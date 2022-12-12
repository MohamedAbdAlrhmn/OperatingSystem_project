
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
  800045:	68 e0 36 80 00       	push   $0x8036e0
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
  800069:	68 e2 36 80 00       	push   $0x8036e2
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
  8000a6:	68 e9 36 80 00       	push   $0x8036e9
  8000ab:	e8 9b 18 00 00       	call   80194b <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 eb 36 80 00       	push   $0x8036eb
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
  8000ec:	68 f9 36 80 00       	push   $0x8036f9
  8000f1:	e8 66 19 00 00       	call   801a5c <sys_create_env>
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
  800115:	68 03 37 80 00       	push   $0x803703
  80011a:	e8 3d 19 00 00       	call   801a5c <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 0d 37 80 00       	push   $0x80370d
  800139:	6a 27                	push   $0x27
  80013b:	68 22 37 80 00       	push   $0x803722
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 2a 19 00 00       	call   801a7a <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 4c 32 00 00       	call   8033ac <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 0c 19 00 00       	call   801a7a <sys_run_env>
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
  800185:	68 3d 37 80 00       	push   $0x80373d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 4c 19 00 00       	call   801ae3 <sys_getparentenvid>
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
  8001aa:	68 eb 36 80 00       	push   $0x8036eb
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 8f 14 00 00       	call   801646 <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 ce 18 00 00       	call   801a96 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 c0 18 00 00       	call   801a96 <sys_destroy_env>
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
  8001f0:	e8 d5 18 00 00       	call   801aca <sys_getenvindex>
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
  80025b:	e8 77 16 00 00       	call   8018d7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 6c 37 80 00       	push   $0x80376c
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
  80028b:	68 94 37 80 00       	push   $0x803794
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
  8002bc:	68 bc 37 80 00       	push   $0x8037bc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 14 38 80 00       	push   $0x803814
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 6c 37 80 00       	push   $0x80376c
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 f7 15 00 00       	call   8018f1 <sys_enable_interrupt>

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
  80030d:	e8 84 17 00 00       	call   801a96 <sys_destroy_env>
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
  80031e:	e8 d9 17 00 00       	call   801afc <sys_exit_env>
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
  800347:	68 28 38 80 00       	push   $0x803828
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 2d 38 80 00       	push   $0x80382d
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
  800384:	68 49 38 80 00       	push   $0x803849
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
  8003b0:	68 4c 38 80 00       	push   $0x80384c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 98 38 80 00       	push   $0x803898
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
  800482:	68 a4 38 80 00       	push   $0x8038a4
  800487:	6a 3a                	push   $0x3a
  800489:	68 98 38 80 00       	push   $0x803898
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
  8004f2:	68 f8 38 80 00       	push   $0x8038f8
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 98 38 80 00       	push   $0x803898
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
  80054c:	e8 d8 11 00 00       	call   801729 <sys_cputs>
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
  8005c3:	e8 61 11 00 00       	call   801729 <sys_cputs>
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
  80060d:	e8 c5 12 00 00       	call   8018d7 <sys_disable_interrupt>
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
  80062d:	e8 bf 12 00 00       	call   8018f1 <sys_enable_interrupt>
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
  800677:	e8 e4 2d 00 00       	call   803460 <__udivdi3>
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
  8006c7:	e8 a4 2e 00 00       	call   803570 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 74 3b 80 00       	add    $0x803b74,%eax
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
  800822:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
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
  800903:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 85 3b 80 00       	push   $0x803b85
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
  800928:	68 8e 3b 80 00       	push   $0x803b8e
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
  800955:	be 91 3b 80 00       	mov    $0x803b91,%esi
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
  80137b:	68 f0 3c 80 00       	push   $0x803cf0
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
  80144b:	e8 1d 04 00 00       	call   80186d <sys_allocate_chunk>
  801450:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801453:	a1 20 41 80 00       	mov    0x804120,%eax
  801458:	83 ec 0c             	sub    $0xc,%esp
  80145b:	50                   	push   %eax
  80145c:	e8 92 0a 00 00       	call   801ef3 <initialize_MemBlocksList>
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
  801489:	68 15 3d 80 00       	push   $0x803d15
  80148e:	6a 33                	push   $0x33
  801490:	68 33 3d 80 00       	push   $0x803d33
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
  801508:	68 40 3d 80 00       	push   $0x803d40
  80150d:	6a 34                	push   $0x34
  80150f:	68 33 3d 80 00       	push   $0x803d33
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
  80157d:	68 64 3d 80 00       	push   $0x803d64
  801582:	6a 46                	push   $0x46
  801584:	68 33 3d 80 00       	push   $0x803d33
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
  801599:	68 8c 3d 80 00       	push   $0x803d8c
  80159e:	6a 61                	push   $0x61
  8015a0:	68 33 3d 80 00       	push   $0x803d33
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
  8015bf:	75 07                	jne    8015c8 <smalloc+0x1e>
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c6:	eb 7c                	jmp    801644 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015c8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	01 d0                	add    %edx,%eax
  8015d7:	48                   	dec    %eax
  8015d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015de:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e3:	f7 75 f0             	divl   -0x10(%ebp)
  8015e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e9:	29 d0                	sub    %edx,%eax
  8015eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8015ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f5:	e8 41 06 00 00       	call   801c3b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	74 11                	je     80160f <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	ff 75 e8             	pushl  -0x18(%ebp)
  801604:	e8 ac 0c 00 00       	call   8022b5 <alloc_block_FF>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80160f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801613:	74 2a                	je     80163f <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801618:	8b 40 08             	mov    0x8(%eax),%eax
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801621:	52                   	push   %edx
  801622:	50                   	push   %eax
  801623:	ff 75 0c             	pushl  0xc(%ebp)
  801626:	ff 75 08             	pushl  0x8(%ebp)
  801629:	e8 92 03 00 00       	call   8019c0 <sys_createSharedObject>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801634:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801638:	74 05                	je     80163f <smalloc+0x95>
			return (void*)virtual_address;
  80163a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163d:	eb 05                	jmp    801644 <smalloc+0x9a>
	}
	return NULL;
  80163f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801644:	c9                   	leave  
  801645:	c3                   	ret    

00801646 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164c:	e8 13 fd ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801651:	83 ec 04             	sub    $0x4,%esp
  801654:	68 b0 3d 80 00       	push   $0x803db0
  801659:	68 a2 00 00 00       	push   $0xa2
  80165e:	68 33 3d 80 00       	push   $0x803d33
  801663:	e8 be ec ff ff       	call   800326 <_panic>

00801668 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166e:	e8 f1 fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	68 d4 3d 80 00       	push   $0x803dd4
  80167b:	68 e6 00 00 00       	push   $0xe6
  801680:	68 33 3d 80 00       	push   $0x803d33
  801685:	e8 9c ec ff ff       	call   800326 <_panic>

0080168a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801690:	83 ec 04             	sub    $0x4,%esp
  801693:	68 fc 3d 80 00       	push   $0x803dfc
  801698:	68 fa 00 00 00       	push   $0xfa
  80169d:	68 33 3d 80 00       	push   $0x803d33
  8016a2:	e8 7f ec ff ff       	call   800326 <_panic>

008016a7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	68 20 3e 80 00       	push   $0x803e20
  8016b5:	68 05 01 00 00       	push   $0x105
  8016ba:	68 33 3d 80 00       	push   $0x803d33
  8016bf:	e8 62 ec ff ff       	call   800326 <_panic>

008016c4 <shrink>:

}
void shrink(uint32 newSize)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ca:	83 ec 04             	sub    $0x4,%esp
  8016cd:	68 20 3e 80 00       	push   $0x803e20
  8016d2:	68 0a 01 00 00       	push   $0x10a
  8016d7:	68 33 3d 80 00       	push   $0x803d33
  8016dc:	e8 45 ec ff ff       	call   800326 <_panic>

008016e1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016e7:	83 ec 04             	sub    $0x4,%esp
  8016ea:	68 20 3e 80 00       	push   $0x803e20
  8016ef:	68 0f 01 00 00       	push   $0x10f
  8016f4:	68 33 3d 80 00       	push   $0x803d33
  8016f9:	e8 28 ec ff ff       	call   800326 <_panic>

008016fe <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	57                   	push   %edi
  801702:	56                   	push   %esi
  801703:	53                   	push   %ebx
  801704:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801710:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801713:	8b 7d 18             	mov    0x18(%ebp),%edi
  801716:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801719:	cd 30                	int    $0x30
  80171b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5f                   	pop    %edi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801735:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	52                   	push   %edx
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	50                   	push   %eax
  801745:	6a 00                	push   $0x0
  801747:	e8 b2 ff ff ff       	call   8016fe <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	90                   	nop
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_cgetc>:

int
sys_cgetc(void)
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 01                	push   $0x1
  801761:	e8 98 ff ff ff       	call   8016fe <syscall>
  801766:	83 c4 18             	add    $0x18,%esp
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80176e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	52                   	push   %edx
  80177b:	50                   	push   %eax
  80177c:	6a 05                	push   $0x5
  80177e:	e8 7b ff ff ff       	call   8016fe <syscall>
  801783:	83 c4 18             	add    $0x18,%esp
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	56                   	push   %esi
  80178c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80178d:	8b 75 18             	mov    0x18(%ebp),%esi
  801790:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801793:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801796:	8b 55 0c             	mov    0xc(%ebp),%edx
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	56                   	push   %esi
  80179d:	53                   	push   %ebx
  80179e:	51                   	push   %ecx
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	6a 06                	push   $0x6
  8017a3:	e8 56 ff ff ff       	call   8016fe <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ae:	5b                   	pop    %ebx
  8017af:	5e                   	pop    %esi
  8017b0:	5d                   	pop    %ebp
  8017b1:	c3                   	ret    

008017b2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	52                   	push   %edx
  8017c2:	50                   	push   %eax
  8017c3:	6a 07                	push   $0x7
  8017c5:	e8 34 ff ff ff       	call   8016fe <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	ff 75 08             	pushl  0x8(%ebp)
  8017de:	6a 08                	push   $0x8
  8017e0:	e8 19 ff ff ff       	call   8016fe <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 09                	push   $0x9
  8017f9:	e8 00 ff ff ff       	call   8016fe <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 0a                	push   $0xa
  801812:	e8 e7 fe ff ff       	call   8016fe <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 0b                	push   $0xb
  80182b:	e8 ce fe ff ff       	call   8016fe <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	ff 75 08             	pushl  0x8(%ebp)
  801844:	6a 0f                	push   $0xf
  801846:	e8 b3 fe ff ff       	call   8016fe <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
	return;
  80184e:	90                   	nop
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	ff 75 08             	pushl  0x8(%ebp)
  801860:	6a 10                	push   $0x10
  801862:	e8 97 fe ff ff       	call   8016fe <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
	return ;
  80186a:	90                   	nop
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	ff 75 10             	pushl  0x10(%ebp)
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	6a 11                	push   $0x11
  80187f:	e8 7a fe ff ff       	call   8016fe <syscall>
  801884:	83 c4 18             	add    $0x18,%esp
	return ;
  801887:	90                   	nop
}
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 0c                	push   $0xc
  801899:	e8 60 fe ff ff       	call   8016fe <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 0d                	push   $0xd
  8018b3:	e8 46 fe ff ff       	call   8016fe <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 0e                	push   $0xe
  8018cc:	e8 2d fe ff ff       	call   8016fe <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 13                	push   $0x13
  8018e6:	e8 13 fe ff ff       	call   8016fe <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	90                   	nop
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 14                	push   $0x14
  801900:	e8 f9 fd ff ff       	call   8016fe <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_cputc>:


void
sys_cputc(const char c)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801917:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	50                   	push   %eax
  801924:	6a 15                	push   $0x15
  801926:	e8 d3 fd ff ff       	call   8016fe <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	90                   	nop
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 16                	push   $0x16
  801940:	e8 b9 fd ff ff       	call   8016fe <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	90                   	nop
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80194e:	8b 45 08             	mov    0x8(%ebp),%eax
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	50                   	push   %eax
  80195b:	6a 17                	push   $0x17
  80195d:	e8 9c fd ff ff       	call   8016fe <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	6a 1a                	push   $0x1a
  80197a:	e8 7f fd ff ff       	call   8016fe <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	52                   	push   %edx
  801994:	50                   	push   %eax
  801995:	6a 18                	push   $0x18
  801997:	e8 62 fd ff ff       	call   8016fe <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	90                   	nop
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 19                	push   $0x19
  8019b5:	e8 44 fd ff ff       	call   8016fe <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019cc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019cf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	51                   	push   %ecx
  8019d9:	52                   	push   %edx
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	50                   	push   %eax
  8019de:	6a 1b                	push   $0x1b
  8019e0:	e8 19 fd ff ff       	call   8016fe <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	52                   	push   %edx
  8019fa:	50                   	push   %eax
  8019fb:	6a 1c                	push   $0x1c
  8019fd:	e8 fc fc ff ff       	call   8016fe <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	51                   	push   %ecx
  801a18:	52                   	push   %edx
  801a19:	50                   	push   %eax
  801a1a:	6a 1d                	push   $0x1d
  801a1c:	e8 dd fc ff ff       	call   8016fe <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	52                   	push   %edx
  801a36:	50                   	push   %eax
  801a37:	6a 1e                	push   $0x1e
  801a39:	e8 c0 fc ff ff       	call   8016fe <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 1f                	push   $0x1f
  801a52:	e8 a7 fc ff ff       	call   8016fe <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 14             	pushl  0x14(%ebp)
  801a67:	ff 75 10             	pushl  0x10(%ebp)
  801a6a:	ff 75 0c             	pushl  0xc(%ebp)
  801a6d:	50                   	push   %eax
  801a6e:	6a 20                	push   $0x20
  801a70:	e8 89 fc ff ff       	call   8016fe <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	50                   	push   %eax
  801a89:	6a 21                	push   $0x21
  801a8b:	e8 6e fc ff ff       	call   8016fe <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	90                   	nop
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	50                   	push   %eax
  801aa5:	6a 22                	push   $0x22
  801aa7:	e8 52 fc ff ff       	call   8016fe <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 02                	push   $0x2
  801ac0:	e8 39 fc ff ff       	call   8016fe <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 03                	push   $0x3
  801ad9:	e8 20 fc ff ff       	call   8016fe <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 04                	push   $0x4
  801af2:	e8 07 fc ff ff       	call   8016fe <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_exit_env>:


void sys_exit_env(void)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 23                	push   $0x23
  801b0b:	e8 ee fb ff ff       	call   8016fe <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	90                   	nop
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b1c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b1f:	8d 50 04             	lea    0x4(%eax),%edx
  801b22:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	52                   	push   %edx
  801b2c:	50                   	push   %eax
  801b2d:	6a 24                	push   $0x24
  801b2f:	e8 ca fb ff ff       	call   8016fe <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
	return result;
  801b37:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b40:	89 01                	mov    %eax,(%ecx)
  801b42:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	c9                   	leave  
  801b49:	c2 04 00             	ret    $0x4

00801b4c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	ff 75 10             	pushl  0x10(%ebp)
  801b56:	ff 75 0c             	pushl  0xc(%ebp)
  801b59:	ff 75 08             	pushl  0x8(%ebp)
  801b5c:	6a 12                	push   $0x12
  801b5e:	e8 9b fb ff ff       	call   8016fe <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
	return ;
  801b66:	90                   	nop
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 25                	push   $0x25
  801b78:	e8 81 fb ff ff       	call   8016fe <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b8e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	50                   	push   %eax
  801b9b:	6a 26                	push   $0x26
  801b9d:	e8 5c fb ff ff       	call   8016fe <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba5:	90                   	nop
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <rsttst>:
void rsttst()
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 28                	push   $0x28
  801bb7:	e8 42 fb ff ff       	call   8016fe <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbf:	90                   	nop
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
  801bc5:	83 ec 04             	sub    $0x4,%esp
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bce:	8b 55 18             	mov    0x18(%ebp),%edx
  801bd1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bd5:	52                   	push   %edx
  801bd6:	50                   	push   %eax
  801bd7:	ff 75 10             	pushl  0x10(%ebp)
  801bda:	ff 75 0c             	pushl  0xc(%ebp)
  801bdd:	ff 75 08             	pushl  0x8(%ebp)
  801be0:	6a 27                	push   $0x27
  801be2:	e8 17 fb ff ff       	call   8016fe <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bea:	90                   	nop
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <chktst>:
void chktst(uint32 n)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	6a 29                	push   $0x29
  801bfd:	e8 fc fa ff ff       	call   8016fe <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
	return ;
  801c05:	90                   	nop
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <inctst>:

void inctst()
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 2a                	push   $0x2a
  801c17:	e8 e2 fa ff ff       	call   8016fe <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1f:	90                   	nop
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <gettst>:
uint32 gettst()
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 2b                	push   $0x2b
  801c31:	e8 c8 fa ff ff       	call   8016fe <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 2c                	push   $0x2c
  801c4d:	e8 ac fa ff ff       	call   8016fe <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
  801c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c58:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c5c:	75 07                	jne    801c65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c63:	eb 05                	jmp    801c6a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 2c                	push   $0x2c
  801c7e:	e8 7b fa ff ff       	call   8016fe <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
  801c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c89:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c8d:	75 07                	jne    801c96 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c94:	eb 05                	jmp    801c9b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 2c                	push   $0x2c
  801caf:	e8 4a fa ff ff       	call   8016fe <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
  801cb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cba:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cbe:	75 07                	jne    801cc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc5:	eb 05                	jmp    801ccc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 2c                	push   $0x2c
  801ce0:	e8 19 fa ff ff       	call   8016fe <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
  801ce8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ceb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cef:	75 07                	jne    801cf8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cf1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf6:	eb 05                	jmp    801cfd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	ff 75 08             	pushl  0x8(%ebp)
  801d0d:	6a 2d                	push   $0x2d
  801d0f:	e8 ea f9 ff ff       	call   8016fe <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
	return ;
  801d17:	90                   	nop
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d1e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d21:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	53                   	push   %ebx
  801d2d:	51                   	push   %ecx
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 2e                	push   $0x2e
  801d32:	e8 c7 f9 ff ff       	call   8016fe <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
}
  801d3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	6a 2f                	push   $0x2f
  801d52:	e8 a7 f9 ff ff       	call   8016fe <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d62:	83 ec 0c             	sub    $0xc,%esp
  801d65:	68 30 3e 80 00       	push   $0x803e30
  801d6a:	e8 6b e8 ff ff       	call   8005da <cprintf>
  801d6f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d72:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d79:	83 ec 0c             	sub    $0xc,%esp
  801d7c:	68 5c 3e 80 00       	push   $0x803e5c
  801d81:	e8 54 e8 ff ff       	call   8005da <cprintf>
  801d86:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d89:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d8d:	a1 38 41 80 00       	mov    0x804138,%eax
  801d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d95:	eb 56                	jmp    801ded <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9b:	74 1c                	je     801db9 <print_mem_block_lists+0x5d>
  801d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da0:	8b 50 08             	mov    0x8(%eax),%edx
  801da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da6:	8b 48 08             	mov    0x8(%eax),%ecx
  801da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dac:	8b 40 0c             	mov    0xc(%eax),%eax
  801daf:	01 c8                	add    %ecx,%eax
  801db1:	39 c2                	cmp    %eax,%edx
  801db3:	73 04                	jae    801db9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801db5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 50 08             	mov    0x8(%eax),%edx
  801dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc5:	01 c2                	add    %eax,%edx
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	8b 40 08             	mov    0x8(%eax),%eax
  801dcd:	83 ec 04             	sub    $0x4,%esp
  801dd0:	52                   	push   %edx
  801dd1:	50                   	push   %eax
  801dd2:	68 71 3e 80 00       	push   $0x803e71
  801dd7:	e8 fe e7 ff ff       	call   8005da <cprintf>
  801ddc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801de5:	a1 40 41 80 00       	mov    0x804140,%eax
  801dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df1:	74 07                	je     801dfa <print_mem_block_lists+0x9e>
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	8b 00                	mov    (%eax),%eax
  801df8:	eb 05                	jmp    801dff <print_mem_block_lists+0xa3>
  801dfa:	b8 00 00 00 00       	mov    $0x0,%eax
  801dff:	a3 40 41 80 00       	mov    %eax,0x804140
  801e04:	a1 40 41 80 00       	mov    0x804140,%eax
  801e09:	85 c0                	test   %eax,%eax
  801e0b:	75 8a                	jne    801d97 <print_mem_block_lists+0x3b>
  801e0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e11:	75 84                	jne    801d97 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e13:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e17:	75 10                	jne    801e29 <print_mem_block_lists+0xcd>
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	68 80 3e 80 00       	push   $0x803e80
  801e21:	e8 b4 e7 ff ff       	call   8005da <cprintf>
  801e26:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e30:	83 ec 0c             	sub    $0xc,%esp
  801e33:	68 a4 3e 80 00       	push   $0x803ea4
  801e38:	e8 9d e7 ff ff       	call   8005da <cprintf>
  801e3d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e40:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e44:	a1 40 40 80 00       	mov    0x804040,%eax
  801e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4c:	eb 56                	jmp    801ea4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e52:	74 1c                	je     801e70 <print_mem_block_lists+0x114>
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 50 08             	mov    0x8(%eax),%edx
  801e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e63:	8b 40 0c             	mov    0xc(%eax),%eax
  801e66:	01 c8                	add    %ecx,%eax
  801e68:	39 c2                	cmp    %eax,%edx
  801e6a:	73 04                	jae    801e70 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e6c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	8b 50 08             	mov    0x8(%eax),%edx
  801e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e79:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7c:	01 c2                	add    %eax,%edx
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	8b 40 08             	mov    0x8(%eax),%eax
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	52                   	push   %edx
  801e88:	50                   	push   %eax
  801e89:	68 71 3e 80 00       	push   $0x803e71
  801e8e:	e8 47 e7 ff ff       	call   8005da <cprintf>
  801e93:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e9c:	a1 48 40 80 00       	mov    0x804048,%eax
  801ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea8:	74 07                	je     801eb1 <print_mem_block_lists+0x155>
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	8b 00                	mov    (%eax),%eax
  801eaf:	eb 05                	jmp    801eb6 <print_mem_block_lists+0x15a>
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	a3 48 40 80 00       	mov    %eax,0x804048
  801ebb:	a1 48 40 80 00       	mov    0x804048,%eax
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	75 8a                	jne    801e4e <print_mem_block_lists+0xf2>
  801ec4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec8:	75 84                	jne    801e4e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eca:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ece:	75 10                	jne    801ee0 <print_mem_block_lists+0x184>
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	68 bc 3e 80 00       	push   $0x803ebc
  801ed8:	e8 fd e6 ff ff       	call   8005da <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 30 3e 80 00       	push   $0x803e30
  801ee8:	e8 ed e6 ff ff       	call   8005da <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp

}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ef9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f00:	00 00 00 
  801f03:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f0a:	00 00 00 
  801f0d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f14:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f1e:	e9 9e 00 00 00       	jmp    801fc1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f23:	a1 50 40 80 00       	mov    0x804050,%eax
  801f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2b:	c1 e2 04             	shl    $0x4,%edx
  801f2e:	01 d0                	add    %edx,%eax
  801f30:	85 c0                	test   %eax,%eax
  801f32:	75 14                	jne    801f48 <initialize_MemBlocksList+0x55>
  801f34:	83 ec 04             	sub    $0x4,%esp
  801f37:	68 e4 3e 80 00       	push   $0x803ee4
  801f3c:	6a 46                	push   $0x46
  801f3e:	68 07 3f 80 00       	push   $0x803f07
  801f43:	e8 de e3 ff ff       	call   800326 <_panic>
  801f48:	a1 50 40 80 00       	mov    0x804050,%eax
  801f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f50:	c1 e2 04             	shl    $0x4,%edx
  801f53:	01 d0                	add    %edx,%eax
  801f55:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f5b:	89 10                	mov    %edx,(%eax)
  801f5d:	8b 00                	mov    (%eax),%eax
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	74 18                	je     801f7b <initialize_MemBlocksList+0x88>
  801f63:	a1 48 41 80 00       	mov    0x804148,%eax
  801f68:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f6e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f71:	c1 e1 04             	shl    $0x4,%ecx
  801f74:	01 ca                	add    %ecx,%edx
  801f76:	89 50 04             	mov    %edx,0x4(%eax)
  801f79:	eb 12                	jmp    801f8d <initialize_MemBlocksList+0x9a>
  801f7b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f83:	c1 e2 04             	shl    $0x4,%edx
  801f86:	01 d0                	add    %edx,%eax
  801f88:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f8d:	a1 50 40 80 00       	mov    0x804050,%eax
  801f92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f95:	c1 e2 04             	shl    $0x4,%edx
  801f98:	01 d0                	add    %edx,%eax
  801f9a:	a3 48 41 80 00       	mov    %eax,0x804148
  801f9f:	a1 50 40 80 00       	mov    0x804050,%eax
  801fa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa7:	c1 e2 04             	shl    $0x4,%edx
  801faa:	01 d0                	add    %edx,%eax
  801fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fb3:	a1 54 41 80 00       	mov    0x804154,%eax
  801fb8:	40                   	inc    %eax
  801fb9:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fbe:	ff 45 f4             	incl   -0xc(%ebp)
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fc7:	0f 82 56 ff ff ff    	jb     801f23 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fcd:	90                   	nop
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	8b 00                	mov    (%eax),%eax
  801fdb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fde:	eb 19                	jmp    801ff9 <find_block+0x29>
	{
		if(va==point->sva)
  801fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fe9:	75 05                	jne    801ff0 <find_block+0x20>
		   return point;
  801feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fee:	eb 36                	jmp    802026 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	8b 40 08             	mov    0x8(%eax),%eax
  801ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ff9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ffd:	74 07                	je     802006 <find_block+0x36>
  801fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802002:	8b 00                	mov    (%eax),%eax
  802004:	eb 05                	jmp    80200b <find_block+0x3b>
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	8b 55 08             	mov    0x8(%ebp),%edx
  80200e:	89 42 08             	mov    %eax,0x8(%edx)
  802011:	8b 45 08             	mov    0x8(%ebp),%eax
  802014:	8b 40 08             	mov    0x8(%eax),%eax
  802017:	85 c0                	test   %eax,%eax
  802019:	75 c5                	jne    801fe0 <find_block+0x10>
  80201b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80201f:	75 bf                	jne    801fe0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80202e:	a1 40 40 80 00       	mov    0x804040,%eax
  802033:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802036:	a1 44 40 80 00       	mov    0x804044,%eax
  80203b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80203e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802041:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802044:	74 24                	je     80206a <insert_sorted_allocList+0x42>
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 50 08             	mov    0x8(%eax),%edx
  80204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204f:	8b 40 08             	mov    0x8(%eax),%eax
  802052:	39 c2                	cmp    %eax,%edx
  802054:	76 14                	jbe    80206a <insert_sorted_allocList+0x42>
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	8b 50 08             	mov    0x8(%eax),%edx
  80205c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205f:	8b 40 08             	mov    0x8(%eax),%eax
  802062:	39 c2                	cmp    %eax,%edx
  802064:	0f 82 60 01 00 00    	jb     8021ca <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80206a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206e:	75 65                	jne    8020d5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802074:	75 14                	jne    80208a <insert_sorted_allocList+0x62>
  802076:	83 ec 04             	sub    $0x4,%esp
  802079:	68 e4 3e 80 00       	push   $0x803ee4
  80207e:	6a 6b                	push   $0x6b
  802080:	68 07 3f 80 00       	push   $0x803f07
  802085:	e8 9c e2 ff ff       	call   800326 <_panic>
  80208a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	89 10                	mov    %edx,(%eax)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8b 00                	mov    (%eax),%eax
  80209a:	85 c0                	test   %eax,%eax
  80209c:	74 0d                	je     8020ab <insert_sorted_allocList+0x83>
  80209e:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a6:	89 50 04             	mov    %edx,0x4(%eax)
  8020a9:	eb 08                	jmp    8020b3 <insert_sorted_allocList+0x8b>
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	a3 40 40 80 00       	mov    %eax,0x804040
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020c5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020ca:	40                   	inc    %eax
  8020cb:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020d0:	e9 dc 01 00 00       	jmp    8022b1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 50 08             	mov    0x8(%eax),%edx
  8020db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	39 c2                	cmp    %eax,%edx
  8020e3:	77 6c                	ja     802151 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e9:	74 06                	je     8020f1 <insert_sorted_allocList+0xc9>
  8020eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ef:	75 14                	jne    802105 <insert_sorted_allocList+0xdd>
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 20 3f 80 00       	push   $0x803f20
  8020f9:	6a 6f                	push   $0x6f
  8020fb:	68 07 3f 80 00       	push   $0x803f07
  802100:	e8 21 e2 ff ff       	call   800326 <_panic>
  802105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802108:	8b 50 04             	mov    0x4(%eax),%edx
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	89 50 04             	mov    %edx,0x4(%eax)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802117:	89 10                	mov    %edx,(%eax)
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	8b 40 04             	mov    0x4(%eax),%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	74 0d                	je     802130 <insert_sorted_allocList+0x108>
  802123:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802126:	8b 40 04             	mov    0x4(%eax),%eax
  802129:	8b 55 08             	mov    0x8(%ebp),%edx
  80212c:	89 10                	mov    %edx,(%eax)
  80212e:	eb 08                	jmp    802138 <insert_sorted_allocList+0x110>
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 40 40 80 00       	mov    %eax,0x804040
  802138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213b:	8b 55 08             	mov    0x8(%ebp),%edx
  80213e:	89 50 04             	mov    %edx,0x4(%eax)
  802141:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802146:	40                   	inc    %eax
  802147:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80214c:	e9 60 01 00 00       	jmp    8022b1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 50 08             	mov    0x8(%eax),%edx
  802157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80215a:	8b 40 08             	mov    0x8(%eax),%eax
  80215d:	39 c2                	cmp    %eax,%edx
  80215f:	0f 82 4c 01 00 00    	jb     8022b1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802169:	75 14                	jne    80217f <insert_sorted_allocList+0x157>
  80216b:	83 ec 04             	sub    $0x4,%esp
  80216e:	68 58 3f 80 00       	push   $0x803f58
  802173:	6a 73                	push   $0x73
  802175:	68 07 3f 80 00       	push   $0x803f07
  80217a:	e8 a7 e1 ff ff       	call   800326 <_panic>
  80217f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8b 40 04             	mov    0x4(%eax),%eax
  802191:	85 c0                	test   %eax,%eax
  802193:	74 0c                	je     8021a1 <insert_sorted_allocList+0x179>
  802195:	a1 44 40 80 00       	mov    0x804044,%eax
  80219a:	8b 55 08             	mov    0x8(%ebp),%edx
  80219d:	89 10                	mov    %edx,(%eax)
  80219f:	eb 08                	jmp    8021a9 <insert_sorted_allocList+0x181>
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 40 40 80 00       	mov    %eax,0x804040
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021bf:	40                   	inc    %eax
  8021c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c5:	e9 e7 00 00 00       	jmp    8022b1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021df:	e9 9d 00 00 00       	jmp    802281 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 00                	mov    (%eax),%eax
  8021e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8b 50 08             	mov    0x8(%eax),%edx
  8021f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	39 c2                	cmp    %eax,%edx
  8021fa:	76 7d                	jbe    802279 <insert_sorted_allocList+0x251>
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 50 08             	mov    0x8(%eax),%edx
  802202:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802205:	8b 40 08             	mov    0x8(%eax),%eax
  802208:	39 c2                	cmp    %eax,%edx
  80220a:	73 6d                	jae    802279 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80220c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802210:	74 06                	je     802218 <insert_sorted_allocList+0x1f0>
  802212:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802216:	75 14                	jne    80222c <insert_sorted_allocList+0x204>
  802218:	83 ec 04             	sub    $0x4,%esp
  80221b:	68 7c 3f 80 00       	push   $0x803f7c
  802220:	6a 7f                	push   $0x7f
  802222:	68 07 3f 80 00       	push   $0x803f07
  802227:	e8 fa e0 ff ff       	call   800326 <_panic>
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 10                	mov    (%eax),%edx
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	89 10                	mov    %edx,(%eax)
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	8b 00                	mov    (%eax),%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	74 0b                	je     80224a <insert_sorted_allocList+0x222>
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 00                	mov    (%eax),%eax
  802244:	8b 55 08             	mov    0x8(%ebp),%edx
  802247:	89 50 04             	mov    %edx,0x4(%eax)
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 55 08             	mov    0x8(%ebp),%edx
  802250:	89 10                	mov    %edx,(%eax)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802258:	89 50 04             	mov    %edx,0x4(%eax)
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	75 08                	jne    80226c <insert_sorted_allocList+0x244>
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 44 40 80 00       	mov    %eax,0x804044
  80226c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802271:	40                   	inc    %eax
  802272:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802277:	eb 39                	jmp    8022b2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802279:	a1 48 40 80 00       	mov    0x804048,%eax
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	74 07                	je     80228e <insert_sorted_allocList+0x266>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	eb 05                	jmp    802293 <insert_sorted_allocList+0x26b>
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
  802293:	a3 48 40 80 00       	mov    %eax,0x804048
  802298:	a1 48 40 80 00       	mov    0x804048,%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	0f 85 3f ff ff ff    	jne    8021e4 <insert_sorted_allocList+0x1bc>
  8022a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a9:	0f 85 35 ff ff ff    	jne    8021e4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022af:	eb 01                	jmp    8022b2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022b2:	90                   	nop
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022bb:	a1 38 41 80 00       	mov    0x804138,%eax
  8022c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c3:	e9 85 01 00 00       	jmp    80244d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d1:	0f 82 6e 01 00 00    	jb     802445 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 0c             	mov    0xc(%eax),%eax
  8022dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e0:	0f 85 8a 00 00 00    	jne    802370 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ea:	75 17                	jne    802303 <alloc_block_FF+0x4e>
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	68 b0 3f 80 00       	push   $0x803fb0
  8022f4:	68 93 00 00 00       	push   $0x93
  8022f9:	68 07 3f 80 00       	push   $0x803f07
  8022fe:	e8 23 e0 ff ff       	call   800326 <_panic>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	85 c0                	test   %eax,%eax
  80230a:	74 10                	je     80231c <alloc_block_FF+0x67>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802314:	8b 52 04             	mov    0x4(%edx),%edx
  802317:	89 50 04             	mov    %edx,0x4(%eax)
  80231a:	eb 0b                	jmp    802327 <alloc_block_FF+0x72>
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 40 04             	mov    0x4(%eax),%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	74 0f                	je     802340 <alloc_block_FF+0x8b>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 04             	mov    0x4(%eax),%eax
  802337:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233a:	8b 12                	mov    (%edx),%edx
  80233c:	89 10                	mov    %edx,(%eax)
  80233e:	eb 0a                	jmp    80234a <alloc_block_FF+0x95>
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	a3 38 41 80 00       	mov    %eax,0x804138
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80235d:	a1 44 41 80 00       	mov    0x804144,%eax
  802362:	48                   	dec    %eax
  802363:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	e9 10 01 00 00       	jmp    802480 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 0c             	mov    0xc(%eax),%eax
  802376:	3b 45 08             	cmp    0x8(%ebp),%eax
  802379:	0f 86 c6 00 00 00    	jbe    802445 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80237f:	a1 48 41 80 00       	mov    0x804148,%eax
  802384:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 50 08             	mov    0x8(%eax),%edx
  80238d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802390:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802396:	8b 55 08             	mov    0x8(%ebp),%edx
  802399:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80239c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023a0:	75 17                	jne    8023b9 <alloc_block_FF+0x104>
  8023a2:	83 ec 04             	sub    $0x4,%esp
  8023a5:	68 b0 3f 80 00       	push   $0x803fb0
  8023aa:	68 9b 00 00 00       	push   $0x9b
  8023af:	68 07 3f 80 00       	push   $0x803f07
  8023b4:	e8 6d df ff ff       	call   800326 <_panic>
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	74 10                	je     8023d2 <alloc_block_FF+0x11d>
  8023c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ca:	8b 52 04             	mov    0x4(%edx),%edx
  8023cd:	89 50 04             	mov    %edx,0x4(%eax)
  8023d0:	eb 0b                	jmp    8023dd <alloc_block_FF+0x128>
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	8b 40 04             	mov    0x4(%eax),%eax
  8023d8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e0:	8b 40 04             	mov    0x4(%eax),%eax
  8023e3:	85 c0                	test   %eax,%eax
  8023e5:	74 0f                	je     8023f6 <alloc_block_FF+0x141>
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f0:	8b 12                	mov    (%edx),%edx
  8023f2:	89 10                	mov    %edx,(%eax)
  8023f4:	eb 0a                	jmp    802400 <alloc_block_FF+0x14b>
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	a3 48 41 80 00       	mov    %eax,0x804148
  802400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802403:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802413:	a1 54 41 80 00       	mov    0x804154,%eax
  802418:	48                   	dec    %eax
  802419:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 50 08             	mov    0x8(%eax),%edx
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	01 c2                	add    %eax,%edx
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 40 0c             	mov    0xc(%eax),%eax
  802435:	2b 45 08             	sub    0x8(%ebp),%eax
  802438:	89 c2                	mov    %eax,%edx
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	eb 3b                	jmp    802480 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802445:	a1 40 41 80 00       	mov    0x804140,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	74 07                	je     80245a <alloc_block_FF+0x1a5>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	eb 05                	jmp    80245f <alloc_block_FF+0x1aa>
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	a3 40 41 80 00       	mov    %eax,0x804140
  802464:	a1 40 41 80 00       	mov    0x804140,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	0f 85 57 fe ff ff    	jne    8022c8 <alloc_block_FF+0x13>
  802471:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802475:	0f 85 4d fe ff ff    	jne    8022c8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802488:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80248f:	a1 38 41 80 00       	mov    0x804138,%eax
  802494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802497:	e9 df 00 00 00       	jmp    80257b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a5:	0f 82 c8 00 00 00    	jb     802573 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b4:	0f 85 8a 00 00 00    	jne    802544 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	75 17                	jne    8024d7 <alloc_block_BF+0x55>
  8024c0:	83 ec 04             	sub    $0x4,%esp
  8024c3:	68 b0 3f 80 00       	push   $0x803fb0
  8024c8:	68 b7 00 00 00       	push   $0xb7
  8024cd:	68 07 3f 80 00       	push   $0x803f07
  8024d2:	e8 4f de ff ff       	call   800326 <_panic>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 00                	mov    (%eax),%eax
  8024dc:	85 c0                	test   %eax,%eax
  8024de:	74 10                	je     8024f0 <alloc_block_BF+0x6e>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e8:	8b 52 04             	mov    0x4(%edx),%edx
  8024eb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ee:	eb 0b                	jmp    8024fb <alloc_block_BF+0x79>
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 04             	mov    0x4(%eax),%eax
  8024f6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	74 0f                	je     802514 <alloc_block_BF+0x92>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250e:	8b 12                	mov    (%edx),%edx
  802510:	89 10                	mov    %edx,(%eax)
  802512:	eb 0a                	jmp    80251e <alloc_block_BF+0x9c>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	a3 38 41 80 00       	mov    %eax,0x804138
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802531:	a1 44 41 80 00       	mov    0x804144,%eax
  802536:	48                   	dec    %eax
  802537:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	e9 4d 01 00 00       	jmp    802691 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 0c             	mov    0xc(%eax),%eax
  80254a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254d:	76 24                	jbe    802573 <alloc_block_BF+0xf1>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 0c             	mov    0xc(%eax),%eax
  802555:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802558:	73 19                	jae    802573 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80255a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 0c             	mov    0xc(%eax),%eax
  802567:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 08             	mov    0x8(%eax),%eax
  802570:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802573:	a1 40 41 80 00       	mov    0x804140,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	74 07                	je     802588 <alloc_block_BF+0x106>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	eb 05                	jmp    80258d <alloc_block_BF+0x10b>
  802588:	b8 00 00 00 00       	mov    $0x0,%eax
  80258d:	a3 40 41 80 00       	mov    %eax,0x804140
  802592:	a1 40 41 80 00       	mov    0x804140,%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	0f 85 fd fe ff ff    	jne    80249c <alloc_block_BF+0x1a>
  80259f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a3:	0f 85 f3 fe ff ff    	jne    80249c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025ad:	0f 84 d9 00 00 00    	je     80268c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8025b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ca:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025d1:	75 17                	jne    8025ea <alloc_block_BF+0x168>
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	68 b0 3f 80 00       	push   $0x803fb0
  8025db:	68 c7 00 00 00       	push   $0xc7
  8025e0:	68 07 3f 80 00       	push   $0x803f07
  8025e5:	e8 3c dd ff ff       	call   800326 <_panic>
  8025ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	74 10                	je     802603 <alloc_block_BF+0x181>
  8025f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fb:	8b 52 04             	mov    0x4(%edx),%edx
  8025fe:	89 50 04             	mov    %edx,0x4(%eax)
  802601:	eb 0b                	jmp    80260e <alloc_block_BF+0x18c>
  802603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802606:	8b 40 04             	mov    0x4(%eax),%eax
  802609:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80260e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802611:	8b 40 04             	mov    0x4(%eax),%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	74 0f                	je     802627 <alloc_block_BF+0x1a5>
  802618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261b:	8b 40 04             	mov    0x4(%eax),%eax
  80261e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802621:	8b 12                	mov    (%edx),%edx
  802623:	89 10                	mov    %edx,(%eax)
  802625:	eb 0a                	jmp    802631 <alloc_block_BF+0x1af>
  802627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	a3 48 41 80 00       	mov    %eax,0x804148
  802631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802634:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802644:	a1 54 41 80 00       	mov    0x804154,%eax
  802649:	48                   	dec    %eax
  80264a:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80264f:	83 ec 08             	sub    $0x8,%esp
  802652:	ff 75 ec             	pushl  -0x14(%ebp)
  802655:	68 38 41 80 00       	push   $0x804138
  80265a:	e8 71 f9 ff ff       	call   801fd0 <find_block>
  80265f:	83 c4 10             	add    $0x10,%esp
  802662:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802668:	8b 50 08             	mov    0x8(%eax),%edx
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	01 c2                	add    %eax,%edx
  802670:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802673:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802679:	8b 40 0c             	mov    0xc(%eax),%eax
  80267c:	2b 45 08             	sub    0x8(%ebp),%eax
  80267f:	89 c2                	mov    %eax,%edx
  802681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802684:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268a:	eb 05                	jmp    802691 <alloc_block_BF+0x20f>
	}
	return NULL;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802691:	c9                   	leave  
  802692:	c3                   	ret    

