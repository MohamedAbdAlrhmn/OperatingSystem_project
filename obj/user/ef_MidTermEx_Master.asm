
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
  800045:	68 60 38 80 00       	push   $0x803860
  80004a:	e8 5e 16 00 00       	call   8016ad <smalloc>
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
  800069:	68 62 38 80 00       	push   $0x803862
  80006e:	e8 3a 16 00 00       	call   8016ad <smalloc>
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
  8000a6:	68 69 38 80 00       	push   $0x803869
  8000ab:	e8 30 1a 00 00       	call   801ae0 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 6b 38 80 00       	push   $0x80386b
  8000bf:	e8 e9 15 00 00       	call   8016ad <smalloc>
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
  8000ec:	68 79 38 80 00       	push   $0x803879
  8000f1:	e8 fb 1a 00 00       	call   801bf1 <sys_create_env>
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
  800115:	68 83 38 80 00       	push   $0x803883
  80011a:	e8 d2 1a 00 00       	call   801bf1 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 8d 38 80 00       	push   $0x80388d
  800139:	6a 27                	push   $0x27
  80013b:	68 a2 38 80 00       	push   $0x8038a2
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 bf 1a 00 00       	call   801c0f <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 e1 33 00 00       	call   803541 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 a1 1a 00 00       	call   801c0f <sys_run_env>
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
  800185:	68 bd 38 80 00       	push   $0x8038bd
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 e1 1a 00 00       	call   801c78 <sys_getparentenvid>
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
  8001aa:	68 6b 38 80 00       	push   $0x80386b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 a4 15 00 00       	call   80175b <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 63 1a 00 00       	call   801c2b <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 55 1a 00 00       	call   801c2b <sys_destroy_env>
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
  8001f0:	e8 6a 1a 00 00       	call   801c5f <sys_getenvindex>
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
  80025b:	e8 0c 18 00 00       	call   801a6c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 ec 38 80 00       	push   $0x8038ec
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
  80028b:	68 14 39 80 00       	push   $0x803914
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
  8002bc:	68 3c 39 80 00       	push   $0x80393c
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 94 39 80 00       	push   $0x803994
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 ec 38 80 00       	push   $0x8038ec
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 8c 17 00 00       	call   801a86 <sys_enable_interrupt>

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
  80030d:	e8 19 19 00 00       	call   801c2b <sys_destroy_env>
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
  80031e:	e8 6e 19 00 00       	call   801c91 <sys_exit_env>
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
  800347:	68 a8 39 80 00       	push   $0x8039a8
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 50 80 00       	mov    0x805000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 ad 39 80 00       	push   $0x8039ad
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
  800384:	68 c9 39 80 00       	push   $0x8039c9
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
  8003b0:	68 cc 39 80 00       	push   $0x8039cc
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 18 3a 80 00       	push   $0x803a18
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
  800482:	68 24 3a 80 00       	push   $0x803a24
  800487:	6a 3a                	push   $0x3a
  800489:	68 18 3a 80 00       	push   $0x803a18
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
  8004f2:	68 78 3a 80 00       	push   $0x803a78
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 18 3a 80 00       	push   $0x803a18
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
  80054c:	e8 6d 13 00 00       	call   8018be <sys_cputs>
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
  8005c3:	e8 f6 12 00 00       	call   8018be <sys_cputs>
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
  80060d:	e8 5a 14 00 00       	call   801a6c <sys_disable_interrupt>
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
  80062d:	e8 54 14 00 00       	call   801a86 <sys_enable_interrupt>
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
  800677:	e8 7c 2f 00 00       	call   8035f8 <__udivdi3>
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
  8006c7:	e8 3c 30 00 00       	call   803708 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  800822:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  800903:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 05 3d 80 00       	push   $0x803d05
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
  800928:	68 0e 3d 80 00       	push   $0x803d0e
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
  800955:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  80137b:	68 70 3e 80 00       	push   $0x803e70
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
  80144b:	e8 b2 05 00 00       	call   801a02 <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 51 80 00       	mov    0x805120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 27 0c 00 00       	call   802088 <initialize_MemBlocksList>
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
  801489:	68 95 3e 80 00       	push   $0x803e95
  80148e:	6a 33                	push   $0x33
  801490:	68 b3 3e 80 00       	push   $0x803eb3
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
  801508:	68 c0 3e 80 00       	push   $0x803ec0
  80150d:	6a 34                	push   $0x34
  80150f:	68 b3 3e 80 00       	push   $0x803eb3
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
  8015a0:	e8 2b 08 00 00       	call   801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 11                	je     8015ba <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015a9:	83 ec 0c             	sub    $0xc,%esp
  8015ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8015af:	e8 96 0e 00 00       	call   80244a <alloc_block_FF>
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
  8015c6:	e8 f2 0b 00 00       	call   8021bd <insert_sorted_allocList>
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
  8015e0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	50                   	push   %eax
  8015ea:	68 40 50 80 00       	push   $0x805040
  8015ef:	e8 71 0b 00 00       	call   802165 <find_block>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  8015fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015fe:	0f 84 a6 00 00 00    	je     8016aa <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	8b 50 0c             	mov    0xc(%eax),%edx
  80160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160d:	8b 40 08             	mov    0x8(%eax),%eax
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	52                   	push   %edx
  801614:	50                   	push   %eax
  801615:	e8 b0 03 00 00       	call   8019ca <sys_free_user_mem>
  80161a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80161d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801621:	75 14                	jne    801637 <free+0x5a>
  801623:	83 ec 04             	sub    $0x4,%esp
  801626:	68 95 3e 80 00       	push   $0x803e95
  80162b:	6a 74                	push   $0x74
  80162d:	68 b3 3e 80 00       	push   $0x803eb3
  801632:	e8 ef ec ff ff       	call   800326 <_panic>
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	8b 00                	mov    (%eax),%eax
  80163c:	85 c0                	test   %eax,%eax
  80163e:	74 10                	je     801650 <free+0x73>
  801640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801643:	8b 00                	mov    (%eax),%eax
  801645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801648:	8b 52 04             	mov    0x4(%edx),%edx
  80164b:	89 50 04             	mov    %edx,0x4(%eax)
  80164e:	eb 0b                	jmp    80165b <free+0x7e>
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801653:	8b 40 04             	mov    0x4(%eax),%eax
  801656:	a3 44 50 80 00       	mov    %eax,0x805044
  80165b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165e:	8b 40 04             	mov    0x4(%eax),%eax
  801661:	85 c0                	test   %eax,%eax
  801663:	74 0f                	je     801674 <free+0x97>
  801665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801668:	8b 40 04             	mov    0x4(%eax),%eax
  80166b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166e:	8b 12                	mov    (%edx),%edx
  801670:	89 10                	mov    %edx,(%eax)
  801672:	eb 0a                	jmp    80167e <free+0xa1>
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	8b 00                	mov    (%eax),%eax
  801679:	a3 40 50 80 00       	mov    %eax,0x805040
  80167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801691:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801696:	48                   	dec    %eax
  801697:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80169c:	83 ec 0c             	sub    $0xc,%esp
  80169f:	ff 75 f4             	pushl  -0xc(%ebp)
  8016a2:	e8 4e 17 00 00       	call   802df5 <insert_sorted_with_merge_freeList>
  8016a7:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016aa:	90                   	nop
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 38             	sub    $0x38,%esp
  8016b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b9:	e8 a6 fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016c2:	75 0a                	jne    8016ce <smalloc+0x21>
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	e9 8b 00 00 00       	jmp    801759 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016ce:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	48                   	dec    %eax
  8016de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	f7 75 f0             	divl   -0x10(%ebp)
  8016ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ef:	29 d0                	sub    %edx,%eax
  8016f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016f4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fb:	e8 d0 06 00 00       	call   801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801700:	85 c0                	test   %eax,%eax
  801702:	74 11                	je     801715 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801704:	83 ec 0c             	sub    $0xc,%esp
  801707:	ff 75 e8             	pushl  -0x18(%ebp)
  80170a:	e8 3b 0d 00 00       	call   80244a <alloc_block_FF>
  80170f:	83 c4 10             	add    $0x10,%esp
  801712:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801719:	74 39                	je     801754 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80171b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171e:	8b 40 08             	mov    0x8(%eax),%eax
  801721:	89 c2                	mov    %eax,%edx
  801723:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801727:	52                   	push   %edx
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	ff 75 08             	pushl  0x8(%ebp)
  80172f:	e8 21 04 00 00       	call   801b55 <sys_createSharedObject>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80173a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80173e:	74 14                	je     801754 <smalloc+0xa7>
  801740:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801744:	74 0e                	je     801754 <smalloc+0xa7>
  801746:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80174a:	74 08                	je     801754 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174f:	8b 40 08             	mov    0x8(%eax),%eax
  801752:	eb 05                	jmp    801759 <smalloc+0xac>
	}
	return NULL;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801761:	e8 fe fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	e8 0b 04 00 00       	call   801b7f <sys_getSizeOfSharedObject>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80177a:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80177e:	74 76                	je     8017f6 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801780:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801787:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	48                   	dec    %eax
  801790:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801793:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	f7 75 ec             	divl   -0x14(%ebp)
  80179e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a1:	29 d0                	sub    %edx,%eax
  8017a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8017a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017ad:	e8 1e 06 00 00       	call   801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017b2:	85 c0                	test   %eax,%eax
  8017b4:	74 11                	je     8017c7 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017b6:	83 ec 0c             	sub    $0xc,%esp
  8017b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017bc:	e8 89 0c 00 00       	call   80244a <alloc_block_FF>
  8017c1:	83 c4 10             	add    $0x10,%esp
  8017c4:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8017c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017cb:	74 29                	je     8017f6 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d0:	8b 40 08             	mov    0x8(%eax),%eax
  8017d3:	83 ec 04             	sub    $0x4,%esp
  8017d6:	50                   	push   %eax
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	e8 ba 03 00 00       	call   801b9c <sys_getSharedObject>
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8017e8:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017ec:	74 08                	je     8017f6 <sget+0x9b>
				return (void *)mem_block->sva;
  8017ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f1:	8b 40 08             	mov    0x8(%eax),%eax
  8017f4:	eb 05                	jmp    8017fb <sget+0xa0>
		}
	}
	return NULL;
  8017f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801803:	e8 5c fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	68 e4 3e 80 00       	push   $0x803ee4
  801810:	68 f7 00 00 00       	push   $0xf7
  801815:	68 b3 3e 80 00       	push   $0x803eb3
  80181a:	e8 07 eb ff ff       	call   800326 <_panic>

0080181f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	68 0c 3f 80 00       	push   $0x803f0c
  80182d:	68 0c 01 00 00       	push   $0x10c
  801832:	68 b3 3e 80 00       	push   $0x803eb3
  801837:	e8 ea ea ff ff       	call   800326 <_panic>

0080183c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	68 30 3f 80 00       	push   $0x803f30
  80184a:	68 44 01 00 00       	push   $0x144
  80184f:	68 b3 3e 80 00       	push   $0x803eb3
  801854:	e8 cd ea ff ff       	call   800326 <_panic>

