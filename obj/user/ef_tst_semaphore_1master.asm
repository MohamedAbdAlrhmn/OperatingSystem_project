
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
  80003e:	e8 b2 1a 00 00       	call   801af5 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 60 36 80 00       	push   $0x803660
  800050:	e8 3a 19 00 00       	call   80198f <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 64 36 80 00       	push   $0x803664
  800062:	e8 28 19 00 00       	call   80198f <sys_createSemaphore>
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
  800083:	68 6c 36 80 00       	push   $0x80366c
  800088:	e8 13 1a 00 00       	call   801aa0 <sys_create_env>
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
  8000ac:	68 6c 36 80 00       	push   $0x80366c
  8000b1:	e8 ea 19 00 00       	call   801aa0 <sys_create_env>
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
  8000d5:	68 6c 36 80 00       	push   $0x80366c
  8000da:	e8 c1 19 00 00       	call   801aa0 <sys_create_env>
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
  8000fa:	68 79 36 80 00       	push   $0x803679
  8000ff:	6a 13                	push   $0x13
  800101:	68 90 36 80 00       	push   $0x803690
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 a8 19 00 00       	call   801abe <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 9a 19 00 00       	call   801abe <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 8c 19 00 00       	call   801abe <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 64 36 80 00       	push   $0x803664
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 83 18 00 00       	call   8019c8 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 64 36 80 00       	push   $0x803664
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 70 18 00 00       	call   8019c8 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 64 36 80 00       	push   $0x803664
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 5d 18 00 00       	call   8019c8 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 60 36 80 00       	push   $0x803660
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 2d 18 00 00       	call   8019ab <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 64 36 80 00       	push   $0x803664
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 17 18 00 00       	call   8019ab <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 b0 36 80 00       	push   $0x8036b0
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 f8 36 80 00       	push   $0x8036f8
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 5a 19 00 00       	call   801b27 <sys_getparentenvid>
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
  8001e0:	68 43 37 80 00       	push   $0x803743
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 9d 14 00 00       	call   80168a <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 dc 18 00 00       	call   801ada <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 ce 18 00 00       	call   801ada <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 c0 18 00 00       	call   801ada <sys_destroy_env>
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
  800234:	e8 d5 18 00 00       	call   801b0e <sys_getenvindex>
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
  80029f:	e8 77 16 00 00       	call   80191b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 6c 37 80 00       	push   $0x80376c
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
  8002cf:	68 94 37 80 00       	push   $0x803794
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
  800300:	68 bc 37 80 00       	push   $0x8037bc
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 14 38 80 00       	push   $0x803814
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 6c 37 80 00       	push   $0x80376c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 f7 15 00 00       	call   801935 <sys_enable_interrupt>

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
  800351:	e8 84 17 00 00       	call   801ada <sys_destroy_env>
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
  800362:	e8 d9 17 00 00       	call   801b40 <sys_exit_env>
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
  80038b:	68 28 38 80 00       	push   $0x803828
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 2d 38 80 00       	push   $0x80382d
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
  8003c8:	68 49 38 80 00       	push   $0x803849
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
  8003f4:	68 4c 38 80 00       	push   $0x80384c
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 98 38 80 00       	push   $0x803898
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
  8004c6:	68 a4 38 80 00       	push   $0x8038a4
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 98 38 80 00       	push   $0x803898
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
  800536:	68 f8 38 80 00       	push   $0x8038f8
  80053b:	6a 44                	push   $0x44
  80053d:	68 98 38 80 00       	push   $0x803898
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
  800590:	e8 d8 11 00 00       	call   80176d <sys_cputs>
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
  800607:	e8 61 11 00 00       	call   80176d <sys_cputs>
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
  800651:	e8 c5 12 00 00       	call   80191b <sys_disable_interrupt>
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
  800671:	e8 bf 12 00 00       	call   801935 <sys_enable_interrupt>
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
  8006bb:	e8 30 2d 00 00       	call   8033f0 <__udivdi3>
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
  80070b:	e8 f0 2d 00 00       	call   803500 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 74 3b 80 00       	add    $0x803b74,%eax
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
  800866:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
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
  800947:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 85 3b 80 00       	push   $0x803b85
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
  80096c:	68 8e 3b 80 00       	push   $0x803b8e
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
  800999:	be 91 3b 80 00       	mov    $0x803b91,%esi
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
  8013bf:	68 f0 3c 80 00       	push   $0x803cf0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801472:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801481:	2d 00 10 00 00       	sub    $0x1000,%eax
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 06                	push   $0x6
  80148b:	ff 75 f4             	pushl  -0xc(%ebp)
  80148e:	50                   	push   %eax
  80148f:	e8 1d 04 00 00       	call   8018b1 <sys_allocate_chunk>
  801494:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801497:	a1 20 41 80 00       	mov    0x804120,%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	50                   	push   %eax
  8014a0:	e8 92 0a 00 00       	call   801f37 <initialize_MemBlocksList>
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
  8014cd:	68 15 3d 80 00       	push   $0x803d15
  8014d2:	6a 33                	push   $0x33
  8014d4:	68 33 3d 80 00       	push   $0x803d33
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
  80154c:	68 40 3d 80 00       	push   $0x803d40
  801551:	6a 34                	push   $0x34
  801553:	68 33 3d 80 00       	push   $0x803d33
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
  8015c1:	68 64 3d 80 00       	push   $0x803d64
  8015c6:	6a 46                	push   $0x46
  8015c8:	68 33 3d 80 00       	push   $0x803d33
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
  8015dd:	68 8c 3d 80 00       	push   $0x803d8c
  8015e2:	6a 61                	push   $0x61
  8015e4:	68 33 3d 80 00       	push   $0x803d33
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
  801603:	75 07                	jne    80160c <smalloc+0x1e>
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	eb 7c                	jmp    801688 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80160c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801613:	8b 55 0c             	mov    0xc(%ebp),%edx
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	01 d0                	add    %edx,%eax
  80161b:	48                   	dec    %eax
  80161c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80161f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801622:	ba 00 00 00 00       	mov    $0x0,%edx
  801627:	f7 75 f0             	divl   -0x10(%ebp)
  80162a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162d:	29 d0                	sub    %edx,%eax
  80162f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801632:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801639:	e8 41 06 00 00       	call   801c7f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80163e:	85 c0                	test   %eax,%eax
  801640:	74 11                	je     801653 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801642:	83 ec 0c             	sub    $0xc,%esp
  801645:	ff 75 e8             	pushl  -0x18(%ebp)
  801648:	e8 ac 0c 00 00       	call   8022f9 <alloc_block_FF>
  80164d:	83 c4 10             	add    $0x10,%esp
  801650:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801657:	74 2a                	je     801683 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	8b 40 08             	mov    0x8(%eax),%eax
  80165f:	89 c2                	mov    %eax,%edx
  801661:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801665:	52                   	push   %edx
  801666:	50                   	push   %eax
  801667:	ff 75 0c             	pushl  0xc(%ebp)
  80166a:	ff 75 08             	pushl  0x8(%ebp)
  80166d:	e8 92 03 00 00       	call   801a04 <sys_createSharedObject>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801678:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80167c:	74 05                	je     801683 <smalloc+0x95>
			return (void*)virtual_address;
  80167e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801681:	eb 05                	jmp    801688 <smalloc+0x9a>
	}
	return NULL;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801690:	e8 13 fd ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801695:	83 ec 04             	sub    $0x4,%esp
  801698:	68 b0 3d 80 00       	push   $0x803db0
  80169d:	68 a2 00 00 00       	push   $0xa2
  8016a2:	68 33 3d 80 00       	push   $0x803d33
  8016a7:	e8 be ec ff ff       	call   80036a <_panic>

008016ac <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b2:	e8 f1 fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	68 d4 3d 80 00       	push   $0x803dd4
  8016bf:	68 e6 00 00 00       	push   $0xe6
  8016c4:	68 33 3d 80 00       	push   $0x803d33
  8016c9:	e8 9c ec ff ff       	call   80036a <_panic>

008016ce <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016d4:	83 ec 04             	sub    $0x4,%esp
  8016d7:	68 fc 3d 80 00       	push   $0x803dfc
  8016dc:	68 fa 00 00 00       	push   $0xfa
  8016e1:	68 33 3d 80 00       	push   $0x803d33
  8016e6:	e8 7f ec ff ff       	call   80036a <_panic>

008016eb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f1:	83 ec 04             	sub    $0x4,%esp
  8016f4:	68 20 3e 80 00       	push   $0x803e20
  8016f9:	68 05 01 00 00       	push   $0x105
  8016fe:	68 33 3d 80 00       	push   $0x803d33
  801703:	e8 62 ec ff ff       	call   80036a <_panic>

00801708 <shrink>:

}
void shrink(uint32 newSize)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	68 20 3e 80 00       	push   $0x803e20
  801716:	68 0a 01 00 00       	push   $0x10a
  80171b:	68 33 3d 80 00       	push   $0x803d33
  801720:	e8 45 ec ff ff       	call   80036a <_panic>

00801725 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 20 3e 80 00       	push   $0x803e20
  801733:	68 0f 01 00 00       	push   $0x10f
  801738:	68 33 3d 80 00       	push   $0x803d33
  80173d:	e8 28 ec ff ff       	call   80036a <_panic>

00801742 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	57                   	push   %edi
  801746:	56                   	push   %esi
  801747:	53                   	push   %ebx
  801748:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801751:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801754:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801757:	8b 7d 18             	mov    0x18(%ebp),%edi
  80175a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80175d:	cd 30                	int    $0x30
  80175f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801765:	83 c4 10             	add    $0x10,%esp
  801768:	5b                   	pop    %ebx
  801769:	5e                   	pop    %esi
  80176a:	5f                   	pop    %edi
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    

0080176d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	8b 45 10             	mov    0x10(%ebp),%eax
  801776:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801779:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	52                   	push   %edx
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	50                   	push   %eax
  801789:	6a 00                	push   $0x0
  80178b:	e8 b2 ff ff ff       	call   801742 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	90                   	nop
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_cgetc>:

