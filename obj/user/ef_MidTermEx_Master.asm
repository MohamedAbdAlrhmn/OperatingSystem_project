
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 37 80 00       	push   $0x8037c0
  80004a:	e8 a8 15 00 00       	call   8015f7 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 c2 37 80 00       	push   $0x8037c2
  80006e:	e8 84 15 00 00       	call   8015f7 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 c9 37 80 00       	push   $0x8037c9
  8000ab:	e8 7a 19 00 00       	call   801a2a <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 cb 37 80 00       	push   $0x8037cb
  8000bf:	e8 33 15 00 00       	call   8015f7 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 d9 37 80 00       	push   $0x8037d9
  8000f1:	e8 45 1a 00 00       	call   801b3b <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 50 80 00       	mov    0x805020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 e3 37 80 00       	push   $0x8037e3
  80011a:	e8 1c 1a 00 00       	call   801b3b <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 ed 37 80 00       	push   $0x8037ed
  800139:	6a 27                	push   $0x27
  80013b:	68 02 38 80 00       	push   $0x803802
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 09 1a 00 00       	call   801b59 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 2b 33 00 00       	call   80348b <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 eb 19 00 00       	call   801b59 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 1d 38 80 00       	push   $0x80381d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 2b 1a 00 00       	call   801bc2 <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 cb 37 80 00       	push   $0x8037cb
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 ee 14 00 00       	call   8016a5 <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 ad 19 00 00       	call   801b75 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 9f 19 00 00       	call   801b75 <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 b4 19 00 00       	call   801ba9 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 50 80 00       	mov    0x805020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 50 80 00       	mov    0x805020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 56 17 00 00       	call   8019b6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 4c 38 80 00       	push   $0x80384c
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 50 80 00       	mov    0x805020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 50 80 00       	mov    0x805020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 74 38 80 00       	push   $0x803874
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 50 80 00       	mov    0x805020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 9c 38 80 00       	push   $0x80389c
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 f4 38 80 00       	push   $0x8038f4
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 4c 38 80 00       	push   $0x80384c
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 d6 16 00 00       	call   8019d0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 63 18 00 00       	call   801b75 <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 b8 18 00 00       	call   801bdb <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 08 39 80 00       	push   $0x803908
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 50 80 00       	mov    0x805000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 0d 39 80 00       	push   $0x80390d
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 29 39 80 00       	push   $0x803929
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 2c 39 80 00       	push   $0x80392c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 78 39 80 00       	push   $0x803978
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 50 80 00       	mov    0x805020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 50 80 00       	mov    0x805020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 50 80 00       	mov    0x805020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 84 39 80 00       	push   $0x803984
  800487:	6a 3a                	push   $0x3a
  800489:	68 78 39 80 00       	push   $0x803978
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 d8 39 80 00       	push   $0x8039d8
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 78 39 80 00       	push   $0x803978
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 50 80 00       	mov    0x805024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 b7 12 00 00       	call   801808 <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 50 80 00       	mov    0x805024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 40 12 00 00       	call   801808 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 a4 13 00 00       	call   8019b6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 9e 13 00 00       	call   8019d0 <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 c4 2e 00 00       	call   803540 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 84 2f 00 00       	call   803650 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 54 3c 80 00       	add    $0x803c54,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 65 3c 80 00       	push   $0x803c65
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 6e 3c 80 00       	push   $0x803c6e
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 50 80 00       	mov    0x805004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 d0 3d 80 00       	push   $0x803dd0
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80139b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8013a2:	00 00 00 
  8013a5:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8013ac:	00 00 00 
  8013af:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8013b6:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013b9:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8013c0:	00 00 00 
  8013c3:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8013ca:	00 00 00 
  8013cd:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8013d4:	00 00 00 
	uint32 arr_size = 0;
  8013d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8013de:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ed:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013f2:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8013f7:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8013fe:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801401:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801408:	a1 20 51 80 00       	mov    0x805120,%eax
  80140d:	c1 e0 04             	shl    $0x4,%eax
  801410:	89 c2                	mov    %eax,%edx
  801412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801415:	01 d0                	add    %edx,%eax
  801417:	48                   	dec    %eax
  801418:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80141b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80141e:	ba 00 00 00 00       	mov    $0x0,%edx
  801423:	f7 75 ec             	divl   -0x14(%ebp)
  801426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801429:	29 d0                	sub    %edx,%eax
  80142b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80142e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	6a 06                	push   $0x6
  801447:	ff 75 f4             	pushl  -0xc(%ebp)
  80144a:	50                   	push   %eax
  80144b:	e8 fc 04 00 00       	call   80194c <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 51 80 00       	mov    0x805120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 71 0b 00 00       	call   801fd2 <initialize_MemBlocksList>
  801461:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801464:	a1 48 51 80 00       	mov    0x805148,%eax
  801469:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80146c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801476:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801479:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801480:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801484:	75 14                	jne    80149a <initialize_dyn_block_system+0x105>
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	68 f5 3d 80 00       	push   $0x803df5
  80148e:	6a 33                	push   $0x33
  801490:	68 13 3e 80 00       	push   $0x803e13
  801495:	e8 8c ee ff ff       	call   800326 <_panic>
  80149a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149d:	8b 00                	mov    (%eax),%eax
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 10                	je     8014b3 <initialize_dyn_block_system+0x11e>
  8014a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a6:	8b 00                	mov    (%eax),%eax
  8014a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014ab:	8b 52 04             	mov    0x4(%edx),%edx
  8014ae:	89 50 04             	mov    %edx,0x4(%eax)
  8014b1:	eb 0b                	jmp    8014be <initialize_dyn_block_system+0x129>
  8014b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b6:	8b 40 04             	mov    0x4(%eax),%eax
  8014b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c1:	8b 40 04             	mov    0x4(%eax),%eax
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	74 0f                	je     8014d7 <initialize_dyn_block_system+0x142>
  8014c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014cb:	8b 40 04             	mov    0x4(%eax),%eax
  8014ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014d1:	8b 12                	mov    (%edx),%edx
  8014d3:	89 10                	mov    %edx,(%eax)
  8014d5:	eb 0a                	jmp    8014e1 <initialize_dyn_block_system+0x14c>
  8014d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014da:	8b 00                	mov    (%eax),%eax
  8014dc:	a3 48 51 80 00       	mov    %eax,0x805148
  8014e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8014f9:	48                   	dec    %eax
  8014fa:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8014ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801503:	75 14                	jne    801519 <initialize_dyn_block_system+0x184>
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	68 20 3e 80 00       	push   $0x803e20
  80150d:	6a 34                	push   $0x34
  80150f:	68 13 3e 80 00       	push   $0x803e13
  801514:	e8 0d ee ff ff       	call   800326 <_panic>
  801519:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	89 10                	mov    %edx,(%eax)
  801524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	85 c0                	test   %eax,%eax
  80152b:	74 0d                	je     80153a <initialize_dyn_block_system+0x1a5>
  80152d:	a1 38 51 80 00       	mov    0x805138,%eax
  801532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801535:	89 50 04             	mov    %edx,0x4(%eax)
  801538:	eb 08                	jmp    801542 <initialize_dyn_block_system+0x1ad>
  80153a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801545:	a3 38 51 80 00       	mov    %eax,0x805138
  80154a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801554:	a1 44 51 80 00       	mov    0x805144,%eax
  801559:	40                   	inc    %eax
  80155a:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80155f:	90                   	nop
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801568:	e8 f7 fd ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  80156d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801571:	75 07                	jne    80157a <malloc+0x18>
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	eb 61                	jmp    8015db <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80157a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801581:	8b 55 08             	mov    0x8(%ebp),%edx
  801584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801587:	01 d0                	add    %edx,%eax
  801589:	48                   	dec    %eax
  80158a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80158d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801590:	ba 00 00 00 00       	mov    $0x0,%edx
  801595:	f7 75 f0             	divl   -0x10(%ebp)
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	29 d0                	sub    %edx,%eax
  80159d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015a0:	e8 75 07 00 00       	call   801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 11                	je     8015ba <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8015af:	e8 e0 0d 00 00       	call   802394 <alloc_block_FF>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8015ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015be:	74 16                	je     8015d6 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c6:	e8 3c 0b 00 00       	call   802107 <insert_sorted_allocList>
  8015cb:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	8b 40 08             	mov    0x8(%eax),%eax
  8015d4:	eb 05                	jmp    8015db <malloc+0x79>
	}

    return NULL;
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	68 44 3e 80 00       	push   $0x803e44
  8015eb:	6a 6f                	push   $0x6f
  8015ed:	68 13 3e 80 00       	push   $0x803e13
  8015f2:	e8 2f ed ff ff       	call   800326 <_panic>

008015f7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 38             	sub    $0x38,%esp
  8015fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801600:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801603:	e8 5c fd ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801608:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80160c:	75 0a                	jne    801618 <smalloc+0x21>
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	e9 8b 00 00 00       	jmp    8016a3 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801618:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80161f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	48                   	dec    %eax
  801628:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80162b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162e:	ba 00 00 00 00       	mov    $0x0,%edx
  801633:	f7 75 f0             	divl   -0x10(%ebp)
  801636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801639:	29 d0                	sub    %edx,%eax
  80163b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80163e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801645:	e8 d0 06 00 00       	call   801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164a:	85 c0                	test   %eax,%eax
  80164c:	74 11                	je     80165f <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	ff 75 e8             	pushl  -0x18(%ebp)
  801654:	e8 3b 0d 00 00       	call   802394 <alloc_block_FF>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80165f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801663:	74 39                	je     80169e <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	8b 40 08             	mov    0x8(%eax),%eax
  80166b:	89 c2                	mov    %eax,%edx
  80166d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801671:	52                   	push   %edx
  801672:	50                   	push   %eax
  801673:	ff 75 0c             	pushl  0xc(%ebp)
  801676:	ff 75 08             	pushl  0x8(%ebp)
  801679:	e8 21 04 00 00       	call   801a9f <sys_createSharedObject>
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801684:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801688:	74 14                	je     80169e <smalloc+0xa7>
  80168a:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80168e:	74 0e                	je     80169e <smalloc+0xa7>
  801690:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801694:	74 08                	je     80169e <smalloc+0xa7>
			return (void*) mem_block->sva;
  801696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801699:	8b 40 08             	mov    0x8(%eax),%eax
  80169c:	eb 05                	jmp    8016a3 <smalloc+0xac>
	}
	return NULL;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ab:	e8 b4 fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b0:	83 ec 08             	sub    $0x8,%esp
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	ff 75 08             	pushl  0x8(%ebp)
  8016b9:	e8 0b 04 00 00       	call   801ac9 <sys_getSizeOfSharedObject>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016c4:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016c8:	74 76                	je     801740 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016ca:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d7:	01 d0                	add    %edx,%eax
  8016d9:	48                   	dec    %eax
  8016da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e5:	f7 75 ec             	divl   -0x14(%ebp)
  8016e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016eb:	29 d0                	sub    %edx,%eax
  8016ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8016f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016f7:	e8 1e 06 00 00       	call   801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 11                	je     801711 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801700:	83 ec 0c             	sub    $0xc,%esp
  801703:	ff 75 e4             	pushl  -0x1c(%ebp)
  801706:	e8 89 0c 00 00       	call   802394 <alloc_block_FF>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801715:	74 29                	je     801740 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171a:	8b 40 08             	mov    0x8(%eax),%eax
  80171d:	83 ec 04             	sub    $0x4,%esp
  801720:	50                   	push   %eax
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	e8 ba 03 00 00       	call   801ae6 <sys_getSharedObject>
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801732:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801736:	74 08                	je     801740 <sget+0x9b>
				return (void *)mem_block->sva;
  801738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173b:	8b 40 08             	mov    0x8(%eax),%eax
  80173e:	eb 05                	jmp    801745 <sget+0xa0>
		}
	}
	return NULL;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174d:	e8 12 fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 68 3e 80 00       	push   $0x803e68
  80175a:	68 f1 00 00 00       	push   $0xf1
  80175f:	68 13 3e 80 00       	push   $0x803e13
  801764:	e8 bd eb ff ff       	call   800326 <_panic>