00801859 <shrink>:

}
void shrink(uint32 newSize)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	68 30 3f 80 00       	push   $0x803f30
  801867:	68 49 01 00 00       	push   $0x149
  80186c:	68 b3 3e 80 00       	push   $0x803eb3
  801871:	e8 b0 ea ff ff       	call   800326 <_panic>

00801876 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	68 30 3f 80 00       	push   $0x803f30
  801884:	68 4e 01 00 00       	push   $0x14e
  801889:	68 b3 3e 80 00       	push   $0x803eb3
  80188e:	e8 93 ea ff ff       	call   800326 <_panic>

00801893 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	57                   	push   %edi
  801897:	56                   	push   %esi
  801898:	53                   	push   %ebx
  801899:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ae:	cd 30                	int    $0x30
  8018b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	5b                   	pop    %ebx
  8018ba:	5e                   	pop    %esi
  8018bb:	5f                   	pop    %edi
  8018bc:	5d                   	pop    %ebp
  8018bd:	c3                   	ret    

008018be <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 04             	sub    $0x4,%esp
  8018c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	ff 75 0c             	pushl  0xc(%ebp)
  8018d9:	50                   	push   %eax
  8018da:	6a 00                	push   $0x0
  8018dc:	e8 b2 ff ff ff       	call   801893 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	90                   	nop
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 01                	push   $0x1
  8018f6:	e8 98 ff ff ff       	call   801893 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801903:	8b 55 0c             	mov    0xc(%ebp),%edx
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	6a 05                	push   $0x5
  801913:	e8 7b ff ff ff       	call   801893 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801922:	8b 75 18             	mov    0x18(%ebp),%esi
  801925:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801928:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	56                   	push   %esi
  801932:	53                   	push   %ebx
  801933:	51                   	push   %ecx
  801934:	52                   	push   %edx
  801935:	50                   	push   %eax
  801936:	6a 06                	push   $0x6
  801938:	e8 56 ff ff ff       	call   801893 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
}
  801940:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801943:	5b                   	pop    %ebx
  801944:	5e                   	pop    %esi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80194a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	52                   	push   %edx
  801957:	50                   	push   %eax
  801958:	6a 07                	push   $0x7
  80195a:	e8 34 ff ff ff       	call   801893 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 08                	push   $0x8
  801975:	e8 19 ff ff ff       	call   801893 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 09                	push   $0x9
  80198e:	e8 00 ff ff ff       	call   801893 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 0a                	push   $0xa
  8019a7:	e8 e7 fe ff ff       	call   801893 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 0b                	push   $0xb
  8019c0:	e8 ce fe ff ff       	call   801893 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	ff 75 08             	pushl  0x8(%ebp)
  8019d9:	6a 0f                	push   $0xf
  8019db:	e8 b3 fe ff ff       	call   801893 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
	return;
  8019e3:	90                   	nop
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	ff 75 08             	pushl  0x8(%ebp)
  8019f5:	6a 10                	push   $0x10
  8019f7:	e8 97 fe ff ff       	call   801893 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ff:	90                   	nop
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	ff 75 10             	pushl  0x10(%ebp)
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	ff 75 08             	pushl  0x8(%ebp)
  801a12:	6a 11                	push   $0x11
  801a14:	e8 7a fe ff ff       	call   801893 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1c:	90                   	nop
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 0c                	push   $0xc
  801a2e:	e8 60 fe ff ff       	call   801893 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	6a 0d                	push   $0xd
  801a48:	e8 46 fe ff ff       	call   801893 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 0e                	push   $0xe
  801a61:	e8 2d fe ff ff       	call   801893 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 13                	push   $0x13
  801a7b:	e8 13 fe ff ff       	call   801893 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 14                	push   $0x14
  801a95:	e8 f9 fd ff ff       	call   801893 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	50                   	push   %eax
  801ab9:	6a 15                	push   $0x15
  801abb:	e8 d3 fd ff ff       	call   801893 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 16                	push   $0x16
  801ad5:	e8 b9 fd ff ff       	call   801893 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	50                   	push   %eax
  801af0:	6a 17                	push   $0x17
  801af2:	e8 9c fd ff ff       	call   801893 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 1a                	push   $0x1a
  801b0f:	e8 7f fd ff ff       	call   801893 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	52                   	push   %edx
  801b29:	50                   	push   %eax
  801b2a:	6a 18                	push   $0x18
  801b2c:	e8 62 fd ff ff       	call   801893 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	90                   	nop
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 19                	push   $0x19
  801b4a:	e8 44 fd ff ff       	call   801893 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	90                   	nop
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b61:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	51                   	push   %ecx
  801b6e:	52                   	push   %edx
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	50                   	push   %eax
  801b73:	6a 1b                	push   $0x1b
  801b75:	e8 19 fd ff ff       	call   801893 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	52                   	push   %edx
  801b8f:	50                   	push   %eax
  801b90:	6a 1c                	push   $0x1c
  801b92:	e8 fc fc ff ff       	call   801893 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	51                   	push   %ecx
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 1d                	push   $0x1d
  801bb1:	e8 dd fc ff ff       	call   801893 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	52                   	push   %edx
  801bcb:	50                   	push   %eax
  801bcc:	6a 1e                	push   $0x1e
  801bce:	e8 c0 fc ff ff       	call   801893 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 1f                	push   $0x1f
  801be7:	e8 a7 fc ff ff       	call   801893 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 14             	pushl  0x14(%ebp)
  801bfc:	ff 75 10             	pushl  0x10(%ebp)
  801bff:	ff 75 0c             	pushl  0xc(%ebp)
  801c02:	50                   	push   %eax
  801c03:	6a 20                	push   $0x20
  801c05:	e8 89 fc ff ff       	call   801893 <syscall>
  801c0a:	83 c4 18             	add    $0x18,%esp
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	50                   	push   %eax
  801c1e:	6a 21                	push   $0x21
  801c20:	e8 6e fc ff ff       	call   801893 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
}
  801c28:	90                   	nop
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	50                   	push   %eax
  801c3a:	6a 22                	push   $0x22
  801c3c:	e8 52 fc ff ff       	call   801893 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 02                	push   $0x2
  801c55:	e8 39 fc ff ff       	call   801893 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 03                	push   $0x3
  801c6e:	e8 20 fc ff ff       	call   801893 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 04                	push   $0x4
  801c87:	e8 07 fc ff ff       	call   801893 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_exit_env>:


void sys_exit_env(void)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 23                	push   $0x23
  801ca0:	e8 ee fb ff ff       	call   801893 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	90                   	nop
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb4:	8d 50 04             	lea    0x4(%eax),%edx
  801cb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	52                   	push   %edx
  801cc1:	50                   	push   %eax
  801cc2:	6a 24                	push   $0x24
  801cc4:	e8 ca fb ff ff       	call   801893 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return result;
  801ccc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd5:	89 01                	mov    %eax,(%ecx)
  801cd7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	c9                   	leave  
  801cde:	c2 04 00             	ret    $0x4

00801ce1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	ff 75 10             	pushl  0x10(%ebp)
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 12                	push   $0x12
  801cf3:	e8 9b fb ff ff       	call   801893 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <sys_rcr2>:
uint32 sys_rcr2()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 25                	push   $0x25
  801d0d:	e8 81 fb ff ff       	call   801893 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	83 ec 04             	sub    $0x4,%esp
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	50                   	push   %eax
  801d30:	6a 26                	push   $0x26
  801d32:	e8 5c fb ff ff       	call   801893 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <rsttst>:
void rsttst()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 28                	push   $0x28
  801d4c:	e8 42 fb ff ff       	call   801893 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d63:	8b 55 18             	mov    0x18(%ebp),%edx
  801d66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	ff 75 10             	pushl  0x10(%ebp)
  801d6f:	ff 75 0c             	pushl  0xc(%ebp)
  801d72:	ff 75 08             	pushl  0x8(%ebp)
  801d75:	6a 27                	push   $0x27
  801d77:	e8 17 fb ff ff       	call   801893 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7f:	90                   	nop
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <chktst>:
void chktst(uint32 n)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	ff 75 08             	pushl  0x8(%ebp)
  801d90:	6a 29                	push   $0x29
  801d92:	e8 fc fa ff ff       	call   801893 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9a:	90                   	nop
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <inctst>:

void inctst()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 2a                	push   $0x2a
  801dac:	e8 e2 fa ff ff       	call   801893 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
	return ;
  801db4:	90                   	nop
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <gettst>:
uint32 gettst()
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 2b                	push   $0x2b
  801dc6:	e8 c8 fa ff ff       	call   801893 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 2c                	push   $0x2c
  801de2:	e8 ac fa ff ff       	call   801893 <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
  801dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ded:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df1:	75 07                	jne    801dfa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df3:	b8 01 00 00 00       	mov    $0x1,%eax
  801df8:	eb 05                	jmp    801dff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 2c                	push   $0x2c
  801e13:	e8 7b fa ff ff       	call   801893 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
  801e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e1e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e22:	75 07                	jne    801e2b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e24:	b8 01 00 00 00       	mov    $0x1,%eax
  801e29:	eb 05                	jmp    801e30 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 2c                	push   $0x2c
  801e44:	e8 4a fa ff ff       	call   801893 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
  801e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e4f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e53:	75 07                	jne    801e5c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e55:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5a:	eb 05                	jmp    801e61 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 2c                	push   $0x2c
  801e75:	e8 19 fa ff ff       	call   801893 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
  801e7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e80:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e84:	75 07                	jne    801e8d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	eb 05                	jmp    801e92 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	6a 2d                	push   $0x2d
  801ea4:	e8 ea f9 ff ff       	call   801893 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	6a 00                	push   $0x0
  801ec1:	53                   	push   %ebx
  801ec2:	51                   	push   %ecx
  801ec3:	52                   	push   %edx
  801ec4:	50                   	push   %eax
  801ec5:	6a 2e                	push   $0x2e
  801ec7:	e8 c7 f9 ff ff       	call   801893 <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
}
  801ecf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	6a 2f                	push   $0x2f
  801ee7:	e8 a7 f9 ff ff       	call   801893 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	68 40 3f 80 00       	push   $0x803f40
  801eff:	e8 d6 e6 ff ff       	call   8005da <cprintf>
  801f04:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	68 6c 3f 80 00       	push   $0x803f6c
  801f16:	e8 bf e6 ff ff       	call   8005da <cprintf>
  801f1b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f1e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f22:	a1 38 51 80 00       	mov    0x805138,%eax
  801f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2a:	eb 56                	jmp    801f82 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f30:	74 1c                	je     801f4e <print_mem_block_lists+0x5d>
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 50 08             	mov    0x8(%eax),%edx
  801f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f41:	8b 40 0c             	mov    0xc(%eax),%eax
  801f44:	01 c8                	add    %ecx,%eax
  801f46:	39 c2                	cmp    %eax,%edx
  801f48:	73 04                	jae    801f4e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f4a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f51:	8b 50 08             	mov    0x8(%eax),%edx
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5a:	01 c2                	add    %eax,%edx
  801f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	68 81 3f 80 00       	push   $0x803f81
  801f6c:	e8 69 e6 ff ff       	call   8005da <cprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7a:	a1 40 51 80 00       	mov    0x805140,%eax
  801f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f86:	74 07                	je     801f8f <print_mem_block_lists+0x9e>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 00                	mov    (%eax),%eax
  801f8d:	eb 05                	jmp    801f94 <print_mem_block_lists+0xa3>
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f94:	a3 40 51 80 00       	mov    %eax,0x805140
  801f99:	a1 40 51 80 00       	mov    0x805140,%eax
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 8a                	jne    801f2c <print_mem_block_lists+0x3b>
  801fa2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa6:	75 84                	jne    801f2c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fa8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fac:	75 10                	jne    801fbe <print_mem_block_lists+0xcd>
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 90 3f 80 00       	push   $0x803f90
  801fb6:	e8 1f e6 ff ff       	call   8005da <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fbe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 b4 3f 80 00       	push   $0x803fb4
  801fcd:	e8 08 e6 ff ff       	call   8005da <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fd5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd9:	a1 40 50 80 00       	mov    0x805040,%eax
  801fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe1:	eb 56                	jmp    802039 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe7:	74 1c                	je     802005 <print_mem_block_lists+0x114>
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 50 08             	mov    0x8(%eax),%edx
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffb:	01 c8                	add    %ecx,%eax
  801ffd:	39 c2                	cmp    %eax,%edx
  801fff:	73 04                	jae    802005 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802001:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	8b 50 08             	mov    0x8(%eax),%edx
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 40 0c             	mov    0xc(%eax),%eax
  802011:	01 c2                	add    %eax,%edx
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	8b 40 08             	mov    0x8(%eax),%eax
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	52                   	push   %edx
  80201d:	50                   	push   %eax
  80201e:	68 81 3f 80 00       	push   $0x803f81
  802023:	e8 b2 e5 ff ff       	call   8005da <cprintf>
  802028:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802031:	a1 48 50 80 00       	mov    0x805048,%eax
  802036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203d:	74 07                	je     802046 <print_mem_block_lists+0x155>
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 00                	mov    (%eax),%eax
  802044:	eb 05                	jmp    80204b <print_mem_block_lists+0x15a>
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	a3 48 50 80 00       	mov    %eax,0x805048
  802050:	a1 48 50 80 00       	mov    0x805048,%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	75 8a                	jne    801fe3 <print_mem_block_lists+0xf2>
  802059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205d:	75 84                	jne    801fe3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80205f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802063:	75 10                	jne    802075 <print_mem_block_lists+0x184>
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 cc 3f 80 00       	push   $0x803fcc
  80206d:	e8 68 e5 ff ff       	call   8005da <cprintf>
  802072:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	68 40 3f 80 00       	push   $0x803f40
  80207d:	e8 58 e5 ff ff       	call   8005da <cprintf>
  802082:	83 c4 10             	add    $0x10,%esp

}
  802085:	90                   	nop
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80208e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802095:	00 00 00 
  802098:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80209f:	00 00 00 
  8020a2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020a9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b3:	e9 9e 00 00 00       	jmp    802156 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8020bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c0:	c1 e2 04             	shl    $0x4,%edx
  8020c3:	01 d0                	add    %edx,%eax
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	75 14                	jne    8020dd <initialize_MemBlocksList+0x55>
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	68 f4 3f 80 00       	push   $0x803ff4
  8020d1:	6a 46                	push   $0x46
  8020d3:	68 17 40 80 00       	push   $0x804017
  8020d8:	e8 49 e2 ff ff       	call   800326 <_panic>
  8020dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	c1 e2 04             	shl    $0x4,%edx
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020f0:	89 10                	mov    %edx,(%eax)
  8020f2:	8b 00                	mov    (%eax),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	74 18                	je     802110 <initialize_MemBlocksList+0x88>
  8020f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8020fd:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802103:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802106:	c1 e1 04             	shl    $0x4,%ecx
  802109:	01 ca                	add    %ecx,%edx
  80210b:	89 50 04             	mov    %edx,0x4(%eax)
  80210e:	eb 12                	jmp    802122 <initialize_MemBlocksList+0x9a>
  802110:	a1 50 50 80 00       	mov    0x805050,%eax
  802115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802118:	c1 e2 04             	shl    $0x4,%edx
  80211b:	01 d0                	add    %edx,%eax
  80211d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802122:	a1 50 50 80 00       	mov    0x805050,%eax
  802127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212a:	c1 e2 04             	shl    $0x4,%edx
  80212d:	01 d0                	add    %edx,%eax
  80212f:	a3 48 51 80 00       	mov    %eax,0x805148
  802134:	a1 50 50 80 00       	mov    0x805050,%eax
  802139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213c:	c1 e2 04             	shl    $0x4,%edx
  80213f:	01 d0                	add    %edx,%eax
  802141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802148:	a1 54 51 80 00       	mov    0x805154,%eax
  80214d:	40                   	inc    %eax
  80214e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802153:	ff 45 f4             	incl   -0xc(%ebp)
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	3b 45 08             	cmp    0x8(%ebp),%eax
  80215c:	0f 82 56 ff ff ff    	jb     8020b8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802162:	90                   	nop
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802173:	eb 19                	jmp    80218e <find_block+0x29>
	{
		if(va==point->sva)
  802175:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802178:	8b 40 08             	mov    0x8(%eax),%eax
  80217b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80217e:	75 05                	jne    802185 <find_block+0x20>
		   return point;
  802180:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802183:	eb 36                	jmp    8021bb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	8b 40 08             	mov    0x8(%eax),%eax
  80218b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80218e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802192:	74 07                	je     80219b <find_block+0x36>
  802194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802197:	8b 00                	mov    (%eax),%eax
  802199:	eb 05                	jmp    8021a0 <find_block+0x3b>
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a3:	89 42 08             	mov    %eax,0x8(%edx)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	75 c5                	jne    802175 <find_block+0x10>
  8021b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b4:	75 bf                	jne    802175 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021cb:	a1 44 50 80 00       	mov    0x805044,%eax
  8021d0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021d9:	74 24                	je     8021ff <insert_sorted_allocList+0x42>
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 50 08             	mov    0x8(%eax),%edx
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	8b 40 08             	mov    0x8(%eax),%eax
  8021e7:	39 c2                	cmp    %eax,%edx
  8021e9:	76 14                	jbe    8021ff <insert_sorted_allocList+0x42>
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 50 08             	mov    0x8(%eax),%edx
  8021f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f4:	8b 40 08             	mov    0x8(%eax),%eax
  8021f7:	39 c2                	cmp    %eax,%edx
  8021f9:	0f 82 60 01 00 00    	jb     80235f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802203:	75 65                	jne    80226a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802209:	75 14                	jne    80221f <insert_sorted_allocList+0x62>
  80220b:	83 ec 04             	sub    $0x4,%esp
  80220e:	68 f4 3f 80 00       	push   $0x803ff4
  802213:	6a 6b                	push   $0x6b
  802215:	68 17 40 80 00       	push   $0x804017
  80221a:	e8 07 e1 ff ff       	call   800326 <_panic>
  80221f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	89 10                	mov    %edx,(%eax)
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	8b 00                	mov    (%eax),%eax
  80222f:	85 c0                	test   %eax,%eax
  802231:	74 0d                	je     802240 <insert_sorted_allocList+0x83>
  802233:	a1 40 50 80 00       	mov    0x805040,%eax
  802238:	8b 55 08             	mov    0x8(%ebp),%edx
  80223b:	89 50 04             	mov    %edx,0x4(%eax)
  80223e:	eb 08                	jmp    802248 <insert_sorted_allocList+0x8b>
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	a3 44 50 80 00       	mov    %eax,0x805044
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 40 50 80 00       	mov    %eax,0x805040
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80225a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80225f:	40                   	inc    %eax
  802260:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802265:	e9 dc 01 00 00       	jmp    802446 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	39 c2                	cmp    %eax,%edx
  802278:	77 6c                	ja     8022e6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80227a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227e:	74 06                	je     802286 <insert_sorted_allocList+0xc9>
  802280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802284:	75 14                	jne    80229a <insert_sorted_allocList+0xdd>
  802286:	83 ec 04             	sub    $0x4,%esp
  802289:	68 30 40 80 00       	push   $0x804030
  80228e:	6a 6f                	push   $0x6f
  802290:	68 17 40 80 00       	push   $0x804017
  802295:	e8 8c e0 ff ff       	call   800326 <_panic>
  80229a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229d:	8b 50 04             	mov    0x4(%eax),%edx
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	8b 40 04             	mov    0x4(%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 0d                	je     8022c5 <insert_sorted_allocList+0x108>
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	8b 40 04             	mov    0x4(%eax),%eax
  8022be:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c1:	89 10                	mov    %edx,(%eax)
  8022c3:	eb 08                	jmp    8022cd <insert_sorted_allocList+0x110>
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d3:	89 50 04             	mov    %edx,0x4(%eax)
  8022d6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022db:	40                   	inc    %eax
  8022dc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e1:	e9 60 01 00 00       	jmp    802446 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ef:	8b 40 08             	mov    0x8(%eax),%eax
  8022f2:	39 c2                	cmp    %eax,%edx
  8022f4:	0f 82 4c 01 00 00    	jb     802446 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fe:	75 14                	jne    802314 <insert_sorted_allocList+0x157>
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 68 40 80 00       	push   $0x804068
  802308:	6a 73                	push   $0x73
  80230a:	68 17 40 80 00       	push   $0x804017
  80230f:	e8 12 e0 ff ff       	call   800326 <_panic>
  802314:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	89 50 04             	mov    %edx,0x4(%eax)
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	74 0c                	je     802336 <insert_sorted_allocList+0x179>
  80232a:	a1 44 50 80 00       	mov    0x805044,%eax
  80232f:	8b 55 08             	mov    0x8(%ebp),%edx
  802332:	89 10                	mov    %edx,(%eax)
  802334:	eb 08                	jmp    80233e <insert_sorted_allocList+0x181>
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 40 50 80 00       	mov    %eax,0x805040
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	a3 44 50 80 00       	mov    %eax,0x805044
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80234f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802354:	40                   	inc    %eax
  802355:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80235a:	e9 e7 00 00 00       	jmp    802446 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802365:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80236c:	a1 40 50 80 00       	mov    0x805040,%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802374:	e9 9d 00 00 00       	jmp    802416 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 00                	mov    (%eax),%eax
  80237e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	8b 50 08             	mov    0x8(%eax),%edx
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 08             	mov    0x8(%eax),%eax
  80238d:	39 c2                	cmp    %eax,%edx
  80238f:	76 7d                	jbe    80240e <insert_sorted_allocList+0x251>
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	8b 50 08             	mov    0x8(%eax),%edx
  802397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80239a:	8b 40 08             	mov    0x8(%eax),%eax
  80239d:	39 c2                	cmp    %eax,%edx
  80239f:	73 6d                	jae    80240e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a5:	74 06                	je     8023ad <insert_sorted_allocList+0x1f0>
  8023a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ab:	75 14                	jne    8023c1 <insert_sorted_allocList+0x204>
  8023ad:	83 ec 04             	sub    $0x4,%esp
  8023b0:	68 8c 40 80 00       	push   $0x80408c
  8023b5:	6a 7f                	push   $0x7f
  8023b7:	68 17 40 80 00       	push   $0x804017
  8023bc:	e8 65 df ff ff       	call   800326 <_panic>
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 10                	mov    (%eax),%edx
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	8b 00                	mov    (%eax),%eax
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	74 0b                	je     8023df <insert_sorted_allocList+0x222>
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e5:	89 10                	mov    %edx,(%eax)
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	75 08                	jne    802401 <insert_sorted_allocList+0x244>
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 44 50 80 00       	mov    %eax,0x805044
  802401:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802406:	40                   	inc    %eax
  802407:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80240c:	eb 39                	jmp    802447 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80240e:	a1 48 50 80 00       	mov    0x805048,%eax
  802413:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241a:	74 07                	je     802423 <insert_sorted_allocList+0x266>
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	eb 05                	jmp    802428 <insert_sorted_allocList+0x26b>
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	a3 48 50 80 00       	mov    %eax,0x805048
  80242d:	a1 48 50 80 00       	mov    0x805048,%eax
  802432:	85 c0                	test   %eax,%eax
  802434:	0f 85 3f ff ff ff    	jne    802379 <insert_sorted_allocList+0x1bc>
  80243a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80243e:	0f 85 35 ff ff ff    	jne    802379 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802444:	eb 01                	jmp    802447 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802446:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802447:	90                   	nop
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802450:	a1 38 51 80 00       	mov    0x805138,%eax
  802455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802458:	e9 85 01 00 00       	jmp    8025e2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 40 0c             	mov    0xc(%eax),%eax
  802463:	3b 45 08             	cmp    0x8(%ebp),%eax
  802466:	0f 82 6e 01 00 00    	jb     8025da <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 85 8a 00 00 00    	jne    802505 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80247b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247f:	75 17                	jne    802498 <alloc_block_FF+0x4e>
  802481:	83 ec 04             	sub    $0x4,%esp
  802484:	68 c0 40 80 00       	push   $0x8040c0
  802489:	68 93 00 00 00       	push   $0x93
  80248e:	68 17 40 80 00       	push   $0x804017
  802493:	e8 8e de ff ff       	call   800326 <_panic>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 10                	je     8024b1 <alloc_block_FF+0x67>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ac:	89 50 04             	mov    %edx,0x4(%eax)
  8024af:	eb 0b                	jmp    8024bc <alloc_block_FF+0x72>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 0f                	je     8024d5 <alloc_block_FF+0x8b>
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cf:	8b 12                	mov    (%edx),%edx
  8024d1:	89 10                	mov    %edx,(%eax)
  8024d3:	eb 0a                	jmp    8024df <alloc_block_FF+0x95>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	a3 38 51 80 00       	mov    %eax,0x805138
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8024f7:	48                   	dec    %eax
  8024f8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	e9 10 01 00 00       	jmp    802615 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250e:	0f 86 c6 00 00 00    	jbe    8025da <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802514:	a1 48 51 80 00       	mov    0x805148,%eax
  802519:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80251c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251f:	8b 50 08             	mov    0x8(%eax),%edx
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252b:	8b 55 08             	mov    0x8(%ebp),%edx
  80252e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802531:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802535:	75 17                	jne    80254e <alloc_block_FF+0x104>
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	68 c0 40 80 00       	push   $0x8040c0
  80253f:	68 9b 00 00 00       	push   $0x9b
  802544:	68 17 40 80 00       	push   $0x804017
  802549:	e8 d8 dd ff ff       	call   800326 <_panic>
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 10                	je     802567 <alloc_block_FF+0x11d>
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255f:	8b 52 04             	mov    0x4(%edx),%edx
  802562:	89 50 04             	mov    %edx,0x4(%eax)
  802565:	eb 0b                	jmp    802572 <alloc_block_FF+0x128>
  802567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256a:	8b 40 04             	mov    0x4(%eax),%eax
  80256d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 0f                	je     80258b <alloc_block_FF+0x141>
  80257c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802585:	8b 12                	mov    (%edx),%edx
  802587:	89 10                	mov    %edx,(%eax)
  802589:	eb 0a                	jmp    802595 <alloc_block_FF+0x14b>
  80258b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	a3 48 51 80 00       	mov    %eax,0x805148
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a8:	a1 54 51 80 00       	mov    0x805154,%eax
  8025ad:	48                   	dec    %eax
  8025ae:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 50 08             	mov    0x8(%eax),%edx
  8025b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bc:	01 c2                	add    %eax,%edx
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8025cd:	89 c2                	mov    %eax,%edx
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	eb 3b                	jmp    802615 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025da:	a1 40 51 80 00       	mov    0x805140,%eax
  8025df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e6:	74 07                	je     8025ef <alloc_block_FF+0x1a5>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	eb 05                	jmp    8025f4 <alloc_block_FF+0x1aa>
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8025f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	0f 85 57 fe ff ff    	jne    80245d <alloc_block_FF+0x13>
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	0f 85 4d fe ff ff    	jne    80245d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802610:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802615:	c9                   	leave  
  802616:	c3                   	ret    

00802617 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802617:	55                   	push   %ebp
  802618:	89 e5                	mov    %esp,%ebp
  80261a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80261d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802624:	a1 38 51 80 00       	mov    0x805138,%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	e9 df 00 00 00       	jmp    802710 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 0c             	mov    0xc(%eax),%eax
  802637:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263a:	0f 82 c8 00 00 00    	jb     802708 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	3b 45 08             	cmp    0x8(%ebp),%eax
  802649:	0f 85 8a 00 00 00    	jne    8026d9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80264f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802653:	75 17                	jne    80266c <alloc_block_BF+0x55>
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	68 c0 40 80 00       	push   $0x8040c0
  80265d:	68 b7 00 00 00       	push   $0xb7
  802662:	68 17 40 80 00       	push   $0x804017
  802667:	e8 ba dc ff ff       	call   800326 <_panic>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	74 10                	je     802685 <alloc_block_BF+0x6e>
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267d:	8b 52 04             	mov    0x4(%edx),%edx
  802680:	89 50 04             	mov    %edx,0x4(%eax)
  802683:	eb 0b                	jmp    802690 <alloc_block_BF+0x79>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 04             	mov    0x4(%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 0f                	je     8026a9 <alloc_block_BF+0x92>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a3:	8b 12                	mov    (%edx),%edx
  8026a5:	89 10                	mov    %edx,(%eax)
  8026a7:	eb 0a                	jmp    8026b3 <alloc_block_BF+0x9c>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8026cb:	48                   	dec    %eax
  8026cc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	e9 4d 01 00 00       	jmp    802826 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e2:	76 24                	jbe    802708 <alloc_block_BF+0xf1>
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ed:	73 19                	jae    802708 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026ef:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802708:	a1 40 51 80 00       	mov    0x805140,%eax
  80270d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802710:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802714:	74 07                	je     80271d <alloc_block_BF+0x106>
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	eb 05                	jmp    802722 <alloc_block_BF+0x10b>
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
  802722:	a3 40 51 80 00       	mov    %eax,0x805140
  802727:	a1 40 51 80 00       	mov    0x805140,%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	0f 85 fd fe ff ff    	jne    802631 <alloc_block_BF+0x1a>
  802734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802738:	0f 85 f3 fe ff ff    	jne    802631 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80273e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802742:	0f 84 d9 00 00 00    	je     802821 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802748:	a1 48 51 80 00       	mov    0x805148,%eax
  80274d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802750:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802756:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275c:	8b 55 08             	mov    0x8(%ebp),%edx
  80275f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802762:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802766:	75 17                	jne    80277f <alloc_block_BF+0x168>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 c0 40 80 00       	push   $0x8040c0
  802770:	68 c7 00 00 00       	push   $0xc7
  802775:	68 17 40 80 00       	push   $0x804017
  80277a:	e8 a7 db ff ff       	call   800326 <_panic>
  80277f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 10                	je     802798 <alloc_block_BF+0x181>
  802788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802790:	8b 52 04             	mov    0x4(%edx),%edx
  802793:	89 50 04             	mov    %edx,0x4(%eax)
  802796:	eb 0b                	jmp    8027a3 <alloc_block_BF+0x18c>
  802798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 0f                	je     8027bc <alloc_block_BF+0x1a5>
  8027ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b0:	8b 40 04             	mov    0x4(%eax),%eax
  8027b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027b6:	8b 12                	mov    (%edx),%edx
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	eb 0a                	jmp    8027c6 <alloc_block_BF+0x1af>
  8027bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8027c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8027de:	48                   	dec    %eax
  8027df:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027e4:	83 ec 08             	sub    $0x8,%esp
  8027e7:	ff 75 ec             	pushl  -0x14(%ebp)
  8027ea:	68 38 51 80 00       	push   $0x805138
  8027ef:	e8 71 f9 ff ff       	call   802165 <find_block>
  8027f4:	83 c4 10             	add    $0x10,%esp
  8027f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fd:	8b 50 08             	mov    0x8(%eax),%edx
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	01 c2                	add    %eax,%edx
  802805:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802808:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80280b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	2b 45 08             	sub    0x8(%ebp),%eax
  802814:	89 c2                	mov    %eax,%edx
  802816:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802819:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80281c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281f:	eb 05                	jmp    802826 <alloc_block_BF+0x20f>
	}
	return NULL;
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80282e:	a1 28 50 80 00       	mov    0x805028,%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	0f 85 de 01 00 00    	jne    802a19 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80283b:	a1 38 51 80 00       	mov    0x805138,%eax
  802840:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802843:	e9 9e 01 00 00       	jmp    8029e6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 0c             	mov    0xc(%eax),%eax
  80284e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802851:	0f 82 87 01 00 00    	jb     8029de <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 85 95 00 00 00    	jne    8028fb <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	75 17                	jne    802883 <alloc_block_NF+0x5b>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 c0 40 80 00       	push   $0x8040c0
  802874:	68 e0 00 00 00       	push   $0xe0
  802879:	68 17 40 80 00       	push   $0x804017
  80287e:	e8 a3 da ff ff       	call   800326 <_panic>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 10                	je     80289c <alloc_block_NF+0x74>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802894:	8b 52 04             	mov    0x4(%edx),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	eb 0b                	jmp    8028a7 <alloc_block_NF+0x7f>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0f                	je     8028c0 <alloc_block_NF+0x98>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	8b 12                	mov    (%edx),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	eb 0a                	jmp    8028ca <alloc_block_NF+0xa2>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ee:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	e9 f8 04 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802901:	3b 45 08             	cmp    0x8(%ebp),%eax
  802904:	0f 86 d4 00 00 00    	jbe    8029de <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290a:	a1 48 51 80 00       	mov    0x805148,%eax
  80290f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 55 08             	mov    0x8(%ebp),%edx
  802924:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802927:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80292b:	75 17                	jne    802944 <alloc_block_NF+0x11c>
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	68 c0 40 80 00       	push   $0x8040c0
  802935:	68 e9 00 00 00       	push   $0xe9
  80293a:	68 17 40 80 00       	push   $0x804017
  80293f:	e8 e2 d9 ff ff       	call   800326 <_panic>
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 10                	je     80295d <alloc_block_NF+0x135>
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802955:	8b 52 04             	mov    0x4(%edx),%edx
  802958:	89 50 04             	mov    %edx,0x4(%eax)
  80295b:	eb 0b                	jmp    802968 <alloc_block_NF+0x140>
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 40 04             	mov    0x4(%eax),%eax
  802963:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	85 c0                	test   %eax,%eax
  802970:	74 0f                	je     802981 <alloc_block_NF+0x159>
  802972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80297b:	8b 12                	mov    (%edx),%edx
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	eb 0a                	jmp    80298b <alloc_block_NF+0x163>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	a3 48 51 80 00       	mov    %eax,0x805148
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299e:	a1 54 51 80 00       	mov    0x805154,%eax
  8029a3:	48                   	dec    %eax
  8029a4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	8b 40 08             	mov    0x8(%eax),%eax
  8029af:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	01 c2                	add    %eax,%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ce:	89 c2                	mov    %eax,%edx
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	e9 15 04 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029de:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ea:	74 07                	je     8029f3 <alloc_block_NF+0x1cb>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	eb 05                	jmp    8029f8 <alloc_block_NF+0x1d0>
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	a3 40 51 80 00       	mov    %eax,0x805140
  8029fd:	a1 40 51 80 00       	mov    0x805140,%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	0f 85 3e fe ff ff    	jne    802848 <alloc_block_NF+0x20>
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	0f 85 34 fe ff ff    	jne    802848 <alloc_block_NF+0x20>
  802a14:	e9 d5 03 00 00       	jmp    802dee <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a19:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a21:	e9 b1 01 00 00       	jmp    802bd7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 50 08             	mov    0x8(%eax),%edx
  802a2c:	a1 28 50 80 00       	mov    0x805028,%eax
  802a31:	39 c2                	cmp    %eax,%edx
  802a33:	0f 82 96 01 00 00    	jb     802bcf <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a42:	0f 82 87 01 00 00    	jb     802bcf <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a51:	0f 85 95 00 00 00    	jne    802aec <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5b:	75 17                	jne    802a74 <alloc_block_NF+0x24c>
  802a5d:	83 ec 04             	sub    $0x4,%esp
  802a60:	68 c0 40 80 00       	push   $0x8040c0
  802a65:	68 fc 00 00 00       	push   $0xfc
  802a6a:	68 17 40 80 00       	push   $0x804017
  802a6f:	e8 b2 d8 ff ff       	call   800326 <_panic>
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 10                	je     802a8d <alloc_block_NF+0x265>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 00                	mov    (%eax),%eax
  802a82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a85:	8b 52 04             	mov    0x4(%edx),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%eax)
  802a8b:	eb 0b                	jmp    802a98 <alloc_block_NF+0x270>
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 04             	mov    0x4(%eax),%eax
  802a93:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 40 04             	mov    0x4(%eax),%eax
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	74 0f                	je     802ab1 <alloc_block_NF+0x289>
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 04             	mov    0x4(%eax),%eax
  802aa8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aab:	8b 12                	mov    (%edx),%edx
  802aad:	89 10                	mov    %edx,(%eax)
  802aaf:	eb 0a                	jmp    802abb <alloc_block_NF+0x293>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	a3 38 51 80 00       	mov    %eax,0x805138
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ace:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad3:	48                   	dec    %eax
  802ad4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 08             	mov    0x8(%eax),%eax
  802adf:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	e9 07 03 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af5:	0f 86 d4 00 00 00    	jbe    802bcf <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802afb:	a1 48 51 80 00       	mov    0x805148,%eax
  802b00:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 50 08             	mov    0x8(%eax),%edx
  802b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b12:	8b 55 08             	mov    0x8(%ebp),%edx
  802b15:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b1c:	75 17                	jne    802b35 <alloc_block_NF+0x30d>
  802b1e:	83 ec 04             	sub    $0x4,%esp
  802b21:	68 c0 40 80 00       	push   $0x8040c0
  802b26:	68 04 01 00 00       	push   $0x104
  802b2b:	68 17 40 80 00       	push   $0x804017
  802b30:	e8 f1 d7 ff ff       	call   800326 <_panic>
  802b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	85 c0                	test   %eax,%eax
  802b3c:	74 10                	je     802b4e <alloc_block_NF+0x326>
  802b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b41:	8b 00                	mov    (%eax),%eax
  802b43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b46:	8b 52 04             	mov    0x4(%edx),%edx
  802b49:	89 50 04             	mov    %edx,0x4(%eax)
  802b4c:	eb 0b                	jmp    802b59 <alloc_block_NF+0x331>
  802b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b51:	8b 40 04             	mov    0x4(%eax),%eax
  802b54:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0f                	je     802b72 <alloc_block_NF+0x34a>
  802b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b6c:	8b 12                	mov    (%edx),%edx
  802b6e:	89 10                	mov    %edx,(%eax)
  802b70:	eb 0a                	jmp    802b7c <alloc_block_NF+0x354>
  802b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b94:	48                   	dec    %eax
  802b95:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ba0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 50 08             	mov    0x8(%eax),%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	01 c2                	add    %eax,%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbf:	89 c2                	mov    %eax,%edx
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bca:	e9 24 02 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bcf:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bdb:	74 07                	je     802be4 <alloc_block_NF+0x3bc>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	eb 05                	jmp    802be9 <alloc_block_NF+0x3c1>
  802be4:	b8 00 00 00 00       	mov    $0x0,%eax
  802be9:	a3 40 51 80 00       	mov    %eax,0x805140
  802bee:	a1 40 51 80 00       	mov    0x805140,%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	0f 85 2b fe ff ff    	jne    802a26 <alloc_block_NF+0x1fe>
  802bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bff:	0f 85 21 fe ff ff    	jne    802a26 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c05:	a1 38 51 80 00       	mov    0x805138,%eax
  802c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0d:	e9 ae 01 00 00       	jmp    802dc0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 50 08             	mov    0x8(%eax),%edx
  802c18:	a1 28 50 80 00       	mov    0x805028,%eax
  802c1d:	39 c2                	cmp    %eax,%edx
  802c1f:	0f 83 93 01 00 00    	jae    802db8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2e:	0f 82 84 01 00 00    	jb     802db8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3d:	0f 85 95 00 00 00    	jne    802cd8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c47:	75 17                	jne    802c60 <alloc_block_NF+0x438>
  802c49:	83 ec 04             	sub    $0x4,%esp
  802c4c:	68 c0 40 80 00       	push   $0x8040c0
  802c51:	68 14 01 00 00       	push   $0x114
  802c56:	68 17 40 80 00       	push   $0x804017
  802c5b:	e8 c6 d6 ff ff       	call   800326 <_panic>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 10                	je     802c79 <alloc_block_NF+0x451>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c71:	8b 52 04             	mov    0x4(%edx),%edx
  802c74:	89 50 04             	mov    %edx,0x4(%eax)
  802c77:	eb 0b                	jmp    802c84 <alloc_block_NF+0x45c>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 04             	mov    0x4(%eax),%eax
  802c7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 0f                	je     802c9d <alloc_block_NF+0x475>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c97:	8b 12                	mov    (%edx),%edx
  802c99:	89 10                	mov    %edx,(%eax)
  802c9b:	eb 0a                	jmp    802ca7 <alloc_block_NF+0x47f>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cba:	a1 44 51 80 00       	mov    0x805144,%eax
  802cbf:	48                   	dec    %eax
  802cc0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 08             	mov    0x8(%eax),%eax
  802ccb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	e9 1b 01 00 00       	jmp    802df3 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cde:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce1:	0f 86 d1 00 00 00    	jbe    802db8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ce7:	a1 48 51 80 00       	mov    0x805148,%eax
  802cec:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802d01:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d08:	75 17                	jne    802d21 <alloc_block_NF+0x4f9>
  802d0a:	83 ec 04             	sub    $0x4,%esp
  802d0d:	68 c0 40 80 00       	push   $0x8040c0
  802d12:	68 1c 01 00 00       	push   $0x11c
  802d17:	68 17 40 80 00       	push   $0x804017
  802d1c:	e8 05 d6 ff ff       	call   800326 <_panic>
  802d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d24:	8b 00                	mov    (%eax),%eax
  802d26:	85 c0                	test   %eax,%eax
  802d28:	74 10                	je     802d3a <alloc_block_NF+0x512>
  802d2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d32:	8b 52 04             	mov    0x4(%edx),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 0b                	jmp    802d45 <alloc_block_NF+0x51d>
  802d3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	8b 40 04             	mov    0x4(%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 0f                	je     802d5e <alloc_block_NF+0x536>
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d58:	8b 12                	mov    (%edx),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 0a                	jmp    802d68 <alloc_block_NF+0x540>
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	a3 48 51 80 00       	mov    %eax,0x805148
  802d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 54 51 80 00       	mov    0x805154,%eax
  802d80:	48                   	dec    %eax
  802d81:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d89:	8b 40 08             	mov    0x8(%eax),%eax
  802d8c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	01 c2                	add    %eax,%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	2b 45 08             	sub    0x8(%ebp),%eax
  802dab:	89 c2                	mov    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db6:	eb 3b                	jmp    802df3 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802db8:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc4:	74 07                	je     802dcd <alloc_block_NF+0x5a5>
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	eb 05                	jmp    802dd2 <alloc_block_NF+0x5aa>
  802dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd2:	a3 40 51 80 00       	mov    %eax,0x805140
  802dd7:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	0f 85 2e fe ff ff    	jne    802c12 <alloc_block_NF+0x3ea>
  802de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de8:	0f 85 24 fe ff ff    	jne    802c12 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df3:	c9                   	leave  
  802df4:	c3                   	ret    

00802df5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
  802df8:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dfb:	a1 38 51 80 00       	mov    0x805138,%eax
  802e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e03:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e08:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	74 14                	je     802e28 <insert_sorted_with_merge_freeList+0x33>
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 50 08             	mov    0x8(%eax),%edx
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	8b 40 08             	mov    0x8(%eax),%eax
  802e20:	39 c2                	cmp    %eax,%edx
  802e22:	0f 87 9b 01 00 00    	ja     802fc3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2c:	75 17                	jne    802e45 <insert_sorted_with_merge_freeList+0x50>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 f4 3f 80 00       	push   $0x803ff4
  802e36:	68 38 01 00 00       	push   $0x138
  802e3b:	68 17 40 80 00       	push   $0x804017
  802e40:	e8 e1 d4 ff ff       	call   800326 <_panic>
  802e45:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 0d                	je     802e66 <insert_sorted_with_merge_freeList+0x71>
  802e59:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e61:	89 50 04             	mov    %edx,0x4(%eax)
  802e64:	eb 08                	jmp    802e6e <insert_sorted_with_merge_freeList+0x79>
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	a3 38 51 80 00       	mov    %eax,0x805138
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e80:	a1 44 51 80 00       	mov    0x805144,%eax
  802e85:	40                   	inc    %eax
  802e86:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e8f:	0f 84 a8 06 00 00    	je     80353d <insert_sorted_with_merge_freeList+0x748>
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea1:	01 c2                	add    %eax,%edx
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	0f 85 8c 06 00 00    	jne    80353d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	01 c2                	add    %eax,%edx
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0xed>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 c0 40 80 00       	push   $0x8040c0
  802ed3:	68 3c 01 00 00       	push   $0x13c
  802ed8:	68 17 40 80 00       	push   $0x804017
  802edd:	e8 44 d4 ff ff       	call   800326 <_panic>
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 10                	je     802efb <insert_sorted_with_merge_freeList+0x106>
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef3:	8b 52 04             	mov    0x4(%edx),%edx
  802ef6:	89 50 04             	mov    %edx,0x4(%eax)
  802ef9:	eb 0b                	jmp    802f06 <insert_sorted_with_merge_freeList+0x111>
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0f                	je     802f1f <insert_sorted_with_merge_freeList+0x12a>
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	8b 40 04             	mov    0x4(%eax),%eax
  802f16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f19:	8b 12                	mov    (%edx),%edx
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	eb 0a                	jmp    802f29 <insert_sorted_with_merge_freeList+0x134>
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	a3 38 51 80 00       	mov    %eax,0x805138
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f41:	48                   	dec    %eax
  802f42:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f5f:	75 17                	jne    802f78 <insert_sorted_with_merge_freeList+0x183>
  802f61:	83 ec 04             	sub    $0x4,%esp
  802f64:	68 f4 3f 80 00       	push   $0x803ff4
  802f69:	68 3f 01 00 00       	push   $0x13f
  802f6e:	68 17 40 80 00       	push   $0x804017
  802f73:	e8 ae d3 ff ff       	call   800326 <_panic>
  802f78:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f86:	8b 00                	mov    (%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 0d                	je     802f99 <insert_sorted_with_merge_freeList+0x1a4>
  802f8c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f94:	89 50 04             	mov    %edx,0x4(%eax)
  802f97:	eb 08                	jmp    802fa1 <insert_sorted_with_merge_freeList+0x1ac>
  802f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb3:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb8:	40                   	inc    %eax
  802fb9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fbe:	e9 7a 05 00 00       	jmp    80353d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcc:	8b 40 08             	mov    0x8(%eax),%eax
  802fcf:	39 c2                	cmp    %eax,%edx
  802fd1:	0f 82 14 01 00 00    	jb     8030eb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fda:	8b 50 08             	mov    0x8(%eax),%edx
  802fdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	01 c2                	add    %eax,%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 08             	mov    0x8(%eax),%eax
  802feb:	39 c2                	cmp    %eax,%edx
  802fed:	0f 85 90 00 00 00    	jne    803083 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fff:	01 c2                	add    %eax,%edx
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80301b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301f:	75 17                	jne    803038 <insert_sorted_with_merge_freeList+0x243>
  803021:	83 ec 04             	sub    $0x4,%esp
  803024:	68 f4 3f 80 00       	push   $0x803ff4
  803029:	68 49 01 00 00       	push   $0x149
  80302e:	68 17 40 80 00       	push   $0x804017
  803033:	e8 ee d2 ff ff       	call   800326 <_panic>
  803038:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	89 10                	mov    %edx,(%eax)
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0d                	je     803059 <insert_sorted_with_merge_freeList+0x264>
  80304c:	a1 48 51 80 00       	mov    0x805148,%eax
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	89 50 04             	mov    %edx,0x4(%eax)
  803057:	eb 08                	jmp    803061 <insert_sorted_with_merge_freeList+0x26c>
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	a3 48 51 80 00       	mov    %eax,0x805148
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803073:	a1 54 51 80 00       	mov    0x805154,%eax
  803078:	40                   	inc    %eax
  803079:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80307e:	e9 bb 04 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x2ab>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 68 40 80 00       	push   $0x804068
  803091:	68 4c 01 00 00       	push   $0x14c
  803096:	68 17 40 80 00       	push   $0x804017
  80309b:	e8 86 d2 ff ff       	call   800326 <_panic>
  8030a0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	8b 40 04             	mov    0x4(%eax),%eax
  8030b2:	85 c0                	test   %eax,%eax
  8030b4:	74 0c                	je     8030c2 <insert_sorted_with_merge_freeList+0x2cd>
  8030b6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	eb 08                	jmp    8030ca <insert_sorted_with_merge_freeList+0x2d5>
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030db:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e0:	40                   	inc    %eax
  8030e1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e6:	e9 53 04 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f3:	e9 15 04 00 00       	jmp    80350d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	8b 00                	mov    (%eax),%eax
  8030fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 86 f1 03 00 00    	jbe    803505 <insert_sorted_with_merge_freeList+0x710>
  803114:	8b 45 08             	mov    0x8(%ebp),%eax
  803117:	8b 50 08             	mov    0x8(%eax),%edx
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 40 08             	mov    0x8(%eax),%eax
  803120:	39 c2                	cmp    %eax,%edx
  803122:	0f 83 dd 03 00 00    	jae    803505 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 50 08             	mov    0x8(%eax),%edx
  80312e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803131:	8b 40 0c             	mov    0xc(%eax),%eax
  803134:	01 c2                	add    %eax,%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 40 08             	mov    0x8(%eax),%eax
  80313c:	39 c2                	cmp    %eax,%edx
  80313e:	0f 85 b9 01 00 00    	jne    8032fd <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 40 0c             	mov    0xc(%eax),%eax
  803150:	01 c2                	add    %eax,%edx
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 40 08             	mov    0x8(%eax),%eax
  803158:	39 c2                	cmp    %eax,%edx
  80315a:	0f 85 0d 01 00 00    	jne    80326d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803163:	8b 50 0c             	mov    0xc(%eax),%edx
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 40 0c             	mov    0xc(%eax),%eax
  80316c:	01 c2                	add    %eax,%edx
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803174:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803178:	75 17                	jne    803191 <insert_sorted_with_merge_freeList+0x39c>
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	68 c0 40 80 00       	push   $0x8040c0
  803182:	68 5c 01 00 00       	push   $0x15c
  803187:	68 17 40 80 00       	push   $0x804017
  80318c:	e8 95 d1 ff ff       	call   800326 <_panic>
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 10                	je     8031aa <insert_sorted_with_merge_freeList+0x3b5>
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a2:	8b 52 04             	mov    0x4(%edx),%edx
  8031a5:	89 50 04             	mov    %edx,0x4(%eax)
  8031a8:	eb 0b                	jmp    8031b5 <insert_sorted_with_merge_freeList+0x3c0>
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 04             	mov    0x4(%eax),%eax
  8031b0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	74 0f                	je     8031ce <insert_sorted_with_merge_freeList+0x3d9>
  8031bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c8:	8b 12                	mov    (%edx),%edx
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	eb 0a                	jmp    8031d8 <insert_sorted_with_merge_freeList+0x3e3>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 00                	mov    (%eax),%eax
  8031d3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031eb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f0:	48                   	dec    %eax
  8031f1:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803200:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803203:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80320a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80320e:	75 17                	jne    803227 <insert_sorted_with_merge_freeList+0x432>
  803210:	83 ec 04             	sub    $0x4,%esp
  803213:	68 f4 3f 80 00       	push   $0x803ff4
  803218:	68 5f 01 00 00       	push   $0x15f
  80321d:	68 17 40 80 00       	push   $0x804017
  803222:	e8 ff d0 ff ff       	call   800326 <_panic>
  803227:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80322d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0d                	je     803248 <insert_sorted_with_merge_freeList+0x453>
  80323b:	a1 48 51 80 00       	mov    0x805148,%eax
  803240:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	eb 08                	jmp    803250 <insert_sorted_with_merge_freeList+0x45b>
  803248:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	a3 48 51 80 00       	mov    %eax,0x805148
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 54 51 80 00       	mov    0x805154,%eax
  803267:	40                   	inc    %eax
  803268:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 50 0c             	mov    0xc(%eax),%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	8b 40 0c             	mov    0xc(%eax),%eax
  803279:	01 c2                	add    %eax,%edx
  80327b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803281:	8b 45 08             	mov    0x8(%ebp),%eax
  803284:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803299:	75 17                	jne    8032b2 <insert_sorted_with_merge_freeList+0x4bd>
  80329b:	83 ec 04             	sub    $0x4,%esp
  80329e:	68 f4 3f 80 00       	push   $0x803ff4
  8032a3:	68 64 01 00 00       	push   $0x164
  8032a8:	68 17 40 80 00       	push   $0x804017
  8032ad:	e8 74 d0 ff ff       	call   800326 <_panic>
  8032b2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	85 c0                	test   %eax,%eax
  8032c4:	74 0d                	je     8032d3 <insert_sorted_with_merge_freeList+0x4de>
  8032c6:	a1 48 51 80 00       	mov    0x805148,%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	eb 08                	jmp    8032db <insert_sorted_with_merge_freeList+0x4e6>
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	a3 48 51 80 00       	mov    %eax,0x805148
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ed:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f2:	40                   	inc    %eax
  8032f3:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032f8:	e9 41 02 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 50 08             	mov    0x8(%eax),%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	8b 40 0c             	mov    0xc(%eax),%eax
  803309:	01 c2                	add    %eax,%edx
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	8b 40 08             	mov    0x8(%eax),%eax
  803311:	39 c2                	cmp    %eax,%edx
  803313:	0f 85 7c 01 00 00    	jne    803495 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803319:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80331d:	74 06                	je     803325 <insert_sorted_with_merge_freeList+0x530>
  80331f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803323:	75 17                	jne    80333c <insert_sorted_with_merge_freeList+0x547>
  803325:	83 ec 04             	sub    $0x4,%esp
  803328:	68 30 40 80 00       	push   $0x804030
  80332d:	68 69 01 00 00       	push   $0x169
  803332:	68 17 40 80 00       	push   $0x804017
  803337:	e8 ea cf ff ff       	call   800326 <_panic>
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	8b 50 04             	mov    0x4(%eax),%edx
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334e:	89 10                	mov    %edx,(%eax)
  803350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803353:	8b 40 04             	mov    0x4(%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0d                	je     803367 <insert_sorted_with_merge_freeList+0x572>
  80335a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335d:	8b 40 04             	mov    0x4(%eax),%eax
  803360:	8b 55 08             	mov    0x8(%ebp),%edx
  803363:	89 10                	mov    %edx,(%eax)
  803365:	eb 08                	jmp    80336f <insert_sorted_with_merge_freeList+0x57a>
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	a3 38 51 80 00       	mov    %eax,0x805138
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	8b 55 08             	mov    0x8(%ebp),%edx
  803375:	89 50 04             	mov    %edx,0x4(%eax)
  803378:	a1 44 51 80 00       	mov    0x805144,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	8b 50 0c             	mov    0xc(%eax),%edx
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 40 0c             	mov    0xc(%eax),%eax
  80338f:	01 c2                	add    %eax,%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803397:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80339b:	75 17                	jne    8033b4 <insert_sorted_with_merge_freeList+0x5bf>
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	68 c0 40 80 00       	push   $0x8040c0
  8033a5:	68 6b 01 00 00       	push   $0x16b
  8033aa:	68 17 40 80 00       	push   $0x804017
  8033af:	e8 72 cf ff ff       	call   800326 <_panic>
  8033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b7:	8b 00                	mov    (%eax),%eax
  8033b9:	85 c0                	test   %eax,%eax
  8033bb:	74 10                	je     8033cd <insert_sorted_with_merge_freeList+0x5d8>
  8033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c5:	8b 52 04             	mov    0x4(%edx),%edx
  8033c8:	89 50 04             	mov    %edx,0x4(%eax)
  8033cb:	eb 0b                	jmp    8033d8 <insert_sorted_with_merge_freeList+0x5e3>
  8033cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033db:	8b 40 04             	mov    0x4(%eax),%eax
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	74 0f                	je     8033f1 <insert_sorted_with_merge_freeList+0x5fc>
  8033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e5:	8b 40 04             	mov    0x4(%eax),%eax
  8033e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033eb:	8b 12                	mov    (%edx),%edx
  8033ed:	89 10                	mov    %edx,(%eax)
  8033ef:	eb 0a                	jmp    8033fb <insert_sorted_with_merge_freeList+0x606>
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340e:	a1 44 51 80 00       	mov    0x805144,%eax
  803413:	48                   	dec    %eax
  803414:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803423:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803426:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80342d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803431:	75 17                	jne    80344a <insert_sorted_with_merge_freeList+0x655>
  803433:	83 ec 04             	sub    $0x4,%esp
  803436:	68 f4 3f 80 00       	push   $0x803ff4
  80343b:	68 6e 01 00 00       	push   $0x16e
  803440:	68 17 40 80 00       	push   $0x804017
  803445:	e8 dc ce ff ff       	call   800326 <_panic>
  80344a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803450:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803453:	89 10                	mov    %edx,(%eax)
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	8b 00                	mov    (%eax),%eax
  80345a:	85 c0                	test   %eax,%eax
  80345c:	74 0d                	je     80346b <insert_sorted_with_merge_freeList+0x676>
  80345e:	a1 48 51 80 00       	mov    0x805148,%eax
  803463:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803466:	89 50 04             	mov    %edx,0x4(%eax)
  803469:	eb 08                	jmp    803473 <insert_sorted_with_merge_freeList+0x67e>
  80346b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803476:	a3 48 51 80 00       	mov    %eax,0x805148
  80347b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803485:	a1 54 51 80 00       	mov    0x805154,%eax
  80348a:	40                   	inc    %eax
  80348b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803490:	e9 a9 00 00 00       	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803499:	74 06                	je     8034a1 <insert_sorted_with_merge_freeList+0x6ac>
  80349b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80349f:	75 17                	jne    8034b8 <insert_sorted_with_merge_freeList+0x6c3>
  8034a1:	83 ec 04             	sub    $0x4,%esp
  8034a4:	68 8c 40 80 00       	push   $0x80408c
  8034a9:	68 73 01 00 00       	push   $0x173
  8034ae:	68 17 40 80 00       	push   $0x804017
  8034b3:	e8 6e ce ff ff       	call   800326 <_panic>
  8034b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bb:	8b 10                	mov    (%eax),%edx
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	89 10                	mov    %edx,(%eax)
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	8b 00                	mov    (%eax),%eax
  8034c7:	85 c0                	test   %eax,%eax
  8034c9:	74 0b                	je     8034d6 <insert_sorted_with_merge_freeList+0x6e1>
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	8b 00                	mov    (%eax),%eax
  8034d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d3:	89 50 04             	mov    %edx,0x4(%eax)
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034dc:	89 10                	mov    %edx,(%eax)
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 00                	mov    (%eax),%eax
  8034ec:	85 c0                	test   %eax,%eax
  8034ee:	75 08                	jne    8034f8 <insert_sorted_with_merge_freeList+0x703>
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034fd:	40                   	inc    %eax
  8034fe:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803503:	eb 39                	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803505:	a1 40 51 80 00       	mov    0x805140,%eax
  80350a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80350d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803511:	74 07                	je     80351a <insert_sorted_with_merge_freeList+0x725>
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	8b 00                	mov    (%eax),%eax
  803518:	eb 05                	jmp    80351f <insert_sorted_with_merge_freeList+0x72a>
  80351a:	b8 00 00 00 00       	mov    $0x0,%eax
  80351f:	a3 40 51 80 00       	mov    %eax,0x805140
  803524:	a1 40 51 80 00       	mov    0x805140,%eax
  803529:	85 c0                	test   %eax,%eax
  80352b:	0f 85 c7 fb ff ff    	jne    8030f8 <insert_sorted_with_merge_freeList+0x303>
  803531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803535:	0f 85 bd fb ff ff    	jne    8030f8 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80353b:	eb 01                	jmp    80353e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80353d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80353e:	90                   	nop
  80353f:	c9                   	leave  
  803540:	c3                   	ret    

00803541 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803541:	55                   	push   %ebp
  803542:	89 e5                	mov    %esp,%ebp
  803544:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803547:	8b 55 08             	mov    0x8(%ebp),%edx
  80354a:	89 d0                	mov    %edx,%eax
  80354c:	c1 e0 02             	shl    $0x2,%eax
  80354f:	01 d0                	add    %edx,%eax
  803551:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803558:	01 d0                	add    %edx,%eax
  80355a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803561:	01 d0                	add    %edx,%eax
  803563:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80356a:	01 d0                	add    %edx,%eax
  80356c:	c1 e0 04             	shl    $0x4,%eax
  80356f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803572:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803579:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80357c:	83 ec 0c             	sub    $0xc,%esp
  80357f:	50                   	push   %eax
  803580:	e8 26 e7 ff ff       	call   801cab <sys_get_virtual_time>
  803585:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803588:	eb 41                	jmp    8035cb <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80358a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80358d:	83 ec 0c             	sub    $0xc,%esp
  803590:	50                   	push   %eax
  803591:	e8 15 e7 ff ff       	call   801cab <sys_get_virtual_time>
  803596:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803599:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80359c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80359f:	29 c2                	sub    %eax,%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8035a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035ac:	89 d1                	mov    %edx,%ecx
  8035ae:	29 c1                	sub    %eax,%ecx
  8035b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8035b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035b6:	39 c2                	cmp    %eax,%edx
  8035b8:	0f 97 c0             	seta   %al
  8035bb:	0f b6 c0             	movzbl %al,%eax
  8035be:	29 c1                	sub    %eax,%ecx
  8035c0:	89 c8                	mov    %ecx,%eax
  8035c2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8035c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8035d1:	72 b7                	jb     80358a <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8035d3:	90                   	nop
  8035d4:	c9                   	leave  
  8035d5:	c3                   	ret    

008035d6 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8035d6:	55                   	push   %ebp
  8035d7:	89 e5                	mov    %esp,%ebp
  8035d9:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8035dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8035e3:	eb 03                	jmp    8035e8 <busy_wait+0x12>
  8035e5:	ff 45 fc             	incl   -0x4(%ebp)
  8035e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035ee:	72 f5                	jb     8035e5 <busy_wait+0xf>
	return i;
  8035f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8035f3:	c9                   	leave  
  8035f4:	c3                   	ret    
  8035f5:	66 90                	xchg   %ax,%ax
  8035f7:	90                   	nop

008035f8 <__udivdi3>:
  8035f8:	55                   	push   %ebp
  8035f9:	57                   	push   %edi
  8035fa:	56                   	push   %esi
  8035fb:	53                   	push   %ebx
  8035fc:	83 ec 1c             	sub    $0x1c,%esp
  8035ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803603:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803607:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80360f:	89 ca                	mov    %ecx,%edx
  803611:	89 f8                	mov    %edi,%eax
  803613:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803617:	85 f6                	test   %esi,%esi
  803619:	75 2d                	jne    803648 <__udivdi3+0x50>
  80361b:	39 cf                	cmp    %ecx,%edi
  80361d:	77 65                	ja     803684 <__udivdi3+0x8c>
  80361f:	89 fd                	mov    %edi,%ebp
  803621:	85 ff                	test   %edi,%edi
  803623:	75 0b                	jne    803630 <__udivdi3+0x38>
  803625:	b8 01 00 00 00       	mov    $0x1,%eax
  80362a:	31 d2                	xor    %edx,%edx
  80362c:	f7 f7                	div    %edi
  80362e:	89 c5                	mov    %eax,%ebp
  803630:	31 d2                	xor    %edx,%edx
  803632:	89 c8                	mov    %ecx,%eax
  803634:	f7 f5                	div    %ebp
  803636:	89 c1                	mov    %eax,%ecx
  803638:	89 d8                	mov    %ebx,%eax
  80363a:	f7 f5                	div    %ebp
  80363c:	89 cf                	mov    %ecx,%edi
  80363e:	89 fa                	mov    %edi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	39 ce                	cmp    %ecx,%esi
  80364a:	77 28                	ja     803674 <__udivdi3+0x7c>
  80364c:	0f bd fe             	bsr    %esi,%edi
  80364f:	83 f7 1f             	xor    $0x1f,%edi
  803652:	75 40                	jne    803694 <__udivdi3+0x9c>
  803654:	39 ce                	cmp    %ecx,%esi
  803656:	72 0a                	jb     803662 <__udivdi3+0x6a>
  803658:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80365c:	0f 87 9e 00 00 00    	ja     803700 <__udivdi3+0x108>
  803662:	b8 01 00 00 00       	mov    $0x1,%eax
  803667:	89 fa                	mov    %edi,%edx
  803669:	83 c4 1c             	add    $0x1c,%esp
  80366c:	5b                   	pop    %ebx
  80366d:	5e                   	pop    %esi
  80366e:	5f                   	pop    %edi
  80366f:	5d                   	pop    %ebp
  803670:	c3                   	ret    
  803671:	8d 76 00             	lea    0x0(%esi),%esi
  803674:	31 ff                	xor    %edi,%edi
  803676:	31 c0                	xor    %eax,%eax
  803678:	89 fa                	mov    %edi,%edx
  80367a:	83 c4 1c             	add    $0x1c,%esp
  80367d:	5b                   	pop    %ebx
  80367e:	5e                   	pop    %esi
  80367f:	5f                   	pop    %edi
  803680:	5d                   	pop    %ebp
  803681:	c3                   	ret    
  803682:	66 90                	xchg   %ax,%ax
  803684:	89 d8                	mov    %ebx,%eax
  803686:	f7 f7                	div    %edi
  803688:	31 ff                	xor    %edi,%edi
  80368a:	89 fa                	mov    %edi,%edx
  80368c:	83 c4 1c             	add    $0x1c,%esp
  80368f:	5b                   	pop    %ebx
  803690:	5e                   	pop    %esi
  803691:	5f                   	pop    %edi
  803692:	5d                   	pop    %ebp
  803693:	c3                   	ret    
  803694:	bd 20 00 00 00       	mov    $0x20,%ebp
  803699:	89 eb                	mov    %ebp,%ebx
  80369b:	29 fb                	sub    %edi,%ebx
  80369d:	89 f9                	mov    %edi,%ecx
  80369f:	d3 e6                	shl    %cl,%esi
  8036a1:	89 c5                	mov    %eax,%ebp
  8036a3:	88 d9                	mov    %bl,%cl
  8036a5:	d3 ed                	shr    %cl,%ebp
  8036a7:	89 e9                	mov    %ebp,%ecx
  8036a9:	09 f1                	or     %esi,%ecx
  8036ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036af:	89 f9                	mov    %edi,%ecx
  8036b1:	d3 e0                	shl    %cl,%eax
  8036b3:	89 c5                	mov    %eax,%ebp
  8036b5:	89 d6                	mov    %edx,%esi
  8036b7:	88 d9                	mov    %bl,%cl
  8036b9:	d3 ee                	shr    %cl,%esi
  8036bb:	89 f9                	mov    %edi,%ecx
  8036bd:	d3 e2                	shl    %cl,%edx
  8036bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c3:	88 d9                	mov    %bl,%cl
  8036c5:	d3 e8                	shr    %cl,%eax
  8036c7:	09 c2                	or     %eax,%edx
  8036c9:	89 d0                	mov    %edx,%eax
  8036cb:	89 f2                	mov    %esi,%edx
  8036cd:	f7 74 24 0c          	divl   0xc(%esp)
  8036d1:	89 d6                	mov    %edx,%esi
  8036d3:	89 c3                	mov    %eax,%ebx
  8036d5:	f7 e5                	mul    %ebp
  8036d7:	39 d6                	cmp    %edx,%esi
  8036d9:	72 19                	jb     8036f4 <__udivdi3+0xfc>
  8036db:	74 0b                	je     8036e8 <__udivdi3+0xf0>
  8036dd:	89 d8                	mov    %ebx,%eax
  8036df:	31 ff                	xor    %edi,%edi
  8036e1:	e9 58 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  8036e6:	66 90                	xchg   %ax,%ax
  8036e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036ec:	89 f9                	mov    %edi,%ecx
  8036ee:	d3 e2                	shl    %cl,%edx
  8036f0:	39 c2                	cmp    %eax,%edx
  8036f2:	73 e9                	jae    8036dd <__udivdi3+0xe5>
  8036f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036f7:	31 ff                	xor    %edi,%edi
  8036f9:	e9 40 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  8036fe:	66 90                	xchg   %ax,%ax
  803700:	31 c0                	xor    %eax,%eax
  803702:	e9 37 ff ff ff       	jmp    80363e <__udivdi3+0x46>
  803707:	90                   	nop

00803708 <__umoddi3>:
  803708:	55                   	push   %ebp
  803709:	57                   	push   %edi
  80370a:	56                   	push   %esi
  80370b:	53                   	push   %ebx
  80370c:	83 ec 1c             	sub    $0x1c,%esp
  80370f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803713:	8b 74 24 34          	mov    0x34(%esp),%esi
  803717:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80371b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80371f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803723:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803727:	89 f3                	mov    %esi,%ebx
  803729:	89 fa                	mov    %edi,%edx
  80372b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80372f:	89 34 24             	mov    %esi,(%esp)
  803732:	85 c0                	test   %eax,%eax
  803734:	75 1a                	jne    803750 <__umoddi3+0x48>
  803736:	39 f7                	cmp    %esi,%edi
  803738:	0f 86 a2 00 00 00    	jbe    8037e0 <__umoddi3+0xd8>
  80373e:	89 c8                	mov    %ecx,%eax
  803740:	89 f2                	mov    %esi,%edx
  803742:	f7 f7                	div    %edi
  803744:	89 d0                	mov    %edx,%eax
  803746:	31 d2                	xor    %edx,%edx
  803748:	83 c4 1c             	add    $0x1c,%esp
  80374b:	5b                   	pop    %ebx
  80374c:	5e                   	pop    %esi
  80374d:	5f                   	pop    %edi
  80374e:	5d                   	pop    %ebp
  80374f:	c3                   	ret    
  803750:	39 f0                	cmp    %esi,%eax
  803752:	0f 87 ac 00 00 00    	ja     803804 <__umoddi3+0xfc>
  803758:	0f bd e8             	bsr    %eax,%ebp
  80375b:	83 f5 1f             	xor    $0x1f,%ebp
  80375e:	0f 84 ac 00 00 00    	je     803810 <__umoddi3+0x108>
  803764:	bf 20 00 00 00       	mov    $0x20,%edi
  803769:	29 ef                	sub    %ebp,%edi
  80376b:	89 fe                	mov    %edi,%esi
  80376d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803771:	89 e9                	mov    %ebp,%ecx
  803773:	d3 e0                	shl    %cl,%eax
  803775:	89 d7                	mov    %edx,%edi
  803777:	89 f1                	mov    %esi,%ecx
  803779:	d3 ef                	shr    %cl,%edi
  80377b:	09 c7                	or     %eax,%edi
  80377d:	89 e9                	mov    %ebp,%ecx
  80377f:	d3 e2                	shl    %cl,%edx
  803781:	89 14 24             	mov    %edx,(%esp)
  803784:	89 d8                	mov    %ebx,%eax
  803786:	d3 e0                	shl    %cl,%eax
  803788:	89 c2                	mov    %eax,%edx
  80378a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80378e:	d3 e0                	shl    %cl,%eax
  803790:	89 44 24 04          	mov    %eax,0x4(%esp)
  803794:	8b 44 24 08          	mov    0x8(%esp),%eax
  803798:	89 f1                	mov    %esi,%ecx
  80379a:	d3 e8                	shr    %cl,%eax
  80379c:	09 d0                	or     %edx,%eax
  80379e:	d3 eb                	shr    %cl,%ebx
  8037a0:	89 da                	mov    %ebx,%edx
  8037a2:	f7 f7                	div    %edi
  8037a4:	89 d3                	mov    %edx,%ebx
  8037a6:	f7 24 24             	mull   (%esp)
  8037a9:	89 c6                	mov    %eax,%esi
  8037ab:	89 d1                	mov    %edx,%ecx
  8037ad:	39 d3                	cmp    %edx,%ebx
  8037af:	0f 82 87 00 00 00    	jb     80383c <__umoddi3+0x134>
  8037b5:	0f 84 91 00 00 00    	je     80384c <__umoddi3+0x144>
  8037bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037bf:	29 f2                	sub    %esi,%edx
  8037c1:	19 cb                	sbb    %ecx,%ebx
  8037c3:	89 d8                	mov    %ebx,%eax
  8037c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037c9:	d3 e0                	shl    %cl,%eax
  8037cb:	89 e9                	mov    %ebp,%ecx
  8037cd:	d3 ea                	shr    %cl,%edx
  8037cf:	09 d0                	or     %edx,%eax
  8037d1:	89 e9                	mov    %ebp,%ecx
  8037d3:	d3 eb                	shr    %cl,%ebx
  8037d5:	89 da                	mov    %ebx,%edx
  8037d7:	83 c4 1c             	add    $0x1c,%esp
  8037da:	5b                   	pop    %ebx
  8037db:	5e                   	pop    %esi
  8037dc:	5f                   	pop    %edi
  8037dd:	5d                   	pop    %ebp
  8037de:	c3                   	ret    
  8037df:	90                   	nop
  8037e0:	89 fd                	mov    %edi,%ebp
  8037e2:	85 ff                	test   %edi,%edi
  8037e4:	75 0b                	jne    8037f1 <__umoddi3+0xe9>
  8037e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037eb:	31 d2                	xor    %edx,%edx
  8037ed:	f7 f7                	div    %edi
  8037ef:	89 c5                	mov    %eax,%ebp
  8037f1:	89 f0                	mov    %esi,%eax
  8037f3:	31 d2                	xor    %edx,%edx
  8037f5:	f7 f5                	div    %ebp
  8037f7:	89 c8                	mov    %ecx,%eax
  8037f9:	f7 f5                	div    %ebp
  8037fb:	89 d0                	mov    %edx,%eax
  8037fd:	e9 44 ff ff ff       	jmp    803746 <__umoddi3+0x3e>
  803802:	66 90                	xchg   %ax,%ax
  803804:	89 c8                	mov    %ecx,%eax
  803806:	89 f2                	mov    %esi,%edx
  803808:	83 c4 1c             	add    $0x1c,%esp
  80380b:	5b                   	pop    %ebx
  80380c:	5e                   	pop    %esi
  80380d:	5f                   	pop    %edi
  80380e:	5d                   	pop    %ebp
  80380f:	c3                   	ret    
  803810:	3b 04 24             	cmp    (%esp),%eax
  803813:	72 06                	jb     80381b <__umoddi3+0x113>
  803815:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803819:	77 0f                	ja     80382a <__umoddi3+0x122>
  80381b:	89 f2                	mov    %esi,%edx
  80381d:	29 f9                	sub    %edi,%ecx
  80381f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803823:	89 14 24             	mov    %edx,(%esp)
  803826:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80382a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80382e:	8b 14 24             	mov    (%esp),%edx
  803831:	83 c4 1c             	add    $0x1c,%esp
  803834:	5b                   	pop    %ebx
  803835:	5e                   	pop    %esi
  803836:	5f                   	pop    %edi
  803837:	5d                   	pop    %ebp
  803838:	c3                   	ret    
  803839:	8d 76 00             	lea    0x0(%esi),%esi
  80383c:	2b 04 24             	sub    (%esp),%eax
  80383f:	19 fa                	sbb    %edi,%edx
  803841:	89 d1                	mov    %edx,%ecx
  803843:	89 c6                	mov    %eax,%esi
  803845:	e9 71 ff ff ff       	jmp    8037bb <__umoddi3+0xb3>
  80384a:	66 90                	xchg   %ax,%ax
  80384c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803850:	72 ea                	jb     80383c <__umoddi3+0x134>
  803852:	89 d9                	mov    %ebx,%ecx
  803854:	e9 62 ff ff ff       	jmp    8037bb <__umoddi3+0xb3>
