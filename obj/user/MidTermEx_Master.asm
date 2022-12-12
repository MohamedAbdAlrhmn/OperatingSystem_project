
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
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
  800045:	68 80 36 80 00       	push   $0x803680
  80004a:	e8 db 13 00 00       	call   80142a <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 84 36 80 00       	push   $0x803684
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 a9 36 80 00       	push   $0x8036a9
  80009f:	e8 86 13 00 00       	call   80142a <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 b0 36 80 00       	push   $0x8036b0
  8000dc:	e8 ea 16 00 00       	call   8017cb <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 b2 36 80 00       	push   $0x8036b2
  8000f0:	e8 35 13 00 00       	call   80142a <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 c0 36 80 00       	push   $0x8036c0
  80012c:	e8 ab 17 00 00       	call   8018dc <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 ca 36 80 00       	push   $0x8036ca
  80015f:	e8 78 17 00 00       	call   8018dc <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 85 17 00 00       	call   8018fa <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 77 17 00 00       	call   8018fa <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 d4 36 80 00       	push   $0x8036d4
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 c8 15 00 00       	call   80178b <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 83 15 00 00       	call   801757 <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 a4 15 00 00       	call   80178b <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 82 15 00 00       	call   801771 <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 cc 13 00 00       	call   8015d2 <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 38 15 00 00       	call   801757 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 a5 13 00 00       	call   8015d2 <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 36 15 00 00       	call   801771 <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 f5 16 00 00       	call   80194a <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 97 14 00 00       	call   801757 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 04 37 80 00       	push   $0x803704
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 2c 37 80 00       	push   $0x80372c
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 54 37 80 00       	push   $0x803754
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 ac 37 80 00       	push   $0x8037ac
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 04 37 80 00       	push   $0x803704
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 17 14 00 00       	call   801771 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 a4 15 00 00       	call   801916 <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 f9 15 00 00       	call   80197c <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 d8 11 00 00       	call   8015a9 <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 61 11 00 00       	call   8015a9 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 c5 12 00 00       	call   801757 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 bf 12 00 00       	call   801771 <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 10 2f 00 00       	call   80340c <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 d0 2f 00 00       	call   80351c <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 d4 39 80 00       	add    $0x8039d4,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 f8 39 80 00 	mov    0x8039f8(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d 40 38 80 00 	mov    0x803840(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 e5 39 80 00       	push   $0x8039e5
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 ee 39 80 00       	push   $0x8039ee
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be f1 39 80 00       	mov    $0x8039f1,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 50 3b 80 00       	push   $0x803b50
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80121b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801222:	00 00 00 
  801225:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80122c:	00 00 00 
  80122f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801236:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801239:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801240:	00 00 00 
  801243:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80124a:	00 00 00 
  80124d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801254:	00 00 00 
	uint32 arr_size = 0;
  801257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80125e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801265:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80126d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801272:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801277:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80127e:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801281:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801288:	a1 20 41 80 00       	mov    0x804120,%eax
  80128d:	c1 e0 04             	shl    $0x4,%eax
  801290:	89 c2                	mov    %eax,%edx
  801292:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801295:	01 d0                	add    %edx,%eax
  801297:	48                   	dec    %eax
  801298:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80129b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80129e:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a3:	f7 75 ec             	divl   -0x14(%ebp)
  8012a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012a9:	29 d0                	sub    %edx,%eax
  8012ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8012ae:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8012b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012bd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012c2:	83 ec 04             	sub    $0x4,%esp
  8012c5:	6a 06                	push   $0x6
  8012c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8012ca:	50                   	push   %eax
  8012cb:	e8 1d 04 00 00       	call   8016ed <sys_allocate_chunk>
  8012d0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012d3:	a1 20 41 80 00       	mov    0x804120,%eax
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	50                   	push   %eax
  8012dc:	e8 92 0a 00 00       	call   801d73 <initialize_MemBlocksList>
  8012e1:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8012e4:	a1 48 41 80 00       	mov    0x804148,%eax
  8012e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8012ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ef:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8012f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012f9:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801300:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801304:	75 14                	jne    80131a <initialize_dyn_block_system+0x105>
  801306:	83 ec 04             	sub    $0x4,%esp
  801309:	68 75 3b 80 00       	push   $0x803b75
  80130e:	6a 33                	push   $0x33
  801310:	68 93 3b 80 00       	push   $0x803b93
  801315:	e8 12 1f 00 00       	call   80322c <_panic>
  80131a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80131d:	8b 00                	mov    (%eax),%eax
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 10                	je     801333 <initialize_dyn_block_system+0x11e>
  801323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801326:	8b 00                	mov    (%eax),%eax
  801328:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80132b:	8b 52 04             	mov    0x4(%edx),%edx
  80132e:	89 50 04             	mov    %edx,0x4(%eax)
  801331:	eb 0b                	jmp    80133e <initialize_dyn_block_system+0x129>
  801333:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801336:	8b 40 04             	mov    0x4(%eax),%eax
  801339:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80133e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801341:	8b 40 04             	mov    0x4(%eax),%eax
  801344:	85 c0                	test   %eax,%eax
  801346:	74 0f                	je     801357 <initialize_dyn_block_system+0x142>
  801348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134b:	8b 40 04             	mov    0x4(%eax),%eax
  80134e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801351:	8b 12                	mov    (%edx),%edx
  801353:	89 10                	mov    %edx,(%eax)
  801355:	eb 0a                	jmp    801361 <initialize_dyn_block_system+0x14c>
  801357:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80135a:	8b 00                	mov    (%eax),%eax
  80135c:	a3 48 41 80 00       	mov    %eax,0x804148
  801361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80136a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801374:	a1 54 41 80 00       	mov    0x804154,%eax
  801379:	48                   	dec    %eax
  80137a:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80137f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801383:	75 14                	jne    801399 <initialize_dyn_block_system+0x184>
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 a0 3b 80 00       	push   $0x803ba0
  80138d:	6a 34                	push   $0x34
  80138f:	68 93 3b 80 00       	push   $0x803b93
  801394:	e8 93 1e 00 00       	call   80322c <_panic>
  801399:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80139f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a2:	89 10                	mov    %edx,(%eax)
  8013a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	74 0d                	je     8013ba <initialize_dyn_block_system+0x1a5>
  8013ad:	a1 38 41 80 00       	mov    0x804138,%eax
  8013b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013b5:	89 50 04             	mov    %edx,0x4(%eax)
  8013b8:	eb 08                	jmp    8013c2 <initialize_dyn_block_system+0x1ad>
  8013ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8013c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8013ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8013d9:	40                   	inc    %eax
  8013da:	a3 44 41 80 00       	mov    %eax,0x804144
}
  8013df:	90                   	nop
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013e8:	e8 f7 fd ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f1:	75 07                	jne    8013fa <malloc+0x18>
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f8:	eb 14                	jmp    80140e <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	68 c4 3b 80 00       	push   $0x803bc4
  801402:	6a 46                	push   $0x46
  801404:	68 93 3b 80 00       	push   $0x803b93
  801409:	e8 1e 1e 00 00       	call   80322c <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	68 ec 3b 80 00       	push   $0x803bec
  80141e:	6a 61                	push   $0x61
  801420:	68 93 3b 80 00       	push   $0x803b93
  801425:	e8 02 1e 00 00       	call   80322c <_panic>

0080142a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 38             	sub    $0x38,%esp
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801436:	e8 a9 fd ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80143b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80143f:	75 07                	jne    801448 <smalloc+0x1e>
  801441:	b8 00 00 00 00       	mov    $0x0,%eax
  801446:	eb 7c                	jmp    8014c4 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801448:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801455:	01 d0                	add    %edx,%eax
  801457:	48                   	dec    %eax
  801458:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80145b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145e:	ba 00 00 00 00       	mov    $0x0,%edx
  801463:	f7 75 f0             	divl   -0x10(%ebp)
  801466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801469:	29 d0                	sub    %edx,%eax
  80146b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80146e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801475:	e8 41 06 00 00       	call   801abb <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147a:	85 c0                	test   %eax,%eax
  80147c:	74 11                	je     80148f <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80147e:	83 ec 0c             	sub    $0xc,%esp
  801481:	ff 75 e8             	pushl  -0x18(%ebp)
  801484:	e8 ac 0c 00 00       	call   802135 <alloc_block_FF>
  801489:	83 c4 10             	add    $0x10,%esp
  80148c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80148f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801493:	74 2a                	je     8014bf <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	8b 40 08             	mov    0x8(%eax),%eax
  80149b:	89 c2                	mov    %eax,%edx
  80149d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014a1:	52                   	push   %edx
  8014a2:	50                   	push   %eax
  8014a3:	ff 75 0c             	pushl  0xc(%ebp)
  8014a6:	ff 75 08             	pushl  0x8(%ebp)
  8014a9:	e8 92 03 00 00       	call   801840 <sys_createSharedObject>
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8014b4:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8014b8:	74 05                	je     8014bf <smalloc+0x95>
			return (void*)virtual_address;
  8014ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014bd:	eb 05                	jmp    8014c4 <smalloc+0x9a>
	}
	return NULL;
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014cc:	e8 13 fd ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	68 10 3c 80 00       	push   $0x803c10
  8014d9:	68 a2 00 00 00       	push   $0xa2
  8014de:	68 93 3b 80 00       	push   $0x803b93
  8014e3:	e8 44 1d 00 00       	call   80322c <_panic>

008014e8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ee:	e8 f1 fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 34 3c 80 00       	push   $0x803c34
  8014fb:	68 e6 00 00 00       	push   $0xe6
  801500:	68 93 3b 80 00       	push   $0x803b93
  801505:	e8 22 1d 00 00       	call   80322c <_panic>

0080150a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 5c 3c 80 00       	push   $0x803c5c
  801518:	68 fa 00 00 00       	push   $0xfa
  80151d:	68 93 3b 80 00       	push   $0x803b93
  801522:	e8 05 1d 00 00       	call   80322c <_panic>

00801527 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 80 3c 80 00       	push   $0x803c80
  801535:	68 05 01 00 00       	push   $0x105
  80153a:	68 93 3b 80 00       	push   $0x803b93
  80153f:	e8 e8 1c 00 00       	call   80322c <_panic>

00801544 <shrink>:

}
void shrink(uint32 newSize)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 80 3c 80 00       	push   $0x803c80
  801552:	68 0a 01 00 00       	push   $0x10a
  801557:	68 93 3b 80 00       	push   $0x803b93
  80155c:	e8 cb 1c 00 00       	call   80322c <_panic>

00801561 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 80 3c 80 00       	push   $0x803c80
  80156f:	68 0f 01 00 00       	push   $0x10f
  801574:	68 93 3b 80 00       	push   $0x803b93
  801579:	e8 ae 1c 00 00       	call   80322c <_panic>