00801769 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 90 3e 80 00       	push   $0x803e90
  801777:	68 05 01 00 00       	push   $0x105
  80177c:	68 13 3e 80 00       	push   $0x803e13
  801781:	e8 a0 eb ff ff       	call   800326 <_panic>

00801786 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 b4 3e 80 00       	push   $0x803eb4
  801794:	68 10 01 00 00       	push   $0x110
  801799:	68 13 3e 80 00       	push   $0x803e13
  80179e:	e8 83 eb ff ff       	call   800326 <_panic>

008017a3 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	68 b4 3e 80 00       	push   $0x803eb4
  8017b1:	68 15 01 00 00       	push   $0x115
  8017b6:	68 13 3e 80 00       	push   $0x803e13
  8017bb:	e8 66 eb ff ff       	call   800326 <_panic>

008017c0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c6:	83 ec 04             	sub    $0x4,%esp
  8017c9:	68 b4 3e 80 00       	push   $0x803eb4
  8017ce:	68 1a 01 00 00       	push   $0x11a
  8017d3:	68 13 3e 80 00       	push   $0x803e13
  8017d8:	e8 49 eb ff ff       	call   800326 <_panic>

008017dd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	57                   	push   %edi
  8017e1:	56                   	push   %esi
  8017e2:	53                   	push   %ebx
  8017e3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f8:	cd 30                	int    $0x30
  8017fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	5b                   	pop    %ebx
  801804:	5e                   	pop    %esi
  801805:	5f                   	pop    %edi
  801806:	5d                   	pop    %ebp
  801807:	c3                   	ret    

00801808 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	8b 45 10             	mov    0x10(%ebp),%eax
  801811:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801814:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	52                   	push   %edx
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	6a 00                	push   $0x0
  801826:	e8 b2 ff ff ff       	call   8017dd <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_cgetc>:

int
sys_cgetc(void)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 01                	push   $0x1
  801840:	e8 98 ff ff ff       	call   8017dd <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	52                   	push   %edx
  80185a:	50                   	push   %eax
  80185b:	6a 05                	push   $0x5
  80185d:	e8 7b ff ff ff       	call   8017dd <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	56                   	push   %esi
  80186b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186c:	8b 75 18             	mov    0x18(%ebp),%esi
  80186f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801872:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801875:	8b 55 0c             	mov    0xc(%ebp),%edx
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	56                   	push   %esi
  80187c:	53                   	push   %ebx
  80187d:	51                   	push   %ecx
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 06                	push   $0x6
  801882:	e8 56 ff ff ff       	call   8017dd <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5e                   	pop    %esi
  80188f:	5d                   	pop    %ebp
  801890:	c3                   	ret    

00801891 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801894:	8b 55 0c             	mov    0xc(%ebp),%edx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	52                   	push   %edx
  8018a1:	50                   	push   %eax
  8018a2:	6a 07                	push   $0x7
  8018a4:	e8 34 ff ff ff       	call   8017dd <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 08                	push   $0x8
  8018bf:	e8 19 ff ff ff       	call   8017dd <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 09                	push   $0x9
  8018d8:	e8 00 ff ff ff       	call   8017dd <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 0a                	push   $0xa
  8018f1:	e8 e7 fe ff ff       	call   8017dd <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 0b                	push   $0xb
  80190a:	e8 ce fe ff ff       	call   8017dd <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	6a 0f                	push   $0xf
  801925:	e8 b3 fe ff ff       	call   8017dd <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	ff 75 08             	pushl  0x8(%ebp)
  80193f:	6a 10                	push   $0x10
  801941:	e8 97 fe ff ff       	call   8017dd <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
	return ;
  801949:	90                   	nop
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 10             	pushl  0x10(%ebp)
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 11                	push   $0x11
  80195e:	e8 7a fe ff ff       	call   8017dd <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return ;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 0c                	push   $0xc
  801978:	e8 60 fe ff ff       	call   8017dd <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 08             	pushl  0x8(%ebp)
  801990:	6a 0d                	push   $0xd
  801992:	e8 46 fe ff ff       	call   8017dd <syscall>
  801997:	83 c4 18             	add    $0x18,%esp
}
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 0e                	push   $0xe
  8019ab:	e8 2d fe ff ff       	call   8017dd <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 13                	push   $0x13
  8019c5:	e8 13 fe ff ff       	call   8017dd <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	90                   	nop
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 14                	push   $0x14
  8019df:	e8 f9 fd ff ff       	call   8017dd <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	50                   	push   %eax
  801a03:	6a 15                	push   $0x15
  801a05:	e8 d3 fd ff ff       	call   8017dd <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	90                   	nop
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 16                	push   $0x16
  801a1f:	e8 b9 fd ff ff       	call   8017dd <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	90                   	nop
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	6a 17                	push   $0x17
  801a3c:	e8 9c fd ff ff       	call   8017dd <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 1a                	push   $0x1a
  801a59:	e8 7f fd ff ff       	call   8017dd <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 18                	push   $0x18
  801a76:	e8 62 fd ff ff       	call   8017dd <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	52                   	push   %edx
  801a91:	50                   	push   %eax
  801a92:	6a 19                	push   $0x19
  801a94:	e8 44 fd ff ff       	call   8017dd <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	90                   	nop
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 04             	sub    $0x4,%esp
  801aa5:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aae:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	6a 00                	push   $0x0
  801ab7:	51                   	push   %ecx
  801ab8:	52                   	push   %edx
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	6a 1b                	push   $0x1b
  801abf:	e8 19 fd ff ff       	call   8017dd <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 1c                	push   $0x1c
  801adc:	e8 fc fc ff ff       	call   8017dd <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 1d                	push   $0x1d
  801afb:	e8 dd fc ff ff       	call   8017dd <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	52                   	push   %edx
  801b15:	50                   	push   %eax
  801b16:	6a 1e                	push   $0x1e
  801b18:	e8 c0 fc ff ff       	call   8017dd <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 1f                	push   $0x1f
  801b31:	e8 a7 fc ff ff       	call   8017dd <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 14             	pushl  0x14(%ebp)
  801b46:	ff 75 10             	pushl  0x10(%ebp)
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	50                   	push   %eax
  801b4d:	6a 20                	push   $0x20
  801b4f:	e8 89 fc ff ff       	call   8017dd <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	50                   	push   %eax
  801b68:	6a 21                	push   $0x21
  801b6a:	e8 6e fc ff ff       	call   8017dd <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	90                   	nop
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	50                   	push   %eax
  801b84:	6a 22                	push   $0x22
  801b86:	e8 52 fc ff ff       	call   8017dd <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 02                	push   $0x2
  801b9f:	e8 39 fc ff ff       	call   8017dd <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 03                	push   $0x3
  801bb8:	e8 20 fc ff ff       	call   8017dd <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 04                	push   $0x4
  801bd1:	e8 07 fc ff ff       	call   8017dd <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_exit_env>:


void sys_exit_env(void)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 23                	push   $0x23
  801bea:	e8 ee fb ff ff       	call   8017dd <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfe:	8d 50 04             	lea    0x4(%eax),%edx
  801c01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	52                   	push   %edx
  801c0b:	50                   	push   %eax
  801c0c:	6a 24                	push   $0x24
  801c0e:	e8 ca fb ff ff       	call   8017dd <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
	return result;
  801c16:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1f:	89 01                	mov    %eax,(%ecx)
  801c21:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	c9                   	leave  
  801c28:	c2 04 00             	ret    $0x4

00801c2b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	ff 75 10             	pushl  0x10(%ebp)
  801c35:	ff 75 0c             	pushl  0xc(%ebp)
  801c38:	ff 75 08             	pushl  0x8(%ebp)
  801c3b:	6a 12                	push   $0x12
  801c3d:	e8 9b fb ff ff       	call   8017dd <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
	return ;
  801c45:	90                   	nop
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 25                	push   $0x25
  801c57:	e8 81 fb ff ff       	call   8017dd <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 04             	sub    $0x4,%esp
  801c67:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 26                	push   $0x26
  801c7c:	e8 5c fb ff ff       	call   8017dd <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
	return ;
  801c84:	90                   	nop
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <rsttst>:
void rsttst()
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 28                	push   $0x28
  801c96:	e8 42 fb ff ff       	call   8017dd <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cad:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	ff 75 10             	pushl  0x10(%ebp)
  801cb9:	ff 75 0c             	pushl  0xc(%ebp)
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	6a 27                	push   $0x27
  801cc1:	e8 17 fb ff ff       	call   8017dd <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc9:	90                   	nop
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <chktst>:
void chktst(uint32 n)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	6a 29                	push   $0x29
  801cdc:	e8 fc fa ff ff       	call   8017dd <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <inctst>:

void inctst()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 2a                	push   $0x2a
  801cf6:	e8 e2 fa ff ff       	call   8017dd <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <gettst>:
uint32 gettst()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 2b                	push   $0x2b
  801d10:	e8 c8 fa ff ff       	call   8017dd <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 2c                	push   $0x2c
  801d2c:	e8 ac fa ff ff       	call   8017dd <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
  801d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d37:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d3b:	75 07                	jne    801d44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d42:	eb 05                	jmp    801d49 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 2c                	push   $0x2c
  801d5d:	e8 7b fa ff ff       	call   8017dd <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
  801d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d68:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d6c:	75 07                	jne    801d75 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d73:	eb 05                	jmp    801d7a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 2c                	push   $0x2c
  801d8e:	e8 4a fa ff ff       	call   8017dd <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
  801d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d99:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d9d:	75 07                	jne    801da6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d9f:	b8 01 00 00 00       	mov    $0x1,%eax
  801da4:	eb 05                	jmp    801dab <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 2c                	push   $0x2c
  801dbf:	e8 19 fa ff ff       	call   8017dd <syscall>
  801dc4:	83 c4 18             	add    $0x18,%esp
  801dc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dca:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dce:	75 07                	jne    801dd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd0:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd5:	eb 05                	jmp    801ddc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	ff 75 08             	pushl  0x8(%ebp)
  801dec:	6a 2d                	push   $0x2d
  801dee:	e8 ea f9 ff ff       	call   8017dd <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return ;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dfd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	53                   	push   %ebx
  801e0c:	51                   	push   %ecx
  801e0d:	52                   	push   %edx
  801e0e:	50                   	push   %eax
  801e0f:	6a 2e                	push   $0x2e
  801e11:	e8 c7 f9 ff ff       	call   8017dd <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	52                   	push   %edx
  801e2e:	50                   	push   %eax
  801e2f:	6a 2f                	push   $0x2f
  801e31:	e8 a7 f9 ff ff       	call   8017dd <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	68 c4 3e 80 00       	push   $0x803ec4
  801e49:	e8 8c e7 ff ff       	call   8005da <cprintf>
  801e4e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	68 f0 3e 80 00       	push   $0x803ef0
  801e60:	e8 75 e7 ff ff       	call   8005da <cprintf>
  801e65:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e68:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6c:	a1 38 51 80 00       	mov    0x805138,%eax
  801e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e74:	eb 56                	jmp    801ecc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7a:	74 1c                	je     801e98 <print_mem_block_lists+0x5d>
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	8b 50 08             	mov    0x8(%eax),%edx
  801e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e85:	8b 48 08             	mov    0x8(%eax),%ecx
  801e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8e:	01 c8                	add    %ecx,%eax
  801e90:	39 c2                	cmp    %eax,%edx
  801e92:	73 04                	jae    801e98 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e94:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 50 08             	mov    0x8(%eax),%edx
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	01 c2                	add    %eax,%edx
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	68 05 3f 80 00       	push   $0x803f05
  801eb6:	e8 1f e7 ff ff       	call   8005da <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec4:	a1 40 51 80 00       	mov    0x805140,%eax
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed0:	74 07                	je     801ed9 <print_mem_block_lists+0x9e>
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 00                	mov    (%eax),%eax
  801ed7:	eb 05                	jmp    801ede <print_mem_block_lists+0xa3>
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	a3 40 51 80 00       	mov    %eax,0x805140
  801ee3:	a1 40 51 80 00       	mov    0x805140,%eax
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	75 8a                	jne    801e76 <print_mem_block_lists+0x3b>
  801eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef0:	75 84                	jne    801e76 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef6:	75 10                	jne    801f08 <print_mem_block_lists+0xcd>
  801ef8:	83 ec 0c             	sub    $0xc,%esp
  801efb:	68 14 3f 80 00       	push   $0x803f14
  801f00:	e8 d5 e6 ff ff       	call   8005da <cprintf>
  801f05:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f08:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	68 38 3f 80 00       	push   $0x803f38
  801f17:	e8 be e6 ff ff       	call   8005da <cprintf>
  801f1c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f1f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f23:	a1 40 50 80 00       	mov    0x805040,%eax
  801f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2b:	eb 56                	jmp    801f83 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f31:	74 1c                	je     801f4f <print_mem_block_lists+0x114>
  801f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f36:	8b 50 08             	mov    0x8(%eax),%edx
  801f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	8b 40 0c             	mov    0xc(%eax),%eax
  801f45:	01 c8                	add    %ecx,%eax
  801f47:	39 c2                	cmp    %eax,%edx
  801f49:	73 04                	jae    801f4f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f4b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 50 08             	mov    0x8(%eax),%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5b:	01 c2                	add    %eax,%edx
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 40 08             	mov    0x8(%eax),%eax
  801f63:	83 ec 04             	sub    $0x4,%esp
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	68 05 3f 80 00       	push   $0x803f05
  801f6d:	e8 68 e6 ff ff       	call   8005da <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7b:	a1 48 50 80 00       	mov    0x805048,%eax
  801f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f87:	74 07                	je     801f90 <print_mem_block_lists+0x155>
  801f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8c:	8b 00                	mov    (%eax),%eax
  801f8e:	eb 05                	jmp    801f95 <print_mem_block_lists+0x15a>
  801f90:	b8 00 00 00 00       	mov    $0x0,%eax
  801f95:	a3 48 50 80 00       	mov    %eax,0x805048
  801f9a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	75 8a                	jne    801f2d <print_mem_block_lists+0xf2>
  801fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa7:	75 84                	jne    801f2d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fad:	75 10                	jne    801fbf <print_mem_block_lists+0x184>
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	68 50 3f 80 00       	push   $0x803f50
  801fb7:	e8 1e e6 ff ff       	call   8005da <cprintf>
  801fbc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fbf:	83 ec 0c             	sub    $0xc,%esp
  801fc2:	68 c4 3e 80 00       	push   $0x803ec4
  801fc7:	e8 0e e6 ff ff       	call   8005da <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp

}
  801fcf:	90                   	nop
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fd8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fdf:	00 00 00 
  801fe2:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fe9:	00 00 00 
  801fec:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ff3:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ffd:	e9 9e 00 00 00       	jmp    8020a0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802002:	a1 50 50 80 00       	mov    0x805050,%eax
  802007:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200a:	c1 e2 04             	shl    $0x4,%edx
  80200d:	01 d0                	add    %edx,%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	75 14                	jne    802027 <initialize_MemBlocksList+0x55>
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	68 78 3f 80 00       	push   $0x803f78
  80201b:	6a 46                	push   $0x46
  80201d:	68 9b 3f 80 00       	push   $0x803f9b
  802022:	e8 ff e2 ff ff       	call   800326 <_panic>
  802027:	a1 50 50 80 00       	mov    0x805050,%eax
  80202c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202f:	c1 e2 04             	shl    $0x4,%edx
  802032:	01 d0                	add    %edx,%eax
  802034:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80203a:	89 10                	mov    %edx,(%eax)
  80203c:	8b 00                	mov    (%eax),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	74 18                	je     80205a <initialize_MemBlocksList+0x88>
  802042:	a1 48 51 80 00       	mov    0x805148,%eax
  802047:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80204d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802050:	c1 e1 04             	shl    $0x4,%ecx
  802053:	01 ca                	add    %ecx,%edx
  802055:	89 50 04             	mov    %edx,0x4(%eax)
  802058:	eb 12                	jmp    80206c <initialize_MemBlocksList+0x9a>
  80205a:	a1 50 50 80 00       	mov    0x805050,%eax
  80205f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802062:	c1 e2 04             	shl    $0x4,%edx
  802065:	01 d0                	add    %edx,%eax
  802067:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80206c:	a1 50 50 80 00       	mov    0x805050,%eax
  802071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802074:	c1 e2 04             	shl    $0x4,%edx
  802077:	01 d0                	add    %edx,%eax
  802079:	a3 48 51 80 00       	mov    %eax,0x805148
  80207e:	a1 50 50 80 00       	mov    0x805050,%eax
  802083:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802086:	c1 e2 04             	shl    $0x4,%edx
  802089:	01 d0                	add    %edx,%eax
  80208b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802092:	a1 54 51 80 00       	mov    0x805154,%eax
  802097:	40                   	inc    %eax
  802098:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80209d:	ff 45 f4             	incl   -0xc(%ebp)
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a6:	0f 82 56 ff ff ff    	jb     802002 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020ac:	90                   	nop
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020af:	55                   	push   %ebp
  8020b0:	89 e5                	mov    %esp,%ebp
  8020b2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	8b 00                	mov    (%eax),%eax
  8020ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bd:	eb 19                	jmp    8020d8 <find_block+0x29>
	{
		if(va==point->sva)
  8020bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c2:	8b 40 08             	mov    0x8(%eax),%eax
  8020c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c8:	75 05                	jne    8020cf <find_block+0x20>
		   return point;
  8020ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cd:	eb 36                	jmp    802105 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	8b 40 08             	mov    0x8(%eax),%eax
  8020d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020dc:	74 07                	je     8020e5 <find_block+0x36>
  8020de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e1:	8b 00                	mov    (%eax),%eax
  8020e3:	eb 05                	jmp    8020ea <find_block+0x3b>
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ed:	89 42 08             	mov    %eax,0x8(%edx)
  8020f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	75 c5                	jne    8020bf <find_block+0x10>
  8020fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fe:	75 bf                	jne    8020bf <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802100:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80210d:	a1 40 50 80 00       	mov    0x805040,%eax
  802112:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802115:	a1 44 50 80 00       	mov    0x805044,%eax
  80211a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80211d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802120:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802123:	74 24                	je     802149 <insert_sorted_allocList+0x42>
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8b 50 08             	mov    0x8(%eax),%edx
  80212b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212e:	8b 40 08             	mov    0x8(%eax),%eax
  802131:	39 c2                	cmp    %eax,%edx
  802133:	76 14                	jbe    802149 <insert_sorted_allocList+0x42>
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	8b 50 08             	mov    0x8(%eax),%edx
  80213b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213e:	8b 40 08             	mov    0x8(%eax),%eax
  802141:	39 c2                	cmp    %eax,%edx
  802143:	0f 82 60 01 00 00    	jb     8022a9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214d:	75 65                	jne    8021b4 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80214f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802153:	75 14                	jne    802169 <insert_sorted_allocList+0x62>
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	68 78 3f 80 00       	push   $0x803f78
  80215d:	6a 6b                	push   $0x6b
  80215f:	68 9b 3f 80 00       	push   $0x803f9b
  802164:	e8 bd e1 ff ff       	call   800326 <_panic>
  802169:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	89 10                	mov    %edx,(%eax)
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	74 0d                	je     80218a <insert_sorted_allocList+0x83>
  80217d:	a1 40 50 80 00       	mov    0x805040,%eax
  802182:	8b 55 08             	mov    0x8(%ebp),%edx
  802185:	89 50 04             	mov    %edx,0x4(%eax)
  802188:	eb 08                	jmp    802192 <insert_sorted_allocList+0x8b>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	a3 44 50 80 00       	mov    %eax,0x805044
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	a3 40 50 80 00       	mov    %eax,0x805040
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021a9:	40                   	inc    %eax
  8021aa:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021af:	e9 dc 01 00 00       	jmp    802390 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	39 c2                	cmp    %eax,%edx
  8021c2:	77 6c                	ja     802230 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c8:	74 06                	je     8021d0 <insert_sorted_allocList+0xc9>
  8021ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ce:	75 14                	jne    8021e4 <insert_sorted_allocList+0xdd>
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	68 b4 3f 80 00       	push   $0x803fb4
  8021d8:	6a 6f                	push   $0x6f
  8021da:	68 9b 3f 80 00       	push   $0x803f9b
  8021df:	e8 42 e1 ff ff       	call   800326 <_panic>
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	8b 50 04             	mov    0x4(%eax),%edx
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	89 50 04             	mov    %edx,0x4(%eax)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f6:	89 10                	mov    %edx,(%eax)
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fb:	8b 40 04             	mov    0x4(%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 0d                	je     80220f <insert_sorted_allocList+0x108>
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	8b 40 04             	mov    0x4(%eax),%eax
  802208:	8b 55 08             	mov    0x8(%ebp),%edx
  80220b:	89 10                	mov    %edx,(%eax)
  80220d:	eb 08                	jmp    802217 <insert_sorted_allocList+0x110>
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 40 50 80 00       	mov    %eax,0x805040
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	89 50 04             	mov    %edx,0x4(%eax)
  802220:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802225:	40                   	inc    %eax
  802226:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80222b:	e9 60 01 00 00       	jmp    802390 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8b 50 08             	mov    0x8(%eax),%edx
  802236:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802239:	8b 40 08             	mov    0x8(%eax),%eax
  80223c:	39 c2                	cmp    %eax,%edx
  80223e:	0f 82 4c 01 00 00    	jb     802390 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802244:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802248:	75 14                	jne    80225e <insert_sorted_allocList+0x157>
  80224a:	83 ec 04             	sub    $0x4,%esp
  80224d:	68 ec 3f 80 00       	push   $0x803fec
  802252:	6a 73                	push   $0x73
  802254:	68 9b 3f 80 00       	push   $0x803f9b
  802259:	e8 c8 e0 ff ff       	call   800326 <_panic>
  80225e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	89 50 04             	mov    %edx,0x4(%eax)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 40 04             	mov    0x4(%eax),%eax
  802270:	85 c0                	test   %eax,%eax
  802272:	74 0c                	je     802280 <insert_sorted_allocList+0x179>
  802274:	a1 44 50 80 00       	mov    0x805044,%eax
  802279:	8b 55 08             	mov    0x8(%ebp),%edx
  80227c:	89 10                	mov    %edx,(%eax)
  80227e:	eb 08                	jmp    802288 <insert_sorted_allocList+0x181>
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	a3 40 50 80 00       	mov    %eax,0x805040
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 44 50 80 00       	mov    %eax,0x805044
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802299:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80229e:	40                   	inc    %eax
  80229f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a4:	e9 e7 00 00 00       	jmp    802390 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8022bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022be:	e9 9d 00 00 00       	jmp    802360 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8b 50 08             	mov    0x8(%eax),%edx
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 40 08             	mov    0x8(%eax),%eax
  8022d7:	39 c2                	cmp    %eax,%edx
  8022d9:	76 7d                	jbe    802358 <insert_sorted_allocList+0x251>
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8b 50 08             	mov    0x8(%eax),%edx
  8022e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e4:	8b 40 08             	mov    0x8(%eax),%eax
  8022e7:	39 c2                	cmp    %eax,%edx
  8022e9:	73 6d                	jae    802358 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ef:	74 06                	je     8022f7 <insert_sorted_allocList+0x1f0>
  8022f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f5:	75 14                	jne    80230b <insert_sorted_allocList+0x204>
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	68 10 40 80 00       	push   $0x804010
  8022ff:	6a 7f                	push   $0x7f
  802301:	68 9b 3f 80 00       	push   $0x803f9b
  802306:	e8 1b e0 ff ff       	call   800326 <_panic>
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 10                	mov    (%eax),%edx
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	89 10                	mov    %edx,(%eax)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 0b                	je     802329 <insert_sorted_allocList+0x222>
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	8b 55 08             	mov    0x8(%ebp),%edx
  802326:	89 50 04             	mov    %edx,0x4(%eax)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 55 08             	mov    0x8(%ebp),%edx
  80232f:	89 10                	mov    %edx,(%eax)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802337:	89 50 04             	mov    %edx,0x4(%eax)
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	75 08                	jne    80234b <insert_sorted_allocList+0x244>
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	a3 44 50 80 00       	mov    %eax,0x805044
  80234b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802350:	40                   	inc    %eax
  802351:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802356:	eb 39                	jmp    802391 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802358:	a1 48 50 80 00       	mov    0x805048,%eax
  80235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802360:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802364:	74 07                	je     80236d <insert_sorted_allocList+0x266>
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	eb 05                	jmp    802372 <insert_sorted_allocList+0x26b>
  80236d:	b8 00 00 00 00       	mov    $0x0,%eax
  802372:	a3 48 50 80 00       	mov    %eax,0x805048
  802377:	a1 48 50 80 00       	mov    0x805048,%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	0f 85 3f ff ff ff    	jne    8022c3 <insert_sorted_allocList+0x1bc>
  802384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802388:	0f 85 35 ff ff ff    	jne    8022c3 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80238e:	eb 01                	jmp    802391 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802390:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802391:	90                   	nop
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80239a:	a1 38 51 80 00       	mov    0x805138,%eax
  80239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a2:	e9 85 01 00 00       	jmp    80252c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b0:	0f 82 6e 01 00 00    	jb     802524 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bf:	0f 85 8a 00 00 00    	jne    80244f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c9:	75 17                	jne    8023e2 <alloc_block_FF+0x4e>
  8023cb:	83 ec 04             	sub    $0x4,%esp
  8023ce:	68 44 40 80 00       	push   $0x804044
  8023d3:	68 93 00 00 00       	push   $0x93
  8023d8:	68 9b 3f 80 00       	push   $0x803f9b
  8023dd:	e8 44 df ff ff       	call   800326 <_panic>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 10                	je     8023fb <alloc_block_FF+0x67>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f3:	8b 52 04             	mov    0x4(%edx),%edx
  8023f6:	89 50 04             	mov    %edx,0x4(%eax)
  8023f9:	eb 0b                	jmp    802406 <alloc_block_FF+0x72>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 40 04             	mov    0x4(%eax),%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 0f                	je     80241f <alloc_block_FF+0x8b>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802419:	8b 12                	mov    (%edx),%edx
  80241b:	89 10                	mov    %edx,(%eax)
  80241d:	eb 0a                	jmp    802429 <alloc_block_FF+0x95>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	a3 38 51 80 00       	mov    %eax,0x805138
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243c:	a1 44 51 80 00       	mov    0x805144,%eax
  802441:	48                   	dec    %eax
  802442:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	e9 10 01 00 00       	jmp    80255f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 40 0c             	mov    0xc(%eax),%eax
  802455:	3b 45 08             	cmp    0x8(%ebp),%eax
  802458:	0f 86 c6 00 00 00    	jbe    802524 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80245e:	a1 48 51 80 00       	mov    0x805148,%eax
  802463:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 50 08             	mov    0x8(%eax),%edx
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	8b 55 08             	mov    0x8(%ebp),%edx
  802478:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80247b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80247f:	75 17                	jne    802498 <alloc_block_FF+0x104>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 44 40 80 00       	push   $0x804044
  802489:	68 9b 00 00 00       	push   $0x9b
  80248e:	68 9b 3f 80 00       	push   $0x803f9b
  802493:	e8 8e de ff ff       	call   800326 <_panic>
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 10                	je     8024b1 <alloc_block_FF+0x11d>
  8024a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ac:	89 50 04             	mov    %edx,0x4(%eax)
  8024af:	eb 0b                	jmp    8024bc <alloc_block_FF+0x128>
  8024b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block_FF+0x141>
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 0a                	jmp    8024df <alloc_block_FF+0x14b>
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	a3 48 51 80 00       	mov    %eax,0x805148
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8024f7:	48                   	dec    %eax
  8024f8:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 50 08             	mov    0x8(%eax),%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	01 c2                	add    %eax,%edx
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 0c             	mov    0xc(%eax),%eax
  802514:	2b 45 08             	sub    0x8(%ebp),%eax
  802517:	89 c2                	mov    %eax,%edx
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	eb 3b                	jmp    80255f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802524:	a1 40 51 80 00       	mov    0x805140,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	74 07                	je     802539 <alloc_block_FF+0x1a5>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	eb 05                	jmp    80253e <alloc_block_FF+0x1aa>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	a3 40 51 80 00       	mov    %eax,0x805140
  802543:	a1 40 51 80 00       	mov    0x805140,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 85 57 fe ff ff    	jne    8023a7 <alloc_block_FF+0x13>
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	0f 85 4d fe ff ff    	jne    8023a7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802567:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80256e:	a1 38 51 80 00       	mov    0x805138,%eax
  802573:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802576:	e9 df 00 00 00       	jmp    80265a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 40 0c             	mov    0xc(%eax),%eax
  802581:	3b 45 08             	cmp    0x8(%ebp),%eax
  802584:	0f 82 c8 00 00 00    	jb     802652 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 0c             	mov    0xc(%eax),%eax
  802590:	3b 45 08             	cmp    0x8(%ebp),%eax
  802593:	0f 85 8a 00 00 00    	jne    802623 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802599:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259d:	75 17                	jne    8025b6 <alloc_block_BF+0x55>
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	68 44 40 80 00       	push   $0x804044
  8025a7:	68 b7 00 00 00       	push   $0xb7
  8025ac:	68 9b 3f 80 00       	push   $0x803f9b
  8025b1:	e8 70 dd ff ff       	call   800326 <_panic>
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 00                	mov    (%eax),%eax
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	74 10                	je     8025cf <alloc_block_BF+0x6e>
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c7:	8b 52 04             	mov    0x4(%edx),%edx
  8025ca:	89 50 04             	mov    %edx,0x4(%eax)
  8025cd:	eb 0b                	jmp    8025da <alloc_block_BF+0x79>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 04             	mov    0x4(%eax),%eax
  8025d5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 04             	mov    0x4(%eax),%eax
  8025e0:	85 c0                	test   %eax,%eax
  8025e2:	74 0f                	je     8025f3 <alloc_block_BF+0x92>
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ed:	8b 12                	mov    (%edx),%edx
  8025ef:	89 10                	mov    %edx,(%eax)
  8025f1:	eb 0a                	jmp    8025fd <alloc_block_BF+0x9c>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802610:	a1 44 51 80 00       	mov    0x805144,%eax
  802615:	48                   	dec    %eax
  802616:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	e9 4d 01 00 00       	jmp    802770 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 0c             	mov    0xc(%eax),%eax
  802629:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262c:	76 24                	jbe    802652 <alloc_block_BF+0xf1>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 0c             	mov    0xc(%eax),%eax
  802634:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802637:	73 19                	jae    802652 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802639:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 08             	mov    0x8(%eax),%eax
  80264f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802652:	a1 40 51 80 00       	mov    0x805140,%eax
  802657:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265e:	74 07                	je     802667 <alloc_block_BF+0x106>
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	eb 05                	jmp    80266c <alloc_block_BF+0x10b>
  802667:	b8 00 00 00 00       	mov    $0x0,%eax
  80266c:	a3 40 51 80 00       	mov    %eax,0x805140
  802671:	a1 40 51 80 00       	mov    0x805140,%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 85 fd fe ff ff    	jne    80257b <alloc_block_BF+0x1a>
  80267e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802682:	0f 85 f3 fe ff ff    	jne    80257b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802688:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80268c:	0f 84 d9 00 00 00    	je     80276b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802692:	a1 48 51 80 00       	mov    0x805148,%eax
  802697:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80269a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026b0:	75 17                	jne    8026c9 <alloc_block_BF+0x168>
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	68 44 40 80 00       	push   $0x804044
  8026ba:	68 c7 00 00 00       	push   $0xc7
  8026bf:	68 9b 3f 80 00       	push   $0x803f9b
  8026c4:	e8 5d dc ff ff       	call   800326 <_panic>
  8026c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	74 10                	je     8026e2 <alloc_block_BF+0x181>
  8026d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026da:	8b 52 04             	mov    0x4(%edx),%edx
  8026dd:	89 50 04             	mov    %edx,0x4(%eax)
  8026e0:	eb 0b                	jmp    8026ed <alloc_block_BF+0x18c>
  8026e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f0:	8b 40 04             	mov    0x4(%eax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	74 0f                	je     802706 <alloc_block_BF+0x1a5>
  8026f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802700:	8b 12                	mov    (%edx),%edx
  802702:	89 10                	mov    %edx,(%eax)
  802704:	eb 0a                	jmp    802710 <alloc_block_BF+0x1af>
  802706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	a3 48 51 80 00       	mov    %eax,0x805148
  802710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802713:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802719:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802723:	a1 54 51 80 00       	mov    0x805154,%eax
  802728:	48                   	dec    %eax
  802729:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80272e:	83 ec 08             	sub    $0x8,%esp
  802731:	ff 75 ec             	pushl  -0x14(%ebp)
  802734:	68 38 51 80 00       	push   $0x805138
  802739:	e8 71 f9 ff ff       	call   8020af <find_block>
  80273e:	83 c4 10             	add    $0x10,%esp
  802741:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802744:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802747:	8b 50 08             	mov    0x8(%eax),%edx
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	01 c2                	add    %eax,%edx
  80274f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802752:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802755:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802758:	8b 40 0c             	mov    0xc(%eax),%eax
  80275b:	2b 45 08             	sub    0x8(%ebp),%eax
  80275e:	89 c2                	mov    %eax,%edx
  802760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802763:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802769:	eb 05                	jmp    802770 <alloc_block_BF+0x20f>
	}
	return NULL;
  80276b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802770:	c9                   	leave  
  802771:	c3                   	ret    

00802772 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802772:	55                   	push   %ebp
  802773:	89 e5                	mov    %esp,%ebp
  802775:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802778:	a1 28 50 80 00       	mov    0x805028,%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	0f 85 de 01 00 00    	jne    802963 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802785:	a1 38 51 80 00       	mov    0x805138,%eax
  80278a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278d:	e9 9e 01 00 00       	jmp    802930 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 0c             	mov    0xc(%eax),%eax
  802798:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279b:	0f 82 87 01 00 00    	jb     802928 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027aa:	0f 85 95 00 00 00    	jne    802845 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b4:	75 17                	jne    8027cd <alloc_block_NF+0x5b>
  8027b6:	83 ec 04             	sub    $0x4,%esp
  8027b9:	68 44 40 80 00       	push   $0x804044
  8027be:	68 e0 00 00 00       	push   $0xe0
  8027c3:	68 9b 3f 80 00       	push   $0x803f9b
  8027c8:	e8 59 db ff ff       	call   800326 <_panic>
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	85 c0                	test   %eax,%eax
  8027d4:	74 10                	je     8027e6 <alloc_block_NF+0x74>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027de:	8b 52 04             	mov    0x4(%edx),%edx
  8027e1:	89 50 04             	mov    %edx,0x4(%eax)
  8027e4:	eb 0b                	jmp    8027f1 <alloc_block_NF+0x7f>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	74 0f                	je     80280a <alloc_block_NF+0x98>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802804:	8b 12                	mov    (%edx),%edx
  802806:	89 10                	mov    %edx,(%eax)
  802808:	eb 0a                	jmp    802814 <alloc_block_NF+0xa2>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 00                	mov    (%eax),%eax
  80280f:	a3 38 51 80 00       	mov    %eax,0x805138
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802827:	a1 44 51 80 00       	mov    0x805144,%eax
  80282c:	48                   	dec    %eax
  80282d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 08             	mov    0x8(%eax),%eax
  802838:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	e9 f8 04 00 00       	jmp    802d3d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 40 0c             	mov    0xc(%eax),%eax
  80284b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284e:	0f 86 d4 00 00 00    	jbe    802928 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802854:	a1 48 51 80 00       	mov    0x805148,%eax
  802859:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 50 08             	mov    0x8(%eax),%edx
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 55 08             	mov    0x8(%ebp),%edx
  80286e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802871:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802875:	75 17                	jne    80288e <alloc_block_NF+0x11c>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 44 40 80 00       	push   $0x804044
  80287f:	68 e9 00 00 00       	push   $0xe9
  802884:	68 9b 3f 80 00       	push   $0x803f9b
  802889:	e8 98 da ff ff       	call   800326 <_panic>
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	74 10                	je     8028a7 <alloc_block_NF+0x135>
  802897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289f:	8b 52 04             	mov    0x4(%edx),%edx
  8028a2:	89 50 04             	mov    %edx,0x4(%eax)
  8028a5:	eb 0b                	jmp    8028b2 <alloc_block_NF+0x140>
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b5:	8b 40 04             	mov    0x4(%eax),%eax
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	74 0f                	je     8028cb <alloc_block_NF+0x159>
  8028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c5:	8b 12                	mov    (%edx),%edx
  8028c7:	89 10                	mov    %edx,(%eax)
  8028c9:	eb 0a                	jmp    8028d5 <alloc_block_NF+0x163>
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8028ed:	48                   	dec    %eax
  8028ee:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	8b 40 08             	mov    0x8(%eax),%eax
  8028f9:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	01 c2                	add    %eax,%edx
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 0c             	mov    0xc(%eax),%eax
  802915:	2b 45 08             	sub    0x8(%ebp),%eax
  802918:	89 c2                	mov    %eax,%edx
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802923:	e9 15 04 00 00       	jmp    802d3d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802928:	a1 40 51 80 00       	mov    0x805140,%eax
  80292d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802934:	74 07                	je     80293d <alloc_block_NF+0x1cb>
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	eb 05                	jmp    802942 <alloc_block_NF+0x1d0>
  80293d:	b8 00 00 00 00       	mov    $0x0,%eax
  802942:	a3 40 51 80 00       	mov    %eax,0x805140
  802947:	a1 40 51 80 00       	mov    0x805140,%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 3e fe ff ff    	jne    802792 <alloc_block_NF+0x20>
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	0f 85 34 fe ff ff    	jne    802792 <alloc_block_NF+0x20>
  80295e:	e9 d5 03 00 00       	jmp    802d38 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802963:	a1 38 51 80 00       	mov    0x805138,%eax
  802968:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296b:	e9 b1 01 00 00       	jmp    802b21 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 50 08             	mov    0x8(%eax),%edx
  802976:	a1 28 50 80 00       	mov    0x805028,%eax
  80297b:	39 c2                	cmp    %eax,%edx
  80297d:	0f 82 96 01 00 00    	jb     802b19 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 40 0c             	mov    0xc(%eax),%eax
  802989:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298c:	0f 82 87 01 00 00    	jb     802b19 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 0c             	mov    0xc(%eax),%eax
  802998:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299b:	0f 85 95 00 00 00    	jne    802a36 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a5:	75 17                	jne    8029be <alloc_block_NF+0x24c>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 44 40 80 00       	push   $0x804044
  8029af:	68 fc 00 00 00       	push   $0xfc
  8029b4:	68 9b 3f 80 00       	push   $0x803f9b
  8029b9:	e8 68 d9 ff ff       	call   800326 <_panic>
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	74 10                	je     8029d7 <alloc_block_NF+0x265>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 00                	mov    (%eax),%eax
  8029cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cf:	8b 52 04             	mov    0x4(%edx),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
  8029d5:	eb 0b                	jmp    8029e2 <alloc_block_NF+0x270>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 0f                	je     8029fb <alloc_block_NF+0x289>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 04             	mov    0x4(%eax),%eax
  8029f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f5:	8b 12                	mov    (%edx),%edx
  8029f7:	89 10                	mov    %edx,(%eax)
  8029f9:	eb 0a                	jmp    802a05 <alloc_block_NF+0x293>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	a3 38 51 80 00       	mov    %eax,0x805138
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a18:	a1 44 51 80 00       	mov    0x805144,%eax
  802a1d:	48                   	dec    %eax
  802a1e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 08             	mov    0x8(%eax),%eax
  802a29:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	e9 07 03 00 00       	jmp    802d3d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a3f:	0f 86 d4 00 00 00    	jbe    802b19 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a45:	a1 48 51 80 00       	mov    0x805148,%eax
  802a4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 50 08             	mov    0x8(%eax),%edx
  802a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a56:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a62:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a66:	75 17                	jne    802a7f <alloc_block_NF+0x30d>
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	68 44 40 80 00       	push   $0x804044
  802a70:	68 04 01 00 00       	push   $0x104
  802a75:	68 9b 3f 80 00       	push   $0x803f9b
  802a7a:	e8 a7 d8 ff ff       	call   800326 <_panic>
  802a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a82:	8b 00                	mov    (%eax),%eax
  802a84:	85 c0                	test   %eax,%eax
  802a86:	74 10                	je     802a98 <alloc_block_NF+0x326>
  802a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a90:	8b 52 04             	mov    0x4(%edx),%edx
  802a93:	89 50 04             	mov    %edx,0x4(%eax)
  802a96:	eb 0b                	jmp    802aa3 <alloc_block_NF+0x331>
  802a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9b:	8b 40 04             	mov    0x4(%eax),%eax
  802a9e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	74 0f                	je     802abc <alloc_block_NF+0x34a>
  802aad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab0:	8b 40 04             	mov    0x4(%eax),%eax
  802ab3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ab6:	8b 12                	mov    (%edx),%edx
  802ab8:	89 10                	mov    %edx,(%eax)
  802aba:	eb 0a                	jmp    802ac6 <alloc_block_NF+0x354>
  802abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ac6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad9:	a1 54 51 80 00       	mov    0x805154,%eax
  802ade:	48                   	dec    %eax
  802adf:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae7:	8b 40 08             	mov    0x8(%eax),%eax
  802aea:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 50 08             	mov    0x8(%eax),%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	01 c2                	add    %eax,%edx
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b03:	8b 40 0c             	mov    0xc(%eax),%eax
  802b06:	2b 45 08             	sub    0x8(%ebp),%eax
  802b09:	89 c2                	mov    %eax,%edx
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b14:	e9 24 02 00 00       	jmp    802d3d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b19:	a1 40 51 80 00       	mov    0x805140,%eax
  802b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b25:	74 07                	je     802b2e <alloc_block_NF+0x3bc>
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	eb 05                	jmp    802b33 <alloc_block_NF+0x3c1>
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
  802b33:	a3 40 51 80 00       	mov    %eax,0x805140
  802b38:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	0f 85 2b fe ff ff    	jne    802970 <alloc_block_NF+0x1fe>
  802b45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b49:	0f 85 21 fe ff ff    	jne    802970 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b57:	e9 ae 01 00 00       	jmp    802d0a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 50 08             	mov    0x8(%eax),%edx
  802b62:	a1 28 50 80 00       	mov    0x805028,%eax
  802b67:	39 c2                	cmp    %eax,%edx
  802b69:	0f 83 93 01 00 00    	jae    802d02 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 40 0c             	mov    0xc(%eax),%eax
  802b75:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b78:	0f 82 84 01 00 00    	jb     802d02 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b87:	0f 85 95 00 00 00    	jne    802c22 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b91:	75 17                	jne    802baa <alloc_block_NF+0x438>
  802b93:	83 ec 04             	sub    $0x4,%esp
  802b96:	68 44 40 80 00       	push   $0x804044
  802b9b:	68 14 01 00 00       	push   $0x114
  802ba0:	68 9b 3f 80 00       	push   $0x803f9b
  802ba5:	e8 7c d7 ff ff       	call   800326 <_panic>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	74 10                	je     802bc3 <alloc_block_NF+0x451>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbb:	8b 52 04             	mov    0x4(%edx),%edx
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
  802bc1:	eb 0b                	jmp    802bce <alloc_block_NF+0x45c>
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 0f                	je     802be7 <alloc_block_NF+0x475>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 40 04             	mov    0x4(%eax),%eax
  802bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be1:	8b 12                	mov    (%edx),%edx
  802be3:	89 10                	mov    %edx,(%eax)
  802be5:	eb 0a                	jmp    802bf1 <alloc_block_NF+0x47f>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c04:	a1 44 51 80 00       	mov    0x805144,%eax
  802c09:	48                   	dec    %eax
  802c0a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 40 08             	mov    0x8(%eax),%eax
  802c15:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	e9 1b 01 00 00       	jmp    802d3d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 40 0c             	mov    0xc(%eax),%eax
  802c28:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2b:	0f 86 d1 00 00 00    	jbe    802d02 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c31:	a1 48 51 80 00       	mov    0x805148,%eax
  802c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c52:	75 17                	jne    802c6b <alloc_block_NF+0x4f9>
  802c54:	83 ec 04             	sub    $0x4,%esp
  802c57:	68 44 40 80 00       	push   $0x804044
  802c5c:	68 1c 01 00 00       	push   $0x11c
  802c61:	68 9b 3f 80 00       	push   $0x803f9b
  802c66:	e8 bb d6 ff ff       	call   800326 <_panic>
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	85 c0                	test   %eax,%eax
  802c72:	74 10                	je     802c84 <alloc_block_NF+0x512>
  802c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7c:	8b 52 04             	mov    0x4(%edx),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 0b                	jmp    802c8f <alloc_block_NF+0x51d>
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	74 0f                	je     802ca8 <alloc_block_NF+0x536>
  802c99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca2:	8b 12                	mov    (%edx),%edx
  802ca4:	89 10                	mov    %edx,(%eax)
  802ca6:	eb 0a                	jmp    802cb2 <alloc_block_NF+0x540>
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	a3 48 51 80 00       	mov    %eax,0x805148
  802cb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc5:	a1 54 51 80 00       	mov    0x805154,%eax
  802cca:	48                   	dec    %eax
  802ccb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	01 c2                	add    %eax,%edx
  802ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf2:	2b 45 08             	sub    0x8(%ebp),%eax
  802cf5:	89 c2                	mov    %eax,%edx
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d00:	eb 3b                	jmp    802d3d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d02:	a1 40 51 80 00       	mov    0x805140,%eax
  802d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0e:	74 07                	je     802d17 <alloc_block_NF+0x5a5>
  802d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	eb 05                	jmp    802d1c <alloc_block_NF+0x5aa>
  802d17:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1c:	a3 40 51 80 00       	mov    %eax,0x805140
  802d21:	a1 40 51 80 00       	mov    0x805140,%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	0f 85 2e fe ff ff    	jne    802b5c <alloc_block_NF+0x3ea>
  802d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d32:	0f 85 24 fe ff ff    	jne    802b5c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3d:	c9                   	leave  
  802d3e:	c3                   	ret    

00802d3f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d3f:	55                   	push   %ebp
  802d40:	89 e5                	mov    %esp,%ebp
  802d42:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d45:	a1 38 51 80 00       	mov    0x805138,%eax
  802d4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d4d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d52:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d55:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 14                	je     802d72 <insert_sorted_with_merge_freeList+0x33>
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 50 08             	mov    0x8(%eax),%edx
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	8b 40 08             	mov    0x8(%eax),%eax
  802d6a:	39 c2                	cmp    %eax,%edx
  802d6c:	0f 87 9b 01 00 00    	ja     802f0d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d76:	75 17                	jne    802d8f <insert_sorted_with_merge_freeList+0x50>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 78 3f 80 00       	push   $0x803f78
  802d80:	68 38 01 00 00       	push   $0x138
  802d85:	68 9b 3f 80 00       	push   $0x803f9b
  802d8a:	e8 97 d5 ff ff       	call   800326 <_panic>
  802d8f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	89 10                	mov    %edx,(%eax)
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	74 0d                	je     802db0 <insert_sorted_with_merge_freeList+0x71>
  802da3:	a1 38 51 80 00       	mov    0x805138,%eax
  802da8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dab:	89 50 04             	mov    %edx,0x4(%eax)
  802dae:	eb 08                	jmp    802db8 <insert_sorted_with_merge_freeList+0x79>
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dca:	a1 44 51 80 00       	mov    0x805144,%eax
  802dcf:	40                   	inc    %eax
  802dd0:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd9:	0f 84 a8 06 00 00    	je     803487 <insert_sorted_with_merge_freeList+0x748>
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 50 08             	mov    0x8(%eax),%edx
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 40 0c             	mov    0xc(%eax),%eax
  802deb:	01 c2                	add    %eax,%edx
  802ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df0:	8b 40 08             	mov    0x8(%eax),%eax
  802df3:	39 c2                	cmp    %eax,%edx
  802df5:	0f 85 8c 06 00 00    	jne    803487 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 50 0c             	mov    0xc(%eax),%edx
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 40 0c             	mov    0xc(%eax),%eax
  802e07:	01 c2                	add    %eax,%edx
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e13:	75 17                	jne    802e2c <insert_sorted_with_merge_freeList+0xed>
  802e15:	83 ec 04             	sub    $0x4,%esp
  802e18:	68 44 40 80 00       	push   $0x804044
  802e1d:	68 3c 01 00 00       	push   $0x13c
  802e22:	68 9b 3f 80 00       	push   $0x803f9b
  802e27:	e8 fa d4 ff ff       	call   800326 <_panic>
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 10                	je     802e45 <insert_sorted_with_merge_freeList+0x106>
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3d:	8b 52 04             	mov    0x4(%edx),%edx
  802e40:	89 50 04             	mov    %edx,0x4(%eax)
  802e43:	eb 0b                	jmp    802e50 <insert_sorted_with_merge_freeList+0x111>
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	85 c0                	test   %eax,%eax
  802e58:	74 0f                	je     802e69 <insert_sorted_with_merge_freeList+0x12a>
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e63:	8b 12                	mov    (%edx),%edx
  802e65:	89 10                	mov    %edx,(%eax)
  802e67:	eb 0a                	jmp    802e73 <insert_sorted_with_merge_freeList+0x134>
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e86:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8b:	48                   	dec    %eax
  802e8c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ea5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ea9:	75 17                	jne    802ec2 <insert_sorted_with_merge_freeList+0x183>
  802eab:	83 ec 04             	sub    $0x4,%esp
  802eae:	68 78 3f 80 00       	push   $0x803f78
  802eb3:	68 3f 01 00 00       	push   $0x13f
  802eb8:	68 9b 3f 80 00       	push   $0x803f9b
  802ebd:	e8 64 d4 ff ff       	call   800326 <_panic>
  802ec2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	89 10                	mov    %edx,(%eax)
  802ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed0:	8b 00                	mov    (%eax),%eax
  802ed2:	85 c0                	test   %eax,%eax
  802ed4:	74 0d                	je     802ee3 <insert_sorted_with_merge_freeList+0x1a4>
  802ed6:	a1 48 51 80 00       	mov    0x805148,%eax
  802edb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	eb 08                	jmp    802eeb <insert_sorted_with_merge_freeList+0x1ac>
  802ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efd:	a1 54 51 80 00       	mov    0x805154,%eax
  802f02:	40                   	inc    %eax
  802f03:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f08:	e9 7a 05 00 00       	jmp    803487 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	8b 50 08             	mov    0x8(%eax),%edx
  802f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f16:	8b 40 08             	mov    0x8(%eax),%eax
  802f19:	39 c2                	cmp    %eax,%edx
  802f1b:	0f 82 14 01 00 00    	jb     803035 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	8b 50 08             	mov    0x8(%eax),%edx
  802f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2d:	01 c2                	add    %eax,%edx
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	8b 40 08             	mov    0x8(%eax),%eax
  802f35:	39 c2                	cmp    %eax,%edx
  802f37:	0f 85 90 00 00 00    	jne    802fcd <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f40:	8b 50 0c             	mov    0xc(%eax),%edx
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	01 c2                	add    %eax,%edx
  802f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f69:	75 17                	jne    802f82 <insert_sorted_with_merge_freeList+0x243>
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	68 78 3f 80 00       	push   $0x803f78
  802f73:	68 49 01 00 00       	push   $0x149
  802f78:	68 9b 3f 80 00       	push   $0x803f9b
  802f7d:	e8 a4 d3 ff ff       	call   800326 <_panic>
  802f82:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	89 10                	mov    %edx,(%eax)
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 0d                	je     802fa3 <insert_sorted_with_merge_freeList+0x264>
  802f96:	a1 48 51 80 00       	mov    0x805148,%eax
  802f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	eb 08                	jmp    802fab <insert_sorted_with_merge_freeList+0x26c>
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbd:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc2:	40                   	inc    %eax
  802fc3:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc8:	e9 bb 04 00 00       	jmp    803488 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd1:	75 17                	jne    802fea <insert_sorted_with_merge_freeList+0x2ab>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	68 ec 3f 80 00       	push   $0x803fec
  802fdb:	68 4c 01 00 00       	push   $0x14c
  802fe0:	68 9b 3f 80 00       	push   $0x803f9b
  802fe5:	e8 3c d3 ff ff       	call   800326 <_panic>
  802fea:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	89 50 04             	mov    %edx,0x4(%eax)
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0c                	je     80300c <insert_sorted_with_merge_freeList+0x2cd>
  803000:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803005:	8b 55 08             	mov    0x8(%ebp),%edx
  803008:	89 10                	mov    %edx,(%eax)
  80300a:	eb 08                	jmp    803014 <insert_sorted_with_merge_freeList+0x2d5>
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	a3 38 51 80 00       	mov    %eax,0x805138
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803025:	a1 44 51 80 00       	mov    0x805144,%eax
  80302a:	40                   	inc    %eax
  80302b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803030:	e9 53 04 00 00       	jmp    803488 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803035:	a1 38 51 80 00       	mov    0x805138,%eax
  80303a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303d:	e9 15 04 00 00       	jmp    803457 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	8b 50 08             	mov    0x8(%eax),%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	8b 40 08             	mov    0x8(%eax),%eax
  803056:	39 c2                	cmp    %eax,%edx
  803058:	0f 86 f1 03 00 00    	jbe    80344f <insert_sorted_with_merge_freeList+0x710>
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	8b 50 08             	mov    0x8(%eax),%edx
  803064:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803067:	8b 40 08             	mov    0x8(%eax),%eax
  80306a:	39 c2                	cmp    %eax,%edx
  80306c:	0f 83 dd 03 00 00    	jae    80344f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 50 08             	mov    0x8(%eax),%edx
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 40 0c             	mov    0xc(%eax),%eax
  80307e:	01 c2                	add    %eax,%edx
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	8b 40 08             	mov    0x8(%eax),%eax
  803086:	39 c2                	cmp    %eax,%edx
  803088:	0f 85 b9 01 00 00    	jne    803247 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 40 0c             	mov    0xc(%eax),%eax
  80309a:	01 c2                	add    %eax,%edx
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	8b 40 08             	mov    0x8(%eax),%eax
  8030a2:	39 c2                	cmp    %eax,%edx
  8030a4:	0f 85 0d 01 00 00    	jne    8031b7 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b6:	01 c2                	add    %eax,%edx
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c2:	75 17                	jne    8030db <insert_sorted_with_merge_freeList+0x39c>
  8030c4:	83 ec 04             	sub    $0x4,%esp
  8030c7:	68 44 40 80 00       	push   $0x804044
  8030cc:	68 5c 01 00 00       	push   $0x15c
  8030d1:	68 9b 3f 80 00       	push   $0x803f9b
  8030d6:	e8 4b d2 ff ff       	call   800326 <_panic>
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	8b 00                	mov    (%eax),%eax
  8030e0:	85 c0                	test   %eax,%eax
  8030e2:	74 10                	je     8030f4 <insert_sorted_with_merge_freeList+0x3b5>
  8030e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ec:	8b 52 04             	mov    0x4(%edx),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 0b                	jmp    8030ff <insert_sorted_with_merge_freeList+0x3c0>
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803102:	8b 40 04             	mov    0x4(%eax),%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	74 0f                	je     803118 <insert_sorted_with_merge_freeList+0x3d9>
  803109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310c:	8b 40 04             	mov    0x4(%eax),%eax
  80310f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803112:	8b 12                	mov    (%edx),%edx
  803114:	89 10                	mov    %edx,(%eax)
  803116:	eb 0a                	jmp    803122 <insert_sorted_with_merge_freeList+0x3e3>
  803118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	a3 38 51 80 00       	mov    %eax,0x805138
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803135:	a1 44 51 80 00       	mov    0x805144,%eax
  80313a:	48                   	dec    %eax
  80313b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803154:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803158:	75 17                	jne    803171 <insert_sorted_with_merge_freeList+0x432>
  80315a:	83 ec 04             	sub    $0x4,%esp
  80315d:	68 78 3f 80 00       	push   $0x803f78
  803162:	68 5f 01 00 00       	push   $0x15f
  803167:	68 9b 3f 80 00       	push   $0x803f9b
  80316c:	e8 b5 d1 ff ff       	call   800326 <_panic>
  803171:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	89 10                	mov    %edx,(%eax)
  80317c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317f:	8b 00                	mov    (%eax),%eax
  803181:	85 c0                	test   %eax,%eax
  803183:	74 0d                	je     803192 <insert_sorted_with_merge_freeList+0x453>
  803185:	a1 48 51 80 00       	mov    0x805148,%eax
  80318a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318d:	89 50 04             	mov    %edx,0x4(%eax)
  803190:	eb 08                	jmp    80319a <insert_sorted_with_merge_freeList+0x45b>
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b1:	40                   	inc    %eax
  8031b2:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c3:	01 c2                	add    %eax,%edx
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e3:	75 17                	jne    8031fc <insert_sorted_with_merge_freeList+0x4bd>
  8031e5:	83 ec 04             	sub    $0x4,%esp
  8031e8:	68 78 3f 80 00       	push   $0x803f78
  8031ed:	68 64 01 00 00       	push   $0x164
  8031f2:	68 9b 3f 80 00       	push   $0x803f9b
  8031f7:	e8 2a d1 ff ff       	call   800326 <_panic>
  8031fc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	89 10                	mov    %edx,(%eax)
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	8b 00                	mov    (%eax),%eax
  80320c:	85 c0                	test   %eax,%eax
  80320e:	74 0d                	je     80321d <insert_sorted_with_merge_freeList+0x4de>
  803210:	a1 48 51 80 00       	mov    0x805148,%eax
  803215:	8b 55 08             	mov    0x8(%ebp),%edx
  803218:	89 50 04             	mov    %edx,0x4(%eax)
  80321b:	eb 08                	jmp    803225 <insert_sorted_with_merge_freeList+0x4e6>
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	a3 48 51 80 00       	mov    %eax,0x805148
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803237:	a1 54 51 80 00       	mov    0x805154,%eax
  80323c:	40                   	inc    %eax
  80323d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803242:	e9 41 02 00 00       	jmp    803488 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	8b 50 08             	mov    0x8(%eax),%edx
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	8b 40 0c             	mov    0xc(%eax),%eax
  803253:	01 c2                	add    %eax,%edx
  803255:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803258:	8b 40 08             	mov    0x8(%eax),%eax
  80325b:	39 c2                	cmp    %eax,%edx
  80325d:	0f 85 7c 01 00 00    	jne    8033df <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803263:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803267:	74 06                	je     80326f <insert_sorted_with_merge_freeList+0x530>
  803269:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326d:	75 17                	jne    803286 <insert_sorted_with_merge_freeList+0x547>
  80326f:	83 ec 04             	sub    $0x4,%esp
  803272:	68 b4 3f 80 00       	push   $0x803fb4
  803277:	68 69 01 00 00       	push   $0x169
  80327c:	68 9b 3f 80 00       	push   $0x803f9b
  803281:	e8 a0 d0 ff ff       	call   800326 <_panic>
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	8b 50 04             	mov    0x4(%eax),%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	8b 40 04             	mov    0x4(%eax),%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	74 0d                	je     8032b1 <insert_sorted_with_merge_freeList+0x572>
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	8b 40 04             	mov    0x4(%eax),%eax
  8032aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	eb 08                	jmp    8032b9 <insert_sorted_with_merge_freeList+0x57a>
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c7:	40                   	inc    %eax
  8032c8:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d9:	01 c2                	add    %eax,%edx
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e5:	75 17                	jne    8032fe <insert_sorted_with_merge_freeList+0x5bf>
  8032e7:	83 ec 04             	sub    $0x4,%esp
  8032ea:	68 44 40 80 00       	push   $0x804044
  8032ef:	68 6b 01 00 00       	push   $0x16b
  8032f4:	68 9b 3f 80 00       	push   $0x803f9b
  8032f9:	e8 28 d0 ff ff       	call   800326 <_panic>
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	8b 00                	mov    (%eax),%eax
  803303:	85 c0                	test   %eax,%eax
  803305:	74 10                	je     803317 <insert_sorted_with_merge_freeList+0x5d8>
  803307:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330a:	8b 00                	mov    (%eax),%eax
  80330c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330f:	8b 52 04             	mov    0x4(%edx),%edx
  803312:	89 50 04             	mov    %edx,0x4(%eax)
  803315:	eb 0b                	jmp    803322 <insert_sorted_with_merge_freeList+0x5e3>
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803325:	8b 40 04             	mov    0x4(%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	74 0f                	je     80333b <insert_sorted_with_merge_freeList+0x5fc>
  80332c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332f:	8b 40 04             	mov    0x4(%eax),%eax
  803332:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803335:	8b 12                	mov    (%edx),%edx
  803337:	89 10                	mov    %edx,(%eax)
  803339:	eb 0a                	jmp    803345 <insert_sorted_with_merge_freeList+0x606>
  80333b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333e:	8b 00                	mov    (%eax),%eax
  803340:	a3 38 51 80 00       	mov    %eax,0x805138
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803358:	a1 44 51 80 00       	mov    0x805144,%eax
  80335d:	48                   	dec    %eax
  80335e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803366:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803377:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80337b:	75 17                	jne    803394 <insert_sorted_with_merge_freeList+0x655>
  80337d:	83 ec 04             	sub    $0x4,%esp
  803380:	68 78 3f 80 00       	push   $0x803f78
  803385:	68 6e 01 00 00       	push   $0x16e
  80338a:	68 9b 3f 80 00       	push   $0x803f9b
  80338f:	e8 92 cf ff ff       	call   800326 <_panic>
  803394:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	89 10                	mov    %edx,(%eax)
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 0d                	je     8033b5 <insert_sorted_with_merge_freeList+0x676>
  8033a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b0:	89 50 04             	mov    %edx,0x4(%eax)
  8033b3:	eb 08                	jmp    8033bd <insert_sorted_with_merge_freeList+0x67e>
  8033b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8033d4:	40                   	inc    %eax
  8033d5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033da:	e9 a9 00 00 00       	jmp    803488 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e3:	74 06                	je     8033eb <insert_sorted_with_merge_freeList+0x6ac>
  8033e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e9:	75 17                	jne    803402 <insert_sorted_with_merge_freeList+0x6c3>
  8033eb:	83 ec 04             	sub    $0x4,%esp
  8033ee:	68 10 40 80 00       	push   $0x804010
  8033f3:	68 73 01 00 00       	push   $0x173
  8033f8:	68 9b 3f 80 00       	push   $0x803f9b
  8033fd:	e8 24 cf ff ff       	call   800326 <_panic>
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 10                	mov    (%eax),%edx
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	89 10                	mov    %edx,(%eax)
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	74 0b                	je     803420 <insert_sorted_with_merge_freeList+0x6e1>
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	8b 55 08             	mov    0x8(%ebp),%edx
  80341d:	89 50 04             	mov    %edx,0x4(%eax)
  803420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803423:	8b 55 08             	mov    0x8(%ebp),%edx
  803426:	89 10                	mov    %edx,(%eax)
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342e:	89 50 04             	mov    %edx,0x4(%eax)
  803431:	8b 45 08             	mov    0x8(%ebp),%eax
  803434:	8b 00                	mov    (%eax),%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	75 08                	jne    803442 <insert_sorted_with_merge_freeList+0x703>
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803442:	a1 44 51 80 00       	mov    0x805144,%eax
  803447:	40                   	inc    %eax
  803448:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80344d:	eb 39                	jmp    803488 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80344f:	a1 40 51 80 00       	mov    0x805140,%eax
  803454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345b:	74 07                	je     803464 <insert_sorted_with_merge_freeList+0x725>
  80345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803460:	8b 00                	mov    (%eax),%eax
  803462:	eb 05                	jmp    803469 <insert_sorted_with_merge_freeList+0x72a>
  803464:	b8 00 00 00 00       	mov    $0x0,%eax
  803469:	a3 40 51 80 00       	mov    %eax,0x805140
  80346e:	a1 40 51 80 00       	mov    0x805140,%eax
  803473:	85 c0                	test   %eax,%eax
  803475:	0f 85 c7 fb ff ff    	jne    803042 <insert_sorted_with_merge_freeList+0x303>
  80347b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347f:	0f 85 bd fb ff ff    	jne    803042 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803485:	eb 01                	jmp    803488 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803487:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803488:	90                   	nop
  803489:	c9                   	leave  
  80348a:	c3                   	ret    

0080348b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80348b:	55                   	push   %ebp
  80348c:	89 e5                	mov    %esp,%ebp
  80348e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803491:	8b 55 08             	mov    0x8(%ebp),%edx
  803494:	89 d0                	mov    %edx,%eax
  803496:	c1 e0 02             	shl    $0x2,%eax
  803499:	01 d0                	add    %edx,%eax
  80349b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034a2:	01 d0                	add    %edx,%eax
  8034a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034ab:	01 d0                	add    %edx,%eax
  8034ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034b4:	01 d0                	add    %edx,%eax
  8034b6:	c1 e0 04             	shl    $0x4,%eax
  8034b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8034bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8034c3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8034c6:	83 ec 0c             	sub    $0xc,%esp
  8034c9:	50                   	push   %eax
  8034ca:	e8 26 e7 ff ff       	call   801bf5 <sys_get_virtual_time>
  8034cf:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8034d2:	eb 41                	jmp    803515 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8034d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8034d7:	83 ec 0c             	sub    $0xc,%esp
  8034da:	50                   	push   %eax
  8034db:	e8 15 e7 ff ff       	call   801bf5 <sys_get_virtual_time>
  8034e0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8034e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e9:	29 c2                	sub    %eax,%edx
  8034eb:	89 d0                	mov    %edx,%eax
  8034ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8034f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f6:	89 d1                	mov    %edx,%ecx
  8034f8:	29 c1                	sub    %eax,%ecx
  8034fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8034fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803500:	39 c2                	cmp    %eax,%edx
  803502:	0f 97 c0             	seta   %al
  803505:	0f b6 c0             	movzbl %al,%eax
  803508:	29 c1                	sub    %eax,%ecx
  80350a:	89 c8                	mov    %ecx,%eax
  80350c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80350f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803512:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80351b:	72 b7                	jb     8034d4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80351d:	90                   	nop
  80351e:	c9                   	leave  
  80351f:	c3                   	ret    

00803520 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803520:	55                   	push   %ebp
  803521:	89 e5                	mov    %esp,%ebp
  803523:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803526:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80352d:	eb 03                	jmp    803532 <busy_wait+0x12>
  80352f:	ff 45 fc             	incl   -0x4(%ebp)
  803532:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803535:	3b 45 08             	cmp    0x8(%ebp),%eax
  803538:	72 f5                	jb     80352f <busy_wait+0xf>
	return i;
  80353a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80353d:	c9                   	leave  
  80353e:	c3                   	ret    
  80353f:	90                   	nop

00803540 <__udivdi3>:
  803540:	55                   	push   %ebp
  803541:	57                   	push   %edi
  803542:	56                   	push   %esi
  803543:	53                   	push   %ebx
  803544:	83 ec 1c             	sub    $0x1c,%esp
  803547:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80354b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80354f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803553:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803557:	89 ca                	mov    %ecx,%edx
  803559:	89 f8                	mov    %edi,%eax
  80355b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80355f:	85 f6                	test   %esi,%esi
  803561:	75 2d                	jne    803590 <__udivdi3+0x50>
  803563:	39 cf                	cmp    %ecx,%edi
  803565:	77 65                	ja     8035cc <__udivdi3+0x8c>
  803567:	89 fd                	mov    %edi,%ebp
  803569:	85 ff                	test   %edi,%edi
  80356b:	75 0b                	jne    803578 <__udivdi3+0x38>
  80356d:	b8 01 00 00 00       	mov    $0x1,%eax
  803572:	31 d2                	xor    %edx,%edx
  803574:	f7 f7                	div    %edi
  803576:	89 c5                	mov    %eax,%ebp
  803578:	31 d2                	xor    %edx,%edx
  80357a:	89 c8                	mov    %ecx,%eax
  80357c:	f7 f5                	div    %ebp
  80357e:	89 c1                	mov    %eax,%ecx
  803580:	89 d8                	mov    %ebx,%eax
  803582:	f7 f5                	div    %ebp
  803584:	89 cf                	mov    %ecx,%edi
  803586:	89 fa                	mov    %edi,%edx
  803588:	83 c4 1c             	add    $0x1c,%esp
  80358b:	5b                   	pop    %ebx
  80358c:	5e                   	pop    %esi
  80358d:	5f                   	pop    %edi
  80358e:	5d                   	pop    %ebp
  80358f:	c3                   	ret    
  803590:	39 ce                	cmp    %ecx,%esi
  803592:	77 28                	ja     8035bc <__udivdi3+0x7c>
  803594:	0f bd fe             	bsr    %esi,%edi
  803597:	83 f7 1f             	xor    $0x1f,%edi
  80359a:	75 40                	jne    8035dc <__udivdi3+0x9c>
  80359c:	39 ce                	cmp    %ecx,%esi
  80359e:	72 0a                	jb     8035aa <__udivdi3+0x6a>
  8035a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035a4:	0f 87 9e 00 00 00    	ja     803648 <__udivdi3+0x108>
  8035aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035af:	89 fa                	mov    %edi,%edx
  8035b1:	83 c4 1c             	add    $0x1c,%esp
  8035b4:	5b                   	pop    %ebx
  8035b5:	5e                   	pop    %esi
  8035b6:	5f                   	pop    %edi
  8035b7:	5d                   	pop    %ebp
  8035b8:	c3                   	ret    
  8035b9:	8d 76 00             	lea    0x0(%esi),%esi
  8035bc:	31 ff                	xor    %edi,%edi
  8035be:	31 c0                	xor    %eax,%eax
  8035c0:	89 fa                	mov    %edi,%edx
  8035c2:	83 c4 1c             	add    $0x1c,%esp
  8035c5:	5b                   	pop    %ebx
  8035c6:	5e                   	pop    %esi
  8035c7:	5f                   	pop    %edi
  8035c8:	5d                   	pop    %ebp
  8035c9:	c3                   	ret    
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	f7 f7                	div    %edi
  8035d0:	31 ff                	xor    %edi,%edi
  8035d2:	89 fa                	mov    %edi,%edx
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    
  8035dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035e1:	89 eb                	mov    %ebp,%ebx
  8035e3:	29 fb                	sub    %edi,%ebx
  8035e5:	89 f9                	mov    %edi,%ecx
  8035e7:	d3 e6                	shl    %cl,%esi
  8035e9:	89 c5                	mov    %eax,%ebp
  8035eb:	88 d9                	mov    %bl,%cl
  8035ed:	d3 ed                	shr    %cl,%ebp
  8035ef:	89 e9                	mov    %ebp,%ecx
  8035f1:	09 f1                	or     %esi,%ecx
  8035f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035f7:	89 f9                	mov    %edi,%ecx
  8035f9:	d3 e0                	shl    %cl,%eax
  8035fb:	89 c5                	mov    %eax,%ebp
  8035fd:	89 d6                	mov    %edx,%esi
  8035ff:	88 d9                	mov    %bl,%cl
  803601:	d3 ee                	shr    %cl,%esi
  803603:	89 f9                	mov    %edi,%ecx
  803605:	d3 e2                	shl    %cl,%edx
  803607:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360b:	88 d9                	mov    %bl,%cl
  80360d:	d3 e8                	shr    %cl,%eax
  80360f:	09 c2                	or     %eax,%edx
  803611:	89 d0                	mov    %edx,%eax
  803613:	89 f2                	mov    %esi,%edx
  803615:	f7 74 24 0c          	divl   0xc(%esp)
  803619:	89 d6                	mov    %edx,%esi
  80361b:	89 c3                	mov    %eax,%ebx
  80361d:	f7 e5                	mul    %ebp
  80361f:	39 d6                	cmp    %edx,%esi
  803621:	72 19                	jb     80363c <__udivdi3+0xfc>
  803623:	74 0b                	je     803630 <__udivdi3+0xf0>
  803625:	89 d8                	mov    %ebx,%eax
  803627:	31 ff                	xor    %edi,%edi
  803629:	e9 58 ff ff ff       	jmp    803586 <__udivdi3+0x46>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	8b 54 24 08          	mov    0x8(%esp),%edx
  803634:	89 f9                	mov    %edi,%ecx
  803636:	d3 e2                	shl    %cl,%edx
  803638:	39 c2                	cmp    %eax,%edx
  80363a:	73 e9                	jae    803625 <__udivdi3+0xe5>
  80363c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80363f:	31 ff                	xor    %edi,%edi
  803641:	e9 40 ff ff ff       	jmp    803586 <__udivdi3+0x46>
  803646:	66 90                	xchg   %ax,%ax
  803648:	31 c0                	xor    %eax,%eax
  80364a:	e9 37 ff ff ff       	jmp    803586 <__udivdi3+0x46>
  80364f:	90                   	nop

00803650 <__umoddi3>:
  803650:	55                   	push   %ebp
  803651:	57                   	push   %edi
  803652:	56                   	push   %esi
  803653:	53                   	push   %ebx
  803654:	83 ec 1c             	sub    $0x1c,%esp
  803657:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80365b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80365f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803663:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803667:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80366b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80366f:	89 f3                	mov    %esi,%ebx
  803671:	89 fa                	mov    %edi,%edx
  803673:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803677:	89 34 24             	mov    %esi,(%esp)
  80367a:	85 c0                	test   %eax,%eax
  80367c:	75 1a                	jne    803698 <__umoddi3+0x48>
  80367e:	39 f7                	cmp    %esi,%edi
  803680:	0f 86 a2 00 00 00    	jbe    803728 <__umoddi3+0xd8>
  803686:	89 c8                	mov    %ecx,%eax
  803688:	89 f2                	mov    %esi,%edx
  80368a:	f7 f7                	div    %edi
  80368c:	89 d0                	mov    %edx,%eax
  80368e:	31 d2                	xor    %edx,%edx
  803690:	83 c4 1c             	add    $0x1c,%esp
  803693:	5b                   	pop    %ebx
  803694:	5e                   	pop    %esi
  803695:	5f                   	pop    %edi
  803696:	5d                   	pop    %ebp
  803697:	c3                   	ret    
  803698:	39 f0                	cmp    %esi,%eax
  80369a:	0f 87 ac 00 00 00    	ja     80374c <__umoddi3+0xfc>
  8036a0:	0f bd e8             	bsr    %eax,%ebp
  8036a3:	83 f5 1f             	xor    $0x1f,%ebp
  8036a6:	0f 84 ac 00 00 00    	je     803758 <__umoddi3+0x108>
  8036ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8036b1:	29 ef                	sub    %ebp,%edi
  8036b3:	89 fe                	mov    %edi,%esi
  8036b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036b9:	89 e9                	mov    %ebp,%ecx
  8036bb:	d3 e0                	shl    %cl,%eax
  8036bd:	89 d7                	mov    %edx,%edi
  8036bf:	89 f1                	mov    %esi,%ecx
  8036c1:	d3 ef                	shr    %cl,%edi
  8036c3:	09 c7                	or     %eax,%edi
  8036c5:	89 e9                	mov    %ebp,%ecx
  8036c7:	d3 e2                	shl    %cl,%edx
  8036c9:	89 14 24             	mov    %edx,(%esp)
  8036cc:	89 d8                	mov    %ebx,%eax
  8036ce:	d3 e0                	shl    %cl,%eax
  8036d0:	89 c2                	mov    %eax,%edx
  8036d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036d6:	d3 e0                	shl    %cl,%eax
  8036d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e0:	89 f1                	mov    %esi,%ecx
  8036e2:	d3 e8                	shr    %cl,%eax
  8036e4:	09 d0                	or     %edx,%eax
  8036e6:	d3 eb                	shr    %cl,%ebx
  8036e8:	89 da                	mov    %ebx,%edx
  8036ea:	f7 f7                	div    %edi
  8036ec:	89 d3                	mov    %edx,%ebx
  8036ee:	f7 24 24             	mull   (%esp)
  8036f1:	89 c6                	mov    %eax,%esi
  8036f3:	89 d1                	mov    %edx,%ecx
  8036f5:	39 d3                	cmp    %edx,%ebx
  8036f7:	0f 82 87 00 00 00    	jb     803784 <__umoddi3+0x134>
  8036fd:	0f 84 91 00 00 00    	je     803794 <__umoddi3+0x144>
  803703:	8b 54 24 04          	mov    0x4(%esp),%edx
  803707:	29 f2                	sub    %esi,%edx
  803709:	19 cb                	sbb    %ecx,%ebx
  80370b:	89 d8                	mov    %ebx,%eax
  80370d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803711:	d3 e0                	shl    %cl,%eax
  803713:	89 e9                	mov    %ebp,%ecx
  803715:	d3 ea                	shr    %cl,%edx
  803717:	09 d0                	or     %edx,%eax
  803719:	89 e9                	mov    %ebp,%ecx
  80371b:	d3 eb                	shr    %cl,%ebx
  80371d:	89 da                	mov    %ebx,%edx
  80371f:	83 c4 1c             	add    $0x1c,%esp
  803722:	5b                   	pop    %ebx
  803723:	5e                   	pop    %esi
  803724:	5f                   	pop    %edi
  803725:	5d                   	pop    %ebp
  803726:	c3                   	ret    
  803727:	90                   	nop
  803728:	89 fd                	mov    %edi,%ebp
  80372a:	85 ff                	test   %edi,%edi
  80372c:	75 0b                	jne    803739 <__umoddi3+0xe9>
  80372e:	b8 01 00 00 00       	mov    $0x1,%eax
  803733:	31 d2                	xor    %edx,%edx
  803735:	f7 f7                	div    %edi
  803737:	89 c5                	mov    %eax,%ebp
  803739:	89 f0                	mov    %esi,%eax
  80373b:	31 d2                	xor    %edx,%edx
  80373d:	f7 f5                	div    %ebp
  80373f:	89 c8                	mov    %ecx,%eax
  803741:	f7 f5                	div    %ebp
  803743:	89 d0                	mov    %edx,%eax
  803745:	e9 44 ff ff ff       	jmp    80368e <__umoddi3+0x3e>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	89 c8                	mov    %ecx,%eax
  80374e:	89 f2                	mov    %esi,%edx
  803750:	83 c4 1c             	add    $0x1c,%esp
  803753:	5b                   	pop    %ebx
  803754:	5e                   	pop    %esi
  803755:	5f                   	pop    %edi
  803756:	5d                   	pop    %ebp
  803757:	c3                   	ret    
  803758:	3b 04 24             	cmp    (%esp),%eax
  80375b:	72 06                	jb     803763 <__umoddi3+0x113>
  80375d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803761:	77 0f                	ja     803772 <__umoddi3+0x122>
  803763:	89 f2                	mov    %esi,%edx
  803765:	29 f9                	sub    %edi,%ecx
  803767:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80376b:	89 14 24             	mov    %edx,(%esp)
  80376e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803772:	8b 44 24 04          	mov    0x4(%esp),%eax
  803776:	8b 14 24             	mov    (%esp),%edx
  803779:	83 c4 1c             	add    $0x1c,%esp
  80377c:	5b                   	pop    %ebx
  80377d:	5e                   	pop    %esi
  80377e:	5f                   	pop    %edi
  80377f:	5d                   	pop    %ebp
  803780:	c3                   	ret    
  803781:	8d 76 00             	lea    0x0(%esi),%esi
  803784:	2b 04 24             	sub    (%esp),%eax
  803787:	19 fa                	sbb    %edi,%edx
  803789:	89 d1                	mov    %edx,%ecx
  80378b:	89 c6                	mov    %eax,%esi
  80378d:	e9 71 ff ff ff       	jmp    803703 <__umoddi3+0xb3>
  803792:	66 90                	xchg   %ax,%ax
  803794:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803798:	72 ea                	jb     803784 <__umoddi3+0x134>
  80379a:	89 d9                	mov    %ebx,%ecx
  80379c:	e9 62 ff ff ff       	jmp    803703 <__umoddi3+0xb3>