int
sys_cgetc(void)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 01                	push   $0x1
  8017a5:	e8 98 ff ff ff       	call   801742 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	52                   	push   %edx
  8017bf:	50                   	push   %eax
  8017c0:	6a 05                	push   $0x5
  8017c2:	e8 7b ff ff ff       	call   801742 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	56                   	push   %esi
  8017d0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8017d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	51                   	push   %ecx
  8017e3:	52                   	push   %edx
  8017e4:	50                   	push   %eax
  8017e5:	6a 06                	push   $0x6
  8017e7:	e8 56 ff ff ff       	call   801742 <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
}
  8017ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f2:	5b                   	pop    %ebx
  8017f3:	5e                   	pop    %esi
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	52                   	push   %edx
  801806:	50                   	push   %eax
  801807:	6a 07                	push   $0x7
  801809:	e8 34 ff ff ff       	call   801742 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	ff 75 0c             	pushl  0xc(%ebp)
  80181f:	ff 75 08             	pushl  0x8(%ebp)
  801822:	6a 08                	push   $0x8
  801824:	e8 19 ff ff ff       	call   801742 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 09                	push   $0x9
  80183d:	e8 00 ff ff ff       	call   801742 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 0a                	push   $0xa
  801856:	e8 e7 fe ff ff       	call   801742 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 0b                	push   $0xb
  80186f:	e8 ce fe ff ff       	call   801742 <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	ff 75 08             	pushl  0x8(%ebp)
  801888:	6a 0f                	push   $0xf
  80188a:	e8 b3 fe ff ff       	call   801742 <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
	return;
  801892:	90                   	nop
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	6a 10                	push   $0x10
  8018a6:	e8 97 fe ff ff       	call   801742 <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ae:	90                   	nop
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	ff 75 10             	pushl  0x10(%ebp)
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	6a 11                	push   $0x11
  8018c3:	e8 7a fe ff ff       	call   801742 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018cb:	90                   	nop
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 0c                	push   $0xc
  8018dd:	e8 60 fe ff ff       	call   801742 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	6a 0d                	push   $0xd
  8018f7:	e8 46 fe ff ff       	call   801742 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 0e                	push   $0xe
  801910:	e8 2d fe ff ff       	call   801742 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 13                	push   $0x13
  80192a:	e8 13 fe ff ff       	call   801742 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	90                   	nop
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 14                	push   $0x14
  801944:	e8 f9 fd ff ff       	call   801742 <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	90                   	nop
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <sys_cputc>:


void
sys_cputc(const char c)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 04             	sub    $0x4,%esp
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80195b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	50                   	push   %eax
  801968:	6a 15                	push   $0x15
  80196a:	e8 d3 fd ff ff       	call   801742 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 16                	push   $0x16
  801984:	e8 b9 fd ff ff       	call   801742 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	90                   	nop
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 0c             	pushl  0xc(%ebp)
  80199e:	50                   	push   %eax
  80199f:	6a 17                	push   $0x17
  8019a1:	e8 9c fd ff ff       	call   801742 <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	52                   	push   %edx
  8019bb:	50                   	push   %eax
  8019bc:	6a 1a                	push   $0x1a
  8019be:	e8 7f fd ff ff       	call   801742 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	52                   	push   %edx
  8019d8:	50                   	push   %eax
  8019d9:	6a 18                	push   $0x18
  8019db:	e8 62 fd ff ff       	call   801742 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	90                   	nop
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	52                   	push   %edx
  8019f6:	50                   	push   %eax
  8019f7:	6a 19                	push   $0x19
  8019f9:	e8 44 fd ff ff       	call   801742 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	90                   	nop
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a10:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a13:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a17:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1a:	6a 00                	push   $0x0
  801a1c:	51                   	push   %ecx
  801a1d:	52                   	push   %edx
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	50                   	push   %eax
  801a22:	6a 1b                	push   $0x1b
  801a24:	e8 19 fd ff ff       	call   801742 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	6a 1c                	push   $0x1c
  801a41:	e8 fc fc ff ff       	call   801742 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	51                   	push   %ecx
  801a5c:	52                   	push   %edx
  801a5d:	50                   	push   %eax
  801a5e:	6a 1d                	push   $0x1d
  801a60:	e8 dd fc ff ff       	call   801742 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	52                   	push   %edx
  801a7a:	50                   	push   %eax
  801a7b:	6a 1e                	push   $0x1e
  801a7d:	e8 c0 fc ff ff       	call   801742 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 1f                	push   $0x1f
  801a96:	e8 a7 fc ff ff       	call   801742 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	ff 75 14             	pushl  0x14(%ebp)
  801aab:	ff 75 10             	pushl  0x10(%ebp)
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	50                   	push   %eax
  801ab2:	6a 20                	push   $0x20
  801ab4:	e8 89 fc ff ff       	call   801742 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	50                   	push   %eax
  801acd:	6a 21                	push   $0x21
  801acf:	e8 6e fc ff ff       	call   801742 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	90                   	nop
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	50                   	push   %eax
  801ae9:	6a 22                	push   $0x22
  801aeb:	e8 52 fc ff ff       	call   801742 <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 02                	push   $0x2
  801b04:	e8 39 fc ff ff       	call   801742 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 03                	push   $0x3
  801b1d:	e8 20 fc ff ff       	call   801742 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 04                	push   $0x4
  801b36:	e8 07 fc ff ff       	call   801742 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_exit_env>:


void sys_exit_env(void)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 23                	push   $0x23
  801b4f:	e8 ee fb ff ff       	call   801742 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	90                   	nop
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b60:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b63:	8d 50 04             	lea    0x4(%eax),%edx
  801b66:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	52                   	push   %edx
  801b70:	50                   	push   %eax
  801b71:	6a 24                	push   $0x24
  801b73:	e8 ca fb ff ff       	call   801742 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return result;
  801b7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b84:	89 01                	mov    %eax,(%ecx)
  801b86:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	c9                   	leave  
  801b8d:	c2 04 00             	ret    $0x4

00801b90 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	ff 75 10             	pushl  0x10(%ebp)
  801b9a:	ff 75 0c             	pushl  0xc(%ebp)
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 12                	push   $0x12
  801ba2:	e8 9b fb ff ff       	call   801742 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
	return ;
  801baa:	90                   	nop
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_rcr2>:
uint32 sys_rcr2()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 25                	push   $0x25
  801bbc:	e8 81 fb ff ff       	call   801742 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	50                   	push   %eax
  801bdf:	6a 26                	push   $0x26
  801be1:	e8 5c fb ff ff       	call   801742 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return ;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <rsttst>:
void rsttst()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 28                	push   $0x28
  801bfb:	e8 42 fb ff ff       	call   801742 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
	return ;
  801c03:	90                   	nop
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c12:	8b 55 18             	mov    0x18(%ebp),%edx
  801c15:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	ff 75 10             	pushl  0x10(%ebp)
  801c1e:	ff 75 0c             	pushl  0xc(%ebp)
  801c21:	ff 75 08             	pushl  0x8(%ebp)
  801c24:	6a 27                	push   $0x27
  801c26:	e8 17 fb ff ff       	call   801742 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <chktst>:
void chktst(uint32 n)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 08             	pushl  0x8(%ebp)
  801c3f:	6a 29                	push   $0x29
  801c41:	e8 fc fa ff ff       	call   801742 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return ;
  801c49:	90                   	nop
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <inctst>:

void inctst()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 2a                	push   $0x2a
  801c5b:	e8 e2 fa ff ff       	call   801742 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return ;
  801c63:	90                   	nop
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <gettst>:
uint32 gettst()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 2b                	push   $0x2b
  801c75:	e8 c8 fa ff ff       	call   801742 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 2c                	push   $0x2c
  801c91:	e8 ac fa ff ff       	call   801742 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
  801c99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c9c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ca0:	75 07                	jne    801ca9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ca2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca7:	eb 05                	jmp    801cae <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 2c                	push   $0x2c
  801cc2:	e8 7b fa ff ff       	call   801742 <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
  801cca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ccd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cd1:	75 07                	jne    801cda <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd8:	eb 05                	jmp    801cdf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 2c                	push   $0x2c
  801cf3:	e8 4a fa ff ff       	call   801742 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
  801cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cfe:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d02:	75 07                	jne    801d0b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d04:	b8 01 00 00 00       	mov    $0x1,%eax
  801d09:	eb 05                	jmp    801d10 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 2c                	push   $0x2c
  801d24:	e8 19 fa ff ff       	call   801742 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
  801d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d2f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d33:	75 07                	jne    801d3c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	eb 05                	jmp    801d41 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	6a 2d                	push   $0x2d
  801d53:	e8 ea f9 ff ff       	call   801742 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5b:	90                   	nop
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d62:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	6a 00                	push   $0x0
  801d70:	53                   	push   %ebx
  801d71:	51                   	push   %ecx
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	6a 2e                	push   $0x2e
  801d76:	e8 c7 f9 ff ff       	call   801742 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
}
  801d7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	52                   	push   %edx
  801d93:	50                   	push   %eax
  801d94:	6a 2f                	push   $0x2f
  801d96:	e8 a7 f9 ff ff       	call   801742 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801da6:	83 ec 0c             	sub    $0xc,%esp
  801da9:	68 30 3e 80 00       	push   $0x803e30
  801dae:	e8 6b e8 ff ff       	call   80061e <cprintf>
  801db3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801db6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dbd:	83 ec 0c             	sub    $0xc,%esp
  801dc0:	68 5c 3e 80 00       	push   $0x803e5c
  801dc5:	e8 54 e8 ff ff       	call   80061e <cprintf>
  801dca:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dcd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dd1:	a1 38 41 80 00       	mov    0x804138,%eax
  801dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd9:	eb 56                	jmp    801e31 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ddb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ddf:	74 1c                	je     801dfd <print_mem_block_lists+0x5d>
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 50 08             	mov    0x8(%eax),%edx
  801de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dea:	8b 48 08             	mov    0x8(%eax),%ecx
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df0:	8b 40 0c             	mov    0xc(%eax),%eax
  801df3:	01 c8                	add    %ecx,%eax
  801df5:	39 c2                	cmp    %eax,%edx
  801df7:	73 04                	jae    801dfd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801df9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e00:	8b 50 08             	mov    0x8(%eax),%edx
  801e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e06:	8b 40 0c             	mov    0xc(%eax),%eax
  801e09:	01 c2                	add    %eax,%edx
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	8b 40 08             	mov    0x8(%eax),%eax
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	52                   	push   %edx
  801e15:	50                   	push   %eax
  801e16:	68 71 3e 80 00       	push   $0x803e71
  801e1b:	e8 fe e7 ff ff       	call   80061e <cprintf>
  801e20:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e29:	a1 40 41 80 00       	mov    0x804140,%eax
  801e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e35:	74 07                	je     801e3e <print_mem_block_lists+0x9e>
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	8b 00                	mov    (%eax),%eax
  801e3c:	eb 05                	jmp    801e43 <print_mem_block_lists+0xa3>
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e43:	a3 40 41 80 00       	mov    %eax,0x804140
  801e48:	a1 40 41 80 00       	mov    0x804140,%eax
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	75 8a                	jne    801ddb <print_mem_block_lists+0x3b>
  801e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e55:	75 84                	jne    801ddb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e57:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e5b:	75 10                	jne    801e6d <print_mem_block_lists+0xcd>
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	68 80 3e 80 00       	push   $0x803e80
  801e65:	e8 b4 e7 ff ff       	call   80061e <cprintf>
  801e6a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e74:	83 ec 0c             	sub    $0xc,%esp
  801e77:	68 a4 3e 80 00       	push   $0x803ea4
  801e7c:	e8 9d e7 ff ff       	call   80061e <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e84:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e88:	a1 40 40 80 00       	mov    0x804040,%eax
  801e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e90:	eb 56                	jmp    801ee8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e96:	74 1c                	je     801eb4 <print_mem_block_lists+0x114>
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 50 08             	mov    0x8(%eax),%edx
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	8b 48 08             	mov    0x8(%eax),%ecx
  801ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaa:	01 c8                	add    %ecx,%eax
  801eac:	39 c2                	cmp    %eax,%edx
  801eae:	73 04                	jae    801eb4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801eb0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 50 08             	mov    0x8(%eax),%edx
  801eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec0:	01 c2                	add    %eax,%edx
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	8b 40 08             	mov    0x8(%eax),%eax
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	52                   	push   %edx
  801ecc:	50                   	push   %eax
  801ecd:	68 71 3e 80 00       	push   $0x803e71
  801ed2:	e8 47 e7 ff ff       	call   80061e <cprintf>
  801ed7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee0:	a1 48 40 80 00       	mov    0x804048,%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eec:	74 07                	je     801ef5 <print_mem_block_lists+0x155>
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	8b 00                	mov    (%eax),%eax
  801ef3:	eb 05                	jmp    801efa <print_mem_block_lists+0x15a>
  801ef5:	b8 00 00 00 00       	mov    $0x0,%eax
  801efa:	a3 48 40 80 00       	mov    %eax,0x804048
  801eff:	a1 48 40 80 00       	mov    0x804048,%eax
  801f04:	85 c0                	test   %eax,%eax
  801f06:	75 8a                	jne    801e92 <print_mem_block_lists+0xf2>
  801f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0c:	75 84                	jne    801e92 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f0e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f12:	75 10                	jne    801f24 <print_mem_block_lists+0x184>
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 bc 3e 80 00       	push   $0x803ebc
  801f1c:	e8 fd e6 ff ff       	call   80061e <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f24:	83 ec 0c             	sub    $0xc,%esp
  801f27:	68 30 3e 80 00       	push   $0x803e30
  801f2c:	e8 ed e6 ff ff       	call   80061e <cprintf>
  801f31:	83 c4 10             	add    $0x10,%esp

}
  801f34:	90                   	nop
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f3d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f44:	00 00 00 
  801f47:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f4e:	00 00 00 
  801f51:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f58:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f62:	e9 9e 00 00 00       	jmp    802005 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f67:	a1 50 40 80 00       	mov    0x804050,%eax
  801f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6f:	c1 e2 04             	shl    $0x4,%edx
  801f72:	01 d0                	add    %edx,%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 14                	jne    801f8c <initialize_MemBlocksList+0x55>
  801f78:	83 ec 04             	sub    $0x4,%esp
  801f7b:	68 e4 3e 80 00       	push   $0x803ee4
  801f80:	6a 46                	push   $0x46
  801f82:	68 07 3f 80 00       	push   $0x803f07
  801f87:	e8 de e3 ff ff       	call   80036a <_panic>
  801f8c:	a1 50 40 80 00       	mov    0x804050,%eax
  801f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f94:	c1 e2 04             	shl    $0x4,%edx
  801f97:	01 d0                	add    %edx,%eax
  801f99:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f9f:	89 10                	mov    %edx,(%eax)
  801fa1:	8b 00                	mov    (%eax),%eax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	74 18                	je     801fbf <initialize_MemBlocksList+0x88>
  801fa7:	a1 48 41 80 00       	mov    0x804148,%eax
  801fac:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801fb2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fb5:	c1 e1 04             	shl    $0x4,%ecx
  801fb8:	01 ca                	add    %ecx,%edx
  801fba:	89 50 04             	mov    %edx,0x4(%eax)
  801fbd:	eb 12                	jmp    801fd1 <initialize_MemBlocksList+0x9a>
  801fbf:	a1 50 40 80 00       	mov    0x804050,%eax
  801fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc7:	c1 e2 04             	shl    $0x4,%edx
  801fca:	01 d0                	add    %edx,%eax
  801fcc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fd1:	a1 50 40 80 00       	mov    0x804050,%eax
  801fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd9:	c1 e2 04             	shl    $0x4,%edx
  801fdc:	01 d0                	add    %edx,%eax
  801fde:	a3 48 41 80 00       	mov    %eax,0x804148
  801fe3:	a1 50 40 80 00       	mov    0x804050,%eax
  801fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801feb:	c1 e2 04             	shl    $0x4,%edx
  801fee:	01 d0                	add    %edx,%eax
  801ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ff7:	a1 54 41 80 00       	mov    0x804154,%eax
  801ffc:	40                   	inc    %eax
  801ffd:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802002:	ff 45 f4             	incl   -0xc(%ebp)
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	3b 45 08             	cmp    0x8(%ebp),%eax
  80200b:	0f 82 56 ff ff ff    	jb     801f67 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802011:	90                   	nop
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	8b 00                	mov    (%eax),%eax
  80201f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802022:	eb 19                	jmp    80203d <find_block+0x29>
	{
		if(va==point->sva)
  802024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802027:	8b 40 08             	mov    0x8(%eax),%eax
  80202a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80202d:	75 05                	jne    802034 <find_block+0x20>
		   return point;
  80202f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802032:	eb 36                	jmp    80206a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	8b 40 08             	mov    0x8(%eax),%eax
  80203a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80203d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802041:	74 07                	je     80204a <find_block+0x36>
  802043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802046:	8b 00                	mov    (%eax),%eax
  802048:	eb 05                	jmp    80204f <find_block+0x3b>
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	8b 55 08             	mov    0x8(%ebp),%edx
  802052:	89 42 08             	mov    %eax,0x8(%edx)
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	8b 40 08             	mov    0x8(%eax),%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	75 c5                	jne    802024 <find_block+0x10>
  80205f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802063:	75 bf                	jne    802024 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802072:	a1 40 40 80 00       	mov    0x804040,%eax
  802077:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80207a:	a1 44 40 80 00       	mov    0x804044,%eax
  80207f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802085:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802088:	74 24                	je     8020ae <insert_sorted_allocList+0x42>
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	8b 50 08             	mov    0x8(%eax),%edx
  802090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802093:	8b 40 08             	mov    0x8(%eax),%eax
  802096:	39 c2                	cmp    %eax,%edx
  802098:	76 14                	jbe    8020ae <insert_sorted_allocList+0x42>
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8b 50 08             	mov    0x8(%eax),%edx
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	39 c2                	cmp    %eax,%edx
  8020a8:	0f 82 60 01 00 00    	jb     80220e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020b2:	75 65                	jne    802119 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b8:	75 14                	jne    8020ce <insert_sorted_allocList+0x62>
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	68 e4 3e 80 00       	push   $0x803ee4
  8020c2:	6a 6b                	push   $0x6b
  8020c4:	68 07 3f 80 00       	push   $0x803f07
  8020c9:	e8 9c e2 ff ff       	call   80036a <_panic>
  8020ce:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	89 10                	mov    %edx,(%eax)
  8020d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dc:	8b 00                	mov    (%eax),%eax
  8020de:	85 c0                	test   %eax,%eax
  8020e0:	74 0d                	je     8020ef <insert_sorted_allocList+0x83>
  8020e2:	a1 40 40 80 00       	mov    0x804040,%eax
  8020e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ea:	89 50 04             	mov    %edx,0x4(%eax)
  8020ed:	eb 08                	jmp    8020f7 <insert_sorted_allocList+0x8b>
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	a3 44 40 80 00       	mov    %eax,0x804044
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802109:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80210e:	40                   	inc    %eax
  80210f:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802114:	e9 dc 01 00 00       	jmp    8022f5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 50 08             	mov    0x8(%eax),%edx
  80211f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802122:	8b 40 08             	mov    0x8(%eax),%eax
  802125:	39 c2                	cmp    %eax,%edx
  802127:	77 6c                	ja     802195 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802129:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80212d:	74 06                	je     802135 <insert_sorted_allocList+0xc9>
  80212f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802133:	75 14                	jne    802149 <insert_sorted_allocList+0xdd>
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	68 20 3f 80 00       	push   $0x803f20
  80213d:	6a 6f                	push   $0x6f
  80213f:	68 07 3f 80 00       	push   $0x803f07
  802144:	e8 21 e2 ff ff       	call   80036a <_panic>
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	8b 50 04             	mov    0x4(%eax),%edx
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80215b:	89 10                	mov    %edx,(%eax)
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	8b 40 04             	mov    0x4(%eax),%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	74 0d                	je     802174 <insert_sorted_allocList+0x108>
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	8b 40 04             	mov    0x4(%eax),%eax
  80216d:	8b 55 08             	mov    0x8(%ebp),%edx
  802170:	89 10                	mov    %edx,(%eax)
  802172:	eb 08                	jmp    80217c <insert_sorted_allocList+0x110>
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	a3 40 40 80 00       	mov    %eax,0x804040
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	8b 55 08             	mov    0x8(%ebp),%edx
  802182:	89 50 04             	mov    %edx,0x4(%eax)
  802185:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218a:	40                   	inc    %eax
  80218b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802190:	e9 60 01 00 00       	jmp    8022f5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	8b 50 08             	mov    0x8(%eax),%edx
  80219b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219e:	8b 40 08             	mov    0x8(%eax),%eax
  8021a1:	39 c2                	cmp    %eax,%edx
  8021a3:	0f 82 4c 01 00 00    	jb     8022f5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ad:	75 14                	jne    8021c3 <insert_sorted_allocList+0x157>
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 58 3f 80 00       	push   $0x803f58
  8021b7:	6a 73                	push   $0x73
  8021b9:	68 07 3f 80 00       	push   $0x803f07
  8021be:	e8 a7 e1 ff ff       	call   80036a <_panic>
  8021c3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	89 50 04             	mov    %edx,0x4(%eax)
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	8b 40 04             	mov    0x4(%eax),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 0c                	je     8021e5 <insert_sorted_allocList+0x179>
  8021d9:	a1 44 40 80 00       	mov    0x804044,%eax
  8021de:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e1:	89 10                	mov    %edx,(%eax)
  8021e3:	eb 08                	jmp    8021ed <insert_sorted_allocList+0x181>
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	a3 44 40 80 00       	mov    %eax,0x804044
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021fe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802203:	40                   	inc    %eax
  802204:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802209:	e9 e7 00 00 00       	jmp    8022f5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802214:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80221b:	a1 40 40 80 00       	mov    0x804040,%eax
  802220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802223:	e9 9d 00 00 00       	jmp    8022c5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	8b 00                	mov    (%eax),%eax
  80222d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8b 50 08             	mov    0x8(%eax),%edx
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	8b 40 08             	mov    0x8(%eax),%eax
  80223c:	39 c2                	cmp    %eax,%edx
  80223e:	76 7d                	jbe    8022bd <insert_sorted_allocList+0x251>
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	8b 50 08             	mov    0x8(%eax),%edx
  802246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802249:	8b 40 08             	mov    0x8(%eax),%eax
  80224c:	39 c2                	cmp    %eax,%edx
  80224e:	73 6d                	jae    8022bd <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802250:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802254:	74 06                	je     80225c <insert_sorted_allocList+0x1f0>
  802256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225a:	75 14                	jne    802270 <insert_sorted_allocList+0x204>
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 7c 3f 80 00       	push   $0x803f7c
  802264:	6a 7f                	push   $0x7f
  802266:	68 07 3f 80 00       	push   $0x803f07
  80226b:	e8 fa e0 ff ff       	call   80036a <_panic>
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	8b 10                	mov    (%eax),%edx
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	89 10                	mov    %edx,(%eax)
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	85 c0                	test   %eax,%eax
  802281:	74 0b                	je     80228e <insert_sorted_allocList+0x222>
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	8b 55 08             	mov    0x8(%ebp),%edx
  80228b:	89 50 04             	mov    %edx,0x4(%eax)
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 55 08             	mov    0x8(%ebp),%edx
  802294:	89 10                	mov    %edx,(%eax)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229c:	89 50 04             	mov    %edx,0x4(%eax)
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	75 08                	jne    8022b0 <insert_sorted_allocList+0x244>
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b5:	40                   	inc    %eax
  8022b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022bb:	eb 39                	jmp    8022f6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022bd:	a1 48 40 80 00       	mov    0x804048,%eax
  8022c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c9:	74 07                	je     8022d2 <insert_sorted_allocList+0x266>
  8022cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ce:	8b 00                	mov    (%eax),%eax
  8022d0:	eb 05                	jmp    8022d7 <insert_sorted_allocList+0x26b>
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d7:	a3 48 40 80 00       	mov    %eax,0x804048
  8022dc:	a1 48 40 80 00       	mov    0x804048,%eax
  8022e1:	85 c0                	test   %eax,%eax
  8022e3:	0f 85 3f ff ff ff    	jne    802228 <insert_sorted_allocList+0x1bc>
  8022e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ed:	0f 85 35 ff ff ff    	jne    802228 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022f3:	eb 01                	jmp    8022f6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022f6:	90                   	nop
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
  8022fc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802307:	e9 85 01 00 00       	jmp    802491 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 0c             	mov    0xc(%eax),%eax
  802312:	3b 45 08             	cmp    0x8(%ebp),%eax
  802315:	0f 82 6e 01 00 00    	jb     802489 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 40 0c             	mov    0xc(%eax),%eax
  802321:	3b 45 08             	cmp    0x8(%ebp),%eax
  802324:	0f 85 8a 00 00 00    	jne    8023b4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80232a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232e:	75 17                	jne    802347 <alloc_block_FF+0x4e>
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	68 b0 3f 80 00       	push   $0x803fb0
  802338:	68 93 00 00 00       	push   $0x93
  80233d:	68 07 3f 80 00       	push   $0x803f07
  802342:	e8 23 e0 ff ff       	call   80036a <_panic>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	85 c0                	test   %eax,%eax
  80234e:	74 10                	je     802360 <alloc_block_FF+0x67>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802358:	8b 52 04             	mov    0x4(%edx),%edx
  80235b:	89 50 04             	mov    %edx,0x4(%eax)
  80235e:	eb 0b                	jmp    80236b <alloc_block_FF+0x72>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 40 04             	mov    0x4(%eax),%eax
  802366:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 40 04             	mov    0x4(%eax),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	74 0f                	je     802384 <alloc_block_FF+0x8b>
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 40 04             	mov    0x4(%eax),%eax
  80237b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237e:	8b 12                	mov    (%edx),%edx
  802380:	89 10                	mov    %edx,(%eax)
  802382:	eb 0a                	jmp    80238e <alloc_block_FF+0x95>
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 00                	mov    (%eax),%eax
  802389:	a3 38 41 80 00       	mov    %eax,0x804138
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8023a6:	48                   	dec    %eax
  8023a7:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	e9 10 01 00 00       	jmp    8024c4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bd:	0f 86 c6 00 00 00    	jbe    802489 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023c3:	a1 48 41 80 00       	mov    0x804148,%eax
  8023c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 50 08             	mov    0x8(%eax),%edx
  8023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023da:	8b 55 08             	mov    0x8(%ebp),%edx
  8023dd:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e4:	75 17                	jne    8023fd <alloc_block_FF+0x104>
  8023e6:	83 ec 04             	sub    $0x4,%esp
  8023e9:	68 b0 3f 80 00       	push   $0x803fb0
  8023ee:	68 9b 00 00 00       	push   $0x9b
  8023f3:	68 07 3f 80 00       	push   $0x803f07
  8023f8:	e8 6d df ff ff       	call   80036a <_panic>
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	74 10                	je     802416 <alloc_block_FF+0x11d>
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240e:	8b 52 04             	mov    0x4(%edx),%edx
  802411:	89 50 04             	mov    %edx,0x4(%eax)
  802414:	eb 0b                	jmp    802421 <alloc_block_FF+0x128>
  802416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802419:	8b 40 04             	mov    0x4(%eax),%eax
  80241c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0f                	je     80243a <alloc_block_FF+0x141>
  80242b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242e:	8b 40 04             	mov    0x4(%eax),%eax
  802431:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802434:	8b 12                	mov    (%edx),%edx
  802436:	89 10                	mov    %edx,(%eax)
  802438:	eb 0a                	jmp    802444 <alloc_block_FF+0x14b>
  80243a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	a3 48 41 80 00       	mov    %eax,0x804148
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802450:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802457:	a1 54 41 80 00       	mov    0x804154,%eax
  80245c:	48                   	dec    %eax
  80245d:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 50 08             	mov    0x8(%eax),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	01 c2                	add    %eax,%edx
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 0c             	mov    0xc(%eax),%eax
  802479:	2b 45 08             	sub    0x8(%ebp),%eax
  80247c:	89 c2                	mov    %eax,%edx
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	eb 3b                	jmp    8024c4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802489:	a1 40 41 80 00       	mov    0x804140,%eax
  80248e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802495:	74 07                	je     80249e <alloc_block_FF+0x1a5>
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	eb 05                	jmp    8024a3 <alloc_block_FF+0x1aa>
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a3:	a3 40 41 80 00       	mov    %eax,0x804140
  8024a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	0f 85 57 fe ff ff    	jne    80230c <alloc_block_FF+0x13>
  8024b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b9:	0f 85 4d fe ff ff    	jne    80230c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024cc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024d3:	a1 38 41 80 00       	mov    0x804138,%eax
  8024d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024db:	e9 df 00 00 00       	jmp    8025bf <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e9:	0f 82 c8 00 00 00    	jb     8025b7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f8:	0f 85 8a 00 00 00    	jne    802588 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802502:	75 17                	jne    80251b <alloc_block_BF+0x55>
  802504:	83 ec 04             	sub    $0x4,%esp
  802507:	68 b0 3f 80 00       	push   $0x803fb0
  80250c:	68 b7 00 00 00       	push   $0xb7
  802511:	68 07 3f 80 00       	push   $0x803f07
  802516:	e8 4f de ff ff       	call   80036a <_panic>
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 00                	mov    (%eax),%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	74 10                	je     802534 <alloc_block_BF+0x6e>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252c:	8b 52 04             	mov    0x4(%edx),%edx
  80252f:	89 50 04             	mov    %edx,0x4(%eax)
  802532:	eb 0b                	jmp    80253f <alloc_block_BF+0x79>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 04             	mov    0x4(%eax),%eax
  80253a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 40 04             	mov    0x4(%eax),%eax
  802545:	85 c0                	test   %eax,%eax
  802547:	74 0f                	je     802558 <alloc_block_BF+0x92>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 04             	mov    0x4(%eax),%eax
  80254f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802552:	8b 12                	mov    (%edx),%edx
  802554:	89 10                	mov    %edx,(%eax)
  802556:	eb 0a                	jmp    802562 <alloc_block_BF+0x9c>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	a3 38 41 80 00       	mov    %eax,0x804138
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802575:	a1 44 41 80 00       	mov    0x804144,%eax
  80257a:	48                   	dec    %eax
  80257b:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	e9 4d 01 00 00       	jmp    8026d5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 0c             	mov    0xc(%eax),%eax
  80258e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802591:	76 24                	jbe    8025b7 <alloc_block_BF+0xf1>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 40 0c             	mov    0xc(%eax),%eax
  802599:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80259c:	73 19                	jae    8025b7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80259e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 08             	mov    0x8(%eax),%eax
  8025b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8025bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c3:	74 07                	je     8025cc <alloc_block_BF+0x106>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	eb 05                	jmp    8025d1 <alloc_block_BF+0x10b>
  8025cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d1:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d6:	a1 40 41 80 00       	mov    0x804140,%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 85 fd fe ff ff    	jne    8024e0 <alloc_block_BF+0x1a>
  8025e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e7:	0f 85 f3 fe ff ff    	jne    8024e0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025f1:	0f 84 d9 00 00 00    	je     8026d0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f7:	a1 48 41 80 00       	mov    0x804148,%eax
  8025fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802602:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802605:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260b:	8b 55 08             	mov    0x8(%ebp),%edx
  80260e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802611:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802615:	75 17                	jne    80262e <alloc_block_BF+0x168>
  802617:	83 ec 04             	sub    $0x4,%esp
  80261a:	68 b0 3f 80 00       	push   $0x803fb0
  80261f:	68 c7 00 00 00       	push   $0xc7
  802624:	68 07 3f 80 00       	push   $0x803f07
  802629:	e8 3c dd ff ff       	call   80036a <_panic>
  80262e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	74 10                	je     802647 <alloc_block_BF+0x181>
  802637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80263f:	8b 52 04             	mov    0x4(%edx),%edx
  802642:	89 50 04             	mov    %edx,0x4(%eax)
  802645:	eb 0b                	jmp    802652 <alloc_block_BF+0x18c>
  802647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	74 0f                	je     80266b <alloc_block_BF+0x1a5>
  80265c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265f:	8b 40 04             	mov    0x4(%eax),%eax
  802662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802665:	8b 12                	mov    (%edx),%edx
  802667:	89 10                	mov    %edx,(%eax)
  802669:	eb 0a                	jmp    802675 <alloc_block_BF+0x1af>
  80266b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	a3 48 41 80 00       	mov    %eax,0x804148
  802675:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802678:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802681:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802688:	a1 54 41 80 00       	mov    0x804154,%eax
  80268d:	48                   	dec    %eax
  80268e:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802693:	83 ec 08             	sub    $0x8,%esp
  802696:	ff 75 ec             	pushl  -0x14(%ebp)
  802699:	68 38 41 80 00       	push   $0x804138
  80269e:	e8 71 f9 ff ff       	call   802014 <find_block>
  8026a3:	83 c4 10             	add    $0x10,%esp
  8026a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ac:	8b 50 08             	mov    0x8(%eax),%edx
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	01 c2                	add    %eax,%edx
  8026b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c3:	89 c2                	mov    %eax,%edx
  8026c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ce:	eb 05                	jmp    8026d5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    

008026d7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026d7:	55                   	push   %ebp
  8026d8:	89 e5                	mov    %esp,%ebp
  8026da:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026dd:	a1 28 40 80 00       	mov    0x804028,%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	0f 85 de 01 00 00    	jne    8028c8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026ea:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	e9 9e 01 00 00       	jmp    802895 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802700:	0f 82 87 01 00 00    	jb     80288d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 40 0c             	mov    0xc(%eax),%eax
  80270c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270f:	0f 85 95 00 00 00    	jne    8027aa <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802719:	75 17                	jne    802732 <alloc_block_NF+0x5b>
  80271b:	83 ec 04             	sub    $0x4,%esp
  80271e:	68 b0 3f 80 00       	push   $0x803fb0
  802723:	68 e0 00 00 00       	push   $0xe0
  802728:	68 07 3f 80 00       	push   $0x803f07
  80272d:	e8 38 dc ff ff       	call   80036a <_panic>
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	74 10                	je     80274b <alloc_block_NF+0x74>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802743:	8b 52 04             	mov    0x4(%edx),%edx
  802746:	89 50 04             	mov    %edx,0x4(%eax)
  802749:	eb 0b                	jmp    802756 <alloc_block_NF+0x7f>
  80274b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274e:	8b 40 04             	mov    0x4(%eax),%eax
  802751:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 0f                	je     80276f <alloc_block_NF+0x98>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802769:	8b 12                	mov    (%edx),%edx
  80276b:	89 10                	mov    %edx,(%eax)
  80276d:	eb 0a                	jmp    802779 <alloc_block_NF+0xa2>
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 00                	mov    (%eax),%eax
  802774:	a3 38 41 80 00       	mov    %eax,0x804138
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278c:	a1 44 41 80 00       	mov    0x804144,%eax
  802791:	48                   	dec    %eax
  802792:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 40 08             	mov    0x8(%eax),%eax
  80279d:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	e9 f8 04 00 00       	jmp    802ca2 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b3:	0f 86 d4 00 00 00    	jbe    80288d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8027be:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 50 08             	mov    0x8(%eax),%edx
  8027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ca:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027da:	75 17                	jne    8027f3 <alloc_block_NF+0x11c>
  8027dc:	83 ec 04             	sub    $0x4,%esp
  8027df:	68 b0 3f 80 00       	push   $0x803fb0
  8027e4:	68 e9 00 00 00       	push   $0xe9
  8027e9:	68 07 3f 80 00       	push   $0x803f07
  8027ee:	e8 77 db ff ff       	call   80036a <_panic>
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	74 10                	je     80280c <alloc_block_NF+0x135>
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802804:	8b 52 04             	mov    0x4(%edx),%edx
  802807:	89 50 04             	mov    %edx,0x4(%eax)
  80280a:	eb 0b                	jmp    802817 <alloc_block_NF+0x140>
  80280c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280f:	8b 40 04             	mov    0x4(%eax),%eax
  802812:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281a:	8b 40 04             	mov    0x4(%eax),%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	74 0f                	je     802830 <alloc_block_NF+0x159>
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	8b 40 04             	mov    0x4(%eax),%eax
  802827:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80282a:	8b 12                	mov    (%edx),%edx
  80282c:	89 10                	mov    %edx,(%eax)
  80282e:	eb 0a                	jmp    80283a <alloc_block_NF+0x163>
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 00                	mov    (%eax),%eax
  802835:	a3 48 41 80 00       	mov    %eax,0x804148
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284d:	a1 54 41 80 00       	mov    0x804154,%eax
  802852:	48                   	dec    %eax
  802853:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 40 08             	mov    0x8(%eax),%eax
  80285e:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 50 08             	mov    0x8(%eax),%edx
  802869:	8b 45 08             	mov    0x8(%ebp),%eax
  80286c:	01 c2                	add    %eax,%edx
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	2b 45 08             	sub    0x8(%ebp),%eax
  80287d:	89 c2                	mov    %eax,%edx
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	e9 15 04 00 00       	jmp    802ca2 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80288d:	a1 40 41 80 00       	mov    0x804140,%eax
  802892:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802899:	74 07                	je     8028a2 <alloc_block_NF+0x1cb>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	eb 05                	jmp    8028a7 <alloc_block_NF+0x1d0>
  8028a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a7:	a3 40 41 80 00       	mov    %eax,0x804140
  8028ac:	a1 40 41 80 00       	mov    0x804140,%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	0f 85 3e fe ff ff    	jne    8026f7 <alloc_block_NF+0x20>
  8028b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bd:	0f 85 34 fe ff ff    	jne    8026f7 <alloc_block_NF+0x20>
  8028c3:	e9 d5 03 00 00       	jmp    802c9d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d0:	e9 b1 01 00 00       	jmp    802a86 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 50 08             	mov    0x8(%eax),%edx
  8028db:	a1 28 40 80 00       	mov    0x804028,%eax
  8028e0:	39 c2                	cmp    %eax,%edx
  8028e2:	0f 82 96 01 00 00    	jb     802a7e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f1:	0f 82 87 01 00 00    	jb     802a7e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802900:	0f 85 95 00 00 00    	jne    80299b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802906:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290a:	75 17                	jne    802923 <alloc_block_NF+0x24c>
  80290c:	83 ec 04             	sub    $0x4,%esp
  80290f:	68 b0 3f 80 00       	push   $0x803fb0
  802914:	68 fc 00 00 00       	push   $0xfc
  802919:	68 07 3f 80 00       	push   $0x803f07
  80291e:	e8 47 da ff ff       	call   80036a <_panic>
  802923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	74 10                	je     80293c <alloc_block_NF+0x265>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802934:	8b 52 04             	mov    0x4(%edx),%edx
  802937:	89 50 04             	mov    %edx,0x4(%eax)
  80293a:	eb 0b                	jmp    802947 <alloc_block_NF+0x270>
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 0f                	je     802960 <alloc_block_NF+0x289>
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295a:	8b 12                	mov    (%edx),%edx
  80295c:	89 10                	mov    %edx,(%eax)
  80295e:	eb 0a                	jmp    80296a <alloc_block_NF+0x293>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	a3 38 41 80 00       	mov    %eax,0x804138
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297d:	a1 44 41 80 00       	mov    0x804144,%eax
  802982:	48                   	dec    %eax
  802983:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 08             	mov    0x8(%eax),%eax
  80298e:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	e9 07 03 00 00       	jmp    802ca2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a4:	0f 86 d4 00 00 00    	jbe    802a7e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029aa:	a1 48 41 80 00       	mov    0x804148,%eax
  8029af:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029cb:	75 17                	jne    8029e4 <alloc_block_NF+0x30d>
  8029cd:	83 ec 04             	sub    $0x4,%esp
  8029d0:	68 b0 3f 80 00       	push   $0x803fb0
  8029d5:	68 04 01 00 00       	push   $0x104
  8029da:	68 07 3f 80 00       	push   $0x803f07
  8029df:	e8 86 d9 ff ff       	call   80036a <_panic>
  8029e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 10                	je     8029fd <alloc_block_NF+0x326>
  8029ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029f5:	8b 52 04             	mov    0x4(%edx),%edx
  8029f8:	89 50 04             	mov    %edx,0x4(%eax)
  8029fb:	eb 0b                	jmp    802a08 <alloc_block_NF+0x331>
  8029fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0b:	8b 40 04             	mov    0x4(%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 0f                	je     802a21 <alloc_block_NF+0x34a>
  802a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1b:	8b 12                	mov    (%edx),%edx
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	eb 0a                	jmp    802a2b <alloc_block_NF+0x354>
  802a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	a3 48 41 80 00       	mov    %eax,0x804148
  802a2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a43:	48                   	dec    %eax
  802a44:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4c:	8b 40 08             	mov    0x8(%eax),%eax
  802a4f:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 50 08             	mov    0x8(%eax),%edx
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	01 c2                	add    %eax,%edx
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a6e:	89 c2                	mov    %eax,%edx
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a79:	e9 24 02 00 00       	jmp    802ca2 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a7e:	a1 40 41 80 00       	mov    0x804140,%eax
  802a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8a:	74 07                	je     802a93 <alloc_block_NF+0x3bc>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	eb 05                	jmp    802a98 <alloc_block_NF+0x3c1>
  802a93:	b8 00 00 00 00       	mov    $0x0,%eax
  802a98:	a3 40 41 80 00       	mov    %eax,0x804140
  802a9d:	a1 40 41 80 00       	mov    0x804140,%eax
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	0f 85 2b fe ff ff    	jne    8028d5 <alloc_block_NF+0x1fe>
  802aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aae:	0f 85 21 fe ff ff    	jne    8028d5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ab4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abc:	e9 ae 01 00 00       	jmp    802c6f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 50 08             	mov    0x8(%eax),%edx
  802ac7:	a1 28 40 80 00       	mov    0x804028,%eax
  802acc:	39 c2                	cmp    %eax,%edx
  802ace:	0f 83 93 01 00 00    	jae    802c67 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 0c             	mov    0xc(%eax),%eax
  802ada:	3b 45 08             	cmp    0x8(%ebp),%eax
  802add:	0f 82 84 01 00 00    	jb     802c67 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aec:	0f 85 95 00 00 00    	jne    802b87 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af6:	75 17                	jne    802b0f <alloc_block_NF+0x438>
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	68 b0 3f 80 00       	push   $0x803fb0
  802b00:	68 14 01 00 00       	push   $0x114
  802b05:	68 07 3f 80 00       	push   $0x803f07
  802b0a:	e8 5b d8 ff ff       	call   80036a <_panic>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	74 10                	je     802b28 <alloc_block_NF+0x451>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b20:	8b 52 04             	mov    0x4(%edx),%edx
  802b23:	89 50 04             	mov    %edx,0x4(%eax)
  802b26:	eb 0b                	jmp    802b33 <alloc_block_NF+0x45c>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 0f                	je     802b4c <alloc_block_NF+0x475>
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b46:	8b 12                	mov    (%edx),%edx
  802b48:	89 10                	mov    %edx,(%eax)
  802b4a:	eb 0a                	jmp    802b56 <alloc_block_NF+0x47f>
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 00                	mov    (%eax),%eax
  802b51:	a3 38 41 80 00       	mov    %eax,0x804138
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b69:	a1 44 41 80 00       	mov    0x804144,%eax
  802b6e:	48                   	dec    %eax
  802b6f:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 40 08             	mov    0x8(%eax),%eax
  802b7a:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	e9 1b 01 00 00       	jmp    802ca2 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b90:	0f 86 d1 00 00 00    	jbe    802c67 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b96:	a1 48 41 80 00       	mov    0x804148,%eax
  802b9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 50 08             	mov    0x8(%eax),%edx
  802ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bb7:	75 17                	jne    802bd0 <alloc_block_NF+0x4f9>
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	68 b0 3f 80 00       	push   $0x803fb0
  802bc1:	68 1c 01 00 00       	push   $0x11c
  802bc6:	68 07 3f 80 00       	push   $0x803f07
  802bcb:	e8 9a d7 ff ff       	call   80036a <_panic>
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 10                	je     802be9 <alloc_block_NF+0x512>
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802be1:	8b 52 04             	mov    0x4(%edx),%edx
  802be4:	89 50 04             	mov    %edx,0x4(%eax)
  802be7:	eb 0b                	jmp    802bf4 <alloc_block_NF+0x51d>
  802be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf7:	8b 40 04             	mov    0x4(%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 0f                	je     802c0d <alloc_block_NF+0x536>
  802bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c01:	8b 40 04             	mov    0x4(%eax),%eax
  802c04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c07:	8b 12                	mov    (%edx),%edx
  802c09:	89 10                	mov    %edx,(%eax)
  802c0b:	eb 0a                	jmp    802c17 <alloc_block_NF+0x540>
  802c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c10:	8b 00                	mov    (%eax),%eax
  802c12:	a3 48 41 80 00       	mov    %eax,0x804148
  802c17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2a:	a1 54 41 80 00       	mov    0x804154,%eax
  802c2f:	48                   	dec    %eax
  802c30:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c38:	8b 40 08             	mov    0x8(%eax),%eax
  802c3b:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 50 08             	mov    0x8(%eax),%edx
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	01 c2                	add    %eax,%edx
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 40 0c             	mov    0xc(%eax),%eax
  802c57:	2b 45 08             	sub    0x8(%ebp),%eax
  802c5a:	89 c2                	mov    %eax,%edx
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	eb 3b                	jmp    802ca2 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c67:	a1 40 41 80 00       	mov    0x804140,%eax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	74 07                	je     802c7c <alloc_block_NF+0x5a5>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	eb 05                	jmp    802c81 <alloc_block_NF+0x5aa>
  802c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c81:	a3 40 41 80 00       	mov    %eax,0x804140
  802c86:	a1 40 41 80 00       	mov    0x804140,%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	0f 85 2e fe ff ff    	jne    802ac1 <alloc_block_NF+0x3ea>
  802c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c97:	0f 85 24 fe ff ff    	jne    802ac1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca2:	c9                   	leave  
  802ca3:	c3                   	ret    

00802ca4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ca4:	55                   	push   %ebp
  802ca5:	89 e5                	mov    %esp,%ebp
  802ca7:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802caa:	a1 38 41 80 00       	mov    0x804138,%eax
  802caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cb2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cb7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cba:	a1 38 41 80 00       	mov    0x804138,%eax
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 14                	je     802cd7 <insert_sorted_with_merge_freeList+0x33>
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 50 08             	mov    0x8(%eax),%edx
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 40 08             	mov    0x8(%eax),%eax
  802ccf:	39 c2                	cmp    %eax,%edx
  802cd1:	0f 87 9b 01 00 00    	ja     802e72 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdb:	75 17                	jne    802cf4 <insert_sorted_with_merge_freeList+0x50>
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	68 e4 3e 80 00       	push   $0x803ee4
  802ce5:	68 38 01 00 00       	push   $0x138
  802cea:	68 07 3f 80 00       	push   $0x803f07
  802cef:	e8 76 d6 ff ff       	call   80036a <_panic>
  802cf4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	89 10                	mov    %edx,(%eax)
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 0d                	je     802d15 <insert_sorted_with_merge_freeList+0x71>
  802d08:	a1 38 41 80 00       	mov    0x804138,%eax
  802d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d10:	89 50 04             	mov    %edx,0x4(%eax)
  802d13:	eb 08                	jmp    802d1d <insert_sorted_with_merge_freeList+0x79>
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	a3 38 41 80 00       	mov    %eax,0x804138
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d34:	40                   	inc    %eax
  802d35:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d3e:	0f 84 a8 06 00 00    	je     8033ec <insert_sorted_with_merge_freeList+0x748>
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 50 08             	mov    0x8(%eax),%edx
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d50:	01 c2                	add    %eax,%edx
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 40 08             	mov    0x8(%eax),%eax
  802d58:	39 c2                	cmp    %eax,%edx
  802d5a:	0f 85 8c 06 00 00    	jne    8033ec <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 50 0c             	mov    0xc(%eax),%edx
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6c:	01 c2                	add    %eax,%edx
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d78:	75 17                	jne    802d91 <insert_sorted_with_merge_freeList+0xed>
  802d7a:	83 ec 04             	sub    $0x4,%esp
  802d7d:	68 b0 3f 80 00       	push   $0x803fb0
  802d82:	68 3c 01 00 00       	push   $0x13c
  802d87:	68 07 3f 80 00       	push   $0x803f07
  802d8c:	e8 d9 d5 ff ff       	call   80036a <_panic>
  802d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 10                	je     802daa <insert_sorted_with_merge_freeList+0x106>
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da2:	8b 52 04             	mov    0x4(%edx),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	eb 0b                	jmp    802db5 <insert_sorted_with_merge_freeList+0x111>
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 40 04             	mov    0x4(%eax),%eax
  802db0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db8:	8b 40 04             	mov    0x4(%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 0f                	je     802dce <insert_sorted_with_merge_freeList+0x12a>
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	8b 40 04             	mov    0x4(%eax),%eax
  802dc5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc8:	8b 12                	mov    (%edx),%edx
  802dca:	89 10                	mov    %edx,(%eax)
  802dcc:	eb 0a                	jmp    802dd8 <insert_sorted_with_merge_freeList+0x134>
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	a3 38 41 80 00       	mov    %eax,0x804138
  802dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802deb:	a1 44 41 80 00       	mov    0x804144,%eax
  802df0:	48                   	dec    %eax
  802df1:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0e:	75 17                	jne    802e27 <insert_sorted_with_merge_freeList+0x183>
  802e10:	83 ec 04             	sub    $0x4,%esp
  802e13:	68 e4 3e 80 00       	push   $0x803ee4
  802e18:	68 3f 01 00 00       	push   $0x13f
  802e1d:	68 07 3f 80 00       	push   $0x803f07
  802e22:	e8 43 d5 ff ff       	call   80036a <_panic>
  802e27:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	89 10                	mov    %edx,(%eax)
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	74 0d                	je     802e48 <insert_sorted_with_merge_freeList+0x1a4>
  802e3b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e43:	89 50 04             	mov    %edx,0x4(%eax)
  802e46:	eb 08                	jmp    802e50 <insert_sorted_with_merge_freeList+0x1ac>
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	a3 48 41 80 00       	mov    %eax,0x804148
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e62:	a1 54 41 80 00       	mov    0x804154,%eax
  802e67:	40                   	inc    %eax
  802e68:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e6d:	e9 7a 05 00 00       	jmp    8033ec <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	8b 50 08             	mov    0x8(%eax),%edx
  802e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7b:	8b 40 08             	mov    0x8(%eax),%eax
  802e7e:	39 c2                	cmp    %eax,%edx
  802e80:	0f 82 14 01 00 00    	jb     802f9a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e89:	8b 50 08             	mov    0x8(%eax),%edx
  802e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e92:	01 c2                	add    %eax,%edx
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 40 08             	mov    0x8(%eax),%eax
  802e9a:	39 c2                	cmp    %eax,%edx
  802e9c:	0f 85 90 00 00 00    	jne    802f32 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	01 c2                	add    %eax,%edx
  802eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ece:	75 17                	jne    802ee7 <insert_sorted_with_merge_freeList+0x243>
  802ed0:	83 ec 04             	sub    $0x4,%esp
  802ed3:	68 e4 3e 80 00       	push   $0x803ee4
  802ed8:	68 49 01 00 00       	push   $0x149
  802edd:	68 07 3f 80 00       	push   $0x803f07
  802ee2:	e8 83 d4 ff ff       	call   80036a <_panic>
  802ee7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	89 10                	mov    %edx,(%eax)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 00                	mov    (%eax),%eax
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	74 0d                	je     802f08 <insert_sorted_with_merge_freeList+0x264>
  802efb:	a1 48 41 80 00       	mov    0x804148,%eax
  802f00:	8b 55 08             	mov    0x8(%ebp),%edx
  802f03:	89 50 04             	mov    %edx,0x4(%eax)
  802f06:	eb 08                	jmp    802f10 <insert_sorted_with_merge_freeList+0x26c>
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	a3 48 41 80 00       	mov    %eax,0x804148
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f22:	a1 54 41 80 00       	mov    0x804154,%eax
  802f27:	40                   	inc    %eax
  802f28:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f2d:	e9 bb 04 00 00       	jmp    8033ed <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f36:	75 17                	jne    802f4f <insert_sorted_with_merge_freeList+0x2ab>
  802f38:	83 ec 04             	sub    $0x4,%esp
  802f3b:	68 58 3f 80 00       	push   $0x803f58
  802f40:	68 4c 01 00 00       	push   $0x14c
  802f45:	68 07 3f 80 00       	push   $0x803f07
  802f4a:	e8 1b d4 ff ff       	call   80036a <_panic>
  802f4f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	89 50 04             	mov    %edx,0x4(%eax)
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 40 04             	mov    0x4(%eax),%eax
  802f61:	85 c0                	test   %eax,%eax
  802f63:	74 0c                	je     802f71 <insert_sorted_with_merge_freeList+0x2cd>
  802f65:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6d:	89 10                	mov    %edx,(%eax)
  802f6f:	eb 08                	jmp    802f79 <insert_sorted_with_merge_freeList+0x2d5>
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	a3 38 41 80 00       	mov    %eax,0x804138
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f8f:	40                   	inc    %eax
  802f90:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f95:	e9 53 04 00 00       	jmp    8033ed <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f9a:	a1 38 41 80 00       	mov    0x804138,%eax
  802f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa2:	e9 15 04 00 00       	jmp    8033bc <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 00                	mov    (%eax),%eax
  802fac:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	8b 50 08             	mov    0x8(%eax),%edx
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 86 f1 03 00 00    	jbe    8033b4 <insert_sorted_with_merge_freeList+0x710>
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	8b 40 08             	mov    0x8(%eax),%eax
  802fcf:	39 c2                	cmp    %eax,%edx
  802fd1:	0f 83 dd 03 00 00    	jae    8033b4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 50 08             	mov    0x8(%eax),%edx
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	01 c2                	add    %eax,%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 08             	mov    0x8(%eax),%eax
  802feb:	39 c2                	cmp    %eax,%edx
  802fed:	0f 85 b9 01 00 00    	jne    8031ac <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	8b 50 08             	mov    0x8(%eax),%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fff:	01 c2                	add    %eax,%edx
  803001:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803004:	8b 40 08             	mov    0x8(%eax),%eax
  803007:	39 c2                	cmp    %eax,%edx
  803009:	0f 85 0d 01 00 00    	jne    80311c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 50 0c             	mov    0xc(%eax),%edx
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	01 c2                	add    %eax,%edx
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803023:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803027:	75 17                	jne    803040 <insert_sorted_with_merge_freeList+0x39c>
  803029:	83 ec 04             	sub    $0x4,%esp
  80302c:	68 b0 3f 80 00       	push   $0x803fb0
  803031:	68 5c 01 00 00       	push   $0x15c
  803036:	68 07 3f 80 00       	push   $0x803f07
  80303b:	e8 2a d3 ff ff       	call   80036a <_panic>
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	74 10                	je     803059 <insert_sorted_with_merge_freeList+0x3b5>
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803051:	8b 52 04             	mov    0x4(%edx),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 0b                	jmp    803064 <insert_sorted_with_merge_freeList+0x3c0>
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	8b 40 04             	mov    0x4(%eax),%eax
  80305f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803067:	8b 40 04             	mov    0x4(%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 0f                	je     80307d <insert_sorted_with_merge_freeList+0x3d9>
  80306e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803071:	8b 40 04             	mov    0x4(%eax),%eax
  803074:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803077:	8b 12                	mov    (%edx),%edx
  803079:	89 10                	mov    %edx,(%eax)
  80307b:	eb 0a                	jmp    803087 <insert_sorted_with_merge_freeList+0x3e3>
  80307d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	a3 38 41 80 00       	mov    %eax,0x804138
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309a:	a1 44 41 80 00       	mov    0x804144,%eax
  80309f:	48                   	dec    %eax
  8030a0:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  8030a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030bd:	75 17                	jne    8030d6 <insert_sorted_with_merge_freeList+0x432>
  8030bf:	83 ec 04             	sub    $0x4,%esp
  8030c2:	68 e4 3e 80 00       	push   $0x803ee4
  8030c7:	68 5f 01 00 00       	push   $0x15f
  8030cc:	68 07 3f 80 00       	push   $0x803f07
  8030d1:	e8 94 d2 ff ff       	call   80036a <_panic>
  8030d6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	89 10                	mov    %edx,(%eax)
  8030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	85 c0                	test   %eax,%eax
  8030e8:	74 0d                	je     8030f7 <insert_sorted_with_merge_freeList+0x453>
  8030ea:	a1 48 41 80 00       	mov    0x804148,%eax
  8030ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f2:	89 50 04             	mov    %edx,0x4(%eax)
  8030f5:	eb 08                	jmp    8030ff <insert_sorted_with_merge_freeList+0x45b>
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803102:	a3 48 41 80 00       	mov    %eax,0x804148
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803111:	a1 54 41 80 00       	mov    0x804154,%eax
  803116:	40                   	inc    %eax
  803117:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	8b 50 0c             	mov    0xc(%eax),%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 40 0c             	mov    0xc(%eax),%eax
  803128:	01 c2                	add    %eax,%edx
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803144:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803148:	75 17                	jne    803161 <insert_sorted_with_merge_freeList+0x4bd>
  80314a:	83 ec 04             	sub    $0x4,%esp
  80314d:	68 e4 3e 80 00       	push   $0x803ee4
  803152:	68 64 01 00 00       	push   $0x164
  803157:	68 07 3f 80 00       	push   $0x803f07
  80315c:	e8 09 d2 ff ff       	call   80036a <_panic>
  803161:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803167:	8b 45 08             	mov    0x8(%ebp),%eax
  80316a:	89 10                	mov    %edx,(%eax)
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	74 0d                	je     803182 <insert_sorted_with_merge_freeList+0x4de>
  803175:	a1 48 41 80 00       	mov    0x804148,%eax
  80317a:	8b 55 08             	mov    0x8(%ebp),%edx
  80317d:	89 50 04             	mov    %edx,0x4(%eax)
  803180:	eb 08                	jmp    80318a <insert_sorted_with_merge_freeList+0x4e6>
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	a3 48 41 80 00       	mov    %eax,0x804148
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80319c:	a1 54 41 80 00       	mov    0x804154,%eax
  8031a1:	40                   	inc    %eax
  8031a2:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031a7:	e9 41 02 00 00       	jmp    8033ed <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	8b 50 08             	mov    0x8(%eax),%edx
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b8:	01 c2                	add    %eax,%edx
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	0f 85 7c 01 00 00    	jne    803344 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031c8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031cc:	74 06                	je     8031d4 <insert_sorted_with_merge_freeList+0x530>
  8031ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d2:	75 17                	jne    8031eb <insert_sorted_with_merge_freeList+0x547>
  8031d4:	83 ec 04             	sub    $0x4,%esp
  8031d7:	68 20 3f 80 00       	push   $0x803f20
  8031dc:	68 69 01 00 00       	push   $0x169
  8031e1:	68 07 3f 80 00       	push   $0x803f07
  8031e6:	e8 7f d1 ff ff       	call   80036a <_panic>
  8031eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ee:	8b 50 04             	mov    0x4(%eax),%edx
  8031f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f4:	89 50 04             	mov    %edx,0x4(%eax)
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fd:	89 10                	mov    %edx,(%eax)
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 40 04             	mov    0x4(%eax),%eax
  803205:	85 c0                	test   %eax,%eax
  803207:	74 0d                	je     803216 <insert_sorted_with_merge_freeList+0x572>
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	8b 40 04             	mov    0x4(%eax),%eax
  80320f:	8b 55 08             	mov    0x8(%ebp),%edx
  803212:	89 10                	mov    %edx,(%eax)
  803214:	eb 08                	jmp    80321e <insert_sorted_with_merge_freeList+0x57a>
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	a3 38 41 80 00       	mov    %eax,0x804138
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	8b 55 08             	mov    0x8(%ebp),%edx
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	a1 44 41 80 00       	mov    0x804144,%eax
  80322c:	40                   	inc    %eax
  80322d:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	8b 50 0c             	mov    0xc(%eax),%edx
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	01 c2                	add    %eax,%edx
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803246:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80324a:	75 17                	jne    803263 <insert_sorted_with_merge_freeList+0x5bf>
  80324c:	83 ec 04             	sub    $0x4,%esp
  80324f:	68 b0 3f 80 00       	push   $0x803fb0
  803254:	68 6b 01 00 00       	push   $0x16b
  803259:	68 07 3f 80 00       	push   $0x803f07
  80325e:	e8 07 d1 ff ff       	call   80036a <_panic>
  803263:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803266:	8b 00                	mov    (%eax),%eax
  803268:	85 c0                	test   %eax,%eax
  80326a:	74 10                	je     80327c <insert_sorted_with_merge_freeList+0x5d8>
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803274:	8b 52 04             	mov    0x4(%edx),%edx
  803277:	89 50 04             	mov    %edx,0x4(%eax)
  80327a:	eb 0b                	jmp    803287 <insert_sorted_with_merge_freeList+0x5e3>
  80327c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327f:	8b 40 04             	mov    0x4(%eax),%eax
  803282:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328a:	8b 40 04             	mov    0x4(%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 0f                	je     8032a0 <insert_sorted_with_merge_freeList+0x5fc>
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 40 04             	mov    0x4(%eax),%eax
  803297:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80329a:	8b 12                	mov    (%edx),%edx
  80329c:	89 10                	mov    %edx,(%eax)
  80329e:	eb 0a                	jmp    8032aa <insert_sorted_with_merge_freeList+0x606>
  8032a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a3:	8b 00                	mov    (%eax),%eax
  8032a5:	a3 38 41 80 00       	mov    %eax,0x804138
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bd:	a1 44 41 80 00       	mov    0x804144,%eax
  8032c2:	48                   	dec    %eax
  8032c3:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e0:	75 17                	jne    8032f9 <insert_sorted_with_merge_freeList+0x655>
  8032e2:	83 ec 04             	sub    $0x4,%esp
  8032e5:	68 e4 3e 80 00       	push   $0x803ee4
  8032ea:	68 6e 01 00 00       	push   $0x16e
  8032ef:	68 07 3f 80 00       	push   $0x803f07
  8032f4:	e8 71 d0 ff ff       	call   80036a <_panic>
  8032f9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	89 10                	mov    %edx,(%eax)
  803304:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803307:	8b 00                	mov    (%eax),%eax
  803309:	85 c0                	test   %eax,%eax
  80330b:	74 0d                	je     80331a <insert_sorted_with_merge_freeList+0x676>
  80330d:	a1 48 41 80 00       	mov    0x804148,%eax
  803312:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803315:	89 50 04             	mov    %edx,0x4(%eax)
  803318:	eb 08                	jmp    803322 <insert_sorted_with_merge_freeList+0x67e>
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	a3 48 41 80 00       	mov    %eax,0x804148
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803334:	a1 54 41 80 00       	mov    0x804154,%eax
  803339:	40                   	inc    %eax
  80333a:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80333f:	e9 a9 00 00 00       	jmp    8033ed <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803348:	74 06                	je     803350 <insert_sorted_with_merge_freeList+0x6ac>
  80334a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334e:	75 17                	jne    803367 <insert_sorted_with_merge_freeList+0x6c3>
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	68 7c 3f 80 00       	push   $0x803f7c
  803358:	68 73 01 00 00       	push   $0x173
  80335d:	68 07 3f 80 00       	push   $0x803f07
  803362:	e8 03 d0 ff ff       	call   80036a <_panic>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 10                	mov    (%eax),%edx
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	89 10                	mov    %edx,(%eax)
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	8b 00                	mov    (%eax),%eax
  803376:	85 c0                	test   %eax,%eax
  803378:	74 0b                	je     803385 <insert_sorted_with_merge_freeList+0x6e1>
  80337a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	8b 55 08             	mov    0x8(%ebp),%edx
  803382:	89 50 04             	mov    %edx,0x4(%eax)
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 55 08             	mov    0x8(%ebp),%edx
  80338b:	89 10                	mov    %edx,(%eax)
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803393:	89 50 04             	mov    %edx,0x4(%eax)
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	85 c0                	test   %eax,%eax
  80339d:	75 08                	jne    8033a7 <insert_sorted_with_merge_freeList+0x703>
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8033a7:	a1 44 41 80 00       	mov    0x804144,%eax
  8033ac:	40                   	inc    %eax
  8033ad:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8033b2:	eb 39                	jmp    8033ed <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033b4:	a1 40 41 80 00       	mov    0x804140,%eax
  8033b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c0:	74 07                	je     8033c9 <insert_sorted_with_merge_freeList+0x725>
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	8b 00                	mov    (%eax),%eax
  8033c7:	eb 05                	jmp    8033ce <insert_sorted_with_merge_freeList+0x72a>
  8033c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ce:	a3 40 41 80 00       	mov    %eax,0x804140
  8033d3:	a1 40 41 80 00       	mov    0x804140,%eax
  8033d8:	85 c0                	test   %eax,%eax
  8033da:	0f 85 c7 fb ff ff    	jne    802fa7 <insert_sorted_with_merge_freeList+0x303>
  8033e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e4:	0f 85 bd fb ff ff    	jne    802fa7 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ea:	eb 01                	jmp    8033ed <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033ec:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ed:	90                   	nop
  8033ee:	c9                   	leave  
  8033ef:	c3                   	ret    

008033f0 <__udivdi3>:
  8033f0:	55                   	push   %ebp
  8033f1:	57                   	push   %edi
  8033f2:	56                   	push   %esi
  8033f3:	53                   	push   %ebx
  8033f4:	83 ec 1c             	sub    $0x1c,%esp
  8033f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803403:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803407:	89 ca                	mov    %ecx,%edx
  803409:	89 f8                	mov    %edi,%eax
  80340b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80340f:	85 f6                	test   %esi,%esi
  803411:	75 2d                	jne    803440 <__udivdi3+0x50>
  803413:	39 cf                	cmp    %ecx,%edi
  803415:	77 65                	ja     80347c <__udivdi3+0x8c>
  803417:	89 fd                	mov    %edi,%ebp
  803419:	85 ff                	test   %edi,%edi
  80341b:	75 0b                	jne    803428 <__udivdi3+0x38>
  80341d:	b8 01 00 00 00       	mov    $0x1,%eax
  803422:	31 d2                	xor    %edx,%edx
  803424:	f7 f7                	div    %edi
  803426:	89 c5                	mov    %eax,%ebp
  803428:	31 d2                	xor    %edx,%edx
  80342a:	89 c8                	mov    %ecx,%eax
  80342c:	f7 f5                	div    %ebp
  80342e:	89 c1                	mov    %eax,%ecx
  803430:	89 d8                	mov    %ebx,%eax
  803432:	f7 f5                	div    %ebp
  803434:	89 cf                	mov    %ecx,%edi
  803436:	89 fa                	mov    %edi,%edx
  803438:	83 c4 1c             	add    $0x1c,%esp
  80343b:	5b                   	pop    %ebx
  80343c:	5e                   	pop    %esi
  80343d:	5f                   	pop    %edi
  80343e:	5d                   	pop    %ebp
  80343f:	c3                   	ret    
  803440:	39 ce                	cmp    %ecx,%esi
  803442:	77 28                	ja     80346c <__udivdi3+0x7c>
  803444:	0f bd fe             	bsr    %esi,%edi
  803447:	83 f7 1f             	xor    $0x1f,%edi
  80344a:	75 40                	jne    80348c <__udivdi3+0x9c>
  80344c:	39 ce                	cmp    %ecx,%esi
  80344e:	72 0a                	jb     80345a <__udivdi3+0x6a>
  803450:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803454:	0f 87 9e 00 00 00    	ja     8034f8 <__udivdi3+0x108>
  80345a:	b8 01 00 00 00       	mov    $0x1,%eax
  80345f:	89 fa                	mov    %edi,%edx
  803461:	83 c4 1c             	add    $0x1c,%esp
  803464:	5b                   	pop    %ebx
  803465:	5e                   	pop    %esi
  803466:	5f                   	pop    %edi
  803467:	5d                   	pop    %ebp
  803468:	c3                   	ret    
  803469:	8d 76 00             	lea    0x0(%esi),%esi
  80346c:	31 ff                	xor    %edi,%edi
  80346e:	31 c0                	xor    %eax,%eax
  803470:	89 fa                	mov    %edi,%edx
  803472:	83 c4 1c             	add    $0x1c,%esp
  803475:	5b                   	pop    %ebx
  803476:	5e                   	pop    %esi
  803477:	5f                   	pop    %edi
  803478:	5d                   	pop    %ebp
  803479:	c3                   	ret    
  80347a:	66 90                	xchg   %ax,%ax
  80347c:	89 d8                	mov    %ebx,%eax
  80347e:	f7 f7                	div    %edi
  803480:	31 ff                	xor    %edi,%edi
  803482:	89 fa                	mov    %edi,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803491:	89 eb                	mov    %ebp,%ebx
  803493:	29 fb                	sub    %edi,%ebx
  803495:	89 f9                	mov    %edi,%ecx
  803497:	d3 e6                	shl    %cl,%esi
  803499:	89 c5                	mov    %eax,%ebp
  80349b:	88 d9                	mov    %bl,%cl
  80349d:	d3 ed                	shr    %cl,%ebp
  80349f:	89 e9                	mov    %ebp,%ecx
  8034a1:	09 f1                	or     %esi,%ecx
  8034a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034a7:	89 f9                	mov    %edi,%ecx
  8034a9:	d3 e0                	shl    %cl,%eax
  8034ab:	89 c5                	mov    %eax,%ebp
  8034ad:	89 d6                	mov    %edx,%esi
  8034af:	88 d9                	mov    %bl,%cl
  8034b1:	d3 ee                	shr    %cl,%esi
  8034b3:	89 f9                	mov    %edi,%ecx
  8034b5:	d3 e2                	shl    %cl,%edx
  8034b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034bb:	88 d9                	mov    %bl,%cl
  8034bd:	d3 e8                	shr    %cl,%eax
  8034bf:	09 c2                	or     %eax,%edx
  8034c1:	89 d0                	mov    %edx,%eax
  8034c3:	89 f2                	mov    %esi,%edx
  8034c5:	f7 74 24 0c          	divl   0xc(%esp)
  8034c9:	89 d6                	mov    %edx,%esi
  8034cb:	89 c3                	mov    %eax,%ebx
  8034cd:	f7 e5                	mul    %ebp
  8034cf:	39 d6                	cmp    %edx,%esi
  8034d1:	72 19                	jb     8034ec <__udivdi3+0xfc>
  8034d3:	74 0b                	je     8034e0 <__udivdi3+0xf0>
  8034d5:	89 d8                	mov    %ebx,%eax
  8034d7:	31 ff                	xor    %edi,%edi
  8034d9:	e9 58 ff ff ff       	jmp    803436 <__udivdi3+0x46>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034e4:	89 f9                	mov    %edi,%ecx
  8034e6:	d3 e2                	shl    %cl,%edx
  8034e8:	39 c2                	cmp    %eax,%edx
  8034ea:	73 e9                	jae    8034d5 <__udivdi3+0xe5>
  8034ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034ef:	31 ff                	xor    %edi,%edi
  8034f1:	e9 40 ff ff ff       	jmp    803436 <__udivdi3+0x46>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	31 c0                	xor    %eax,%eax
  8034fa:	e9 37 ff ff ff       	jmp    803436 <__udivdi3+0x46>
  8034ff:	90                   	nop

00803500 <__umoddi3>:
  803500:	55                   	push   %ebp
  803501:	57                   	push   %edi
  803502:	56                   	push   %esi
  803503:	53                   	push   %ebx
  803504:	83 ec 1c             	sub    $0x1c,%esp
  803507:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80350b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80350f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803513:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803517:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80351b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80351f:	89 f3                	mov    %esi,%ebx
  803521:	89 fa                	mov    %edi,%edx
  803523:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803527:	89 34 24             	mov    %esi,(%esp)
  80352a:	85 c0                	test   %eax,%eax
  80352c:	75 1a                	jne    803548 <__umoddi3+0x48>
  80352e:	39 f7                	cmp    %esi,%edi
  803530:	0f 86 a2 00 00 00    	jbe    8035d8 <__umoddi3+0xd8>
  803536:	89 c8                	mov    %ecx,%eax
  803538:	89 f2                	mov    %esi,%edx
  80353a:	f7 f7                	div    %edi
  80353c:	89 d0                	mov    %edx,%eax
  80353e:	31 d2                	xor    %edx,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	39 f0                	cmp    %esi,%eax
  80354a:	0f 87 ac 00 00 00    	ja     8035fc <__umoddi3+0xfc>
  803550:	0f bd e8             	bsr    %eax,%ebp
  803553:	83 f5 1f             	xor    $0x1f,%ebp
  803556:	0f 84 ac 00 00 00    	je     803608 <__umoddi3+0x108>
  80355c:	bf 20 00 00 00       	mov    $0x20,%edi
  803561:	29 ef                	sub    %ebp,%edi
  803563:	89 fe                	mov    %edi,%esi
  803565:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803569:	89 e9                	mov    %ebp,%ecx
  80356b:	d3 e0                	shl    %cl,%eax
  80356d:	89 d7                	mov    %edx,%edi
  80356f:	89 f1                	mov    %esi,%ecx
  803571:	d3 ef                	shr    %cl,%edi
  803573:	09 c7                	or     %eax,%edi
  803575:	89 e9                	mov    %ebp,%ecx
  803577:	d3 e2                	shl    %cl,%edx
  803579:	89 14 24             	mov    %edx,(%esp)
  80357c:	89 d8                	mov    %ebx,%eax
  80357e:	d3 e0                	shl    %cl,%eax
  803580:	89 c2                	mov    %eax,%edx
  803582:	8b 44 24 08          	mov    0x8(%esp),%eax
  803586:	d3 e0                	shl    %cl,%eax
  803588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80358c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803590:	89 f1                	mov    %esi,%ecx
  803592:	d3 e8                	shr    %cl,%eax
  803594:	09 d0                	or     %edx,%eax
  803596:	d3 eb                	shr    %cl,%ebx
  803598:	89 da                	mov    %ebx,%edx
  80359a:	f7 f7                	div    %edi
  80359c:	89 d3                	mov    %edx,%ebx
  80359e:	f7 24 24             	mull   (%esp)
  8035a1:	89 c6                	mov    %eax,%esi
  8035a3:	89 d1                	mov    %edx,%ecx
  8035a5:	39 d3                	cmp    %edx,%ebx
  8035a7:	0f 82 87 00 00 00    	jb     803634 <__umoddi3+0x134>
  8035ad:	0f 84 91 00 00 00    	je     803644 <__umoddi3+0x144>
  8035b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035b7:	29 f2                	sub    %esi,%edx
  8035b9:	19 cb                	sbb    %ecx,%ebx
  8035bb:	89 d8                	mov    %ebx,%eax
  8035bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035c1:	d3 e0                	shl    %cl,%eax
  8035c3:	89 e9                	mov    %ebp,%ecx
  8035c5:	d3 ea                	shr    %cl,%edx
  8035c7:	09 d0                	or     %edx,%eax
  8035c9:	89 e9                	mov    %ebp,%ecx
  8035cb:	d3 eb                	shr    %cl,%ebx
  8035cd:	89 da                	mov    %ebx,%edx
  8035cf:	83 c4 1c             	add    $0x1c,%esp
  8035d2:	5b                   	pop    %ebx
  8035d3:	5e                   	pop    %esi
  8035d4:	5f                   	pop    %edi
  8035d5:	5d                   	pop    %ebp
  8035d6:	c3                   	ret    
  8035d7:	90                   	nop
  8035d8:	89 fd                	mov    %edi,%ebp
  8035da:	85 ff                	test   %edi,%edi
  8035dc:	75 0b                	jne    8035e9 <__umoddi3+0xe9>
  8035de:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e3:	31 d2                	xor    %edx,%edx
  8035e5:	f7 f7                	div    %edi
  8035e7:	89 c5                	mov    %eax,%ebp
  8035e9:	89 f0                	mov    %esi,%eax
  8035eb:	31 d2                	xor    %edx,%edx
  8035ed:	f7 f5                	div    %ebp
  8035ef:	89 c8                	mov    %ecx,%eax
  8035f1:	f7 f5                	div    %ebp
  8035f3:	89 d0                	mov    %edx,%eax
  8035f5:	e9 44 ff ff ff       	jmp    80353e <__umoddi3+0x3e>
  8035fa:	66 90                	xchg   %ax,%ax
  8035fc:	89 c8                	mov    %ecx,%eax
  8035fe:	89 f2                	mov    %esi,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	3b 04 24             	cmp    (%esp),%eax
  80360b:	72 06                	jb     803613 <__umoddi3+0x113>
  80360d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803611:	77 0f                	ja     803622 <__umoddi3+0x122>
  803613:	89 f2                	mov    %esi,%edx
  803615:	29 f9                	sub    %edi,%ecx
  803617:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80361b:	89 14 24             	mov    %edx,(%esp)
  80361e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803622:	8b 44 24 04          	mov    0x4(%esp),%eax
  803626:	8b 14 24             	mov    (%esp),%edx
  803629:	83 c4 1c             	add    $0x1c,%esp
  80362c:	5b                   	pop    %ebx
  80362d:	5e                   	pop    %esi
  80362e:	5f                   	pop    %edi
  80362f:	5d                   	pop    %ebp
  803630:	c3                   	ret    
  803631:	8d 76 00             	lea    0x0(%esi),%esi
  803634:	2b 04 24             	sub    (%esp),%eax
  803637:	19 fa                	sbb    %edi,%edx
  803639:	89 d1                	mov    %edx,%ecx
  80363b:	89 c6                	mov    %eax,%esi
  80363d:	e9 71 ff ff ff       	jmp    8035b3 <__umoddi3+0xb3>
  803642:	66 90                	xchg   %ax,%ax
  803644:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803648:	72 ea                	jb     803634 <__umoddi3+0x134>
  80364a:	89 d9                	mov    %ebx,%ecx
  80364c:	e9 62 ff ff ff       	jmp    8035b3 <__umoddi3+0xb3>