0080157e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	57                   	push   %edi
  801582:	56                   	push   %esi
  801583:	53                   	push   %ebx
  801584:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801590:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801593:	8b 7d 18             	mov    0x18(%ebp),%edi
  801596:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801599:	cd 30                	int    $0x30
  80159b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	5f                   	pop    %edi
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	52                   	push   %edx
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	e8 b2 ff ff ff       	call   80157e <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	90                   	nop
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 01                	push   $0x1
  8015e1:	e8 98 ff ff ff       	call   80157e <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	52                   	push   %edx
  8015fb:	50                   	push   %eax
  8015fc:	6a 05                	push   $0x5
  8015fe:	e8 7b ff ff ff       	call   80157e <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	56                   	push   %esi
  80160c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80160d:	8b 75 18             	mov    0x18(%ebp),%esi
  801610:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801613:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801616:	8b 55 0c             	mov    0xc(%ebp),%edx
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	51                   	push   %ecx
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	6a 06                	push   $0x6
  801623:	e8 56 ff ff ff       	call   80157e <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162e:	5b                   	pop    %ebx
  80162f:	5e                   	pop    %esi
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    

00801632 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	52                   	push   %edx
  801642:	50                   	push   %eax
  801643:	6a 07                	push   $0x7
  801645:	e8 34 ff ff ff       	call   80157e <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	6a 08                	push   $0x8
  801660:	e8 19 ff ff ff       	call   80157e <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 09                	push   $0x9
  801679:	e8 00 ff ff ff       	call   80157e <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 0a                	push   $0xa
  801692:	e8 e7 fe ff ff       	call   80157e <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 0b                	push   $0xb
  8016ab:	e8 ce fe ff ff       	call   80157e <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	ff 75 08             	pushl  0x8(%ebp)
  8016c4:	6a 0f                	push   $0xf
  8016c6:	e8 b3 fe ff ff       	call   80157e <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
	return;
  8016ce:	90                   	nop
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	6a 10                	push   $0x10
  8016e2:	e8 97 fe ff ff       	call   80157e <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ea:	90                   	nop
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 10             	pushl  0x10(%ebp)
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	ff 75 08             	pushl  0x8(%ebp)
  8016fd:	6a 11                	push   $0x11
  8016ff:	e8 7a fe ff ff       	call   80157e <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
	return ;
  801707:	90                   	nop
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 0c                	push   $0xc
  801719:	e8 60 fe ff ff       	call   80157e <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	6a 0d                	push   $0xd
  801733:	e8 46 fe ff ff       	call   80157e <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 0e                	push   $0xe
  80174c:	e8 2d fe ff ff       	call   80157e <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	90                   	nop
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 13                	push   $0x13
  801766:	e8 13 fe ff ff       	call   80157e <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	90                   	nop
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 14                	push   $0x14
  801780:	e8 f9 fd ff ff       	call   80157e <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_cputc>:


void
sys_cputc(const char c)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801797:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	50                   	push   %eax
  8017a4:	6a 15                	push   $0x15
  8017a6:	e8 d3 fd ff ff       	call   80157e <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 16                	push   $0x16
  8017c0:	e8 b9 fd ff ff       	call   80157e <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	6a 17                	push   $0x17
  8017dd:	e8 9c fd ff ff       	call   80157e <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	52                   	push   %edx
  8017f7:	50                   	push   %eax
  8017f8:	6a 1a                	push   $0x1a
  8017fa:	e8 7f fd ff ff       	call   80157e <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	52                   	push   %edx
  801814:	50                   	push   %eax
  801815:	6a 18                	push   $0x18
  801817:	e8 62 fd ff ff       	call   80157e <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 19                	push   $0x19
  801835:	e8 44 fd ff ff       	call   80157e <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	8b 45 10             	mov    0x10(%ebp),%eax
  801849:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80184c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80184f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	51                   	push   %ecx
  801859:	52                   	push   %edx
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	6a 1b                	push   $0x1b
  801860:	e8 19 fd ff ff       	call   80157e <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	6a 1c                	push   $0x1c
  80187d:	e8 fc fc ff ff       	call   80157e <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80188a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	51                   	push   %ecx
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 1d                	push   $0x1d
  80189c:	e8 dd fc ff ff       	call   80157e <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	52                   	push   %edx
  8018b6:	50                   	push   %eax
  8018b7:	6a 1e                	push   $0x1e
  8018b9:	e8 c0 fc ff ff       	call   80157e <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 1f                	push   $0x1f
  8018d2:	e8 a7 fc ff ff       	call   80157e <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	ff 75 14             	pushl  0x14(%ebp)
  8018e7:	ff 75 10             	pushl  0x10(%ebp)
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	6a 20                	push   $0x20
  8018f0:	e8 89 fc ff ff       	call   80157e <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	50                   	push   %eax
  801909:	6a 21                	push   $0x21
  80190b:	e8 6e fc ff ff       	call   80157e <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	50                   	push   %eax
  801925:	6a 22                	push   $0x22
  801927:	e8 52 fc ff ff       	call   80157e <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 02                	push   $0x2
  801940:	e8 39 fc ff ff       	call   80157e <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 03                	push   $0x3
  801959:	e8 20 fc ff ff       	call   80157e <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 04                	push   $0x4
  801972:	e8 07 fc ff ff       	call   80157e <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_exit_env>:


void sys_exit_env(void)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 23                	push   $0x23
  80198b:	e8 ee fb ff ff       	call   80157e <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80199c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199f:	8d 50 04             	lea    0x4(%eax),%edx
  8019a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	52                   	push   %edx
  8019ac:	50                   	push   %eax
  8019ad:	6a 24                	push   $0x24
  8019af:	e8 ca fb ff ff       	call   80157e <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	89 01                	mov    %eax,(%ecx)
  8019c2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	c9                   	leave  
  8019c9:	c2 04 00             	ret    $0x4

008019cc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	6a 12                	push   $0x12
  8019de:	e8 9b fb ff ff       	call   80157e <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e6:	90                   	nop
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 25                	push   $0x25
  8019f8:	e8 81 fb ff ff       	call   80157e <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	50                   	push   %eax
  801a1b:	6a 26                	push   $0x26
  801a1d:	e8 5c fb ff ff       	call   80157e <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <rsttst>:
void rsttst()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 28                	push   $0x28
  801a37:	e8 42 fb ff ff       	call   80157e <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	ff 75 10             	pushl  0x10(%ebp)
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	6a 27                	push   $0x27
  801a62:	e8 17 fb ff ff       	call   80157e <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6a:	90                   	nop
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <chktst>:
void chktst(uint32 n)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 29                	push   $0x29
  801a7d:	e8 fc fa ff ff       	call   80157e <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return ;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <inctst>:

void inctst()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 2a                	push   $0x2a
  801a97:	e8 e2 fa ff ff       	call   80157e <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <gettst>:
uint32 gettst()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 2b                	push   $0x2b
  801ab1:	e8 c8 fa ff ff       	call   80157e <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 2c                	push   $0x2c
  801acd:	e8 ac fa ff ff       	call   80157e <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
  801ad5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ad8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801adc:	75 07                	jne    801ae5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ade:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae3:	eb 05                	jmp    801aea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 2c                	push   $0x2c
  801afe:	e8 7b fa ff ff       	call   80157e <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
  801b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b09:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b0d:	75 07                	jne    801b16 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b14:	eb 05                	jmp    801b1b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 2c                	push   $0x2c
  801b2f:	e8 4a fa ff ff       	call   80157e <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
  801b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b3a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b3e:	75 07                	jne    801b47 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b40:	b8 01 00 00 00       	mov    $0x1,%eax
  801b45:	eb 05                	jmp    801b4c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 2c                	push   $0x2c
  801b60:	e8 19 fa ff ff       	call   80157e <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
  801b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b6b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b6f:	75 07                	jne    801b78 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	eb 05                	jmp    801b7d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 08             	pushl  0x8(%ebp)
  801b8d:	6a 2d                	push   $0x2d
  801b8f:	e8 ea f9 ff ff       	call   80157e <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
	return ;
  801b97:	90                   	nop
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b9e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	53                   	push   %ebx
  801bad:	51                   	push   %ecx
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	6a 2e                	push   $0x2e
  801bb2:	e8 c7 f9 ff ff       	call   80157e <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 2f                	push   $0x2f
  801bd2:	e8 a7 f9 ff ff       	call   80157e <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	68 90 3c 80 00       	push   $0x803c90
  801bea:	e8 6b e8 ff ff       	call   80045a <cprintf>
  801bef:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	68 bc 3c 80 00       	push   $0x803cbc
  801c01:	e8 54 e8 ff ff       	call   80045a <cprintf>
  801c06:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c09:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c0d:	a1 38 41 80 00       	mov    0x804138,%eax
  801c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c15:	eb 56                	jmp    801c6d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c1b:	74 1c                	je     801c39 <print_mem_block_lists+0x5d>
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	8b 50 08             	mov    0x8(%eax),%edx
  801c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c26:	8b 48 08             	mov    0x8(%eax),%ecx
  801c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2f:	01 c8                	add    %ecx,%eax
  801c31:	39 c2                	cmp    %eax,%edx
  801c33:	73 04                	jae    801c39 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c35:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	8b 50 08             	mov    0x8(%eax),%edx
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	8b 40 0c             	mov    0xc(%eax),%eax
  801c45:	01 c2                	add    %eax,%edx
  801c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4a:	8b 40 08             	mov    0x8(%eax),%eax
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	68 d1 3c 80 00       	push   $0x803cd1
  801c57:	e8 fe e7 ff ff       	call   80045a <cprintf>
  801c5c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c65:	a1 40 41 80 00       	mov    0x804140,%eax
  801c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c71:	74 07                	je     801c7a <print_mem_block_lists+0x9e>
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	8b 00                	mov    (%eax),%eax
  801c78:	eb 05                	jmp    801c7f <print_mem_block_lists+0xa3>
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	a3 40 41 80 00       	mov    %eax,0x804140
  801c84:	a1 40 41 80 00       	mov    0x804140,%eax
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	75 8a                	jne    801c17 <print_mem_block_lists+0x3b>
  801c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c91:	75 84                	jne    801c17 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c93:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c97:	75 10                	jne    801ca9 <print_mem_block_lists+0xcd>
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	68 e0 3c 80 00       	push   $0x803ce0
  801ca1:	e8 b4 e7 ff ff       	call   80045a <cprintf>
  801ca6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ca9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	68 04 3d 80 00       	push   $0x803d04
  801cb8:	e8 9d e7 ff ff       	call   80045a <cprintf>
  801cbd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801cc0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801cc4:	a1 40 40 80 00       	mov    0x804040,%eax
  801cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ccc:	eb 56                	jmp    801d24 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd2:	74 1c                	je     801cf0 <print_mem_block_lists+0x114>
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd7:	8b 50 08             	mov    0x8(%eax),%edx
  801cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdd:	8b 48 08             	mov    0x8(%eax),%ecx
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce6:	01 c8                	add    %ecx,%eax
  801ce8:	39 c2                	cmp    %eax,%edx
  801cea:	73 04                	jae    801cf0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801cec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf3:	8b 50 08             	mov    0x8(%eax),%edx
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfc:	01 c2                	add    %eax,%edx
  801cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d01:	8b 40 08             	mov    0x8(%eax),%eax
  801d04:	83 ec 04             	sub    $0x4,%esp
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	68 d1 3c 80 00       	push   $0x803cd1
  801d0e:	e8 47 e7 ff ff       	call   80045a <cprintf>
  801d13:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d1c:	a1 48 40 80 00       	mov    0x804048,%eax
  801d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d28:	74 07                	je     801d31 <print_mem_block_lists+0x155>
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	eb 05                	jmp    801d36 <print_mem_block_lists+0x15a>
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
  801d36:	a3 48 40 80 00       	mov    %eax,0x804048
  801d3b:	a1 48 40 80 00       	mov    0x804048,%eax
  801d40:	85 c0                	test   %eax,%eax
  801d42:	75 8a                	jne    801cce <print_mem_block_lists+0xf2>
  801d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d48:	75 84                	jne    801cce <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d4a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d4e:	75 10                	jne    801d60 <print_mem_block_lists+0x184>
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	68 1c 3d 80 00       	push   $0x803d1c
  801d58:	e8 fd e6 ff ff       	call   80045a <cprintf>
  801d5d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	68 90 3c 80 00       	push   $0x803c90
  801d68:	e8 ed e6 ff ff       	call   80045a <cprintf>
  801d6d:	83 c4 10             	add    $0x10,%esp

}
  801d70:	90                   	nop
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801d79:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801d80:	00 00 00 
  801d83:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801d8a:	00 00 00 
  801d8d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d94:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d9e:	e9 9e 00 00 00       	jmp    801e41 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801da3:	a1 50 40 80 00       	mov    0x804050,%eax
  801da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dab:	c1 e2 04             	shl    $0x4,%edx
  801dae:	01 d0                	add    %edx,%eax
  801db0:	85 c0                	test   %eax,%eax
  801db2:	75 14                	jne    801dc8 <initialize_MemBlocksList+0x55>
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	68 44 3d 80 00       	push   $0x803d44
  801dbc:	6a 46                	push   $0x46
  801dbe:	68 67 3d 80 00       	push   $0x803d67
  801dc3:	e8 64 14 00 00       	call   80322c <_panic>
  801dc8:	a1 50 40 80 00       	mov    0x804050,%eax
  801dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd0:	c1 e2 04             	shl    $0x4,%edx
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ddb:	89 10                	mov    %edx,(%eax)
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	74 18                	je     801dfb <initialize_MemBlocksList+0x88>
  801de3:	a1 48 41 80 00       	mov    0x804148,%eax
  801de8:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801dee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801df1:	c1 e1 04             	shl    $0x4,%ecx
  801df4:	01 ca                	add    %ecx,%edx
  801df6:	89 50 04             	mov    %edx,0x4(%eax)
  801df9:	eb 12                	jmp    801e0d <initialize_MemBlocksList+0x9a>
  801dfb:	a1 50 40 80 00       	mov    0x804050,%eax
  801e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e03:	c1 e2 04             	shl    $0x4,%edx
  801e06:	01 d0                	add    %edx,%eax
  801e08:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e0d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e15:	c1 e2 04             	shl    $0x4,%edx
  801e18:	01 d0                	add    %edx,%eax
  801e1a:	a3 48 41 80 00       	mov    %eax,0x804148
  801e1f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e27:	c1 e2 04             	shl    $0x4,%edx
  801e2a:	01 d0                	add    %edx,%eax
  801e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e33:	a1 54 41 80 00       	mov    0x804154,%eax
  801e38:	40                   	inc    %eax
  801e39:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801e3e:	ff 45 f4             	incl   -0xc(%ebp)
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e47:	0f 82 56 ff ff ff    	jb     801da3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	8b 00                	mov    (%eax),%eax
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e5e:	eb 19                	jmp    801e79 <find_block+0x29>
	{
		if(va==point->sva)
  801e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e63:	8b 40 08             	mov    0x8(%eax),%eax
  801e66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e69:	75 05                	jne    801e70 <find_block+0x20>
		   return point;
  801e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6e:	eb 36                	jmp    801ea6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	8b 40 08             	mov    0x8(%eax),%eax
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e7d:	74 07                	je     801e86 <find_block+0x36>
  801e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e82:	8b 00                	mov    (%eax),%eax
  801e84:	eb 05                	jmp    801e8b <find_block+0x3b>
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8e:	89 42 08             	mov    %eax,0x8(%edx)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	8b 40 08             	mov    0x8(%eax),%eax
  801e97:	85 c0                	test   %eax,%eax
  801e99:	75 c5                	jne    801e60 <find_block+0x10>
  801e9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e9f:	75 bf                	jne    801e60 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801eae:	a1 40 40 80 00       	mov    0x804040,%eax
  801eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801eb6:	a1 44 40 80 00       	mov    0x804044,%eax
  801ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ec4:	74 24                	je     801eea <insert_sorted_allocList+0x42>
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	8b 50 08             	mov    0x8(%eax),%edx
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 40 08             	mov    0x8(%eax),%eax
  801ed2:	39 c2                	cmp    %eax,%edx
  801ed4:	76 14                	jbe    801eea <insert_sorted_allocList+0x42>
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	8b 50 08             	mov    0x8(%eax),%edx
  801edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edf:	8b 40 08             	mov    0x8(%eax),%eax
  801ee2:	39 c2                	cmp    %eax,%edx
  801ee4:	0f 82 60 01 00 00    	jb     80204a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eee:	75 65                	jne    801f55 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ef0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ef4:	75 14                	jne    801f0a <insert_sorted_allocList+0x62>
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	68 44 3d 80 00       	push   $0x803d44
  801efe:	6a 6b                	push   $0x6b
  801f00:	68 67 3d 80 00       	push   $0x803d67
  801f05:	e8 22 13 00 00       	call   80322c <_panic>
  801f0a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	89 10                	mov    %edx,(%eax)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	74 0d                	je     801f2b <insert_sorted_allocList+0x83>
  801f1e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f23:	8b 55 08             	mov    0x8(%ebp),%edx
  801f26:	89 50 04             	mov    %edx,0x4(%eax)
  801f29:	eb 08                	jmp    801f33 <insert_sorted_allocList+0x8b>
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	a3 44 40 80 00       	mov    %eax,0x804044
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	a3 40 40 80 00       	mov    %eax,0x804040
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f45:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f4a:	40                   	inc    %eax
  801f4b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f50:	e9 dc 01 00 00       	jmp    802131 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8b 50 08             	mov    0x8(%eax),%edx
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 40 08             	mov    0x8(%eax),%eax
  801f61:	39 c2                	cmp    %eax,%edx
  801f63:	77 6c                	ja     801fd1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801f65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f69:	74 06                	je     801f71 <insert_sorted_allocList+0xc9>
  801f6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f6f:	75 14                	jne    801f85 <insert_sorted_allocList+0xdd>
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	68 80 3d 80 00       	push   $0x803d80
  801f79:	6a 6f                	push   $0x6f
  801f7b:	68 67 3d 80 00       	push   $0x803d67
  801f80:	e8 a7 12 00 00       	call   80322c <_panic>
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	8b 50 04             	mov    0x4(%eax),%edx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	89 50 04             	mov    %edx,0x4(%eax)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f97:	89 10                	mov    %edx,(%eax)
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 40 04             	mov    0x4(%eax),%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	74 0d                	je     801fb0 <insert_sorted_allocList+0x108>
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	8b 40 04             	mov    0x4(%eax),%eax
  801fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  801fac:	89 10                	mov    %edx,(%eax)
  801fae:	eb 08                	jmp    801fb8 <insert_sorted_allocList+0x110>
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	a3 40 40 80 00       	mov    %eax,0x804040
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbe:	89 50 04             	mov    %edx,0x4(%eax)
  801fc1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fc6:	40                   	inc    %eax
  801fc7:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fcc:	e9 60 01 00 00       	jmp    802131 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fda:	8b 40 08             	mov    0x8(%eax),%eax
  801fdd:	39 c2                	cmp    %eax,%edx
  801fdf:	0f 82 4c 01 00 00    	jb     802131 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801fe5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe9:	75 14                	jne    801fff <insert_sorted_allocList+0x157>
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 b8 3d 80 00       	push   $0x803db8
  801ff3:	6a 73                	push   $0x73
  801ff5:	68 67 3d 80 00       	push   $0x803d67
  801ffa:	e8 2d 12 00 00       	call   80322c <_panic>
  801fff:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	89 50 04             	mov    %edx,0x4(%eax)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8b 40 04             	mov    0x4(%eax),%eax
  802011:	85 c0                	test   %eax,%eax
  802013:	74 0c                	je     802021 <insert_sorted_allocList+0x179>
  802015:	a1 44 40 80 00       	mov    0x804044,%eax
  80201a:	8b 55 08             	mov    0x8(%ebp),%edx
  80201d:	89 10                	mov    %edx,(%eax)
  80201f:	eb 08                	jmp    802029 <insert_sorted_allocList+0x181>
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	a3 40 40 80 00       	mov    %eax,0x804040
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	a3 44 40 80 00       	mov    %eax,0x804044
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203f:	40                   	inc    %eax
  802040:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802045:	e9 e7 00 00 00       	jmp    802131 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802050:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802057:	a1 40 40 80 00       	mov    0x804040,%eax
  80205c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205f:	e9 9d 00 00 00       	jmp    802101 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	8b 50 08             	mov    0x8(%eax),%edx
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	8b 40 08             	mov    0x8(%eax),%eax
  802078:	39 c2                	cmp    %eax,%edx
  80207a:	76 7d                	jbe    8020f9 <insert_sorted_allocList+0x251>
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8b 50 08             	mov    0x8(%eax),%edx
  802082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802085:	8b 40 08             	mov    0x8(%eax),%eax
  802088:	39 c2                	cmp    %eax,%edx
  80208a:	73 6d                	jae    8020f9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80208c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802090:	74 06                	je     802098 <insert_sorted_allocList+0x1f0>
  802092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802096:	75 14                	jne    8020ac <insert_sorted_allocList+0x204>
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 dc 3d 80 00       	push   $0x803ddc
  8020a0:	6a 7f                	push   $0x7f
  8020a2:	68 67 3d 80 00       	push   $0x803d67
  8020a7:	e8 80 11 00 00       	call   80322c <_panic>
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 10                	mov    (%eax),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	89 10                	mov    %edx,(%eax)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	74 0b                	je     8020ca <insert_sorted_allocList+0x222>
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 00                	mov    (%eax),%eax
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	89 50 04             	mov    %edx,0x4(%eax)
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d0:	89 10                	mov    %edx,(%eax)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	89 50 04             	mov    %edx,0x4(%eax)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 08                	jne    8020ec <insert_sorted_allocList+0x244>
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8020ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f1:	40                   	inc    %eax
  8020f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020f7:	eb 39                	jmp    802132 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802105:	74 07                	je     80210e <insert_sorted_allocList+0x266>
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 00                	mov    (%eax),%eax
  80210c:	eb 05                	jmp    802113 <insert_sorted_allocList+0x26b>
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	a3 48 40 80 00       	mov    %eax,0x804048
  802118:	a1 48 40 80 00       	mov    0x804048,%eax
  80211d:	85 c0                	test   %eax,%eax
  80211f:	0f 85 3f ff ff ff    	jne    802064 <insert_sorted_allocList+0x1bc>
  802125:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802129:	0f 85 35 ff ff ff    	jne    802064 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80212f:	eb 01                	jmp    802132 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802131:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802132:	90                   	nop
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80213b:	a1 38 41 80 00       	mov    0x804138,%eax
  802140:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802143:	e9 85 01 00 00       	jmp    8022cd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 40 0c             	mov    0xc(%eax),%eax
  80214e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802151:	0f 82 6e 01 00 00    	jb     8022c5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 40 0c             	mov    0xc(%eax),%eax
  80215d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802160:	0f 85 8a 00 00 00    	jne    8021f0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216a:	75 17                	jne    802183 <alloc_block_FF+0x4e>
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	68 10 3e 80 00       	push   $0x803e10
  802174:	68 93 00 00 00       	push   $0x93
  802179:	68 67 3d 80 00       	push   $0x803d67
  80217e:	e8 a9 10 00 00       	call   80322c <_panic>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 10                	je     80219c <alloc_block_FF+0x67>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802194:	8b 52 04             	mov    0x4(%edx),%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 0b                	jmp    8021a7 <alloc_block_FF+0x72>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 40 04             	mov    0x4(%eax),%eax
  8021a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 04             	mov    0x4(%eax),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 0f                	je     8021c0 <alloc_block_FF+0x8b>
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 04             	mov    0x4(%eax),%eax
  8021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ba:	8b 12                	mov    (%edx),%edx
  8021bc:	89 10                	mov    %edx,(%eax)
  8021be:	eb 0a                	jmp    8021ca <alloc_block_FF+0x95>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8021e2:	48                   	dec    %eax
  8021e3:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	e9 10 01 00 00       	jmp    802300 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f9:	0f 86 c6 00 00 00    	jbe    8022c5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8021ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802204:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220a:	8b 50 08             	mov    0x8(%eax),%edx
  80220d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802210:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	8b 55 08             	mov    0x8(%ebp),%edx
  802219:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80221c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802220:	75 17                	jne    802239 <alloc_block_FF+0x104>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 10 3e 80 00       	push   $0x803e10
  80222a:	68 9b 00 00 00       	push   $0x9b
  80222f:	68 67 3d 80 00       	push   $0x803d67
  802234:	e8 f3 0f 00 00       	call   80322c <_panic>
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	74 10                	je     802252 <alloc_block_FF+0x11d>
  802242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224a:	8b 52 04             	mov    0x4(%edx),%edx
  80224d:	89 50 04             	mov    %edx,0x4(%eax)
  802250:	eb 0b                	jmp    80225d <alloc_block_FF+0x128>
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	8b 40 04             	mov    0x4(%eax),%eax
  802258:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	8b 40 04             	mov    0x4(%eax),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	74 0f                	je     802276 <alloc_block_FF+0x141>
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	8b 40 04             	mov    0x4(%eax),%eax
  80226d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802270:	8b 12                	mov    (%edx),%edx
  802272:	89 10                	mov    %edx,(%eax)
  802274:	eb 0a                	jmp    802280 <alloc_block_FF+0x14b>
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	a3 48 41 80 00       	mov    %eax,0x804148
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802293:	a1 54 41 80 00       	mov    0x804154,%eax
  802298:	48                   	dec    %eax
  802299:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	01 c2                	add    %eax,%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8022b8:	89 c2                	mov    %eax,%edx
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	eb 3b                	jmp    802300 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d1:	74 07                	je     8022da <alloc_block_FF+0x1a5>
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 00                	mov    (%eax),%eax
  8022d8:	eb 05                	jmp    8022df <alloc_block_FF+0x1aa>
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	a3 40 41 80 00       	mov    %eax,0x804140
  8022e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	0f 85 57 fe ff ff    	jne    802148 <alloc_block_FF+0x13>
  8022f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f5:	0f 85 4d fe ff ff    	jne    802148 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802308:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80230f:	a1 38 41 80 00       	mov    0x804138,%eax
  802314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802317:	e9 df 00 00 00       	jmp    8023fb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 0c             	mov    0xc(%eax),%eax
  802322:	3b 45 08             	cmp    0x8(%ebp),%eax
  802325:	0f 82 c8 00 00 00    	jb     8023f3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 40 0c             	mov    0xc(%eax),%eax
  802331:	3b 45 08             	cmp    0x8(%ebp),%eax
  802334:	0f 85 8a 00 00 00    	jne    8023c4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	75 17                	jne    802357 <alloc_block_BF+0x55>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 10 3e 80 00       	push   $0x803e10
  802348:	68 b7 00 00 00       	push   $0xb7
  80234d:	68 67 3d 80 00       	push   $0x803d67
  802352:	e8 d5 0e 00 00       	call   80322c <_panic>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 10                	je     802370 <alloc_block_BF+0x6e>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802368:	8b 52 04             	mov    0x4(%edx),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	eb 0b                	jmp    80237b <alloc_block_BF+0x79>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 04             	mov    0x4(%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 0f                	je     802394 <alloc_block_BF+0x92>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238e:	8b 12                	mov    (%edx),%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	eb 0a                	jmp    80239e <alloc_block_BF+0x9c>
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	a3 38 41 80 00       	mov    %eax,0x804138
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b1:	a1 44 41 80 00       	mov    0x804144,%eax
  8023b6:	48                   	dec    %eax
  8023b7:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	e9 4d 01 00 00       	jmp    802511 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023cd:	76 24                	jbe    8023f3 <alloc_block_BF+0xf1>
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023d8:	73 19                	jae    8023f3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8023da:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 08             	mov    0x8(%eax),%eax
  8023f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023f3:	a1 40 41 80 00       	mov    0x804140,%eax
  8023f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ff:	74 07                	je     802408 <alloc_block_BF+0x106>
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	eb 05                	jmp    80240d <alloc_block_BF+0x10b>
  802408:	b8 00 00 00 00       	mov    $0x0,%eax
  80240d:	a3 40 41 80 00       	mov    %eax,0x804140
  802412:	a1 40 41 80 00       	mov    0x804140,%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	0f 85 fd fe ff ff    	jne    80231c <alloc_block_BF+0x1a>
  80241f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802423:	0f 85 f3 fe ff ff    	jne    80231c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802429:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80242d:	0f 84 d9 00 00 00    	je     80250c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802433:	a1 48 41 80 00       	mov    0x804148,%eax
  802438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80243b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802441:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802447:	8b 55 08             	mov    0x8(%ebp),%edx
  80244a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80244d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802451:	75 17                	jne    80246a <alloc_block_BF+0x168>
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 10 3e 80 00       	push   $0x803e10
  80245b:	68 c7 00 00 00       	push   $0xc7
  802460:	68 67 3d 80 00       	push   $0x803d67
  802465:	e8 c2 0d 00 00       	call   80322c <_panic>
  80246a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 10                	je     802483 <alloc_block_BF+0x181>
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80247b:	8b 52 04             	mov    0x4(%edx),%edx
  80247e:	89 50 04             	mov    %edx,0x4(%eax)
  802481:	eb 0b                	jmp    80248e <alloc_block_BF+0x18c>
  802483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80248e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 0f                	je     8024a7 <alloc_block_BF+0x1a5>
  802498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a1:	8b 12                	mov    (%edx),%edx
  8024a3:	89 10                	mov    %edx,(%eax)
  8024a5:	eb 0a                	jmp    8024b1 <alloc_block_BF+0x1af>
  8024a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8024b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c4:	a1 54 41 80 00       	mov    0x804154,%eax
  8024c9:	48                   	dec    %eax
  8024ca:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8024cf:	83 ec 08             	sub    $0x8,%esp
  8024d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8024d5:	68 38 41 80 00       	push   $0x804138
  8024da:	e8 71 f9 ff ff       	call   801e50 <find_block>
  8024df:	83 c4 10             	add    $0x10,%esp
  8024e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8024e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e8:	8b 50 08             	mov    0x8(%eax),%edx
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	01 c2                	add    %eax,%edx
  8024f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8024f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ff:	89 c2                	mov    %eax,%edx
  802501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802504:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250a:	eb 05                	jmp    802511 <alloc_block_BF+0x20f>
	}
	return NULL;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802519:	a1 28 40 80 00       	mov    0x804028,%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	0f 85 de 01 00 00    	jne    802704 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802526:	a1 38 41 80 00       	mov    0x804138,%eax
  80252b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252e:	e9 9e 01 00 00       	jmp    8026d1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253c:	0f 82 87 01 00 00    	jb     8026c9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 0c             	mov    0xc(%eax),%eax
  802548:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254b:	0f 85 95 00 00 00    	jne    8025e6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	75 17                	jne    80256e <alloc_block_NF+0x5b>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 10 3e 80 00       	push   $0x803e10
  80255f:	68 e0 00 00 00       	push   $0xe0
  802564:	68 67 3d 80 00       	push   $0x803d67
  802569:	e8 be 0c 00 00       	call   80322c <_panic>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 10                	je     802587 <alloc_block_NF+0x74>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	8b 52 04             	mov    0x4(%edx),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	eb 0b                	jmp    802592 <alloc_block_NF+0x7f>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0f                	je     8025ab <alloc_block_NF+0x98>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	8b 12                	mov    (%edx),%edx
  8025a7:	89 10                	mov    %edx,(%eax)
  8025a9:	eb 0a                	jmp    8025b5 <alloc_block_NF+0xa2>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	a3 38 41 80 00       	mov    %eax,0x804138
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c8:	a1 44 41 80 00       	mov    0x804144,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 08             	mov    0x8(%eax),%eax
  8025d9:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	e9 f8 04 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ef:	0f 86 d4 00 00 00    	jbe    8026c9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f5:	a1 48 41 80 00       	mov    0x804148,%eax
  8025fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 50 08             	mov    0x8(%eax),%edx
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260c:	8b 55 08             	mov    0x8(%ebp),%edx
  80260f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802616:	75 17                	jne    80262f <alloc_block_NF+0x11c>
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	68 10 3e 80 00       	push   $0x803e10
  802620:	68 e9 00 00 00       	push   $0xe9
  802625:	68 67 3d 80 00       	push   $0x803d67
  80262a:	e8 fd 0b 00 00       	call   80322c <_panic>
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 10                	je     802648 <alloc_block_NF+0x135>
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802640:	8b 52 04             	mov    0x4(%edx),%edx
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	eb 0b                	jmp    802653 <alloc_block_NF+0x140>
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 0f                	je     80266c <alloc_block_NF+0x159>
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802666:	8b 12                	mov    (%edx),%edx
  802668:	89 10                	mov    %edx,(%eax)
  80266a:	eb 0a                	jmp    802676 <alloc_block_NF+0x163>
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	a3 48 41 80 00       	mov    %eax,0x804148
  802676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802689:	a1 54 41 80 00       	mov    0x804154,%eax
  80268e:	48                   	dec    %eax
  80268f:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802697:	8b 40 08             	mov    0x8(%eax),%eax
  80269a:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 50 08             	mov    0x8(%eax),%edx
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	01 c2                	add    %eax,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b9:	89 c2                	mov    %eax,%edx
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	e9 15 04 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	74 07                	je     8026de <alloc_block_NF+0x1cb>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	eb 05                	jmp    8026e3 <alloc_block_NF+0x1d0>
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e3:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 85 3e fe ff ff    	jne    802533 <alloc_block_NF+0x20>
  8026f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f9:	0f 85 34 fe ff ff    	jne    802533 <alloc_block_NF+0x20>
  8026ff:	e9 d5 03 00 00       	jmp    802ad9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802704:	a1 38 41 80 00       	mov    0x804138,%eax
  802709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270c:	e9 b1 01 00 00       	jmp    8028c2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 50 08             	mov    0x8(%eax),%edx
  802717:	a1 28 40 80 00       	mov    0x804028,%eax
  80271c:	39 c2                	cmp    %eax,%edx
  80271e:	0f 82 96 01 00 00    	jb     8028ba <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272d:	0f 82 87 01 00 00    	jb     8028ba <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 0c             	mov    0xc(%eax),%eax
  802739:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273c:	0f 85 95 00 00 00    	jne    8027d7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	75 17                	jne    80275f <alloc_block_NF+0x24c>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 10 3e 80 00       	push   $0x803e10
  802750:	68 fc 00 00 00       	push   $0xfc
  802755:	68 67 3d 80 00       	push   $0x803d67
  80275a:	e8 cd 0a 00 00       	call   80322c <_panic>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 10                	je     802778 <alloc_block_NF+0x265>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 52 04             	mov    0x4(%edx),%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	eb 0b                	jmp    802783 <alloc_block_NF+0x270>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0f                	je     80279c <alloc_block_NF+0x289>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	8b 12                	mov    (%edx),%edx
  802798:	89 10                	mov    %edx,(%eax)
  80279a:	eb 0a                	jmp    8027a6 <alloc_block_NF+0x293>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8027be:	48                   	dec    %eax
  8027bf:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ca:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	e9 07 03 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e0:	0f 86 d4 00 00 00    	jbe    8028ba <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8027eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 50 08             	mov    0x8(%eax),%edx
  8027f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8027fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802800:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802803:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802807:	75 17                	jne    802820 <alloc_block_NF+0x30d>
  802809:	83 ec 04             	sub    $0x4,%esp
  80280c:	68 10 3e 80 00       	push   $0x803e10
  802811:	68 04 01 00 00       	push   $0x104
  802816:	68 67 3d 80 00       	push   $0x803d67
  80281b:	e8 0c 0a 00 00       	call   80322c <_panic>
  802820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	85 c0                	test   %eax,%eax
  802827:	74 10                	je     802839 <alloc_block_NF+0x326>
  802829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282c:	8b 00                	mov    (%eax),%eax
  80282e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802831:	8b 52 04             	mov    0x4(%edx),%edx
  802834:	89 50 04             	mov    %edx,0x4(%eax)
  802837:	eb 0b                	jmp    802844 <alloc_block_NF+0x331>
  802839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802844:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 0f                	je     80285d <alloc_block_NF+0x34a>
  80284e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802851:	8b 40 04             	mov    0x4(%eax),%eax
  802854:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802857:	8b 12                	mov    (%edx),%edx
  802859:	89 10                	mov    %edx,(%eax)
  80285b:	eb 0a                	jmp    802867 <alloc_block_NF+0x354>
  80285d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	a3 48 41 80 00       	mov    %eax,0x804148
  802867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287a:	a1 54 41 80 00       	mov    0x804154,%eax
  80287f:	48                   	dec    %eax
  802880:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802888:	8b 40 08             	mov    0x8(%eax),%eax
  80288b:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 50 08             	mov    0x8(%eax),%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	01 c2                	add    %eax,%edx
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8028aa:	89 c2                	mov    %eax,%edx
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8028b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b5:	e9 24 02 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ba:	a1 40 41 80 00       	mov    0x804140,%eax
  8028bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	74 07                	je     8028cf <alloc_block_NF+0x3bc>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	eb 05                	jmp    8028d4 <alloc_block_NF+0x3c1>
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d4:	a3 40 41 80 00       	mov    %eax,0x804140
  8028d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	0f 85 2b fe ff ff    	jne    802711 <alloc_block_NF+0x1fe>
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	0f 85 21 fe ff ff    	jne    802711 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f8:	e9 ae 01 00 00       	jmp    802aab <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 50 08             	mov    0x8(%eax),%edx
  802903:	a1 28 40 80 00       	mov    0x804028,%eax
  802908:	39 c2                	cmp    %eax,%edx
  80290a:	0f 83 93 01 00 00    	jae    802aa3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 40 0c             	mov    0xc(%eax),%eax
  802916:	3b 45 08             	cmp    0x8(%ebp),%eax
  802919:	0f 82 84 01 00 00    	jb     802aa3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 0c             	mov    0xc(%eax),%eax
  802925:	3b 45 08             	cmp    0x8(%ebp),%eax
  802928:	0f 85 95 00 00 00    	jne    8029c3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802932:	75 17                	jne    80294b <alloc_block_NF+0x438>
  802934:	83 ec 04             	sub    $0x4,%esp
  802937:	68 10 3e 80 00       	push   $0x803e10
  80293c:	68 14 01 00 00       	push   $0x114
  802941:	68 67 3d 80 00       	push   $0x803d67
  802946:	e8 e1 08 00 00       	call   80322c <_panic>
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 10                	je     802964 <alloc_block_NF+0x451>
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295c:	8b 52 04             	mov    0x4(%edx),%edx
  80295f:	89 50 04             	mov    %edx,0x4(%eax)
  802962:	eb 0b                	jmp    80296f <alloc_block_NF+0x45c>
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 0f                	je     802988 <alloc_block_NF+0x475>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802982:	8b 12                	mov    (%edx),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	eb 0a                	jmp    802992 <alloc_block_NF+0x47f>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	a3 38 41 80 00       	mov    %eax,0x804138
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a5:	a1 44 41 80 00       	mov    0x804144,%eax
  8029aa:	48                   	dec    %eax
  8029ab:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 40 08             	mov    0x8(%eax),%eax
  8029b6:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	e9 1b 01 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cc:	0f 86 d1 00 00 00    	jbe    802aa3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8029d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ec:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f3:	75 17                	jne    802a0c <alloc_block_NF+0x4f9>
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	68 10 3e 80 00       	push   $0x803e10
  8029fd:	68 1c 01 00 00       	push   $0x11c
  802a02:	68 67 3d 80 00       	push   $0x803d67
  802a07:	e8 20 08 00 00       	call   80322c <_panic>
  802a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 10                	je     802a25 <alloc_block_NF+0x512>
  802a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1d:	8b 52 04             	mov    0x4(%edx),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 0b                	jmp    802a30 <alloc_block_NF+0x51d>
  802a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 0f                	je     802a49 <alloc_block_NF+0x536>
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a43:	8b 12                	mov    (%edx),%edx
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	eb 0a                	jmp    802a53 <alloc_block_NF+0x540>
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	a3 48 41 80 00       	mov    %eax,0x804148
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a66:	a1 54 41 80 00       	mov    0x804154,%eax
  802a6b:	48                   	dec    %eax
  802a6c:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a74:	8b 40 08             	mov    0x8(%eax),%eax
  802a77:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 50 08             	mov    0x8(%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	01 c2                	add    %eax,%edx
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 0c             	mov    0xc(%eax),%eax
  802a93:	2b 45 08             	sub    0x8(%ebp),%eax
  802a96:	89 c2                	mov    %eax,%edx
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa1:	eb 3b                	jmp    802ade <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa3:	a1 40 41 80 00       	mov    0x804140,%eax
  802aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	74 07                	je     802ab8 <alloc_block_NF+0x5a5>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	eb 05                	jmp    802abd <alloc_block_NF+0x5aa>
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  802abd:	a3 40 41 80 00       	mov    %eax,0x804140
  802ac2:	a1 40 41 80 00       	mov    0x804140,%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	0f 85 2e fe ff ff    	jne    8028fd <alloc_block_NF+0x3ea>
  802acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad3:	0f 85 24 fe ff ff    	jne    8028fd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ae6:	a1 38 41 80 00       	mov    0x804138,%eax
  802aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802aee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802af6:	a1 38 41 80 00       	mov    0x804138,%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 14                	je     802b13 <insert_sorted_with_merge_freeList+0x33>
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	0f 87 9b 01 00 00    	ja     802cae <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b17:	75 17                	jne    802b30 <insert_sorted_with_merge_freeList+0x50>
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	68 44 3d 80 00       	push   $0x803d44
  802b21:	68 38 01 00 00       	push   $0x138
  802b26:	68 67 3d 80 00       	push   $0x803d67
  802b2b:	e8 fc 06 00 00       	call   80322c <_panic>
  802b30:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	89 10                	mov    %edx,(%eax)
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	74 0d                	je     802b51 <insert_sorted_with_merge_freeList+0x71>
  802b44:	a1 38 41 80 00       	mov    0x804138,%eax
  802b49:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4c:	89 50 04             	mov    %edx,0x4(%eax)
  802b4f:	eb 08                	jmp    802b59 <insert_sorted_with_merge_freeList+0x79>
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	a3 38 41 80 00       	mov    %eax,0x804138
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802b70:	40                   	inc    %eax
  802b71:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7a:	0f 84 a8 06 00 00    	je     803228 <insert_sorted_with_merge_freeList+0x748>
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 40 08             	mov    0x8(%eax),%eax
  802b94:	39 c2                	cmp    %eax,%edx
  802b96:	0f 85 8c 06 00 00    	jne    803228 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	01 c2                	add    %eax,%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb4:	75 17                	jne    802bcd <insert_sorted_with_merge_freeList+0xed>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 10 3e 80 00       	push   $0x803e10
  802bbe:	68 3c 01 00 00       	push   $0x13c
  802bc3:	68 67 3d 80 00       	push   $0x803d67
  802bc8:	e8 5f 06 00 00       	call   80322c <_panic>
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	74 10                	je     802be6 <insert_sorted_with_merge_freeList+0x106>
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bde:	8b 52 04             	mov    0x4(%edx),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	eb 0b                	jmp    802bf1 <insert_sorted_with_merge_freeList+0x111>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0f                	je     802c0a <insert_sorted_with_merge_freeList+0x12a>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c04:	8b 12                	mov    (%edx),%edx
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	eb 0a                	jmp    802c14 <insert_sorted_with_merge_freeList+0x134>
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2c:	48                   	dec    %eax
  802c2d:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802c46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4a:	75 17                	jne    802c63 <insert_sorted_with_merge_freeList+0x183>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 44 3d 80 00       	push   $0x803d44
  802c54:	68 3f 01 00 00       	push   $0x13f
  802c59:	68 67 3d 80 00       	push   $0x803d67
  802c5e:	e8 c9 05 00 00       	call   80322c <_panic>
  802c63:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0d                	je     802c84 <insert_sorted_with_merge_freeList+0x1a4>
  802c77:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 08                	jmp    802c8c <insert_sorted_with_merge_freeList+0x1ac>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ca9:	e9 7a 05 00 00       	jmp    803228 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	39 c2                	cmp    %eax,%edx
  802cbc:	0f 82 14 01 00 00    	jb     802dd6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc5:	8b 50 08             	mov    0x8(%eax),%edx
  802cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cce:	01 c2                	add    %eax,%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	39 c2                	cmp    %eax,%edx
  802cd8:	0f 85 90 00 00 00    	jne    802d6e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cea:	01 c2                	add    %eax,%edx
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0a:	75 17                	jne    802d23 <insert_sorted_with_merge_freeList+0x243>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 44 3d 80 00       	push   $0x803d44
  802d14:	68 49 01 00 00       	push   $0x149
  802d19:	68 67 3d 80 00       	push   $0x803d67
  802d1e:	e8 09 05 00 00       	call   80322c <_panic>
  802d23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0d                	je     802d44 <insert_sorted_with_merge_freeList+0x264>
  802d37:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 08                	jmp    802d4c <insert_sorted_with_merge_freeList+0x26c>
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d69:	e9 bb 04 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d72:	75 17                	jne    802d8b <insert_sorted_with_merge_freeList+0x2ab>
  802d74:	83 ec 04             	sub    $0x4,%esp
  802d77:	68 b8 3d 80 00       	push   $0x803db8
  802d7c:	68 4c 01 00 00       	push   $0x14c
  802d81:	68 67 3d 80 00       	push   $0x803d67
  802d86:	e8 a1 04 00 00       	call   80322c <_panic>
  802d8b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	89 50 04             	mov    %edx,0x4(%eax)
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 0c                	je     802dad <insert_sorted_with_merge_freeList+0x2cd>
  802da1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802da6:	8b 55 08             	mov    0x8(%ebp),%edx
  802da9:	89 10                	mov    %edx,(%eax)
  802dab:	eb 08                	jmp    802db5 <insert_sorted_with_merge_freeList+0x2d5>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	a3 38 41 80 00       	mov    %eax,0x804138
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc6:	a1 44 41 80 00       	mov    0x804144,%eax
  802dcb:	40                   	inc    %eax
  802dcc:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dd1:	e9 53 04 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802dd6:	a1 38 41 80 00       	mov    0x804138,%eax
  802ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dde:	e9 15 04 00 00       	jmp    8031f8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 50 08             	mov    0x8(%eax),%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 08             	mov    0x8(%eax),%eax
  802df7:	39 c2                	cmp    %eax,%edx
  802df9:	0f 86 f1 03 00 00    	jbe    8031f0 <insert_sorted_with_merge_freeList+0x710>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	8b 50 08             	mov    0x8(%eax),%edx
  802e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e08:	8b 40 08             	mov    0x8(%eax),%eax
  802e0b:	39 c2                	cmp    %eax,%edx
  802e0d:	0f 83 dd 03 00 00    	jae    8031f0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 50 08             	mov    0x8(%eax),%edx
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	01 c2                	add    %eax,%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 40 08             	mov    0x8(%eax),%eax
  802e27:	39 c2                	cmp    %eax,%edx
  802e29:	0f 85 b9 01 00 00    	jne    802fe8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3b:	01 c2                	add    %eax,%edx
  802e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e40:	8b 40 08             	mov    0x8(%eax),%eax
  802e43:	39 c2                	cmp    %eax,%edx
  802e45:	0f 85 0d 01 00 00    	jne    802f58 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	01 c2                	add    %eax,%edx
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802e5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e63:	75 17                	jne    802e7c <insert_sorted_with_merge_freeList+0x39c>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 10 3e 80 00       	push   $0x803e10
  802e6d:	68 5c 01 00 00       	push   $0x15c
  802e72:	68 67 3d 80 00       	push   $0x803d67
  802e77:	e8 b0 03 00 00       	call   80322c <_panic>
  802e7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 10                	je     802e95 <insert_sorted_with_merge_freeList+0x3b5>
  802e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e8d:	8b 52 04             	mov    0x4(%edx),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	eb 0b                	jmp    802ea0 <insert_sorted_with_merge_freeList+0x3c0>
  802e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ea0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 0f                	je     802eb9 <insert_sorted_with_merge_freeList+0x3d9>
  802eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb3:	8b 12                	mov    (%edx),%edx
  802eb5:	89 10                	mov    %edx,(%eax)
  802eb7:	eb 0a                	jmp    802ec3 <insert_sorted_with_merge_freeList+0x3e3>
  802eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	a3 38 41 80 00       	mov    %eax,0x804138
  802ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 44 41 80 00       	mov    0x804144,%eax
  802edb:	48                   	dec    %eax
  802edc:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ef5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef9:	75 17                	jne    802f12 <insert_sorted_with_merge_freeList+0x432>
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	68 44 3d 80 00       	push   $0x803d44
  802f03:	68 5f 01 00 00       	push   $0x15f
  802f08:	68 67 3d 80 00       	push   $0x803d67
  802f0d:	e8 1a 03 00 00       	call   80322c <_panic>
  802f12:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	74 0d                	je     802f33 <insert_sorted_with_merge_freeList+0x453>
  802f26:	a1 48 41 80 00       	mov    0x804148,%eax
  802f2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	eb 08                	jmp    802f3b <insert_sorted_with_merge_freeList+0x45b>
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f52:	40                   	inc    %eax
  802f53:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	8b 40 0c             	mov    0xc(%eax),%eax
  802f64:	01 c2                	add    %eax,%edx
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f84:	75 17                	jne    802f9d <insert_sorted_with_merge_freeList+0x4bd>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 44 3d 80 00       	push   $0x803d44
  802f8e:	68 64 01 00 00       	push   $0x164
  802f93:	68 67 3d 80 00       	push   $0x803d67
  802f98:	e8 8f 02 00 00       	call   80322c <_panic>
  802f9d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 0d                	je     802fbe <insert_sorted_with_merge_freeList+0x4de>
  802fb1:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb9:	89 50 04             	mov    %edx,0x4(%eax)
  802fbc:	eb 08                	jmp    802fc6 <insert_sorted_with_merge_freeList+0x4e6>
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	a3 48 41 80 00       	mov    %eax,0x804148
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 54 41 80 00       	mov    0x804154,%eax
  802fdd:	40                   	inc    %eax
  802fde:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802fe3:	e9 41 02 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 50 08             	mov    0x8(%eax),%edx
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff4:	01 c2                	add    %eax,%edx
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	8b 40 08             	mov    0x8(%eax),%eax
  802ffc:	39 c2                	cmp    %eax,%edx
  802ffe:	0f 85 7c 01 00 00    	jne    803180 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803004:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803008:	74 06                	je     803010 <insert_sorted_with_merge_freeList+0x530>
  80300a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300e:	75 17                	jne    803027 <insert_sorted_with_merge_freeList+0x547>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 80 3d 80 00       	push   $0x803d80
  803018:	68 69 01 00 00       	push   $0x169
  80301d:	68 67 3d 80 00       	push   $0x803d67
  803022:	e8 05 02 00 00       	call   80322c <_panic>
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 50 04             	mov    0x4(%eax),%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	89 50 04             	mov    %edx,0x4(%eax)
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0d                	je     803052 <insert_sorted_with_merge_freeList+0x572>
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	8b 55 08             	mov    0x8(%ebp),%edx
  80304e:	89 10                	mov    %edx,(%eax)
  803050:	eb 08                	jmp    80305a <insert_sorted_with_merge_freeList+0x57a>
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	a3 38 41 80 00       	mov    %eax,0x804138
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	a1 44 41 80 00       	mov    0x804144,%eax
  803068:	40                   	inc    %eax
  803069:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 50 0c             	mov    0xc(%eax),%edx
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803082:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803086:	75 17                	jne    80309f <insert_sorted_with_merge_freeList+0x5bf>
  803088:	83 ec 04             	sub    $0x4,%esp
  80308b:	68 10 3e 80 00       	push   $0x803e10
  803090:	68 6b 01 00 00       	push   $0x16b
  803095:	68 67 3d 80 00       	push   $0x803d67
  80309a:	e8 8d 01 00 00       	call   80322c <_panic>
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 10                	je     8030b8 <insert_sorted_with_merge_freeList+0x5d8>
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b0:	8b 52 04             	mov    0x4(%edx),%edx
  8030b3:	89 50 04             	mov    %edx,0x4(%eax)
  8030b6:	eb 0b                	jmp    8030c3 <insert_sorted_with_merge_freeList+0x5e3>
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	8b 40 04             	mov    0x4(%eax),%eax
  8030be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	8b 40 04             	mov    0x4(%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0f                	je     8030dc <insert_sorted_with_merge_freeList+0x5fc>
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	8b 40 04             	mov    0x4(%eax),%eax
  8030d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d6:	8b 12                	mov    (%edx),%edx
  8030d8:	89 10                	mov    %edx,(%eax)
  8030da:	eb 0a                	jmp    8030e6 <insert_sorted_with_merge_freeList+0x606>
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	a3 38 41 80 00       	mov    %eax,0x804138
  8030e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f9:	a1 44 41 80 00       	mov    0x804144,%eax
  8030fe:	48                   	dec    %eax
  8030ff:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803118:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311c:	75 17                	jne    803135 <insert_sorted_with_merge_freeList+0x655>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 44 3d 80 00       	push   $0x803d44
  803126:	68 6e 01 00 00       	push   $0x16e
  80312b:	68 67 3d 80 00       	push   $0x803d67
  803130:	e8 f7 00 00 00       	call   80322c <_panic>
  803135:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0d                	je     803156 <insert_sorted_with_merge_freeList+0x676>
  803149:	a1 48 41 80 00       	mov    0x804148,%eax
  80314e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803151:	89 50 04             	mov    %edx,0x4(%eax)
  803154:	eb 08                	jmp    80315e <insert_sorted_with_merge_freeList+0x67e>
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	a3 48 41 80 00       	mov    %eax,0x804148
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803170:	a1 54 41 80 00       	mov    0x804154,%eax
  803175:	40                   	inc    %eax
  803176:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80317b:	e9 a9 00 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803184:	74 06                	je     80318c <insert_sorted_with_merge_freeList+0x6ac>
  803186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318a:	75 17                	jne    8031a3 <insert_sorted_with_merge_freeList+0x6c3>
  80318c:	83 ec 04             	sub    $0x4,%esp
  80318f:	68 dc 3d 80 00       	push   $0x803ddc
  803194:	68 73 01 00 00       	push   $0x173
  803199:	68 67 3d 80 00       	push   $0x803d67
  80319e:	e8 89 00 00 00       	call   80322c <_panic>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 10                	mov    (%eax),%edx
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 0b                	je     8031c1 <insert_sorted_with_merge_freeList+0x6e1>
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031be:	89 50 04             	mov    %edx,0x4(%eax)
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c7:	89 10                	mov    %edx,(%eax)
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cf:	89 50 04             	mov    %edx,0x4(%eax)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	75 08                	jne    8031e3 <insert_sorted_with_merge_freeList+0x703>
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031e3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031e8:	40                   	inc    %eax
  8031e9:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8031ee:	eb 39                	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fc:	74 07                	je     803205 <insert_sorted_with_merge_freeList+0x725>
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	eb 05                	jmp    80320a <insert_sorted_with_merge_freeList+0x72a>
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	a3 40 41 80 00       	mov    %eax,0x804140
  80320f:	a1 40 41 80 00       	mov    0x804140,%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	0f 85 c7 fb ff ff    	jne    802de3 <insert_sorted_with_merge_freeList+0x303>
  80321c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803220:	0f 85 bd fb ff ff    	jne    802de3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803226:	eb 01                	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803228:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803229:	90                   	nop
  80322a:	c9                   	leave  
  80322b:	c3                   	ret    

0080322c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80322c:	55                   	push   %ebp
  80322d:	89 e5                	mov    %esp,%ebp
  80322f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803232:	8d 45 10             	lea    0x10(%ebp),%eax
  803235:	83 c0 04             	add    $0x4,%eax
  803238:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80323b:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803240:	85 c0                	test   %eax,%eax
  803242:	74 16                	je     80325a <_panic+0x2e>
		cprintf("%s: ", argv0);
  803244:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803249:	83 ec 08             	sub    $0x8,%esp
  80324c:	50                   	push   %eax
  80324d:	68 30 3e 80 00       	push   $0x803e30
  803252:	e8 03 d2 ff ff       	call   80045a <cprintf>
  803257:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80325a:	a1 00 40 80 00       	mov    0x804000,%eax
  80325f:	ff 75 0c             	pushl  0xc(%ebp)
  803262:	ff 75 08             	pushl  0x8(%ebp)
  803265:	50                   	push   %eax
  803266:	68 35 3e 80 00       	push   $0x803e35
  80326b:	e8 ea d1 ff ff       	call   80045a <cprintf>
  803270:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803273:	8b 45 10             	mov    0x10(%ebp),%eax
  803276:	83 ec 08             	sub    $0x8,%esp
  803279:	ff 75 f4             	pushl  -0xc(%ebp)
  80327c:	50                   	push   %eax
  80327d:	e8 6d d1 ff ff       	call   8003ef <vcprintf>
  803282:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803285:	83 ec 08             	sub    $0x8,%esp
  803288:	6a 00                	push   $0x0
  80328a:	68 51 3e 80 00       	push   $0x803e51
  80328f:	e8 5b d1 ff ff       	call   8003ef <vcprintf>
  803294:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803297:	e8 dc d0 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  80329c:	eb fe                	jmp    80329c <_panic+0x70>

0080329e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80329e:	55                   	push   %ebp
  80329f:	89 e5                	mov    %esp,%ebp
  8032a1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8032a9:	8b 50 74             	mov    0x74(%eax),%edx
  8032ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032af:	39 c2                	cmp    %eax,%edx
  8032b1:	74 14                	je     8032c7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 54 3e 80 00       	push   $0x803e54
  8032bb:	6a 26                	push   $0x26
  8032bd:	68 a0 3e 80 00       	push   $0x803ea0
  8032c2:	e8 65 ff ff ff       	call   80322c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032d5:	e9 c2 00 00 00       	jmp    80339c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	01 d0                	add    %edx,%eax
  8032e9:	8b 00                	mov    (%eax),%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	75 08                	jne    8032f7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8032ef:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8032f2:	e9 a2 00 00 00       	jmp    803399 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8032f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032fe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803305:	eb 69                	jmp    803370 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803307:	a1 20 40 80 00       	mov    0x804020,%eax
  80330c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803312:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803315:	89 d0                	mov    %edx,%eax
  803317:	01 c0                	add    %eax,%eax
  803319:	01 d0                	add    %edx,%eax
  80331b:	c1 e0 03             	shl    $0x3,%eax
  80331e:	01 c8                	add    %ecx,%eax
  803320:	8a 40 04             	mov    0x4(%eax),%al
  803323:	84 c0                	test   %al,%al
  803325:	75 46                	jne    80336d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803327:	a1 20 40 80 00       	mov    0x804020,%eax
  80332c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803332:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803335:	89 d0                	mov    %edx,%eax
  803337:	01 c0                	add    %eax,%eax
  803339:	01 d0                	add    %edx,%eax
  80333b:	c1 e0 03             	shl    $0x3,%eax
  80333e:	01 c8                	add    %ecx,%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803345:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803348:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80334d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80334f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803352:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	01 c8                	add    %ecx,%eax
  80335e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803360:	39 c2                	cmp    %eax,%edx
  803362:	75 09                	jne    80336d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803364:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80336b:	eb 12                	jmp    80337f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80336d:	ff 45 e8             	incl   -0x18(%ebp)
  803370:	a1 20 40 80 00       	mov    0x804020,%eax
  803375:	8b 50 74             	mov    0x74(%eax),%edx
  803378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337b:	39 c2                	cmp    %eax,%edx
  80337d:	77 88                	ja     803307 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80337f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803383:	75 14                	jne    803399 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803385:	83 ec 04             	sub    $0x4,%esp
  803388:	68 ac 3e 80 00       	push   $0x803eac
  80338d:	6a 3a                	push   $0x3a
  80338f:	68 a0 3e 80 00       	push   $0x803ea0
  803394:	e8 93 fe ff ff       	call   80322c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803399:	ff 45 f0             	incl   -0x10(%ebp)
  80339c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033a2:	0f 8c 32 ff ff ff    	jl     8032da <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033b6:	eb 26                	jmp    8033de <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8033bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c6:	89 d0                	mov    %edx,%eax
  8033c8:	01 c0                	add    %eax,%eax
  8033ca:	01 d0                	add    %edx,%eax
  8033cc:	c1 e0 03             	shl    $0x3,%eax
  8033cf:	01 c8                	add    %ecx,%eax
  8033d1:	8a 40 04             	mov    0x4(%eax),%al
  8033d4:	3c 01                	cmp    $0x1,%al
  8033d6:	75 03                	jne    8033db <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033d8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033db:	ff 45 e0             	incl   -0x20(%ebp)
  8033de:	a1 20 40 80 00       	mov    0x804020,%eax
  8033e3:	8b 50 74             	mov    0x74(%eax),%edx
  8033e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e9:	39 c2                	cmp    %eax,%edx
  8033eb:	77 cb                	ja     8033b8 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033f3:	74 14                	je     803409 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8033f5:	83 ec 04             	sub    $0x4,%esp
  8033f8:	68 00 3f 80 00       	push   $0x803f00
  8033fd:	6a 44                	push   $0x44
  8033ff:	68 a0 3e 80 00       	push   $0x803ea0
  803404:	e8 23 fe ff ff       	call   80322c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803409:	90                   	nop
  80340a:	c9                   	leave  
  80340b:	c3                   	ret    

0080340c <__udivdi3>:
  80340c:	55                   	push   %ebp
  80340d:	57                   	push   %edi
  80340e:	56                   	push   %esi
  80340f:	53                   	push   %ebx
  803410:	83 ec 1c             	sub    $0x1c,%esp
  803413:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803417:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80341b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803423:	89 ca                	mov    %ecx,%edx
  803425:	89 f8                	mov    %edi,%eax
  803427:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80342b:	85 f6                	test   %esi,%esi
  80342d:	75 2d                	jne    80345c <__udivdi3+0x50>
  80342f:	39 cf                	cmp    %ecx,%edi
  803431:	77 65                	ja     803498 <__udivdi3+0x8c>
  803433:	89 fd                	mov    %edi,%ebp
  803435:	85 ff                	test   %edi,%edi
  803437:	75 0b                	jne    803444 <__udivdi3+0x38>
  803439:	b8 01 00 00 00       	mov    $0x1,%eax
  80343e:	31 d2                	xor    %edx,%edx
  803440:	f7 f7                	div    %edi
  803442:	89 c5                	mov    %eax,%ebp
  803444:	31 d2                	xor    %edx,%edx
  803446:	89 c8                	mov    %ecx,%eax
  803448:	f7 f5                	div    %ebp
  80344a:	89 c1                	mov    %eax,%ecx
  80344c:	89 d8                	mov    %ebx,%eax
  80344e:	f7 f5                	div    %ebp
  803450:	89 cf                	mov    %ecx,%edi
  803452:	89 fa                	mov    %edi,%edx
  803454:	83 c4 1c             	add    $0x1c,%esp
  803457:	5b                   	pop    %ebx
  803458:	5e                   	pop    %esi
  803459:	5f                   	pop    %edi
  80345a:	5d                   	pop    %ebp
  80345b:	c3                   	ret    
  80345c:	39 ce                	cmp    %ecx,%esi
  80345e:	77 28                	ja     803488 <__udivdi3+0x7c>
  803460:	0f bd fe             	bsr    %esi,%edi
  803463:	83 f7 1f             	xor    $0x1f,%edi
  803466:	75 40                	jne    8034a8 <__udivdi3+0x9c>
  803468:	39 ce                	cmp    %ecx,%esi
  80346a:	72 0a                	jb     803476 <__udivdi3+0x6a>
  80346c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803470:	0f 87 9e 00 00 00    	ja     803514 <__udivdi3+0x108>
  803476:	b8 01 00 00 00       	mov    $0x1,%eax
  80347b:	89 fa                	mov    %edi,%edx
  80347d:	83 c4 1c             	add    $0x1c,%esp
  803480:	5b                   	pop    %ebx
  803481:	5e                   	pop    %esi
  803482:	5f                   	pop    %edi
  803483:	5d                   	pop    %ebp
  803484:	c3                   	ret    
  803485:	8d 76 00             	lea    0x0(%esi),%esi
  803488:	31 ff                	xor    %edi,%edi
  80348a:	31 c0                	xor    %eax,%eax
  80348c:	89 fa                	mov    %edi,%edx
  80348e:	83 c4 1c             	add    $0x1c,%esp
  803491:	5b                   	pop    %ebx
  803492:	5e                   	pop    %esi
  803493:	5f                   	pop    %edi
  803494:	5d                   	pop    %ebp
  803495:	c3                   	ret    
  803496:	66 90                	xchg   %ax,%ax
  803498:	89 d8                	mov    %ebx,%eax
  80349a:	f7 f7                	div    %edi
  80349c:	31 ff                	xor    %edi,%edi
  80349e:	89 fa                	mov    %edi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034ad:	89 eb                	mov    %ebp,%ebx
  8034af:	29 fb                	sub    %edi,%ebx
  8034b1:	89 f9                	mov    %edi,%ecx
  8034b3:	d3 e6                	shl    %cl,%esi
  8034b5:	89 c5                	mov    %eax,%ebp
  8034b7:	88 d9                	mov    %bl,%cl
  8034b9:	d3 ed                	shr    %cl,%ebp
  8034bb:	89 e9                	mov    %ebp,%ecx
  8034bd:	09 f1                	or     %esi,%ecx
  8034bf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034c3:	89 f9                	mov    %edi,%ecx
  8034c5:	d3 e0                	shl    %cl,%eax
  8034c7:	89 c5                	mov    %eax,%ebp
  8034c9:	89 d6                	mov    %edx,%esi
  8034cb:	88 d9                	mov    %bl,%cl
  8034cd:	d3 ee                	shr    %cl,%esi
  8034cf:	89 f9                	mov    %edi,%ecx
  8034d1:	d3 e2                	shl    %cl,%edx
  8034d3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d7:	88 d9                	mov    %bl,%cl
  8034d9:	d3 e8                	shr    %cl,%eax
  8034db:	09 c2                	or     %eax,%edx
  8034dd:	89 d0                	mov    %edx,%eax
  8034df:	89 f2                	mov    %esi,%edx
  8034e1:	f7 74 24 0c          	divl   0xc(%esp)
  8034e5:	89 d6                	mov    %edx,%esi
  8034e7:	89 c3                	mov    %eax,%ebx
  8034e9:	f7 e5                	mul    %ebp
  8034eb:	39 d6                	cmp    %edx,%esi
  8034ed:	72 19                	jb     803508 <__udivdi3+0xfc>
  8034ef:	74 0b                	je     8034fc <__udivdi3+0xf0>
  8034f1:	89 d8                	mov    %ebx,%eax
  8034f3:	31 ff                	xor    %edi,%edi
  8034f5:	e9 58 ff ff ff       	jmp    803452 <__udivdi3+0x46>
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	8b 54 24 08          	mov    0x8(%esp),%edx
  803500:	89 f9                	mov    %edi,%ecx
  803502:	d3 e2                	shl    %cl,%edx
  803504:	39 c2                	cmp    %eax,%edx
  803506:	73 e9                	jae    8034f1 <__udivdi3+0xe5>
  803508:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80350b:	31 ff                	xor    %edi,%edi
  80350d:	e9 40 ff ff ff       	jmp    803452 <__udivdi3+0x46>
  803512:	66 90                	xchg   %ax,%ax
  803514:	31 c0                	xor    %eax,%eax
  803516:	e9 37 ff ff ff       	jmp    803452 <__udivdi3+0x46>
  80351b:	90                   	nop

0080351c <__umoddi3>:
  80351c:	55                   	push   %ebp
  80351d:	57                   	push   %edi
  80351e:	56                   	push   %esi
  80351f:	53                   	push   %ebx
  803520:	83 ec 1c             	sub    $0x1c,%esp
  803523:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803527:	8b 74 24 34          	mov    0x34(%esp),%esi
  80352b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803533:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803537:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80353b:	89 f3                	mov    %esi,%ebx
  80353d:	89 fa                	mov    %edi,%edx
  80353f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803543:	89 34 24             	mov    %esi,(%esp)
  803546:	85 c0                	test   %eax,%eax
  803548:	75 1a                	jne    803564 <__umoddi3+0x48>
  80354a:	39 f7                	cmp    %esi,%edi
  80354c:	0f 86 a2 00 00 00    	jbe    8035f4 <__umoddi3+0xd8>
  803552:	89 c8                	mov    %ecx,%eax
  803554:	89 f2                	mov    %esi,%edx
  803556:	f7 f7                	div    %edi
  803558:	89 d0                	mov    %edx,%eax
  80355a:	31 d2                	xor    %edx,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	39 f0                	cmp    %esi,%eax
  803566:	0f 87 ac 00 00 00    	ja     803618 <__umoddi3+0xfc>
  80356c:	0f bd e8             	bsr    %eax,%ebp
  80356f:	83 f5 1f             	xor    $0x1f,%ebp
  803572:	0f 84 ac 00 00 00    	je     803624 <__umoddi3+0x108>
  803578:	bf 20 00 00 00       	mov    $0x20,%edi
  80357d:	29 ef                	sub    %ebp,%edi
  80357f:	89 fe                	mov    %edi,%esi
  803581:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803585:	89 e9                	mov    %ebp,%ecx
  803587:	d3 e0                	shl    %cl,%eax
  803589:	89 d7                	mov    %edx,%edi
  80358b:	89 f1                	mov    %esi,%ecx
  80358d:	d3 ef                	shr    %cl,%edi
  80358f:	09 c7                	or     %eax,%edi
  803591:	89 e9                	mov    %ebp,%ecx
  803593:	d3 e2                	shl    %cl,%edx
  803595:	89 14 24             	mov    %edx,(%esp)
  803598:	89 d8                	mov    %ebx,%eax
  80359a:	d3 e0                	shl    %cl,%eax
  80359c:	89 c2                	mov    %eax,%edx
  80359e:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a2:	d3 e0                	shl    %cl,%eax
  8035a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ac:	89 f1                	mov    %esi,%ecx
  8035ae:	d3 e8                	shr    %cl,%eax
  8035b0:	09 d0                	or     %edx,%eax
  8035b2:	d3 eb                	shr    %cl,%ebx
  8035b4:	89 da                	mov    %ebx,%edx
  8035b6:	f7 f7                	div    %edi
  8035b8:	89 d3                	mov    %edx,%ebx
  8035ba:	f7 24 24             	mull   (%esp)
  8035bd:	89 c6                	mov    %eax,%esi
  8035bf:	89 d1                	mov    %edx,%ecx
  8035c1:	39 d3                	cmp    %edx,%ebx
  8035c3:	0f 82 87 00 00 00    	jb     803650 <__umoddi3+0x134>
  8035c9:	0f 84 91 00 00 00    	je     803660 <__umoddi3+0x144>
  8035cf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035d3:	29 f2                	sub    %esi,%edx
  8035d5:	19 cb                	sbb    %ecx,%ebx
  8035d7:	89 d8                	mov    %ebx,%eax
  8035d9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035dd:	d3 e0                	shl    %cl,%eax
  8035df:	89 e9                	mov    %ebp,%ecx
  8035e1:	d3 ea                	shr    %cl,%edx
  8035e3:	09 d0                	or     %edx,%eax
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 eb                	shr    %cl,%ebx
  8035e9:	89 da                	mov    %ebx,%edx
  8035eb:	83 c4 1c             	add    $0x1c,%esp
  8035ee:	5b                   	pop    %ebx
  8035ef:	5e                   	pop    %esi
  8035f0:	5f                   	pop    %edi
  8035f1:	5d                   	pop    %ebp
  8035f2:	c3                   	ret    
  8035f3:	90                   	nop
  8035f4:	89 fd                	mov    %edi,%ebp
  8035f6:	85 ff                	test   %edi,%edi
  8035f8:	75 0b                	jne    803605 <__umoddi3+0xe9>
  8035fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ff:	31 d2                	xor    %edx,%edx
  803601:	f7 f7                	div    %edi
  803603:	89 c5                	mov    %eax,%ebp
  803605:	89 f0                	mov    %esi,%eax
  803607:	31 d2                	xor    %edx,%edx
  803609:	f7 f5                	div    %ebp
  80360b:	89 c8                	mov    %ecx,%eax
  80360d:	f7 f5                	div    %ebp
  80360f:	89 d0                	mov    %edx,%eax
  803611:	e9 44 ff ff ff       	jmp    80355a <__umoddi3+0x3e>
  803616:	66 90                	xchg   %ax,%ax
  803618:	89 c8                	mov    %ecx,%eax
  80361a:	89 f2                	mov    %esi,%edx
  80361c:	83 c4 1c             	add    $0x1c,%esp
  80361f:	5b                   	pop    %ebx
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
  803624:	3b 04 24             	cmp    (%esp),%eax
  803627:	72 06                	jb     80362f <__umoddi3+0x113>
  803629:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80362d:	77 0f                	ja     80363e <__umoddi3+0x122>
  80362f:	89 f2                	mov    %esi,%edx
  803631:	29 f9                	sub    %edi,%ecx
  803633:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803637:	89 14 24             	mov    %edx,(%esp)
  80363a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803642:	8b 14 24             	mov    (%esp),%edx
  803645:	83 c4 1c             	add    $0x1c,%esp
  803648:	5b                   	pop    %ebx
  803649:	5e                   	pop    %esi
  80364a:	5f                   	pop    %edi
  80364b:	5d                   	pop    %ebp
  80364c:	c3                   	ret    
  80364d:	8d 76 00             	lea    0x0(%esi),%esi
  803650:	2b 04 24             	sub    (%esp),%eax
  803653:	19 fa                	sbb    %edi,%edx
  803655:	89 d1                	mov    %edx,%ecx
  803657:	89 c6                	mov    %eax,%esi
  803659:	e9 71 ff ff ff       	jmp    8035cf <__umoddi3+0xb3>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803664:	72 ea                	jb     803650 <__umoddi3+0x134>
  803666:	89 d9                	mov    %ebx,%ecx
  803668:	e9 62 ff ff ff       	jmp    8035cf <__umoddi3+0xb3>
