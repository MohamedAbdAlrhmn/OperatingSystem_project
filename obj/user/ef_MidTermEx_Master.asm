
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
  800045:	68 20 37 80 00       	push   $0x803720
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
  800069:	68 22 37 80 00       	push   $0x803722
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
  8000a6:	68 29 37 80 00       	push   $0x803729
  8000ab:	e8 e8 18 00 00       	call   801998 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 2b 37 80 00       	push   $0x80372b
  8000bf:	e8 33 15 00 00       	call   8015f7 <smalloc>
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
  8000ec:	68 39 37 80 00       	push   $0x803739
  8000f1:	e8 b3 19 00 00       	call   801aa9 <sys_create_env>
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
  800115:	68 43 37 80 00       	push   $0x803743
  80011a:	e8 8a 19 00 00       	call   801aa9 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 4d 37 80 00       	push   $0x80374d
  800139:	6a 27                	push   $0x27
  80013b:	68 62 37 80 00       	push   $0x803762
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 77 19 00 00       	call   801ac7 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 99 32 00 00       	call   8033f9 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 59 19 00 00       	call   801ac7 <sys_run_env>
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
  800185:	68 7d 37 80 00       	push   $0x80377d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 99 19 00 00       	call   801b30 <sys_getparentenvid>
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
  8001aa:	68 2b 37 80 00       	push   $0x80372b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 dc 14 00 00       	call   801693 <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 1b 19 00 00       	call   801ae3 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 0d 19 00 00       	call   801ae3 <sys_destroy_env>
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
  8001f0:	e8 22 19 00 00       	call   801b17 <sys_getenvindex>
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
  80025b:	e8 c4 16 00 00       	call   801924 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ac 37 80 00       	push   $0x8037ac
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
  80028b:	68 d4 37 80 00       	push   $0x8037d4
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
  8002bc:	68 fc 37 80 00       	push   $0x8037fc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 54 38 80 00       	push   $0x803854
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 ac 37 80 00       	push   $0x8037ac
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 44 16 00 00       	call   80193e <sys_enable_interrupt>

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
  80030d:	e8 d1 17 00 00       	call   801ae3 <sys_destroy_env>
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
  80031e:	e8 26 18 00 00       	call   801b49 <sys_exit_env>
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
  800347:	68 68 38 80 00       	push   $0x803868
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 6d 38 80 00       	push   $0x80386d
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
  800384:	68 89 38 80 00       	push   $0x803889
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
  8003b0:	68 8c 38 80 00       	push   $0x80388c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 d8 38 80 00       	push   $0x8038d8
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
  800482:	68 e4 38 80 00       	push   $0x8038e4
  800487:	6a 3a                	push   $0x3a
  800489:	68 d8 38 80 00       	push   $0x8038d8
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
  8004f2:	68 38 39 80 00       	push   $0x803938
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 d8 38 80 00       	push   $0x8038d8
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
  80054c:	e8 25 12 00 00       	call   801776 <sys_cputs>
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
  8005c3:	e8 ae 11 00 00       	call   801776 <sys_cputs>
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
  80060d:	e8 12 13 00 00       	call   801924 <sys_disable_interrupt>
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
  80062d:	e8 0c 13 00 00       	call   80193e <sys_enable_interrupt>
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
  800677:	e8 34 2e 00 00       	call   8034b0 <__udivdi3>
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
  8006c7:	e8 f4 2e 00 00       	call   8035c0 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 b4 3b 80 00       	add    $0x803bb4,%eax
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
  800822:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
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
  800903:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 c5 3b 80 00       	push   $0x803bc5
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
  800928:	68 ce 3b 80 00       	push   $0x803bce
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
  800955:	be d1 3b 80 00       	mov    $0x803bd1,%esi
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
  80137b:	68 30 3d 80 00       	push   $0x803d30
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80142e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801442:	83 ec 04             	sub    $0x4,%esp
  801445:	6a 06                	push   $0x6
  801447:	ff 75 f4             	pushl  -0xc(%ebp)
  80144a:	50                   	push   %eax
  80144b:	e8 6a 04 00 00       	call   8018ba <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 41 80 00       	mov    0x804120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 df 0a 00 00       	call   801f40 <initialize_MemBlocksList>
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
  801489:	68 55 3d 80 00       	push   $0x803d55
  80148e:	6a 33                	push   $0x33
  801490:	68 73 3d 80 00       	push   $0x803d73
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
  801508:	68 80 3d 80 00       	push   $0x803d80
  80150d:	6a 34                	push   $0x34
  80150f:	68 73 3d 80 00       	push   $0x803d73
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
  8015a0:	e8 e3 06 00 00       	call   801c88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 11                	je     8015ba <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8015af:	e8 4e 0d 00 00       	call   802302 <alloc_block_FF>
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
  8015c6:	e8 aa 0a 00 00       	call   802075 <insert_sorted_allocList>
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
  8015e6:	68 a4 3d 80 00       	push   $0x803da4
  8015eb:	6a 6f                	push   $0x6f
  8015ed:	68 73 3d 80 00       	push   $0x803d73
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
  80160c:	75 07                	jne    801615 <smalloc+0x1e>
  80160e:	b8 00 00 00 00       	mov    $0x0,%eax
  801613:	eb 7c                	jmp    801691 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801615:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80161c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	48                   	dec    %eax
  801625:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801628:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162b:	ba 00 00 00 00       	mov    $0x0,%edx
  801630:	f7 75 f0             	divl   -0x10(%ebp)
  801633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801636:	29 d0                	sub    %edx,%eax
  801638:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80163b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801642:	e8 41 06 00 00       	call   801c88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801647:	85 c0                	test   %eax,%eax
  801649:	74 11                	je     80165c <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 e8             	pushl  -0x18(%ebp)
  801651:	e8 ac 0c 00 00       	call   802302 <alloc_block_FF>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80165c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801660:	74 2a                	je     80168c <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801665:	8b 40 08             	mov    0x8(%eax),%eax
  801668:	89 c2                	mov    %eax,%edx
  80166a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80166e:	52                   	push   %edx
  80166f:	50                   	push   %eax
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	ff 75 08             	pushl  0x8(%ebp)
  801676:	e8 92 03 00 00       	call   801a0d <sys_createSharedObject>
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801681:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801685:	74 05                	je     80168c <smalloc+0x95>
			return (void*)virtual_address;
  801687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80168a:	eb 05                	jmp    801691 <smalloc+0x9a>
	}
	return NULL;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801699:	e8 c6 fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 c8 3d 80 00       	push   $0x803dc8
  8016a6:	68 b0 00 00 00       	push   $0xb0
  8016ab:	68 73 3d 80 00       	push   $0x803d73
  8016b0:	e8 71 ec ff ff       	call   800326 <_panic>

008016b5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016bb:	e8 a4 fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 ec 3d 80 00       	push   $0x803dec
  8016c8:	68 f4 00 00 00       	push   $0xf4
  8016cd:	68 73 3d 80 00       	push   $0x803d73
  8016d2:	e8 4f ec ff ff       	call   800326 <_panic>

008016d7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	68 14 3e 80 00       	push   $0x803e14
  8016e5:	68 08 01 00 00       	push   $0x108
  8016ea:	68 73 3d 80 00       	push   $0x803d73
  8016ef:	e8 32 ec ff ff       	call   800326 <_panic>

008016f4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	68 38 3e 80 00       	push   $0x803e38
  801702:	68 13 01 00 00       	push   $0x113
  801707:	68 73 3d 80 00       	push   $0x803d73
  80170c:	e8 15 ec ff ff       	call   800326 <_panic>

00801711 <shrink>:

}
void shrink(uint32 newSize)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
  801714:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801717:	83 ec 04             	sub    $0x4,%esp
  80171a:	68 38 3e 80 00       	push   $0x803e38
  80171f:	68 18 01 00 00       	push   $0x118
  801724:	68 73 3d 80 00       	push   $0x803d73
  801729:	e8 f8 eb ff ff       	call   800326 <_panic>

0080172e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	68 38 3e 80 00       	push   $0x803e38
  80173c:	68 1d 01 00 00       	push   $0x11d
  801741:	68 73 3d 80 00       	push   $0x803d73
  801746:	e8 db eb ff ff       	call   800326 <_panic>

0080174b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	57                   	push   %edi
  80174f:	56                   	push   %esi
  801750:	53                   	push   %ebx
  801751:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801760:	8b 7d 18             	mov    0x18(%ebp),%edi
  801763:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801766:	cd 30                	int    $0x30
  801768:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	5b                   	pop    %ebx
  801772:	5e                   	pop    %esi
  801773:	5f                   	pop    %edi
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 04             	sub    $0x4,%esp
  80177c:	8b 45 10             	mov    0x10(%ebp),%eax
  80177f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801782:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	52                   	push   %edx
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	50                   	push   %eax
  801792:	6a 00                	push   $0x0
  801794:	e8 b2 ff ff ff       	call   80174b <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	90                   	nop
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sys_cgetc>:

int
sys_cgetc(void)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 01                	push   $0x1
  8017ae:	e8 98 ff ff ff       	call   80174b <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	52                   	push   %edx
  8017c8:	50                   	push   %eax
  8017c9:	6a 05                	push   $0x5
  8017cb:	e8 7b ff ff ff       	call   80174b <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	56                   	push   %esi
  8017d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017da:	8b 75 18             	mov    0x18(%ebp),%esi
  8017dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	56                   	push   %esi
  8017ea:	53                   	push   %ebx
  8017eb:	51                   	push   %ecx
  8017ec:	52                   	push   %edx
  8017ed:	50                   	push   %eax
  8017ee:	6a 06                	push   $0x6
  8017f0:	e8 56 ff ff ff       	call   80174b <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801802:	8b 55 0c             	mov    0xc(%ebp),%edx
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	52                   	push   %edx
  80180f:	50                   	push   %eax
  801810:	6a 07                	push   $0x7
  801812:	e8 34 ff ff ff       	call   80174b <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	ff 75 08             	pushl  0x8(%ebp)
  80182b:	6a 08                	push   $0x8
  80182d:	e8 19 ff ff ff       	call   80174b <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 09                	push   $0x9
  801846:	e8 00 ff ff ff       	call   80174b <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 0a                	push   $0xa
  80185f:	e8 e7 fe ff ff       	call   80174b <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 0b                	push   $0xb
  801878:	e8 ce fe ff ff       	call   80174b <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	6a 0f                	push   $0xf
  801893:	e8 b3 fe ff ff       	call   80174b <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
	return;
  80189b:	90                   	nop
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	ff 75 08             	pushl  0x8(%ebp)
  8018ad:	6a 10                	push   $0x10
  8018af:	e8 97 fe ff ff       	call   80174b <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b7:	90                   	nop
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	ff 75 10             	pushl  0x10(%ebp)
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	6a 11                	push   $0x11
  8018cc:	e8 7a fe ff ff       	call   80174b <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d4:	90                   	nop
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 0c                	push   $0xc
  8018e6:	e8 60 fe ff ff       	call   80174b <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	6a 0d                	push   $0xd
  801900:	e8 46 fe ff ff       	call   80174b <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 0e                	push   $0xe
  801919:	e8 2d fe ff ff       	call   80174b <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 13                	push   $0x13
  801933:	e8 13 fe ff ff       	call   80174b <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 14                	push   $0x14
  80194d:	e8 f9 fd ff ff       	call   80174b <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_cputc>:


void
sys_cputc(const char c)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801964:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	50                   	push   %eax
  801971:	6a 15                	push   $0x15
  801973:	e8 d3 fd ff ff       	call   80174b <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	90                   	nop
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 16                	push   $0x16
  80198d:	e8 b9 fd ff ff       	call   80174b <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	6a 17                	push   $0x17
  8019aa:	e8 9c fd ff ff       	call   80174b <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	6a 1a                	push   $0x1a
  8019c7:	e8 7f fd ff ff       	call   80174b <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	52                   	push   %edx
  8019e1:	50                   	push   %eax
  8019e2:	6a 18                	push   $0x18
  8019e4:	e8 62 fd ff ff       	call   80174b <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	52                   	push   %edx
  8019ff:	50                   	push   %eax
  801a00:	6a 19                	push   $0x19
  801a02:	e8 44 fd ff ff       	call   80174b <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	8b 45 10             	mov    0x10(%ebp),%eax
  801a16:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a19:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a1c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	51                   	push   %ecx
  801a26:	52                   	push   %edx
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	50                   	push   %eax
  801a2b:	6a 1b                	push   $0x1b
  801a2d:	e8 19 fd ff ff       	call   80174b <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	6a 1c                	push   $0x1c
  801a4a:	e8 fc fc ff ff       	call   80174b <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a57:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	51                   	push   %ecx
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 1d                	push   $0x1d
  801a69:	e8 dd fc ff ff       	call   80174b <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	52                   	push   %edx
  801a83:	50                   	push   %eax
  801a84:	6a 1e                	push   $0x1e
  801a86:	e8 c0 fc ff ff       	call   80174b <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 1f                	push   $0x1f
  801a9f:	e8 a7 fc ff ff       	call   80174b <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	ff 75 14             	pushl  0x14(%ebp)
  801ab4:	ff 75 10             	pushl  0x10(%ebp)
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	50                   	push   %eax
  801abb:	6a 20                	push   $0x20
  801abd:	e8 89 fc ff ff       	call   80174b <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	50                   	push   %eax
  801ad6:	6a 21                	push   $0x21
  801ad8:	e8 6e fc ff ff       	call   80174b <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	50                   	push   %eax
  801af2:	6a 22                	push   $0x22
  801af4:	e8 52 fc ff ff       	call   80174b <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 02                	push   $0x2
  801b0d:	e8 39 fc ff ff       	call   80174b <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 03                	push   $0x3
  801b26:	e8 20 fc ff ff       	call   80174b <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 04                	push   $0x4
  801b3f:	e8 07 fc ff ff       	call   80174b <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_exit_env>:


void sys_exit_env(void)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 23                	push   $0x23
  801b58:	e8 ee fb ff ff       	call   80174b <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	90                   	nop
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b69:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b6c:	8d 50 04             	lea    0x4(%eax),%edx
  801b6f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	52                   	push   %edx
  801b79:	50                   	push   %eax
  801b7a:	6a 24                	push   $0x24
  801b7c:	e8 ca fb ff ff       	call   80174b <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
	return result;
  801b84:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b8d:	89 01                	mov    %eax,(%ecx)
  801b8f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	c9                   	leave  
  801b96:	c2 04 00             	ret    $0x4

00801b99 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	ff 75 10             	pushl  0x10(%ebp)
  801ba3:	ff 75 0c             	pushl  0xc(%ebp)
  801ba6:	ff 75 08             	pushl  0x8(%ebp)
  801ba9:	6a 12                	push   $0x12
  801bab:	e8 9b fb ff ff       	call   80174b <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb3:	90                   	nop
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 25                	push   $0x25
  801bc5:	e8 81 fb ff ff       	call   80174b <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bdb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	50                   	push   %eax
  801be8:	6a 26                	push   $0x26
  801bea:	e8 5c fb ff ff       	call   80174b <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf2:	90                   	nop
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <rsttst>:
void rsttst()
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 28                	push   $0x28
  801c04:	e8 42 fb ff ff       	call   80174b <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	83 ec 04             	sub    $0x4,%esp
  801c15:	8b 45 14             	mov    0x14(%ebp),%eax
  801c18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c1b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	ff 75 10             	pushl  0x10(%ebp)
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	ff 75 08             	pushl  0x8(%ebp)
  801c2d:	6a 27                	push   $0x27
  801c2f:	e8 17 fb ff ff       	call   80174b <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
	return ;
  801c37:	90                   	nop
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <chktst>:
void chktst(uint32 n)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	ff 75 08             	pushl  0x8(%ebp)
  801c48:	6a 29                	push   $0x29
  801c4a:	e8 fc fa ff ff       	call   80174b <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c52:	90                   	nop
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <inctst>:

void inctst()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 2a                	push   $0x2a
  801c64:	e8 e2 fa ff ff       	call   80174b <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <gettst>:
uint32 gettst()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 2b                	push   $0x2b
  801c7e:	e8 c8 fa ff ff       	call   80174b <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
  801c8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 2c                	push   $0x2c
  801c9a:	e8 ac fa ff ff       	call   80174b <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
  801ca2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ca5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ca9:	75 07                	jne    801cb2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cab:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb0:	eb 05                	jmp    801cb7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 2c                	push   $0x2c
  801ccb:	e8 7b fa ff ff       	call   80174b <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
  801cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cd6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cda:	75 07                	jne    801ce3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cdc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce1:	eb 05                	jmp    801ce8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 2c                	push   $0x2c
  801cfc:	e8 4a fa ff ff       	call   80174b <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
  801d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d07:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d0b:	75 07                	jne    801d14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d12:	eb 05                	jmp    801d19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 2c                	push   $0x2c
  801d2d:	e8 19 fa ff ff       	call   80174b <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
  801d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d3c:	75 07                	jne    801d45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	eb 05                	jmp    801d4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	6a 2d                	push   $0x2d
  801d5c:	e8 ea f9 ff ff       	call   80174b <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return ;
  801d64:	90                   	nop
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	6a 00                	push   $0x0
  801d79:	53                   	push   %ebx
  801d7a:	51                   	push   %ecx
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	6a 2e                	push   $0x2e
  801d7f:	e8 c7 f9 ff ff       	call   80174b <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	52                   	push   %edx
  801d9c:	50                   	push   %eax
  801d9d:	6a 2f                	push   $0x2f
  801d9f:	e8 a7 f9 ff ff       	call   80174b <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801daf:	83 ec 0c             	sub    $0xc,%esp
  801db2:	68 48 3e 80 00       	push   $0x803e48
  801db7:	e8 1e e8 ff ff       	call   8005da <cprintf>
  801dbc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dc6:	83 ec 0c             	sub    $0xc,%esp
  801dc9:	68 74 3e 80 00       	push   $0x803e74
  801dce:	e8 07 e8 ff ff       	call   8005da <cprintf>
  801dd3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dd6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dda:	a1 38 41 80 00       	mov    0x804138,%eax
  801ddf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de2:	eb 56                	jmp    801e3a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801de4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801de8:	74 1c                	je     801e06 <print_mem_block_lists+0x5d>
  801dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ded:	8b 50 08             	mov    0x8(%eax),%edx
  801df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df3:	8b 48 08             	mov    0x8(%eax),%ecx
  801df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfc:	01 c8                	add    %ecx,%eax
  801dfe:	39 c2                	cmp    %eax,%edx
  801e00:	73 04                	jae    801e06 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e02:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	8b 50 08             	mov    0x8(%eax),%edx
  801e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e12:	01 c2                	add    %eax,%edx
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	8b 40 08             	mov    0x8(%eax),%eax
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	52                   	push   %edx
  801e1e:	50                   	push   %eax
  801e1f:	68 89 3e 80 00       	push   $0x803e89
  801e24:	e8 b1 e7 ff ff       	call   8005da <cprintf>
  801e29:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e32:	a1 40 41 80 00       	mov    0x804140,%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3e:	74 07                	je     801e47 <print_mem_block_lists+0x9e>
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 00                	mov    (%eax),%eax
  801e45:	eb 05                	jmp    801e4c <print_mem_block_lists+0xa3>
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4c:	a3 40 41 80 00       	mov    %eax,0x804140
  801e51:	a1 40 41 80 00       	mov    0x804140,%eax
  801e56:	85 c0                	test   %eax,%eax
  801e58:	75 8a                	jne    801de4 <print_mem_block_lists+0x3b>
  801e5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5e:	75 84                	jne    801de4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e60:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e64:	75 10                	jne    801e76 <print_mem_block_lists+0xcd>
  801e66:	83 ec 0c             	sub    $0xc,%esp
  801e69:	68 98 3e 80 00       	push   $0x803e98
  801e6e:	e8 67 e7 ff ff       	call   8005da <cprintf>
  801e73:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e7d:	83 ec 0c             	sub    $0xc,%esp
  801e80:	68 bc 3e 80 00       	push   $0x803ebc
  801e85:	e8 50 e7 ff ff       	call   8005da <cprintf>
  801e8a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e8d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e91:	a1 40 40 80 00       	mov    0x804040,%eax
  801e96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e99:	eb 56                	jmp    801ef1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e9f:	74 1c                	je     801ebd <print_mem_block_lists+0x114>
  801ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea4:	8b 50 08             	mov    0x8(%eax),%edx
  801ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaa:	8b 48 08             	mov    0x8(%eax),%ecx
  801ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	01 c8                	add    %ecx,%eax
  801eb5:	39 c2                	cmp    %eax,%edx
  801eb7:	73 04                	jae    801ebd <print_mem_block_lists+0x114>
			sorted = 0 ;
  801eb9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 50 08             	mov    0x8(%eax),%edx
  801ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec9:	01 c2                	add    %eax,%edx
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	8b 40 08             	mov    0x8(%eax),%eax
  801ed1:	83 ec 04             	sub    $0x4,%esp
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	68 89 3e 80 00       	push   $0x803e89
  801edb:	e8 fa e6 ff ff       	call   8005da <cprintf>
  801ee0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee9:	a1 48 40 80 00       	mov    0x804048,%eax
  801eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef5:	74 07                	je     801efe <print_mem_block_lists+0x155>
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 00                	mov    (%eax),%eax
  801efc:	eb 05                	jmp    801f03 <print_mem_block_lists+0x15a>
  801efe:	b8 00 00 00 00       	mov    $0x0,%eax
  801f03:	a3 48 40 80 00       	mov    %eax,0x804048
  801f08:	a1 48 40 80 00       	mov    0x804048,%eax
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	75 8a                	jne    801e9b <print_mem_block_lists+0xf2>
  801f11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f15:	75 84                	jne    801e9b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f17:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f1b:	75 10                	jne    801f2d <print_mem_block_lists+0x184>
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	68 d4 3e 80 00       	push   $0x803ed4
  801f25:	e8 b0 e6 ff ff       	call   8005da <cprintf>
  801f2a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f2d:	83 ec 0c             	sub    $0xc,%esp
  801f30:	68 48 3e 80 00       	push   $0x803e48
  801f35:	e8 a0 e6 ff ff       	call   8005da <cprintf>
  801f3a:	83 c4 10             	add    $0x10,%esp

}
  801f3d:	90                   	nop
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f46:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f4d:	00 00 00 
  801f50:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f57:	00 00 00 
  801f5a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f61:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f6b:	e9 9e 00 00 00       	jmp    80200e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f70:	a1 50 40 80 00       	mov    0x804050,%eax
  801f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f78:	c1 e2 04             	shl    $0x4,%edx
  801f7b:	01 d0                	add    %edx,%eax
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	75 14                	jne    801f95 <initialize_MemBlocksList+0x55>
  801f81:	83 ec 04             	sub    $0x4,%esp
  801f84:	68 fc 3e 80 00       	push   $0x803efc
  801f89:	6a 46                	push   $0x46
  801f8b:	68 1f 3f 80 00       	push   $0x803f1f
  801f90:	e8 91 e3 ff ff       	call   800326 <_panic>
  801f95:	a1 50 40 80 00       	mov    0x804050,%eax
  801f9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f9d:	c1 e2 04             	shl    $0x4,%edx
  801fa0:	01 d0                	add    %edx,%eax
  801fa2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801fa8:	89 10                	mov    %edx,(%eax)
  801faa:	8b 00                	mov    (%eax),%eax
  801fac:	85 c0                	test   %eax,%eax
  801fae:	74 18                	je     801fc8 <initialize_MemBlocksList+0x88>
  801fb0:	a1 48 41 80 00       	mov    0x804148,%eax
  801fb5:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801fbb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fbe:	c1 e1 04             	shl    $0x4,%ecx
  801fc1:	01 ca                	add    %ecx,%edx
  801fc3:	89 50 04             	mov    %edx,0x4(%eax)
  801fc6:	eb 12                	jmp    801fda <initialize_MemBlocksList+0x9a>
  801fc8:	a1 50 40 80 00       	mov    0x804050,%eax
  801fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd0:	c1 e2 04             	shl    $0x4,%edx
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fda:	a1 50 40 80 00       	mov    0x804050,%eax
  801fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe2:	c1 e2 04             	shl    $0x4,%edx
  801fe5:	01 d0                	add    %edx,%eax
  801fe7:	a3 48 41 80 00       	mov    %eax,0x804148
  801fec:	a1 50 40 80 00       	mov    0x804050,%eax
  801ff1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff4:	c1 e2 04             	shl    $0x4,%edx
  801ff7:	01 d0                	add    %edx,%eax
  801ff9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802000:	a1 54 41 80 00       	mov    0x804154,%eax
  802005:	40                   	inc    %eax
  802006:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80200b:	ff 45 f4             	incl   -0xc(%ebp)
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	3b 45 08             	cmp    0x8(%ebp),%eax
  802014:	0f 82 56 ff ff ff    	jb     801f70 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80201a:	90                   	nop
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	8b 00                	mov    (%eax),%eax
  802028:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80202b:	eb 19                	jmp    802046 <find_block+0x29>
	{
		if(va==point->sva)
  80202d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802030:	8b 40 08             	mov    0x8(%eax),%eax
  802033:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802036:	75 05                	jne    80203d <find_block+0x20>
		   return point;
  802038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203b:	eb 36                	jmp    802073 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	8b 40 08             	mov    0x8(%eax),%eax
  802043:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802046:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80204a:	74 07                	je     802053 <find_block+0x36>
  80204c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	eb 05                	jmp    802058 <find_block+0x3b>
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	8b 55 08             	mov    0x8(%ebp),%edx
  80205b:	89 42 08             	mov    %eax,0x8(%edx)
  80205e:	8b 45 08             	mov    0x8(%ebp),%eax
  802061:	8b 40 08             	mov    0x8(%eax),%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	75 c5                	jne    80202d <find_block+0x10>
  802068:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80206c:	75 bf                	jne    80202d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80207b:	a1 40 40 80 00       	mov    0x804040,%eax
  802080:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802083:	a1 44 40 80 00       	mov    0x804044,%eax
  802088:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80208b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802091:	74 24                	je     8020b7 <insert_sorted_allocList+0x42>
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	8b 50 08             	mov    0x8(%eax),%edx
  802099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209c:	8b 40 08             	mov    0x8(%eax),%eax
  80209f:	39 c2                	cmp    %eax,%edx
  8020a1:	76 14                	jbe    8020b7 <insert_sorted_allocList+0x42>
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	8b 50 08             	mov    0x8(%eax),%edx
  8020a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ac:	8b 40 08             	mov    0x8(%eax),%eax
  8020af:	39 c2                	cmp    %eax,%edx
  8020b1:	0f 82 60 01 00 00    	jb     802217 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020bb:	75 65                	jne    802122 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c1:	75 14                	jne    8020d7 <insert_sorted_allocList+0x62>
  8020c3:	83 ec 04             	sub    $0x4,%esp
  8020c6:	68 fc 3e 80 00       	push   $0x803efc
  8020cb:	6a 6b                	push   $0x6b
  8020cd:	68 1f 3f 80 00       	push   $0x803f1f
  8020d2:	e8 4f e2 ff ff       	call   800326 <_panic>
  8020d7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	89 10                	mov    %edx,(%eax)
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	74 0d                	je     8020f8 <insert_sorted_allocList+0x83>
  8020eb:	a1 40 40 80 00       	mov    0x804040,%eax
  8020f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f3:	89 50 04             	mov    %edx,0x4(%eax)
  8020f6:	eb 08                	jmp    802100 <insert_sorted_allocList+0x8b>
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	a3 44 40 80 00       	mov    %eax,0x804044
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	a3 40 40 80 00       	mov    %eax,0x804040
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802112:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802117:	40                   	inc    %eax
  802118:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80211d:	e9 dc 01 00 00       	jmp    8022fe <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	8b 50 08             	mov    0x8(%eax),%edx
  802128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212b:	8b 40 08             	mov    0x8(%eax),%eax
  80212e:	39 c2                	cmp    %eax,%edx
  802130:	77 6c                	ja     80219e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802132:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802136:	74 06                	je     80213e <insert_sorted_allocList+0xc9>
  802138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80213c:	75 14                	jne    802152 <insert_sorted_allocList+0xdd>
  80213e:	83 ec 04             	sub    $0x4,%esp
  802141:	68 38 3f 80 00       	push   $0x803f38
  802146:	6a 6f                	push   $0x6f
  802148:	68 1f 3f 80 00       	push   $0x803f1f
  80214d:	e8 d4 e1 ff ff       	call   800326 <_panic>
  802152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802155:	8b 50 04             	mov    0x4(%eax),%edx
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	89 50 04             	mov    %edx,0x4(%eax)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802164:	89 10                	mov    %edx,(%eax)
  802166:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802169:	8b 40 04             	mov    0x4(%eax),%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	74 0d                	je     80217d <insert_sorted_allocList+0x108>
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 40 04             	mov    0x4(%eax),%eax
  802176:	8b 55 08             	mov    0x8(%ebp),%edx
  802179:	89 10                	mov    %edx,(%eax)
  80217b:	eb 08                	jmp    802185 <insert_sorted_allocList+0x110>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	a3 40 40 80 00       	mov    %eax,0x804040
  802185:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802188:	8b 55 08             	mov    0x8(%ebp),%edx
  80218b:	89 50 04             	mov    %edx,0x4(%eax)
  80218e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802193:	40                   	inc    %eax
  802194:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802199:	e9 60 01 00 00       	jmp    8022fe <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 50 08             	mov    0x8(%eax),%edx
  8021a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021a7:	8b 40 08             	mov    0x8(%eax),%eax
  8021aa:	39 c2                	cmp    %eax,%edx
  8021ac:	0f 82 4c 01 00 00    	jb     8022fe <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b6:	75 14                	jne    8021cc <insert_sorted_allocList+0x157>
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	68 70 3f 80 00       	push   $0x803f70
  8021c0:	6a 73                	push   $0x73
  8021c2:	68 1f 3f 80 00       	push   $0x803f1f
  8021c7:	e8 5a e1 ff ff       	call   800326 <_panic>
  8021cc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	89 50 04             	mov    %edx,0x4(%eax)
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	8b 40 04             	mov    0x4(%eax),%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	74 0c                	je     8021ee <insert_sorted_allocList+0x179>
  8021e2:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ea:	89 10                	mov    %edx,(%eax)
  8021ec:	eb 08                	jmp    8021f6 <insert_sorted_allocList+0x181>
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 44 40 80 00       	mov    %eax,0x804044
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802207:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80220c:	40                   	inc    %eax
  80220d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802212:	e9 e7 00 00 00       	jmp    8022fe <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80221d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802224:	a1 40 40 80 00       	mov    0x804040,%eax
  802229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222c:	e9 9d 00 00 00       	jmp    8022ce <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	8b 00                	mov    (%eax),%eax
  802236:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 50 08             	mov    0x8(%eax),%edx
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 40 08             	mov    0x8(%eax),%eax
  802245:	39 c2                	cmp    %eax,%edx
  802247:	76 7d                	jbe    8022c6 <insert_sorted_allocList+0x251>
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	8b 50 08             	mov    0x8(%eax),%edx
  80224f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802252:	8b 40 08             	mov    0x8(%eax),%eax
  802255:	39 c2                	cmp    %eax,%edx
  802257:	73 6d                	jae    8022c6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225d:	74 06                	je     802265 <insert_sorted_allocList+0x1f0>
  80225f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802263:	75 14                	jne    802279 <insert_sorted_allocList+0x204>
  802265:	83 ec 04             	sub    $0x4,%esp
  802268:	68 94 3f 80 00       	push   $0x803f94
  80226d:	6a 7f                	push   $0x7f
  80226f:	68 1f 3f 80 00       	push   $0x803f1f
  802274:	e8 ad e0 ff ff       	call   800326 <_panic>
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 10                	mov    (%eax),%edx
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	89 10                	mov    %edx,(%eax)
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	74 0b                	je     802297 <insert_sorted_allocList+0x222>
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 00                	mov    (%eax),%eax
  802291:	8b 55 08             	mov    0x8(%ebp),%edx
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 55 08             	mov    0x8(%ebp),%edx
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a5:	89 50 04             	mov    %edx,0x4(%eax)
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	75 08                	jne    8022b9 <insert_sorted_allocList+0x244>
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022be:	40                   	inc    %eax
  8022bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022c4:	eb 39                	jmp    8022ff <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022c6:	a1 48 40 80 00       	mov    0x804048,%eax
  8022cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d2:	74 07                	je     8022db <insert_sorted_allocList+0x266>
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	eb 05                	jmp    8022e0 <insert_sorted_allocList+0x26b>
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e0:	a3 48 40 80 00       	mov    %eax,0x804048
  8022e5:	a1 48 40 80 00       	mov    0x804048,%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	0f 85 3f ff ff ff    	jne    802231 <insert_sorted_allocList+0x1bc>
  8022f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f6:	0f 85 35 ff ff ff    	jne    802231 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022fc:	eb 01                	jmp    8022ff <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022fe:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022ff:	90                   	nop
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802308:	a1 38 41 80 00       	mov    0x804138,%eax
  80230d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802310:	e9 85 01 00 00       	jmp    80249a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 40 0c             	mov    0xc(%eax),%eax
  80231b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231e:	0f 82 6e 01 00 00    	jb     802492 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 40 0c             	mov    0xc(%eax),%eax
  80232a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232d:	0f 85 8a 00 00 00    	jne    8023bd <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802337:	75 17                	jne    802350 <alloc_block_FF+0x4e>
  802339:	83 ec 04             	sub    $0x4,%esp
  80233c:	68 c8 3f 80 00       	push   $0x803fc8
  802341:	68 93 00 00 00       	push   $0x93
  802346:	68 1f 3f 80 00       	push   $0x803f1f
  80234b:	e8 d6 df ff ff       	call   800326 <_panic>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 10                	je     802369 <alloc_block_FF+0x67>
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802361:	8b 52 04             	mov    0x4(%edx),%edx
  802364:	89 50 04             	mov    %edx,0x4(%eax)
  802367:	eb 0b                	jmp    802374 <alloc_block_FF+0x72>
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 40 04             	mov    0x4(%eax),%eax
  80237a:	85 c0                	test   %eax,%eax
  80237c:	74 0f                	je     80238d <alloc_block_FF+0x8b>
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 04             	mov    0x4(%eax),%eax
  802384:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802387:	8b 12                	mov    (%edx),%edx
  802389:	89 10                	mov    %edx,(%eax)
  80238b:	eb 0a                	jmp    802397 <alloc_block_FF+0x95>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	a3 38 41 80 00       	mov    %eax,0x804138
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023aa:	a1 44 41 80 00       	mov    0x804144,%eax
  8023af:	48                   	dec    %eax
  8023b0:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	e9 10 01 00 00       	jmp    8024cd <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c6:	0f 86 c6 00 00 00    	jbe    802492 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023cc:	a1 48 41 80 00       	mov    0x804148,%eax
  8023d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 50 08             	mov    0x8(%eax),%edx
  8023da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023dd:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ed:	75 17                	jne    802406 <alloc_block_FF+0x104>
  8023ef:	83 ec 04             	sub    $0x4,%esp
  8023f2:	68 c8 3f 80 00       	push   $0x803fc8
  8023f7:	68 9b 00 00 00       	push   $0x9b
  8023fc:	68 1f 3f 80 00       	push   $0x803f1f
  802401:	e8 20 df ff ff       	call   800326 <_panic>
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	85 c0                	test   %eax,%eax
  80240d:	74 10                	je     80241f <alloc_block_FF+0x11d>
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802417:	8b 52 04             	mov    0x4(%edx),%edx
  80241a:	89 50 04             	mov    %edx,0x4(%eax)
  80241d:	eb 0b                	jmp    80242a <alloc_block_FF+0x128>
  80241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 0f                	je     802443 <alloc_block_FF+0x141>
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	8b 40 04             	mov    0x4(%eax),%eax
  80243a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243d:	8b 12                	mov    (%edx),%edx
  80243f:	89 10                	mov    %edx,(%eax)
  802441:	eb 0a                	jmp    80244d <alloc_block_FF+0x14b>
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	a3 48 41 80 00       	mov    %eax,0x804148
  80244d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802450:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802459:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802460:	a1 54 41 80 00       	mov    0x804154,%eax
  802465:	48                   	dec    %eax
  802466:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 50 08             	mov    0x8(%eax),%edx
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	01 c2                	add    %eax,%edx
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 40 0c             	mov    0xc(%eax),%eax
  802482:	2b 45 08             	sub    0x8(%ebp),%eax
  802485:	89 c2                	mov    %eax,%edx
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80248d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802490:	eb 3b                	jmp    8024cd <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802492:	a1 40 41 80 00       	mov    0x804140,%eax
  802497:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249e:	74 07                	je     8024a7 <alloc_block_FF+0x1a5>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	eb 05                	jmp    8024ac <alloc_block_FF+0x1aa>
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8024b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	0f 85 57 fe ff ff    	jne    802315 <alloc_block_FF+0x13>
  8024be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c2:	0f 85 4d fe ff ff    	jne    802315 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e4:	e9 df 00 00 00       	jmp    8025c8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f2:	0f 82 c8 00 00 00    	jb     8025c0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802501:	0f 85 8a 00 00 00    	jne    802591 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250b:	75 17                	jne    802524 <alloc_block_BF+0x55>
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	68 c8 3f 80 00       	push   $0x803fc8
  802515:	68 b7 00 00 00       	push   $0xb7
  80251a:	68 1f 3f 80 00       	push   $0x803f1f
  80251f:	e8 02 de ff ff       	call   800326 <_panic>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 10                	je     80253d <alloc_block_BF+0x6e>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	8b 52 04             	mov    0x4(%edx),%edx
  802538:	89 50 04             	mov    %edx,0x4(%eax)
  80253b:	eb 0b                	jmp    802548 <alloc_block_BF+0x79>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 0f                	je     802561 <alloc_block_BF+0x92>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 04             	mov    0x4(%eax),%eax
  802558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255b:	8b 12                	mov    (%edx),%edx
  80255d:	89 10                	mov    %edx,(%eax)
  80255f:	eb 0a                	jmp    80256b <alloc_block_BF+0x9c>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	a3 38 41 80 00       	mov    %eax,0x804138
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257e:	a1 44 41 80 00       	mov    0x804144,%eax
  802583:	48                   	dec    %eax
  802584:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	e9 4d 01 00 00       	jmp    8026de <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 0c             	mov    0xc(%eax),%eax
  802597:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259a:	76 24                	jbe    8025c0 <alloc_block_BF+0xf1>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025a5:	73 19                	jae    8025c0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025a7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 08             	mov    0x8(%eax),%eax
  8025bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	74 07                	je     8025d5 <alloc_block_BF+0x106>
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	eb 05                	jmp    8025da <alloc_block_BF+0x10b>
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025da:	a3 40 41 80 00       	mov    %eax,0x804140
  8025df:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	0f 85 fd fe ff ff    	jne    8024e9 <alloc_block_BF+0x1a>
  8025ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f0:	0f 85 f3 fe ff ff    	jne    8024e9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025fa:	0f 84 d9 00 00 00    	je     8026d9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802600:	a1 48 41 80 00       	mov    0x804148,%eax
  802605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802614:	8b 55 08             	mov    0x8(%ebp),%edx
  802617:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80261a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80261e:	75 17                	jne    802637 <alloc_block_BF+0x168>
  802620:	83 ec 04             	sub    $0x4,%esp
  802623:	68 c8 3f 80 00       	push   $0x803fc8
  802628:	68 c7 00 00 00       	push   $0xc7
  80262d:	68 1f 3f 80 00       	push   $0x803f1f
  802632:	e8 ef dc ff ff       	call   800326 <_panic>
  802637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	74 10                	je     802650 <alloc_block_BF+0x181>
  802640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802648:	8b 52 04             	mov    0x4(%edx),%edx
  80264b:	89 50 04             	mov    %edx,0x4(%eax)
  80264e:	eb 0b                	jmp    80265b <alloc_block_BF+0x18c>
  802650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802653:	8b 40 04             	mov    0x4(%eax),%eax
  802656:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80265b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	74 0f                	je     802674 <alloc_block_BF+0x1a5>
  802665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802668:	8b 40 04             	mov    0x4(%eax),%eax
  80266b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80266e:	8b 12                	mov    (%edx),%edx
  802670:	89 10                	mov    %edx,(%eax)
  802672:	eb 0a                	jmp    80267e <alloc_block_BF+0x1af>
  802674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802677:	8b 00                	mov    (%eax),%eax
  802679:	a3 48 41 80 00       	mov    %eax,0x804148
  80267e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802691:	a1 54 41 80 00       	mov    0x804154,%eax
  802696:	48                   	dec    %eax
  802697:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80269c:	83 ec 08             	sub    $0x8,%esp
  80269f:	ff 75 ec             	pushl  -0x14(%ebp)
  8026a2:	68 38 41 80 00       	push   $0x804138
  8026a7:	e8 71 f9 ff ff       	call   80201d <find_block>
  8026ac:	83 c4 10             	add    $0x10,%esp
  8026af:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b5:	8b 50 08             	mov    0x8(%eax),%edx
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	01 c2                	add    %eax,%edx
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026cc:	89 c2                	mov    %eax,%edx
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d7:	eb 05                	jmp    8026de <alloc_block_BF+0x20f>
	}
	return NULL;
  8026d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026de:	c9                   	leave  
  8026df:	c3                   	ret    

