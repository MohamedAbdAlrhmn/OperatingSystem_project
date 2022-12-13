
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
  800045:	68 00 37 80 00       	push   $0x803700
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
  800069:	68 02 37 80 00       	push   $0x803702
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
  8000a6:	68 09 37 80 00       	push   $0x803709
  8000ab:	e8 c0 18 00 00       	call   801970 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 0b 37 80 00       	push   $0x80370b
  8000bf:	e8 e6 14 00 00       	call   8015aa <smalloc>
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
  8000ec:	68 19 37 80 00       	push   $0x803719
  8000f1:	e8 8b 19 00 00       	call   801a81 <sys_create_env>
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
  800115:	68 23 37 80 00       	push   $0x803723
  80011a:	e8 62 19 00 00       	call   801a81 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 2d 37 80 00       	push   $0x80372d
  800139:	6a 27                	push   $0x27
  80013b:	68 42 37 80 00       	push   $0x803742
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 4f 19 00 00       	call   801a9f <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 71 32 00 00       	call   8033d1 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 31 19 00 00       	call   801a9f <sys_run_env>
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
  800185:	68 5d 37 80 00       	push   $0x80375d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 71 19 00 00       	call   801b08 <sys_getparentenvid>
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
  8001aa:	68 0b 37 80 00       	push   $0x80370b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 b4 14 00 00       	call   80166b <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 f3 18 00 00       	call   801abb <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 e5 18 00 00       	call   801abb <sys_destroy_env>
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
  8001f0:	e8 fa 18 00 00       	call   801aef <sys_getenvindex>
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
  80025b:	e8 9c 16 00 00       	call   8018fc <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 8c 37 80 00       	push   $0x80378c
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
  80028b:	68 b4 37 80 00       	push   $0x8037b4
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
  8002bc:	68 dc 37 80 00       	push   $0x8037dc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 34 38 80 00       	push   $0x803834
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 8c 37 80 00       	push   $0x80378c
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 1c 16 00 00       	call   801916 <sys_enable_interrupt>

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
  80030d:	e8 a9 17 00 00       	call   801abb <sys_destroy_env>
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
  80031e:	e8 fe 17 00 00       	call   801b21 <sys_exit_env>
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
  800347:	68 48 38 80 00       	push   $0x803848
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 50 80 00       	mov    0x805000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 4d 38 80 00       	push   $0x80384d
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
  800384:	68 69 38 80 00       	push   $0x803869
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
  8003b0:	68 6c 38 80 00       	push   $0x80386c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 b8 38 80 00       	push   $0x8038b8
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
  800482:	68 c4 38 80 00       	push   $0x8038c4
  800487:	6a 3a                	push   $0x3a
  800489:	68 b8 38 80 00       	push   $0x8038b8
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
  8004f2:	68 18 39 80 00       	push   $0x803918
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 b8 38 80 00       	push   $0x8038b8
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
  80054c:	e8 fd 11 00 00       	call   80174e <sys_cputs>
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
  8005c3:	e8 86 11 00 00       	call   80174e <sys_cputs>
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
  80060d:	e8 ea 12 00 00       	call   8018fc <sys_disable_interrupt>
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
  80062d:	e8 e4 12 00 00       	call   801916 <sys_enable_interrupt>
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
  800677:	e8 0c 2e 00 00       	call   803488 <__udivdi3>
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
  8006c7:	e8 cc 2e 00 00       	call   803598 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 94 3b 80 00       	add    $0x803b94,%eax
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
  800822:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
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
  800903:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 a5 3b 80 00       	push   $0x803ba5
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
  800928:	68 ae 3b 80 00       	push   $0x803bae
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
  800955:	be b1 3b 80 00       	mov    $0x803bb1,%esi
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
  80137b:	68 10 3d 80 00       	push   $0x803d10
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
  80144b:	e8 42 04 00 00       	call   801892 <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 51 80 00       	mov    0x805120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 b7 0a 00 00       	call   801f18 <initialize_MemBlocksList>
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
  801489:	68 35 3d 80 00       	push   $0x803d35
  80148e:	6a 33                	push   $0x33
  801490:	68 53 3d 80 00       	push   $0x803d53
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
  801508:	68 60 3d 80 00       	push   $0x803d60
  80150d:	6a 34                	push   $0x34
  80150f:	68 53 3d 80 00       	push   $0x803d53
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
  80157d:	68 84 3d 80 00       	push   $0x803d84
  801582:	6a 46                	push   $0x46
  801584:	68 53 3d 80 00       	push   $0x803d53
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
  801599:	68 ac 3d 80 00       	push   $0x803dac
  80159e:	6a 61                	push   $0x61
  8015a0:	68 53 3d 80 00       	push   $0x803d53
  8015a5:	e8 7c ed ff ff       	call   800326 <_panic>

008015aa <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 38             	sub    $0x38,%esp
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b6:	e8 a9 fd ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bf:	75 0a                	jne    8015cb <smalloc+0x21>
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	e9 9e 00 00 00       	jmp    801669 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015cb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d8:	01 d0                	add    %edx,%eax
  8015da:	48                   	dec    %eax
  8015db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e6:	f7 75 f0             	divl   -0x10(%ebp)
  8015e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ec:	29 d0                	sub    %edx,%eax
  8015ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015f1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f8:	e8 63 06 00 00       	call   801c60 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	74 11                	je     801612 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	ff 75 e8             	pushl  -0x18(%ebp)
  801607:	e8 ce 0c 00 00       	call   8022da <alloc_block_FF>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801616:	74 4c                	je     801664 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161b:	8b 40 08             	mov    0x8(%eax),%eax
  80161e:	89 c2                	mov    %eax,%edx
  801620:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801624:	52                   	push   %edx
  801625:	50                   	push   %eax
  801626:	ff 75 0c             	pushl  0xc(%ebp)
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	e8 b4 03 00 00       	call   8019e5 <sys_createSharedObject>
  801631:	83 c4 10             	add    $0x10,%esp
  801634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801637:	83 ec 08             	sub    $0x8,%esp
  80163a:	ff 75 e0             	pushl  -0x20(%ebp)
  80163d:	68 cf 3d 80 00       	push   $0x803dcf
  801642:	e8 93 ef ff ff       	call   8005da <cprintf>
  801647:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80164a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80164e:	74 14                	je     801664 <smalloc+0xba>
  801650:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801654:	74 0e                	je     801664 <smalloc+0xba>
  801656:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80165a:	74 08                	je     801664 <smalloc+0xba>
			return (void*) mem_block->sva;
  80165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165f:	8b 40 08             	mov    0x8(%eax),%eax
  801662:	eb 05                	jmp    801669 <smalloc+0xbf>
	}
	return NULL;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801671:	e8 ee fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801676:	83 ec 04             	sub    $0x4,%esp
  801679:	68 e4 3d 80 00       	push   $0x803de4
  80167e:	68 ab 00 00 00       	push   $0xab
  801683:	68 53 3d 80 00       	push   $0x803d53
  801688:	e8 99 ec ff ff       	call   800326 <_panic>

0080168d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801693:	e8 cc fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	68 08 3e 80 00       	push   $0x803e08
  8016a0:	68 ef 00 00 00       	push   $0xef
  8016a5:	68 53 3d 80 00       	push   $0x803d53
  8016aa:	e8 77 ec ff ff       	call   800326 <_panic>

008016af <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 30 3e 80 00       	push   $0x803e30
  8016bd:	68 03 01 00 00       	push   $0x103
  8016c2:	68 53 3d 80 00       	push   $0x803d53
  8016c7:	e8 5a ec ff ff       	call   800326 <_panic>

008016cc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	68 54 3e 80 00       	push   $0x803e54
  8016da:	68 0e 01 00 00       	push   $0x10e
  8016df:	68 53 3d 80 00       	push   $0x803d53
  8016e4:	e8 3d ec ff ff       	call   800326 <_panic>

008016e9 <shrink>:

}
void shrink(uint32 newSize)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ef:	83 ec 04             	sub    $0x4,%esp
  8016f2:	68 54 3e 80 00       	push   $0x803e54
  8016f7:	68 13 01 00 00       	push   $0x113
  8016fc:	68 53 3d 80 00       	push   $0x803d53
  801701:	e8 20 ec ff ff       	call   800326 <_panic>

00801706 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80170c:	83 ec 04             	sub    $0x4,%esp
  80170f:	68 54 3e 80 00       	push   $0x803e54
  801714:	68 18 01 00 00       	push   $0x118
  801719:	68 53 3d 80 00       	push   $0x803d53
  80171e:	e8 03 ec ff ff       	call   800326 <_panic>

00801723 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	57                   	push   %edi
  801727:	56                   	push   %esi
  801728:	53                   	push   %ebx
  801729:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801732:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801735:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801738:	8b 7d 18             	mov    0x18(%ebp),%edi
  80173b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80173e:	cd 30                	int    $0x30
  801740:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801743:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801746:	83 c4 10             	add    $0x10,%esp
  801749:	5b                   	pop    %ebx
  80174a:	5e                   	pop    %esi
  80174b:	5f                   	pop    %edi
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    

0080174e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80175a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	52                   	push   %edx
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	50                   	push   %eax
  80176a:	6a 00                	push   $0x0
  80176c:	e8 b2 ff ff ff       	call   801723 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	90                   	nop
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_cgetc>:

int
sys_cgetc(void)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 01                	push   $0x1
  801786:	e8 98 ff ff ff       	call   801723 <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	6a 05                	push   $0x5
  8017a3:	e8 7b ff ff ff       	call   801723 <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017b2:	8b 75 18             	mov    0x18(%ebp),%esi
  8017b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017be:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c1:	56                   	push   %esi
  8017c2:	53                   	push   %ebx
  8017c3:	51                   	push   %ecx
  8017c4:	52                   	push   %edx
  8017c5:	50                   	push   %eax
  8017c6:	6a 06                	push   $0x6
  8017c8:	e8 56 ff ff ff       	call   801723 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5e                   	pop    %esi
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    

008017d7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	52                   	push   %edx
  8017e7:	50                   	push   %eax
  8017e8:	6a 07                	push   $0x7
  8017ea:	e8 34 ff ff ff       	call   801723 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	ff 75 0c             	pushl  0xc(%ebp)
  801800:	ff 75 08             	pushl  0x8(%ebp)
  801803:	6a 08                	push   $0x8
  801805:	e8 19 ff ff ff       	call   801723 <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 09                	push   $0x9
  80181e:	e8 00 ff ff ff       	call   801723 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 0a                	push   $0xa
  801837:	e8 e7 fe ff ff       	call   801723 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 0b                	push   $0xb
  801850:	e8 ce fe ff ff       	call   801723 <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	ff 75 0c             	pushl  0xc(%ebp)
  801866:	ff 75 08             	pushl  0x8(%ebp)
  801869:	6a 0f                	push   $0xf
  80186b:	e8 b3 fe ff ff       	call   801723 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
	return;
  801873:	90                   	nop
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	6a 10                	push   $0x10
  801887:	e8 97 fe ff ff       	call   801723 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
	return ;
  80188f:	90                   	nop
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	ff 75 10             	pushl  0x10(%ebp)
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	6a 11                	push   $0x11
  8018a4:	e8 7a fe ff ff       	call   801723 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ac:	90                   	nop
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 0c                	push   $0xc
  8018be:	e8 60 fe ff ff       	call   801723 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 08             	pushl  0x8(%ebp)
  8018d6:	6a 0d                	push   $0xd
  8018d8:	e8 46 fe ff ff       	call   801723 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 0e                	push   $0xe
  8018f1:	e8 2d fe ff ff       	call   801723 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 13                	push   $0x13
  80190b:	e8 13 fe ff ff       	call   801723 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 14                	push   $0x14
  801925:	e8 f9 fd ff ff       	call   801723 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	90                   	nop
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_cputc>:


void
sys_cputc(const char c)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80193c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	50                   	push   %eax
  801949:	6a 15                	push   $0x15
  80194b:	e8 d3 fd ff ff       	call   801723 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	90                   	nop
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 16                	push   $0x16
  801965:	e8 b9 fd ff ff       	call   801723 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	90                   	nop
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	50                   	push   %eax
  801980:	6a 17                	push   $0x17
  801982:	e8 9c fd ff ff       	call   801723 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	52                   	push   %edx
  80199c:	50                   	push   %eax
  80199d:	6a 1a                	push   $0x1a
  80199f:	e8 7f fd ff ff       	call   801723 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 18                	push   $0x18
  8019bc:	e8 62 fd ff ff       	call   801723 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	6a 19                	push   $0x19
  8019da:	e8 44 fd ff ff       	call   801723 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	51                   	push   %ecx
  8019fe:	52                   	push   %edx
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	50                   	push   %eax
  801a03:	6a 1b                	push   $0x1b
  801a05:	e8 19 fd ff ff       	call   801723 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 1c                	push   $0x1c
  801a22:	e8 fc fc ff ff       	call   801723 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a35:	8b 45 08             	mov    0x8(%ebp),%eax
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	51                   	push   %ecx
  801a3d:	52                   	push   %edx
  801a3e:	50                   	push   %eax
  801a3f:	6a 1d                	push   $0x1d
  801a41:	e8 dd fc ff ff       	call   801723 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 1e                	push   $0x1e
  801a5e:	e8 c0 fc ff ff       	call   801723 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 1f                	push   $0x1f
  801a77:	e8 a7 fc ff ff       	call   801723 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	ff 75 14             	pushl  0x14(%ebp)
  801a8c:	ff 75 10             	pushl  0x10(%ebp)
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	50                   	push   %eax
  801a93:	6a 20                	push   $0x20
  801a95:	e8 89 fc ff ff       	call   801723 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	50                   	push   %eax
  801aae:	6a 21                	push   $0x21
  801ab0:	e8 6e fc ff ff       	call   801723 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	90                   	nop
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	50                   	push   %eax
  801aca:	6a 22                	push   $0x22
  801acc:	e8 52 fc ff ff       	call   801723 <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 02                	push   $0x2
  801ae5:	e8 39 fc ff ff       	call   801723 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 03                	push   $0x3
  801afe:	e8 20 fc ff ff       	call   801723 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 04                	push   $0x4
  801b17:	e8 07 fc ff ff       	call   801723 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_exit_env>:


void sys_exit_env(void)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 23                	push   $0x23
  801b30:	e8 ee fb ff ff       	call   801723 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b41:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b44:	8d 50 04             	lea    0x4(%eax),%edx
  801b47:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 24                	push   $0x24
  801b54:	e8 ca fb ff ff       	call   801723 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
	return result;
  801b5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b65:	89 01                	mov    %eax,(%ecx)
  801b67:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	c9                   	leave  
  801b6e:	c2 04 00             	ret    $0x4

00801b71 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 10             	pushl  0x10(%ebp)
  801b7b:	ff 75 0c             	pushl  0xc(%ebp)
  801b7e:	ff 75 08             	pushl  0x8(%ebp)
  801b81:	6a 12                	push   $0x12
  801b83:	e8 9b fb ff ff       	call   801723 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8b:	90                   	nop
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 25                	push   $0x25
  801b9d:	e8 81 fb ff ff       	call   801723 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	50                   	push   %eax
  801bc0:	6a 26                	push   $0x26
  801bc2:	e8 5c fb ff ff       	call   801723 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bca:	90                   	nop
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <rsttst>:
void rsttst()
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 28                	push   $0x28
  801bdc:	e8 42 fb ff ff       	call   801723 <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf3:	8b 55 18             	mov    0x18(%ebp),%edx
  801bf6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	ff 75 08             	pushl  0x8(%ebp)
  801c05:	6a 27                	push   $0x27
  801c07:	e8 17 fb ff ff       	call   801723 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <chktst>:
void chktst(uint32 n)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	6a 29                	push   $0x29
  801c22:	e8 fc fa ff ff       	call   801723 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <inctst>:

void inctst()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 2a                	push   $0x2a
  801c3c:	e8 e2 fa ff ff       	call   801723 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
	return ;
  801c44:	90                   	nop
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <gettst>:
uint32 gettst()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 2b                	push   $0x2b
  801c56:	e8 c8 fa ff ff       	call   801723 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 2c                	push   $0x2c
  801c72:	e8 ac fa ff ff       	call   801723 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
  801c7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c7d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c81:	75 07                	jne    801c8a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c83:	b8 01 00 00 00       	mov    $0x1,%eax
  801c88:	eb 05                	jmp    801c8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 2c                	push   $0x2c
  801ca3:	e8 7b fa ff ff       	call   801723 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
  801cab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cb2:	75 07                	jne    801cbb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb9:	eb 05                	jmp    801cc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 2c                	push   $0x2c
  801cd4:	e8 4a fa ff ff       	call   801723 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
  801cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cdf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ce3:	75 07                	jne    801cec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ce5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cea:	eb 05                	jmp    801cf1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 2c                	push   $0x2c
  801d05:	e8 19 fa ff ff       	call   801723 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
  801d0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d10:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d14:	75 07                	jne    801d1d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	eb 05                	jmp    801d22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 2d                	push   $0x2d
  801d34:	e8 ea f9 ff ff       	call   801723 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	53                   	push   %ebx
  801d52:	51                   	push   %ecx
  801d53:	52                   	push   %edx
  801d54:	50                   	push   %eax
  801d55:	6a 2e                	push   $0x2e
  801d57:	e8 c7 f9 ff ff       	call   801723 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	52                   	push   %edx
  801d74:	50                   	push   %eax
  801d75:	6a 2f                	push   $0x2f
  801d77:	e8 a7 f9 ff ff       	call   801723 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
  801d84:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d87:	83 ec 0c             	sub    $0xc,%esp
  801d8a:	68 64 3e 80 00       	push   $0x803e64
  801d8f:	e8 46 e8 ff ff       	call   8005da <cprintf>
  801d94:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	68 90 3e 80 00       	push   $0x803e90
  801da6:	e8 2f e8 ff ff       	call   8005da <cprintf>
  801dab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db2:	a1 38 51 80 00       	mov    0x805138,%eax
  801db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dba:	eb 56                	jmp    801e12 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc0:	74 1c                	je     801dde <print_mem_block_lists+0x5d>
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	8b 50 08             	mov    0x8(%eax),%edx
  801dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcb:	8b 48 08             	mov    0x8(%eax),%ecx
  801dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd4:	01 c8                	add    %ecx,%eax
  801dd6:	39 c2                	cmp    %eax,%edx
  801dd8:	73 04                	jae    801dde <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dda:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de1:	8b 50 08             	mov    0x8(%eax),%edx
  801de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dea:	01 c2                	add    %eax,%edx
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 40 08             	mov    0x8(%eax),%eax
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	68 a5 3e 80 00       	push   $0x803ea5
  801dfc:	e8 d9 e7 ff ff       	call   8005da <cprintf>
  801e01:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e0a:	a1 40 51 80 00       	mov    0x805140,%eax
  801e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e16:	74 07                	je     801e1f <print_mem_block_lists+0x9e>
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	8b 00                	mov    (%eax),%eax
  801e1d:	eb 05                	jmp    801e24 <print_mem_block_lists+0xa3>
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	a3 40 51 80 00       	mov    %eax,0x805140
  801e29:	a1 40 51 80 00       	mov    0x805140,%eax
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	75 8a                	jne    801dbc <print_mem_block_lists+0x3b>
  801e32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e36:	75 84                	jne    801dbc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e38:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e3c:	75 10                	jne    801e4e <print_mem_block_lists+0xcd>
  801e3e:	83 ec 0c             	sub    $0xc,%esp
  801e41:	68 b4 3e 80 00       	push   $0x803eb4
  801e46:	e8 8f e7 ff ff       	call   8005da <cprintf>
  801e4b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e4e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e55:	83 ec 0c             	sub    $0xc,%esp
  801e58:	68 d8 3e 80 00       	push   $0x803ed8
  801e5d:	e8 78 e7 ff ff       	call   8005da <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e65:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e69:	a1 40 50 80 00       	mov    0x805040,%eax
  801e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e71:	eb 56                	jmp    801ec9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e77:	74 1c                	je     801e95 <print_mem_block_lists+0x114>
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	8b 50 08             	mov    0x8(%eax),%edx
  801e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e82:	8b 48 08             	mov    0x8(%eax),%ecx
  801e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e88:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8b:	01 c8                	add    %ecx,%eax
  801e8d:	39 c2                	cmp    %eax,%edx
  801e8f:	73 04                	jae    801e95 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e91:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	8b 50 08             	mov    0x8(%eax),%edx
  801e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea1:	01 c2                	add    %eax,%edx
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	8b 40 08             	mov    0x8(%eax),%eax
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	52                   	push   %edx
  801ead:	50                   	push   %eax
  801eae:	68 a5 3e 80 00       	push   $0x803ea5
  801eb3:	e8 22 e7 ff ff       	call   8005da <cprintf>
  801eb8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ec1:	a1 48 50 80 00       	mov    0x805048,%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecd:	74 07                	je     801ed6 <print_mem_block_lists+0x155>
  801ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed2:	8b 00                	mov    (%eax),%eax
  801ed4:	eb 05                	jmp    801edb <print_mem_block_lists+0x15a>
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  801edb:	a3 48 50 80 00       	mov    %eax,0x805048
  801ee0:	a1 48 50 80 00       	mov    0x805048,%eax
  801ee5:	85 c0                	test   %eax,%eax
  801ee7:	75 8a                	jne    801e73 <print_mem_block_lists+0xf2>
  801ee9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eed:	75 84                	jne    801e73 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef3:	75 10                	jne    801f05 <print_mem_block_lists+0x184>
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	68 f0 3e 80 00       	push   $0x803ef0
  801efd:	e8 d8 e6 ff ff       	call   8005da <cprintf>
  801f02:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	68 64 3e 80 00       	push   $0x803e64
  801f0d:	e8 c8 e6 ff ff       	call   8005da <cprintf>
  801f12:	83 c4 10             	add    $0x10,%esp

}
  801f15:	90                   	nop
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f1e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f25:	00 00 00 
  801f28:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f2f:	00 00 00 
  801f32:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f39:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f43:	e9 9e 00 00 00       	jmp    801fe6 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f48:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f50:	c1 e2 04             	shl    $0x4,%edx
  801f53:	01 d0                	add    %edx,%eax
  801f55:	85 c0                	test   %eax,%eax
  801f57:	75 14                	jne    801f6d <initialize_MemBlocksList+0x55>
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	68 18 3f 80 00       	push   $0x803f18
  801f61:	6a 46                	push   $0x46
  801f63:	68 3b 3f 80 00       	push   $0x803f3b
  801f68:	e8 b9 e3 ff ff       	call   800326 <_panic>
  801f6d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	c1 e2 04             	shl    $0x4,%edx
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f80:	89 10                	mov    %edx,(%eax)
  801f82:	8b 00                	mov    (%eax),%eax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	74 18                	je     801fa0 <initialize_MemBlocksList+0x88>
  801f88:	a1 48 51 80 00       	mov    0x805148,%eax
  801f8d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f93:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f96:	c1 e1 04             	shl    $0x4,%ecx
  801f99:	01 ca                	add    %ecx,%edx
  801f9b:	89 50 04             	mov    %edx,0x4(%eax)
  801f9e:	eb 12                	jmp    801fb2 <initialize_MemBlocksList+0x9a>
  801fa0:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa8:	c1 e2 04             	shl    $0x4,%edx
  801fab:	01 d0                	add    %edx,%eax
  801fad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fb2:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	c1 e2 04             	shl    $0x4,%edx
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	a3 48 51 80 00       	mov    %eax,0x805148
  801fc4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcc:	c1 e2 04             	shl    $0x4,%edx
  801fcf:	01 d0                	add    %edx,%eax
  801fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fd8:	a1 54 51 80 00       	mov    0x805154,%eax
  801fdd:	40                   	inc    %eax
  801fde:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fe3:	ff 45 f4             	incl   -0xc(%ebp)
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fec:	0f 82 56 ff ff ff    	jb     801f48 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ff2:	90                   	nop
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	8b 00                	mov    (%eax),%eax
  802000:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802003:	eb 19                	jmp    80201e <find_block+0x29>
	{
		if(va==point->sva)
  802005:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802008:	8b 40 08             	mov    0x8(%eax),%eax
  80200b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80200e:	75 05                	jne    802015 <find_block+0x20>
		   return point;
  802010:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802013:	eb 36                	jmp    80204b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	8b 40 08             	mov    0x8(%eax),%eax
  80201b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80201e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802022:	74 07                	je     80202b <find_block+0x36>
  802024:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	eb 05                	jmp    802030 <find_block+0x3b>
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	8b 55 08             	mov    0x8(%ebp),%edx
  802033:	89 42 08             	mov    %eax,0x8(%edx)
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8b 40 08             	mov    0x8(%eax),%eax
  80203c:	85 c0                	test   %eax,%eax
  80203e:	75 c5                	jne    802005 <find_block+0x10>
  802040:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802044:	75 bf                	jne    802005 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802053:	a1 40 50 80 00       	mov    0x805040,%eax
  802058:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80205b:	a1 44 50 80 00       	mov    0x805044,%eax
  802060:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802066:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802069:	74 24                	je     80208f <insert_sorted_allocList+0x42>
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8b 50 08             	mov    0x8(%eax),%edx
  802071:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802074:	8b 40 08             	mov    0x8(%eax),%eax
  802077:	39 c2                	cmp    %eax,%edx
  802079:	76 14                	jbe    80208f <insert_sorted_allocList+0x42>
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	8b 50 08             	mov    0x8(%eax),%edx
  802081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802084:	8b 40 08             	mov    0x8(%eax),%eax
  802087:	39 c2                	cmp    %eax,%edx
  802089:	0f 82 60 01 00 00    	jb     8021ef <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80208f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802093:	75 65                	jne    8020fa <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802095:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802099:	75 14                	jne    8020af <insert_sorted_allocList+0x62>
  80209b:	83 ec 04             	sub    $0x4,%esp
  80209e:	68 18 3f 80 00       	push   $0x803f18
  8020a3:	6a 6b                	push   $0x6b
  8020a5:	68 3b 3f 80 00       	push   $0x803f3b
  8020aa:	e8 77 e2 ff ff       	call   800326 <_panic>
  8020af:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b8:	89 10                	mov    %edx,(%eax)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 00                	mov    (%eax),%eax
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	74 0d                	je     8020d0 <insert_sorted_allocList+0x83>
  8020c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cb:	89 50 04             	mov    %edx,0x4(%eax)
  8020ce:	eb 08                	jmp    8020d8 <insert_sorted_allocList+0x8b>
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	a3 44 50 80 00       	mov    %eax,0x805044
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 40 50 80 00       	mov    %eax,0x805040
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ea:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ef:	40                   	inc    %eax
  8020f0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020f5:	e9 dc 01 00 00       	jmp    8022d6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	8b 50 08             	mov    0x8(%eax),%edx
  802100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802103:	8b 40 08             	mov    0x8(%eax),%eax
  802106:	39 c2                	cmp    %eax,%edx
  802108:	77 6c                	ja     802176 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80210a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210e:	74 06                	je     802116 <insert_sorted_allocList+0xc9>
  802110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802114:	75 14                	jne    80212a <insert_sorted_allocList+0xdd>
  802116:	83 ec 04             	sub    $0x4,%esp
  802119:	68 54 3f 80 00       	push   $0x803f54
  80211e:	6a 6f                	push   $0x6f
  802120:	68 3b 3f 80 00       	push   $0x803f3b
  802125:	e8 fc e1 ff ff       	call   800326 <_panic>
  80212a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212d:	8b 50 04             	mov    0x4(%eax),%edx
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	89 50 04             	mov    %edx,0x4(%eax)
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80213c:	89 10                	mov    %edx,(%eax)
  80213e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802141:	8b 40 04             	mov    0x4(%eax),%eax
  802144:	85 c0                	test   %eax,%eax
  802146:	74 0d                	je     802155 <insert_sorted_allocList+0x108>
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	8b 40 04             	mov    0x4(%eax),%eax
  80214e:	8b 55 08             	mov    0x8(%ebp),%edx
  802151:	89 10                	mov    %edx,(%eax)
  802153:	eb 08                	jmp    80215d <insert_sorted_allocList+0x110>
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	a3 40 50 80 00       	mov    %eax,0x805040
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	8b 55 08             	mov    0x8(%ebp),%edx
  802163:	89 50 04             	mov    %edx,0x4(%eax)
  802166:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80216b:	40                   	inc    %eax
  80216c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802171:	e9 60 01 00 00       	jmp    8022d6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	8b 50 08             	mov    0x8(%eax),%edx
  80217c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217f:	8b 40 08             	mov    0x8(%eax),%eax
  802182:	39 c2                	cmp    %eax,%edx
  802184:	0f 82 4c 01 00 00    	jb     8022d6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80218a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218e:	75 14                	jne    8021a4 <insert_sorted_allocList+0x157>
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	68 8c 3f 80 00       	push   $0x803f8c
  802198:	6a 73                	push   $0x73
  80219a:	68 3b 3f 80 00       	push   $0x803f3b
  80219f:	e8 82 e1 ff ff       	call   800326 <_panic>
  8021a4:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	89 50 04             	mov    %edx,0x4(%eax)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	8b 40 04             	mov    0x4(%eax),%eax
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	74 0c                	je     8021c6 <insert_sorted_allocList+0x179>
  8021ba:	a1 44 50 80 00       	mov    0x805044,%eax
  8021bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c2:	89 10                	mov    %edx,(%eax)
  8021c4:	eb 08                	jmp    8021ce <insert_sorted_allocList+0x181>
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	a3 40 50 80 00       	mov    %eax,0x805040
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021df:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e4:	40                   	inc    %eax
  8021e5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021ea:	e9 e7 00 00 00       	jmp    8022d6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021fc:	a1 40 50 80 00       	mov    0x805040,%eax
  802201:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802204:	e9 9d 00 00 00       	jmp    8022a6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	8b 00                	mov    (%eax),%eax
  80220e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	8b 50 08             	mov    0x8(%eax),%edx
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 40 08             	mov    0x8(%eax),%eax
  80221d:	39 c2                	cmp    %eax,%edx
  80221f:	76 7d                	jbe    80229e <insert_sorted_allocList+0x251>
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	8b 50 08             	mov    0x8(%eax),%edx
  802227:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222a:	8b 40 08             	mov    0x8(%eax),%eax
  80222d:	39 c2                	cmp    %eax,%edx
  80222f:	73 6d                	jae    80229e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802235:	74 06                	je     80223d <insert_sorted_allocList+0x1f0>
  802237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223b:	75 14                	jne    802251 <insert_sorted_allocList+0x204>
  80223d:	83 ec 04             	sub    $0x4,%esp
  802240:	68 b0 3f 80 00       	push   $0x803fb0
  802245:	6a 7f                	push   $0x7f
  802247:	68 3b 3f 80 00       	push   $0x803f3b
  80224c:	e8 d5 e0 ff ff       	call   800326 <_panic>
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 10                	mov    (%eax),%edx
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	89 10                	mov    %edx,(%eax)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	74 0b                	je     80226f <insert_sorted_allocList+0x222>
  802264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802267:	8b 00                	mov    (%eax),%eax
  802269:	8b 55 08             	mov    0x8(%ebp),%edx
  80226c:	89 50 04             	mov    %edx,0x4(%eax)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	89 10                	mov    %edx,(%eax)
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	75 08                	jne    802291 <insert_sorted_allocList+0x244>
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 44 50 80 00       	mov    %eax,0x805044
  802291:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802296:	40                   	inc    %eax
  802297:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80229c:	eb 39                	jmp    8022d7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80229e:	a1 48 50 80 00       	mov    0x805048,%eax
  8022a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022aa:	74 07                	je     8022b3 <insert_sorted_allocList+0x266>
  8022ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	eb 05                	jmp    8022b8 <insert_sorted_allocList+0x26b>
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	a3 48 50 80 00       	mov    %eax,0x805048
  8022bd:	a1 48 50 80 00       	mov    0x805048,%eax
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	0f 85 3f ff ff ff    	jne    802209 <insert_sorted_allocList+0x1bc>
  8022ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ce:	0f 85 35 ff ff ff    	jne    802209 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022d4:	eb 01                	jmp    8022d7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022d6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022d7:	90                   	nop
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e8:	e9 85 01 00 00       	jmp    802472 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f6:	0f 82 6e 01 00 00    	jb     80246a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802302:	3b 45 08             	cmp    0x8(%ebp),%eax
  802305:	0f 85 8a 00 00 00    	jne    802395 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80230b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230f:	75 17                	jne    802328 <alloc_block_FF+0x4e>
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 e4 3f 80 00       	push   $0x803fe4
  802319:	68 93 00 00 00       	push   $0x93
  80231e:	68 3b 3f 80 00       	push   $0x803f3b
  802323:	e8 fe df ff ff       	call   800326 <_panic>
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	74 10                	je     802341 <alloc_block_FF+0x67>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802339:	8b 52 04             	mov    0x4(%edx),%edx
  80233c:	89 50 04             	mov    %edx,0x4(%eax)
  80233f:	eb 0b                	jmp    80234c <alloc_block_FF+0x72>
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 40 04             	mov    0x4(%eax),%eax
  802347:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 04             	mov    0x4(%eax),%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	74 0f                	je     802365 <alloc_block_FF+0x8b>
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 40 04             	mov    0x4(%eax),%eax
  80235c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235f:	8b 12                	mov    (%edx),%edx
  802361:	89 10                	mov    %edx,(%eax)
  802363:	eb 0a                	jmp    80236f <alloc_block_FF+0x95>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	a3 38 51 80 00       	mov    %eax,0x805138
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802382:	a1 44 51 80 00       	mov    0x805144,%eax
  802387:	48                   	dec    %eax
  802388:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	e9 10 01 00 00       	jmp    8024a5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 40 0c             	mov    0xc(%eax),%eax
  80239b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239e:	0f 86 c6 00 00 00    	jbe    80246a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023a4:	a1 48 51 80 00       	mov    0x805148,%eax
  8023a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 50 08             	mov    0x8(%eax),%edx
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023be:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c5:	75 17                	jne    8023de <alloc_block_FF+0x104>
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	68 e4 3f 80 00       	push   $0x803fe4
  8023cf:	68 9b 00 00 00       	push   $0x9b
  8023d4:	68 3b 3f 80 00       	push   $0x803f3b
  8023d9:	e8 48 df ff ff       	call   800326 <_panic>
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	8b 00                	mov    (%eax),%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	74 10                	je     8023f7 <alloc_block_FF+0x11d>
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 00                	mov    (%eax),%eax
  8023ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ef:	8b 52 04             	mov    0x4(%edx),%edx
  8023f2:	89 50 04             	mov    %edx,0x4(%eax)
  8023f5:	eb 0b                	jmp    802402 <alloc_block_FF+0x128>
  8023f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fa:	8b 40 04             	mov    0x4(%eax),%eax
  8023fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802405:	8b 40 04             	mov    0x4(%eax),%eax
  802408:	85 c0                	test   %eax,%eax
  80240a:	74 0f                	je     80241b <alloc_block_FF+0x141>
  80240c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240f:	8b 40 04             	mov    0x4(%eax),%eax
  802412:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802415:	8b 12                	mov    (%edx),%edx
  802417:	89 10                	mov    %edx,(%eax)
  802419:	eb 0a                	jmp    802425 <alloc_block_FF+0x14b>
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 00                	mov    (%eax),%eax
  802420:	a3 48 51 80 00       	mov    %eax,0x805148
  802425:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802428:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802438:	a1 54 51 80 00       	mov    0x805154,%eax
  80243d:	48                   	dec    %eax
  80243e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 50 08             	mov    0x8(%eax),%edx
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	01 c2                	add    %eax,%edx
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 0c             	mov    0xc(%eax),%eax
  80245a:	2b 45 08             	sub    0x8(%ebp),%eax
  80245d:	89 c2                	mov    %eax,%edx
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	eb 3b                	jmp    8024a5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80246a:	a1 40 51 80 00       	mov    0x805140,%eax
  80246f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802476:	74 07                	je     80247f <alloc_block_FF+0x1a5>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	eb 05                	jmp    802484 <alloc_block_FF+0x1aa>
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	a3 40 51 80 00       	mov    %eax,0x805140
  802489:	a1 40 51 80 00       	mov    0x805140,%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 85 57 fe ff ff    	jne    8022ed <alloc_block_FF+0x13>
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	0f 85 4d fe ff ff    	jne    8022ed <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024ad:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8024b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024bc:	e9 df 00 00 00       	jmp    8025a0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ca:	0f 82 c8 00 00 00    	jb     802598 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d9:	0f 85 8a 00 00 00    	jne    802569 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e3:	75 17                	jne    8024fc <alloc_block_BF+0x55>
  8024e5:	83 ec 04             	sub    $0x4,%esp
  8024e8:	68 e4 3f 80 00       	push   $0x803fe4
  8024ed:	68 b7 00 00 00       	push   $0xb7
  8024f2:	68 3b 3f 80 00       	push   $0x803f3b
  8024f7:	e8 2a de ff ff       	call   800326 <_panic>
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 00                	mov    (%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 10                	je     802515 <alloc_block_BF+0x6e>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250d:	8b 52 04             	mov    0x4(%edx),%edx
  802510:	89 50 04             	mov    %edx,0x4(%eax)
  802513:	eb 0b                	jmp    802520 <alloc_block_BF+0x79>
  802515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802518:	8b 40 04             	mov    0x4(%eax),%eax
  80251b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 04             	mov    0x4(%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 0f                	je     802539 <alloc_block_BF+0x92>
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 04             	mov    0x4(%eax),%eax
  802530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802533:	8b 12                	mov    (%edx),%edx
  802535:	89 10                	mov    %edx,(%eax)
  802537:	eb 0a                	jmp    802543 <alloc_block_BF+0x9c>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 00                	mov    (%eax),%eax
  80253e:	a3 38 51 80 00       	mov    %eax,0x805138
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802556:	a1 44 51 80 00       	mov    0x805144,%eax
  80255b:	48                   	dec    %eax
  80255c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	e9 4d 01 00 00       	jmp    8026b6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 0c             	mov    0xc(%eax),%eax
  80256f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802572:	76 24                	jbe    802598 <alloc_block_BF+0xf1>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 40 0c             	mov    0xc(%eax),%eax
  80257a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80257d:	73 19                	jae    802598 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80257f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 40 0c             	mov    0xc(%eax),%eax
  80258c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 08             	mov    0x8(%eax),%eax
  802595:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802598:	a1 40 51 80 00       	mov    0x805140,%eax
  80259d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a4:	74 07                	je     8025ad <alloc_block_BF+0x106>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	eb 05                	jmp    8025b2 <alloc_block_BF+0x10b>
  8025ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b2:	a3 40 51 80 00       	mov    %eax,0x805140
  8025b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	0f 85 fd fe ff ff    	jne    8024c1 <alloc_block_BF+0x1a>
  8025c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c8:	0f 85 f3 fe ff ff    	jne    8024c1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025d2:	0f 84 d9 00 00 00    	je     8026b1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8025dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e6:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ef:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025f6:	75 17                	jne    80260f <alloc_block_BF+0x168>
  8025f8:	83 ec 04             	sub    $0x4,%esp
  8025fb:	68 e4 3f 80 00       	push   $0x803fe4
  802600:	68 c7 00 00 00       	push   $0xc7
  802605:	68 3b 3f 80 00       	push   $0x803f3b
  80260a:	e8 17 dd ff ff       	call   800326 <_panic>
  80260f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	74 10                	je     802628 <alloc_block_BF+0x181>
  802618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802620:	8b 52 04             	mov    0x4(%edx),%edx
  802623:	89 50 04             	mov    %edx,0x4(%eax)
  802626:	eb 0b                	jmp    802633 <alloc_block_BF+0x18c>
  802628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802636:	8b 40 04             	mov    0x4(%eax),%eax
  802639:	85 c0                	test   %eax,%eax
  80263b:	74 0f                	je     80264c <alloc_block_BF+0x1a5>
  80263d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802646:	8b 12                	mov    (%edx),%edx
  802648:	89 10                	mov    %edx,(%eax)
  80264a:	eb 0a                	jmp    802656 <alloc_block_BF+0x1af>
  80264c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	a3 48 51 80 00       	mov    %eax,0x805148
  802656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802662:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802669:	a1 54 51 80 00       	mov    0x805154,%eax
  80266e:	48                   	dec    %eax
  80266f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802674:	83 ec 08             	sub    $0x8,%esp
  802677:	ff 75 ec             	pushl  -0x14(%ebp)
  80267a:	68 38 51 80 00       	push   $0x805138
  80267f:	e8 71 f9 ff ff       	call   801ff5 <find_block>
  802684:	83 c4 10             	add    $0x10,%esp
  802687:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80268a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268d:	8b 50 08             	mov    0x8(%eax),%edx
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	01 c2                	add    %eax,%edx
  802695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802698:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80269b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a4:	89 c2                	mov    %eax,%edx
  8026a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026af:	eb 05                	jmp    8026b6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b6:	c9                   	leave  
  8026b7:	c3                   	ret    

008026b8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026be:	a1 28 50 80 00       	mov    0x805028,%eax
  8026c3:	85 c0                	test   %eax,%eax
  8026c5:	0f 85 de 01 00 00    	jne    8028a9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026cb:	a1 38 51 80 00       	mov    0x805138,%eax
  8026d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d3:	e9 9e 01 00 00       	jmp    802876 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 40 0c             	mov    0xc(%eax),%eax
  8026de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e1:	0f 82 87 01 00 00    	jb     80286e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f0:	0f 85 95 00 00 00    	jne    80278b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	75 17                	jne    802713 <alloc_block_NF+0x5b>
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	68 e4 3f 80 00       	push   $0x803fe4
  802704:	68 e0 00 00 00       	push   $0xe0
  802709:	68 3b 3f 80 00       	push   $0x803f3b
  80270e:	e8 13 dc ff ff       	call   800326 <_panic>
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 00                	mov    (%eax),%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	74 10                	je     80272c <alloc_block_NF+0x74>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 00                	mov    (%eax),%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	8b 52 04             	mov    0x4(%edx),%edx
  802727:	89 50 04             	mov    %edx,0x4(%eax)
  80272a:	eb 0b                	jmp    802737 <alloc_block_NF+0x7f>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 04             	mov    0x4(%eax),%eax
  802732:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	74 0f                	je     802750 <alloc_block_NF+0x98>
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 04             	mov    0x4(%eax),%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	8b 12                	mov    (%edx),%edx
  80274c:	89 10                	mov    %edx,(%eax)
  80274e:	eb 0a                	jmp    80275a <alloc_block_NF+0xa2>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 00                	mov    (%eax),%eax
  802755:	a3 38 51 80 00       	mov    %eax,0x805138
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276d:	a1 44 51 80 00       	mov    0x805144,%eax
  802772:	48                   	dec    %eax
  802773:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 08             	mov    0x8(%eax),%eax
  80277e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	e9 f8 04 00 00       	jmp    802c83 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	3b 45 08             	cmp    0x8(%ebp),%eax
  802794:	0f 86 d4 00 00 00    	jbe    80286e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80279a:	a1 48 51 80 00       	mov    0x805148,%eax
  80279f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 50 08             	mov    0x8(%eax),%edx
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bb:	75 17                	jne    8027d4 <alloc_block_NF+0x11c>
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 e4 3f 80 00       	push   $0x803fe4
  8027c5:	68 e9 00 00 00       	push   $0xe9
  8027ca:	68 3b 3f 80 00       	push   $0x803f3b
  8027cf:	e8 52 db ff ff       	call   800326 <_panic>
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 10                	je     8027ed <alloc_block_NF+0x135>
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e5:	8b 52 04             	mov    0x4(%edx),%edx
  8027e8:	89 50 04             	mov    %edx,0x4(%eax)
  8027eb:	eb 0b                	jmp    8027f8 <alloc_block_NF+0x140>
  8027ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 0f                	je     802811 <alloc_block_NF+0x159>
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280b:	8b 12                	mov    (%edx),%edx
  80280d:	89 10                	mov    %edx,(%eax)
  80280f:	eb 0a                	jmp    80281b <alloc_block_NF+0x163>
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	a3 48 51 80 00       	mov    %eax,0x805148
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282e:	a1 54 51 80 00       	mov    0x805154,%eax
  802833:	48                   	dec    %eax
  802834:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 40 08             	mov    0x8(%eax),%eax
  80283f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 50 08             	mov    0x8(%eax),%edx
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	01 c2                	add    %eax,%edx
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	8b 40 0c             	mov    0xc(%eax),%eax
  80285b:	2b 45 08             	sub    0x8(%ebp),%eax
  80285e:	89 c2                	mov    %eax,%edx
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802869:	e9 15 04 00 00       	jmp    802c83 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80286e:	a1 40 51 80 00       	mov    0x805140,%eax
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287a:	74 07                	je     802883 <alloc_block_NF+0x1cb>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	eb 05                	jmp    802888 <alloc_block_NF+0x1d0>
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	a3 40 51 80 00       	mov    %eax,0x805140
  80288d:	a1 40 51 80 00       	mov    0x805140,%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	0f 85 3e fe ff ff    	jne    8026d8 <alloc_block_NF+0x20>
  80289a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289e:	0f 85 34 fe ff ff    	jne    8026d8 <alloc_block_NF+0x20>
  8028a4:	e9 d5 03 00 00       	jmp    802c7e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8028ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b1:	e9 b1 01 00 00       	jmp    802a67 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 50 08             	mov    0x8(%eax),%edx
  8028bc:	a1 28 50 80 00       	mov    0x805028,%eax
  8028c1:	39 c2                	cmp    %eax,%edx
  8028c3:	0f 82 96 01 00 00    	jb     802a5f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d2:	0f 82 87 01 00 00    	jb     802a5f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 0c             	mov    0xc(%eax),%eax
  8028de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e1:	0f 85 95 00 00 00    	jne    80297c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028eb:	75 17                	jne    802904 <alloc_block_NF+0x24c>
  8028ed:	83 ec 04             	sub    $0x4,%esp
  8028f0:	68 e4 3f 80 00       	push   $0x803fe4
  8028f5:	68 fc 00 00 00       	push   $0xfc
  8028fa:	68 3b 3f 80 00       	push   $0x803f3b
  8028ff:	e8 22 da ff ff       	call   800326 <_panic>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 10                	je     80291d <alloc_block_NF+0x265>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802915:	8b 52 04             	mov    0x4(%edx),%edx
  802918:	89 50 04             	mov    %edx,0x4(%eax)
  80291b:	eb 0b                	jmp    802928 <alloc_block_NF+0x270>
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	85 c0                	test   %eax,%eax
  802930:	74 0f                	je     802941 <alloc_block_NF+0x289>
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 04             	mov    0x4(%eax),%eax
  802938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293b:	8b 12                	mov    (%edx),%edx
  80293d:	89 10                	mov    %edx,(%eax)
  80293f:	eb 0a                	jmp    80294b <alloc_block_NF+0x293>
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	a3 38 51 80 00       	mov    %eax,0x805138
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295e:	a1 44 51 80 00       	mov    0x805144,%eax
  802963:	48                   	dec    %eax
  802964:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 08             	mov    0x8(%eax),%eax
  80296f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	e9 07 03 00 00       	jmp    802c83 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 40 0c             	mov    0xc(%eax),%eax
  802982:	3b 45 08             	cmp    0x8(%ebp),%eax
  802985:	0f 86 d4 00 00 00    	jbe    802a5f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80298b:	a1 48 51 80 00       	mov    0x805148,%eax
  802990:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 50 08             	mov    0x8(%eax),%edx
  802999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80299f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ac:	75 17                	jne    8029c5 <alloc_block_NF+0x30d>
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	68 e4 3f 80 00       	push   $0x803fe4
  8029b6:	68 04 01 00 00       	push   $0x104
  8029bb:	68 3b 3f 80 00       	push   $0x803f3b
  8029c0:	e8 61 d9 ff ff       	call   800326 <_panic>
  8029c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 10                	je     8029de <alloc_block_NF+0x326>
  8029ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d6:	8b 52 04             	mov    0x4(%edx),%edx
  8029d9:	89 50 04             	mov    %edx,0x4(%eax)
  8029dc:	eb 0b                	jmp    8029e9 <alloc_block_NF+0x331>
  8029de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e1:	8b 40 04             	mov    0x4(%eax),%eax
  8029e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 0f                	je     802a02 <alloc_block_NF+0x34a>
  8029f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029fc:	8b 12                	mov    (%edx),%edx
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	eb 0a                	jmp    802a0c <alloc_block_NF+0x354>
  802a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	a3 48 51 80 00       	mov    %eax,0x805148
  802a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1f:	a1 54 51 80 00       	mov    0x805154,%eax
  802a24:	48                   	dec    %eax
  802a25:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	8b 40 08             	mov    0x8(%eax),%eax
  802a30:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 50 08             	mov    0x8(%eax),%edx
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	01 c2                	add    %eax,%edx
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4f:	89 c2                	mov    %eax,%edx
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5a:	e9 24 02 00 00       	jmp    802c83 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6b:	74 07                	je     802a74 <alloc_block_NF+0x3bc>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	eb 05                	jmp    802a79 <alloc_block_NF+0x3c1>
  802a74:	b8 00 00 00 00       	mov    $0x0,%eax
  802a79:	a3 40 51 80 00       	mov    %eax,0x805140
  802a7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	0f 85 2b fe ff ff    	jne    8028b6 <alloc_block_NF+0x1fe>
  802a8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8f:	0f 85 21 fe ff ff    	jne    8028b6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a95:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9d:	e9 ae 01 00 00       	jmp    802c50 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	a1 28 50 80 00       	mov    0x805028,%eax
  802aad:	39 c2                	cmp    %eax,%edx
  802aaf:	0f 83 93 01 00 00    	jae    802c48 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  802abb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abe:	0f 82 84 01 00 00    	jb     802c48 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802acd:	0f 85 95 00 00 00    	jne    802b68 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	75 17                	jne    802af0 <alloc_block_NF+0x438>
  802ad9:	83 ec 04             	sub    $0x4,%esp
  802adc:	68 e4 3f 80 00       	push   $0x803fe4
  802ae1:	68 14 01 00 00       	push   $0x114
  802ae6:	68 3b 3f 80 00       	push   $0x803f3b
  802aeb:	e8 36 d8 ff ff       	call   800326 <_panic>
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 00                	mov    (%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 10                	je     802b09 <alloc_block_NF+0x451>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 00                	mov    (%eax),%eax
  802afe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b01:	8b 52 04             	mov    0x4(%edx),%edx
  802b04:	89 50 04             	mov    %edx,0x4(%eax)
  802b07:	eb 0b                	jmp    802b14 <alloc_block_NF+0x45c>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	85 c0                	test   %eax,%eax
  802b1c:	74 0f                	je     802b2d <alloc_block_NF+0x475>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b27:	8b 12                	mov    (%edx),%edx
  802b29:	89 10                	mov    %edx,(%eax)
  802b2b:	eb 0a                	jmp    802b37 <alloc_block_NF+0x47f>
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	a3 38 51 80 00       	mov    %eax,0x805138
  802b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b4f:	48                   	dec    %eax
  802b50:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 08             	mov    0x8(%eax),%eax
  802b5b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	e9 1b 01 00 00       	jmp    802c83 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b71:	0f 86 d1 00 00 00    	jbe    802c48 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b77:	a1 48 51 80 00       	mov    0x805148,%eax
  802b7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 50 08             	mov    0x8(%eax),%edx
  802b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b88:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b91:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b94:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b98:	75 17                	jne    802bb1 <alloc_block_NF+0x4f9>
  802b9a:	83 ec 04             	sub    $0x4,%esp
  802b9d:	68 e4 3f 80 00       	push   $0x803fe4
  802ba2:	68 1c 01 00 00       	push   $0x11c
  802ba7:	68 3b 3f 80 00       	push   $0x803f3b
  802bac:	e8 75 d7 ff ff       	call   800326 <_panic>
  802bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 10                	je     802bca <alloc_block_NF+0x512>
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc2:	8b 52 04             	mov    0x4(%edx),%edx
  802bc5:	89 50 04             	mov    %edx,0x4(%eax)
  802bc8:	eb 0b                	jmp    802bd5 <alloc_block_NF+0x51d>
  802bca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcd:	8b 40 04             	mov    0x4(%eax),%eax
  802bd0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0f                	je     802bee <alloc_block_NF+0x536>
  802bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be2:	8b 40 04             	mov    0x4(%eax),%eax
  802be5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802be8:	8b 12                	mov    (%edx),%edx
  802bea:	89 10                	mov    %edx,(%eax)
  802bec:	eb 0a                	jmp    802bf8 <alloc_block_NF+0x540>
  802bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	a3 48 51 80 00       	mov    %eax,0x805148
  802bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c10:	48                   	dec    %eax
  802c11:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 40 08             	mov    0x8(%eax),%eax
  802c1c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	01 c2                	add    %eax,%edx
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 40 0c             	mov    0xc(%eax),%eax
  802c38:	2b 45 08             	sub    0x8(%ebp),%eax
  802c3b:	89 c2                	mov    %eax,%edx
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c46:	eb 3b                	jmp    802c83 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c48:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c54:	74 07                	je     802c5d <alloc_block_NF+0x5a5>
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	eb 05                	jmp    802c62 <alloc_block_NF+0x5aa>
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c62:	a3 40 51 80 00       	mov    %eax,0x805140
  802c67:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	0f 85 2e fe ff ff    	jne    802aa2 <alloc_block_NF+0x3ea>
  802c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c78:	0f 85 24 fe ff ff    	jne    802aa2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c83:	c9                   	leave  
  802c84:	c3                   	ret    

00802c85 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c85:	55                   	push   %ebp
  802c86:	89 e5                	mov    %esp,%ebp
  802c88:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c90:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c93:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c98:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 14                	je     802cb8 <insert_sorted_with_merge_freeList+0x33>
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	0f 87 9b 01 00 00    	ja     802e53 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbc:	75 17                	jne    802cd5 <insert_sorted_with_merge_freeList+0x50>
  802cbe:	83 ec 04             	sub    $0x4,%esp
  802cc1:	68 18 3f 80 00       	push   $0x803f18
  802cc6:	68 38 01 00 00       	push   $0x138
  802ccb:	68 3b 3f 80 00       	push   $0x803f3b
  802cd0:	e8 51 d6 ff ff       	call   800326 <_panic>
  802cd5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	89 10                	mov    %edx,(%eax)
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	74 0d                	je     802cf6 <insert_sorted_with_merge_freeList+0x71>
  802ce9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cee:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf1:	89 50 04             	mov    %edx,0x4(%eax)
  802cf4:	eb 08                	jmp    802cfe <insert_sorted_with_merge_freeList+0x79>
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	a3 38 51 80 00       	mov    %eax,0x805138
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d10:	a1 44 51 80 00       	mov    0x805144,%eax
  802d15:	40                   	inc    %eax
  802d16:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1f:	0f 84 a8 06 00 00    	je     8033cd <insert_sorted_with_merge_freeList+0x748>
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	8b 50 08             	mov    0x8(%eax),%edx
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	01 c2                	add    %eax,%edx
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 40 08             	mov    0x8(%eax),%eax
  802d39:	39 c2                	cmp    %eax,%edx
  802d3b:	0f 85 8c 06 00 00    	jne    8033cd <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	8b 50 0c             	mov    0xc(%eax),%edx
  802d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4d:	01 c2                	add    %eax,%edx
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d59:	75 17                	jne    802d72 <insert_sorted_with_merge_freeList+0xed>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 e4 3f 80 00       	push   $0x803fe4
  802d63:	68 3c 01 00 00       	push   $0x13c
  802d68:	68 3b 3f 80 00       	push   $0x803f3b
  802d6d:	e8 b4 d5 ff ff       	call   800326 <_panic>
  802d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	74 10                	je     802d8b <insert_sorted_with_merge_freeList+0x106>
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d83:	8b 52 04             	mov    0x4(%edx),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	eb 0b                	jmp    802d96 <insert_sorted_with_merge_freeList+0x111>
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 0f                	je     802daf <insert_sorted_with_merge_freeList+0x12a>
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da9:	8b 12                	mov    (%edx),%edx
  802dab:	89 10                	mov    %edx,(%eax)
  802dad:	eb 0a                	jmp    802db9 <insert_sorted_with_merge_freeList+0x134>
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	a3 38 51 80 00       	mov    %eax,0x805138
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcc:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd1:	48                   	dec    %eax
  802dd2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802deb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802def:	75 17                	jne    802e08 <insert_sorted_with_merge_freeList+0x183>
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 18 3f 80 00       	push   $0x803f18
  802df9:	68 3f 01 00 00       	push   $0x13f
  802dfe:	68 3b 3f 80 00       	push   $0x803f3b
  802e03:	e8 1e d5 ff ff       	call   800326 <_panic>
  802e08:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	89 10                	mov    %edx,(%eax)
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0d                	je     802e29 <insert_sorted_with_merge_freeList+0x1a4>
  802e1c:	a1 48 51 80 00       	mov    0x805148,%eax
  802e21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e24:	89 50 04             	mov    %edx,0x4(%eax)
  802e27:	eb 08                	jmp    802e31 <insert_sorted_with_merge_freeList+0x1ac>
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	a3 48 51 80 00       	mov    %eax,0x805148
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e43:	a1 54 51 80 00       	mov    0x805154,%eax
  802e48:	40                   	inc    %eax
  802e49:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e4e:	e9 7a 05 00 00       	jmp    8033cd <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 50 08             	mov    0x8(%eax),%edx
  802e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5c:	8b 40 08             	mov    0x8(%eax),%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	0f 82 14 01 00 00    	jb     802f7b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6a:	8b 50 08             	mov    0x8(%eax),%edx
  802e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	01 c2                	add    %eax,%edx
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
  802e7b:	39 c2                	cmp    %eax,%edx
  802e7d:	0f 85 90 00 00 00    	jne    802f13 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e86:	8b 50 0c             	mov    0xc(%eax),%edx
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8f:	01 c2                	add    %eax,%edx
  802e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e94:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eaf:	75 17                	jne    802ec8 <insert_sorted_with_merge_freeList+0x243>
  802eb1:	83 ec 04             	sub    $0x4,%esp
  802eb4:	68 18 3f 80 00       	push   $0x803f18
  802eb9:	68 49 01 00 00       	push   $0x149
  802ebe:	68 3b 3f 80 00       	push   $0x803f3b
  802ec3:	e8 5e d4 ff ff       	call   800326 <_panic>
  802ec8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	89 10                	mov    %edx,(%eax)
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	74 0d                	je     802ee9 <insert_sorted_with_merge_freeList+0x264>
  802edc:	a1 48 51 80 00       	mov    0x805148,%eax
  802ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee4:	89 50 04             	mov    %edx,0x4(%eax)
  802ee7:	eb 08                	jmp    802ef1 <insert_sorted_with_merge_freeList+0x26c>
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f03:	a1 54 51 80 00       	mov    0x805154,%eax
  802f08:	40                   	inc    %eax
  802f09:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f0e:	e9 bb 04 00 00       	jmp    8033ce <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f17:	75 17                	jne    802f30 <insert_sorted_with_merge_freeList+0x2ab>
  802f19:	83 ec 04             	sub    $0x4,%esp
  802f1c:	68 8c 3f 80 00       	push   $0x803f8c
  802f21:	68 4c 01 00 00       	push   $0x14c
  802f26:	68 3b 3f 80 00       	push   $0x803f3b
  802f2b:	e8 f6 d3 ff ff       	call   800326 <_panic>
  802f30:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0c                	je     802f52 <insert_sorted_with_merge_freeList+0x2cd>
  802f46:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	eb 08                	jmp    802f5a <insert_sorted_with_merge_freeList+0x2d5>
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	a3 38 51 80 00       	mov    %eax,0x805138
  802f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f6b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f70:	40                   	inc    %eax
  802f71:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f76:	e9 53 04 00 00       	jmp    8033ce <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f83:	e9 15 04 00 00       	jmp    80339d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 50 08             	mov    0x8(%eax),%edx
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 40 08             	mov    0x8(%eax),%eax
  802f9c:	39 c2                	cmp    %eax,%edx
  802f9e:	0f 86 f1 03 00 00    	jbe    803395 <insert_sorted_with_merge_freeList+0x710>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	8b 50 08             	mov    0x8(%eax),%edx
  802faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fad:	8b 40 08             	mov    0x8(%eax),%eax
  802fb0:	39 c2                	cmp    %eax,%edx
  802fb2:	0f 83 dd 03 00 00    	jae    803395 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 50 08             	mov    0x8(%eax),%edx
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc4:	01 c2                	add    %eax,%edx
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	8b 40 08             	mov    0x8(%eax),%eax
  802fcc:	39 c2                	cmp    %eax,%edx
  802fce:	0f 85 b9 01 00 00    	jne    80318d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe0:	01 c2                	add    %eax,%edx
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	8b 40 08             	mov    0x8(%eax),%eax
  802fe8:	39 c2                	cmp    %eax,%edx
  802fea:	0f 85 0d 01 00 00    	jne    8030fd <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffc:	01 c2                	add    %eax,%edx
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803004:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803008:	75 17                	jne    803021 <insert_sorted_with_merge_freeList+0x39c>
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 e4 3f 80 00       	push   $0x803fe4
  803012:	68 5c 01 00 00       	push   $0x15c
  803017:	68 3b 3f 80 00       	push   $0x803f3b
  80301c:	e8 05 d3 ff ff       	call   800326 <_panic>
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	74 10                	je     80303a <insert_sorted_with_merge_freeList+0x3b5>
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803032:	8b 52 04             	mov    0x4(%edx),%edx
  803035:	89 50 04             	mov    %edx,0x4(%eax)
  803038:	eb 0b                	jmp    803045 <insert_sorted_with_merge_freeList+0x3c0>
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	74 0f                	je     80305e <insert_sorted_with_merge_freeList+0x3d9>
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	8b 40 04             	mov    0x4(%eax),%eax
  803055:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803058:	8b 12                	mov    (%edx),%edx
  80305a:	89 10                	mov    %edx,(%eax)
  80305c:	eb 0a                	jmp    803068 <insert_sorted_with_merge_freeList+0x3e3>
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	a3 38 51 80 00       	mov    %eax,0x805138
  803068:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307b:	a1 44 51 80 00       	mov    0x805144,%eax
  803080:	48                   	dec    %eax
  803081:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80309a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80309e:	75 17                	jne    8030b7 <insert_sorted_with_merge_freeList+0x432>
  8030a0:	83 ec 04             	sub    $0x4,%esp
  8030a3:	68 18 3f 80 00       	push   $0x803f18
  8030a8:	68 5f 01 00 00       	push   $0x15f
  8030ad:	68 3b 3f 80 00       	push   $0x803f3b
  8030b2:	e8 6f d2 ff ff       	call   800326 <_panic>
  8030b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c0:	89 10                	mov    %edx,(%eax)
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	8b 00                	mov    (%eax),%eax
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	74 0d                	je     8030d8 <insert_sorted_with_merge_freeList+0x453>
  8030cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d3:	89 50 04             	mov    %edx,0x4(%eax)
  8030d6:	eb 08                	jmp    8030e0 <insert_sorted_with_merge_freeList+0x45b>
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8030f7:	40                   	inc    %eax
  8030f8:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 50 0c             	mov    0xc(%eax),%edx
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	8b 40 0c             	mov    0xc(%eax),%eax
  803109:	01 c2                	add    %eax,%edx
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803129:	75 17                	jne    803142 <insert_sorted_with_merge_freeList+0x4bd>
  80312b:	83 ec 04             	sub    $0x4,%esp
  80312e:	68 18 3f 80 00       	push   $0x803f18
  803133:	68 64 01 00 00       	push   $0x164
  803138:	68 3b 3f 80 00       	push   $0x803f3b
  80313d:	e8 e4 d1 ff ff       	call   800326 <_panic>
  803142:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	89 10                	mov    %edx,(%eax)
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 00                	mov    (%eax),%eax
  803152:	85 c0                	test   %eax,%eax
  803154:	74 0d                	je     803163 <insert_sorted_with_merge_freeList+0x4de>
  803156:	a1 48 51 80 00       	mov    0x805148,%eax
  80315b:	8b 55 08             	mov    0x8(%ebp),%edx
  80315e:	89 50 04             	mov    %edx,0x4(%eax)
  803161:	eb 08                	jmp    80316b <insert_sorted_with_merge_freeList+0x4e6>
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	a3 48 51 80 00       	mov    %eax,0x805148
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317d:	a1 54 51 80 00       	mov    0x805154,%eax
  803182:	40                   	inc    %eax
  803183:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803188:	e9 41 02 00 00       	jmp    8033ce <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	8b 50 08             	mov    0x8(%eax),%edx
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	8b 40 0c             	mov    0xc(%eax),%eax
  803199:	01 c2                	add    %eax,%edx
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	8b 40 08             	mov    0x8(%eax),%eax
  8031a1:	39 c2                	cmp    %eax,%edx
  8031a3:	0f 85 7c 01 00 00    	jne    803325 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ad:	74 06                	je     8031b5 <insert_sorted_with_merge_freeList+0x530>
  8031af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b3:	75 17                	jne    8031cc <insert_sorted_with_merge_freeList+0x547>
  8031b5:	83 ec 04             	sub    $0x4,%esp
  8031b8:	68 54 3f 80 00       	push   $0x803f54
  8031bd:	68 69 01 00 00       	push   $0x169
  8031c2:	68 3b 3f 80 00       	push   $0x803f3b
  8031c7:	e8 5a d1 ff ff       	call   800326 <_panic>
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	8b 50 04             	mov    0x4(%eax),%edx
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031de:	89 10                	mov    %edx,(%eax)
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	8b 40 04             	mov    0x4(%eax),%eax
  8031e6:	85 c0                	test   %eax,%eax
  8031e8:	74 0d                	je     8031f7 <insert_sorted_with_merge_freeList+0x572>
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	eb 08                	jmp    8031ff <insert_sorted_with_merge_freeList+0x57a>
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 55 08             	mov    0x8(%ebp),%edx
  803205:	89 50 04             	mov    %edx,0x4(%eax)
  803208:	a1 44 51 80 00       	mov    0x805144,%eax
  80320d:	40                   	inc    %eax
  80320e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	8b 50 0c             	mov    0xc(%eax),%edx
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	8b 40 0c             	mov    0xc(%eax),%eax
  80321f:	01 c2                	add    %eax,%edx
  803221:	8b 45 08             	mov    0x8(%ebp),%eax
  803224:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803227:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322b:	75 17                	jne    803244 <insert_sorted_with_merge_freeList+0x5bf>
  80322d:	83 ec 04             	sub    $0x4,%esp
  803230:	68 e4 3f 80 00       	push   $0x803fe4
  803235:	68 6b 01 00 00       	push   $0x16b
  80323a:	68 3b 3f 80 00       	push   $0x803f3b
  80323f:	e8 e2 d0 ff ff       	call   800326 <_panic>
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	8b 00                	mov    (%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 10                	je     80325d <insert_sorted_with_merge_freeList+0x5d8>
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	8b 00                	mov    (%eax),%eax
  803252:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803255:	8b 52 04             	mov    0x4(%edx),%edx
  803258:	89 50 04             	mov    %edx,0x4(%eax)
  80325b:	eb 0b                	jmp    803268 <insert_sorted_with_merge_freeList+0x5e3>
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	8b 40 04             	mov    0x4(%eax),%eax
  803263:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	8b 40 04             	mov    0x4(%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0f                	je     803281 <insert_sorted_with_merge_freeList+0x5fc>
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	8b 40 04             	mov    0x4(%eax),%eax
  803278:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327b:	8b 12                	mov    (%edx),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	eb 0a                	jmp    80328b <insert_sorted_with_merge_freeList+0x606>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	a3 38 51 80 00       	mov    %eax,0x805138
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329e:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a3:	48                   	dec    %eax
  8032a4:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032c1:	75 17                	jne    8032da <insert_sorted_with_merge_freeList+0x655>
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	68 18 3f 80 00       	push   $0x803f18
  8032cb:	68 6e 01 00 00       	push   $0x16e
  8032d0:	68 3b 3f 80 00       	push   $0x803f3b
  8032d5:	e8 4c d0 ff ff       	call   800326 <_panic>
  8032da:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	89 10                	mov    %edx,(%eax)
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	85 c0                	test   %eax,%eax
  8032ec:	74 0d                	je     8032fb <insert_sorted_with_merge_freeList+0x676>
  8032ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8032f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	eb 08                	jmp    803303 <insert_sorted_with_merge_freeList+0x67e>
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803303:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803306:	a3 48 51 80 00       	mov    %eax,0x805148
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803315:	a1 54 51 80 00       	mov    0x805154,%eax
  80331a:	40                   	inc    %eax
  80331b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803320:	e9 a9 00 00 00       	jmp    8033ce <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803325:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803329:	74 06                	je     803331 <insert_sorted_with_merge_freeList+0x6ac>
  80332b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80332f:	75 17                	jne    803348 <insert_sorted_with_merge_freeList+0x6c3>
  803331:	83 ec 04             	sub    $0x4,%esp
  803334:	68 b0 3f 80 00       	push   $0x803fb0
  803339:	68 73 01 00 00       	push   $0x173
  80333e:	68 3b 3f 80 00       	push   $0x803f3b
  803343:	e8 de cf ff ff       	call   800326 <_panic>
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 10                	mov    (%eax),%edx
  80334d:	8b 45 08             	mov    0x8(%ebp),%eax
  803350:	89 10                	mov    %edx,(%eax)
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	74 0b                	je     803366 <insert_sorted_with_merge_freeList+0x6e1>
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 00                	mov    (%eax),%eax
  803360:	8b 55 08             	mov    0x8(%ebp),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803369:	8b 55 08             	mov    0x8(%ebp),%edx
  80336c:	89 10                	mov    %edx,(%eax)
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803374:	89 50 04             	mov    %edx,0x4(%eax)
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	8b 00                	mov    (%eax),%eax
  80337c:	85 c0                	test   %eax,%eax
  80337e:	75 08                	jne    803388 <insert_sorted_with_merge_freeList+0x703>
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803388:	a1 44 51 80 00       	mov    0x805144,%eax
  80338d:	40                   	inc    %eax
  80338e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803393:	eb 39                	jmp    8033ce <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803395:	a1 40 51 80 00       	mov    0x805140,%eax
  80339a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80339d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a1:	74 07                	je     8033aa <insert_sorted_with_merge_freeList+0x725>
  8033a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	eb 05                	jmp    8033af <insert_sorted_with_merge_freeList+0x72a>
  8033aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8033af:	a3 40 51 80 00       	mov    %eax,0x805140
  8033b4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	0f 85 c7 fb ff ff    	jne    802f88 <insert_sorted_with_merge_freeList+0x303>
  8033c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c5:	0f 85 bd fb ff ff    	jne    802f88 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033cb:	eb 01                	jmp    8033ce <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033cd:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ce:	90                   	nop
  8033cf:	c9                   	leave  
  8033d0:	c3                   	ret    

008033d1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 d0                	mov    %edx,%eax
  8033dc:	c1 e0 02             	shl    $0x2,%eax
  8033df:	01 d0                	add    %edx,%eax
  8033e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033e8:	01 d0                	add    %edx,%eax
  8033ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033f1:	01 d0                	add    %edx,%eax
  8033f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033fa:	01 d0                	add    %edx,%eax
  8033fc:	c1 e0 04             	shl    $0x4,%eax
  8033ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803409:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80340c:	83 ec 0c             	sub    $0xc,%esp
  80340f:	50                   	push   %eax
  803410:	e8 26 e7 ff ff       	call   801b3b <sys_get_virtual_time>
  803415:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803418:	eb 41                	jmp    80345b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80341a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80341d:	83 ec 0c             	sub    $0xc,%esp
  803420:	50                   	push   %eax
  803421:	e8 15 e7 ff ff       	call   801b3b <sys_get_virtual_time>
  803426:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803429:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	29 c2                	sub    %eax,%edx
  803431:	89 d0                	mov    %edx,%eax
  803433:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343c:	89 d1                	mov    %edx,%ecx
  80343e:	29 c1                	sub    %eax,%ecx
  803440:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803446:	39 c2                	cmp    %eax,%edx
  803448:	0f 97 c0             	seta   %al
  80344b:	0f b6 c0             	movzbl %al,%eax
  80344e:	29 c1                	sub    %eax,%ecx
  803450:	89 c8                	mov    %ecx,%eax
  803452:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803455:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803458:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80345b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803461:	72 b7                	jb     80341a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803463:	90                   	nop
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
  803469:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80346c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803473:	eb 03                	jmp    803478 <busy_wait+0x12>
  803475:	ff 45 fc             	incl   -0x4(%ebp)
  803478:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80347b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80347e:	72 f5                	jb     803475 <busy_wait+0xf>
	return i;
  803480:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803483:	c9                   	leave  
  803484:	c3                   	ret    
  803485:	66 90                	xchg   %ax,%ax
  803487:	90                   	nop

00803488 <__udivdi3>:
  803488:	55                   	push   %ebp
  803489:	57                   	push   %edi
  80348a:	56                   	push   %esi
  80348b:	53                   	push   %ebx
  80348c:	83 ec 1c             	sub    $0x1c,%esp
  80348f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803493:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803497:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80349b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80349f:	89 ca                	mov    %ecx,%edx
  8034a1:	89 f8                	mov    %edi,%eax
  8034a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034a7:	85 f6                	test   %esi,%esi
  8034a9:	75 2d                	jne    8034d8 <__udivdi3+0x50>
  8034ab:	39 cf                	cmp    %ecx,%edi
  8034ad:	77 65                	ja     803514 <__udivdi3+0x8c>
  8034af:	89 fd                	mov    %edi,%ebp
  8034b1:	85 ff                	test   %edi,%edi
  8034b3:	75 0b                	jne    8034c0 <__udivdi3+0x38>
  8034b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ba:	31 d2                	xor    %edx,%edx
  8034bc:	f7 f7                	div    %edi
  8034be:	89 c5                	mov    %eax,%ebp
  8034c0:	31 d2                	xor    %edx,%edx
  8034c2:	89 c8                	mov    %ecx,%eax
  8034c4:	f7 f5                	div    %ebp
  8034c6:	89 c1                	mov    %eax,%ecx
  8034c8:	89 d8                	mov    %ebx,%eax
  8034ca:	f7 f5                	div    %ebp
  8034cc:	89 cf                	mov    %ecx,%edi
  8034ce:	89 fa                	mov    %edi,%edx
  8034d0:	83 c4 1c             	add    $0x1c,%esp
  8034d3:	5b                   	pop    %ebx
  8034d4:	5e                   	pop    %esi
  8034d5:	5f                   	pop    %edi
  8034d6:	5d                   	pop    %ebp
  8034d7:	c3                   	ret    
  8034d8:	39 ce                	cmp    %ecx,%esi
  8034da:	77 28                	ja     803504 <__udivdi3+0x7c>
  8034dc:	0f bd fe             	bsr    %esi,%edi
  8034df:	83 f7 1f             	xor    $0x1f,%edi
  8034e2:	75 40                	jne    803524 <__udivdi3+0x9c>
  8034e4:	39 ce                	cmp    %ecx,%esi
  8034e6:	72 0a                	jb     8034f2 <__udivdi3+0x6a>
  8034e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034ec:	0f 87 9e 00 00 00    	ja     803590 <__udivdi3+0x108>
  8034f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f7:	89 fa                	mov    %edi,%edx
  8034f9:	83 c4 1c             	add    $0x1c,%esp
  8034fc:	5b                   	pop    %ebx
  8034fd:	5e                   	pop    %esi
  8034fe:	5f                   	pop    %edi
  8034ff:	5d                   	pop    %ebp
  803500:	c3                   	ret    
  803501:	8d 76 00             	lea    0x0(%esi),%esi
  803504:	31 ff                	xor    %edi,%edi
  803506:	31 c0                	xor    %eax,%eax
  803508:	89 fa                	mov    %edi,%edx
  80350a:	83 c4 1c             	add    $0x1c,%esp
  80350d:	5b                   	pop    %ebx
  80350e:	5e                   	pop    %esi
  80350f:	5f                   	pop    %edi
  803510:	5d                   	pop    %ebp
  803511:	c3                   	ret    
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 d8                	mov    %ebx,%eax
  803516:	f7 f7                	div    %edi
  803518:	31 ff                	xor    %edi,%edi
  80351a:	89 fa                	mov    %edi,%edx
  80351c:	83 c4 1c             	add    $0x1c,%esp
  80351f:	5b                   	pop    %ebx
  803520:	5e                   	pop    %esi
  803521:	5f                   	pop    %edi
  803522:	5d                   	pop    %ebp
  803523:	c3                   	ret    
  803524:	bd 20 00 00 00       	mov    $0x20,%ebp
  803529:	89 eb                	mov    %ebp,%ebx
  80352b:	29 fb                	sub    %edi,%ebx
  80352d:	89 f9                	mov    %edi,%ecx
  80352f:	d3 e6                	shl    %cl,%esi
  803531:	89 c5                	mov    %eax,%ebp
  803533:	88 d9                	mov    %bl,%cl
  803535:	d3 ed                	shr    %cl,%ebp
  803537:	89 e9                	mov    %ebp,%ecx
  803539:	09 f1                	or     %esi,%ecx
  80353b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80353f:	89 f9                	mov    %edi,%ecx
  803541:	d3 e0                	shl    %cl,%eax
  803543:	89 c5                	mov    %eax,%ebp
  803545:	89 d6                	mov    %edx,%esi
  803547:	88 d9                	mov    %bl,%cl
  803549:	d3 ee                	shr    %cl,%esi
  80354b:	89 f9                	mov    %edi,%ecx
  80354d:	d3 e2                	shl    %cl,%edx
  80354f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803553:	88 d9                	mov    %bl,%cl
  803555:	d3 e8                	shr    %cl,%eax
  803557:	09 c2                	or     %eax,%edx
  803559:	89 d0                	mov    %edx,%eax
  80355b:	89 f2                	mov    %esi,%edx
  80355d:	f7 74 24 0c          	divl   0xc(%esp)
  803561:	89 d6                	mov    %edx,%esi
  803563:	89 c3                	mov    %eax,%ebx
  803565:	f7 e5                	mul    %ebp
  803567:	39 d6                	cmp    %edx,%esi
  803569:	72 19                	jb     803584 <__udivdi3+0xfc>
  80356b:	74 0b                	je     803578 <__udivdi3+0xf0>
  80356d:	89 d8                	mov    %ebx,%eax
  80356f:	31 ff                	xor    %edi,%edi
  803571:	e9 58 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  803576:	66 90                	xchg   %ax,%ax
  803578:	8b 54 24 08          	mov    0x8(%esp),%edx
  80357c:	89 f9                	mov    %edi,%ecx
  80357e:	d3 e2                	shl    %cl,%edx
  803580:	39 c2                	cmp    %eax,%edx
  803582:	73 e9                	jae    80356d <__udivdi3+0xe5>
  803584:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803587:	31 ff                	xor    %edi,%edi
  803589:	e9 40 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  80358e:	66 90                	xchg   %ax,%ax
  803590:	31 c0                	xor    %eax,%eax
  803592:	e9 37 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  803597:	90                   	nop

00803598 <__umoddi3>:
  803598:	55                   	push   %ebp
  803599:	57                   	push   %edi
  80359a:	56                   	push   %esi
  80359b:	53                   	push   %ebx
  80359c:	83 ec 1c             	sub    $0x1c,%esp
  80359f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035b7:	89 f3                	mov    %esi,%ebx
  8035b9:	89 fa                	mov    %edi,%edx
  8035bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035bf:	89 34 24             	mov    %esi,(%esp)
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 1a                	jne    8035e0 <__umoddi3+0x48>
  8035c6:	39 f7                	cmp    %esi,%edi
  8035c8:	0f 86 a2 00 00 00    	jbe    803670 <__umoddi3+0xd8>
  8035ce:	89 c8                	mov    %ecx,%eax
  8035d0:	89 f2                	mov    %esi,%edx
  8035d2:	f7 f7                	div    %edi
  8035d4:	89 d0                	mov    %edx,%eax
  8035d6:	31 d2                	xor    %edx,%edx
  8035d8:	83 c4 1c             	add    $0x1c,%esp
  8035db:	5b                   	pop    %ebx
  8035dc:	5e                   	pop    %esi
  8035dd:	5f                   	pop    %edi
  8035de:	5d                   	pop    %ebp
  8035df:	c3                   	ret    
  8035e0:	39 f0                	cmp    %esi,%eax
  8035e2:	0f 87 ac 00 00 00    	ja     803694 <__umoddi3+0xfc>
  8035e8:	0f bd e8             	bsr    %eax,%ebp
  8035eb:	83 f5 1f             	xor    $0x1f,%ebp
  8035ee:	0f 84 ac 00 00 00    	je     8036a0 <__umoddi3+0x108>
  8035f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035f9:	29 ef                	sub    %ebp,%edi
  8035fb:	89 fe                	mov    %edi,%esi
  8035fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803601:	89 e9                	mov    %ebp,%ecx
  803603:	d3 e0                	shl    %cl,%eax
  803605:	89 d7                	mov    %edx,%edi
  803607:	89 f1                	mov    %esi,%ecx
  803609:	d3 ef                	shr    %cl,%edi
  80360b:	09 c7                	or     %eax,%edi
  80360d:	89 e9                	mov    %ebp,%ecx
  80360f:	d3 e2                	shl    %cl,%edx
  803611:	89 14 24             	mov    %edx,(%esp)
  803614:	89 d8                	mov    %ebx,%eax
  803616:	d3 e0                	shl    %cl,%eax
  803618:	89 c2                	mov    %eax,%edx
  80361a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361e:	d3 e0                	shl    %cl,%eax
  803620:	89 44 24 04          	mov    %eax,0x4(%esp)
  803624:	8b 44 24 08          	mov    0x8(%esp),%eax
  803628:	89 f1                	mov    %esi,%ecx
  80362a:	d3 e8                	shr    %cl,%eax
  80362c:	09 d0                	or     %edx,%eax
  80362e:	d3 eb                	shr    %cl,%ebx
  803630:	89 da                	mov    %ebx,%edx
  803632:	f7 f7                	div    %edi
  803634:	89 d3                	mov    %edx,%ebx
  803636:	f7 24 24             	mull   (%esp)
  803639:	89 c6                	mov    %eax,%esi
  80363b:	89 d1                	mov    %edx,%ecx
  80363d:	39 d3                	cmp    %edx,%ebx
  80363f:	0f 82 87 00 00 00    	jb     8036cc <__umoddi3+0x134>
  803645:	0f 84 91 00 00 00    	je     8036dc <__umoddi3+0x144>
  80364b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80364f:	29 f2                	sub    %esi,%edx
  803651:	19 cb                	sbb    %ecx,%ebx
  803653:	89 d8                	mov    %ebx,%eax
  803655:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803659:	d3 e0                	shl    %cl,%eax
  80365b:	89 e9                	mov    %ebp,%ecx
  80365d:	d3 ea                	shr    %cl,%edx
  80365f:	09 d0                	or     %edx,%eax
  803661:	89 e9                	mov    %ebp,%ecx
  803663:	d3 eb                	shr    %cl,%ebx
  803665:	89 da                	mov    %ebx,%edx
  803667:	83 c4 1c             	add    $0x1c,%esp
  80366a:	5b                   	pop    %ebx
  80366b:	5e                   	pop    %esi
  80366c:	5f                   	pop    %edi
  80366d:	5d                   	pop    %ebp
  80366e:	c3                   	ret    
  80366f:	90                   	nop
  803670:	89 fd                	mov    %edi,%ebp
  803672:	85 ff                	test   %edi,%edi
  803674:	75 0b                	jne    803681 <__umoddi3+0xe9>
  803676:	b8 01 00 00 00       	mov    $0x1,%eax
  80367b:	31 d2                	xor    %edx,%edx
  80367d:	f7 f7                	div    %edi
  80367f:	89 c5                	mov    %eax,%ebp
  803681:	89 f0                	mov    %esi,%eax
  803683:	31 d2                	xor    %edx,%edx
  803685:	f7 f5                	div    %ebp
  803687:	89 c8                	mov    %ecx,%eax
  803689:	f7 f5                	div    %ebp
  80368b:	89 d0                	mov    %edx,%eax
  80368d:	e9 44 ff ff ff       	jmp    8035d6 <__umoddi3+0x3e>
  803692:	66 90                	xchg   %ax,%ax
  803694:	89 c8                	mov    %ecx,%eax
  803696:	89 f2                	mov    %esi,%edx
  803698:	83 c4 1c             	add    $0x1c,%esp
  80369b:	5b                   	pop    %ebx
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	3b 04 24             	cmp    (%esp),%eax
  8036a3:	72 06                	jb     8036ab <__umoddi3+0x113>
  8036a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036a9:	77 0f                	ja     8036ba <__umoddi3+0x122>
  8036ab:	89 f2                	mov    %esi,%edx
  8036ad:	29 f9                	sub    %edi,%ecx
  8036af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036b3:	89 14 24             	mov    %edx,(%esp)
  8036b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036be:	8b 14 24             	mov    (%esp),%edx
  8036c1:	83 c4 1c             	add    $0x1c,%esp
  8036c4:	5b                   	pop    %ebx
  8036c5:	5e                   	pop    %esi
  8036c6:	5f                   	pop    %edi
  8036c7:	5d                   	pop    %ebp
  8036c8:	c3                   	ret    
  8036c9:	8d 76 00             	lea    0x0(%esi),%esi
  8036cc:	2b 04 24             	sub    (%esp),%eax
  8036cf:	19 fa                	sbb    %edi,%edx
  8036d1:	89 d1                	mov    %edx,%ecx
  8036d3:	89 c6                	mov    %eax,%esi
  8036d5:	e9 71 ff ff ff       	jmp    80364b <__umoddi3+0xb3>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e0:	72 ea                	jb     8036cc <__umoddi3+0x134>
  8036e2:	89 d9                	mov    %ebx,%ecx
  8036e4:	e9 62 ff ff ff       	jmp    80364b <__umoddi3+0xb3>
