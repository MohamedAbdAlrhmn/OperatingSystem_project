
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
  80003e:	e8 4a 1a 00 00       	call   801a8d <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 00 36 80 00       	push   $0x803600
  800050:	e8 d2 18 00 00       	call   801927 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 04 36 80 00       	push   $0x803604
  800062:	e8 c0 18 00 00       	call   801927 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 0c 36 80 00       	push   $0x80360c
  800088:	e8 ab 19 00 00       	call   801a38 <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 0c 36 80 00       	push   $0x80360c
  8000b1:	e8 82 19 00 00       	call   801a38 <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 0c 36 80 00       	push   $0x80360c
  8000da:	e8 59 19 00 00       	call   801a38 <sys_create_env>
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
  8000fa:	68 19 36 80 00       	push   $0x803619
  8000ff:	6a 13                	push   $0x13
  800101:	68 30 36 80 00       	push   $0x803630
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 40 19 00 00       	call   801a56 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 32 19 00 00       	call   801a56 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 24 19 00 00       	call   801a56 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 04 36 80 00       	push   $0x803604
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 1b 18 00 00       	call   801960 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 04 36 80 00       	push   $0x803604
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 08 18 00 00       	call   801960 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 04 36 80 00       	push   $0x803604
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 f5 17 00 00       	call   801960 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 00 36 80 00       	push   $0x803600
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 c5 17 00 00       	call   801943 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 04 36 80 00       	push   $0x803604
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 af 17 00 00       	call   801943 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 50 36 80 00       	push   $0x803650
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 98 36 80 00       	push   $0x803698
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 f2 18 00 00       	call   801abf <sys_getparentenvid>
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
  8001e0:	68 e3 36 80 00       	push   $0x8036e3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 35 14 00 00       	call   801622 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 74 18 00 00       	call   801a72 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 66 18 00 00       	call   801a72 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 58 18 00 00       	call   801a72 <sys_destroy_env>
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
  800234:	e8 6d 18 00 00       	call   801aa6 <sys_getenvindex>
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
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 0f 16 00 00       	call   8018b3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 0c 37 80 00       	push   $0x80370c
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 34 37 80 00       	push   $0x803734
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 5c 37 80 00       	push   $0x80375c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 b4 37 80 00       	push   $0x8037b4
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 0c 37 80 00       	push   $0x80370c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 8f 15 00 00       	call   8018cd <sys_enable_interrupt>

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
  800351:	e8 1c 17 00 00       	call   801a72 <sys_destroy_env>
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
  800362:	e8 71 17 00 00       	call   801ad8 <sys_exit_env>
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
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 c8 37 80 00       	push   $0x8037c8
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 cd 37 80 00       	push   $0x8037cd
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
  8003c8:	68 e9 37 80 00       	push   $0x8037e9
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
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 ec 37 80 00       	push   $0x8037ec
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 38 38 80 00       	push   $0x803838
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
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8004c6:	68 44 38 80 00       	push   $0x803844
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 38 38 80 00       	push   $0x803838
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
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800536:	68 98 38 80 00       	push   $0x803898
  80053b:	6a 44                	push   $0x44
  80053d:	68 38 38 80 00       	push   $0x803838
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
  800575:	a0 24 40 80 00       	mov    0x804024,%al
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
  800590:	e8 70 11 00 00       	call   801705 <sys_cputs>
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
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 f9 10 00 00       	call   801705 <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
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
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
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
  800651:	e8 5d 12 00 00       	call   8018b3 <sys_disable_interrupt>
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
  800671:	e8 57 12 00 00       	call   8018cd <sys_enable_interrupt>
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
  8006bb:	e8 c8 2c 00 00       	call   803388 <__udivdi3>
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
  80070b:	e8 88 2d 00 00       	call   803498 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 14 3b 80 00       	add    $0x803b14,%eax
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
  800866:	8b 04 85 38 3b 80 00 	mov    0x803b38(,%eax,4),%eax
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
  800947:	8b 34 9d 80 39 80 00 	mov    0x803980(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 25 3b 80 00       	push   $0x803b25
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
  80096c:	68 2e 3b 80 00       	push   $0x803b2e
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
  800999:	be 31 3b 80 00       	mov    $0x803b31,%esi
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
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 90 3c 80 00       	push   $0x803c90
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
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
  8013df:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013e6:	00 00 00 
  8013e9:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f0:	00 00 00 
  8013f3:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fa:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013fd:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801404:	00 00 00 
  801407:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80140e:	00 00 00 
  801411:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
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
  801436:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80143b:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801442:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801445:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80144c:	a1 20 41 80 00       	mov    0x804120,%eax
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801472:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801481:	2d 00 10 00 00       	sub    $0x1000,%eax
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 03                	push   $0x3
  80148b:	ff 75 f4             	pushl  -0xc(%ebp)
  80148e:	50                   	push   %eax
  80148f:	e8 b5 03 00 00       	call   801849 <sys_allocate_chunk>
  801494:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801497:	a1 20 41 80 00       	mov    0x804120,%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	50                   	push   %eax
  8014a0:	e8 2a 0a 00 00       	call   801ecf <initialize_MemBlocksList>
  8014a5:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014a8:	a1 48 41 80 00       	mov    0x804148,%eax
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
  8014cd:	68 b5 3c 80 00       	push   $0x803cb5
  8014d2:	6a 33                	push   $0x33
  8014d4:	68 d3 3c 80 00       	push   $0x803cd3
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
  8014fd:	a3 4c 41 80 00       	mov    %eax,0x80414c
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
  801520:	a3 48 41 80 00       	mov    %eax,0x804148
  801525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80152e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801531:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801538:	a1 54 41 80 00       	mov    0x804154,%eax
  80153d:	48                   	dec    %eax
  80153e:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801543:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801547:	75 14                	jne    80155d <initialize_dyn_block_system+0x184>
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 e0 3c 80 00       	push   $0x803ce0
  801551:	6a 34                	push   $0x34
  801553:	68 d3 3c 80 00       	push   $0x803cd3
  801558:	e8 0d ee ff ff       	call   80036a <_panic>
  80155d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801566:	89 10                	mov    %edx,(%eax)
  801568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 0d                	je     80157e <initialize_dyn_block_system+0x1a5>
  801571:	a1 38 41 80 00       	mov    0x804138,%eax
  801576:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801579:	89 50 04             	mov    %edx,0x4(%eax)
  80157c:	eb 08                	jmp    801586 <initialize_dyn_block_system+0x1ad>
  80157e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801581:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801586:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801589:	a3 38 41 80 00       	mov    %eax,0x804138
  80158e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801591:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801598:	a1 44 41 80 00       	mov    0x804144,%eax
  80159d:	40                   	inc    %eax
  80159e:	a3 44 41 80 00       	mov    %eax,0x804144
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
  8015c1:	68 04 3d 80 00       	push   $0x803d04
  8015c6:	6a 46                	push   $0x46
  8015c8:	68 d3 3c 80 00       	push   $0x803cd3
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
  8015dd:	68 2c 3d 80 00       	push   $0x803d2c
  8015e2:	6a 61                	push   $0x61
  8015e4:	68 d3 3c 80 00       	push   $0x803cd3
  8015e9:	e8 7c ed ff ff       	call   80036a <_panic>

008015ee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 18             	sub    $0x18,%esp
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fa:	e8 a9 fd ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801603:	75 07                	jne    80160c <smalloc+0x1e>
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	eb 14                	jmp    801620 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 50 3d 80 00       	push   $0x803d50
  801614:	6a 76                	push   $0x76
  801616:	68 d3 3c 80 00       	push   $0x803cd3
  80161b:	e8 4a ed ff ff       	call   80036a <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801628:	e8 7b fd ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80162d:	83 ec 04             	sub    $0x4,%esp
  801630:	68 78 3d 80 00       	push   $0x803d78
  801635:	68 93 00 00 00       	push   $0x93
  80163a:	68 d3 3c 80 00       	push   $0x803cd3
  80163f:	e8 26 ed ff ff       	call   80036a <_panic>

00801644 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164a:	e8 59 fd ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	68 9c 3d 80 00       	push   $0x803d9c
  801657:	68 c5 00 00 00       	push   $0xc5
  80165c:	68 d3 3c 80 00       	push   $0x803cd3
  801661:	e8 04 ed ff ff       	call   80036a <_panic>

00801666 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80166c:	83 ec 04             	sub    $0x4,%esp
  80166f:	68 c4 3d 80 00       	push   $0x803dc4
  801674:	68 d9 00 00 00       	push   $0xd9
  801679:	68 d3 3c 80 00       	push   $0x803cd3
  80167e:	e8 e7 ec ff ff       	call   80036a <_panic>

00801683 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801689:	83 ec 04             	sub    $0x4,%esp
  80168c:	68 e8 3d 80 00       	push   $0x803de8
  801691:	68 e4 00 00 00       	push   $0xe4
  801696:	68 d3 3c 80 00       	push   $0x803cd3
  80169b:	e8 ca ec ff ff       	call   80036a <_panic>

008016a0 <shrink>:

}
void shrink(uint32 newSize)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016a6:	83 ec 04             	sub    $0x4,%esp
  8016a9:	68 e8 3d 80 00       	push   $0x803de8
  8016ae:	68 e9 00 00 00       	push   $0xe9
  8016b3:	68 d3 3c 80 00       	push   $0x803cd3
  8016b8:	e8 ad ec ff ff       	call   80036a <_panic>

008016bd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c3:	83 ec 04             	sub    $0x4,%esp
  8016c6:	68 e8 3d 80 00       	push   $0x803de8
  8016cb:	68 ee 00 00 00       	push   $0xee
  8016d0:	68 d3 3c 80 00       	push   $0x803cd3
  8016d5:	e8 90 ec ff ff       	call   80036a <_panic>

008016da <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	57                   	push   %edi
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ef:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016f2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016f5:	cd 30                	int    $0x30
  8016f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	5b                   	pop    %ebx
  801701:	5e                   	pop    %esi
  801702:	5f                   	pop    %edi
  801703:	5d                   	pop    %ebp
  801704:	c3                   	ret    

00801705 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	8b 45 10             	mov    0x10(%ebp),%eax
  80170e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801711:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	52                   	push   %edx
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	50                   	push   %eax
  801721:	6a 00                	push   $0x0
  801723:	e8 b2 ff ff ff       	call   8016da <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_cgetc>:

int
sys_cgetc(void)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 01                	push   $0x1
  80173d:	e8 98 ff ff ff       	call   8016da <syscall>
  801742:	83 c4 18             	add    $0x18,%esp
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80174a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	52                   	push   %edx
  801757:	50                   	push   %eax
  801758:	6a 05                	push   $0x5
  80175a:	e8 7b ff ff ff       	call   8016da <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	56                   	push   %esi
  801768:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801769:	8b 75 18             	mov    0x18(%ebp),%esi
  80176c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80176f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801772:	8b 55 0c             	mov    0xc(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	56                   	push   %esi
  801779:	53                   	push   %ebx
  80177a:	51                   	push   %ecx
  80177b:	52                   	push   %edx
  80177c:	50                   	push   %eax
  80177d:	6a 06                	push   $0x6
  80177f:	e8 56 ff ff ff       	call   8016da <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178a:	5b                   	pop    %ebx
  80178b:	5e                   	pop    %esi
  80178c:	5d                   	pop    %ebp
  80178d:	c3                   	ret    

0080178e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801791:	8b 55 0c             	mov    0xc(%ebp),%edx
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	52                   	push   %edx
  80179e:	50                   	push   %eax
  80179f:	6a 07                	push   $0x7
  8017a1:	e8 34 ff ff ff       	call   8016da <syscall>
  8017a6:	83 c4 18             	add    $0x18,%esp
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	6a 08                	push   $0x8
  8017bc:	e8 19 ff ff ff       	call   8016da <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 09                	push   $0x9
  8017d5:	e8 00 ff ff ff       	call   8016da <syscall>
  8017da:	83 c4 18             	add    $0x18,%esp
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 0a                	push   $0xa
  8017ee:	e8 e7 fe ff ff       	call   8016da <syscall>
  8017f3:	83 c4 18             	add    $0x18,%esp
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 0b                	push   $0xb
  801807:	e8 ce fe ff ff       	call   8016da <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	ff 75 0c             	pushl  0xc(%ebp)
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	6a 0f                	push   $0xf
  801822:	e8 b3 fe ff ff       	call   8016da <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
	return;
  80182a:	90                   	nop
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	ff 75 08             	pushl  0x8(%ebp)
  80183c:	6a 10                	push   $0x10
  80183e:	e8 97 fe ff ff       	call   8016da <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
	return ;
  801846:	90                   	nop
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	ff 75 10             	pushl  0x10(%ebp)
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 11                	push   $0x11
  80185b:	e8 7a fe ff ff       	call   8016da <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return ;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 0c                	push   $0xc
  801875:	e8 60 fe ff ff       	call   8016da <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	ff 75 08             	pushl  0x8(%ebp)
  80188d:	6a 0d                	push   $0xd
  80188f:	e8 46 fe ff ff       	call   8016da <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 0e                	push   $0xe
  8018a8:	e8 2d fe ff ff       	call   8016da <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 13                	push   $0x13
  8018c2:	e8 13 fe ff ff       	call   8016da <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 14                	push   $0x14
  8018dc:	e8 f9 fd ff ff       	call   8016da <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018f3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	50                   	push   %eax
  801900:	6a 15                	push   $0x15
  801902:	e8 d3 fd ff ff       	call   8016da <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	90                   	nop
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 16                	push   $0x16
  80191c:	e8 b9 fd ff ff       	call   8016da <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	50                   	push   %eax
  801937:	6a 17                	push   $0x17
  801939:	e8 9c fd ff ff       	call   8016da <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 1a                	push   $0x1a
  801956:	e8 7f fd ff ff       	call   8016da <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	52                   	push   %edx
  801970:	50                   	push   %eax
  801971:	6a 18                	push   $0x18
  801973:	e8 62 fd ff ff       	call   8016da <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	90                   	nop
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801981:	8b 55 0c             	mov    0xc(%ebp),%edx
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	52                   	push   %edx
  80198e:	50                   	push   %eax
  80198f:	6a 19                	push   $0x19
  801991:	e8 44 fd ff ff       	call   8016da <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019a8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019ab:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	51                   	push   %ecx
  8019b5:	52                   	push   %edx
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	50                   	push   %eax
  8019ba:	6a 1b                	push   $0x1b
  8019bc:	e8 19 fd ff ff       	call   8016da <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	52                   	push   %edx
  8019d6:	50                   	push   %eax
  8019d7:	6a 1c                	push   $0x1c
  8019d9:	e8 fc fc ff ff       	call   8016da <syscall>
  8019de:	83 c4 18             	add    $0x18,%esp
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	51                   	push   %ecx
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 1d                	push   $0x1d
  8019f8:	e8 dd fc ff ff       	call   8016da <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 1e                	push   $0x1e
  801a15:	e8 c0 fc ff ff       	call   8016da <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 1f                	push   $0x1f
  801a2e:	e8 a7 fc ff ff       	call   8016da <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	ff 75 14             	pushl  0x14(%ebp)
  801a43:	ff 75 10             	pushl  0x10(%ebp)
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	6a 20                	push   $0x20
  801a4c:	e8 89 fc ff ff       	call   8016da <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	50                   	push   %eax
  801a65:	6a 21                	push   $0x21
  801a67:	e8 6e fc ff ff       	call   8016da <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	50                   	push   %eax
  801a81:	6a 22                	push   $0x22
  801a83:	e8 52 fc ff ff       	call   8016da <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 02                	push   $0x2
  801a9c:	e8 39 fc ff ff       	call   8016da <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 03                	push   $0x3
  801ab5:	e8 20 fc ff ff       	call   8016da <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 04                	push   $0x4
  801ace:	e8 07 fc ff ff       	call   8016da <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_exit_env>:


void sys_exit_env(void)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 23                	push   $0x23
  801ae7:	e8 ee fb ff ff       	call   8016da <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801af8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801afb:	8d 50 04             	lea    0x4(%eax),%edx
  801afe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 24                	push   $0x24
  801b0b:	e8 ca fb ff ff       	call   8016da <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
	return result;
  801b13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b19:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b1c:	89 01                	mov    %eax,(%ecx)
  801b1e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	c9                   	leave  
  801b25:	c2 04 00             	ret    $0x4

00801b28 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	ff 75 10             	pushl  0x10(%ebp)
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	ff 75 08             	pushl  0x8(%ebp)
  801b38:	6a 12                	push   $0x12
  801b3a:	e8 9b fb ff ff       	call   8016da <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b42:	90                   	nop
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 25                	push   $0x25
  801b54:	e8 81 fb ff ff       	call   8016da <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b6a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	50                   	push   %eax
  801b77:	6a 26                	push   $0x26
  801b79:	e8 5c fb ff ff       	call   8016da <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <rsttst>:
void rsttst()
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 28                	push   $0x28
  801b93:	e8 42 fb ff ff       	call   8016da <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9b:	90                   	nop
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 04             	sub    $0x4,%esp
  801ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801baa:	8b 55 18             	mov    0x18(%ebp),%edx
  801bad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb1:	52                   	push   %edx
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 10             	pushl  0x10(%ebp)
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	ff 75 08             	pushl  0x8(%ebp)
  801bbc:	6a 27                	push   $0x27
  801bbe:	e8 17 fb ff ff       	call   8016da <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc6:	90                   	nop
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <chktst>:
void chktst(uint32 n)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	6a 29                	push   $0x29
  801bd9:	e8 fc fa ff ff       	call   8016da <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
	return ;
  801be1:	90                   	nop
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <inctst>:

void inctst()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 2a                	push   $0x2a
  801bf3:	e8 e2 fa ff ff       	call   8016da <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <gettst>:
uint32 gettst()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 2b                	push   $0x2b
  801c0d:	e8 c8 fa ff ff       	call   8016da <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 2c                	push   $0x2c
  801c29:	e8 ac fa ff ff       	call   8016da <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
  801c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c34:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c38:	75 07                	jne    801c41 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3f:	eb 05                	jmp    801c46 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 2c                	push   $0x2c
  801c5a:	e8 7b fa ff ff       	call   8016da <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
  801c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c65:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c69:	75 07                	jne    801c72 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c70:	eb 05                	jmp    801c77 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 2c                	push   $0x2c
  801c8b:	e8 4a fa ff ff       	call   8016da <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
  801c93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c96:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c9a:	75 07                	jne    801ca3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca1:	eb 05                	jmp    801ca8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 2c                	push   $0x2c
  801cbc:	e8 19 fa ff ff       	call   8016da <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
  801cc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cc7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ccb:	75 07                	jne    801cd4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ccd:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd2:	eb 05                	jmp    801cd9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	6a 2d                	push   $0x2d
  801ceb:	e8 ea f9 ff ff       	call   8016da <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cfa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	6a 00                	push   $0x0
  801d08:	53                   	push   %ebx
  801d09:	51                   	push   %ecx
  801d0a:	52                   	push   %edx
  801d0b:	50                   	push   %eax
  801d0c:	6a 2e                	push   $0x2e
  801d0e:	e8 c7 f9 ff ff       	call   8016da <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	52                   	push   %edx
  801d2b:	50                   	push   %eax
  801d2c:	6a 2f                	push   $0x2f
  801d2e:	e8 a7 f9 ff ff       	call   8016da <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d3e:	83 ec 0c             	sub    $0xc,%esp
  801d41:	68 f8 3d 80 00       	push   $0x803df8
  801d46:	e8 d3 e8 ff ff       	call   80061e <cprintf>
  801d4b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d55:	83 ec 0c             	sub    $0xc,%esp
  801d58:	68 24 3e 80 00       	push   $0x803e24
  801d5d:	e8 bc e8 ff ff       	call   80061e <cprintf>
  801d62:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d65:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d69:	a1 38 41 80 00       	mov    0x804138,%eax
  801d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d71:	eb 56                	jmp    801dc9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d77:	74 1c                	je     801d95 <print_mem_block_lists+0x5d>
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	8b 50 08             	mov    0x8(%eax),%edx
  801d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d82:	8b 48 08             	mov    0x8(%eax),%ecx
  801d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d88:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8b:	01 c8                	add    %ecx,%eax
  801d8d:	39 c2                	cmp    %eax,%edx
  801d8f:	73 04                	jae    801d95 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d91:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	8b 50 08             	mov    0x8(%eax),%edx
  801d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801da1:	01 c2                	add    %eax,%edx
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	8b 40 08             	mov    0x8(%eax),%eax
  801da9:	83 ec 04             	sub    $0x4,%esp
  801dac:	52                   	push   %edx
  801dad:	50                   	push   %eax
  801dae:	68 39 3e 80 00       	push   $0x803e39
  801db3:	e8 66 e8 ff ff       	call   80061e <cprintf>
  801db8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc1:	a1 40 41 80 00       	mov    0x804140,%eax
  801dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dcd:	74 07                	je     801dd6 <print_mem_block_lists+0x9e>
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 00                	mov    (%eax),%eax
  801dd4:	eb 05                	jmp    801ddb <print_mem_block_lists+0xa3>
  801dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddb:	a3 40 41 80 00       	mov    %eax,0x804140
  801de0:	a1 40 41 80 00       	mov    0x804140,%eax
  801de5:	85 c0                	test   %eax,%eax
  801de7:	75 8a                	jne    801d73 <print_mem_block_lists+0x3b>
  801de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ded:	75 84                	jne    801d73 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801def:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801df3:	75 10                	jne    801e05 <print_mem_block_lists+0xcd>
  801df5:	83 ec 0c             	sub    $0xc,%esp
  801df8:	68 48 3e 80 00       	push   $0x803e48
  801dfd:	e8 1c e8 ff ff       	call   80061e <cprintf>
  801e02:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	68 6c 3e 80 00       	push   $0x803e6c
  801e14:	e8 05 e8 ff ff       	call   80061e <cprintf>
  801e19:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e1c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e20:	a1 40 40 80 00       	mov    0x804040,%eax
  801e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e28:	eb 56                	jmp    801e80 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2e:	74 1c                	je     801e4c <print_mem_block_lists+0x114>
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 50 08             	mov    0x8(%eax),%edx
  801e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e39:	8b 48 08             	mov    0x8(%eax),%ecx
  801e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e42:	01 c8                	add    %ecx,%eax
  801e44:	39 c2                	cmp    %eax,%edx
  801e46:	73 04                	jae    801e4c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e48:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	8b 50 08             	mov    0x8(%eax),%edx
  801e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e55:	8b 40 0c             	mov    0xc(%eax),%eax
  801e58:	01 c2                	add    %eax,%edx
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 40 08             	mov    0x8(%eax),%eax
  801e60:	83 ec 04             	sub    $0x4,%esp
  801e63:	52                   	push   %edx
  801e64:	50                   	push   %eax
  801e65:	68 39 3e 80 00       	push   $0x803e39
  801e6a:	e8 af e7 ff ff       	call   80061e <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e78:	a1 48 40 80 00       	mov    0x804048,%eax
  801e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e84:	74 07                	je     801e8d <print_mem_block_lists+0x155>
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	8b 00                	mov    (%eax),%eax
  801e8b:	eb 05                	jmp    801e92 <print_mem_block_lists+0x15a>
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	a3 48 40 80 00       	mov    %eax,0x804048
  801e97:	a1 48 40 80 00       	mov    0x804048,%eax
  801e9c:	85 c0                	test   %eax,%eax
  801e9e:	75 8a                	jne    801e2a <print_mem_block_lists+0xf2>
  801ea0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea4:	75 84                	jne    801e2a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ea6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eaa:	75 10                	jne    801ebc <print_mem_block_lists+0x184>
  801eac:	83 ec 0c             	sub    $0xc,%esp
  801eaf:	68 84 3e 80 00       	push   $0x803e84
  801eb4:	e8 65 e7 ff ff       	call   80061e <cprintf>
  801eb9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	68 f8 3d 80 00       	push   $0x803df8
  801ec4:	e8 55 e7 ff ff       	call   80061e <cprintf>
  801ec9:	83 c4 10             	add    $0x10,%esp

}
  801ecc:	90                   	nop
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ed5:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801edc:	00 00 00 
  801edf:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ee6:	00 00 00 
  801ee9:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ef0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ef3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801efa:	e9 9e 00 00 00       	jmp    801f9d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eff:	a1 50 40 80 00       	mov    0x804050,%eax
  801f04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f07:	c1 e2 04             	shl    $0x4,%edx
  801f0a:	01 d0                	add    %edx,%eax
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	75 14                	jne    801f24 <initialize_MemBlocksList+0x55>
  801f10:	83 ec 04             	sub    $0x4,%esp
  801f13:	68 ac 3e 80 00       	push   $0x803eac
  801f18:	6a 46                	push   $0x46
  801f1a:	68 cf 3e 80 00       	push   $0x803ecf
  801f1f:	e8 46 e4 ff ff       	call   80036a <_panic>
  801f24:	a1 50 40 80 00       	mov    0x804050,%eax
  801f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2c:	c1 e2 04             	shl    $0x4,%edx
  801f2f:	01 d0                	add    %edx,%eax
  801f31:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f37:	89 10                	mov    %edx,(%eax)
  801f39:	8b 00                	mov    (%eax),%eax
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	74 18                	je     801f57 <initialize_MemBlocksList+0x88>
  801f3f:	a1 48 41 80 00       	mov    0x804148,%eax
  801f44:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f4a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f4d:	c1 e1 04             	shl    $0x4,%ecx
  801f50:	01 ca                	add    %ecx,%edx
  801f52:	89 50 04             	mov    %edx,0x4(%eax)
  801f55:	eb 12                	jmp    801f69 <initialize_MemBlocksList+0x9a>
  801f57:	a1 50 40 80 00       	mov    0x804050,%eax
  801f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5f:	c1 e2 04             	shl    $0x4,%edx
  801f62:	01 d0                	add    %edx,%eax
  801f64:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f69:	a1 50 40 80 00       	mov    0x804050,%eax
  801f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f71:	c1 e2 04             	shl    $0x4,%edx
  801f74:	01 d0                	add    %edx,%eax
  801f76:	a3 48 41 80 00       	mov    %eax,0x804148
  801f7b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f83:	c1 e2 04             	shl    $0x4,%edx
  801f86:	01 d0                	add    %edx,%eax
  801f88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f8f:	a1 54 41 80 00       	mov    0x804154,%eax
  801f94:	40                   	inc    %eax
  801f95:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f9a:	ff 45 f4             	incl   -0xc(%ebp)
  801f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fa3:	0f 82 56 ff ff ff    	jb     801eff <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fa9:	90                   	nop
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	8b 00                	mov    (%eax),%eax
  801fb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fba:	eb 19                	jmp    801fd5 <find_block+0x29>
	{
		if(va==point->sva)
  801fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbf:	8b 40 08             	mov    0x8(%eax),%eax
  801fc2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fc5:	75 05                	jne    801fcc <find_block+0x20>
		   return point;
  801fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fca:	eb 36                	jmp    802002 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	8b 40 08             	mov    0x8(%eax),%eax
  801fd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fd5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fd9:	74 07                	je     801fe2 <find_block+0x36>
  801fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fde:	8b 00                	mov    (%eax),%eax
  801fe0:	eb 05                	jmp    801fe7 <find_block+0x3b>
  801fe2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fea:	89 42 08             	mov    %eax,0x8(%edx)
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	8b 40 08             	mov    0x8(%eax),%eax
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	75 c5                	jne    801fbc <find_block+0x10>
  801ff7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ffb:	75 bf                	jne    801fbc <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80200a:	a1 40 40 80 00       	mov    0x804040,%eax
  80200f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802012:	a1 44 40 80 00       	mov    0x804044,%eax
  802017:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802020:	74 24                	je     802046 <insert_sorted_allocList+0x42>
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	8b 50 08             	mov    0x8(%eax),%edx
  802028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202b:	8b 40 08             	mov    0x8(%eax),%eax
  80202e:	39 c2                	cmp    %eax,%edx
  802030:	76 14                	jbe    802046 <insert_sorted_allocList+0x42>
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	8b 50 08             	mov    0x8(%eax),%edx
  802038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203b:	8b 40 08             	mov    0x8(%eax),%eax
  80203e:	39 c2                	cmp    %eax,%edx
  802040:	0f 82 60 01 00 00    	jb     8021a6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80204a:	75 65                	jne    8020b1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80204c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802050:	75 14                	jne    802066 <insert_sorted_allocList+0x62>
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	68 ac 3e 80 00       	push   $0x803eac
  80205a:	6a 6b                	push   $0x6b
  80205c:	68 cf 3e 80 00       	push   $0x803ecf
  802061:	e8 04 e3 ff ff       	call   80036a <_panic>
  802066:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	89 10                	mov    %edx,(%eax)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	8b 00                	mov    (%eax),%eax
  802076:	85 c0                	test   %eax,%eax
  802078:	74 0d                	je     802087 <insert_sorted_allocList+0x83>
  80207a:	a1 40 40 80 00       	mov    0x804040,%eax
  80207f:	8b 55 08             	mov    0x8(%ebp),%edx
  802082:	89 50 04             	mov    %edx,0x4(%eax)
  802085:	eb 08                	jmp    80208f <insert_sorted_allocList+0x8b>
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	a3 44 40 80 00       	mov    %eax,0x804044
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	a3 40 40 80 00       	mov    %eax,0x804040
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a6:	40                   	inc    %eax
  8020a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ac:	e9 dc 01 00 00       	jmp    80228d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	8b 50 08             	mov    0x8(%eax),%edx
  8020b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ba:	8b 40 08             	mov    0x8(%eax),%eax
  8020bd:	39 c2                	cmp    %eax,%edx
  8020bf:	77 6c                	ja     80212d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c5:	74 06                	je     8020cd <insert_sorted_allocList+0xc9>
  8020c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020cb:	75 14                	jne    8020e1 <insert_sorted_allocList+0xdd>
  8020cd:	83 ec 04             	sub    $0x4,%esp
  8020d0:	68 e8 3e 80 00       	push   $0x803ee8
  8020d5:	6a 6f                	push   $0x6f
  8020d7:	68 cf 3e 80 00       	push   $0x803ecf
  8020dc:	e8 89 e2 ff ff       	call   80036a <_panic>
  8020e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e4:	8b 50 04             	mov    0x4(%eax),%edx
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	89 50 04             	mov    %edx,0x4(%eax)
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f3:	89 10                	mov    %edx,(%eax)
  8020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f8:	8b 40 04             	mov    0x4(%eax),%eax
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	74 0d                	je     80210c <insert_sorted_allocList+0x108>
  8020ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802102:	8b 40 04             	mov    0x4(%eax),%eax
  802105:	8b 55 08             	mov    0x8(%ebp),%edx
  802108:	89 10                	mov    %edx,(%eax)
  80210a:	eb 08                	jmp    802114 <insert_sorted_allocList+0x110>
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	a3 40 40 80 00       	mov    %eax,0x804040
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	8b 55 08             	mov    0x8(%ebp),%edx
  80211a:	89 50 04             	mov    %edx,0x4(%eax)
  80211d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802122:	40                   	inc    %eax
  802123:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802128:	e9 60 01 00 00       	jmp    80228d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	8b 50 08             	mov    0x8(%eax),%edx
  802133:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802136:	8b 40 08             	mov    0x8(%eax),%eax
  802139:	39 c2                	cmp    %eax,%edx
  80213b:	0f 82 4c 01 00 00    	jb     80228d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802141:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802145:	75 14                	jne    80215b <insert_sorted_allocList+0x157>
  802147:	83 ec 04             	sub    $0x4,%esp
  80214a:	68 20 3f 80 00       	push   $0x803f20
  80214f:	6a 73                	push   $0x73
  802151:	68 cf 3e 80 00       	push   $0x803ecf
  802156:	e8 0f e2 ff ff       	call   80036a <_panic>
  80215b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	89 50 04             	mov    %edx,0x4(%eax)
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	8b 40 04             	mov    0x4(%eax),%eax
  80216d:	85 c0                	test   %eax,%eax
  80216f:	74 0c                	je     80217d <insert_sorted_allocList+0x179>
  802171:	a1 44 40 80 00       	mov    0x804044,%eax
  802176:	8b 55 08             	mov    0x8(%ebp),%edx
  802179:	89 10                	mov    %edx,(%eax)
  80217b:	eb 08                	jmp    802185 <insert_sorted_allocList+0x181>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	a3 40 40 80 00       	mov    %eax,0x804040
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	a3 44 40 80 00       	mov    %eax,0x804044
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802196:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80219b:	40                   	inc    %eax
  80219c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a1:	e9 e7 00 00 00       	jmp    80228d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021ac:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021b3:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bb:	e9 9d 00 00 00       	jmp    80225d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 40 08             	mov    0x8(%eax),%eax
  8021d4:	39 c2                	cmp    %eax,%edx
  8021d6:	76 7d                	jbe    802255 <insert_sorted_allocList+0x251>
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	8b 50 08             	mov    0x8(%eax),%edx
  8021de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e1:	8b 40 08             	mov    0x8(%eax),%eax
  8021e4:	39 c2                	cmp    %eax,%edx
  8021e6:	73 6d                	jae    802255 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ec:	74 06                	je     8021f4 <insert_sorted_allocList+0x1f0>
  8021ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f2:	75 14                	jne    802208 <insert_sorted_allocList+0x204>
  8021f4:	83 ec 04             	sub    $0x4,%esp
  8021f7:	68 44 3f 80 00       	push   $0x803f44
  8021fc:	6a 7f                	push   $0x7f
  8021fe:	68 cf 3e 80 00       	push   $0x803ecf
  802203:	e8 62 e1 ff ff       	call   80036a <_panic>
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 10                	mov    (%eax),%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	89 10                	mov    %edx,(%eax)
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	85 c0                	test   %eax,%eax
  802219:	74 0b                	je     802226 <insert_sorted_allocList+0x222>
  80221b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221e:	8b 00                	mov    (%eax),%eax
  802220:	8b 55 08             	mov    0x8(%ebp),%edx
  802223:	89 50 04             	mov    %edx,0x4(%eax)
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 55 08             	mov    0x8(%ebp),%edx
  80222c:	89 10                	mov    %edx,(%eax)
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802234:	89 50 04             	mov    %edx,0x4(%eax)
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	8b 00                	mov    (%eax),%eax
  80223c:	85 c0                	test   %eax,%eax
  80223e:	75 08                	jne    802248 <insert_sorted_allocList+0x244>
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 44 40 80 00       	mov    %eax,0x804044
  802248:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80224d:	40                   	inc    %eax
  80224e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802253:	eb 39                	jmp    80228e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802255:	a1 48 40 80 00       	mov    0x804048,%eax
  80225a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802261:	74 07                	je     80226a <insert_sorted_allocList+0x266>
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	8b 00                	mov    (%eax),%eax
  802268:	eb 05                	jmp    80226f <insert_sorted_allocList+0x26b>
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
  80226f:	a3 48 40 80 00       	mov    %eax,0x804048
  802274:	a1 48 40 80 00       	mov    0x804048,%eax
  802279:	85 c0                	test   %eax,%eax
  80227b:	0f 85 3f ff ff ff    	jne    8021c0 <insert_sorted_allocList+0x1bc>
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	0f 85 35 ff ff ff    	jne    8021c0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80228b:	eb 01                	jmp    80228e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80228e:	90                   	nop
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802297:	a1 38 41 80 00       	mov    0x804138,%eax
  80229c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229f:	e9 85 01 00 00       	jmp    802429 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ad:	0f 82 6e 01 00 00    	jb     802421 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bc:	0f 85 8a 00 00 00    	jne    80234c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c6:	75 17                	jne    8022df <alloc_block_FF+0x4e>
  8022c8:	83 ec 04             	sub    $0x4,%esp
  8022cb:	68 78 3f 80 00       	push   $0x803f78
  8022d0:	68 93 00 00 00       	push   $0x93
  8022d5:	68 cf 3e 80 00       	push   $0x803ecf
  8022da:	e8 8b e0 ff ff       	call   80036a <_panic>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	74 10                	je     8022f8 <alloc_block_FF+0x67>
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f0:	8b 52 04             	mov    0x4(%edx),%edx
  8022f3:	89 50 04             	mov    %edx,0x4(%eax)
  8022f6:	eb 0b                	jmp    802303 <alloc_block_FF+0x72>
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 40 04             	mov    0x4(%eax),%eax
  8022fe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 04             	mov    0x4(%eax),%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	74 0f                	je     80231c <alloc_block_FF+0x8b>
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 40 04             	mov    0x4(%eax),%eax
  802313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802316:	8b 12                	mov    (%edx),%edx
  802318:	89 10                	mov    %edx,(%eax)
  80231a:	eb 0a                	jmp    802326 <alloc_block_FF+0x95>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	a3 38 41 80 00       	mov    %eax,0x804138
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802339:	a1 44 41 80 00       	mov    0x804144,%eax
  80233e:	48                   	dec    %eax
  80233f:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	e9 10 01 00 00       	jmp    80245c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 0c             	mov    0xc(%eax),%eax
  802352:	3b 45 08             	cmp    0x8(%ebp),%eax
  802355:	0f 86 c6 00 00 00    	jbe    802421 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80235b:	a1 48 41 80 00       	mov    0x804148,%eax
  802360:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 50 08             	mov    0x8(%eax),%edx
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80236f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802372:	8b 55 08             	mov    0x8(%ebp),%edx
  802375:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802378:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80237c:	75 17                	jne    802395 <alloc_block_FF+0x104>
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	68 78 3f 80 00       	push   $0x803f78
  802386:	68 9b 00 00 00       	push   $0x9b
  80238b:	68 cf 3e 80 00       	push   $0x803ecf
  802390:	e8 d5 df ff ff       	call   80036a <_panic>
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	85 c0                	test   %eax,%eax
  80239c:	74 10                	je     8023ae <alloc_block_FF+0x11d>
  80239e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023a6:	8b 52 04             	mov    0x4(%edx),%edx
  8023a9:	89 50 04             	mov    %edx,0x4(%eax)
  8023ac:	eb 0b                	jmp    8023b9 <alloc_block_FF+0x128>
  8023ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b1:	8b 40 04             	mov    0x4(%eax),%eax
  8023b4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	8b 40 04             	mov    0x4(%eax),%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	74 0f                	je     8023d2 <alloc_block_FF+0x141>
  8023c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c6:	8b 40 04             	mov    0x4(%eax),%eax
  8023c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023cc:	8b 12                	mov    (%edx),%edx
  8023ce:	89 10                	mov    %edx,(%eax)
  8023d0:	eb 0a                	jmp    8023dc <alloc_block_FF+0x14b>
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	8b 00                	mov    (%eax),%eax
  8023d7:	a3 48 41 80 00       	mov    %eax,0x804148
  8023dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8023f4:	48                   	dec    %eax
  8023f5:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 50 08             	mov    0x8(%eax),%edx
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	01 c2                	add    %eax,%edx
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 40 0c             	mov    0xc(%eax),%eax
  802411:	2b 45 08             	sub    0x8(%ebp),%eax
  802414:	89 c2                	mov    %eax,%edx
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	eb 3b                	jmp    80245c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802421:	a1 40 41 80 00       	mov    0x804140,%eax
  802426:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242d:	74 07                	je     802436 <alloc_block_FF+0x1a5>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	eb 05                	jmp    80243b <alloc_block_FF+0x1aa>
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
  80243b:	a3 40 41 80 00       	mov    %eax,0x804140
  802440:	a1 40 41 80 00       	mov    0x804140,%eax
  802445:	85 c0                	test   %eax,%eax
  802447:	0f 85 57 fe ff ff    	jne    8022a4 <alloc_block_FF+0x13>
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	0f 85 4d fe ff ff    	jne    8022a4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802464:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80246b:	a1 38 41 80 00       	mov    0x804138,%eax
  802470:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802473:	e9 df 00 00 00       	jmp    802557 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 0c             	mov    0xc(%eax),%eax
  80247e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802481:	0f 82 c8 00 00 00    	jb     80254f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802490:	0f 85 8a 00 00 00    	jne    802520 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	75 17                	jne    8024b3 <alloc_block_BF+0x55>
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	68 78 3f 80 00       	push   $0x803f78
  8024a4:	68 b7 00 00 00       	push   $0xb7
  8024a9:	68 cf 3e 80 00       	push   $0x803ecf
  8024ae:	e8 b7 de ff ff       	call   80036a <_panic>
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 00                	mov    (%eax),%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 10                	je     8024cc <alloc_block_BF+0x6e>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 00                	mov    (%eax),%eax
  8024c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c4:	8b 52 04             	mov    0x4(%edx),%edx
  8024c7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ca:	eb 0b                	jmp    8024d7 <alloc_block_BF+0x79>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 04             	mov    0x4(%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 0f                	je     8024f0 <alloc_block_BF+0x92>
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	8b 40 04             	mov    0x4(%eax),%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	8b 12                	mov    (%edx),%edx
  8024ec:	89 10                	mov    %edx,(%eax)
  8024ee:	eb 0a                	jmp    8024fa <alloc_block_BF+0x9c>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	a3 38 41 80 00       	mov    %eax,0x804138
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250d:	a1 44 41 80 00       	mov    0x804144,%eax
  802512:	48                   	dec    %eax
  802513:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	e9 4d 01 00 00       	jmp    80266d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 0c             	mov    0xc(%eax),%eax
  802526:	3b 45 08             	cmp    0x8(%ebp),%eax
  802529:	76 24                	jbe    80254f <alloc_block_BF+0xf1>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 0c             	mov    0xc(%eax),%eax
  802531:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802534:	73 19                	jae    80254f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802536:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 0c             	mov    0xc(%eax),%eax
  802543:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 08             	mov    0x8(%eax),%eax
  80254c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80254f:	a1 40 41 80 00       	mov    0x804140,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	74 07                	je     802564 <alloc_block_BF+0x106>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	eb 05                	jmp    802569 <alloc_block_BF+0x10b>
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	a3 40 41 80 00       	mov    %eax,0x804140
  80256e:	a1 40 41 80 00       	mov    0x804140,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 85 fd fe ff ff    	jne    802478 <alloc_block_BF+0x1a>
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	0f 85 f3 fe ff ff    	jne    802478 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802585:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802589:	0f 84 d9 00 00 00    	je     802668 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80258f:	a1 48 41 80 00       	mov    0x804148,%eax
  802594:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025ad:	75 17                	jne    8025c6 <alloc_block_BF+0x168>
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	68 78 3f 80 00       	push   $0x803f78
  8025b7:	68 c7 00 00 00       	push   $0xc7
  8025bc:	68 cf 3e 80 00       	push   $0x803ecf
  8025c1:	e8 a4 dd ff ff       	call   80036a <_panic>
  8025c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 10                	je     8025df <alloc_block_BF+0x181>
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025d7:	8b 52 04             	mov    0x4(%edx),%edx
  8025da:	89 50 04             	mov    %edx,0x4(%eax)
  8025dd:	eb 0b                	jmp    8025ea <alloc_block_BF+0x18c>
  8025df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ed:	8b 40 04             	mov    0x4(%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	74 0f                	je     802603 <alloc_block_BF+0x1a5>
  8025f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f7:	8b 40 04             	mov    0x4(%eax),%eax
  8025fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fd:	8b 12                	mov    (%edx),%edx
  8025ff:	89 10                	mov    %edx,(%eax)
  802601:	eb 0a                	jmp    80260d <alloc_block_BF+0x1af>
  802603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	a3 48 41 80 00       	mov    %eax,0x804148
  80260d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802620:	a1 54 41 80 00       	mov    0x804154,%eax
  802625:	48                   	dec    %eax
  802626:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80262b:	83 ec 08             	sub    $0x8,%esp
  80262e:	ff 75 ec             	pushl  -0x14(%ebp)
  802631:	68 38 41 80 00       	push   $0x804138
  802636:	e8 71 f9 ff ff       	call   801fac <find_block>
  80263b:	83 c4 10             	add    $0x10,%esp
  80263e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802644:	8b 50 08             	mov    0x8(%eax),%edx
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	01 c2                	add    %eax,%edx
  80264c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802655:	8b 40 0c             	mov    0xc(%eax),%eax
  802658:	2b 45 08             	sub    0x8(%ebp),%eax
  80265b:	89 c2                	mov    %eax,%edx
  80265d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802660:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802666:	eb 05                	jmp    80266d <alloc_block_BF+0x20f>
	}
	return NULL;
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802675:	a1 28 40 80 00       	mov    0x804028,%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	0f 85 de 01 00 00    	jne    802860 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802682:	a1 38 41 80 00       	mov    0x804138,%eax
  802687:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268a:	e9 9e 01 00 00       	jmp    80282d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 40 0c             	mov    0xc(%eax),%eax
  802695:	3b 45 08             	cmp    0x8(%ebp),%eax
  802698:	0f 82 87 01 00 00    	jb     802825 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a7:	0f 85 95 00 00 00    	jne    802742 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b1:	75 17                	jne    8026ca <alloc_block_NF+0x5b>
  8026b3:	83 ec 04             	sub    $0x4,%esp
  8026b6:	68 78 3f 80 00       	push   $0x803f78
  8026bb:	68 e0 00 00 00       	push   $0xe0
  8026c0:	68 cf 3e 80 00       	push   $0x803ecf
  8026c5:	e8 a0 dc ff ff       	call   80036a <_panic>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 10                	je     8026e3 <alloc_block_NF+0x74>
  8026d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026db:	8b 52 04             	mov    0x4(%edx),%edx
  8026de:	89 50 04             	mov    %edx,0x4(%eax)
  8026e1:	eb 0b                	jmp    8026ee <alloc_block_NF+0x7f>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 0f                	je     802707 <alloc_block_NF+0x98>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802701:	8b 12                	mov    (%edx),%edx
  802703:	89 10                	mov    %edx,(%eax)
  802705:	eb 0a                	jmp    802711 <alloc_block_NF+0xa2>
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	a3 38 41 80 00       	mov    %eax,0x804138
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802724:	a1 44 41 80 00       	mov    0x804144,%eax
  802729:	48                   	dec    %eax
  80272a:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 40 08             	mov    0x8(%eax),%eax
  802735:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	e9 f8 04 00 00       	jmp    802c3a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274b:	0f 86 d4 00 00 00    	jbe    802825 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802751:	a1 48 41 80 00       	mov    0x804148,%eax
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 50 08             	mov    0x8(%eax),%edx
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802768:	8b 55 08             	mov    0x8(%ebp),%edx
  80276b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80276e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802772:	75 17                	jne    80278b <alloc_block_NF+0x11c>
  802774:	83 ec 04             	sub    $0x4,%esp
  802777:	68 78 3f 80 00       	push   $0x803f78
  80277c:	68 e9 00 00 00       	push   $0xe9
  802781:	68 cf 3e 80 00       	push   $0x803ecf
  802786:	e8 df db ff ff       	call   80036a <_panic>
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	85 c0                	test   %eax,%eax
  802792:	74 10                	je     8027a4 <alloc_block_NF+0x135>
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279c:	8b 52 04             	mov    0x4(%edx),%edx
  80279f:	89 50 04             	mov    %edx,0x4(%eax)
  8027a2:	eb 0b                	jmp    8027af <alloc_block_NF+0x140>
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 0f                	je     8027c8 <alloc_block_NF+0x159>
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c2:	8b 12                	mov    (%edx),%edx
  8027c4:	89 10                	mov    %edx,(%eax)
  8027c6:	eb 0a                	jmp    8027d2 <alloc_block_NF+0x163>
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	8b 00                	mov    (%eax),%eax
  8027cd:	a3 48 41 80 00       	mov    %eax,0x804148
  8027d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ea:	48                   	dec    %eax
  8027eb:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	8b 40 08             	mov    0x8(%eax),%eax
  8027f6:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 50 08             	mov    0x8(%eax),%edx
  802801:	8b 45 08             	mov    0x8(%ebp),%eax
  802804:	01 c2                	add    %eax,%edx
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 40 0c             	mov    0xc(%eax),%eax
  802812:	2b 45 08             	sub    0x8(%ebp),%eax
  802815:	89 c2                	mov    %eax,%edx
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	e9 15 04 00 00       	jmp    802c3a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802825:	a1 40 41 80 00       	mov    0x804140,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <alloc_block_NF+0x1cb>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <alloc_block_NF+0x1d0>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 40 41 80 00       	mov    %eax,0x804140
  802844:	a1 40 41 80 00       	mov    0x804140,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 3e fe ff ff    	jne    80268f <alloc_block_NF+0x20>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 34 fe ff ff    	jne    80268f <alloc_block_NF+0x20>
  80285b:	e9 d5 03 00 00       	jmp    802c35 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802860:	a1 38 41 80 00       	mov    0x804138,%eax
  802865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802868:	e9 b1 01 00 00       	jmp    802a1e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 50 08             	mov    0x8(%eax),%edx
  802873:	a1 28 40 80 00       	mov    0x804028,%eax
  802878:	39 c2                	cmp    %eax,%edx
  80287a:	0f 82 96 01 00 00    	jb     802a16 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 40 0c             	mov    0xc(%eax),%eax
  802886:	3b 45 08             	cmp    0x8(%ebp),%eax
  802889:	0f 82 87 01 00 00    	jb     802a16 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 0c             	mov    0xc(%eax),%eax
  802895:	3b 45 08             	cmp    0x8(%ebp),%eax
  802898:	0f 85 95 00 00 00    	jne    802933 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80289e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a2:	75 17                	jne    8028bb <alloc_block_NF+0x24c>
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	68 78 3f 80 00       	push   $0x803f78
  8028ac:	68 fc 00 00 00       	push   $0xfc
  8028b1:	68 cf 3e 80 00       	push   $0x803ecf
  8028b6:	e8 af da ff ff       	call   80036a <_panic>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 00                	mov    (%eax),%eax
  8028c0:	85 c0                	test   %eax,%eax
  8028c2:	74 10                	je     8028d4 <alloc_block_NF+0x265>
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cc:	8b 52 04             	mov    0x4(%edx),%edx
  8028cf:	89 50 04             	mov    %edx,0x4(%eax)
  8028d2:	eb 0b                	jmp    8028df <alloc_block_NF+0x270>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 40 04             	mov    0x4(%eax),%eax
  8028da:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 40 04             	mov    0x4(%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 0f                	je     8028f8 <alloc_block_NF+0x289>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 40 04             	mov    0x4(%eax),%eax
  8028ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f2:	8b 12                	mov    (%edx),%edx
  8028f4:	89 10                	mov    %edx,(%eax)
  8028f6:	eb 0a                	jmp    802902 <alloc_block_NF+0x293>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	a3 38 41 80 00       	mov    %eax,0x804138
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802915:	a1 44 41 80 00       	mov    0x804144,%eax
  80291a:	48                   	dec    %eax
  80291b:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 08             	mov    0x8(%eax),%eax
  802926:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	e9 07 03 00 00       	jmp    802c3a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 0c             	mov    0xc(%eax),%eax
  802939:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293c:	0f 86 d4 00 00 00    	jbe    802a16 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802942:	a1 48 41 80 00       	mov    0x804148,%eax
  802947:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802959:	8b 55 08             	mov    0x8(%ebp),%edx
  80295c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80295f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802963:	75 17                	jne    80297c <alloc_block_NF+0x30d>
  802965:	83 ec 04             	sub    $0x4,%esp
  802968:	68 78 3f 80 00       	push   $0x803f78
  80296d:	68 04 01 00 00       	push   $0x104
  802972:	68 cf 3e 80 00       	push   $0x803ecf
  802977:	e8 ee d9 ff ff       	call   80036a <_panic>
  80297c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297f:	8b 00                	mov    (%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 10                	je     802995 <alloc_block_NF+0x326>
  802985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298d:	8b 52 04             	mov    0x4(%edx),%edx
  802990:	89 50 04             	mov    %edx,0x4(%eax)
  802993:	eb 0b                	jmp    8029a0 <alloc_block_NF+0x331>
  802995:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802998:	8b 40 04             	mov    0x4(%eax),%eax
  80299b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a3:	8b 40 04             	mov    0x4(%eax),%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	74 0f                	je     8029b9 <alloc_block_NF+0x34a>
  8029aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ad:	8b 40 04             	mov    0x4(%eax),%eax
  8029b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b3:	8b 12                	mov    (%edx),%edx
  8029b5:	89 10                	mov    %edx,(%eax)
  8029b7:	eb 0a                	jmp    8029c3 <alloc_block_NF+0x354>
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	a3 48 41 80 00       	mov    %eax,0x804148
  8029c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8029db:	48                   	dec    %eax
  8029dc:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e4:	8b 40 08             	mov    0x8(%eax),%eax
  8029e7:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 50 08             	mov    0x8(%eax),%edx
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	01 c2                	add    %eax,%edx
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 0c             	mov    0xc(%eax),%eax
  802a03:	2b 45 08             	sub    0x8(%ebp),%eax
  802a06:	89 c2                	mov    %eax,%edx
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a11:	e9 24 02 00 00       	jmp    802c3a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a16:	a1 40 41 80 00       	mov    0x804140,%eax
  802a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a22:	74 07                	je     802a2b <alloc_block_NF+0x3bc>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 00                	mov    (%eax),%eax
  802a29:	eb 05                	jmp    802a30 <alloc_block_NF+0x3c1>
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a30:	a3 40 41 80 00       	mov    %eax,0x804140
  802a35:	a1 40 41 80 00       	mov    0x804140,%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	0f 85 2b fe ff ff    	jne    80286d <alloc_block_NF+0x1fe>
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a46:	0f 85 21 fe ff ff    	jne    80286d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a4c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a54:	e9 ae 01 00 00       	jmp    802c07 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 50 08             	mov    0x8(%eax),%edx
  802a5f:	a1 28 40 80 00       	mov    0x804028,%eax
  802a64:	39 c2                	cmp    %eax,%edx
  802a66:	0f 83 93 01 00 00    	jae    802bff <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a72:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a75:	0f 82 84 01 00 00    	jb     802bff <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a84:	0f 85 95 00 00 00    	jne    802b1f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8e:	75 17                	jne    802aa7 <alloc_block_NF+0x438>
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	68 78 3f 80 00       	push   $0x803f78
  802a98:	68 14 01 00 00       	push   $0x114
  802a9d:	68 cf 3e 80 00       	push   $0x803ecf
  802aa2:	e8 c3 d8 ff ff       	call   80036a <_panic>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 10                	je     802ac0 <alloc_block_NF+0x451>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab8:	8b 52 04             	mov    0x4(%edx),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 0b                	jmp    802acb <alloc_block_NF+0x45c>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0f                	je     802ae4 <alloc_block_NF+0x475>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	8b 12                	mov    (%edx),%edx
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	eb 0a                	jmp    802aee <alloc_block_NF+0x47f>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	a3 38 41 80 00       	mov    %eax,0x804138
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b01:	a1 44 41 80 00       	mov    0x804144,%eax
  802b06:	48                   	dec    %eax
  802b07:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 40 08             	mov    0x8(%eax),%eax
  802b12:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	e9 1b 01 00 00       	jmp    802c3a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 0c             	mov    0xc(%eax),%eax
  802b25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b28:	0f 86 d1 00 00 00    	jbe    802bff <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802b33:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 50 08             	mov    0x8(%eax),%edx
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b45:	8b 55 08             	mov    0x8(%ebp),%edx
  802b48:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b4f:	75 17                	jne    802b68 <alloc_block_NF+0x4f9>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 78 3f 80 00       	push   $0x803f78
  802b59:	68 1c 01 00 00       	push   $0x11c
  802b5e:	68 cf 3e 80 00       	push   $0x803ecf
  802b63:	e8 02 d8 ff ff       	call   80036a <_panic>
  802b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	85 c0                	test   %eax,%eax
  802b6f:	74 10                	je     802b81 <alloc_block_NF+0x512>
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b79:	8b 52 04             	mov    0x4(%edx),%edx
  802b7c:	89 50 04             	mov    %edx,0x4(%eax)
  802b7f:	eb 0b                	jmp    802b8c <alloc_block_NF+0x51d>
  802b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b84:	8b 40 04             	mov    0x4(%eax),%eax
  802b87:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8f:	8b 40 04             	mov    0x4(%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 0f                	je     802ba5 <alloc_block_NF+0x536>
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b9f:	8b 12                	mov    (%edx),%edx
  802ba1:	89 10                	mov    %edx,(%eax)
  802ba3:	eb 0a                	jmp    802baf <alloc_block_NF+0x540>
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	a3 48 41 80 00       	mov    %eax,0x804148
  802baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc2:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc7:	48                   	dec    %eax
  802bc8:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
  802bd3:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 50 08             	mov    0x8(%eax),%edx
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	01 c2                	add    %eax,%edx
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf2:	89 c2                	mov    %eax,%edx
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfd:	eb 3b                	jmp    802c3a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bff:	a1 40 41 80 00       	mov    0x804140,%eax
  802c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0b:	74 07                	je     802c14 <alloc_block_NF+0x5a5>
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	eb 05                	jmp    802c19 <alloc_block_NF+0x5aa>
  802c14:	b8 00 00 00 00       	mov    $0x0,%eax
  802c19:	a3 40 41 80 00       	mov    %eax,0x804140
  802c1e:	a1 40 41 80 00       	mov    0x804140,%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	0f 85 2e fe ff ff    	jne    802a59 <alloc_block_NF+0x3ea>
  802c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2f:	0f 85 24 fe ff ff    	jne    802a59 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3a:	c9                   	leave  
  802c3b:	c3                   	ret    

00802c3c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c3c:	55                   	push   %ebp
  802c3d:	89 e5                	mov    %esp,%ebp
  802c3f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c42:	a1 38 41 80 00       	mov    0x804138,%eax
  802c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c4a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c4f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c52:	a1 38 41 80 00       	mov    0x804138,%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 14                	je     802c6f <insert_sorted_with_merge_freeList+0x33>
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	8b 50 08             	mov    0x8(%eax),%edx
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	8b 40 08             	mov    0x8(%eax),%eax
  802c67:	39 c2                	cmp    %eax,%edx
  802c69:	0f 87 9b 01 00 00    	ja     802e0a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c73:	75 17                	jne    802c8c <insert_sorted_with_merge_freeList+0x50>
  802c75:	83 ec 04             	sub    $0x4,%esp
  802c78:	68 ac 3e 80 00       	push   $0x803eac
  802c7d:	68 38 01 00 00       	push   $0x138
  802c82:	68 cf 3e 80 00       	push   $0x803ecf
  802c87:	e8 de d6 ff ff       	call   80036a <_panic>
  802c8c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	89 10                	mov    %edx,(%eax)
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 0d                	je     802cad <insert_sorted_with_merge_freeList+0x71>
  802ca0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca8:	89 50 04             	mov    %edx,0x4(%eax)
  802cab:	eb 08                	jmp    802cb5 <insert_sorted_with_merge_freeList+0x79>
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	a3 38 41 80 00       	mov    %eax,0x804138
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc7:	a1 44 41 80 00       	mov    0x804144,%eax
  802ccc:	40                   	inc    %eax
  802ccd:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cd6:	0f 84 a8 06 00 00    	je     803384 <insert_sorted_with_merge_freeList+0x748>
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	8b 50 08             	mov    0x8(%eax),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	01 c2                	add    %eax,%edx
  802cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ced:	8b 40 08             	mov    0x8(%eax),%eax
  802cf0:	39 c2                	cmp    %eax,%edx
  802cf2:	0f 85 8c 06 00 00    	jne    803384 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	8b 50 0c             	mov    0xc(%eax),%edx
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 40 0c             	mov    0xc(%eax),%eax
  802d04:	01 c2                	add    %eax,%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d10:	75 17                	jne    802d29 <insert_sorted_with_merge_freeList+0xed>
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 78 3f 80 00       	push   $0x803f78
  802d1a:	68 3c 01 00 00       	push   $0x13c
  802d1f:	68 cf 3e 80 00       	push   $0x803ecf
  802d24:	e8 41 d6 ff ff       	call   80036a <_panic>
  802d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2c:	8b 00                	mov    (%eax),%eax
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	74 10                	je     802d42 <insert_sorted_with_merge_freeList+0x106>
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3a:	8b 52 04             	mov    0x4(%edx),%edx
  802d3d:	89 50 04             	mov    %edx,0x4(%eax)
  802d40:	eb 0b                	jmp    802d4d <insert_sorted_with_merge_freeList+0x111>
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	85 c0                	test   %eax,%eax
  802d55:	74 0f                	je     802d66 <insert_sorted_with_merge_freeList+0x12a>
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 40 04             	mov    0x4(%eax),%eax
  802d5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d60:	8b 12                	mov    (%edx),%edx
  802d62:	89 10                	mov    %edx,(%eax)
  802d64:	eb 0a                	jmp    802d70 <insert_sorted_with_merge_freeList+0x134>
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	a3 38 41 80 00       	mov    %eax,0x804138
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d83:	a1 44 41 80 00       	mov    0x804144,%eax
  802d88:	48                   	dec    %eax
  802d89:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802da2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802da6:	75 17                	jne    802dbf <insert_sorted_with_merge_freeList+0x183>
  802da8:	83 ec 04             	sub    $0x4,%esp
  802dab:	68 ac 3e 80 00       	push   $0x803eac
  802db0:	68 3f 01 00 00       	push   $0x13f
  802db5:	68 cf 3e 80 00       	push   $0x803ecf
  802dba:	e8 ab d5 ff ff       	call   80036a <_panic>
  802dbf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 0d                	je     802de0 <insert_sorted_with_merge_freeList+0x1a4>
  802dd3:	a1 48 41 80 00       	mov    0x804148,%eax
  802dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddb:	89 50 04             	mov    %edx,0x4(%eax)
  802dde:	eb 08                	jmp    802de8 <insert_sorted_with_merge_freeList+0x1ac>
  802de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	a3 48 41 80 00       	mov    %eax,0x804148
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfa:	a1 54 41 80 00       	mov    0x804154,%eax
  802dff:	40                   	inc    %eax
  802e00:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e05:	e9 7a 05 00 00       	jmp    803384 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 50 08             	mov    0x8(%eax),%edx
  802e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e13:	8b 40 08             	mov    0x8(%eax),%eax
  802e16:	39 c2                	cmp    %eax,%edx
  802e18:	0f 82 14 01 00 00    	jb     802f32 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	8b 50 08             	mov    0x8(%eax),%edx
  802e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	01 c2                	add    %eax,%edx
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 40 08             	mov    0x8(%eax),%eax
  802e32:	39 c2                	cmp    %eax,%edx
  802e34:	0f 85 90 00 00 00    	jne    802eca <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	8b 40 0c             	mov    0xc(%eax),%eax
  802e46:	01 c2                	add    %eax,%edx
  802e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e66:	75 17                	jne    802e7f <insert_sorted_with_merge_freeList+0x243>
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 ac 3e 80 00       	push   $0x803eac
  802e70:	68 49 01 00 00       	push   $0x149
  802e75:	68 cf 3e 80 00       	push   $0x803ecf
  802e7a:	e8 eb d4 ff ff       	call   80036a <_panic>
  802e7f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	89 10                	mov    %edx,(%eax)
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	74 0d                	je     802ea0 <insert_sorted_with_merge_freeList+0x264>
  802e93:	a1 48 41 80 00       	mov    0x804148,%eax
  802e98:	8b 55 08             	mov    0x8(%ebp),%edx
  802e9b:	89 50 04             	mov    %edx,0x4(%eax)
  802e9e:	eb 08                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x26c>
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eba:	a1 54 41 80 00       	mov    0x804154,%eax
  802ebf:	40                   	inc    %eax
  802ec0:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec5:	e9 bb 04 00 00       	jmp    803385 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802eca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ece:	75 17                	jne    802ee7 <insert_sorted_with_merge_freeList+0x2ab>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 20 3f 80 00       	push   $0x803f20
  802ed8:	68 4c 01 00 00       	push   $0x14c
  802edd:	68 cf 3e 80 00       	push   $0x803ecf
  802ee2:	e8 83 d4 ff ff       	call   80036a <_panic>
  802ee7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 40 04             	mov    0x4(%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 0c                	je     802f09 <insert_sorted_with_merge_freeList+0x2cd>
  802efd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f02:	8b 55 08             	mov    0x8(%ebp),%edx
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	eb 08                	jmp    802f11 <insert_sorted_with_merge_freeList+0x2d5>
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	a3 38 41 80 00       	mov    %eax,0x804138
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f22:	a1 44 41 80 00       	mov    0x804144,%eax
  802f27:	40                   	inc    %eax
  802f28:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2d:	e9 53 04 00 00       	jmp    803385 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f32:	a1 38 41 80 00       	mov    0x804138,%eax
  802f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3a:	e9 15 04 00 00       	jmp    803354 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 50 08             	mov    0x8(%eax),%edx
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 40 08             	mov    0x8(%eax),%eax
  802f53:	39 c2                	cmp    %eax,%edx
  802f55:	0f 86 f1 03 00 00    	jbe    80334c <insert_sorted_with_merge_freeList+0x710>
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 50 08             	mov    0x8(%eax),%edx
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 40 08             	mov    0x8(%eax),%eax
  802f67:	39 c2                	cmp    %eax,%edx
  802f69:	0f 83 dd 03 00 00    	jae    80334c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7b:	01 c2                	add    %eax,%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	39 c2                	cmp    %eax,%edx
  802f85:	0f 85 b9 01 00 00    	jne    803144 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	8b 50 08             	mov    0x8(%eax),%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 40 0c             	mov    0xc(%eax),%eax
  802f97:	01 c2                	add    %eax,%edx
  802f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	0f 85 0d 01 00 00    	jne    8030b4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 50 0c             	mov    0xc(%eax),%edx
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fbb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fbf:	75 17                	jne    802fd8 <insert_sorted_with_merge_freeList+0x39c>
  802fc1:	83 ec 04             	sub    $0x4,%esp
  802fc4:	68 78 3f 80 00       	push   $0x803f78
  802fc9:	68 5c 01 00 00       	push   $0x15c
  802fce:	68 cf 3e 80 00       	push   $0x803ecf
  802fd3:	e8 92 d3 ff ff       	call   80036a <_panic>
  802fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 10                	je     802ff1 <insert_sorted_with_merge_freeList+0x3b5>
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	8b 00                	mov    (%eax),%eax
  802fe6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe9:	8b 52 04             	mov    0x4(%edx),%edx
  802fec:	89 50 04             	mov    %edx,0x4(%eax)
  802fef:	eb 0b                	jmp    802ffc <insert_sorted_with_merge_freeList+0x3c0>
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	8b 40 04             	mov    0x4(%eax),%eax
  802ff7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 40 04             	mov    0x4(%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	74 0f                	je     803015 <insert_sorted_with_merge_freeList+0x3d9>
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	8b 40 04             	mov    0x4(%eax),%eax
  80300c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300f:	8b 12                	mov    (%edx),%edx
  803011:	89 10                	mov    %edx,(%eax)
  803013:	eb 0a                	jmp    80301f <insert_sorted_with_merge_freeList+0x3e3>
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	8b 00                	mov    (%eax),%eax
  80301a:	a3 38 41 80 00       	mov    %eax,0x804138
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803032:	a1 44 41 80 00       	mov    0x804144,%eax
  803037:	48                   	dec    %eax
  803038:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  80303d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803040:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803047:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803051:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803055:	75 17                	jne    80306e <insert_sorted_with_merge_freeList+0x432>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 ac 3e 80 00       	push   $0x803eac
  80305f:	68 5f 01 00 00       	push   $0x15f
  803064:	68 cf 3e 80 00       	push   $0x803ecf
  803069:	e8 fc d2 ff ff       	call   80036a <_panic>
  80306e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	89 10                	mov    %edx,(%eax)
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	8b 00                	mov    (%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 0d                	je     80308f <insert_sorted_with_merge_freeList+0x453>
  803082:	a1 48 41 80 00       	mov    0x804148,%eax
  803087:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308a:	89 50 04             	mov    %edx,0x4(%eax)
  80308d:	eb 08                	jmp    803097 <insert_sorted_with_merge_freeList+0x45b>
  80308f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803092:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309a:	a3 48 41 80 00       	mov    %eax,0x804148
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a9:	a1 54 41 80 00       	mov    0x804154,%eax
  8030ae:	40                   	inc    %eax
  8030af:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c0:	01 c2                	add    %eax,%edx
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e0:	75 17                	jne    8030f9 <insert_sorted_with_merge_freeList+0x4bd>
  8030e2:	83 ec 04             	sub    $0x4,%esp
  8030e5:	68 ac 3e 80 00       	push   $0x803eac
  8030ea:	68 64 01 00 00       	push   $0x164
  8030ef:	68 cf 3e 80 00       	push   $0x803ecf
  8030f4:	e8 71 d2 ff ff       	call   80036a <_panic>
  8030f9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	89 10                	mov    %edx,(%eax)
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 00                	mov    (%eax),%eax
  803109:	85 c0                	test   %eax,%eax
  80310b:	74 0d                	je     80311a <insert_sorted_with_merge_freeList+0x4de>
  80310d:	a1 48 41 80 00       	mov    0x804148,%eax
  803112:	8b 55 08             	mov    0x8(%ebp),%edx
  803115:	89 50 04             	mov    %edx,0x4(%eax)
  803118:	eb 08                	jmp    803122 <insert_sorted_with_merge_freeList+0x4e6>
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	a3 48 41 80 00       	mov    %eax,0x804148
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803134:	a1 54 41 80 00       	mov    0x804154,%eax
  803139:	40                   	inc    %eax
  80313a:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80313f:	e9 41 02 00 00       	jmp    803385 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 40 0c             	mov    0xc(%eax),%eax
  803150:	01 c2                	add    %eax,%edx
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 40 08             	mov    0x8(%eax),%eax
  803158:	39 c2                	cmp    %eax,%edx
  80315a:	0f 85 7c 01 00 00    	jne    8032dc <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803160:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803164:	74 06                	je     80316c <insert_sorted_with_merge_freeList+0x530>
  803166:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316a:	75 17                	jne    803183 <insert_sorted_with_merge_freeList+0x547>
  80316c:	83 ec 04             	sub    $0x4,%esp
  80316f:	68 e8 3e 80 00       	push   $0x803ee8
  803174:	68 69 01 00 00       	push   $0x169
  803179:	68 cf 3e 80 00       	push   $0x803ecf
  80317e:	e8 e7 d1 ff ff       	call   80036a <_panic>
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 50 04             	mov    0x4(%eax),%edx
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	89 50 04             	mov    %edx,0x4(%eax)
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803195:	89 10                	mov    %edx,(%eax)
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	74 0d                	je     8031ae <insert_sorted_with_merge_freeList+0x572>
  8031a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a4:	8b 40 04             	mov    0x4(%eax),%eax
  8031a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031aa:	89 10                	mov    %edx,(%eax)
  8031ac:	eb 08                	jmp    8031b6 <insert_sorted_with_merge_freeList+0x57a>
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bc:	89 50 04             	mov    %edx,0x4(%eax)
  8031bf:	a1 44 41 80 00       	mov    0x804144,%eax
  8031c4:	40                   	inc    %eax
  8031c5:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	8b 50 0c             	mov    0xc(%eax),%edx
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d6:	01 c2                	add    %eax,%edx
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e2:	75 17                	jne    8031fb <insert_sorted_with_merge_freeList+0x5bf>
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	68 78 3f 80 00       	push   $0x803f78
  8031ec:	68 6b 01 00 00       	push   $0x16b
  8031f1:	68 cf 3e 80 00       	push   $0x803ecf
  8031f6:	e8 6f d1 ff ff       	call   80036a <_panic>
  8031fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fe:	8b 00                	mov    (%eax),%eax
  803200:	85 c0                	test   %eax,%eax
  803202:	74 10                	je     803214 <insert_sorted_with_merge_freeList+0x5d8>
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 00                	mov    (%eax),%eax
  803209:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320c:	8b 52 04             	mov    0x4(%edx),%edx
  80320f:	89 50 04             	mov    %edx,0x4(%eax)
  803212:	eb 0b                	jmp    80321f <insert_sorted_with_merge_freeList+0x5e3>
  803214:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803217:	8b 40 04             	mov    0x4(%eax),%eax
  80321a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	8b 40 04             	mov    0x4(%eax),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	74 0f                	je     803238 <insert_sorted_with_merge_freeList+0x5fc>
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	8b 40 04             	mov    0x4(%eax),%eax
  80322f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803232:	8b 12                	mov    (%edx),%edx
  803234:	89 10                	mov    %edx,(%eax)
  803236:	eb 0a                	jmp    803242 <insert_sorted_with_merge_freeList+0x606>
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 00                	mov    (%eax),%eax
  80323d:	a3 38 41 80 00       	mov    %eax,0x804138
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803255:	a1 44 41 80 00       	mov    0x804144,%eax
  80325a:	48                   	dec    %eax
  80325b:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803274:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803278:	75 17                	jne    803291 <insert_sorted_with_merge_freeList+0x655>
  80327a:	83 ec 04             	sub    $0x4,%esp
  80327d:	68 ac 3e 80 00       	push   $0x803eac
  803282:	68 6e 01 00 00       	push   $0x16e
  803287:	68 cf 3e 80 00       	push   $0x803ecf
  80328c:	e8 d9 d0 ff ff       	call   80036a <_panic>
  803291:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803297:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329a:	89 10                	mov    %edx,(%eax)
  80329c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0d                	je     8032b2 <insert_sorted_with_merge_freeList+0x676>
  8032a5:	a1 48 41 80 00       	mov    0x804148,%eax
  8032aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ad:	89 50 04             	mov    %edx,0x4(%eax)
  8032b0:	eb 08                	jmp    8032ba <insert_sorted_with_merge_freeList+0x67e>
  8032b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	a3 48 41 80 00       	mov    %eax,0x804148
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cc:	a1 54 41 80 00       	mov    0x804154,%eax
  8032d1:	40                   	inc    %eax
  8032d2:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8032d7:	e9 a9 00 00 00       	jmp    803385 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e0:	74 06                	je     8032e8 <insert_sorted_with_merge_freeList+0x6ac>
  8032e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e6:	75 17                	jne    8032ff <insert_sorted_with_merge_freeList+0x6c3>
  8032e8:	83 ec 04             	sub    $0x4,%esp
  8032eb:	68 44 3f 80 00       	push   $0x803f44
  8032f0:	68 73 01 00 00       	push   $0x173
  8032f5:	68 cf 3e 80 00       	push   $0x803ecf
  8032fa:	e8 6b d0 ff ff       	call   80036a <_panic>
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 10                	mov    (%eax),%edx
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	89 10                	mov    %edx,(%eax)
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	74 0b                	je     80331d <insert_sorted_with_merge_freeList+0x6e1>
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	8b 55 08             	mov    0x8(%ebp),%edx
  80331a:	89 50 04             	mov    %edx,0x4(%eax)
  80331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803320:	8b 55 08             	mov    0x8(%ebp),%edx
  803323:	89 10                	mov    %edx,(%eax)
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332b:	89 50 04             	mov    %edx,0x4(%eax)
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 00                	mov    (%eax),%eax
  803333:	85 c0                	test   %eax,%eax
  803335:	75 08                	jne    80333f <insert_sorted_with_merge_freeList+0x703>
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80333f:	a1 44 41 80 00       	mov    0x804144,%eax
  803344:	40                   	inc    %eax
  803345:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80334a:	eb 39                	jmp    803385 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80334c:	a1 40 41 80 00       	mov    0x804140,%eax
  803351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803358:	74 07                	je     803361 <insert_sorted_with_merge_freeList+0x725>
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	8b 00                	mov    (%eax),%eax
  80335f:	eb 05                	jmp    803366 <insert_sorted_with_merge_freeList+0x72a>
  803361:	b8 00 00 00 00       	mov    $0x0,%eax
  803366:	a3 40 41 80 00       	mov    %eax,0x804140
  80336b:	a1 40 41 80 00       	mov    0x804140,%eax
  803370:	85 c0                	test   %eax,%eax
  803372:	0f 85 c7 fb ff ff    	jne    802f3f <insert_sorted_with_merge_freeList+0x303>
  803378:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337c:	0f 85 bd fb ff ff    	jne    802f3f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803382:	eb 01                	jmp    803385 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803384:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803385:	90                   	nop
  803386:	c9                   	leave  
  803387:	c3                   	ret    

00803388 <__udivdi3>:
  803388:	55                   	push   %ebp
  803389:	57                   	push   %edi
  80338a:	56                   	push   %esi
  80338b:	53                   	push   %ebx
  80338c:	83 ec 1c             	sub    $0x1c,%esp
  80338f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803393:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803397:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80339f:	89 ca                	mov    %ecx,%edx
  8033a1:	89 f8                	mov    %edi,%eax
  8033a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033a7:	85 f6                	test   %esi,%esi
  8033a9:	75 2d                	jne    8033d8 <__udivdi3+0x50>
  8033ab:	39 cf                	cmp    %ecx,%edi
  8033ad:	77 65                	ja     803414 <__udivdi3+0x8c>
  8033af:	89 fd                	mov    %edi,%ebp
  8033b1:	85 ff                	test   %edi,%edi
  8033b3:	75 0b                	jne    8033c0 <__udivdi3+0x38>
  8033b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ba:	31 d2                	xor    %edx,%edx
  8033bc:	f7 f7                	div    %edi
  8033be:	89 c5                	mov    %eax,%ebp
  8033c0:	31 d2                	xor    %edx,%edx
  8033c2:	89 c8                	mov    %ecx,%eax
  8033c4:	f7 f5                	div    %ebp
  8033c6:	89 c1                	mov    %eax,%ecx
  8033c8:	89 d8                	mov    %ebx,%eax
  8033ca:	f7 f5                	div    %ebp
  8033cc:	89 cf                	mov    %ecx,%edi
  8033ce:	89 fa                	mov    %edi,%edx
  8033d0:	83 c4 1c             	add    $0x1c,%esp
  8033d3:	5b                   	pop    %ebx
  8033d4:	5e                   	pop    %esi
  8033d5:	5f                   	pop    %edi
  8033d6:	5d                   	pop    %ebp
  8033d7:	c3                   	ret    
  8033d8:	39 ce                	cmp    %ecx,%esi
  8033da:	77 28                	ja     803404 <__udivdi3+0x7c>
  8033dc:	0f bd fe             	bsr    %esi,%edi
  8033df:	83 f7 1f             	xor    $0x1f,%edi
  8033e2:	75 40                	jne    803424 <__udivdi3+0x9c>
  8033e4:	39 ce                	cmp    %ecx,%esi
  8033e6:	72 0a                	jb     8033f2 <__udivdi3+0x6a>
  8033e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033ec:	0f 87 9e 00 00 00    	ja     803490 <__udivdi3+0x108>
  8033f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f7:	89 fa                	mov    %edi,%edx
  8033f9:	83 c4 1c             	add    $0x1c,%esp
  8033fc:	5b                   	pop    %ebx
  8033fd:	5e                   	pop    %esi
  8033fe:	5f                   	pop    %edi
  8033ff:	5d                   	pop    %ebp
  803400:	c3                   	ret    
  803401:	8d 76 00             	lea    0x0(%esi),%esi
  803404:	31 ff                	xor    %edi,%edi
  803406:	31 c0                	xor    %eax,%eax
  803408:	89 fa                	mov    %edi,%edx
  80340a:	83 c4 1c             	add    $0x1c,%esp
  80340d:	5b                   	pop    %ebx
  80340e:	5e                   	pop    %esi
  80340f:	5f                   	pop    %edi
  803410:	5d                   	pop    %ebp
  803411:	c3                   	ret    
  803412:	66 90                	xchg   %ax,%ax
  803414:	89 d8                	mov    %ebx,%eax
  803416:	f7 f7                	div    %edi
  803418:	31 ff                	xor    %edi,%edi
  80341a:	89 fa                	mov    %edi,%edx
  80341c:	83 c4 1c             	add    $0x1c,%esp
  80341f:	5b                   	pop    %ebx
  803420:	5e                   	pop    %esi
  803421:	5f                   	pop    %edi
  803422:	5d                   	pop    %ebp
  803423:	c3                   	ret    
  803424:	bd 20 00 00 00       	mov    $0x20,%ebp
  803429:	89 eb                	mov    %ebp,%ebx
  80342b:	29 fb                	sub    %edi,%ebx
  80342d:	89 f9                	mov    %edi,%ecx
  80342f:	d3 e6                	shl    %cl,%esi
  803431:	89 c5                	mov    %eax,%ebp
  803433:	88 d9                	mov    %bl,%cl
  803435:	d3 ed                	shr    %cl,%ebp
  803437:	89 e9                	mov    %ebp,%ecx
  803439:	09 f1                	or     %esi,%ecx
  80343b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80343f:	89 f9                	mov    %edi,%ecx
  803441:	d3 e0                	shl    %cl,%eax
  803443:	89 c5                	mov    %eax,%ebp
  803445:	89 d6                	mov    %edx,%esi
  803447:	88 d9                	mov    %bl,%cl
  803449:	d3 ee                	shr    %cl,%esi
  80344b:	89 f9                	mov    %edi,%ecx
  80344d:	d3 e2                	shl    %cl,%edx
  80344f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803453:	88 d9                	mov    %bl,%cl
  803455:	d3 e8                	shr    %cl,%eax
  803457:	09 c2                	or     %eax,%edx
  803459:	89 d0                	mov    %edx,%eax
  80345b:	89 f2                	mov    %esi,%edx
  80345d:	f7 74 24 0c          	divl   0xc(%esp)
  803461:	89 d6                	mov    %edx,%esi
  803463:	89 c3                	mov    %eax,%ebx
  803465:	f7 e5                	mul    %ebp
  803467:	39 d6                	cmp    %edx,%esi
  803469:	72 19                	jb     803484 <__udivdi3+0xfc>
  80346b:	74 0b                	je     803478 <__udivdi3+0xf0>
  80346d:	89 d8                	mov    %ebx,%eax
  80346f:	31 ff                	xor    %edi,%edi
  803471:	e9 58 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  803476:	66 90                	xchg   %ax,%ax
  803478:	8b 54 24 08          	mov    0x8(%esp),%edx
  80347c:	89 f9                	mov    %edi,%ecx
  80347e:	d3 e2                	shl    %cl,%edx
  803480:	39 c2                	cmp    %eax,%edx
  803482:	73 e9                	jae    80346d <__udivdi3+0xe5>
  803484:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803487:	31 ff                	xor    %edi,%edi
  803489:	e9 40 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  80348e:	66 90                	xchg   %ax,%ax
  803490:	31 c0                	xor    %eax,%eax
  803492:	e9 37 ff ff ff       	jmp    8033ce <__udivdi3+0x46>
  803497:	90                   	nop

00803498 <__umoddi3>:
  803498:	55                   	push   %ebp
  803499:	57                   	push   %edi
  80349a:	56                   	push   %esi
  80349b:	53                   	push   %ebx
  80349c:	83 ec 1c             	sub    $0x1c,%esp
  80349f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034b7:	89 f3                	mov    %esi,%ebx
  8034b9:	89 fa                	mov    %edi,%edx
  8034bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034bf:	89 34 24             	mov    %esi,(%esp)
  8034c2:	85 c0                	test   %eax,%eax
  8034c4:	75 1a                	jne    8034e0 <__umoddi3+0x48>
  8034c6:	39 f7                	cmp    %esi,%edi
  8034c8:	0f 86 a2 00 00 00    	jbe    803570 <__umoddi3+0xd8>
  8034ce:	89 c8                	mov    %ecx,%eax
  8034d0:	89 f2                	mov    %esi,%edx
  8034d2:	f7 f7                	div    %edi
  8034d4:	89 d0                	mov    %edx,%eax
  8034d6:	31 d2                	xor    %edx,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	39 f0                	cmp    %esi,%eax
  8034e2:	0f 87 ac 00 00 00    	ja     803594 <__umoddi3+0xfc>
  8034e8:	0f bd e8             	bsr    %eax,%ebp
  8034eb:	83 f5 1f             	xor    $0x1f,%ebp
  8034ee:	0f 84 ac 00 00 00    	je     8035a0 <__umoddi3+0x108>
  8034f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8034f9:	29 ef                	sub    %ebp,%edi
  8034fb:	89 fe                	mov    %edi,%esi
  8034fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803501:	89 e9                	mov    %ebp,%ecx
  803503:	d3 e0                	shl    %cl,%eax
  803505:	89 d7                	mov    %edx,%edi
  803507:	89 f1                	mov    %esi,%ecx
  803509:	d3 ef                	shr    %cl,%edi
  80350b:	09 c7                	or     %eax,%edi
  80350d:	89 e9                	mov    %ebp,%ecx
  80350f:	d3 e2                	shl    %cl,%edx
  803511:	89 14 24             	mov    %edx,(%esp)
  803514:	89 d8                	mov    %ebx,%eax
  803516:	d3 e0                	shl    %cl,%eax
  803518:	89 c2                	mov    %eax,%edx
  80351a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351e:	d3 e0                	shl    %cl,%eax
  803520:	89 44 24 04          	mov    %eax,0x4(%esp)
  803524:	8b 44 24 08          	mov    0x8(%esp),%eax
  803528:	89 f1                	mov    %esi,%ecx
  80352a:	d3 e8                	shr    %cl,%eax
  80352c:	09 d0                	or     %edx,%eax
  80352e:	d3 eb                	shr    %cl,%ebx
  803530:	89 da                	mov    %ebx,%edx
  803532:	f7 f7                	div    %edi
  803534:	89 d3                	mov    %edx,%ebx
  803536:	f7 24 24             	mull   (%esp)
  803539:	89 c6                	mov    %eax,%esi
  80353b:	89 d1                	mov    %edx,%ecx
  80353d:	39 d3                	cmp    %edx,%ebx
  80353f:	0f 82 87 00 00 00    	jb     8035cc <__umoddi3+0x134>
  803545:	0f 84 91 00 00 00    	je     8035dc <__umoddi3+0x144>
  80354b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80354f:	29 f2                	sub    %esi,%edx
  803551:	19 cb                	sbb    %ecx,%ebx
  803553:	89 d8                	mov    %ebx,%eax
  803555:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803559:	d3 e0                	shl    %cl,%eax
  80355b:	89 e9                	mov    %ebp,%ecx
  80355d:	d3 ea                	shr    %cl,%edx
  80355f:	09 d0                	or     %edx,%eax
  803561:	89 e9                	mov    %ebp,%ecx
  803563:	d3 eb                	shr    %cl,%ebx
  803565:	89 da                	mov    %ebx,%edx
  803567:	83 c4 1c             	add    $0x1c,%esp
  80356a:	5b                   	pop    %ebx
  80356b:	5e                   	pop    %esi
  80356c:	5f                   	pop    %edi
  80356d:	5d                   	pop    %ebp
  80356e:	c3                   	ret    
  80356f:	90                   	nop
  803570:	89 fd                	mov    %edi,%ebp
  803572:	85 ff                	test   %edi,%edi
  803574:	75 0b                	jne    803581 <__umoddi3+0xe9>
  803576:	b8 01 00 00 00       	mov    $0x1,%eax
  80357b:	31 d2                	xor    %edx,%edx
  80357d:	f7 f7                	div    %edi
  80357f:	89 c5                	mov    %eax,%ebp
  803581:	89 f0                	mov    %esi,%eax
  803583:	31 d2                	xor    %edx,%edx
  803585:	f7 f5                	div    %ebp
  803587:	89 c8                	mov    %ecx,%eax
  803589:	f7 f5                	div    %ebp
  80358b:	89 d0                	mov    %edx,%eax
  80358d:	e9 44 ff ff ff       	jmp    8034d6 <__umoddi3+0x3e>
  803592:	66 90                	xchg   %ax,%ax
  803594:	89 c8                	mov    %ecx,%eax
  803596:	89 f2                	mov    %esi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	3b 04 24             	cmp    (%esp),%eax
  8035a3:	72 06                	jb     8035ab <__umoddi3+0x113>
  8035a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035a9:	77 0f                	ja     8035ba <__umoddi3+0x122>
  8035ab:	89 f2                	mov    %esi,%edx
  8035ad:	29 f9                	sub    %edi,%ecx
  8035af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035b3:	89 14 24             	mov    %edx,(%esp)
  8035b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035be:	8b 14 24             	mov    (%esp),%edx
  8035c1:	83 c4 1c             	add    $0x1c,%esp
  8035c4:	5b                   	pop    %ebx
  8035c5:	5e                   	pop    %esi
  8035c6:	5f                   	pop    %edi
  8035c7:	5d                   	pop    %ebp
  8035c8:	c3                   	ret    
  8035c9:	8d 76 00             	lea    0x0(%esi),%esi
  8035cc:	2b 04 24             	sub    (%esp),%eax
  8035cf:	19 fa                	sbb    %edi,%edx
  8035d1:	89 d1                	mov    %edx,%ecx
  8035d3:	89 c6                	mov    %eax,%esi
  8035d5:	e9 71 ff ff ff       	jmp    80354b <__umoddi3+0xb3>
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035e0:	72 ea                	jb     8035cc <__umoddi3+0x134>
  8035e2:	89 d9                	mov    %ebx,%ecx
  8035e4:	e9 62 ff ff ff       	jmp    80354b <__umoddi3+0xb3>