008026e0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026e6:	a1 28 40 80 00       	mov    0x804028,%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	0f 85 de 01 00 00    	jne    8028d1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026f3:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fb:	e9 9e 01 00 00       	jmp    80289e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	3b 45 08             	cmp    0x8(%ebp),%eax
  802709:	0f 82 87 01 00 00    	jb     802896 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 0c             	mov    0xc(%eax),%eax
  802715:	3b 45 08             	cmp    0x8(%ebp),%eax
  802718:	0f 85 95 00 00 00    	jne    8027b3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80271e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802722:	75 17                	jne    80273b <alloc_block_NF+0x5b>
  802724:	83 ec 04             	sub    $0x4,%esp
  802727:	68 c8 3f 80 00       	push   $0x803fc8
  80272c:	68 e0 00 00 00       	push   $0xe0
  802731:	68 1f 3f 80 00       	push   $0x803f1f
  802736:	e8 eb db ff ff       	call   800326 <_panic>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 10                	je     802754 <alloc_block_NF+0x74>
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274c:	8b 52 04             	mov    0x4(%edx),%edx
  80274f:	89 50 04             	mov    %edx,0x4(%eax)
  802752:	eb 0b                	jmp    80275f <alloc_block_NF+0x7f>
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 40 04             	mov    0x4(%eax),%eax
  80275a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 0f                	je     802778 <alloc_block_NF+0x98>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 04             	mov    0x4(%eax),%eax
  80276f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802772:	8b 12                	mov    (%edx),%edx
  802774:	89 10                	mov    %edx,(%eax)
  802776:	eb 0a                	jmp    802782 <alloc_block_NF+0xa2>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	a3 38 41 80 00       	mov    %eax,0x804138
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802795:	a1 44 41 80 00       	mov    0x804144,%eax
  80279a:	48                   	dec    %eax
  80279b:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 40 08             	mov    0x8(%eax),%eax
  8027a6:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	e9 f8 04 00 00       	jmp    802cab <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bc:	0f 86 d4 00 00 00    	jbe    802896 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027c2:	a1 48 41 80 00       	mov    0x804148,%eax
  8027c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 50 08             	mov    0x8(%eax),%edx
  8027d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8027dc:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e3:	75 17                	jne    8027fc <alloc_block_NF+0x11c>
  8027e5:	83 ec 04             	sub    $0x4,%esp
  8027e8:	68 c8 3f 80 00       	push   $0x803fc8
  8027ed:	68 e9 00 00 00       	push   $0xe9
  8027f2:	68 1f 3f 80 00       	push   $0x803f1f
  8027f7:	e8 2a db ff ff       	call   800326 <_panic>
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	85 c0                	test   %eax,%eax
  802803:	74 10                	je     802815 <alloc_block_NF+0x135>
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280d:	8b 52 04             	mov    0x4(%edx),%edx
  802810:	89 50 04             	mov    %edx,0x4(%eax)
  802813:	eb 0b                	jmp    802820 <alloc_block_NF+0x140>
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	74 0f                	je     802839 <alloc_block_NF+0x159>
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	8b 40 04             	mov    0x4(%eax),%eax
  802830:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802833:	8b 12                	mov    (%edx),%edx
  802835:	89 10                	mov    %edx,(%eax)
  802837:	eb 0a                	jmp    802843 <alloc_block_NF+0x163>
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	a3 48 41 80 00       	mov    %eax,0x804148
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802856:	a1 54 41 80 00       	mov    0x804154,%eax
  80285b:	48                   	dec    %eax
  80285c:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802864:	8b 40 08             	mov    0x8(%eax),%eax
  802867:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 50 08             	mov    0x8(%eax),%edx
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	01 c2                	add    %eax,%edx
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 0c             	mov    0xc(%eax),%eax
  802883:	2b 45 08             	sub    0x8(%ebp),%eax
  802886:	89 c2                	mov    %eax,%edx
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	e9 15 04 00 00       	jmp    802cab <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802896:	a1 40 41 80 00       	mov    0x804140,%eax
  80289b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a2:	74 07                	je     8028ab <alloc_block_NF+0x1cb>
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 00                	mov    (%eax),%eax
  8028a9:	eb 05                	jmp    8028b0 <alloc_block_NF+0x1d0>
  8028ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8028b0:	a3 40 41 80 00       	mov    %eax,0x804140
  8028b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ba:	85 c0                	test   %eax,%eax
  8028bc:	0f 85 3e fe ff ff    	jne    802700 <alloc_block_NF+0x20>
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	0f 85 34 fe ff ff    	jne    802700 <alloc_block_NF+0x20>
  8028cc:	e9 d5 03 00 00       	jmp    802ca6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d9:	e9 b1 01 00 00       	jmp    802a8f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 50 08             	mov    0x8(%eax),%edx
  8028e4:	a1 28 40 80 00       	mov    0x804028,%eax
  8028e9:	39 c2                	cmp    %eax,%edx
  8028eb:	0f 82 96 01 00 00    	jb     802a87 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fa:	0f 82 87 01 00 00    	jb     802a87 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 0c             	mov    0xc(%eax),%eax
  802906:	3b 45 08             	cmp    0x8(%ebp),%eax
  802909:	0f 85 95 00 00 00    	jne    8029a4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80290f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_NF+0x24c>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 c8 3f 80 00       	push   $0x803fc8
  80291d:	68 fc 00 00 00       	push   $0xfc
  802922:	68 1f 3f 80 00       	push   $0x803f1f
  802927:	e8 fa d9 ff ff       	call   800326 <_panic>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 10                	je     802945 <alloc_block_NF+0x265>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293d:	8b 52 04             	mov    0x4(%edx),%edx
  802940:	89 50 04             	mov    %edx,0x4(%eax)
  802943:	eb 0b                	jmp    802950 <alloc_block_NF+0x270>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0f                	je     802969 <alloc_block_NF+0x289>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802963:	8b 12                	mov    (%edx),%edx
  802965:	89 10                	mov    %edx,(%eax)
  802967:	eb 0a                	jmp    802973 <alloc_block_NF+0x293>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	a3 38 41 80 00       	mov    %eax,0x804138
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802986:	a1 44 41 80 00       	mov    0x804144,%eax
  80298b:	48                   	dec    %eax
  80298c:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	e9 07 03 00 00       	jmp    802cab <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ad:	0f 86 d4 00 00 00    	jbe    802a87 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8029b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 50 08             	mov    0x8(%eax),%edx
  8029c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029d4:	75 17                	jne    8029ed <alloc_block_NF+0x30d>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 c8 3f 80 00       	push   $0x803fc8
  8029de:	68 04 01 00 00       	push   $0x104
  8029e3:	68 1f 3f 80 00       	push   $0x803f1f
  8029e8:	e8 39 d9 ff ff       	call   800326 <_panic>
  8029ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f0:	8b 00                	mov    (%eax),%eax
  8029f2:	85 c0                	test   %eax,%eax
  8029f4:	74 10                	je     802a06 <alloc_block_NF+0x326>
  8029f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029fe:	8b 52 04             	mov    0x4(%edx),%edx
  802a01:	89 50 04             	mov    %edx,0x4(%eax)
  802a04:	eb 0b                	jmp    802a11 <alloc_block_NF+0x331>
  802a06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a09:	8b 40 04             	mov    0x4(%eax),%eax
  802a0c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	85 c0                	test   %eax,%eax
  802a19:	74 0f                	je     802a2a <alloc_block_NF+0x34a>
  802a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a24:	8b 12                	mov    (%edx),%edx
  802a26:	89 10                	mov    %edx,(%eax)
  802a28:	eb 0a                	jmp    802a34 <alloc_block_NF+0x354>
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a47:	a1 54 41 80 00       	mov    0x804154,%eax
  802a4c:	48                   	dec    %eax
  802a4d:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a55:	8b 40 08             	mov    0x8(%eax),%eax
  802a58:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	01 c2                	add    %eax,%edx
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 40 0c             	mov    0xc(%eax),%eax
  802a74:	2b 45 08             	sub    0x8(%ebp),%eax
  802a77:	89 c2                	mov    %eax,%edx
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a82:	e9 24 02 00 00       	jmp    802cab <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a87:	a1 40 41 80 00       	mov    0x804140,%eax
  802a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a93:	74 07                	je     802a9c <alloc_block_NF+0x3bc>
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	8b 00                	mov    (%eax),%eax
  802a9a:	eb 05                	jmp    802aa1 <alloc_block_NF+0x3c1>
  802a9c:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa1:	a3 40 41 80 00       	mov    %eax,0x804140
  802aa6:	a1 40 41 80 00       	mov    0x804140,%eax
  802aab:	85 c0                	test   %eax,%eax
  802aad:	0f 85 2b fe ff ff    	jne    8028de <alloc_block_NF+0x1fe>
  802ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab7:	0f 85 21 fe ff ff    	jne    8028de <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802abd:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac5:	e9 ae 01 00 00       	jmp    802c78 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 50 08             	mov    0x8(%eax),%edx
  802ad0:	a1 28 40 80 00       	mov    0x804028,%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	0f 83 93 01 00 00    	jae    802c70 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae6:	0f 82 84 01 00 00    	jb     802c70 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af5:	0f 85 95 00 00 00    	jne    802b90 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	75 17                	jne    802b18 <alloc_block_NF+0x438>
  802b01:	83 ec 04             	sub    $0x4,%esp
  802b04:	68 c8 3f 80 00       	push   $0x803fc8
  802b09:	68 14 01 00 00       	push   $0x114
  802b0e:	68 1f 3f 80 00       	push   $0x803f1f
  802b13:	e8 0e d8 ff ff       	call   800326 <_panic>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	85 c0                	test   %eax,%eax
  802b1f:	74 10                	je     802b31 <alloc_block_NF+0x451>
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b29:	8b 52 04             	mov    0x4(%edx),%edx
  802b2c:	89 50 04             	mov    %edx,0x4(%eax)
  802b2f:	eb 0b                	jmp    802b3c <alloc_block_NF+0x45c>
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 40 04             	mov    0x4(%eax),%eax
  802b37:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0f                	je     802b55 <alloc_block_NF+0x475>
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 04             	mov    0x4(%eax),%eax
  802b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4f:	8b 12                	mov    (%edx),%edx
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	eb 0a                	jmp    802b5f <alloc_block_NF+0x47f>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	a3 38 41 80 00       	mov    %eax,0x804138
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b72:	a1 44 41 80 00       	mov    0x804144,%eax
  802b77:	48                   	dec    %eax
  802b78:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 40 08             	mov    0x8(%eax),%eax
  802b83:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	e9 1b 01 00 00       	jmp    802cab <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b99:	0f 86 d1 00 00 00    	jbe    802c70 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b9f:	a1 48 41 80 00       	mov    0x804148,%eax
  802ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 50 08             	mov    0x8(%eax),%edx
  802bad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc0:	75 17                	jne    802bd9 <alloc_block_NF+0x4f9>
  802bc2:	83 ec 04             	sub    $0x4,%esp
  802bc5:	68 c8 3f 80 00       	push   $0x803fc8
  802bca:	68 1c 01 00 00       	push   $0x11c
  802bcf:	68 1f 3f 80 00       	push   $0x803f1f
  802bd4:	e8 4d d7 ff ff       	call   800326 <_panic>
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 00                	mov    (%eax),%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	74 10                	je     802bf2 <alloc_block_NF+0x512>
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bea:	8b 52 04             	mov    0x4(%edx),%edx
  802bed:	89 50 04             	mov    %edx,0x4(%eax)
  802bf0:	eb 0b                	jmp    802bfd <alloc_block_NF+0x51d>
  802bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 0f                	je     802c16 <alloc_block_NF+0x536>
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c10:	8b 12                	mov    (%edx),%edx
  802c12:	89 10                	mov    %edx,(%eax)
  802c14:	eb 0a                	jmp    802c20 <alloc_block_NF+0x540>
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	a3 48 41 80 00       	mov    %eax,0x804148
  802c20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c33:	a1 54 41 80 00       	mov    0x804154,%eax
  802c38:	48                   	dec    %eax
  802c39:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c41:	8b 40 08             	mov    0x8(%eax),%eax
  802c44:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 50 08             	mov    0x8(%eax),%edx
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	01 c2                	add    %eax,%edx
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c60:	2b 45 08             	sub    0x8(%ebp),%eax
  802c63:	89 c2                	mov    %eax,%edx
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	eb 3b                	jmp    802cab <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c70:	a1 40 41 80 00       	mov    0x804140,%eax
  802c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7c:	74 07                	je     802c85 <alloc_block_NF+0x5a5>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	eb 05                	jmp    802c8a <alloc_block_NF+0x5aa>
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8a:	a3 40 41 80 00       	mov    %eax,0x804140
  802c8f:	a1 40 41 80 00       	mov    0x804140,%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	0f 85 2e fe ff ff    	jne    802aca <alloc_block_NF+0x3ea>
  802c9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca0:	0f 85 24 fe ff ff    	jne    802aca <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cab:	c9                   	leave  
  802cac:	c3                   	ret    