00802693 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802699:	a1 28 40 80 00       	mov    0x804028,%eax
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	0f 85 de 01 00 00    	jne    802884 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ae:	e9 9e 01 00 00       	jmp    802851 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026bc:	0f 82 87 01 00 00    	jb     802849 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cb:	0f 85 95 00 00 00    	jne    802766 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	75 17                	jne    8026ee <alloc_block_NF+0x5b>
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	68 b0 3f 80 00       	push   $0x803fb0
  8026df:	68 e0 00 00 00       	push   $0xe0
  8026e4:	68 07 3f 80 00       	push   $0x803f07
  8026e9:	e8 38 dc ff ff       	call   800326 <_panic>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	74 10                	je     802707 <alloc_block_NF+0x74>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ff:	8b 52 04             	mov    0x4(%edx),%edx
  802702:	89 50 04             	mov    %edx,0x4(%eax)
  802705:	eb 0b                	jmp    802712 <alloc_block_NF+0x7f>
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 04             	mov    0x4(%eax),%eax
  802718:	85 c0                	test   %eax,%eax
  80271a:	74 0f                	je     80272b <alloc_block_NF+0x98>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	8b 12                	mov    (%edx),%edx
  802727:	89 10                	mov    %edx,(%eax)
  802729:	eb 0a                	jmp    802735 <alloc_block_NF+0xa2>
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	a3 38 41 80 00       	mov    %eax,0x804138
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802748:	a1 44 41 80 00       	mov    0x804144,%eax
  80274d:	48                   	dec    %eax
  80274e:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 08             	mov    0x8(%eax),%eax
  802759:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	e9 f8 04 00 00       	jmp    802c5e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	8b 40 0c             	mov    0xc(%eax),%eax
  80276c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80276f:	0f 86 d4 00 00 00    	jbe    802849 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802775:	a1 48 41 80 00       	mov    0x804148,%eax
  80277a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 50 08             	mov    0x8(%eax),%edx
  802783:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802786:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278c:	8b 55 08             	mov    0x8(%ebp),%edx
  80278f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802796:	75 17                	jne    8027af <alloc_block_NF+0x11c>
  802798:	83 ec 04             	sub    $0x4,%esp
  80279b:	68 b0 3f 80 00       	push   $0x803fb0
  8027a0:	68 e9 00 00 00       	push   $0xe9
  8027a5:	68 07 3f 80 00       	push   $0x803f07
  8027aa:	e8 77 db ff ff       	call   800326 <_panic>
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 10                	je     8027c8 <alloc_block_NF+0x135>
  8027b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c0:	8b 52 04             	mov    0x4(%edx),%edx
  8027c3:	89 50 04             	mov    %edx,0x4(%eax)
  8027c6:	eb 0b                	jmp    8027d3 <alloc_block_NF+0x140>
  8027c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 0f                	je     8027ec <alloc_block_NF+0x159>
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 40 04             	mov    0x4(%eax),%eax
  8027e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e6:	8b 12                	mov    (%edx),%edx
  8027e8:	89 10                	mov    %edx,(%eax)
  8027ea:	eb 0a                	jmp    8027f6 <alloc_block_NF+0x163>
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802809:	a1 54 41 80 00       	mov    0x804154,%eax
  80280e:	48                   	dec    %eax
  80280f:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	8b 40 08             	mov    0x8(%eax),%eax
  80281a:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 50 08             	mov    0x8(%eax),%edx
  802825:	8b 45 08             	mov    0x8(%ebp),%eax
  802828:	01 c2                	add    %eax,%edx
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 40 0c             	mov    0xc(%eax),%eax
  802836:	2b 45 08             	sub    0x8(%ebp),%eax
  802839:	89 c2                	mov    %eax,%edx
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802844:	e9 15 04 00 00       	jmp    802c5e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802849:	a1 40 41 80 00       	mov    0x804140,%eax
  80284e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	74 07                	je     80285e <alloc_block_NF+0x1cb>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	eb 05                	jmp    802863 <alloc_block_NF+0x1d0>
  80285e:	b8 00 00 00 00       	mov    $0x0,%eax
  802863:	a3 40 41 80 00       	mov    %eax,0x804140
  802868:	a1 40 41 80 00       	mov    0x804140,%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	0f 85 3e fe ff ff    	jne    8026b3 <alloc_block_NF+0x20>
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	0f 85 34 fe ff ff    	jne    8026b3 <alloc_block_NF+0x20>
  80287f:	e9 d5 03 00 00       	jmp    802c59 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802884:	a1 38 41 80 00       	mov    0x804138,%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288c:	e9 b1 01 00 00       	jmp    802a42 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 50 08             	mov    0x8(%eax),%edx
  802897:	a1 28 40 80 00       	mov    0x804028,%eax
  80289c:	39 c2                	cmp    %eax,%edx
  80289e:	0f 82 96 01 00 00    	jb     802a3a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ad:	0f 82 87 01 00 00    	jb     802a3a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bc:	0f 85 95 00 00 00    	jne    802957 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	75 17                	jne    8028df <alloc_block_NF+0x24c>
  8028c8:	83 ec 04             	sub    $0x4,%esp
  8028cb:	68 b0 3f 80 00       	push   $0x803fb0
  8028d0:	68 fc 00 00 00       	push   $0xfc
  8028d5:	68 07 3f 80 00       	push   $0x803f07
  8028da:	e8 47 da ff ff       	call   800326 <_panic>
  8028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	74 10                	je     8028f8 <alloc_block_NF+0x265>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	8b 52 04             	mov    0x4(%edx),%edx
  8028f3:	89 50 04             	mov    %edx,0x4(%eax)
  8028f6:	eb 0b                	jmp    802903 <alloc_block_NF+0x270>
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 40 04             	mov    0x4(%eax),%eax
  8028fe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 0f                	je     80291c <alloc_block_NF+0x289>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 04             	mov    0x4(%eax),%eax
  802913:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802916:	8b 12                	mov    (%edx),%edx
  802918:	89 10                	mov    %edx,(%eax)
  80291a:	eb 0a                	jmp    802926 <alloc_block_NF+0x293>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	a3 38 41 80 00       	mov    %eax,0x804138
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802939:	a1 44 41 80 00       	mov    0x804144,%eax
  80293e:	48                   	dec    %eax
  80293f:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 08             	mov    0x8(%eax),%eax
  80294a:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	e9 07 03 00 00       	jmp    802c5e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802960:	0f 86 d4 00 00 00    	jbe    802a3a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802966:	a1 48 41 80 00       	mov    0x804148,%eax
  80296b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 50 08             	mov    0x8(%eax),%edx
  802974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80297a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
  802980:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802983:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802987:	75 17                	jne    8029a0 <alloc_block_NF+0x30d>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 b0 3f 80 00       	push   $0x803fb0
  802991:	68 04 01 00 00       	push   $0x104
  802996:	68 07 3f 80 00       	push   $0x803f07
  80299b:	e8 86 d9 ff ff       	call   800326 <_panic>
  8029a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 10                	je     8029b9 <alloc_block_NF+0x326>
  8029a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b1:	8b 52 04             	mov    0x4(%edx),%edx
  8029b4:	89 50 04             	mov    %edx,0x4(%eax)
  8029b7:	eb 0b                	jmp    8029c4 <alloc_block_NF+0x331>
  8029b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bc:	8b 40 04             	mov    0x4(%eax),%eax
  8029bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	74 0f                	je     8029dd <alloc_block_NF+0x34a>
  8029ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029d7:	8b 12                	mov    (%edx),%edx
  8029d9:	89 10                	mov    %edx,(%eax)
  8029db:	eb 0a                	jmp    8029e7 <alloc_block_NF+0x354>
  8029dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	a3 48 41 80 00       	mov    %eax,0x804148
  8029e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fa:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ff:	48                   	dec    %eax
  802a00:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 50 08             	mov    0x8(%eax),%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	01 c2                	add    %eax,%edx
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2a:	89 c2                	mov    %eax,%edx
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a35:	e9 24 02 00 00       	jmp    802c5e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a3a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a46:	74 07                	je     802a4f <alloc_block_NF+0x3bc>
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	eb 05                	jmp    802a54 <alloc_block_NF+0x3c1>
  802a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a54:	a3 40 41 80 00       	mov    %eax,0x804140
  802a59:	a1 40 41 80 00       	mov    0x804140,%eax
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	0f 85 2b fe ff ff    	jne    802891 <alloc_block_NF+0x1fe>
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	0f 85 21 fe ff ff    	jne    802891 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a70:	a1 38 41 80 00       	mov    0x804138,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	e9 ae 01 00 00       	jmp    802c2b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 50 08             	mov    0x8(%eax),%edx
  802a83:	a1 28 40 80 00       	mov    0x804028,%eax
  802a88:	39 c2                	cmp    %eax,%edx
  802a8a:	0f 83 93 01 00 00    	jae    802c23 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a99:	0f 82 84 01 00 00    	jb     802c23 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa8:	0f 85 95 00 00 00    	jne    802b43 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab2:	75 17                	jne    802acb <alloc_block_NF+0x438>
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 b0 3f 80 00       	push   $0x803fb0
  802abc:	68 14 01 00 00       	push   $0x114
  802ac1:	68 07 3f 80 00       	push   $0x803f07
  802ac6:	e8 5b d8 ff ff       	call   800326 <_panic>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 10                	je     802ae4 <alloc_block_NF+0x451>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adc:	8b 52 04             	mov    0x4(%edx),%edx
  802adf:	89 50 04             	mov    %edx,0x4(%eax)
  802ae2:	eb 0b                	jmp    802aef <alloc_block_NF+0x45c>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 0f                	je     802b08 <alloc_block_NF+0x475>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b02:	8b 12                	mov    (%edx),%edx
  802b04:	89 10                	mov    %edx,(%eax)
  802b06:	eb 0a                	jmp    802b12 <alloc_block_NF+0x47f>
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b25:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2a:	48                   	dec    %eax
  802b2b:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 08             	mov    0x8(%eax),%eax
  802b36:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	e9 1b 01 00 00       	jmp    802c5e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	8b 40 0c             	mov    0xc(%eax),%eax
  802b49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4c:	0f 86 d1 00 00 00    	jbe    802c23 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b52:	a1 48 41 80 00       	mov    0x804148,%eax
  802b57:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 50 08             	mov    0x8(%eax),%edx
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b69:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b6f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b73:	75 17                	jne    802b8c <alloc_block_NF+0x4f9>
  802b75:	83 ec 04             	sub    $0x4,%esp
  802b78:	68 b0 3f 80 00       	push   $0x803fb0
  802b7d:	68 1c 01 00 00       	push   $0x11c
  802b82:	68 07 3f 80 00       	push   $0x803f07
  802b87:	e8 9a d7 ff ff       	call   800326 <_panic>
  802b8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	74 10                	je     802ba5 <alloc_block_NF+0x512>
  802b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b9d:	8b 52 04             	mov    0x4(%edx),%edx
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
  802ba3:	eb 0b                	jmp    802bb0 <alloc_block_NF+0x51d>
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	85 c0                	test   %eax,%eax
  802bb8:	74 0f                	je     802bc9 <alloc_block_NF+0x536>
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc3:	8b 12                	mov    (%edx),%edx
  802bc5:	89 10                	mov    %edx,(%eax)
  802bc7:	eb 0a                	jmp    802bd3 <alloc_block_NF+0x540>
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	a3 48 41 80 00       	mov    %eax,0x804148
  802bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be6:	a1 54 41 80 00       	mov    0x804154,%eax
  802beb:	48                   	dec    %eax
  802bec:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	8b 40 08             	mov    0x8(%eax),%eax
  802bf7:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 50 08             	mov    0x8(%eax),%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	01 c2                	add    %eax,%edx
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	2b 45 08             	sub    0x8(%ebp),%eax
  802c16:	89 c2                	mov    %eax,%edx
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c21:	eb 3b                	jmp    802c5e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c23:	a1 40 41 80 00       	mov    0x804140,%eax
  802c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2f:	74 07                	je     802c38 <alloc_block_NF+0x5a5>
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	eb 05                	jmp    802c3d <alloc_block_NF+0x5aa>
  802c38:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3d:	a3 40 41 80 00       	mov    %eax,0x804140
  802c42:	a1 40 41 80 00       	mov    0x804140,%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	0f 85 2e fe ff ff    	jne    802a7d <alloc_block_NF+0x3ea>
  802c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c53:	0f 85 24 fe ff ff    	jne    802a7d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c5e:	c9                   	leave  
  802c5f:	c3                   	ret    

