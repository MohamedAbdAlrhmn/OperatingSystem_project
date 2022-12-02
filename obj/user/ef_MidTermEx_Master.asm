
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
  800045:	68 60 36 80 00       	push   $0x803660
  80004a:	e8 5b 15 00 00       	call   8015aa <smalloc>
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
  800069:	68 62 36 80 00       	push   $0x803662
  80006e:	e8 37 15 00 00       	call   8015aa <smalloc>
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
  8000a6:	68 69 36 80 00       	push   $0x803669
  8000ab:	e8 33 18 00 00       	call   8018e3 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 6b 36 80 00       	push   $0x80366b
  8000bf:	e8 e6 14 00 00       	call   8015aa <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 79 36 80 00       	push   $0x803679
  8000f1:	e8 fe 18 00 00       	call   8019f4 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 83 36 80 00       	push   $0x803683
  80011a:	e8 d5 18 00 00       	call   8019f4 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 8d 36 80 00       	push   $0x80368d
  800139:	6a 27                	push   $0x27
  80013b:	68 a2 36 80 00       	push   $0x8036a2
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 c2 18 00 00       	call   801a12 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 e4 31 00 00       	call   803344 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 a4 18 00 00       	call   801a12 <sys_run_env>
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
  800185:	68 bd 36 80 00       	push   $0x8036bd
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 e4 18 00 00       	call   801a7b <sys_getparentenvid>
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
  8001aa:	68 6b 36 80 00       	push   $0x80366b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 27 14 00 00       	call   8015de <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 66 18 00 00       	call   801a2e <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 58 18 00 00       	call   801a2e <sys_destroy_env>
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
  8001f0:	e8 6d 18 00 00       	call   801a62 <sys_getenvindex>
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
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 0f 16 00 00       	call   80186f <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ec 36 80 00       	push   $0x8036ec
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 14 37 80 00       	push   $0x803714
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 3c 37 80 00       	push   $0x80373c
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 94 37 80 00       	push   $0x803794
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 ec 36 80 00       	push   $0x8036ec
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 8f 15 00 00       	call   801889 <sys_enable_interrupt>

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
  80030d:	e8 1c 17 00 00       	call   801a2e <sys_destroy_env>
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
  80031e:	e8 71 17 00 00       	call   801a94 <sys_exit_env>
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
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 a8 37 80 00       	push   $0x8037a8
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 ad 37 80 00       	push   $0x8037ad
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
  800384:	68 c9 37 80 00       	push   $0x8037c9
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
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 cc 37 80 00       	push   $0x8037cc
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 18 38 80 00       	push   $0x803818
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
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800482:	68 24 38 80 00       	push   $0x803824
  800487:	6a 3a                	push   $0x3a
  800489:	68 18 38 80 00       	push   $0x803818
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
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8004f2:	68 78 38 80 00       	push   $0x803878
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 18 38 80 00       	push   $0x803818
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
  800531:	a0 24 40 80 00       	mov    0x804024,%al
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
  80054c:	e8 70 11 00 00       	call   8016c1 <sys_cputs>
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
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 f9 10 00 00       	call   8016c1 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
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
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
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
  80060d:	e8 5d 12 00 00       	call   80186f <sys_disable_interrupt>
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
  80062d:	e8 57 12 00 00       	call   801889 <sys_enable_interrupt>
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
  800677:	e8 7c 2d 00 00       	call   8033f8 <__udivdi3>
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
  8006c7:	e8 3c 2e 00 00       	call   803508 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 f4 3a 80 00       	add    $0x803af4,%eax
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
  800822:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
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
  800903:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 05 3b 80 00       	push   $0x803b05
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
  800928:	68 0e 3b 80 00       	push   $0x803b0e
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
  800955:	be 11 3b 80 00       	mov    $0x803b11,%esi
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
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 70 3c 80 00       	push   $0x803c70
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
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
  80139b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013a2:	00 00 00 
  8013a5:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ac:	00 00 00 
  8013af:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013b6:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013b9:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013c0:	00 00 00 
  8013c3:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ca:	00 00 00 
  8013cd:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
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
  8013f2:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  8013f7:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013fe:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801401:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801408:	a1 20 41 80 00       	mov    0x804120,%eax
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  80142e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	6a 03                	push   $0x3
  801447:	ff 75 f4             	pushl  -0xc(%ebp)
  80144a:	50                   	push   %eax
  80144b:	e8 b5 03 00 00       	call   801805 <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 41 80 00       	mov    0x804120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 2a 0a 00 00       	call   801e8b <initialize_MemBlocksList>
  801461:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801464:	a1 48 41 80 00       	mov    0x804148,%eax
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
  801489:	68 95 3c 80 00       	push   $0x803c95
  80148e:	6a 33                	push   $0x33
  801490:	68 b3 3c 80 00       	push   $0x803cb3
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
  8014b9:	a3 4c 41 80 00       	mov    %eax,0x80414c
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
  8014dc:	a3 48 41 80 00       	mov    %eax,0x804148
  8014e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014f4:	a1 54 41 80 00       	mov    0x804154,%eax
  8014f9:	48                   	dec    %eax
  8014fa:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8014ff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801503:	75 14                	jne    801519 <initialize_dyn_block_system+0x184>
  801505:	83 ec 04             	sub    $0x4,%esp
  801508:	68 c0 3c 80 00       	push   $0x803cc0
  80150d:	6a 34                	push   $0x34
  80150f:	68 b3 3c 80 00       	push   $0x803cb3
  801514:	e8 0d ee ff ff       	call   800326 <_panic>
  801519:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80151f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801522:	89 10                	mov    %edx,(%eax)
  801524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801527:	8b 00                	mov    (%eax),%eax
  801529:	85 c0                	test   %eax,%eax
  80152b:	74 0d                	je     80153a <initialize_dyn_block_system+0x1a5>
  80152d:	a1 38 41 80 00       	mov    0x804138,%eax
  801532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801535:	89 50 04             	mov    %edx,0x4(%eax)
  801538:	eb 08                	jmp    801542 <initialize_dyn_block_system+0x1ad>
  80153a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801545:	a3 38 41 80 00       	mov    %eax,0x804138
  80154a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801554:	a1 44 41 80 00       	mov    0x804144,%eax
  801559:	40                   	inc    %eax
  80155a:	a3 44 41 80 00       	mov    %eax,0x804144
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
  801565:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801568:	e8 f7 fd ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  80156d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801571:	75 07                	jne    80157a <malloc+0x18>
  801573:	b8 00 00 00 00       	mov    $0x0,%eax
  801578:	eb 14                	jmp    80158e <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 e4 3c 80 00       	push   $0x803ce4
  801582:	6a 46                	push   $0x46
  801584:	68 b3 3c 80 00       	push   $0x803cb3
  801589:	e8 98 ed ff ff       	call   800326 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	68 0c 3d 80 00       	push   $0x803d0c
  80159e:	6a 61                	push   $0x61
  8015a0:	68 b3 3c 80 00       	push   $0x803cb3
  8015a5:	e8 7c ed ff ff       	call   800326 <_panic>

008015aa <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 18             	sub    $0x18,%esp
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b6:	e8 a9 fd ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bf:	75 07                	jne    8015c8 <smalloc+0x1e>
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	eb 14                	jmp    8015dc <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015c8:	83 ec 04             	sub    $0x4,%esp
  8015cb:	68 30 3d 80 00       	push   $0x803d30
  8015d0:	6a 76                	push   $0x76
  8015d2:	68 b3 3c 80 00       	push   $0x803cb3
  8015d7:	e8 4a ed ff ff       	call   800326 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e4:	e8 7b fd ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 58 3d 80 00       	push   $0x803d58
  8015f1:	68 93 00 00 00       	push   $0x93
  8015f6:	68 b3 3c 80 00       	push   $0x803cb3
  8015fb:	e8 26 ed ff ff       	call   800326 <_panic>

00801600 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801606:	e8 59 fd ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	68 7c 3d 80 00       	push   $0x803d7c
  801613:	68 c5 00 00 00       	push   $0xc5
  801618:	68 b3 3c 80 00       	push   $0x803cb3
  80161d:	e8 04 ed ff ff       	call   800326 <_panic>

00801622 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	68 a4 3d 80 00       	push   $0x803da4
  801630:	68 d9 00 00 00       	push   $0xd9
  801635:	68 b3 3c 80 00       	push   $0x803cb3
  80163a:	e8 e7 ec ff ff       	call   800326 <_panic>

0080163f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 c8 3d 80 00       	push   $0x803dc8
  80164d:	68 e4 00 00 00       	push   $0xe4
  801652:	68 b3 3c 80 00       	push   $0x803cb3
  801657:	e8 ca ec ff ff       	call   800326 <_panic>

0080165c <shrink>:

}
void shrink(uint32 newSize)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	68 c8 3d 80 00       	push   $0x803dc8
  80166a:	68 e9 00 00 00       	push   $0xe9
  80166f:	68 b3 3c 80 00       	push   $0x803cb3
  801674:	e8 ad ec ff ff       	call   800326 <_panic>

00801679 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 c8 3d 80 00       	push   $0x803dc8
  801687:	68 ee 00 00 00       	push   $0xee
  80168c:	68 b3 3c 80 00       	push   $0x803cb3
  801691:	e8 90 ec ff ff       	call   800326 <_panic>