00802cad <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cad:	55                   	push   %ebp
  802cae:	89 e5                	mov    %esp,%ebp
  802cb0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cb3:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cbb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cc0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cc3:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 14                	je     802ce0 <insert_sorted_with_merge_freeList+0x33>
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 50 08             	mov    0x8(%eax),%edx
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	8b 40 08             	mov    0x8(%eax),%eax
  802cd8:	39 c2                	cmp    %eax,%edx
  802cda:	0f 87 9b 01 00 00    	ja     802e7b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ce0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce4:	75 17                	jne    802cfd <insert_sorted_with_merge_freeList+0x50>
  802ce6:	83 ec 04             	sub    $0x4,%esp
  802ce9:	68 fc 3e 80 00       	push   $0x803efc
  802cee:	68 38 01 00 00       	push   $0x138
  802cf3:	68 1f 3f 80 00       	push   $0x803f1f
  802cf8:	e8 29 d6 ff ff       	call   800326 <_panic>
  802cfd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	89 10                	mov    %edx,(%eax)
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	74 0d                	je     802d1e <insert_sorted_with_merge_freeList+0x71>
  802d11:	a1 38 41 80 00       	mov    0x804138,%eax
  802d16:	8b 55 08             	mov    0x8(%ebp),%edx
  802d19:	89 50 04             	mov    %edx,0x4(%eax)
  802d1c:	eb 08                	jmp    802d26 <insert_sorted_with_merge_freeList+0x79>
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d38:	a1 44 41 80 00       	mov    0x804144,%eax
  802d3d:	40                   	inc    %eax
  802d3e:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d47:	0f 84 a8 06 00 00    	je     8033f5 <insert_sorted_with_merge_freeList+0x748>
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	8b 50 08             	mov    0x8(%eax),%edx
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	01 c2                	add    %eax,%edx
  802d5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5e:	8b 40 08             	mov    0x8(%eax),%eax
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	0f 85 8c 06 00 00    	jne    8033f5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d72:	8b 40 0c             	mov    0xc(%eax),%eax
  802d75:	01 c2                	add    %eax,%edx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d81:	75 17                	jne    802d9a <insert_sorted_with_merge_freeList+0xed>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 c8 3f 80 00       	push   $0x803fc8
  802d8b:	68 3c 01 00 00       	push   $0x13c
  802d90:	68 1f 3f 80 00       	push   $0x803f1f
  802d95:	e8 8c d5 ff ff       	call   800326 <_panic>
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	85 c0                	test   %eax,%eax
  802da1:	74 10                	je     802db3 <insert_sorted_with_merge_freeList+0x106>
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dab:	8b 52 04             	mov    0x4(%edx),%edx
  802dae:	89 50 04             	mov    %edx,0x4(%eax)
  802db1:	eb 0b                	jmp    802dbe <insert_sorted_with_merge_freeList+0x111>
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	74 0f                	je     802dd7 <insert_sorted_with_merge_freeList+0x12a>
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd1:	8b 12                	mov    (%edx),%edx
  802dd3:	89 10                	mov    %edx,(%eax)
  802dd5:	eb 0a                	jmp    802de1 <insert_sorted_with_merge_freeList+0x134>
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	a3 38 41 80 00       	mov    %eax,0x804138
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ded:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df4:	a1 44 41 80 00       	mov    0x804144,%eax
  802df9:	48                   	dec    %eax
  802dfa:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e17:	75 17                	jne    802e30 <insert_sorted_with_merge_freeList+0x183>
  802e19:	83 ec 04             	sub    $0x4,%esp
  802e1c:	68 fc 3e 80 00       	push   $0x803efc
  802e21:	68 3f 01 00 00       	push   $0x13f
  802e26:	68 1f 3f 80 00       	push   $0x803f1f
  802e2b:	e8 f6 d4 ff ff       	call   800326 <_panic>
  802e30:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	89 10                	mov    %edx,(%eax)
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	85 c0                	test   %eax,%eax
  802e42:	74 0d                	je     802e51 <insert_sorted_with_merge_freeList+0x1a4>
  802e44:	a1 48 41 80 00       	mov    0x804148,%eax
  802e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	eb 08                	jmp    802e59 <insert_sorted_with_merge_freeList+0x1ac>
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	a3 48 41 80 00       	mov    %eax,0x804148
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 54 41 80 00       	mov    0x804154,%eax
  802e70:	40                   	inc    %eax
  802e71:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e76:	e9 7a 05 00 00       	jmp    8033f5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 50 08             	mov    0x8(%eax),%edx
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	8b 40 08             	mov    0x8(%eax),%eax
  802e87:	39 c2                	cmp    %eax,%edx
  802e89:	0f 82 14 01 00 00    	jb     802fa3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e92:	8b 50 08             	mov    0x8(%eax),%edx
  802e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e98:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9b:	01 c2                	add    %eax,%edx
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 40 08             	mov    0x8(%eax),%eax
  802ea3:	39 c2                	cmp    %eax,%edx
  802ea5:	0f 85 90 00 00 00    	jne    802f3b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb7:	01 c2                	add    %eax,%edx
  802eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebc:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ed3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed7:	75 17                	jne    802ef0 <insert_sorted_with_merge_freeList+0x243>
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 fc 3e 80 00       	push   $0x803efc
  802ee1:	68 49 01 00 00       	push   $0x149
  802ee6:	68 1f 3f 80 00       	push   $0x803f1f
  802eeb:	e8 36 d4 ff ff       	call   800326 <_panic>
  802ef0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 0d                	je     802f11 <insert_sorted_with_merge_freeList+0x264>
  802f04:	a1 48 41 80 00       	mov    0x804148,%eax
  802f09:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0c:	89 50 04             	mov    %edx,0x4(%eax)
  802f0f:	eb 08                	jmp    802f19 <insert_sorted_with_merge_freeList+0x26c>
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	a3 48 41 80 00       	mov    %eax,0x804148
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f30:	40                   	inc    %eax
  802f31:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f36:	e9 bb 04 00 00       	jmp    8033f6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3f:	75 17                	jne    802f58 <insert_sorted_with_merge_freeList+0x2ab>
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	68 70 3f 80 00       	push   $0x803f70
  802f49:	68 4c 01 00 00       	push   $0x14c
  802f4e:	68 1f 3f 80 00       	push   $0x803f1f
  802f53:	e8 ce d3 ff ff       	call   800326 <_panic>
  802f58:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0c                	je     802f7a <insert_sorted_with_merge_freeList+0x2cd>
  802f6e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f73:	8b 55 08             	mov    0x8(%ebp),%edx
  802f76:	89 10                	mov    %edx,(%eax)
  802f78:	eb 08                	jmp    802f82 <insert_sorted_with_merge_freeList+0x2d5>
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	a3 38 41 80 00       	mov    %eax,0x804138
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f93:	a1 44 41 80 00       	mov    0x804144,%eax
  802f98:	40                   	inc    %eax
  802f99:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f9e:	e9 53 04 00 00       	jmp    8033f6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fa3:	a1 38 41 80 00       	mov    0x804138,%eax
  802fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fab:	e9 15 04 00 00       	jmp    8033c5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	8b 50 08             	mov    0x8(%eax),%edx
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 40 08             	mov    0x8(%eax),%eax
  802fc4:	39 c2                	cmp    %eax,%edx
  802fc6:	0f 86 f1 03 00 00    	jbe    8033bd <insert_sorted_with_merge_freeList+0x710>
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	8b 50 08             	mov    0x8(%eax),%edx
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 40 08             	mov    0x8(%eax),%eax
  802fd8:	39 c2                	cmp    %eax,%edx
  802fda:	0f 83 dd 03 00 00    	jae    8033bd <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 50 08             	mov    0x8(%eax),%edx
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	01 c2                	add    %eax,%edx
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 40 08             	mov    0x8(%eax),%eax
  802ff4:	39 c2                	cmp    %eax,%edx
  802ff6:	0f 85 b9 01 00 00    	jne    8031b5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 50 08             	mov    0x8(%eax),%edx
  803002:	8b 45 08             	mov    0x8(%ebp),%eax
  803005:	8b 40 0c             	mov    0xc(%eax),%eax
  803008:	01 c2                	add    %eax,%edx
  80300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300d:	8b 40 08             	mov    0x8(%eax),%eax
  803010:	39 c2                	cmp    %eax,%edx
  803012:	0f 85 0d 01 00 00    	jne    803125 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301b:	8b 50 0c             	mov    0xc(%eax),%edx
  80301e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	01 c2                	add    %eax,%edx
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80302c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803030:	75 17                	jne    803049 <insert_sorted_with_merge_freeList+0x39c>
  803032:	83 ec 04             	sub    $0x4,%esp
  803035:	68 c8 3f 80 00       	push   $0x803fc8
  80303a:	68 5c 01 00 00       	push   $0x15c
  80303f:	68 1f 3f 80 00       	push   $0x803f1f
  803044:	e8 dd d2 ff ff       	call   800326 <_panic>
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	8b 00                	mov    (%eax),%eax
  80304e:	85 c0                	test   %eax,%eax
  803050:	74 10                	je     803062 <insert_sorted_with_merge_freeList+0x3b5>
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305a:	8b 52 04             	mov    0x4(%edx),%edx
  80305d:	89 50 04             	mov    %edx,0x4(%eax)
  803060:	eb 0b                	jmp    80306d <insert_sorted_with_merge_freeList+0x3c0>
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 40 04             	mov    0x4(%eax),%eax
  803068:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 0f                	je     803086 <insert_sorted_with_merge_freeList+0x3d9>
  803077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307a:	8b 40 04             	mov    0x4(%eax),%eax
  80307d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803080:	8b 12                	mov    (%edx),%edx
  803082:	89 10                	mov    %edx,(%eax)
  803084:	eb 0a                	jmp    803090 <insert_sorted_with_merge_freeList+0x3e3>
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	a3 38 41 80 00       	mov    %eax,0x804138
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8030a8:	48                   	dec    %eax
  8030a9:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c6:	75 17                	jne    8030df <insert_sorted_with_merge_freeList+0x432>
  8030c8:	83 ec 04             	sub    $0x4,%esp
  8030cb:	68 fc 3e 80 00       	push   $0x803efc
  8030d0:	68 5f 01 00 00       	push   $0x15f
  8030d5:	68 1f 3f 80 00       	push   $0x803f1f
  8030da:	e8 47 d2 ff ff       	call   800326 <_panic>
  8030df:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	89 10                	mov    %edx,(%eax)
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	74 0d                	je     803100 <insert_sorted_with_merge_freeList+0x453>
  8030f3:	a1 48 41 80 00       	mov    0x804148,%eax
  8030f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fb:	89 50 04             	mov    %edx,0x4(%eax)
  8030fe:	eb 08                	jmp    803108 <insert_sorted_with_merge_freeList+0x45b>
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	a3 48 41 80 00       	mov    %eax,0x804148
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311a:	a1 54 41 80 00       	mov    0x804154,%eax
  80311f:	40                   	inc    %eax
  803120:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 50 0c             	mov    0xc(%eax),%edx
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	8b 40 0c             	mov    0xc(%eax),%eax
  803131:	01 c2                	add    %eax,%edx
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80314d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803151:	75 17                	jne    80316a <insert_sorted_with_merge_freeList+0x4bd>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 fc 3e 80 00       	push   $0x803efc
  80315b:	68 64 01 00 00       	push   $0x164
  803160:	68 1f 3f 80 00       	push   $0x803f1f
  803165:	e8 bc d1 ff ff       	call   800326 <_panic>
  80316a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	89 10                	mov    %edx,(%eax)
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	8b 00                	mov    (%eax),%eax
  80317a:	85 c0                	test   %eax,%eax
  80317c:	74 0d                	je     80318b <insert_sorted_with_merge_freeList+0x4de>
  80317e:	a1 48 41 80 00       	mov    0x804148,%eax
  803183:	8b 55 08             	mov    0x8(%ebp),%edx
  803186:	89 50 04             	mov    %edx,0x4(%eax)
  803189:	eb 08                	jmp    803193 <insert_sorted_with_merge_freeList+0x4e6>
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	a3 48 41 80 00       	mov    %eax,0x804148
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8031aa:	40                   	inc    %eax
  8031ab:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031b0:	e9 41 02 00 00       	jmp    8033f6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	8b 50 08             	mov    0x8(%eax),%edx
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c1:	01 c2                	add    %eax,%edx
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	8b 40 08             	mov    0x8(%eax),%eax
  8031c9:	39 c2                	cmp    %eax,%edx
  8031cb:	0f 85 7c 01 00 00    	jne    80334d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d5:	74 06                	je     8031dd <insert_sorted_with_merge_freeList+0x530>
  8031d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031db:	75 17                	jne    8031f4 <insert_sorted_with_merge_freeList+0x547>
  8031dd:	83 ec 04             	sub    $0x4,%esp
  8031e0:	68 38 3f 80 00       	push   $0x803f38
  8031e5:	68 69 01 00 00       	push   $0x169
  8031ea:	68 1f 3f 80 00       	push   $0x803f1f
  8031ef:	e8 32 d1 ff ff       	call   800326 <_panic>
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 50 04             	mov    0x4(%eax),%edx
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	89 50 04             	mov    %edx,0x4(%eax)
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803206:	89 10                	mov    %edx,(%eax)
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0d                	je     80321f <insert_sorted_with_merge_freeList+0x572>
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	8b 55 08             	mov    0x8(%ebp),%edx
  80321b:	89 10                	mov    %edx,(%eax)
  80321d:	eb 08                	jmp    803227 <insert_sorted_with_merge_freeList+0x57a>
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	a3 38 41 80 00       	mov    %eax,0x804138
  803227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322a:	8b 55 08             	mov    0x8(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	a1 44 41 80 00       	mov    0x804144,%eax
  803235:	40                   	inc    %eax
  803236:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	8b 50 0c             	mov    0xc(%eax),%edx
  803241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803244:	8b 40 0c             	mov    0xc(%eax),%eax
  803247:	01 c2                	add    %eax,%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80324f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803253:	75 17                	jne    80326c <insert_sorted_with_merge_freeList+0x5bf>
  803255:	83 ec 04             	sub    $0x4,%esp
  803258:	68 c8 3f 80 00       	push   $0x803fc8
  80325d:	68 6b 01 00 00       	push   $0x16b
  803262:	68 1f 3f 80 00       	push   $0x803f1f
  803267:	e8 ba d0 ff ff       	call   800326 <_panic>
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 00                	mov    (%eax),%eax
  803271:	85 c0                	test   %eax,%eax
  803273:	74 10                	je     803285 <insert_sorted_with_merge_freeList+0x5d8>
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327d:	8b 52 04             	mov    0x4(%edx),%edx
  803280:	89 50 04             	mov    %edx,0x4(%eax)
  803283:	eb 0b                	jmp    803290 <insert_sorted_with_merge_freeList+0x5e3>
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	8b 40 04             	mov    0x4(%eax),%eax
  80328b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	74 0f                	je     8032a9 <insert_sorted_with_merge_freeList+0x5fc>
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	8b 40 04             	mov    0x4(%eax),%eax
  8032a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a3:	8b 12                	mov    (%edx),%edx
  8032a5:	89 10                	mov    %edx,(%eax)
  8032a7:	eb 0a                	jmp    8032b3 <insert_sorted_with_merge_freeList+0x606>
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8032cb:	48                   	dec    %eax
  8032cc:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8032d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e9:	75 17                	jne    803302 <insert_sorted_with_merge_freeList+0x655>
  8032eb:	83 ec 04             	sub    $0x4,%esp
  8032ee:	68 fc 3e 80 00       	push   $0x803efc
  8032f3:	68 6e 01 00 00       	push   $0x16e
  8032f8:	68 1f 3f 80 00       	push   $0x803f1f
  8032fd:	e8 24 d0 ff ff       	call   800326 <_panic>
  803302:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	89 10                	mov    %edx,(%eax)
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	74 0d                	je     803323 <insert_sorted_with_merge_freeList+0x676>
  803316:	a1 48 41 80 00       	mov    0x804148,%eax
  80331b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331e:	89 50 04             	mov    %edx,0x4(%eax)
  803321:	eb 08                	jmp    80332b <insert_sorted_with_merge_freeList+0x67e>
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	a3 48 41 80 00       	mov    %eax,0x804148
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333d:	a1 54 41 80 00       	mov    0x804154,%eax
  803342:	40                   	inc    %eax
  803343:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803348:	e9 a9 00 00 00       	jmp    8033f6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80334d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803351:	74 06                	je     803359 <insert_sorted_with_merge_freeList+0x6ac>
  803353:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803357:	75 17                	jne    803370 <insert_sorted_with_merge_freeList+0x6c3>
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	68 94 3f 80 00       	push   $0x803f94
  803361:	68 73 01 00 00       	push   $0x173
  803366:	68 1f 3f 80 00       	push   $0x803f1f
  80336b:	e8 b6 cf ff ff       	call   800326 <_panic>
  803370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803373:	8b 10                	mov    (%eax),%edx
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	89 10                	mov    %edx,(%eax)
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 00                	mov    (%eax),%eax
  80337f:	85 c0                	test   %eax,%eax
  803381:	74 0b                	je     80338e <insert_sorted_with_merge_freeList+0x6e1>
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	8b 00                	mov    (%eax),%eax
  803388:	8b 55 08             	mov    0x8(%ebp),%edx
  80338b:	89 50 04             	mov    %edx,0x4(%eax)
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 55 08             	mov    0x8(%ebp),%edx
  803394:	89 10                	mov    %edx,(%eax)
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80339c:	89 50 04             	mov    %edx,0x4(%eax)
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	75 08                	jne    8033b0 <insert_sorted_with_merge_freeList+0x703>
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8033b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8033b5:	40                   	inc    %eax
  8033b6:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8033bb:	eb 39                	jmp    8033f6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8033c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c9:	74 07                	je     8033d2 <insert_sorted_with_merge_freeList+0x725>
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 00                	mov    (%eax),%eax
  8033d0:	eb 05                	jmp    8033d7 <insert_sorted_with_merge_freeList+0x72a>
  8033d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8033d7:	a3 40 41 80 00       	mov    %eax,0x804140
  8033dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	0f 85 c7 fb ff ff    	jne    802fb0 <insert_sorted_with_merge_freeList+0x303>
  8033e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ed:	0f 85 bd fb ff ff    	jne    802fb0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033f3:	eb 01                	jmp    8033f6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033f5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033f6:	90                   	nop
  8033f7:	c9                   	leave  
  8033f8:	c3                   	ret    

008033f9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033f9:	55                   	push   %ebp
  8033fa:	89 e5                	mov    %esp,%ebp
  8033fc:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803402:	89 d0                	mov    %edx,%eax
  803404:	c1 e0 02             	shl    $0x2,%eax
  803407:	01 d0                	add    %edx,%eax
  803409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803410:	01 d0                	add    %edx,%eax
  803412:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803419:	01 d0                	add    %edx,%eax
  80341b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803422:	01 d0                	add    %edx,%eax
  803424:	c1 e0 04             	shl    $0x4,%eax
  803427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80342a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803431:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803434:	83 ec 0c             	sub    $0xc,%esp
  803437:	50                   	push   %eax
  803438:	e8 26 e7 ff ff       	call   801b63 <sys_get_virtual_time>
  80343d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803440:	eb 41                	jmp    803483 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803442:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803445:	83 ec 0c             	sub    $0xc,%esp
  803448:	50                   	push   %eax
  803449:	e8 15 e7 ff ff       	call   801b63 <sys_get_virtual_time>
  80344e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803451:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803454:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803457:	29 c2                	sub    %eax,%edx
  803459:	89 d0                	mov    %edx,%eax
  80345b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80345e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803461:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803464:	89 d1                	mov    %edx,%ecx
  803466:	29 c1                	sub    %eax,%ecx
  803468:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80346b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346e:	39 c2                	cmp    %eax,%edx
  803470:	0f 97 c0             	seta   %al
  803473:	0f b6 c0             	movzbl %al,%eax
  803476:	29 c1                	sub    %eax,%ecx
  803478:	89 c8                	mov    %ecx,%eax
  80347a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80347d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803480:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803489:	72 b7                	jb     803442 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80348b:	90                   	nop
  80348c:	c9                   	leave  
  80348d:	c3                   	ret    

0080348e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80348e:	55                   	push   %ebp
  80348f:	89 e5                	mov    %esp,%ebp
  803491:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803494:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80349b:	eb 03                	jmp    8034a0 <busy_wait+0x12>
  80349d:	ff 45 fc             	incl   -0x4(%ebp)
  8034a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8034a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034a6:	72 f5                	jb     80349d <busy_wait+0xf>
	return i;
  8034a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8034ab:	c9                   	leave  
  8034ac:	c3                   	ret    
  8034ad:	66 90                	xchg   %ax,%ax
  8034af:	90                   	nop

008034b0 <__udivdi3>:
  8034b0:	55                   	push   %ebp
  8034b1:	57                   	push   %edi
  8034b2:	56                   	push   %esi
  8034b3:	53                   	push   %ebx
  8034b4:	83 ec 1c             	sub    $0x1c,%esp
  8034b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034c7:	89 ca                	mov    %ecx,%edx
  8034c9:	89 f8                	mov    %edi,%eax
  8034cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034cf:	85 f6                	test   %esi,%esi
  8034d1:	75 2d                	jne    803500 <__udivdi3+0x50>
  8034d3:	39 cf                	cmp    %ecx,%edi
  8034d5:	77 65                	ja     80353c <__udivdi3+0x8c>
  8034d7:	89 fd                	mov    %edi,%ebp
  8034d9:	85 ff                	test   %edi,%edi
  8034db:	75 0b                	jne    8034e8 <__udivdi3+0x38>
  8034dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034e2:	31 d2                	xor    %edx,%edx
  8034e4:	f7 f7                	div    %edi
  8034e6:	89 c5                	mov    %eax,%ebp
  8034e8:	31 d2                	xor    %edx,%edx
  8034ea:	89 c8                	mov    %ecx,%eax
  8034ec:	f7 f5                	div    %ebp
  8034ee:	89 c1                	mov    %eax,%ecx
  8034f0:	89 d8                	mov    %ebx,%eax
  8034f2:	f7 f5                	div    %ebp
  8034f4:	89 cf                	mov    %ecx,%edi
  8034f6:	89 fa                	mov    %edi,%edx
  8034f8:	83 c4 1c             	add    $0x1c,%esp
  8034fb:	5b                   	pop    %ebx
  8034fc:	5e                   	pop    %esi
  8034fd:	5f                   	pop    %edi
  8034fe:	5d                   	pop    %ebp
  8034ff:	c3                   	ret    
  803500:	39 ce                	cmp    %ecx,%esi
  803502:	77 28                	ja     80352c <__udivdi3+0x7c>
  803504:	0f bd fe             	bsr    %esi,%edi
  803507:	83 f7 1f             	xor    $0x1f,%edi
  80350a:	75 40                	jne    80354c <__udivdi3+0x9c>
  80350c:	39 ce                	cmp    %ecx,%esi
  80350e:	72 0a                	jb     80351a <__udivdi3+0x6a>
  803510:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803514:	0f 87 9e 00 00 00    	ja     8035b8 <__udivdi3+0x108>
  80351a:	b8 01 00 00 00       	mov    $0x1,%eax
  80351f:	89 fa                	mov    %edi,%edx
  803521:	83 c4 1c             	add    $0x1c,%esp
  803524:	5b                   	pop    %ebx
  803525:	5e                   	pop    %esi
  803526:	5f                   	pop    %edi
  803527:	5d                   	pop    %ebp
  803528:	c3                   	ret    
  803529:	8d 76 00             	lea    0x0(%esi),%esi
  80352c:	31 ff                	xor    %edi,%edi
  80352e:	31 c0                	xor    %eax,%eax
  803530:	89 fa                	mov    %edi,%edx
  803532:	83 c4 1c             	add    $0x1c,%esp
  803535:	5b                   	pop    %ebx
  803536:	5e                   	pop    %esi
  803537:	5f                   	pop    %edi
  803538:	5d                   	pop    %ebp
  803539:	c3                   	ret    
  80353a:	66 90                	xchg   %ax,%ax
  80353c:	89 d8                	mov    %ebx,%eax
  80353e:	f7 f7                	div    %edi
  803540:	31 ff                	xor    %edi,%edi
  803542:	89 fa                	mov    %edi,%edx
  803544:	83 c4 1c             	add    $0x1c,%esp
  803547:	5b                   	pop    %ebx
  803548:	5e                   	pop    %esi
  803549:	5f                   	pop    %edi
  80354a:	5d                   	pop    %ebp
  80354b:	c3                   	ret    
  80354c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803551:	89 eb                	mov    %ebp,%ebx
  803553:	29 fb                	sub    %edi,%ebx
  803555:	89 f9                	mov    %edi,%ecx
  803557:	d3 e6                	shl    %cl,%esi
  803559:	89 c5                	mov    %eax,%ebp
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 ed                	shr    %cl,%ebp
  80355f:	89 e9                	mov    %ebp,%ecx
  803561:	09 f1                	or     %esi,%ecx
  803563:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803567:	89 f9                	mov    %edi,%ecx
  803569:	d3 e0                	shl    %cl,%eax
  80356b:	89 c5                	mov    %eax,%ebp
  80356d:	89 d6                	mov    %edx,%esi
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 ee                	shr    %cl,%esi
  803573:	89 f9                	mov    %edi,%ecx
  803575:	d3 e2                	shl    %cl,%edx
  803577:	8b 44 24 08          	mov    0x8(%esp),%eax
  80357b:	88 d9                	mov    %bl,%cl
  80357d:	d3 e8                	shr    %cl,%eax
  80357f:	09 c2                	or     %eax,%edx
  803581:	89 d0                	mov    %edx,%eax
  803583:	89 f2                	mov    %esi,%edx
  803585:	f7 74 24 0c          	divl   0xc(%esp)
  803589:	89 d6                	mov    %edx,%esi
  80358b:	89 c3                	mov    %eax,%ebx
  80358d:	f7 e5                	mul    %ebp
  80358f:	39 d6                	cmp    %edx,%esi
  803591:	72 19                	jb     8035ac <__udivdi3+0xfc>
  803593:	74 0b                	je     8035a0 <__udivdi3+0xf0>
  803595:	89 d8                	mov    %ebx,%eax
  803597:	31 ff                	xor    %edi,%edi
  803599:	e9 58 ff ff ff       	jmp    8034f6 <__udivdi3+0x46>
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035a4:	89 f9                	mov    %edi,%ecx
  8035a6:	d3 e2                	shl    %cl,%edx
  8035a8:	39 c2                	cmp    %eax,%edx
  8035aa:	73 e9                	jae    803595 <__udivdi3+0xe5>
  8035ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035af:	31 ff                	xor    %edi,%edi
  8035b1:	e9 40 ff ff ff       	jmp    8034f6 <__udivdi3+0x46>
  8035b6:	66 90                	xchg   %ax,%ax
  8035b8:	31 c0                	xor    %eax,%eax
  8035ba:	e9 37 ff ff ff       	jmp    8034f6 <__udivdi3+0x46>
  8035bf:	90                   	nop

008035c0 <__umoddi3>:
  8035c0:	55                   	push   %ebp
  8035c1:	57                   	push   %edi
  8035c2:	56                   	push   %esi
  8035c3:	53                   	push   %ebx
  8035c4:	83 ec 1c             	sub    $0x1c,%esp
  8035c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035df:	89 f3                	mov    %esi,%ebx
  8035e1:	89 fa                	mov    %edi,%edx
  8035e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035e7:	89 34 24             	mov    %esi,(%esp)
  8035ea:	85 c0                	test   %eax,%eax
  8035ec:	75 1a                	jne    803608 <__umoddi3+0x48>
  8035ee:	39 f7                	cmp    %esi,%edi
  8035f0:	0f 86 a2 00 00 00    	jbe    803698 <__umoddi3+0xd8>
  8035f6:	89 c8                	mov    %ecx,%eax
  8035f8:	89 f2                	mov    %esi,%edx
  8035fa:	f7 f7                	div    %edi
  8035fc:	89 d0                	mov    %edx,%eax
  8035fe:	31 d2                	xor    %edx,%edx
  803600:	83 c4 1c             	add    $0x1c,%esp
  803603:	5b                   	pop    %ebx
  803604:	5e                   	pop    %esi
  803605:	5f                   	pop    %edi
  803606:	5d                   	pop    %ebp
  803607:	c3                   	ret    
  803608:	39 f0                	cmp    %esi,%eax
  80360a:	0f 87 ac 00 00 00    	ja     8036bc <__umoddi3+0xfc>
  803610:	0f bd e8             	bsr    %eax,%ebp
  803613:	83 f5 1f             	xor    $0x1f,%ebp
  803616:	0f 84 ac 00 00 00    	je     8036c8 <__umoddi3+0x108>
  80361c:	bf 20 00 00 00       	mov    $0x20,%edi
  803621:	29 ef                	sub    %ebp,%edi
  803623:	89 fe                	mov    %edi,%esi
  803625:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803629:	89 e9                	mov    %ebp,%ecx
  80362b:	d3 e0                	shl    %cl,%eax
  80362d:	89 d7                	mov    %edx,%edi
  80362f:	89 f1                	mov    %esi,%ecx
  803631:	d3 ef                	shr    %cl,%edi
  803633:	09 c7                	or     %eax,%edi
  803635:	89 e9                	mov    %ebp,%ecx
  803637:	d3 e2                	shl    %cl,%edx
  803639:	89 14 24             	mov    %edx,(%esp)
  80363c:	89 d8                	mov    %ebx,%eax
  80363e:	d3 e0                	shl    %cl,%eax
  803640:	89 c2                	mov    %eax,%edx
  803642:	8b 44 24 08          	mov    0x8(%esp),%eax
  803646:	d3 e0                	shl    %cl,%eax
  803648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80364c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803650:	89 f1                	mov    %esi,%ecx
  803652:	d3 e8                	shr    %cl,%eax
  803654:	09 d0                	or     %edx,%eax
  803656:	d3 eb                	shr    %cl,%ebx
  803658:	89 da                	mov    %ebx,%edx
  80365a:	f7 f7                	div    %edi
  80365c:	89 d3                	mov    %edx,%ebx
  80365e:	f7 24 24             	mull   (%esp)
  803661:	89 c6                	mov    %eax,%esi
  803663:	89 d1                	mov    %edx,%ecx
  803665:	39 d3                	cmp    %edx,%ebx
  803667:	0f 82 87 00 00 00    	jb     8036f4 <__umoddi3+0x134>
  80366d:	0f 84 91 00 00 00    	je     803704 <__umoddi3+0x144>
  803673:	8b 54 24 04          	mov    0x4(%esp),%edx
  803677:	29 f2                	sub    %esi,%edx
  803679:	19 cb                	sbb    %ecx,%ebx
  80367b:	89 d8                	mov    %ebx,%eax
  80367d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803681:	d3 e0                	shl    %cl,%eax
  803683:	89 e9                	mov    %ebp,%ecx
  803685:	d3 ea                	shr    %cl,%edx
  803687:	09 d0                	or     %edx,%eax
  803689:	89 e9                	mov    %ebp,%ecx
  80368b:	d3 eb                	shr    %cl,%ebx
  80368d:	89 da                	mov    %ebx,%edx
  80368f:	83 c4 1c             	add    $0x1c,%esp
  803692:	5b                   	pop    %ebx
  803693:	5e                   	pop    %esi
  803694:	5f                   	pop    %edi
  803695:	5d                   	pop    %ebp
  803696:	c3                   	ret    
  803697:	90                   	nop
  803698:	89 fd                	mov    %edi,%ebp
  80369a:	85 ff                	test   %edi,%edi
  80369c:	75 0b                	jne    8036a9 <__umoddi3+0xe9>
  80369e:	b8 01 00 00 00       	mov    $0x1,%eax
  8036a3:	31 d2                	xor    %edx,%edx
  8036a5:	f7 f7                	div    %edi
  8036a7:	89 c5                	mov    %eax,%ebp
  8036a9:	89 f0                	mov    %esi,%eax
  8036ab:	31 d2                	xor    %edx,%edx
  8036ad:	f7 f5                	div    %ebp
  8036af:	89 c8                	mov    %ecx,%eax
  8036b1:	f7 f5                	div    %ebp
  8036b3:	89 d0                	mov    %edx,%eax
  8036b5:	e9 44 ff ff ff       	jmp    8035fe <__umoddi3+0x3e>
  8036ba:	66 90                	xchg   %ax,%ax
  8036bc:	89 c8                	mov    %ecx,%eax
  8036be:	89 f2                	mov    %esi,%edx
  8036c0:	83 c4 1c             	add    $0x1c,%esp
  8036c3:	5b                   	pop    %ebx
  8036c4:	5e                   	pop    %esi
  8036c5:	5f                   	pop    %edi
  8036c6:	5d                   	pop    %ebp
  8036c7:	c3                   	ret    
  8036c8:	3b 04 24             	cmp    (%esp),%eax
  8036cb:	72 06                	jb     8036d3 <__umoddi3+0x113>
  8036cd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036d1:	77 0f                	ja     8036e2 <__umoddi3+0x122>
  8036d3:	89 f2                	mov    %esi,%edx
  8036d5:	29 f9                	sub    %edi,%ecx
  8036d7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036db:	89 14 24             	mov    %edx,(%esp)
  8036de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036e2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036e6:	8b 14 24             	mov    (%esp),%edx
  8036e9:	83 c4 1c             	add    $0x1c,%esp
  8036ec:	5b                   	pop    %ebx
  8036ed:	5e                   	pop    %esi
  8036ee:	5f                   	pop    %edi
  8036ef:	5d                   	pop    %ebp
  8036f0:	c3                   	ret    
  8036f1:	8d 76 00             	lea    0x0(%esi),%esi
  8036f4:	2b 04 24             	sub    (%esp),%eax
  8036f7:	19 fa                	sbb    %edi,%edx
  8036f9:	89 d1                	mov    %edx,%ecx
  8036fb:	89 c6                	mov    %eax,%esi
  8036fd:	e9 71 ff ff ff       	jmp    803673 <__umoddi3+0xb3>
  803702:	66 90                	xchg   %ax,%ax
  803704:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803708:	72 ea                	jb     8036f4 <__umoddi3+0x134>
  80370a:	89 d9                	mov    %ebx,%ecx
  80370c:	e9 62 ff ff ff       	jmp    803673 <__umoddi3+0xb3>