00802c60 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
  802c63:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c66:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c6e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c73:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c76:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	74 14                	je     802c93 <insert_sorted_with_merge_freeList+0x33>
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	8b 50 08             	mov    0x8(%eax),%edx
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	8b 40 08             	mov    0x8(%eax),%eax
  802c8b:	39 c2                	cmp    %eax,%edx
  802c8d:	0f 87 9b 01 00 00    	ja     802e2e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_with_merge_freeList+0x50>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 e4 3e 80 00       	push   $0x803ee4
  802ca1:	68 38 01 00 00       	push   $0x138
  802ca6:	68 07 3f 80 00       	push   $0x803f07
  802cab:	e8 76 d6 ff ff       	call   800326 <_panic>
  802cb0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0d                	je     802cd1 <insert_sorted_with_merge_freeList+0x71>
  802cc4:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	eb 08                	jmp    802cd9 <insert_sorted_with_merge_freeList+0x79>
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf0:	40                   	inc    %eax
  802cf1:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cfa:	0f 84 a8 06 00 00    	je     8033a8 <insert_sorted_with_merge_freeList+0x748>
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 08             	mov    0x8(%eax),%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0c:	01 c2                	add    %eax,%edx
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	39 c2                	cmp    %eax,%edx
  802d16:	0f 85 8c 06 00 00    	jne    8033a8 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 0c             	mov    0xc(%eax),%eax
  802d28:	01 c2                	add    %eax,%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d34:	75 17                	jne    802d4d <insert_sorted_with_merge_freeList+0xed>
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 b0 3f 80 00       	push   $0x803fb0
  802d3e:	68 3c 01 00 00       	push   $0x13c
  802d43:	68 07 3f 80 00       	push   $0x803f07
  802d48:	e8 d9 d5 ff ff       	call   800326 <_panic>
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 10                	je     802d66 <insert_sorted_with_merge_freeList+0x106>
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5e:	8b 52 04             	mov    0x4(%edx),%edx
  802d61:	89 50 04             	mov    %edx,0x4(%eax)
  802d64:	eb 0b                	jmp    802d71 <insert_sorted_with_merge_freeList+0x111>
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	74 0f                	je     802d8a <insert_sorted_with_merge_freeList+0x12a>
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d84:	8b 12                	mov    (%edx),%edx
  802d86:	89 10                	mov    %edx,(%eax)
  802d88:	eb 0a                	jmp    802d94 <insert_sorted_with_merge_freeList+0x134>
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dac:	48                   	dec    %eax
  802dad:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dca:	75 17                	jne    802de3 <insert_sorted_with_merge_freeList+0x183>
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	68 e4 3e 80 00       	push   $0x803ee4
  802dd4:	68 3f 01 00 00       	push   $0x13f
  802dd9:	68 07 3f 80 00       	push   $0x803f07
  802dde:	e8 43 d5 ff ff       	call   800326 <_panic>
  802de3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	85 c0                	test   %eax,%eax
  802df5:	74 0d                	je     802e04 <insert_sorted_with_merge_freeList+0x1a4>
  802df7:	a1 48 41 80 00       	mov    0x804148,%eax
  802dfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dff:	89 50 04             	mov    %edx,0x4(%eax)
  802e02:	eb 08                	jmp    802e0c <insert_sorted_with_merge_freeList+0x1ac>
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e23:	40                   	inc    %eax
  802e24:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e29:	e9 7a 05 00 00       	jmp    8033a8 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 50 08             	mov    0x8(%eax),%edx
  802e34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e37:	8b 40 08             	mov    0x8(%eax),%eax
  802e3a:	39 c2                	cmp    %eax,%edx
  802e3c:	0f 82 14 01 00 00    	jb     802f56 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	8b 40 08             	mov    0x8(%eax),%eax
  802e56:	39 c2                	cmp    %eax,%edx
  802e58:	0f 85 90 00 00 00    	jne    802eee <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	8b 50 0c             	mov    0xc(%eax),%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6a:	01 c2                	add    %eax,%edx
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8a:	75 17                	jne    802ea3 <insert_sorted_with_merge_freeList+0x243>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 e4 3e 80 00       	push   $0x803ee4
  802e94:	68 49 01 00 00       	push   $0x149
  802e99:	68 07 3f 80 00       	push   $0x803f07
  802e9e:	e8 83 d4 ff ff       	call   800326 <_panic>
  802ea3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	89 10                	mov    %edx,(%eax)
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 0d                	je     802ec4 <insert_sorted_with_merge_freeList+0x264>
  802eb7:	a1 48 41 80 00       	mov    0x804148,%eax
  802ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebf:	89 50 04             	mov    %edx,0x4(%eax)
  802ec2:	eb 08                	jmp    802ecc <insert_sorted_with_merge_freeList+0x26c>
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ede:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee3:	40                   	inc    %eax
  802ee4:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee9:	e9 bb 04 00 00       	jmp    8033a9 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802eee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef2:	75 17                	jne    802f0b <insert_sorted_with_merge_freeList+0x2ab>
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 58 3f 80 00       	push   $0x803f58
  802efc:	68 4c 01 00 00       	push   $0x14c
  802f01:	68 07 3f 80 00       	push   $0x803f07
  802f06:	e8 1b d4 ff ff       	call   800326 <_panic>
  802f0b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	89 50 04             	mov    %edx,0x4(%eax)
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 40 04             	mov    0x4(%eax),%eax
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	74 0c                	je     802f2d <insert_sorted_with_merge_freeList+0x2cd>
  802f21:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f26:	8b 55 08             	mov    0x8(%ebp),%edx
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	eb 08                	jmp    802f35 <insert_sorted_with_merge_freeList+0x2d5>
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	a3 38 41 80 00       	mov    %eax,0x804138
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f46:	a1 44 41 80 00       	mov    0x804144,%eax
  802f4b:	40                   	inc    %eax
  802f4c:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f51:	e9 53 04 00 00       	jmp    8033a9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f56:	a1 38 41 80 00       	mov    0x804138,%eax
  802f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f5e:	e9 15 04 00 00       	jmp    803378 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 08             	mov    0x8(%eax),%eax
  802f77:	39 c2                	cmp    %eax,%edx
  802f79:	0f 86 f1 03 00 00    	jbe    803370 <insert_sorted_with_merge_freeList+0x710>
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 83 dd 03 00 00    	jae    803370 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9f:	01 c2                	add    %eax,%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 08             	mov    0x8(%eax),%eax
  802fa7:	39 c2                	cmp    %eax,%edx
  802fa9:	0f 85 b9 01 00 00    	jne    803168 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	8b 50 08             	mov    0x8(%eax),%edx
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbb:	01 c2                	add    %eax,%edx
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	8b 40 08             	mov    0x8(%eax),%eax
  802fc3:	39 c2                	cmp    %eax,%edx
  802fc5:	0f 85 0d 01 00 00    	jne    8030d8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 50 0c             	mov    0xc(%eax),%edx
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd7:	01 c2                	add    %eax,%edx
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fdf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe3:	75 17                	jne    802ffc <insert_sorted_with_merge_freeList+0x39c>
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 b0 3f 80 00       	push   $0x803fb0
  802fed:	68 5c 01 00 00       	push   $0x15c
  802ff2:	68 07 3f 80 00       	push   $0x803f07
  802ff7:	e8 2a d3 ff ff       	call   800326 <_panic>
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 10                	je     803015 <insert_sorted_with_merge_freeList+0x3b5>
  803005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300d:	8b 52 04             	mov    0x4(%edx),%edx
  803010:	89 50 04             	mov    %edx,0x4(%eax)
  803013:	eb 0b                	jmp    803020 <insert_sorted_with_merge_freeList+0x3c0>
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	8b 40 04             	mov    0x4(%eax),%eax
  80301b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803023:	8b 40 04             	mov    0x4(%eax),%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	74 0f                	je     803039 <insert_sorted_with_merge_freeList+0x3d9>
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803033:	8b 12                	mov    (%edx),%edx
  803035:	89 10                	mov    %edx,(%eax)
  803037:	eb 0a                	jmp    803043 <insert_sorted_with_merge_freeList+0x3e3>
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	a3 38 41 80 00       	mov    %eax,0x804138
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803056:	a1 44 41 80 00       	mov    0x804144,%eax
  80305b:	48                   	dec    %eax
  80305c:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80306b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803075:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803079:	75 17                	jne    803092 <insert_sorted_with_merge_freeList+0x432>
  80307b:	83 ec 04             	sub    $0x4,%esp
  80307e:	68 e4 3e 80 00       	push   $0x803ee4
  803083:	68 5f 01 00 00       	push   $0x15f
  803088:	68 07 3f 80 00       	push   $0x803f07
  80308d:	e8 94 d2 ff ff       	call   800326 <_panic>
  803092:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	74 0d                	je     8030b3 <insert_sorted_with_merge_freeList+0x453>
  8030a6:	a1 48 41 80 00       	mov    0x804148,%eax
  8030ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ae:	89 50 04             	mov    %edx,0x4(%eax)
  8030b1:	eb 08                	jmp    8030bb <insert_sorted_with_merge_freeList+0x45b>
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030be:	a3 48 41 80 00       	mov    %eax,0x804148
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cd:	a1 54 41 80 00       	mov    0x804154,%eax
  8030d2:	40                   	inc    %eax
  8030d3:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 50 0c             	mov    0xc(%eax),%edx
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e4:	01 c2                	add    %eax,%edx
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803100:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803104:	75 17                	jne    80311d <insert_sorted_with_merge_freeList+0x4bd>
  803106:	83 ec 04             	sub    $0x4,%esp
  803109:	68 e4 3e 80 00       	push   $0x803ee4
  80310e:	68 64 01 00 00       	push   $0x164
  803113:	68 07 3f 80 00       	push   $0x803f07
  803118:	e8 09 d2 ff ff       	call   800326 <_panic>
  80311d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	89 10                	mov    %edx,(%eax)
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	85 c0                	test   %eax,%eax
  80312f:	74 0d                	je     80313e <insert_sorted_with_merge_freeList+0x4de>
  803131:	a1 48 41 80 00       	mov    0x804148,%eax
  803136:	8b 55 08             	mov    0x8(%ebp),%edx
  803139:	89 50 04             	mov    %edx,0x4(%eax)
  80313c:	eb 08                	jmp    803146 <insert_sorted_with_merge_freeList+0x4e6>
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803146:	8b 45 08             	mov    0x8(%ebp),%eax
  803149:	a3 48 41 80 00       	mov    %eax,0x804148
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803158:	a1 54 41 80 00       	mov    0x804154,%eax
  80315d:	40                   	inc    %eax
  80315e:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803163:	e9 41 02 00 00       	jmp    8033a9 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 50 08             	mov    0x8(%eax),%edx
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	8b 40 0c             	mov    0xc(%eax),%eax
  803174:	01 c2                	add    %eax,%edx
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	8b 40 08             	mov    0x8(%eax),%eax
  80317c:	39 c2                	cmp    %eax,%edx
  80317e:	0f 85 7c 01 00 00    	jne    803300 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803188:	74 06                	je     803190 <insert_sorted_with_merge_freeList+0x530>
  80318a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318e:	75 17                	jne    8031a7 <insert_sorted_with_merge_freeList+0x547>
  803190:	83 ec 04             	sub    $0x4,%esp
  803193:	68 20 3f 80 00       	push   $0x803f20
  803198:	68 69 01 00 00       	push   $0x169
  80319d:	68 07 3f 80 00       	push   $0x803f07
  8031a2:	e8 7f d1 ff ff       	call   800326 <_panic>
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	8b 50 04             	mov    0x4(%eax),%edx
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b9:	89 10                	mov    %edx,(%eax)
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	8b 40 04             	mov    0x4(%eax),%eax
  8031c1:	85 c0                	test   %eax,%eax
  8031c3:	74 0d                	je     8031d2 <insert_sorted_with_merge_freeList+0x572>
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	eb 08                	jmp    8031da <insert_sorted_with_merge_freeList+0x57a>
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	a3 38 41 80 00       	mov    %eax,0x804138
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e0:	89 50 04             	mov    %edx,0x4(%eax)
  8031e3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031e8:	40                   	inc    %eax
  8031e9:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fa:	01 c2                	add    %eax,%edx
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803202:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803206:	75 17                	jne    80321f <insert_sorted_with_merge_freeList+0x5bf>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 b0 3f 80 00       	push   $0x803fb0
  803210:	68 6b 01 00 00       	push   $0x16b
  803215:	68 07 3f 80 00       	push   $0x803f07
  80321a:	e8 07 d1 ff ff       	call   800326 <_panic>
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 10                	je     803238 <insert_sorted_with_merge_freeList+0x5d8>
  803228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803230:	8b 52 04             	mov    0x4(%edx),%edx
  803233:	89 50 04             	mov    %edx,0x4(%eax)
  803236:	eb 0b                	jmp    803243 <insert_sorted_with_merge_freeList+0x5e3>
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 0f                	je     80325c <insert_sorted_with_merge_freeList+0x5fc>
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	8b 40 04             	mov    0x4(%eax),%eax
  803253:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803256:	8b 12                	mov    (%edx),%edx
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	eb 0a                	jmp    803266 <insert_sorted_with_merge_freeList+0x606>
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	a3 38 41 80 00       	mov    %eax,0x804138
  803266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803279:	a1 44 41 80 00       	mov    0x804144,%eax
  80327e:	48                   	dec    %eax
  80327f:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803291:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803298:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80329c:	75 17                	jne    8032b5 <insert_sorted_with_merge_freeList+0x655>
  80329e:	83 ec 04             	sub    $0x4,%esp
  8032a1:	68 e4 3e 80 00       	push   $0x803ee4
  8032a6:	68 6e 01 00 00       	push   $0x16e
  8032ab:	68 07 3f 80 00       	push   $0x803f07
  8032b0:	e8 71 d0 ff ff       	call   800326 <_panic>
  8032b5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8032bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032be:	89 10                	mov    %edx,(%eax)
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	74 0d                	je     8032d6 <insert_sorted_with_merge_freeList+0x676>
  8032c9:	a1 48 41 80 00       	mov    0x804148,%eax
  8032ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d1:	89 50 04             	mov    %edx,0x4(%eax)
  8032d4:	eb 08                	jmp    8032de <insert_sorted_with_merge_freeList+0x67e>
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8032f5:	40                   	inc    %eax
  8032f6:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8032fb:	e9 a9 00 00 00       	jmp    8033a9 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803300:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803304:	74 06                	je     80330c <insert_sorted_with_merge_freeList+0x6ac>
  803306:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330a:	75 17                	jne    803323 <insert_sorted_with_merge_freeList+0x6c3>
  80330c:	83 ec 04             	sub    $0x4,%esp
  80330f:	68 7c 3f 80 00       	push   $0x803f7c
  803314:	68 73 01 00 00       	push   $0x173
  803319:	68 07 3f 80 00       	push   $0x803f07
  80331e:	e8 03 d0 ff ff       	call   800326 <_panic>
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 10                	mov    (%eax),%edx
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	89 10                	mov    %edx,(%eax)
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	8b 00                	mov    (%eax),%eax
  803332:	85 c0                	test   %eax,%eax
  803334:	74 0b                	je     803341 <insert_sorted_with_merge_freeList+0x6e1>
  803336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	8b 55 08             	mov    0x8(%ebp),%edx
  80333e:	89 50 04             	mov    %edx,0x4(%eax)
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 55 08             	mov    0x8(%ebp),%edx
  803347:	89 10                	mov    %edx,(%eax)
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80334f:	89 50 04             	mov    %edx,0x4(%eax)
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	85 c0                	test   %eax,%eax
  803359:	75 08                	jne    803363 <insert_sorted_with_merge_freeList+0x703>
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803363:	a1 44 41 80 00       	mov    0x804144,%eax
  803368:	40                   	inc    %eax
  803369:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80336e:	eb 39                	jmp    8033a9 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803370:	a1 40 41 80 00       	mov    0x804140,%eax
  803375:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803378:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337c:	74 07                	je     803385 <insert_sorted_with_merge_freeList+0x725>
  80337e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803381:	8b 00                	mov    (%eax),%eax
  803383:	eb 05                	jmp    80338a <insert_sorted_with_merge_freeList+0x72a>
  803385:	b8 00 00 00 00       	mov    $0x0,%eax
  80338a:	a3 40 41 80 00       	mov    %eax,0x804140
  80338f:	a1 40 41 80 00       	mov    0x804140,%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	0f 85 c7 fb ff ff    	jne    802f63 <insert_sorted_with_merge_freeList+0x303>
  80339c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a0:	0f 85 bd fb ff ff    	jne    802f63 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033a6:	eb 01                	jmp    8033a9 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033a8:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033a9:	90                   	nop
  8033aa:	c9                   	leave  
  8033ab:	c3                   	ret    