00801696 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	57                   	push   %edi
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016b1:	cd 30                	int    $0x30
  8016b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	5b                   	pop    %ebx
  8016bd:	5e                   	pop    %esi
  8016be:	5f                   	pop    %edi
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	52                   	push   %edx
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	50                   	push   %eax
  8016dd:	6a 00                	push   $0x0
  8016df:	e8 b2 ff ff ff       	call   801696 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	90                   	nop
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 01                	push   $0x1
  8016f9:	e8 98 ff ff ff       	call   801696 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 05                	push   $0x5
  801716:	e8 7b ff ff ff       	call   801696 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801725:	8b 75 18             	mov    0x18(%ebp),%esi
  801728:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	51                   	push   %ecx
  801737:	52                   	push   %edx
  801738:	50                   	push   %eax
  801739:	6a 06                	push   $0x6
  80173b:	e8 56 ff ff ff       	call   801696 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80174d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	52                   	push   %edx
  80175a:	50                   	push   %eax
  80175b:	6a 07                	push   $0x7
  80175d:	e8 34 ff ff ff       	call   801696 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	6a 08                	push   $0x8
  801778:	e8 19 ff ff ff       	call   801696 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 09                	push   $0x9
  801791:	e8 00 ff ff ff       	call   801696 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 0a                	push   $0xa
  8017aa:	e8 e7 fe ff ff       	call   801696 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0b                	push   $0xb
  8017c3:	e8 ce fe ff ff       	call   801696 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 0f                	push   $0xf
  8017de:	e8 b3 fe ff ff       	call   801696 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 10                	push   $0x10
  8017fa:	e8 97 fe ff ff       	call   801696 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801802:	90                   	nop
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 10             	pushl  0x10(%ebp)
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 11                	push   $0x11
  801817:	e8 7a fe ff ff       	call   801696 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return ;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 0c                	push   $0xc
  801831:	e8 60 fe ff ff       	call   801696 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	6a 0d                	push   $0xd
  80184b:	e8 46 fe ff ff       	call   801696 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 0e                	push   $0xe
  801864:	e8 2d fe ff ff       	call   801696 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 13                	push   $0x13
  80187e:	e8 13 fe ff ff       	call   801696 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 14                	push   $0x14
  801898:	e8 f9 fd ff ff       	call   801696 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	50                   	push   %eax
  8018bc:	6a 15                	push   $0x15
  8018be:	e8 d3 fd ff ff       	call   801696 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	90                   	nop
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 16                	push   $0x16
  8018d8:	e8 b9 fd ff ff       	call   801696 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	50                   	push   %eax
  8018f3:	6a 17                	push   $0x17
  8018f5:	e8 9c fd ff ff       	call   801696 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801902:	8b 55 0c             	mov    0xc(%ebp),%edx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	52                   	push   %edx
  80190f:	50                   	push   %eax
  801910:	6a 1a                	push   $0x1a
  801912:	e8 7f fd ff ff       	call   801696 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 18                	push   $0x18
  80192f:	e8 62 fd ff ff       	call   801696 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	52                   	push   %edx
  80194a:	50                   	push   %eax
  80194b:	6a 19                	push   $0x19
  80194d:	e8 44 fd ff ff       	call   801696 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	8b 45 10             	mov    0x10(%ebp),%eax
  801961:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801964:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801967:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	51                   	push   %ecx
  801971:	52                   	push   %edx
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	50                   	push   %eax
  801976:	6a 1b                	push   $0x1b
  801978:	e8 19 fd ff ff       	call   801696 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	6a 1c                	push   $0x1c
  801995:	e8 fc fc ff ff       	call   801696 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	51                   	push   %ecx
  8019b0:	52                   	push   %edx
  8019b1:	50                   	push   %eax
  8019b2:	6a 1d                	push   $0x1d
  8019b4:	e8 dd fc ff ff       	call   801696 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	52                   	push   %edx
  8019ce:	50                   	push   %eax
  8019cf:	6a 1e                	push   $0x1e
  8019d1:	e8 c0 fc ff ff       	call   801696 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 1f                	push   $0x1f
  8019ea:	e8 a7 fc ff ff       	call   801696 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 14             	pushl  0x14(%ebp)
  8019ff:	ff 75 10             	pushl  0x10(%ebp)
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	6a 20                	push   $0x20
  801a08:	e8 89 fc ff ff       	call   801696 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	50                   	push   %eax
  801a21:	6a 21                	push   $0x21
  801a23:	e8 6e fc ff ff       	call   801696 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	50                   	push   %eax
  801a3d:	6a 22                	push   $0x22
  801a3f:	e8 52 fc ff ff       	call   801696 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 02                	push   $0x2
  801a58:	e8 39 fc ff ff       	call   801696 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 03                	push   $0x3
  801a71:	e8 20 fc ff ff       	call   801696 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 04                	push   $0x4
  801a8a:	e8 07 fc ff ff       	call   801696 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_exit_env>:


void sys_exit_env(void)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 23                	push   $0x23
  801aa3:	e8 ee fb ff ff       	call   801696 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ab4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab7:	8d 50 04             	lea    0x4(%eax),%edx
  801aba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 24                	push   $0x24
  801ac7:	e8 ca fb ff ff       	call   801696 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
	return result;
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad8:	89 01                	mov    %eax,(%ecx)
  801ada:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	c9                   	leave  
  801ae1:	c2 04 00             	ret    $0x4

00801ae4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 10             	pushl  0x10(%ebp)
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	6a 12                	push   $0x12
  801af6:	e8 9b fb ff ff       	call   801696 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
	return ;
  801afe:	90                   	nop
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 25                	push   $0x25
  801b10:	e8 81 fb ff ff       	call   801696 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	50                   	push   %eax
  801b33:	6a 26                	push   $0x26
  801b35:	e8 5c fb ff ff       	call   801696 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3d:	90                   	nop
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <rsttst>:
void rsttst()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 28                	push   $0x28
  801b4f:	e8 42 fb ff ff       	call   801696 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
	return ;
  801b57:	90                   	nop
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 04             	sub    $0x4,%esp
  801b60:	8b 45 14             	mov    0x14(%ebp),%eax
  801b63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b66:	8b 55 18             	mov    0x18(%ebp),%edx
  801b69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6d:	52                   	push   %edx
  801b6e:	50                   	push   %eax
  801b6f:	ff 75 10             	pushl  0x10(%ebp)
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	6a 27                	push   $0x27
  801b7a:	e8 17 fb ff ff       	call   801696 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <chktst>:
void chktst(uint32 n)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	6a 29                	push   $0x29
  801b95:	e8 fc fa ff ff       	call   801696 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <inctst>:

void inctst()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 2a                	push   $0x2a
  801baf:	e8 e2 fa ff ff       	call   801696 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <gettst>:
uint32 gettst()
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 2b                	push   $0x2b
  801bc9:	e8 c8 fa ff ff       	call   801696 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 2c                	push   $0x2c
  801be5:	e8 ac fa ff ff       	call   801696 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
  801bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bf0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bf4:	75 07                	jne    801bfd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	eb 05                	jmp    801c02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 2c                	push   $0x2c
  801c16:	e8 7b fa ff ff       	call   801696 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
  801c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c21:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c25:	75 07                	jne    801c2e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c27:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2c:	eb 05                	jmp    801c33 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 2c                	push   $0x2c
  801c47:	e8 4a fa ff ff       	call   801696 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
  801c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c52:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c56:	75 07                	jne    801c5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c58:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5d:	eb 05                	jmp    801c64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 2c                	push   $0x2c
  801c78:	e8 19 fa ff ff       	call   801696 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
  801c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c83:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c87:	75 07                	jne    801c90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	eb 05                	jmp    801c95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 08             	pushl  0x8(%ebp)
  801ca5:	6a 2d                	push   $0x2d
  801ca7:	e8 ea f9 ff ff       	call   801696 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return ;
  801caf:	90                   	nop
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	53                   	push   %ebx
  801cc5:	51                   	push   %ecx
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 2e                	push   $0x2e
  801cca:	e8 c7 f9 ff ff       	call   801696 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	6a 2f                	push   $0x2f
  801cea:	e8 a7 f9 ff ff       	call   801696 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	68 d8 3d 80 00       	push   $0x803dd8
  801d02:	e8 d3 e8 ff ff       	call   8005da <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	68 04 3e 80 00       	push   $0x803e04
  801d19:	e8 bc e8 ff ff       	call   8005da <cprintf>
  801d1e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d21:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d25:	a1 38 41 80 00       	mov    0x804138,%eax
  801d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2d:	eb 56                	jmp    801d85 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d33:	74 1c                	je     801d51 <print_mem_block_lists+0x5d>
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	8b 50 08             	mov    0x8(%eax),%edx
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3e:	8b 48 08             	mov    0x8(%eax),%ecx
  801d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d44:	8b 40 0c             	mov    0xc(%eax),%eax
  801d47:	01 c8                	add    %ecx,%eax
  801d49:	39 c2                	cmp    %eax,%edx
  801d4b:	73 04                	jae    801d51 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d4d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 50 08             	mov    0x8(%eax),%edx
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5d:	01 c2                	add    %eax,%edx
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	8b 40 08             	mov    0x8(%eax),%eax
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	68 19 3e 80 00       	push   $0x803e19
  801d6f:	e8 66 e8 ff ff       	call   8005da <cprintf>
  801d74:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d7d:	a1 40 41 80 00       	mov    0x804140,%eax
  801d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d89:	74 07                	je     801d92 <print_mem_block_lists+0x9e>
  801d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8e:	8b 00                	mov    (%eax),%eax
  801d90:	eb 05                	jmp    801d97 <print_mem_block_lists+0xa3>
  801d92:	b8 00 00 00 00       	mov    $0x0,%eax
  801d97:	a3 40 41 80 00       	mov    %eax,0x804140
  801d9c:	a1 40 41 80 00       	mov    0x804140,%eax
  801da1:	85 c0                	test   %eax,%eax
  801da3:	75 8a                	jne    801d2f <print_mem_block_lists+0x3b>
  801da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da9:	75 84                	jne    801d2f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dab:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801daf:	75 10                	jne    801dc1 <print_mem_block_lists+0xcd>
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	68 28 3e 80 00       	push   $0x803e28
  801db9:	e8 1c e8 ff ff       	call   8005da <cprintf>
  801dbe:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	68 4c 3e 80 00       	push   $0x803e4c
  801dd0:	e8 05 e8 ff ff       	call   8005da <cprintf>
  801dd5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dd8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ddc:	a1 40 40 80 00       	mov    0x804040,%eax
  801de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de4:	eb 56                	jmp    801e3c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801de6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dea:	74 1c                	je     801e08 <print_mem_block_lists+0x114>
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 50 08             	mov    0x8(%eax),%edx
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df5:	8b 48 08             	mov    0x8(%eax),%ecx
  801df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfe:	01 c8                	add    %ecx,%eax
  801e00:	39 c2                	cmp    %eax,%edx
  801e02:	73 04                	jae    801e08 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e04:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 50 08             	mov    0x8(%eax),%edx
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	8b 40 0c             	mov    0xc(%eax),%eax
  801e14:	01 c2                	add    %eax,%edx
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	8b 40 08             	mov    0x8(%eax),%eax
  801e1c:	83 ec 04             	sub    $0x4,%esp
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	68 19 3e 80 00       	push   $0x803e19
  801e26:	e8 af e7 ff ff       	call   8005da <cprintf>
  801e2b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e34:	a1 48 40 80 00       	mov    0x804048,%eax
  801e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e40:	74 07                	je     801e49 <print_mem_block_lists+0x155>
  801e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	eb 05                	jmp    801e4e <print_mem_block_lists+0x15a>
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	a3 48 40 80 00       	mov    %eax,0x804048
  801e53:	a1 48 40 80 00       	mov    0x804048,%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	75 8a                	jne    801de6 <print_mem_block_lists+0xf2>
  801e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e60:	75 84                	jne    801de6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e62:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e66:	75 10                	jne    801e78 <print_mem_block_lists+0x184>
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	68 64 3e 80 00       	push   $0x803e64
  801e70:	e8 65 e7 ff ff       	call   8005da <cprintf>
  801e75:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	68 d8 3d 80 00       	push   $0x803dd8
  801e80:	e8 55 e7 ff ff       	call   8005da <cprintf>
  801e85:	83 c4 10             	add    $0x10,%esp

}
  801e88:	90                   	nop
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e91:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e98:	00 00 00 
  801e9b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ea2:	00 00 00 
  801ea5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801eac:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801eaf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eb6:	e9 9e 00 00 00       	jmp    801f59 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ebb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	c1 e2 04             	shl    $0x4,%edx
  801ec6:	01 d0                	add    %edx,%eax
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	75 14                	jne    801ee0 <initialize_MemBlocksList+0x55>
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	68 8c 3e 80 00       	push   $0x803e8c
  801ed4:	6a 46                	push   $0x46
  801ed6:	68 af 3e 80 00       	push   $0x803eaf
  801edb:	e8 46 e4 ff ff       	call   800326 <_panic>
  801ee0:	a1 50 40 80 00       	mov    0x804050,%eax
  801ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee8:	c1 e2 04             	shl    $0x4,%edx
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ef3:	89 10                	mov    %edx,(%eax)
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	74 18                	je     801f13 <initialize_MemBlocksList+0x88>
  801efb:	a1 48 41 80 00       	mov    0x804148,%eax
  801f00:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f06:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f09:	c1 e1 04             	shl    $0x4,%ecx
  801f0c:	01 ca                	add    %ecx,%edx
  801f0e:	89 50 04             	mov    %edx,0x4(%eax)
  801f11:	eb 12                	jmp    801f25 <initialize_MemBlocksList+0x9a>
  801f13:	a1 50 40 80 00       	mov    0x804050,%eax
  801f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1b:	c1 e2 04             	shl    $0x4,%edx
  801f1e:	01 d0                	add    %edx,%eax
  801f20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f25:	a1 50 40 80 00       	mov    0x804050,%eax
  801f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2d:	c1 e2 04             	shl    $0x4,%edx
  801f30:	01 d0                	add    %edx,%eax
  801f32:	a3 48 41 80 00       	mov    %eax,0x804148
  801f37:	a1 50 40 80 00       	mov    0x804050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f4b:	a1 54 41 80 00       	mov    0x804154,%eax
  801f50:	40                   	inc    %eax
  801f51:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f56:	ff 45 f4             	incl   -0xc(%ebp)
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f5f:	0f 82 56 ff ff ff    	jb     801ebb <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f65:	90                   	nop
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f76:	eb 19                	jmp    801f91 <find_block+0x29>
	{
		if(va==point->sva)
  801f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7b:	8b 40 08             	mov    0x8(%eax),%eax
  801f7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f81:	75 05                	jne    801f88 <find_block+0x20>
		   return point;
  801f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f86:	eb 36                	jmp    801fbe <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	8b 40 08             	mov    0x8(%eax),%eax
  801f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f95:	74 07                	je     801f9e <find_block+0x36>
  801f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	eb 05                	jmp    801fa3 <find_block+0x3b>
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa6:	89 42 08             	mov    %eax,0x8(%edx)
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	8b 40 08             	mov    0x8(%eax),%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	75 c5                	jne    801f78 <find_block+0x10>
  801fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fb7:	75 bf                	jne    801f78 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fc6:	a1 40 40 80 00       	mov    0x804040,%eax
  801fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fce:	a1 44 40 80 00       	mov    0x804044,%eax
  801fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fdc:	74 24                	je     802002 <insert_sorted_allocList+0x42>
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	8b 50 08             	mov    0x8(%eax),%edx
  801fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe7:	8b 40 08             	mov    0x8(%eax),%eax
  801fea:	39 c2                	cmp    %eax,%edx
  801fec:	76 14                	jbe    802002 <insert_sorted_allocList+0x42>
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 50 08             	mov    0x8(%eax),%edx
  801ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff7:	8b 40 08             	mov    0x8(%eax),%eax
  801ffa:	39 c2                	cmp    %eax,%edx
  801ffc:	0f 82 60 01 00 00    	jb     802162 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802006:	75 65                	jne    80206d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802008:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80200c:	75 14                	jne    802022 <insert_sorted_allocList+0x62>
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 8c 3e 80 00       	push   $0x803e8c
  802016:	6a 6b                	push   $0x6b
  802018:	68 af 3e 80 00       	push   $0x803eaf
  80201d:	e8 04 e3 ff ff       	call   800326 <_panic>
  802022:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	89 10                	mov    %edx,(%eax)
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8b 00                	mov    (%eax),%eax
  802032:	85 c0                	test   %eax,%eax
  802034:	74 0d                	je     802043 <insert_sorted_allocList+0x83>
  802036:	a1 40 40 80 00       	mov    0x804040,%eax
  80203b:	8b 55 08             	mov    0x8(%ebp),%edx
  80203e:	89 50 04             	mov    %edx,0x4(%eax)
  802041:	eb 08                	jmp    80204b <insert_sorted_allocList+0x8b>
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	a3 44 40 80 00       	mov    %eax,0x804044
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	a3 40 40 80 00       	mov    %eax,0x804040
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802062:	40                   	inc    %eax
  802063:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802068:	e9 dc 01 00 00       	jmp    802249 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 50 08             	mov    0x8(%eax),%edx
  802073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	39 c2                	cmp    %eax,%edx
  80207b:	77 6c                	ja     8020e9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80207d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802081:	74 06                	je     802089 <insert_sorted_allocList+0xc9>
  802083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802087:	75 14                	jne    80209d <insert_sorted_allocList+0xdd>
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	68 c8 3e 80 00       	push   $0x803ec8
  802091:	6a 6f                	push   $0x6f
  802093:	68 af 3e 80 00       	push   $0x803eaf
  802098:	e8 89 e2 ff ff       	call   800326 <_panic>
  80209d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a0:	8b 50 04             	mov    0x4(%eax),%edx
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	89 50 04             	mov    %edx,0x4(%eax)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020af:	89 10                	mov    %edx,(%eax)
  8020b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b4:	8b 40 04             	mov    0x4(%eax),%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	74 0d                	je     8020c8 <insert_sorted_allocList+0x108>
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	8b 40 04             	mov    0x4(%eax),%eax
  8020c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c4:	89 10                	mov    %edx,(%eax)
  8020c6:	eb 08                	jmp    8020d0 <insert_sorted_allocList+0x110>
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	a3 40 40 80 00       	mov    %eax,0x804040
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d6:	89 50 04             	mov    %edx,0x4(%eax)
  8020d9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020de:	40                   	inc    %eax
  8020df:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e4:	e9 60 01 00 00       	jmp    802249 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 50 08             	mov    0x8(%eax),%edx
  8020ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	39 c2                	cmp    %eax,%edx
  8020f7:	0f 82 4c 01 00 00    	jb     802249 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802101:	75 14                	jne    802117 <insert_sorted_allocList+0x157>
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	68 00 3f 80 00       	push   $0x803f00
  80210b:	6a 73                	push   $0x73
  80210d:	68 af 3e 80 00       	push   $0x803eaf
  802112:	e8 0f e2 ff ff       	call   800326 <_panic>
  802117:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	89 50 04             	mov    %edx,0x4(%eax)
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	8b 40 04             	mov    0x4(%eax),%eax
  802129:	85 c0                	test   %eax,%eax
  80212b:	74 0c                	je     802139 <insert_sorted_allocList+0x179>
  80212d:	a1 44 40 80 00       	mov    0x804044,%eax
  802132:	8b 55 08             	mov    0x8(%ebp),%edx
  802135:	89 10                	mov    %edx,(%eax)
  802137:	eb 08                	jmp    802141 <insert_sorted_allocList+0x181>
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 40 40 80 00       	mov    %eax,0x804040
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	a3 44 40 80 00       	mov    %eax,0x804044
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802152:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802157:	40                   	inc    %eax
  802158:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215d:	e9 e7 00 00 00       	jmp    802249 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802168:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80216f:	a1 40 40 80 00       	mov    0x804040,%eax
  802174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802177:	e9 9d 00 00 00       	jmp    802219 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	8b 50 08             	mov    0x8(%eax),%edx
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 40 08             	mov    0x8(%eax),%eax
  802190:	39 c2                	cmp    %eax,%edx
  802192:	76 7d                	jbe    802211 <insert_sorted_allocList+0x251>
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 50 08             	mov    0x8(%eax),%edx
  80219a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80219d:	8b 40 08             	mov    0x8(%eax),%eax
  8021a0:	39 c2                	cmp    %eax,%edx
  8021a2:	73 6d                	jae    802211 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a8:	74 06                	je     8021b0 <insert_sorted_allocList+0x1f0>
  8021aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ae:	75 14                	jne    8021c4 <insert_sorted_allocList+0x204>
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	68 24 3f 80 00       	push   $0x803f24
  8021b8:	6a 7f                	push   $0x7f
  8021ba:	68 af 3e 80 00       	push   $0x803eaf
  8021bf:	e8 62 e1 ff ff       	call   800326 <_panic>
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 10                	mov    (%eax),%edx
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	89 10                	mov    %edx,(%eax)
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 0b                	je     8021e2 <insert_sorted_allocList+0x222>
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 00                	mov    (%eax),%eax
  8021dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e8:	89 10                	mov    %edx,(%eax)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	75 08                	jne    802204 <insert_sorted_allocList+0x244>
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 44 40 80 00       	mov    %eax,0x804044
  802204:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802209:	40                   	inc    %eax
  80220a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80220f:	eb 39                	jmp    80224a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802211:	a1 48 40 80 00       	mov    0x804048,%eax
  802216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221d:	74 07                	je     802226 <insert_sorted_allocList+0x266>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	eb 05                	jmp    80222b <insert_sorted_allocList+0x26b>
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
  80222b:	a3 48 40 80 00       	mov    %eax,0x804048
  802230:	a1 48 40 80 00       	mov    0x804048,%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	0f 85 3f ff ff ff    	jne    80217c <insert_sorted_allocList+0x1bc>
  80223d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802241:	0f 85 35 ff ff ff    	jne    80217c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802247:	eb 01                	jmp    80224a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802249:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802253:	a1 38 41 80 00       	mov    0x804138,%eax
  802258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225b:	e9 85 01 00 00       	jmp    8023e5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 0c             	mov    0xc(%eax),%eax
  802266:	3b 45 08             	cmp    0x8(%ebp),%eax
  802269:	0f 82 6e 01 00 00    	jb     8023dd <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 0c             	mov    0xc(%eax),%eax
  802275:	3b 45 08             	cmp    0x8(%ebp),%eax
  802278:	0f 85 8a 00 00 00    	jne    802308 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80227e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802282:	75 17                	jne    80229b <alloc_block_FF+0x4e>
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 58 3f 80 00       	push   $0x803f58
  80228c:	68 93 00 00 00       	push   $0x93
  802291:	68 af 3e 80 00       	push   $0x803eaf
  802296:	e8 8b e0 ff ff       	call   800326 <_panic>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 10                	je     8022b4 <alloc_block_FF+0x67>
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	8b 52 04             	mov    0x4(%edx),%edx
  8022af:	89 50 04             	mov    %edx,0x4(%eax)
  8022b2:	eb 0b                	jmp    8022bf <alloc_block_FF+0x72>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 40 04             	mov    0x4(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0f                	je     8022d8 <alloc_block_FF+0x8b>
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	8b 12                	mov    (%edx),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	eb 0a                	jmp    8022e2 <alloc_block_FF+0x95>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8022fa:	48                   	dec    %eax
  8022fb:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	e9 10 01 00 00       	jmp    802418 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 0c             	mov    0xc(%eax),%eax
  80230e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802311:	0f 86 c6 00 00 00    	jbe    8023dd <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802317:	a1 48 41 80 00       	mov    0x804148,%eax
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 50 08             	mov    0x8(%eax),%edx
  802325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802328:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 55 08             	mov    0x8(%ebp),%edx
  802331:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802334:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802338:	75 17                	jne    802351 <alloc_block_FF+0x104>
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 58 3f 80 00       	push   $0x803f58
  802342:	68 9b 00 00 00       	push   $0x9b
  802347:	68 af 3e 80 00       	push   $0x803eaf
  80234c:	e8 d5 df ff ff       	call   800326 <_panic>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	74 10                	je     80236a <alloc_block_FF+0x11d>
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802362:	8b 52 04             	mov    0x4(%edx),%edx
  802365:	89 50 04             	mov    %edx,0x4(%eax)
  802368:	eb 0b                	jmp    802375 <alloc_block_FF+0x128>
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 40 04             	mov    0x4(%eax),%eax
  802370:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	8b 40 04             	mov    0x4(%eax),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	74 0f                	je     80238e <alloc_block_FF+0x141>
  80237f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802382:	8b 40 04             	mov    0x4(%eax),%eax
  802385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802388:	8b 12                	mov    (%edx),%edx
  80238a:	89 10                	mov    %edx,(%eax)
  80238c:	eb 0a                	jmp    802398 <alloc_block_FF+0x14b>
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	a3 48 41 80 00       	mov    %eax,0x804148
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8023b0:	48                   	dec    %eax
  8023b1:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 50 08             	mov    0x8(%eax),%edx
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	01 c2                	add    %eax,%edx
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d0:	89 c2                	mov    %eax,%edx
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023db:	eb 3b                	jmp    802418 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	74 07                	je     8023f2 <alloc_block_FF+0x1a5>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	eb 05                	jmp    8023f7 <alloc_block_FF+0x1aa>
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	a3 40 41 80 00       	mov    %eax,0x804140
  8023fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	0f 85 57 fe ff ff    	jne    802260 <alloc_block_FF+0x13>
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	0f 85 4d fe ff ff    	jne    802260 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802420:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802427:	a1 38 41 80 00       	mov    0x804138,%eax
  80242c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242f:	e9 df 00 00 00       	jmp    802513 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 0c             	mov    0xc(%eax),%eax
  80243a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243d:	0f 82 c8 00 00 00    	jb     80250b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244c:	0f 85 8a 00 00 00    	jne    8024dc <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802456:	75 17                	jne    80246f <alloc_block_BF+0x55>
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	68 58 3f 80 00       	push   $0x803f58
  802460:	68 b7 00 00 00       	push   $0xb7
  802465:	68 af 3e 80 00       	push   $0x803eaf
  80246a:	e8 b7 de ff ff       	call   800326 <_panic>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 10                	je     802488 <alloc_block_BF+0x6e>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802480:	8b 52 04             	mov    0x4(%edx),%edx
  802483:	89 50 04             	mov    %edx,0x4(%eax)
  802486:	eb 0b                	jmp    802493 <alloc_block_BF+0x79>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 04             	mov    0x4(%eax),%eax
  80248e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 04             	mov    0x4(%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 0f                	je     8024ac <alloc_block_BF+0x92>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 04             	mov    0x4(%eax),%eax
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	8b 12                	mov    (%edx),%edx
  8024a8:	89 10                	mov    %edx,(%eax)
  8024aa:	eb 0a                	jmp    8024b6 <alloc_block_BF+0x9c>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ce:	48                   	dec    %eax
  8024cf:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	e9 4d 01 00 00       	jmp    802629 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e5:	76 24                	jbe    80250b <alloc_block_BF+0xf1>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024f0:	73 19                	jae    80250b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024f2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 08             	mov    0x8(%eax),%eax
  802508:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80250b:	a1 40 41 80 00       	mov    0x804140,%eax
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802517:	74 07                	je     802520 <alloc_block_BF+0x106>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	eb 05                	jmp    802525 <alloc_block_BF+0x10b>
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
  802525:	a3 40 41 80 00       	mov    %eax,0x804140
  80252a:	a1 40 41 80 00       	mov    0x804140,%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	0f 85 fd fe ff ff    	jne    802434 <alloc_block_BF+0x1a>
  802537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253b:	0f 85 f3 fe ff ff    	jne    802434 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802541:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802545:	0f 84 d9 00 00 00    	je     802624 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80254b:	a1 48 41 80 00       	mov    0x804148,%eax
  802550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802556:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802559:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80255c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255f:	8b 55 08             	mov    0x8(%ebp),%edx
  802562:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802565:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802569:	75 17                	jne    802582 <alloc_block_BF+0x168>
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 58 3f 80 00       	push   $0x803f58
  802573:	68 c7 00 00 00       	push   $0xc7
  802578:	68 af 3e 80 00       	push   $0x803eaf
  80257d:	e8 a4 dd ff ff       	call   800326 <_panic>
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 10                	je     80259b <alloc_block_BF+0x181>
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802593:	8b 52 04             	mov    0x4(%edx),%edx
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	eb 0b                	jmp    8025a6 <alloc_block_BF+0x18c>
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	74 0f                	je     8025bf <alloc_block_BF+0x1a5>
  8025b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b9:	8b 12                	mov    (%edx),%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	eb 0a                	jmp    8025c9 <alloc_block_BF+0x1af>
  8025bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8025c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8025e1:	48                   	dec    %eax
  8025e2:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025e7:	83 ec 08             	sub    $0x8,%esp
  8025ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8025ed:	68 38 41 80 00       	push   $0x804138
  8025f2:	e8 71 f9 ff ff       	call   801f68 <find_block>
  8025f7:	83 c4 10             	add    $0x10,%esp
  8025fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802600:	8b 50 08             	mov    0x8(%eax),%edx
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	01 c2                	add    %eax,%edx
  802608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80260e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	2b 45 08             	sub    0x8(%ebp),%eax
  802617:	89 c2                	mov    %eax,%edx
  802619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80261f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802622:	eb 05                	jmp    802629 <alloc_block_BF+0x20f>
	}
	return NULL;
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802631:	a1 28 40 80 00       	mov    0x804028,%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	0f 85 de 01 00 00    	jne    80281c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80263e:	a1 38 41 80 00       	mov    0x804138,%eax
  802643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802646:	e9 9e 01 00 00       	jmp    8027e9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 40 0c             	mov    0xc(%eax),%eax
  802651:	3b 45 08             	cmp    0x8(%ebp),%eax
  802654:	0f 82 87 01 00 00    	jb     8027e1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 08             	cmp    0x8(%ebp),%eax
  802663:	0f 85 95 00 00 00    	jne    8026fe <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	75 17                	jne    802686 <alloc_block_NF+0x5b>
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 58 3f 80 00       	push   $0x803f58
  802677:	68 e0 00 00 00       	push   $0xe0
  80267c:	68 af 3e 80 00       	push   $0x803eaf
  802681:	e8 a0 dc ff ff       	call   800326 <_panic>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 10                	je     80269f <alloc_block_NF+0x74>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802697:	8b 52 04             	mov    0x4(%edx),%edx
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
  80269d:	eb 0b                	jmp    8026aa <alloc_block_NF+0x7f>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0f                	je     8026c3 <alloc_block_NF+0x98>
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bd:	8b 12                	mov    (%edx),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	eb 0a                	jmp    8026cd <alloc_block_NF+0xa2>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	a3 38 41 80 00       	mov    %eax,0x804138
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8026e5:	48                   	dec    %eax
  8026e6:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 08             	mov    0x8(%eax),%eax
  8026f1:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	e9 f8 04 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	3b 45 08             	cmp    0x8(%ebp),%eax
  802707:	0f 86 d4 00 00 00    	jbe    8027e1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80270d:	a1 48 41 80 00       	mov    0x804148,%eax
  802712:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 50 08             	mov    0x8(%eax),%edx
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 55 08             	mov    0x8(%ebp),%edx
  802727:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80272a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272e:	75 17                	jne    802747 <alloc_block_NF+0x11c>
  802730:	83 ec 04             	sub    $0x4,%esp
  802733:	68 58 3f 80 00       	push   $0x803f58
  802738:	68 e9 00 00 00       	push   $0xe9
  80273d:	68 af 3e 80 00       	push   $0x803eaf
  802742:	e8 df db ff ff       	call   800326 <_panic>
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 10                	je     802760 <alloc_block_NF+0x135>
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	8b 00                	mov    (%eax),%eax
  802755:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802758:	8b 52 04             	mov    0x4(%edx),%edx
  80275b:	89 50 04             	mov    %edx,0x4(%eax)
  80275e:	eb 0b                	jmp    80276b <alloc_block_NF+0x140>
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	74 0f                	je     802784 <alloc_block_NF+0x159>
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	8b 40 04             	mov    0x4(%eax),%eax
  80277b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277e:	8b 12                	mov    (%edx),%edx
  802780:	89 10                	mov    %edx,(%eax)
  802782:	eb 0a                	jmp    80278e <alloc_block_NF+0x163>
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	a3 48 41 80 00       	mov    %eax,0x804148
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a1:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a6:	48                   	dec    %eax
  8027a7:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027af:	8b 40 08             	mov    0x8(%eax),%eax
  8027b2:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 50 08             	mov    0x8(%eax),%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	01 c2                	add    %eax,%edx
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d1:	89 c2                	mov    %eax,%edx
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	e9 15 04 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027e1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ed:	74 07                	je     8027f6 <alloc_block_NF+0x1cb>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	eb 05                	jmp    8027fb <alloc_block_NF+0x1d0>
  8027f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fb:	a3 40 41 80 00       	mov    %eax,0x804140
  802800:	a1 40 41 80 00       	mov    0x804140,%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	0f 85 3e fe ff ff    	jne    80264b <alloc_block_NF+0x20>
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	0f 85 34 fe ff ff    	jne    80264b <alloc_block_NF+0x20>
  802817:	e9 d5 03 00 00       	jmp    802bf1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80281c:	a1 38 41 80 00       	mov    0x804138,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	e9 b1 01 00 00       	jmp    8029da <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 50 08             	mov    0x8(%eax),%edx
  80282f:	a1 28 40 80 00       	mov    0x804028,%eax
  802834:	39 c2                	cmp    %eax,%edx
  802836:	0f 82 96 01 00 00    	jb     8029d2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 82 87 01 00 00    	jb     8029d2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 85 95 00 00 00    	jne    8028ef <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80285a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285e:	75 17                	jne    802877 <alloc_block_NF+0x24c>
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	68 58 3f 80 00       	push   $0x803f58
  802868:	68 fc 00 00 00       	push   $0xfc
  80286d:	68 af 3e 80 00       	push   $0x803eaf
  802872:	e8 af da ff ff       	call   800326 <_panic>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 10                	je     802890 <alloc_block_NF+0x265>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802888:	8b 52 04             	mov    0x4(%edx),%edx
  80288b:	89 50 04             	mov    %edx,0x4(%eax)
  80288e:	eb 0b                	jmp    80289b <alloc_block_NF+0x270>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 04             	mov    0x4(%eax),%eax
  802896:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 04             	mov    0x4(%eax),%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	74 0f                	je     8028b4 <alloc_block_NF+0x289>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ae:	8b 12                	mov    (%edx),%edx
  8028b0:	89 10                	mov    %edx,(%eax)
  8028b2:	eb 0a                	jmp    8028be <alloc_block_NF+0x293>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d6:	48                   	dec    %eax
  8028d7:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 08             	mov    0x8(%eax),%eax
  8028e2:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	e9 07 03 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f8:	0f 86 d4 00 00 00    	jbe    8029d2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028fe:	a1 48 41 80 00       	mov    0x804148,%eax
  802903:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 50 08             	mov    0x8(%eax),%edx
  80290c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802915:	8b 55 08             	mov    0x8(%ebp),%edx
  802918:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80291b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80291f:	75 17                	jne    802938 <alloc_block_NF+0x30d>
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 58 3f 80 00       	push   $0x803f58
  802929:	68 04 01 00 00       	push   $0x104
  80292e:	68 af 3e 80 00       	push   $0x803eaf
  802933:	e8 ee d9 ff ff       	call   800326 <_panic>
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 10                	je     802951 <alloc_block_NF+0x326>
  802941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802949:	8b 52 04             	mov    0x4(%edx),%edx
  80294c:	89 50 04             	mov    %edx,0x4(%eax)
  80294f:	eb 0b                	jmp    80295c <alloc_block_NF+0x331>
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80295c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0f                	je     802975 <alloc_block_NF+0x34a>
  802966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802969:	8b 40 04             	mov    0x4(%eax),%eax
  80296c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296f:	8b 12                	mov    (%edx),%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	eb 0a                	jmp    80297f <alloc_block_NF+0x354>
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	a3 48 41 80 00       	mov    %eax,0x804148
  80297f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802992:	a1 54 41 80 00       	mov    0x804154,%eax
  802997:	48                   	dec    %eax
  802998:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a0:	8b 40 08             	mov    0x8(%eax),%eax
  8029a3:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 50 08             	mov    0x8(%eax),%edx
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	01 c2                	add    %eax,%edx
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c2:	89 c2                	mov    %eax,%edx
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cd:	e9 24 02 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029d2:	a1 40 41 80 00       	mov    0x804140,%eax
  8029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029de:	74 07                	je     8029e7 <alloc_block_NF+0x3bc>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	eb 05                	jmp    8029ec <alloc_block_NF+0x3c1>
  8029e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ec:	a3 40 41 80 00       	mov    %eax,0x804140
  8029f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	0f 85 2b fe ff ff    	jne    802829 <alloc_block_NF+0x1fe>
  8029fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a02:	0f 85 21 fe ff ff    	jne    802829 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a08:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a10:	e9 ae 01 00 00       	jmp    802bc3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 50 08             	mov    0x8(%eax),%edx
  802a1b:	a1 28 40 80 00       	mov    0x804028,%eax
  802a20:	39 c2                	cmp    %eax,%edx
  802a22:	0f 83 93 01 00 00    	jae    802bbb <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a31:	0f 82 84 01 00 00    	jb     802bbb <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a40:	0f 85 95 00 00 00    	jne    802adb <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4a:	75 17                	jne    802a63 <alloc_block_NF+0x438>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 58 3f 80 00       	push   $0x803f58
  802a54:	68 14 01 00 00       	push   $0x114
  802a59:	68 af 3e 80 00       	push   $0x803eaf
  802a5e:	e8 c3 d8 ff ff       	call   800326 <_panic>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 10                	je     802a7c <alloc_block_NF+0x451>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a74:	8b 52 04             	mov    0x4(%edx),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%eax)
  802a7a:	eb 0b                	jmp    802a87 <alloc_block_NF+0x45c>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0f                	je     802aa0 <alloc_block_NF+0x475>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9a:	8b 12                	mov    (%edx),%edx
  802a9c:	89 10                	mov    %edx,(%eax)
  802a9e:	eb 0a                	jmp    802aaa <alloc_block_NF+0x47f>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	a3 38 41 80 00       	mov    %eax,0x804138
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abd:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac2:	48                   	dec    %eax
  802ac3:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 08             	mov    0x8(%eax),%eax
  802ace:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	e9 1b 01 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae4:	0f 86 d1 00 00 00    	jbe    802bbb <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aea:	a1 48 41 80 00       	mov    0x804148,%eax
  802aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 50 08             	mov    0x8(%eax),%edx
  802af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	8b 55 08             	mov    0x8(%ebp),%edx
  802b04:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b0b:	75 17                	jne    802b24 <alloc_block_NF+0x4f9>
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	68 58 3f 80 00       	push   $0x803f58
  802b15:	68 1c 01 00 00       	push   $0x11c
  802b1a:	68 af 3e 80 00       	push   $0x803eaf
  802b1f:	e8 02 d8 ff ff       	call   800326 <_panic>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	74 10                	je     802b3d <alloc_block_NF+0x512>
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b35:	8b 52 04             	mov    0x4(%edx),%edx
  802b38:	89 50 04             	mov    %edx,0x4(%eax)
  802b3b:	eb 0b                	jmp    802b48 <alloc_block_NF+0x51d>
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 40 04             	mov    0x4(%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 0f                	je     802b61 <alloc_block_NF+0x536>
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5b:	8b 12                	mov    (%edx),%edx
  802b5d:	89 10                	mov    %edx,(%eax)
  802b5f:	eb 0a                	jmp    802b6b <alloc_block_NF+0x540>
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	a3 48 41 80 00       	mov    %eax,0x804148
  802b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7e:	a1 54 41 80 00       	mov    0x804154,%eax
  802b83:	48                   	dec    %eax
  802b84:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	01 c2                	add    %eax,%edx
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	2b 45 08             	sub    0x8(%ebp),%eax
  802bae:	89 c2                	mov    %eax,%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb9:	eb 3b                	jmp    802bf6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bbb:	a1 40 41 80 00       	mov    0x804140,%eax
  802bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc7:	74 07                	je     802bd0 <alloc_block_NF+0x5a5>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	eb 05                	jmp    802bd5 <alloc_block_NF+0x5aa>
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd5:	a3 40 41 80 00       	mov    %eax,0x804140
  802bda:	a1 40 41 80 00       	mov    0x804140,%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	0f 85 2e fe ff ff    	jne    802a15 <alloc_block_NF+0x3ea>
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	0f 85 24 fe ff ff    	jne    802a15 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bfe:	a1 38 41 80 00       	mov    0x804138,%eax
  802c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c06:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c0e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 14                	je     802c2b <insert_sorted_with_merge_freeList+0x33>
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	8b 40 08             	mov    0x8(%eax),%eax
  802c23:	39 c2                	cmp    %eax,%edx
  802c25:	0f 87 9b 01 00 00    	ja     802dc6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2f:	75 17                	jne    802c48 <insert_sorted_with_merge_freeList+0x50>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 8c 3e 80 00       	push   $0x803e8c
  802c39:	68 38 01 00 00       	push   $0x138
  802c3e:	68 af 3e 80 00       	push   $0x803eaf
  802c43:	e8 de d6 ff ff       	call   800326 <_panic>
  802c48:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	89 10                	mov    %edx,(%eax)
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 0d                	je     802c69 <insert_sorted_with_merge_freeList+0x71>
  802c5c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c61:	8b 55 08             	mov    0x8(%ebp),%edx
  802c64:	89 50 04             	mov    %edx,0x4(%eax)
  802c67:	eb 08                	jmp    802c71 <insert_sorted_with_merge_freeList+0x79>
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	a3 38 41 80 00       	mov    %eax,0x804138
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 44 41 80 00       	mov    0x804144,%eax
  802c88:	40                   	inc    %eax
  802c89:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c92:	0f 84 a8 06 00 00    	je     803340 <insert_sorted_with_merge_freeList+0x748>
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	01 c2                	add    %eax,%edx
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 40 08             	mov    0x8(%eax),%eax
  802cac:	39 c2                	cmp    %eax,%edx
  802cae:	0f 85 8c 06 00 00    	jne    803340 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8b 50 0c             	mov    0xc(%eax),%edx
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc0:	01 c2                	add    %eax,%edx
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccc:	75 17                	jne    802ce5 <insert_sorted_with_merge_freeList+0xed>
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 58 3f 80 00       	push   $0x803f58
  802cd6:	68 3c 01 00 00       	push   $0x13c
  802cdb:	68 af 3e 80 00       	push   $0x803eaf
  802ce0:	e8 41 d6 ff ff       	call   800326 <_panic>
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 10                	je     802cfe <insert_sorted_with_merge_freeList+0x106>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf6:	8b 52 04             	mov    0x4(%edx),%edx
  802cf9:	89 50 04             	mov    %edx,0x4(%eax)
  802cfc:	eb 0b                	jmp    802d09 <insert_sorted_with_merge_freeList+0x111>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 40 04             	mov    0x4(%eax),%eax
  802d04:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	74 0f                	je     802d22 <insert_sorted_with_merge_freeList+0x12a>
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1c:	8b 12                	mov    (%edx),%edx
  802d1e:	89 10                	mov    %edx,(%eax)
  802d20:	eb 0a                	jmp    802d2c <insert_sorted_with_merge_freeList+0x134>
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d44:	48                   	dec    %eax
  802d45:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d62:	75 17                	jne    802d7b <insert_sorted_with_merge_freeList+0x183>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 8c 3e 80 00       	push   $0x803e8c
  802d6c:	68 3f 01 00 00       	push   $0x13f
  802d71:	68 af 3e 80 00       	push   $0x803eaf
  802d76:	e8 ab d5 ff ff       	call   800326 <_panic>
  802d7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	89 10                	mov    %edx,(%eax)
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0d                	je     802d9c <insert_sorted_with_merge_freeList+0x1a4>
  802d8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802d94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d97:	89 50 04             	mov    %edx,0x4(%eax)
  802d9a:	eb 08                	jmp    802da4 <insert_sorted_with_merge_freeList+0x1ac>
  802d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	a3 48 41 80 00       	mov    %eax,0x804148
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db6:	a1 54 41 80 00       	mov    0x804154,%eax
  802dbb:	40                   	inc    %eax
  802dbc:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dc1:	e9 7a 05 00 00       	jmp    803340 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 50 08             	mov    0x8(%eax),%edx
  802dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcf:	8b 40 08             	mov    0x8(%eax),%eax
  802dd2:	39 c2                	cmp    %eax,%edx
  802dd4:	0f 82 14 01 00 00    	jb     802eee <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	8b 50 08             	mov    0x8(%eax),%edx
  802de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de3:	8b 40 0c             	mov    0xc(%eax),%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 40 08             	mov    0x8(%eax),%eax
  802dee:	39 c2                	cmp    %eax,%edx
  802df0:	0f 85 90 00 00 00    	jne    802e86 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	01 c2                	add    %eax,%edx
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e22:	75 17                	jne    802e3b <insert_sorted_with_merge_freeList+0x243>
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	68 8c 3e 80 00       	push   $0x803e8c
  802e2c:	68 49 01 00 00       	push   $0x149
  802e31:	68 af 3e 80 00       	push   $0x803eaf
  802e36:	e8 eb d4 ff ff       	call   800326 <_panic>
  802e3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	89 10                	mov    %edx,(%eax)
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0d                	je     802e5c <insert_sorted_with_merge_freeList+0x264>
  802e4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_with_merge_freeList+0x26c>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7b:	40                   	inc    %eax
  802e7c:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e81:	e9 bb 04 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8a:	75 17                	jne    802ea3 <insert_sorted_with_merge_freeList+0x2ab>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 00 3f 80 00       	push   $0x803f00
  802e94:	68 4c 01 00 00       	push   $0x14c
  802e99:	68 af 3e 80 00       	push   $0x803eaf
  802e9e:	e8 83 d4 ff ff       	call   800326 <_panic>
  802ea3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	89 50 04             	mov    %edx,0x4(%eax)
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 0c                	je     802ec5 <insert_sorted_with_merge_freeList+0x2cd>
  802eb9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	eb 08                	jmp    802ecd <insert_sorted_with_merge_freeList+0x2d5>
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	a3 38 41 80 00       	mov    %eax,0x804138
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ede:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee3:	40                   	inc    %eax
  802ee4:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee9:	e9 53 04 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eee:	a1 38 41 80 00       	mov    0x804138,%eax
  802ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef6:	e9 15 04 00 00       	jmp    803310 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 50 08             	mov    0x8(%eax),%edx
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 40 08             	mov    0x8(%eax),%eax
  802f0f:	39 c2                	cmp    %eax,%edx
  802f11:	0f 86 f1 03 00 00    	jbe    803308 <insert_sorted_with_merge_freeList+0x710>
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 50 08             	mov    0x8(%eax),%edx
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	8b 40 08             	mov    0x8(%eax),%eax
  802f23:	39 c2                	cmp    %eax,%edx
  802f25:	0f 83 dd 03 00 00    	jae    803308 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 50 08             	mov    0x8(%eax),%edx
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 0c             	mov    0xc(%eax),%eax
  802f37:	01 c2                	add    %eax,%edx
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	8b 40 08             	mov    0x8(%eax),%eax
  802f3f:	39 c2                	cmp    %eax,%edx
  802f41:	0f 85 b9 01 00 00    	jne    803100 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 50 08             	mov    0x8(%eax),%edx
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8b 40 0c             	mov    0xc(%eax),%eax
  802f53:	01 c2                	add    %eax,%edx
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	39 c2                	cmp    %eax,%edx
  802f5d:	0f 85 0d 01 00 00    	jne    803070 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 50 0c             	mov    0xc(%eax),%edx
  802f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7b:	75 17                	jne    802f94 <insert_sorted_with_merge_freeList+0x39c>
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 58 3f 80 00       	push   $0x803f58
  802f85:	68 5c 01 00 00       	push   $0x15c
  802f8a:	68 af 3e 80 00       	push   $0x803eaf
  802f8f:	e8 92 d3 ff ff       	call   800326 <_panic>
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 10                	je     802fad <insert_sorted_with_merge_freeList+0x3b5>
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa5:	8b 52 04             	mov    0x4(%edx),%edx
  802fa8:	89 50 04             	mov    %edx,0x4(%eax)
  802fab:	eb 0b                	jmp    802fb8 <insert_sorted_with_merge_freeList+0x3c0>
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 40 04             	mov    0x4(%eax),%eax
  802fb3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0f                	je     802fd1 <insert_sorted_with_merge_freeList+0x3d9>
  802fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fcb:	8b 12                	mov    (%edx),%edx
  802fcd:	89 10                	mov    %edx,(%eax)
  802fcf:	eb 0a                	jmp    802fdb <insert_sorted_with_merge_freeList+0x3e3>
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	a3 38 41 80 00       	mov    %eax,0x804138
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fee:	a1 44 41 80 00       	mov    0x804144,%eax
  802ff3:	48                   	dec    %eax
  802ff4:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80300d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803011:	75 17                	jne    80302a <insert_sorted_with_merge_freeList+0x432>
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	68 8c 3e 80 00       	push   $0x803e8c
  80301b:	68 5f 01 00 00       	push   $0x15f
  803020:	68 af 3e 80 00       	push   $0x803eaf
  803025:	e8 fc d2 ff ff       	call   800326 <_panic>
  80302a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	89 10                	mov    %edx,(%eax)
  803035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0d                	je     80304b <insert_sorted_with_merge_freeList+0x453>
  80303e:	a1 48 41 80 00       	mov    0x804148,%eax
  803043:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803046:	89 50 04             	mov    %edx,0x4(%eax)
  803049:	eb 08                	jmp    803053 <insert_sorted_with_merge_freeList+0x45b>
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	a3 48 41 80 00       	mov    %eax,0x804148
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 54 41 80 00       	mov    0x804154,%eax
  80306a:	40                   	inc    %eax
  80306b:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 50 0c             	mov    0xc(%eax),%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	01 c2                	add    %eax,%edx
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803098:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309c:	75 17                	jne    8030b5 <insert_sorted_with_merge_freeList+0x4bd>
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	68 8c 3e 80 00       	push   $0x803e8c
  8030a6:	68 64 01 00 00       	push   $0x164
  8030ab:	68 af 3e 80 00       	push   $0x803eaf
  8030b0:	e8 71 d2 ff ff       	call   800326 <_panic>
  8030b5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0d                	je     8030d6 <insert_sorted_with_merge_freeList+0x4de>
  8030c9:	a1 48 41 80 00       	mov    0x804148,%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	eb 08                	jmp    8030de <insert_sorted_with_merge_freeList+0x4e6>
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8030f5:	40                   	inc    %eax
  8030f6:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030fb:	e9 41 02 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	8b 40 0c             	mov    0xc(%eax),%eax
  80310c:	01 c2                	add    %eax,%edx
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	8b 40 08             	mov    0x8(%eax),%eax
  803114:	39 c2                	cmp    %eax,%edx
  803116:	0f 85 7c 01 00 00    	jne    803298 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80311c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803120:	74 06                	je     803128 <insert_sorted_with_merge_freeList+0x530>
  803122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803126:	75 17                	jne    80313f <insert_sorted_with_merge_freeList+0x547>
  803128:	83 ec 04             	sub    $0x4,%esp
  80312b:	68 c8 3e 80 00       	push   $0x803ec8
  803130:	68 69 01 00 00       	push   $0x169
  803135:	68 af 3e 80 00       	push   $0x803eaf
  80313a:	e8 e7 d1 ff ff       	call   800326 <_panic>
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 50 04             	mov    0x4(%eax),%edx
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803151:	89 10                	mov    %edx,(%eax)
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 04             	mov    0x4(%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 0d                	je     80316a <insert_sorted_with_merge_freeList+0x572>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	8b 55 08             	mov    0x8(%ebp),%edx
  803166:	89 10                	mov    %edx,(%eax)
  803168:	eb 08                	jmp    803172 <insert_sorted_with_merge_freeList+0x57a>
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	a3 38 41 80 00       	mov    %eax,0x804138
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 55 08             	mov    0x8(%ebp),%edx
  803178:	89 50 04             	mov    %edx,0x4(%eax)
  80317b:	a1 44 41 80 00       	mov    0x804144,%eax
  803180:	40                   	inc    %eax
  803181:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	8b 50 0c             	mov    0xc(%eax),%edx
  80318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318f:	8b 40 0c             	mov    0xc(%eax),%eax
  803192:	01 c2                	add    %eax,%edx
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80319a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0x5bf>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 58 3f 80 00       	push   $0x803f58
  8031a8:	68 6b 01 00 00       	push   $0x16b
  8031ad:	68 af 3e 80 00       	push   $0x803eaf
  8031b2:	e8 6f d1 ff ff       	call   800326 <_panic>
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 10                	je     8031d0 <insert_sorted_with_merge_freeList+0x5d8>
  8031c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c8:	8b 52 04             	mov    0x4(%edx),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	eb 0b                	jmp    8031db <insert_sorted_with_merge_freeList+0x5e3>
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0f                	je     8031f4 <insert_sorted_with_merge_freeList+0x5fc>
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ee:	8b 12                	mov    (%edx),%edx
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	eb 0a                	jmp    8031fe <insert_sorted_with_merge_freeList+0x606>
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803211:	a1 44 41 80 00       	mov    0x804144,%eax
  803216:	48                   	dec    %eax
  803217:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803230:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803234:	75 17                	jne    80324d <insert_sorted_with_merge_freeList+0x655>
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	68 8c 3e 80 00       	push   $0x803e8c
  80323e:	68 6e 01 00 00       	push   $0x16e
  803243:	68 af 3e 80 00       	push   $0x803eaf
  803248:	e8 d9 d0 ff ff       	call   800326 <_panic>
  80324d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	89 10                	mov    %edx,(%eax)
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0d                	je     80326e <insert_sorted_with_merge_freeList+0x676>
  803261:	a1 48 41 80 00       	mov    0x804148,%eax
  803266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803269:	89 50 04             	mov    %edx,0x4(%eax)
  80326c:	eb 08                	jmp    803276 <insert_sorted_with_merge_freeList+0x67e>
  80326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803271:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	a3 48 41 80 00       	mov    %eax,0x804148
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803288:	a1 54 41 80 00       	mov    0x804154,%eax
  80328d:	40                   	inc    %eax
  80328e:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803293:	e9 a9 00 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803298:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329c:	74 06                	je     8032a4 <insert_sorted_with_merge_freeList+0x6ac>
  80329e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a2:	75 17                	jne    8032bb <insert_sorted_with_merge_freeList+0x6c3>
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	68 24 3f 80 00       	push   $0x803f24
  8032ac:	68 73 01 00 00       	push   $0x173
  8032b1:	68 af 3e 80 00       	push   $0x803eaf
  8032b6:	e8 6b d0 ff ff       	call   800326 <_panic>
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 10                	mov    (%eax),%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 0b                	je     8032d9 <insert_sorted_with_merge_freeList+0x6e1>
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032df:	89 10                	mov    %edx,(%eax)
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	8b 00                	mov    (%eax),%eax
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	75 08                	jne    8032fb <insert_sorted_with_merge_freeList+0x703>
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032fb:	a1 44 41 80 00       	mov    0x804144,%eax
  803300:	40                   	inc    %eax
  803301:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803306:	eb 39                	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803308:	a1 40 41 80 00       	mov    0x804140,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803314:	74 07                	je     80331d <insert_sorted_with_merge_freeList+0x725>
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	eb 05                	jmp    803322 <insert_sorted_with_merge_freeList+0x72a>
  80331d:	b8 00 00 00 00       	mov    $0x0,%eax
  803322:	a3 40 41 80 00       	mov    %eax,0x804140
  803327:	a1 40 41 80 00       	mov    0x804140,%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	0f 85 c7 fb ff ff    	jne    802efb <insert_sorted_with_merge_freeList+0x303>
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	0f 85 bd fb ff ff    	jne    802efb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80333e:	eb 01                	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803340:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803341:	90                   	nop
  803342:	c9                   	leave  
  803343:	c3                   	ret    

00803344 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803344:	55                   	push   %ebp
  803345:	89 e5                	mov    %esp,%ebp
  803347:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80334a:	8b 55 08             	mov    0x8(%ebp),%edx
  80334d:	89 d0                	mov    %edx,%eax
  80334f:	c1 e0 02             	shl    $0x2,%eax
  803352:	01 d0                	add    %edx,%eax
  803354:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80335b:	01 d0                	add    %edx,%eax
  80335d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803364:	01 d0                	add    %edx,%eax
  803366:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80336d:	01 d0                	add    %edx,%eax
  80336f:	c1 e0 04             	shl    $0x4,%eax
  803372:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803375:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80337c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80337f:	83 ec 0c             	sub    $0xc,%esp
  803382:	50                   	push   %eax
  803383:	e8 26 e7 ff ff       	call   801aae <sys_get_virtual_time>
  803388:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80338b:	eb 41                	jmp    8033ce <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80338d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803390:	83 ec 0c             	sub    $0xc,%esp
  803393:	50                   	push   %eax
  803394:	e8 15 e7 ff ff       	call   801aae <sys_get_virtual_time>
  803399:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80339c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	29 c2                	sub    %eax,%edx
  8033a4:	89 d0                	mov    %edx,%eax
  8033a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033af:	89 d1                	mov    %edx,%ecx
  8033b1:	29 c1                	sub    %eax,%ecx
  8033b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b9:	39 c2                	cmp    %eax,%edx
  8033bb:	0f 97 c0             	seta   %al
  8033be:	0f b6 c0             	movzbl %al,%eax
  8033c1:	29 c1                	sub    %eax,%ecx
  8033c3:	89 c8                	mov    %ecx,%eax
  8033c5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033d4:	72 b7                	jb     80338d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033d6:	90                   	nop
  8033d7:	c9                   	leave  
  8033d8:	c3                   	ret    

008033d9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033d9:	55                   	push   %ebp
  8033da:	89 e5                	mov    %esp,%ebp
  8033dc:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8033df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033e6:	eb 03                	jmp    8033eb <busy_wait+0x12>
  8033e8:	ff 45 fc             	incl   -0x4(%ebp)
  8033eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033f1:	72 f5                	jb     8033e8 <busy_wait+0xf>
	return i;
  8033f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033f6:	c9                   	leave  
  8033f7:	c3                   	ret    

008033f8 <__udivdi3>:
  8033f8:	55                   	push   %ebp
  8033f9:	57                   	push   %edi
  8033fa:	56                   	push   %esi
  8033fb:	53                   	push   %ebx
  8033fc:	83 ec 1c             	sub    $0x1c,%esp
  8033ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803403:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803407:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80340b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80340f:	89 ca                	mov    %ecx,%edx
  803411:	89 f8                	mov    %edi,%eax
  803413:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803417:	85 f6                	test   %esi,%esi
  803419:	75 2d                	jne    803448 <__udivdi3+0x50>
  80341b:	39 cf                	cmp    %ecx,%edi
  80341d:	77 65                	ja     803484 <__udivdi3+0x8c>
  80341f:	89 fd                	mov    %edi,%ebp
  803421:	85 ff                	test   %edi,%edi
  803423:	75 0b                	jne    803430 <__udivdi3+0x38>
  803425:	b8 01 00 00 00       	mov    $0x1,%eax
  80342a:	31 d2                	xor    %edx,%edx
  80342c:	f7 f7                	div    %edi
  80342e:	89 c5                	mov    %eax,%ebp
  803430:	31 d2                	xor    %edx,%edx
  803432:	89 c8                	mov    %ecx,%eax
  803434:	f7 f5                	div    %ebp
  803436:	89 c1                	mov    %eax,%ecx
  803438:	89 d8                	mov    %ebx,%eax
  80343a:	f7 f5                	div    %ebp
  80343c:	89 cf                	mov    %ecx,%edi
  80343e:	89 fa                	mov    %edi,%edx
  803440:	83 c4 1c             	add    $0x1c,%esp
  803443:	5b                   	pop    %ebx
  803444:	5e                   	pop    %esi
  803445:	5f                   	pop    %edi
  803446:	5d                   	pop    %ebp
  803447:	c3                   	ret    
  803448:	39 ce                	cmp    %ecx,%esi
  80344a:	77 28                	ja     803474 <__udivdi3+0x7c>
  80344c:	0f bd fe             	bsr    %esi,%edi
  80344f:	83 f7 1f             	xor    $0x1f,%edi
  803452:	75 40                	jne    803494 <__udivdi3+0x9c>
  803454:	39 ce                	cmp    %ecx,%esi
  803456:	72 0a                	jb     803462 <__udivdi3+0x6a>
  803458:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80345c:	0f 87 9e 00 00 00    	ja     803500 <__udivdi3+0x108>
  803462:	b8 01 00 00 00       	mov    $0x1,%eax
  803467:	89 fa                	mov    %edi,%edx
  803469:	83 c4 1c             	add    $0x1c,%esp
  80346c:	5b                   	pop    %ebx
  80346d:	5e                   	pop    %esi
  80346e:	5f                   	pop    %edi
  80346f:	5d                   	pop    %ebp
  803470:	c3                   	ret    
  803471:	8d 76 00             	lea    0x0(%esi),%esi
  803474:	31 ff                	xor    %edi,%edi
  803476:	31 c0                	xor    %eax,%eax
  803478:	89 fa                	mov    %edi,%edx
  80347a:	83 c4 1c             	add    $0x1c,%esp
  80347d:	5b                   	pop    %ebx
  80347e:	5e                   	pop    %esi
  80347f:	5f                   	pop    %edi
  803480:	5d                   	pop    %ebp
  803481:	c3                   	ret    
  803482:	66 90                	xchg   %ax,%ax
  803484:	89 d8                	mov    %ebx,%eax
  803486:	f7 f7                	div    %edi
  803488:	31 ff                	xor    %edi,%edi
  80348a:	89 fa                	mov    %edi,%edx
  80348c:	83 c4 1c             	add    $0x1c,%esp
  80348f:	5b                   	pop    %ebx
  803490:	5e                   	pop    %esi
  803491:	5f                   	pop    %edi
  803492:	5d                   	pop    %ebp
  803493:	c3                   	ret    
  803494:	bd 20 00 00 00       	mov    $0x20,%ebp
  803499:	89 eb                	mov    %ebp,%ebx
  80349b:	29 fb                	sub    %edi,%ebx
  80349d:	89 f9                	mov    %edi,%ecx
  80349f:	d3 e6                	shl    %cl,%esi
  8034a1:	89 c5                	mov    %eax,%ebp
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 ed                	shr    %cl,%ebp
  8034a7:	89 e9                	mov    %ebp,%ecx
  8034a9:	09 f1                	or     %esi,%ecx
  8034ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034af:	89 f9                	mov    %edi,%ecx
  8034b1:	d3 e0                	shl    %cl,%eax
  8034b3:	89 c5                	mov    %eax,%ebp
  8034b5:	89 d6                	mov    %edx,%esi
  8034b7:	88 d9                	mov    %bl,%cl
  8034b9:	d3 ee                	shr    %cl,%esi
  8034bb:	89 f9                	mov    %edi,%ecx
  8034bd:	d3 e2                	shl    %cl,%edx
  8034bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c3:	88 d9                	mov    %bl,%cl
  8034c5:	d3 e8                	shr    %cl,%eax
  8034c7:	09 c2                	or     %eax,%edx
  8034c9:	89 d0                	mov    %edx,%eax
  8034cb:	89 f2                	mov    %esi,%edx
  8034cd:	f7 74 24 0c          	divl   0xc(%esp)
  8034d1:	89 d6                	mov    %edx,%esi
  8034d3:	89 c3                	mov    %eax,%ebx
  8034d5:	f7 e5                	mul    %ebp
  8034d7:	39 d6                	cmp    %edx,%esi
  8034d9:	72 19                	jb     8034f4 <__udivdi3+0xfc>
  8034db:	74 0b                	je     8034e8 <__udivdi3+0xf0>
  8034dd:	89 d8                	mov    %ebx,%eax
  8034df:	31 ff                	xor    %edi,%edi
  8034e1:	e9 58 ff ff ff       	jmp    80343e <__udivdi3+0x46>
  8034e6:	66 90                	xchg   %ax,%ax
  8034e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034ec:	89 f9                	mov    %edi,%ecx
  8034ee:	d3 e2                	shl    %cl,%edx
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	73 e9                	jae    8034dd <__udivdi3+0xe5>
  8034f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034f7:	31 ff                	xor    %edi,%edi
  8034f9:	e9 40 ff ff ff       	jmp    80343e <__udivdi3+0x46>
  8034fe:	66 90                	xchg   %ax,%ax
  803500:	31 c0                	xor    %eax,%eax
  803502:	e9 37 ff ff ff       	jmp    80343e <__udivdi3+0x46>
  803507:	90                   	nop

00803508 <__umoddi3>:
  803508:	55                   	push   %ebp
  803509:	57                   	push   %edi
  80350a:	56                   	push   %esi
  80350b:	53                   	push   %ebx
  80350c:	83 ec 1c             	sub    $0x1c,%esp
  80350f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803513:	8b 74 24 34          	mov    0x34(%esp),%esi
  803517:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80351b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80351f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803523:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803527:	89 f3                	mov    %esi,%ebx
  803529:	89 fa                	mov    %edi,%edx
  80352b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80352f:	89 34 24             	mov    %esi,(%esp)
  803532:	85 c0                	test   %eax,%eax
  803534:	75 1a                	jne    803550 <__umoddi3+0x48>
  803536:	39 f7                	cmp    %esi,%edi
  803538:	0f 86 a2 00 00 00    	jbe    8035e0 <__umoddi3+0xd8>
  80353e:	89 c8                	mov    %ecx,%eax
  803540:	89 f2                	mov    %esi,%edx
  803542:	f7 f7                	div    %edi
  803544:	89 d0                	mov    %edx,%eax
  803546:	31 d2                	xor    %edx,%edx
  803548:	83 c4 1c             	add    $0x1c,%esp
  80354b:	5b                   	pop    %ebx
  80354c:	5e                   	pop    %esi
  80354d:	5f                   	pop    %edi
  80354e:	5d                   	pop    %ebp
  80354f:	c3                   	ret    
  803550:	39 f0                	cmp    %esi,%eax
  803552:	0f 87 ac 00 00 00    	ja     803604 <__umoddi3+0xfc>
  803558:	0f bd e8             	bsr    %eax,%ebp
  80355b:	83 f5 1f             	xor    $0x1f,%ebp
  80355e:	0f 84 ac 00 00 00    	je     803610 <__umoddi3+0x108>
  803564:	bf 20 00 00 00       	mov    $0x20,%edi
  803569:	29 ef                	sub    %ebp,%edi
  80356b:	89 fe                	mov    %edi,%esi
  80356d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803571:	89 e9                	mov    %ebp,%ecx
  803573:	d3 e0                	shl    %cl,%eax
  803575:	89 d7                	mov    %edx,%edi
  803577:	89 f1                	mov    %esi,%ecx
  803579:	d3 ef                	shr    %cl,%edi
  80357b:	09 c7                	or     %eax,%edi
  80357d:	89 e9                	mov    %ebp,%ecx
  80357f:	d3 e2                	shl    %cl,%edx
  803581:	89 14 24             	mov    %edx,(%esp)
  803584:	89 d8                	mov    %ebx,%eax
  803586:	d3 e0                	shl    %cl,%eax
  803588:	89 c2                	mov    %eax,%edx
  80358a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358e:	d3 e0                	shl    %cl,%eax
  803590:	89 44 24 04          	mov    %eax,0x4(%esp)
  803594:	8b 44 24 08          	mov    0x8(%esp),%eax
  803598:	89 f1                	mov    %esi,%ecx
  80359a:	d3 e8                	shr    %cl,%eax
  80359c:	09 d0                	or     %edx,%eax
  80359e:	d3 eb                	shr    %cl,%ebx
  8035a0:	89 da                	mov    %ebx,%edx
  8035a2:	f7 f7                	div    %edi
  8035a4:	89 d3                	mov    %edx,%ebx
  8035a6:	f7 24 24             	mull   (%esp)
  8035a9:	89 c6                	mov    %eax,%esi
  8035ab:	89 d1                	mov    %edx,%ecx
  8035ad:	39 d3                	cmp    %edx,%ebx
  8035af:	0f 82 87 00 00 00    	jb     80363c <__umoddi3+0x134>
  8035b5:	0f 84 91 00 00 00    	je     80364c <__umoddi3+0x144>
  8035bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035bf:	29 f2                	sub    %esi,%edx
  8035c1:	19 cb                	sbb    %ecx,%ebx
  8035c3:	89 d8                	mov    %ebx,%eax
  8035c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035c9:	d3 e0                	shl    %cl,%eax
  8035cb:	89 e9                	mov    %ebp,%ecx
  8035cd:	d3 ea                	shr    %cl,%edx
  8035cf:	09 d0                	or     %edx,%eax
  8035d1:	89 e9                	mov    %ebp,%ecx
  8035d3:	d3 eb                	shr    %cl,%ebx
  8035d5:	89 da                	mov    %ebx,%edx
  8035d7:	83 c4 1c             	add    $0x1c,%esp
  8035da:	5b                   	pop    %ebx
  8035db:	5e                   	pop    %esi
  8035dc:	5f                   	pop    %edi
  8035dd:	5d                   	pop    %ebp
  8035de:	c3                   	ret    
  8035df:	90                   	nop
  8035e0:	89 fd                	mov    %edi,%ebp
  8035e2:	85 ff                	test   %edi,%edi
  8035e4:	75 0b                	jne    8035f1 <__umoddi3+0xe9>
  8035e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035eb:	31 d2                	xor    %edx,%edx
  8035ed:	f7 f7                	div    %edi
  8035ef:	89 c5                	mov    %eax,%ebp
  8035f1:	89 f0                	mov    %esi,%eax
  8035f3:	31 d2                	xor    %edx,%edx
  8035f5:	f7 f5                	div    %ebp
  8035f7:	89 c8                	mov    %ecx,%eax
  8035f9:	f7 f5                	div    %ebp
  8035fb:	89 d0                	mov    %edx,%eax
  8035fd:	e9 44 ff ff ff       	jmp    803546 <__umoddi3+0x3e>
  803602:	66 90                	xchg   %ax,%ax
  803604:	89 c8                	mov    %ecx,%eax
  803606:	89 f2                	mov    %esi,%edx
  803608:	83 c4 1c             	add    $0x1c,%esp
  80360b:	5b                   	pop    %ebx
  80360c:	5e                   	pop    %esi
  80360d:	5f                   	pop    %edi
  80360e:	5d                   	pop    %ebp
  80360f:	c3                   	ret    
  803610:	3b 04 24             	cmp    (%esp),%eax
  803613:	72 06                	jb     80361b <__umoddi3+0x113>
  803615:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803619:	77 0f                	ja     80362a <__umoddi3+0x122>
  80361b:	89 f2                	mov    %esi,%edx
  80361d:	29 f9                	sub    %edi,%ecx
  80361f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803623:	89 14 24             	mov    %edx,(%esp)
  803626:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80362a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80362e:	8b 14 24             	mov    (%esp),%edx
  803631:	83 c4 1c             	add    $0x1c,%esp
  803634:	5b                   	pop    %ebx
  803635:	5e                   	pop    %esi
  803636:	5f                   	pop    %edi
  803637:	5d                   	pop    %ebp
  803638:	c3                   	ret    
  803639:	8d 76 00             	lea    0x0(%esi),%esi
  80363c:	2b 04 24             	sub    (%esp),%eax
  80363f:	19 fa                	sbb    %edi,%edx
  803641:	89 d1                	mov    %edx,%ecx
  803643:	89 c6                	mov    %eax,%esi
  803645:	e9 71 ff ff ff       	jmp    8035bb <__umoddi3+0xb3>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803650:	72 ea                	jb     80363c <__umoddi3+0x134>
  803652:	89 d9                	mov    %ebx,%ecx
  803654:	e9 62 ff ff ff       	jmp    8035bb <__umoddi3+0xb3>