008033ac <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8033ac:	55                   	push   %ebp
  8033ad:	89 e5                	mov    %esp,%ebp
  8033af:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8033b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b5:	89 d0                	mov    %edx,%eax
  8033b7:	c1 e0 02             	shl    $0x2,%eax
  8033ba:	01 d0                	add    %edx,%eax
  8033bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033c3:	01 d0                	add    %edx,%eax
  8033c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033cc:	01 d0                	add    %edx,%eax
  8033ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033d5:	01 d0                	add    %edx,%eax
  8033d7:	c1 e0 04             	shl    $0x4,%eax
  8033da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8033dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8033e4:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033e7:	83 ec 0c             	sub    $0xc,%esp
  8033ea:	50                   	push   %eax
  8033eb:	e8 26 e7 ff ff       	call   801b16 <sys_get_virtual_time>
  8033f0:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033f3:	eb 41                	jmp    803436 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033f8:	83 ec 0c             	sub    $0xc,%esp
  8033fb:	50                   	push   %eax
  8033fc:	e8 15 e7 ff ff       	call   801b16 <sys_get_virtual_time>
  803401:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803407:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340a:	29 c2                	sub    %eax,%edx
  80340c:	89 d0                	mov    %edx,%eax
  80340e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803411:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803417:	89 d1                	mov    %edx,%ecx
  803419:	29 c1                	sub    %eax,%ecx
  80341b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80341e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803421:	39 c2                	cmp    %eax,%edx
  803423:	0f 97 c0             	seta   %al
  803426:	0f b6 c0             	movzbl %al,%eax
  803429:	29 c1                	sub    %eax,%ecx
  80342b:	89 c8                	mov    %ecx,%eax
  80342d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803430:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803433:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803439:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80343c:	72 b7                	jb     8033f5 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80343e:	90                   	nop
  80343f:	c9                   	leave  
  803440:	c3                   	ret    

00803441 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803441:	55                   	push   %ebp
  803442:	89 e5                	mov    %esp,%ebp
  803444:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80344e:	eb 03                	jmp    803453 <busy_wait+0x12>
  803450:	ff 45 fc             	incl   -0x4(%ebp)
  803453:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803456:	3b 45 08             	cmp    0x8(%ebp),%eax
  803459:	72 f5                	jb     803450 <busy_wait+0xf>
	return i;
  80345b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80345e:	c9                   	leave  
  80345f:	c3                   	ret    

00803460 <__udivdi3>:
  803460:	55                   	push   %ebp
  803461:	57                   	push   %edi
  803462:	56                   	push   %esi
  803463:	53                   	push   %ebx
  803464:	83 ec 1c             	sub    $0x1c,%esp
  803467:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80346b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80346f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803473:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803477:	89 ca                	mov    %ecx,%edx
  803479:	89 f8                	mov    %edi,%eax
  80347b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80347f:	85 f6                	test   %esi,%esi
  803481:	75 2d                	jne    8034b0 <__udivdi3+0x50>
  803483:	39 cf                	cmp    %ecx,%edi
  803485:	77 65                	ja     8034ec <__udivdi3+0x8c>
  803487:	89 fd                	mov    %edi,%ebp
  803489:	85 ff                	test   %edi,%edi
  80348b:	75 0b                	jne    803498 <__udivdi3+0x38>
  80348d:	b8 01 00 00 00       	mov    $0x1,%eax
  803492:	31 d2                	xor    %edx,%edx
  803494:	f7 f7                	div    %edi
  803496:	89 c5                	mov    %eax,%ebp
  803498:	31 d2                	xor    %edx,%edx
  80349a:	89 c8                	mov    %ecx,%eax
  80349c:	f7 f5                	div    %ebp
  80349e:	89 c1                	mov    %eax,%ecx
  8034a0:	89 d8                	mov    %ebx,%eax
  8034a2:	f7 f5                	div    %ebp
  8034a4:	89 cf                	mov    %ecx,%edi
  8034a6:	89 fa                	mov    %edi,%edx
  8034a8:	83 c4 1c             	add    $0x1c,%esp
  8034ab:	5b                   	pop    %ebx
  8034ac:	5e                   	pop    %esi
  8034ad:	5f                   	pop    %edi
  8034ae:	5d                   	pop    %ebp
  8034af:	c3                   	ret    
  8034b0:	39 ce                	cmp    %ecx,%esi
  8034b2:	77 28                	ja     8034dc <__udivdi3+0x7c>
  8034b4:	0f bd fe             	bsr    %esi,%edi
  8034b7:	83 f7 1f             	xor    $0x1f,%edi
  8034ba:	75 40                	jne    8034fc <__udivdi3+0x9c>
  8034bc:	39 ce                	cmp    %ecx,%esi
  8034be:	72 0a                	jb     8034ca <__udivdi3+0x6a>
  8034c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034c4:	0f 87 9e 00 00 00    	ja     803568 <__udivdi3+0x108>
  8034ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8034cf:	89 fa                	mov    %edi,%edx
  8034d1:	83 c4 1c             	add    $0x1c,%esp
  8034d4:	5b                   	pop    %ebx
  8034d5:	5e                   	pop    %esi
  8034d6:	5f                   	pop    %edi
  8034d7:	5d                   	pop    %ebp
  8034d8:	c3                   	ret    
  8034d9:	8d 76 00             	lea    0x0(%esi),%esi
  8034dc:	31 ff                	xor    %edi,%edi
  8034de:	31 c0                	xor    %eax,%eax
  8034e0:	89 fa                	mov    %edi,%edx
  8034e2:	83 c4 1c             	add    $0x1c,%esp
  8034e5:	5b                   	pop    %ebx
  8034e6:	5e                   	pop    %esi
  8034e7:	5f                   	pop    %edi
  8034e8:	5d                   	pop    %ebp
  8034e9:	c3                   	ret    
  8034ea:	66 90                	xchg   %ax,%ax
  8034ec:	89 d8                	mov    %ebx,%eax
  8034ee:	f7 f7                	div    %edi
  8034f0:	31 ff                	xor    %edi,%edi
  8034f2:	89 fa                	mov    %edi,%edx
  8034f4:	83 c4 1c             	add    $0x1c,%esp
  8034f7:	5b                   	pop    %ebx
  8034f8:	5e                   	pop    %esi
  8034f9:	5f                   	pop    %edi
  8034fa:	5d                   	pop    %ebp
  8034fb:	c3                   	ret    
  8034fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803501:	89 eb                	mov    %ebp,%ebx
  803503:	29 fb                	sub    %edi,%ebx
  803505:	89 f9                	mov    %edi,%ecx
  803507:	d3 e6                	shl    %cl,%esi
  803509:	89 c5                	mov    %eax,%ebp
  80350b:	88 d9                	mov    %bl,%cl
  80350d:	d3 ed                	shr    %cl,%ebp
  80350f:	89 e9                	mov    %ebp,%ecx
  803511:	09 f1                	or     %esi,%ecx
  803513:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803517:	89 f9                	mov    %edi,%ecx
  803519:	d3 e0                	shl    %cl,%eax
  80351b:	89 c5                	mov    %eax,%ebp
  80351d:	89 d6                	mov    %edx,%esi
  80351f:	88 d9                	mov    %bl,%cl
  803521:	d3 ee                	shr    %cl,%esi
  803523:	89 f9                	mov    %edi,%ecx
  803525:	d3 e2                	shl    %cl,%edx
  803527:	8b 44 24 08          	mov    0x8(%esp),%eax
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 e8                	shr    %cl,%eax
  80352f:	09 c2                	or     %eax,%edx
  803531:	89 d0                	mov    %edx,%eax
  803533:	89 f2                	mov    %esi,%edx
  803535:	f7 74 24 0c          	divl   0xc(%esp)
  803539:	89 d6                	mov    %edx,%esi
  80353b:	89 c3                	mov    %eax,%ebx
  80353d:	f7 e5                	mul    %ebp
  80353f:	39 d6                	cmp    %edx,%esi
  803541:	72 19                	jb     80355c <__udivdi3+0xfc>
  803543:	74 0b                	je     803550 <__udivdi3+0xf0>
  803545:	89 d8                	mov    %ebx,%eax
  803547:	31 ff                	xor    %edi,%edi
  803549:	e9 58 ff ff ff       	jmp    8034a6 <__udivdi3+0x46>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	8b 54 24 08          	mov    0x8(%esp),%edx
  803554:	89 f9                	mov    %edi,%ecx
  803556:	d3 e2                	shl    %cl,%edx
  803558:	39 c2                	cmp    %eax,%edx
  80355a:	73 e9                	jae    803545 <__udivdi3+0xe5>
  80355c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80355f:	31 ff                	xor    %edi,%edi
  803561:	e9 40 ff ff ff       	jmp    8034a6 <__udivdi3+0x46>
  803566:	66 90                	xchg   %ax,%ax
  803568:	31 c0                	xor    %eax,%eax
  80356a:	e9 37 ff ff ff       	jmp    8034a6 <__udivdi3+0x46>
  80356f:	90                   	nop

00803570 <__umoddi3>:
  803570:	55                   	push   %ebp
  803571:	57                   	push   %edi
  803572:	56                   	push   %esi
  803573:	53                   	push   %ebx
  803574:	83 ec 1c             	sub    $0x1c,%esp
  803577:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80357b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80357f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803583:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803587:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80358b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80358f:	89 f3                	mov    %esi,%ebx
  803591:	89 fa                	mov    %edi,%edx
  803593:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803597:	89 34 24             	mov    %esi,(%esp)
  80359a:	85 c0                	test   %eax,%eax
  80359c:	75 1a                	jne    8035b8 <__umoddi3+0x48>
  80359e:	39 f7                	cmp    %esi,%edi
  8035a0:	0f 86 a2 00 00 00    	jbe    803648 <__umoddi3+0xd8>
  8035a6:	89 c8                	mov    %ecx,%eax
  8035a8:	89 f2                	mov    %esi,%edx
  8035aa:	f7 f7                	div    %edi
  8035ac:	89 d0                	mov    %edx,%eax
  8035ae:	31 d2                	xor    %edx,%edx
  8035b0:	83 c4 1c             	add    $0x1c,%esp
  8035b3:	5b                   	pop    %ebx
  8035b4:	5e                   	pop    %esi
  8035b5:	5f                   	pop    %edi
  8035b6:	5d                   	pop    %ebp
  8035b7:	c3                   	ret    
  8035b8:	39 f0                	cmp    %esi,%eax
  8035ba:	0f 87 ac 00 00 00    	ja     80366c <__umoddi3+0xfc>
  8035c0:	0f bd e8             	bsr    %eax,%ebp
  8035c3:	83 f5 1f             	xor    $0x1f,%ebp
  8035c6:	0f 84 ac 00 00 00    	je     803678 <__umoddi3+0x108>
  8035cc:	bf 20 00 00 00       	mov    $0x20,%edi
  8035d1:	29 ef                	sub    %ebp,%edi
  8035d3:	89 fe                	mov    %edi,%esi
  8035d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035d9:	89 e9                	mov    %ebp,%ecx
  8035db:	d3 e0                	shl    %cl,%eax
  8035dd:	89 d7                	mov    %edx,%edi
  8035df:	89 f1                	mov    %esi,%ecx
  8035e1:	d3 ef                	shr    %cl,%edi
  8035e3:	09 c7                	or     %eax,%edi
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 e2                	shl    %cl,%edx
  8035e9:	89 14 24             	mov    %edx,(%esp)
  8035ec:	89 d8                	mov    %ebx,%eax
  8035ee:	d3 e0                	shl    %cl,%eax
  8035f0:	89 c2                	mov    %eax,%edx
  8035f2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035f6:	d3 e0                	shl    %cl,%eax
  8035f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035fc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803600:	89 f1                	mov    %esi,%ecx
  803602:	d3 e8                	shr    %cl,%eax
  803604:	09 d0                	or     %edx,%eax
  803606:	d3 eb                	shr    %cl,%ebx
  803608:	89 da                	mov    %ebx,%edx
  80360a:	f7 f7                	div    %edi
  80360c:	89 d3                	mov    %edx,%ebx
  80360e:	f7 24 24             	mull   (%esp)
  803611:	89 c6                	mov    %eax,%esi
  803613:	89 d1                	mov    %edx,%ecx
  803615:	39 d3                	cmp    %edx,%ebx
  803617:	0f 82 87 00 00 00    	jb     8036a4 <__umoddi3+0x134>
  80361d:	0f 84 91 00 00 00    	je     8036b4 <__umoddi3+0x144>
  803623:	8b 54 24 04          	mov    0x4(%esp),%edx
  803627:	29 f2                	sub    %esi,%edx
  803629:	19 cb                	sbb    %ecx,%ebx
  80362b:	89 d8                	mov    %ebx,%eax
  80362d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803631:	d3 e0                	shl    %cl,%eax
  803633:	89 e9                	mov    %ebp,%ecx
  803635:	d3 ea                	shr    %cl,%edx
  803637:	09 d0                	or     %edx,%eax
  803639:	89 e9                	mov    %ebp,%ecx
  80363b:	d3 eb                	shr    %cl,%ebx
  80363d:	89 da                	mov    %ebx,%edx
  80363f:	83 c4 1c             	add    $0x1c,%esp
  803642:	5b                   	pop    %ebx
  803643:	5e                   	pop    %esi
  803644:	5f                   	pop    %edi
  803645:	5d                   	pop    %ebp
  803646:	c3                   	ret    
  803647:	90                   	nop
  803648:	89 fd                	mov    %edi,%ebp
  80364a:	85 ff                	test   %edi,%edi
  80364c:	75 0b                	jne    803659 <__umoddi3+0xe9>
  80364e:	b8 01 00 00 00       	mov    $0x1,%eax
  803653:	31 d2                	xor    %edx,%edx
  803655:	f7 f7                	div    %edi
  803657:	89 c5                	mov    %eax,%ebp
  803659:	89 f0                	mov    %esi,%eax
  80365b:	31 d2                	xor    %edx,%edx
  80365d:	f7 f5                	div    %ebp
  80365f:	89 c8                	mov    %ecx,%eax
  803661:	f7 f5                	div    %ebp
  803663:	89 d0                	mov    %edx,%eax
  803665:	e9 44 ff ff ff       	jmp    8035ae <__umoddi3+0x3e>
  80366a:	66 90                	xchg   %ax,%ax
  80366c:	89 c8                	mov    %ecx,%eax
  80366e:	89 f2                	mov    %esi,%edx
  803670:	83 c4 1c             	add    $0x1c,%esp
  803673:	5b                   	pop    %ebx
  803674:	5e                   	pop    %esi
  803675:	5f                   	pop    %edi
  803676:	5d                   	pop    %ebp
  803677:	c3                   	ret    
  803678:	3b 04 24             	cmp    (%esp),%eax
  80367b:	72 06                	jb     803683 <__umoddi3+0x113>
  80367d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803681:	77 0f                	ja     803692 <__umoddi3+0x122>
  803683:	89 f2                	mov    %esi,%edx
  803685:	29 f9                	sub    %edi,%ecx
  803687:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80368b:	89 14 24             	mov    %edx,(%esp)
  80368e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803692:	8b 44 24 04          	mov    0x4(%esp),%eax
  803696:	8b 14 24             	mov    (%esp),%edx
  803699:	83 c4 1c             	add    $0x1c,%esp
  80369c:	5b                   	pop    %ebx
  80369d:	5e                   	pop    %esi
  80369e:	5f                   	pop    %edi
  80369f:	5d                   	pop    %ebp
  8036a0:	c3                   	ret    
  8036a1:	8d 76 00             	lea    0x0(%esi),%esi
  8036a4:	2b 04 24             	sub    (%esp),%eax
  8036a7:	19 fa                	sbb    %edi,%edx
  8036a9:	89 d1                	mov    %edx,%ecx
  8036ab:	89 c6                	mov    %eax,%esi
  8036ad:	e9 71 ff ff ff       	jmp    803623 <__umoddi3+0xb3>
  8036b2:	66 90                	xchg   %ax,%ax
  8036b4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036b8:	72 ea                	jb     8036a4 <__umoddi3+0x134>
  8036ba:	89 d9                	mov    %ebx,%ecx
  8036bc:	e9 62 ff ff ff       	jmp    803623 <__umoddi3+0xb3>
