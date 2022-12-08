
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
  800045:	68 20 36 80 00       	push   $0x803620
  80004a:	e8 db 13 00 00       	call   80142a <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 24 36 80 00       	push   $0x803624
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
  80009a:	68 49 36 80 00       	push   $0x803649
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
  8000d7:	68 50 36 80 00       	push   $0x803650
  8000dc:	e8 82 16 00 00       	call   801763 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 52 36 80 00       	push   $0x803652
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
  800127:	68 60 36 80 00       	push   $0x803660
  80012c:	e8 43 17 00 00       	call   801874 <sys_create_env>
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
  80015a:	68 6a 36 80 00       	push   $0x80366a
  80015f:	e8 10 17 00 00       	call   801874 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 1d 17 00 00       	call   801892 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 0f 17 00 00       	call   801892 <sys_run_env>
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
  80019a:	68 74 36 80 00       	push   $0x803674
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
  8001be:	e8 60 15 00 00       	call   801723 <sys_cputc>
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
  8001cf:	e8 1b 15 00 00       	call   8016ef <sys_disable_interrupt>
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
  8001e2:	e8 3c 15 00 00       	call   801723 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 1a 15 00 00       	call   801709 <sys_enable_interrupt>
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
  800201:	e8 64 13 00 00       	call   80156a <sys_cgetc>
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
  80021a:	e8 d0 14 00 00       	call   8016ef <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 3d 13 00 00       	call   80156a <sys_cgetc>
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
  800236:	e8 ce 14 00 00       	call   801709 <sys_enable_interrupt>
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
  800250:	e8 8d 16 00 00       	call   8018e2 <sys_getenvindex>
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
  8002bb:	e8 2f 14 00 00       	call   8016ef <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 a4 36 80 00       	push   $0x8036a4
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
  8002eb:	68 cc 36 80 00       	push   $0x8036cc
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
  80031c:	68 f4 36 80 00       	push   $0x8036f4
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 4c 37 80 00       	push   $0x80374c
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 a4 36 80 00       	push   $0x8036a4
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 af 13 00 00       	call   801709 <sys_enable_interrupt>

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
  80036d:	e8 3c 15 00 00       	call   8018ae <sys_destroy_env>
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
  80037e:	e8 91 15 00 00       	call   801914 <sys_exit_env>
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
  8003cc:	e8 70 11 00 00       	call   801541 <sys_cputs>
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
  800443:	e8 f9 10 00 00       	call   801541 <sys_cputs>
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
  80048d:	e8 5d 12 00 00       	call   8016ef <sys_disable_interrupt>
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
  8004ad:	e8 57 12 00 00       	call   801709 <sys_enable_interrupt>
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
  8004f7:	e8 a8 2e 00 00       	call   8033a4 <__udivdi3>
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
  800547:	e8 68 2f 00 00       	call   8034b4 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 74 39 80 00       	add    $0x803974,%eax
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
  8006a2:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
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
  800783:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 85 39 80 00       	push   $0x803985
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
  8007a8:	68 8e 39 80 00       	push   $0x80398e
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
  8007d5:	be 91 39 80 00       	mov    $0x803991,%esi
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
  8011fb:	68 f0 3a 80 00       	push   $0x803af0
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
  8012cb:	e8 b5 03 00 00       	call   801685 <sys_allocate_chunk>
  8012d0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012d3:	a1 20 41 80 00       	mov    0x804120,%eax
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	50                   	push   %eax
  8012dc:	e8 2a 0a 00 00       	call   801d0b <initialize_MemBlocksList>
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
  801309:	68 15 3b 80 00       	push   $0x803b15
  80130e:	6a 33                	push   $0x33
  801310:	68 33 3b 80 00       	push   $0x803b33
  801315:	e8 aa 1e 00 00       	call   8031c4 <_panic>
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
  801388:	68 40 3b 80 00       	push   $0x803b40
  80138d:	6a 34                	push   $0x34
  80138f:	68 33 3b 80 00       	push   $0x803b33
  801394:	e8 2b 1e 00 00       	call   8031c4 <_panic>
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
  8013fd:	68 64 3b 80 00       	push   $0x803b64
  801402:	6a 46                	push   $0x46
  801404:	68 33 3b 80 00       	push   $0x803b33
  801409:	e8 b6 1d 00 00       	call   8031c4 <_panic>
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
  801419:	68 8c 3b 80 00       	push   $0x803b8c
  80141e:	6a 61                	push   $0x61
  801420:	68 33 3b 80 00       	push   $0x803b33
  801425:	e8 9a 1d 00 00       	call   8031c4 <_panic>

0080142a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	83 ec 18             	sub    $0x18,%esp
  801430:	8b 45 10             	mov    0x10(%ebp),%eax
  801433:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801436:	e8 a9 fd ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80143b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80143f:	75 07                	jne    801448 <smalloc+0x1e>
  801441:	b8 00 00 00 00       	mov    $0x0,%eax
  801446:	eb 14                	jmp    80145c <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801448:	83 ec 04             	sub    $0x4,%esp
  80144b:	68 b0 3b 80 00       	push   $0x803bb0
  801450:	6a 76                	push   $0x76
  801452:	68 33 3b 80 00       	push   $0x803b33
  801457:	e8 68 1d 00 00       	call   8031c4 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801464:	e8 7b fd ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801469:	83 ec 04             	sub    $0x4,%esp
  80146c:	68 d8 3b 80 00       	push   $0x803bd8
  801471:	68 93 00 00 00       	push   $0x93
  801476:	68 33 3b 80 00       	push   $0x803b33
  80147b:	e8 44 1d 00 00       	call   8031c4 <_panic>

00801480 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801486:	e8 59 fd ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	68 fc 3b 80 00       	push   $0x803bfc
  801493:	68 c5 00 00 00       	push   $0xc5
  801498:	68 33 3b 80 00       	push   $0x803b33
  80149d:	e8 22 1d 00 00       	call   8031c4 <_panic>

008014a2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014a8:	83 ec 04             	sub    $0x4,%esp
  8014ab:	68 24 3c 80 00       	push   $0x803c24
  8014b0:	68 d9 00 00 00       	push   $0xd9
  8014b5:	68 33 3b 80 00       	push   $0x803b33
  8014ba:	e8 05 1d 00 00       	call   8031c4 <_panic>

008014bf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014c5:	83 ec 04             	sub    $0x4,%esp
  8014c8:	68 48 3c 80 00       	push   $0x803c48
  8014cd:	68 e4 00 00 00       	push   $0xe4
  8014d2:	68 33 3b 80 00       	push   $0x803b33
  8014d7:	e8 e8 1c 00 00       	call   8031c4 <_panic>

008014dc <shrink>:

}
void shrink(uint32 newSize)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014e2:	83 ec 04             	sub    $0x4,%esp
  8014e5:	68 48 3c 80 00       	push   $0x803c48
  8014ea:	68 e9 00 00 00       	push   $0xe9
  8014ef:	68 33 3b 80 00       	push   $0x803b33
  8014f4:	e8 cb 1c 00 00       	call   8031c4 <_panic>

008014f9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014f9:	55                   	push   %ebp
  8014fa:	89 e5                	mov    %esp,%ebp
  8014fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014ff:	83 ec 04             	sub    $0x4,%esp
  801502:	68 48 3c 80 00       	push   $0x803c48
  801507:	68 ee 00 00 00       	push   $0xee
  80150c:	68 33 3b 80 00       	push   $0x803b33
  801511:	e8 ae 1c 00 00       	call   8031c4 <_panic>

00801516 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	57                   	push   %edi
  80151a:	56                   	push   %esi
  80151b:	53                   	push   %ebx
  80151c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801528:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80152b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80152e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801531:	cd 30                	int    $0x30
  801533:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	5b                   	pop    %ebx
  80153d:	5e                   	pop    %esi
  80153e:	5f                   	pop    %edi
  80153f:	5d                   	pop    %ebp
  801540:	c3                   	ret    

00801541 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 04             	sub    $0x4,%esp
  801547:	8b 45 10             	mov    0x10(%ebp),%eax
  80154a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80154d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801551:	8b 45 08             	mov    0x8(%ebp),%eax
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	52                   	push   %edx
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	50                   	push   %eax
  80155d:	6a 00                	push   $0x0
  80155f:	e8 b2 ff ff ff       	call   801516 <syscall>
  801564:	83 c4 18             	add    $0x18,%esp
}
  801567:	90                   	nop
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sys_cgetc>:

int
sys_cgetc(void)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 01                	push   $0x1
  801579:	e8 98 ff ff ff       	call   801516 <syscall>
  80157e:	83 c4 18             	add    $0x18,%esp
}
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801586:	8b 55 0c             	mov    0xc(%ebp),%edx
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	6a 00                	push   $0x0
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	52                   	push   %edx
  801593:	50                   	push   %eax
  801594:	6a 05                	push   $0x5
  801596:	e8 7b ff ff ff       	call   801516 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8015a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	56                   	push   %esi
  8015b5:	53                   	push   %ebx
  8015b6:	51                   	push   %ecx
  8015b7:	52                   	push   %edx
  8015b8:	50                   	push   %eax
  8015b9:	6a 06                	push   $0x6
  8015bb:	e8 56 ff ff ff       	call   801516 <syscall>
  8015c0:	83 c4 18             	add    $0x18,%esp
}
  8015c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c6:	5b                   	pop    %ebx
  8015c7:	5e                   	pop    %esi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	52                   	push   %edx
  8015da:	50                   	push   %eax
  8015db:	6a 07                	push   $0x7
  8015dd:	e8 34 ff ff ff       	call   801516 <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	ff 75 0c             	pushl  0xc(%ebp)
  8015f3:	ff 75 08             	pushl  0x8(%ebp)
  8015f6:	6a 08                	push   $0x8
  8015f8:	e8 19 ff ff ff       	call   801516 <syscall>
  8015fd:	83 c4 18             	add    $0x18,%esp
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 09                	push   $0x9
  801611:	e8 00 ff ff ff       	call   801516 <syscall>
  801616:	83 c4 18             	add    $0x18,%esp
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80161e:	6a 00                	push   $0x0
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 0a                	push   $0xa
  80162a:	e8 e7 fe ff ff       	call   801516 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 0b                	push   $0xb
  801643:	e8 ce fe ff ff       	call   801516 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	6a 0f                	push   $0xf
  80165e:	e8 b3 fe ff ff       	call   801516 <syscall>
  801663:	83 c4 18             	add    $0x18,%esp
	return;
  801666:	90                   	nop
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	6a 10                	push   $0x10
  80167a:	e8 97 fe ff ff       	call   801516 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
	return ;
  801682:	90                   	nop
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 10             	pushl  0x10(%ebp)
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	6a 11                	push   $0x11
  801697:	e8 7a fe ff ff       	call   801516 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
	return ;
  80169f:	90                   	nop
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 0c                	push   $0xc
  8016b1:	e8 60 fe ff ff       	call   801516 <syscall>
  8016b6:	83 c4 18             	add    $0x18,%esp
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	ff 75 08             	pushl  0x8(%ebp)
  8016c9:	6a 0d                	push   $0xd
  8016cb:	e8 46 fe ff ff       	call   801516 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 0e                	push   $0xe
  8016e4:	e8 2d fe ff ff       	call   801516 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	90                   	nop
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 13                	push   $0x13
  8016fe:	e8 13 fe ff ff       	call   801516 <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	90                   	nop
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 14                	push   $0x14
  801718:	e8 f9 fd ff ff       	call   801516 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	90                   	nop
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_cputc>:


void
sys_cputc(const char c)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80172f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	50                   	push   %eax
  80173c:	6a 15                	push   $0x15
  80173e:	e8 d3 fd ff ff       	call   801516 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	90                   	nop
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 16                	push   $0x16
  801758:	e8 b9 fd ff ff       	call   801516 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	90                   	nop
  801761:	c9                   	leave  
  801762:	c3                   	ret    

00801763 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801763:	55                   	push   %ebp
  801764:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	ff 75 0c             	pushl  0xc(%ebp)
  801772:	50                   	push   %eax
  801773:	6a 17                	push   $0x17
  801775:	e8 9c fd ff ff       	call   801516 <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	52                   	push   %edx
  80178f:	50                   	push   %eax
  801790:	6a 1a                	push   $0x1a
  801792:	e8 7f fd ff ff       	call   801516 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	6a 18                	push   $0x18
  8017af:	e8 62 fd ff ff       	call   801516 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	52                   	push   %edx
  8017ca:	50                   	push   %eax
  8017cb:	6a 19                	push   $0x19
  8017cd:	e8 44 fd ff ff       	call   801516 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017e4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017e7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	6a 00                	push   $0x0
  8017f0:	51                   	push   %ecx
  8017f1:	52                   	push   %edx
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	50                   	push   %eax
  8017f6:	6a 1b                	push   $0x1b
  8017f8:	e8 19 fd ff ff       	call   801516 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801805:	8b 55 0c             	mov    0xc(%ebp),%edx
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	52                   	push   %edx
  801812:	50                   	push   %eax
  801813:	6a 1c                	push   $0x1c
  801815:	e8 fc fc ff ff       	call   801516 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801822:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	51                   	push   %ecx
  801830:	52                   	push   %edx
  801831:	50                   	push   %eax
  801832:	6a 1d                	push   $0x1d
  801834:	e8 dd fc ff ff       	call   801516 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	52                   	push   %edx
  80184e:	50                   	push   %eax
  80184f:	6a 1e                	push   $0x1e
  801851:	e8 c0 fc ff ff       	call   801516 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 1f                	push   $0x1f
  80186a:	e8 a7 fc ff ff       	call   801516 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	ff 75 14             	pushl  0x14(%ebp)
  80187f:	ff 75 10             	pushl  0x10(%ebp)
  801882:	ff 75 0c             	pushl  0xc(%ebp)
  801885:	50                   	push   %eax
  801886:	6a 20                	push   $0x20
  801888:	e8 89 fc ff ff       	call   801516 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	50                   	push   %eax
  8018a1:	6a 21                	push   $0x21
  8018a3:	e8 6e fc ff ff       	call   801516 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	90                   	nop
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	50                   	push   %eax
  8018bd:	6a 22                	push   $0x22
  8018bf:	e8 52 fc ff ff       	call   801516 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 02                	push   $0x2
  8018d8:	e8 39 fc ff ff       	call   801516 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 03                	push   $0x3
  8018f1:	e8 20 fc ff ff       	call   801516 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 04                	push   $0x4
  80190a:	e8 07 fc ff ff       	call   801516 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <sys_exit_env>:


void sys_exit_env(void)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 23                	push   $0x23
  801923:	e8 ee fb ff ff       	call   801516 <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
}
  80192b:	90                   	nop
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801934:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801937:	8d 50 04             	lea    0x4(%eax),%edx
  80193a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 24                	push   $0x24
  801947:	e8 ca fb ff ff       	call   801516 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
	return result;
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801955:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801958:	89 01                	mov    %eax,(%ecx)
  80195a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	c9                   	leave  
  801961:	c2 04 00             	ret    $0x4

00801964 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 10             	pushl  0x10(%ebp)
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	ff 75 08             	pushl  0x8(%ebp)
  801974:	6a 12                	push   $0x12
  801976:	e8 9b fb ff ff       	call   801516 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
	return ;
  80197e:	90                   	nop
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_rcr2>:
uint32 sys_rcr2()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 25                	push   $0x25
  801990:	e8 81 fb ff ff       	call   801516 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019a6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	50                   	push   %eax
  8019b3:	6a 26                	push   $0x26
  8019b5:	e8 5c fb ff ff       	call   801516 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bd:	90                   	nop
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <rsttst>:
void rsttst()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 28                	push   $0x28
  8019cf:	e8 42 fb ff ff       	call   801516 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 04             	sub    $0x4,%esp
  8019e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019e6:	8b 55 18             	mov    0x18(%ebp),%edx
  8019e9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ed:	52                   	push   %edx
  8019ee:	50                   	push   %eax
  8019ef:	ff 75 10             	pushl  0x10(%ebp)
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	6a 27                	push   $0x27
  8019fa:	e8 17 fb ff ff       	call   801516 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801a02:	90                   	nop
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <chktst>:
void chktst(uint32 n)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 29                	push   $0x29
  801a15:	e8 fc fa ff ff       	call   801516 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <inctst>:

void inctst()
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 2a                	push   $0x2a
  801a2f:	e8 e2 fa ff ff       	call   801516 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return ;
  801a37:	90                   	nop
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <gettst>:
uint32 gettst()
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 2b                	push   $0x2b
  801a49:	e8 c8 fa ff ff       	call   801516 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 2c                	push   $0x2c
  801a65:	e8 ac fa ff ff       	call   801516 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
  801a6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a70:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a74:	75 07                	jne    801a7d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a76:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7b:	eb 05                	jmp    801a82 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 2c                	push   $0x2c
  801a96:	e8 7b fa ff ff       	call   801516 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
  801a9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801aa1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aa5:	75 07                	jne    801aae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aa7:	b8 01 00 00 00       	mov    $0x1,%eax
  801aac:	eb 05                	jmp    801ab3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 2c                	push   $0x2c
  801ac7:	e8 4a fa ff ff       	call   801516 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
  801acf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ad2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ad6:	75 07                	jne    801adf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  801add:	eb 05                	jmp    801ae4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 2c                	push   $0x2c
  801af8:	e8 19 fa ff ff       	call   801516 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
  801b00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b03:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b07:	75 07                	jne    801b10 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b09:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0e:	eb 05                	jmp    801b15 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 08             	pushl  0x8(%ebp)
  801b25:	6a 2d                	push   $0x2d
  801b27:	e8 ea f9 ff ff       	call   801516 <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2f:	90                   	nop
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	53                   	push   %ebx
  801b45:	51                   	push   %ecx
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 2e                	push   $0x2e
  801b4a:	e8 c7 f9 ff ff       	call   801516 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 2f                	push   $0x2f
  801b6a:	e8 a7 f9 ff ff       	call   801516 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	68 58 3c 80 00       	push   $0x803c58
  801b82:	e8 d3 e8 ff ff       	call   80045a <cprintf>
  801b87:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b91:	83 ec 0c             	sub    $0xc,%esp
  801b94:	68 84 3c 80 00       	push   $0x803c84
  801b99:	e8 bc e8 ff ff       	call   80045a <cprintf>
  801b9e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ba1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ba5:	a1 38 41 80 00       	mov    0x804138,%eax
  801baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bad:	eb 56                	jmp    801c05 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801baf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bb3:	74 1c                	je     801bd1 <print_mem_block_lists+0x5d>
  801bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb8:	8b 50 08             	mov    0x8(%eax),%edx
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	8b 48 08             	mov    0x8(%eax),%ecx
  801bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc7:	01 c8                	add    %ecx,%eax
  801bc9:	39 c2                	cmp    %eax,%edx
  801bcb:	73 04                	jae    801bd1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801bcd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd4:	8b 50 08             	mov    0x8(%eax),%edx
  801bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bda:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdd:	01 c2                	add    %eax,%edx
  801bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be2:	8b 40 08             	mov    0x8(%eax),%eax
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	52                   	push   %edx
  801be9:	50                   	push   %eax
  801bea:	68 99 3c 80 00       	push   $0x803c99
  801bef:	e8 66 e8 ff ff       	call   80045a <cprintf>
  801bf4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801bfd:	a1 40 41 80 00       	mov    0x804140,%eax
  801c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c09:	74 07                	je     801c12 <print_mem_block_lists+0x9e>
  801c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0e:	8b 00                	mov    (%eax),%eax
  801c10:	eb 05                	jmp    801c17 <print_mem_block_lists+0xa3>
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
  801c17:	a3 40 41 80 00       	mov    %eax,0x804140
  801c1c:	a1 40 41 80 00       	mov    0x804140,%eax
  801c21:	85 c0                	test   %eax,%eax
  801c23:	75 8a                	jne    801baf <print_mem_block_lists+0x3b>
  801c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c29:	75 84                	jne    801baf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c2b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c2f:	75 10                	jne    801c41 <print_mem_block_lists+0xcd>
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	68 a8 3c 80 00       	push   $0x803ca8
  801c39:	e8 1c e8 ff ff       	call   80045a <cprintf>
  801c3e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801c41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	68 cc 3c 80 00       	push   $0x803ccc
  801c50:	e8 05 e8 ff ff       	call   80045a <cprintf>
  801c55:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801c58:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c5c:	a1 40 40 80 00       	mov    0x804040,%eax
  801c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c64:	eb 56                	jmp    801cbc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c6a:	74 1c                	je     801c88 <print_mem_block_lists+0x114>
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	8b 50 08             	mov    0x8(%eax),%edx
  801c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c75:	8b 48 08             	mov    0x8(%eax),%ecx
  801c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7e:	01 c8                	add    %ecx,%eax
  801c80:	39 c2                	cmp    %eax,%edx
  801c82:	73 04                	jae    801c88 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c84:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	8b 50 08             	mov    0x8(%eax),%edx
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	8b 40 0c             	mov    0xc(%eax),%eax
  801c94:	01 c2                	add    %eax,%edx
  801c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c99:	8b 40 08             	mov    0x8(%eax),%eax
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	68 99 3c 80 00       	push   $0x803c99
  801ca6:	e8 af e7 ff ff       	call   80045a <cprintf>
  801cab:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801cb4:	a1 48 40 80 00       	mov    0x804048,%eax
  801cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc0:	74 07                	je     801cc9 <print_mem_block_lists+0x155>
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	8b 00                	mov    (%eax),%eax
  801cc7:	eb 05                	jmp    801cce <print_mem_block_lists+0x15a>
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cce:	a3 48 40 80 00       	mov    %eax,0x804048
  801cd3:	a1 48 40 80 00       	mov    0x804048,%eax
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	75 8a                	jne    801c66 <print_mem_block_lists+0xf2>
  801cdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ce0:	75 84                	jne    801c66 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ce2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ce6:	75 10                	jne    801cf8 <print_mem_block_lists+0x184>
  801ce8:	83 ec 0c             	sub    $0xc,%esp
  801ceb:	68 e4 3c 80 00       	push   $0x803ce4
  801cf0:	e8 65 e7 ff ff       	call   80045a <cprintf>
  801cf5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801cf8:	83 ec 0c             	sub    $0xc,%esp
  801cfb:	68 58 3c 80 00       	push   $0x803c58
  801d00:	e8 55 e7 ff ff       	call   80045a <cprintf>
  801d05:	83 c4 10             	add    $0x10,%esp

}
  801d08:	90                   	nop
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801d11:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801d18:	00 00 00 
  801d1b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801d22:	00 00 00 
  801d25:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d2c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d36:	e9 9e 00 00 00       	jmp    801dd9 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801d3b:	a1 50 40 80 00       	mov    0x804050,%eax
  801d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d43:	c1 e2 04             	shl    $0x4,%edx
  801d46:	01 d0                	add    %edx,%eax
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	75 14                	jne    801d60 <initialize_MemBlocksList+0x55>
  801d4c:	83 ec 04             	sub    $0x4,%esp
  801d4f:	68 0c 3d 80 00       	push   $0x803d0c
  801d54:	6a 46                	push   $0x46
  801d56:	68 2f 3d 80 00       	push   $0x803d2f
  801d5b:	e8 64 14 00 00       	call   8031c4 <_panic>
  801d60:	a1 50 40 80 00       	mov    0x804050,%eax
  801d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d68:	c1 e2 04             	shl    $0x4,%edx
  801d6b:	01 d0                	add    %edx,%eax
  801d6d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801d73:	89 10                	mov    %edx,(%eax)
  801d75:	8b 00                	mov    (%eax),%eax
  801d77:	85 c0                	test   %eax,%eax
  801d79:	74 18                	je     801d93 <initialize_MemBlocksList+0x88>
  801d7b:	a1 48 41 80 00       	mov    0x804148,%eax
  801d80:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d86:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d89:	c1 e1 04             	shl    $0x4,%ecx
  801d8c:	01 ca                	add    %ecx,%edx
  801d8e:	89 50 04             	mov    %edx,0x4(%eax)
  801d91:	eb 12                	jmp    801da5 <initialize_MemBlocksList+0x9a>
  801d93:	a1 50 40 80 00       	mov    0x804050,%eax
  801d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9b:	c1 e2 04             	shl    $0x4,%edx
  801d9e:	01 d0                	add    %edx,%eax
  801da0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801da5:	a1 50 40 80 00       	mov    0x804050,%eax
  801daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dad:	c1 e2 04             	shl    $0x4,%edx
  801db0:	01 d0                	add    %edx,%eax
  801db2:	a3 48 41 80 00       	mov    %eax,0x804148
  801db7:	a1 50 40 80 00       	mov    0x804050,%eax
  801dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbf:	c1 e2 04             	shl    $0x4,%edx
  801dc2:	01 d0                	add    %edx,%eax
  801dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dcb:	a1 54 41 80 00       	mov    0x804154,%eax
  801dd0:	40                   	inc    %eax
  801dd1:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801dd6:	ff 45 f4             	incl   -0xc(%ebp)
  801dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddc:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ddf:	0f 82 56 ff ff ff    	jb     801d3b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801de5:	90                   	nop
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801dee:	8b 45 08             	mov    0x8(%ebp),%eax
  801df1:	8b 00                	mov    (%eax),%eax
  801df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801df6:	eb 19                	jmp    801e11 <find_block+0x29>
	{
		if(va==point->sva)
  801df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfb:	8b 40 08             	mov    0x8(%eax),%eax
  801dfe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e01:	75 05                	jne    801e08 <find_block+0x20>
		   return point;
  801e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e06:	eb 36                	jmp    801e3e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	8b 40 08             	mov    0x8(%eax),%eax
  801e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e11:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e15:	74 07                	je     801e1e <find_block+0x36>
  801e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e1a:	8b 00                	mov    (%eax),%eax
  801e1c:	eb 05                	jmp    801e23 <find_block+0x3b>
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e23:	8b 55 08             	mov    0x8(%ebp),%edx
  801e26:	89 42 08             	mov    %eax,0x8(%edx)
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	8b 40 08             	mov    0x8(%eax),%eax
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	75 c5                	jne    801df8 <find_block+0x10>
  801e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e37:	75 bf                	jne    801df8 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801e46:	a1 40 40 80 00       	mov    0x804040,%eax
  801e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801e4e:	a1 44 40 80 00       	mov    0x804044,%eax
  801e53:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e59:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e5c:	74 24                	je     801e82 <insert_sorted_allocList+0x42>
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	8b 50 08             	mov    0x8(%eax),%edx
  801e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e67:	8b 40 08             	mov    0x8(%eax),%eax
  801e6a:	39 c2                	cmp    %eax,%edx
  801e6c:	76 14                	jbe    801e82 <insert_sorted_allocList+0x42>
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	8b 50 08             	mov    0x8(%eax),%edx
  801e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e77:	8b 40 08             	mov    0x8(%eax),%eax
  801e7a:	39 c2                	cmp    %eax,%edx
  801e7c:	0f 82 60 01 00 00    	jb     801fe2 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e86:	75 65                	jne    801eed <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e8c:	75 14                	jne    801ea2 <insert_sorted_allocList+0x62>
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	68 0c 3d 80 00       	push   $0x803d0c
  801e96:	6a 6b                	push   $0x6b
  801e98:	68 2f 3d 80 00       	push   $0x803d2f
  801e9d:	e8 22 13 00 00       	call   8031c4 <_panic>
  801ea2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	89 10                	mov    %edx,(%eax)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	8b 00                	mov    (%eax),%eax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	74 0d                	je     801ec3 <insert_sorted_allocList+0x83>
  801eb6:	a1 40 40 80 00       	mov    0x804040,%eax
  801ebb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebe:	89 50 04             	mov    %edx,0x4(%eax)
  801ec1:	eb 08                	jmp    801ecb <insert_sorted_allocList+0x8b>
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	a3 44 40 80 00       	mov    %eax,0x804044
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	a3 40 40 80 00       	mov    %eax,0x804040
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801edd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ee2:	40                   	inc    %eax
  801ee3:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ee8:	e9 dc 01 00 00       	jmp    8020c9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	8b 50 08             	mov    0x8(%eax),%edx
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	8b 40 08             	mov    0x8(%eax),%eax
  801ef9:	39 c2                	cmp    %eax,%edx
  801efb:	77 6c                	ja     801f69 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801efd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f01:	74 06                	je     801f09 <insert_sorted_allocList+0xc9>
  801f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f07:	75 14                	jne    801f1d <insert_sorted_allocList+0xdd>
  801f09:	83 ec 04             	sub    $0x4,%esp
  801f0c:	68 48 3d 80 00       	push   $0x803d48
  801f11:	6a 6f                	push   $0x6f
  801f13:	68 2f 3d 80 00       	push   $0x803d2f
  801f18:	e8 a7 12 00 00       	call   8031c4 <_panic>
  801f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f20:	8b 50 04             	mov    0x4(%eax),%edx
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	89 50 04             	mov    %edx,0x4(%eax)
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f2f:	89 10                	mov    %edx,(%eax)
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	8b 40 04             	mov    0x4(%eax),%eax
  801f37:	85 c0                	test   %eax,%eax
  801f39:	74 0d                	je     801f48 <insert_sorted_allocList+0x108>
  801f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3e:	8b 40 04             	mov    0x4(%eax),%eax
  801f41:	8b 55 08             	mov    0x8(%ebp),%edx
  801f44:	89 10                	mov    %edx,(%eax)
  801f46:	eb 08                	jmp    801f50 <insert_sorted_allocList+0x110>
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	a3 40 40 80 00       	mov    %eax,0x804040
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f53:	8b 55 08             	mov    0x8(%ebp),%edx
  801f56:	89 50 04             	mov    %edx,0x4(%eax)
  801f59:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f5e:	40                   	inc    %eax
  801f5f:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f64:	e9 60 01 00 00       	jmp    8020c9 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	8b 50 08             	mov    0x8(%eax),%edx
  801f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	39 c2                	cmp    %eax,%edx
  801f77:	0f 82 4c 01 00 00    	jb     8020c9 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f81:	75 14                	jne    801f97 <insert_sorted_allocList+0x157>
  801f83:	83 ec 04             	sub    $0x4,%esp
  801f86:	68 80 3d 80 00       	push   $0x803d80
  801f8b:	6a 73                	push   $0x73
  801f8d:	68 2f 3d 80 00       	push   $0x803d2f
  801f92:	e8 2d 12 00 00       	call   8031c4 <_panic>
  801f97:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	89 50 04             	mov    %edx,0x4(%eax)
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	8b 40 04             	mov    0x4(%eax),%eax
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	74 0c                	je     801fb9 <insert_sorted_allocList+0x179>
  801fad:	a1 44 40 80 00       	mov    0x804044,%eax
  801fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb5:	89 10                	mov    %edx,(%eax)
  801fb7:	eb 08                	jmp    801fc1 <insert_sorted_allocList+0x181>
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	a3 40 40 80 00       	mov    %eax,0x804040
  801fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc4:	a3 44 40 80 00       	mov    %eax,0x804044
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fd2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fd7:	40                   	inc    %eax
  801fd8:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fdd:	e9 e7 00 00 00       	jmp    8020c9 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801fe8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801fef:	a1 40 40 80 00       	mov    0x804040,%eax
  801ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff7:	e9 9d 00 00 00       	jmp    802099 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 00                	mov    (%eax),%eax
  802001:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	8b 50 08             	mov    0x8(%eax),%edx
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 40 08             	mov    0x8(%eax),%eax
  802010:	39 c2                	cmp    %eax,%edx
  802012:	76 7d                	jbe    802091 <insert_sorted_allocList+0x251>
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8b 50 08             	mov    0x8(%eax),%edx
  80201a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80201d:	8b 40 08             	mov    0x8(%eax),%eax
  802020:	39 c2                	cmp    %eax,%edx
  802022:	73 6d                	jae    802091 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802024:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802028:	74 06                	je     802030 <insert_sorted_allocList+0x1f0>
  80202a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80202e:	75 14                	jne    802044 <insert_sorted_allocList+0x204>
  802030:	83 ec 04             	sub    $0x4,%esp
  802033:	68 a4 3d 80 00       	push   $0x803da4
  802038:	6a 7f                	push   $0x7f
  80203a:	68 2f 3d 80 00       	push   $0x803d2f
  80203f:	e8 80 11 00 00       	call   8031c4 <_panic>
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 10                	mov    (%eax),%edx
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	89 10                	mov    %edx,(%eax)
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	74 0b                	je     802062 <insert_sorted_allocList+0x222>
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	8b 00                	mov    (%eax),%eax
  80205c:	8b 55 08             	mov    0x8(%ebp),%edx
  80205f:	89 50 04             	mov    %edx,0x4(%eax)
  802062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802065:	8b 55 08             	mov    0x8(%ebp),%edx
  802068:	89 10                	mov    %edx,(%eax)
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802070:	89 50 04             	mov    %edx,0x4(%eax)
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	8b 00                	mov    (%eax),%eax
  802078:	85 c0                	test   %eax,%eax
  80207a:	75 08                	jne    802084 <insert_sorted_allocList+0x244>
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	a3 44 40 80 00       	mov    %eax,0x804044
  802084:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802089:	40                   	inc    %eax
  80208a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80208f:	eb 39                	jmp    8020ca <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802091:	a1 48 40 80 00       	mov    0x804048,%eax
  802096:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209d:	74 07                	je     8020a6 <insert_sorted_allocList+0x266>
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	eb 05                	jmp    8020ab <insert_sorted_allocList+0x26b>
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	a3 48 40 80 00       	mov    %eax,0x804048
  8020b0:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	0f 85 3f ff ff ff    	jne    801ffc <insert_sorted_allocList+0x1bc>
  8020bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c1:	0f 85 35 ff ff ff    	jne    801ffc <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8020c7:	eb 01                	jmp    8020ca <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c9:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8020ca:	90                   	nop
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8020d3:	a1 38 41 80 00       	mov    0x804138,%eax
  8020d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020db:	e9 85 01 00 00       	jmp    802265 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e9:	0f 82 6e 01 00 00    	jb     80225d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020f8:	0f 85 8a 00 00 00    	jne    802188 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8020fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802102:	75 17                	jne    80211b <alloc_block_FF+0x4e>
  802104:	83 ec 04             	sub    $0x4,%esp
  802107:	68 d8 3d 80 00       	push   $0x803dd8
  80210c:	68 93 00 00 00       	push   $0x93
  802111:	68 2f 3d 80 00       	push   $0x803d2f
  802116:	e8 a9 10 00 00       	call   8031c4 <_panic>
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 10                	je     802134 <alloc_block_FF+0x67>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 00                	mov    (%eax),%eax
  802129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212c:	8b 52 04             	mov    0x4(%edx),%edx
  80212f:	89 50 04             	mov    %edx,0x4(%eax)
  802132:	eb 0b                	jmp    80213f <alloc_block_FF+0x72>
  802134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802137:	8b 40 04             	mov    0x4(%eax),%eax
  80213a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	8b 40 04             	mov    0x4(%eax),%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	74 0f                	je     802158 <alloc_block_FF+0x8b>
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 40 04             	mov    0x4(%eax),%eax
  80214f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802152:	8b 12                	mov    (%edx),%edx
  802154:	89 10                	mov    %edx,(%eax)
  802156:	eb 0a                	jmp    802162 <alloc_block_FF+0x95>
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	8b 00                	mov    (%eax),%eax
  80215d:	a3 38 41 80 00       	mov    %eax,0x804138
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802175:	a1 44 41 80 00       	mov    0x804144,%eax
  80217a:	48                   	dec    %eax
  80217b:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	e9 10 01 00 00       	jmp    802298 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	8b 40 0c             	mov    0xc(%eax),%eax
  80218e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802191:	0f 86 c6 00 00 00    	jbe    80225d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802197:	a1 48 41 80 00       	mov    0x804148,%eax
  80219c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80219f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a2:	8b 50 08             	mov    0x8(%eax),%edx
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8021ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8021b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b8:	75 17                	jne    8021d1 <alloc_block_FF+0x104>
  8021ba:	83 ec 04             	sub    $0x4,%esp
  8021bd:	68 d8 3d 80 00       	push   $0x803dd8
  8021c2:	68 9b 00 00 00       	push   $0x9b
  8021c7:	68 2f 3d 80 00       	push   $0x803d2f
  8021cc:	e8 f3 0f 00 00       	call   8031c4 <_panic>
  8021d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d4:	8b 00                	mov    (%eax),%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	74 10                	je     8021ea <alloc_block_FF+0x11d>
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	8b 00                	mov    (%eax),%eax
  8021df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e2:	8b 52 04             	mov    0x4(%edx),%edx
  8021e5:	89 50 04             	mov    %edx,0x4(%eax)
  8021e8:	eb 0b                	jmp    8021f5 <alloc_block_FF+0x128>
  8021ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ed:	8b 40 04             	mov    0x4(%eax),%eax
  8021f0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f8:	8b 40 04             	mov    0x4(%eax),%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	74 0f                	je     80220e <alloc_block_FF+0x141>
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	8b 40 04             	mov    0x4(%eax),%eax
  802205:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802208:	8b 12                	mov    (%edx),%edx
  80220a:	89 10                	mov    %edx,(%eax)
  80220c:	eb 0a                	jmp    802218 <alloc_block_FF+0x14b>
  80220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	a3 48 41 80 00       	mov    %eax,0x804148
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222b:	a1 54 41 80 00       	mov    0x804154,%eax
  802230:	48                   	dec    %eax
  802231:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	8b 50 08             	mov    0x8(%eax),%edx
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	01 c2                	add    %eax,%edx
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 40 0c             	mov    0xc(%eax),%eax
  80224d:	2b 45 08             	sub    0x8(%ebp),%eax
  802250:	89 c2                	mov    %eax,%edx
  802252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802255:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225b:	eb 3b                	jmp    802298 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80225d:	a1 40 41 80 00       	mov    0x804140,%eax
  802262:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802269:	74 07                	je     802272 <alloc_block_FF+0x1a5>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	eb 05                	jmp    802277 <alloc_block_FF+0x1aa>
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
  802277:	a3 40 41 80 00       	mov    %eax,0x804140
  80227c:	a1 40 41 80 00       	mov    0x804140,%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	0f 85 57 fe ff ff    	jne    8020e0 <alloc_block_FF+0x13>
  802289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228d:	0f 85 4d fe ff ff    	jne    8020e0 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8022a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8022a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8022ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022af:	e9 df 00 00 00       	jmp    802393 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bd:	0f 82 c8 00 00 00    	jb     80238b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022cc:	0f 85 8a 00 00 00    	jne    80235c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8022d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d6:	75 17                	jne    8022ef <alloc_block_BF+0x55>
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	68 d8 3d 80 00       	push   $0x803dd8
  8022e0:	68 b7 00 00 00       	push   $0xb7
  8022e5:	68 2f 3d 80 00       	push   $0x803d2f
  8022ea:	e8 d5 0e 00 00       	call   8031c4 <_panic>
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	74 10                	je     802308 <alloc_block_BF+0x6e>
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802300:	8b 52 04             	mov    0x4(%edx),%edx
  802303:	89 50 04             	mov    %edx,0x4(%eax)
  802306:	eb 0b                	jmp    802313 <alloc_block_BF+0x79>
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 04             	mov    0x4(%eax),%eax
  80230e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 40 04             	mov    0x4(%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 0f                	je     80232c <alloc_block_BF+0x92>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802326:	8b 12                	mov    (%edx),%edx
  802328:	89 10                	mov    %edx,(%eax)
  80232a:	eb 0a                	jmp    802336 <alloc_block_BF+0x9c>
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	a3 38 41 80 00       	mov    %eax,0x804138
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802349:	a1 44 41 80 00       	mov    0x804144,%eax
  80234e:	48                   	dec    %eax
  80234f:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	e9 4d 01 00 00       	jmp    8024a9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 40 0c             	mov    0xc(%eax),%eax
  802362:	3b 45 08             	cmp    0x8(%ebp),%eax
  802365:	76 24                	jbe    80238b <alloc_block_BF+0xf1>
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 40 0c             	mov    0xc(%eax),%eax
  80236d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802370:	73 19                	jae    80238b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802372:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 40 0c             	mov    0xc(%eax),%eax
  80237f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 40 08             	mov    0x8(%eax),%eax
  802388:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80238b:	a1 40 41 80 00       	mov    0x804140,%eax
  802390:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802397:	74 07                	je     8023a0 <alloc_block_BF+0x106>
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	eb 05                	jmp    8023a5 <alloc_block_BF+0x10b>
  8023a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a5:	a3 40 41 80 00       	mov    %eax,0x804140
  8023aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	0f 85 fd fe ff ff    	jne    8022b4 <alloc_block_BF+0x1a>
  8023b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bb:	0f 85 f3 fe ff ff    	jne    8022b4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8023c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023c5:	0f 84 d9 00 00 00    	je     8024a4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023cb:	a1 48 41 80 00       	mov    0x804148,%eax
  8023d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8023d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d9:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8023dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023df:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e2:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8023e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023e9:	75 17                	jne    802402 <alloc_block_BF+0x168>
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 d8 3d 80 00       	push   $0x803dd8
  8023f3:	68 c7 00 00 00       	push   $0xc7
  8023f8:	68 2f 3d 80 00       	push   $0x803d2f
  8023fd:	e8 c2 0d 00 00       	call   8031c4 <_panic>
  802402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 10                	je     80241b <alloc_block_BF+0x181>
  80240b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802413:	8b 52 04             	mov    0x4(%edx),%edx
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	eb 0b                	jmp    802426 <alloc_block_BF+0x18c>
  80241b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0f                	je     80243f <alloc_block_BF+0x1a5>
  802430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802439:	8b 12                	mov    (%edx),%edx
  80243b:	89 10                	mov    %edx,(%eax)
  80243d:	eb 0a                	jmp    802449 <alloc_block_BF+0x1af>
  80243f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	a3 48 41 80 00       	mov    %eax,0x804148
  802449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80244c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245c:	a1 54 41 80 00       	mov    0x804154,%eax
  802461:	48                   	dec    %eax
  802462:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802467:	83 ec 08             	sub    $0x8,%esp
  80246a:	ff 75 ec             	pushl  -0x14(%ebp)
  80246d:	68 38 41 80 00       	push   $0x804138
  802472:	e8 71 f9 ff ff       	call   801de8 <find_block>
  802477:	83 c4 10             	add    $0x10,%esp
  80247a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80247d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802480:	8b 50 08             	mov    0x8(%eax),%edx
  802483:	8b 45 08             	mov    0x8(%ebp),%eax
  802486:	01 c2                	add    %eax,%edx
  802488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80248b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80248e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802491:	8b 40 0c             	mov    0xc(%eax),%eax
  802494:	2b 45 08             	sub    0x8(%ebp),%eax
  802497:	89 c2                	mov    %eax,%edx
  802499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80249c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80249f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a2:	eb 05                	jmp    8024a9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8024a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8024b1:	a1 28 40 80 00       	mov    0x804028,%eax
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	0f 85 de 01 00 00    	jne    80269c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8024be:	a1 38 41 80 00       	mov    0x804138,%eax
  8024c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c6:	e9 9e 01 00 00       	jmp    802669 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d4:	0f 82 87 01 00 00    	jb     802661 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e3:	0f 85 95 00 00 00    	jne    80257e <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8024e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ed:	75 17                	jne    802506 <alloc_block_NF+0x5b>
  8024ef:	83 ec 04             	sub    $0x4,%esp
  8024f2:	68 d8 3d 80 00       	push   $0x803dd8
  8024f7:	68 e0 00 00 00       	push   $0xe0
  8024fc:	68 2f 3d 80 00       	push   $0x803d2f
  802501:	e8 be 0c 00 00       	call   8031c4 <_panic>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 00                	mov    (%eax),%eax
  80250b:	85 c0                	test   %eax,%eax
  80250d:	74 10                	je     80251f <alloc_block_NF+0x74>
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802517:	8b 52 04             	mov    0x4(%edx),%edx
  80251a:	89 50 04             	mov    %edx,0x4(%eax)
  80251d:	eb 0b                	jmp    80252a <alloc_block_NF+0x7f>
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 04             	mov    0x4(%eax),%eax
  802525:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 04             	mov    0x4(%eax),%eax
  802530:	85 c0                	test   %eax,%eax
  802532:	74 0f                	je     802543 <alloc_block_NF+0x98>
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 04             	mov    0x4(%eax),%eax
  80253a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253d:	8b 12                	mov    (%edx),%edx
  80253f:	89 10                	mov    %edx,(%eax)
  802541:	eb 0a                	jmp    80254d <alloc_block_NF+0xa2>
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	a3 38 41 80 00       	mov    %eax,0x804138
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802560:	a1 44 41 80 00       	mov    0x804144,%eax
  802565:	48                   	dec    %eax
  802566:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 08             	mov    0x8(%eax),%eax
  802571:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	e9 f8 04 00 00       	jmp    802a76 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 40 0c             	mov    0xc(%eax),%eax
  802584:	3b 45 08             	cmp    0x8(%ebp),%eax
  802587:	0f 86 d4 00 00 00    	jbe    802661 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80258d:	a1 48 41 80 00       	mov    0x804148,%eax
  802592:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 50 08             	mov    0x8(%eax),%edx
  80259b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8025a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ae:	75 17                	jne    8025c7 <alloc_block_NF+0x11c>
  8025b0:	83 ec 04             	sub    $0x4,%esp
  8025b3:	68 d8 3d 80 00       	push   $0x803dd8
  8025b8:	68 e9 00 00 00       	push   $0xe9
  8025bd:	68 2f 3d 80 00       	push   $0x803d2f
  8025c2:	e8 fd 0b 00 00       	call   8031c4 <_panic>
  8025c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ca:	8b 00                	mov    (%eax),%eax
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	74 10                	je     8025e0 <alloc_block_NF+0x135>
  8025d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d8:	8b 52 04             	mov    0x4(%edx),%edx
  8025db:	89 50 04             	mov    %edx,0x4(%eax)
  8025de:	eb 0b                	jmp    8025eb <alloc_block_NF+0x140>
  8025e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e3:	8b 40 04             	mov    0x4(%eax),%eax
  8025e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ee:	8b 40 04             	mov    0x4(%eax),%eax
  8025f1:	85 c0                	test   %eax,%eax
  8025f3:	74 0f                	je     802604 <alloc_block_NF+0x159>
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fe:	8b 12                	mov    (%edx),%edx
  802600:	89 10                	mov    %edx,(%eax)
  802602:	eb 0a                	jmp    80260e <alloc_block_NF+0x163>
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	a3 48 41 80 00       	mov    %eax,0x804148
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802621:	a1 54 41 80 00       	mov    0x804154,%eax
  802626:	48                   	dec    %eax
  802627:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80262c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262f:	8b 40 08             	mov    0x8(%eax),%eax
  802632:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 50 08             	mov    0x8(%eax),%edx
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	01 c2                	add    %eax,%edx
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 0c             	mov    0xc(%eax),%eax
  80264e:	2b 45 08             	sub    0x8(%ebp),%eax
  802651:	89 c2                	mov    %eax,%edx
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	e9 15 04 00 00       	jmp    802a76 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802661:	a1 40 41 80 00       	mov    0x804140,%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	74 07                	je     802676 <alloc_block_NF+0x1cb>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	eb 05                	jmp    80267b <alloc_block_NF+0x1d0>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	a3 40 41 80 00       	mov    %eax,0x804140
  802680:	a1 40 41 80 00       	mov    0x804140,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 85 3e fe ff ff    	jne    8024cb <alloc_block_NF+0x20>
  80268d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802691:	0f 85 34 fe ff ff    	jne    8024cb <alloc_block_NF+0x20>
  802697:	e9 d5 03 00 00       	jmp    802a71 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80269c:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a4:	e9 b1 01 00 00       	jmp    80285a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 50 08             	mov    0x8(%eax),%edx
  8026af:	a1 28 40 80 00       	mov    0x804028,%eax
  8026b4:	39 c2                	cmp    %eax,%edx
  8026b6:	0f 82 96 01 00 00    	jb     802852 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c5:	0f 82 87 01 00 00    	jb     802852 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d4:	0f 85 95 00 00 00    	jne    80276f <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8026da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026de:	75 17                	jne    8026f7 <alloc_block_NF+0x24c>
  8026e0:	83 ec 04             	sub    $0x4,%esp
  8026e3:	68 d8 3d 80 00       	push   $0x803dd8
  8026e8:	68 fc 00 00 00       	push   $0xfc
  8026ed:	68 2f 3d 80 00       	push   $0x803d2f
  8026f2:	e8 cd 0a 00 00       	call   8031c4 <_panic>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 10                	je     802710 <alloc_block_NF+0x265>
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 00                	mov    (%eax),%eax
  802705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802708:	8b 52 04             	mov    0x4(%edx),%edx
  80270b:	89 50 04             	mov    %edx,0x4(%eax)
  80270e:	eb 0b                	jmp    80271b <alloc_block_NF+0x270>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	74 0f                	je     802734 <alloc_block_NF+0x289>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 04             	mov    0x4(%eax),%eax
  80272b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272e:	8b 12                	mov    (%edx),%edx
  802730:	89 10                	mov    %edx,(%eax)
  802732:	eb 0a                	jmp    80273e <alloc_block_NF+0x293>
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 00                	mov    (%eax),%eax
  802739:	a3 38 41 80 00       	mov    %eax,0x804138
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802751:	a1 44 41 80 00       	mov    0x804144,%eax
  802756:	48                   	dec    %eax
  802757:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 40 08             	mov    0x8(%eax),%eax
  802762:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	e9 07 03 00 00       	jmp    802a76 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	8b 40 0c             	mov    0xc(%eax),%eax
  802775:	3b 45 08             	cmp    0x8(%ebp),%eax
  802778:	0f 86 d4 00 00 00    	jbe    802852 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80277e:	a1 48 41 80 00       	mov    0x804148,%eax
  802783:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 50 08             	mov    0x8(%eax),%edx
  80278c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802795:	8b 55 08             	mov    0x8(%ebp),%edx
  802798:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80279b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80279f:	75 17                	jne    8027b8 <alloc_block_NF+0x30d>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 d8 3d 80 00       	push   $0x803dd8
  8027a9:	68 04 01 00 00       	push   $0x104
  8027ae:	68 2f 3d 80 00       	push   $0x803d2f
  8027b3:	e8 0c 0a 00 00       	call   8031c4 <_panic>
  8027b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 10                	je     8027d1 <alloc_block_NF+0x326>
  8027c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027c9:	8b 52 04             	mov    0x4(%edx),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 0b                	jmp    8027dc <alloc_block_NF+0x331>
  8027d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0f                	je     8027f5 <alloc_block_NF+0x34a>
  8027e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027ef:	8b 12                	mov    (%edx),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 0a                	jmp    8027ff <alloc_block_NF+0x354>
  8027f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	a3 48 41 80 00       	mov    %eax,0x804148
  8027ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802812:	a1 54 41 80 00       	mov    0x804154,%eax
  802817:	48                   	dec    %eax
  802818:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80281d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802820:	8b 40 08             	mov    0x8(%eax),%eax
  802823:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 50 08             	mov    0x8(%eax),%edx
  80282e:	8b 45 08             	mov    0x8(%ebp),%eax
  802831:	01 c2                	add    %eax,%edx
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 40 0c             	mov    0xc(%eax),%eax
  80283f:	2b 45 08             	sub    0x8(%ebp),%eax
  802842:	89 c2                	mov    %eax,%edx
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80284a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284d:	e9 24 02 00 00       	jmp    802a76 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802852:	a1 40 41 80 00       	mov    0x804140,%eax
  802857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285e:	74 07                	je     802867 <alloc_block_NF+0x3bc>
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	eb 05                	jmp    80286c <alloc_block_NF+0x3c1>
  802867:	b8 00 00 00 00       	mov    $0x0,%eax
  80286c:	a3 40 41 80 00       	mov    %eax,0x804140
  802871:	a1 40 41 80 00       	mov    0x804140,%eax
  802876:	85 c0                	test   %eax,%eax
  802878:	0f 85 2b fe ff ff    	jne    8026a9 <alloc_block_NF+0x1fe>
  80287e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802882:	0f 85 21 fe ff ff    	jne    8026a9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802888:	a1 38 41 80 00       	mov    0x804138,%eax
  80288d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802890:	e9 ae 01 00 00       	jmp    802a43 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 50 08             	mov    0x8(%eax),%edx
  80289b:	a1 28 40 80 00       	mov    0x804028,%eax
  8028a0:	39 c2                	cmp    %eax,%edx
  8028a2:	0f 83 93 01 00 00    	jae    802a3b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b1:	0f 82 84 01 00 00    	jb     802a3b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c0:	0f 85 95 00 00 00    	jne    80295b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ca:	75 17                	jne    8028e3 <alloc_block_NF+0x438>
  8028cc:	83 ec 04             	sub    $0x4,%esp
  8028cf:	68 d8 3d 80 00       	push   $0x803dd8
  8028d4:	68 14 01 00 00       	push   $0x114
  8028d9:	68 2f 3d 80 00       	push   $0x803d2f
  8028de:	e8 e1 08 00 00       	call   8031c4 <_panic>
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 00                	mov    (%eax),%eax
  8028e8:	85 c0                	test   %eax,%eax
  8028ea:	74 10                	je     8028fc <alloc_block_NF+0x451>
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 00                	mov    (%eax),%eax
  8028f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f4:	8b 52 04             	mov    0x4(%edx),%edx
  8028f7:	89 50 04             	mov    %edx,0x4(%eax)
  8028fa:	eb 0b                	jmp    802907 <alloc_block_NF+0x45c>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 04             	mov    0x4(%eax),%eax
  802902:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	74 0f                	je     802920 <alloc_block_NF+0x475>
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291a:	8b 12                	mov    (%edx),%edx
  80291c:	89 10                	mov    %edx,(%eax)
  80291e:	eb 0a                	jmp    80292a <alloc_block_NF+0x47f>
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 00                	mov    (%eax),%eax
  802925:	a3 38 41 80 00       	mov    %eax,0x804138
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293d:	a1 44 41 80 00       	mov    0x804144,%eax
  802942:	48                   	dec    %eax
  802943:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 40 08             	mov    0x8(%eax),%eax
  80294e:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	e9 1b 01 00 00       	jmp    802a76 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	3b 45 08             	cmp    0x8(%ebp),%eax
  802964:	0f 86 d1 00 00 00    	jbe    802a3b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80296a:	a1 48 41 80 00       	mov    0x804148,%eax
  80296f:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 50 08             	mov    0x8(%eax),%edx
  802978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	8b 55 08             	mov    0x8(%ebp),%edx
  802984:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802987:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80298b:	75 17                	jne    8029a4 <alloc_block_NF+0x4f9>
  80298d:	83 ec 04             	sub    $0x4,%esp
  802990:	68 d8 3d 80 00       	push   $0x803dd8
  802995:	68 1c 01 00 00       	push   $0x11c
  80299a:	68 2f 3d 80 00       	push   $0x803d2f
  80299f:	e8 20 08 00 00       	call   8031c4 <_panic>
  8029a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a7:	8b 00                	mov    (%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	74 10                	je     8029bd <alloc_block_NF+0x512>
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b5:	8b 52 04             	mov    0x4(%edx),%edx
  8029b8:	89 50 04             	mov    %edx,0x4(%eax)
  8029bb:	eb 0b                	jmp    8029c8 <alloc_block_NF+0x51d>
  8029bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c0:	8b 40 04             	mov    0x4(%eax),%eax
  8029c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	74 0f                	je     8029e1 <alloc_block_NF+0x536>
  8029d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d5:	8b 40 04             	mov    0x4(%eax),%eax
  8029d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029db:	8b 12                	mov    (%edx),%edx
  8029dd:	89 10                	mov    %edx,(%eax)
  8029df:	eb 0a                	jmp    8029eb <alloc_block_NF+0x540>
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	a3 48 41 80 00       	mov    %eax,0x804148
  8029eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fe:	a1 54 41 80 00       	mov    0x804154,%eax
  802a03:	48                   	dec    %eax
  802a04:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0c:	8b 40 08             	mov    0x8(%eax),%eax
  802a0f:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 50 08             	mov    0x8(%eax),%edx
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	01 c2                	add    %eax,%edx
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a2e:	89 c2                	mov    %eax,%edx
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a39:	eb 3b                	jmp    802a76 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a3b:	a1 40 41 80 00       	mov    0x804140,%eax
  802a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a47:	74 07                	je     802a50 <alloc_block_NF+0x5a5>
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	eb 05                	jmp    802a55 <alloc_block_NF+0x5aa>
  802a50:	b8 00 00 00 00       	mov    $0x0,%eax
  802a55:	a3 40 41 80 00       	mov    %eax,0x804140
  802a5a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	0f 85 2e fe ff ff    	jne    802895 <alloc_block_NF+0x3ea>
  802a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6b:	0f 85 24 fe ff ff    	jne    802895 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802a71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a76:	c9                   	leave  
  802a77:	c3                   	ret    

00802a78 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a78:	55                   	push   %ebp
  802a79:	89 e5                	mov    %esp,%ebp
  802a7b:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a7e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a86:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a8b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a8e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 14                	je     802aab <insert_sorted_with_merge_freeList+0x33>
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 50 08             	mov    0x8(%eax),%edx
  802a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa0:	8b 40 08             	mov    0x8(%eax),%eax
  802aa3:	39 c2                	cmp    %eax,%edx
  802aa5:	0f 87 9b 01 00 00    	ja     802c46 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aaf:	75 17                	jne    802ac8 <insert_sorted_with_merge_freeList+0x50>
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	68 0c 3d 80 00       	push   $0x803d0c
  802ab9:	68 38 01 00 00       	push   $0x138
  802abe:	68 2f 3d 80 00       	push   $0x803d2f
  802ac3:	e8 fc 06 00 00       	call   8031c4 <_panic>
  802ac8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	89 10                	mov    %edx,(%eax)
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	85 c0                	test   %eax,%eax
  802ada:	74 0d                	je     802ae9 <insert_sorted_with_merge_freeList+0x71>
  802adc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae4:	89 50 04             	mov    %edx,0x4(%eax)
  802ae7:	eb 08                	jmp    802af1 <insert_sorted_with_merge_freeList+0x79>
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	a3 38 41 80 00       	mov    %eax,0x804138
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b03:	a1 44 41 80 00       	mov    0x804144,%eax
  802b08:	40                   	inc    %eax
  802b09:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b12:	0f 84 a8 06 00 00    	je     8031c0 <insert_sorted_with_merge_freeList+0x748>
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	8b 50 08             	mov    0x8(%eax),%edx
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	8b 40 0c             	mov    0xc(%eax),%eax
  802b24:	01 c2                	add    %eax,%edx
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 40 08             	mov    0x8(%eax),%eax
  802b2c:	39 c2                	cmp    %eax,%edx
  802b2e:	0f 85 8c 06 00 00    	jne    8031c0 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 50 0c             	mov    0xc(%eax),%edx
  802b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b40:	01 c2                	add    %eax,%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b4c:	75 17                	jne    802b65 <insert_sorted_with_merge_freeList+0xed>
  802b4e:	83 ec 04             	sub    $0x4,%esp
  802b51:	68 d8 3d 80 00       	push   $0x803dd8
  802b56:	68 3c 01 00 00       	push   $0x13c
  802b5b:	68 2f 3d 80 00       	push   $0x803d2f
  802b60:	e8 5f 06 00 00       	call   8031c4 <_panic>
  802b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	74 10                	je     802b7e <insert_sorted_with_merge_freeList+0x106>
  802b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b76:	8b 52 04             	mov    0x4(%edx),%edx
  802b79:	89 50 04             	mov    %edx,0x4(%eax)
  802b7c:	eb 0b                	jmp    802b89 <insert_sorted_with_merge_freeList+0x111>
  802b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	74 0f                	je     802ba2 <insert_sorted_with_merge_freeList+0x12a>
  802b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b96:	8b 40 04             	mov    0x4(%eax),%eax
  802b99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b9c:	8b 12                	mov    (%edx),%edx
  802b9e:	89 10                	mov    %edx,(%eax)
  802ba0:	eb 0a                	jmp    802bac <insert_sorted_with_merge_freeList+0x134>
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbf:	a1 44 41 80 00       	mov    0x804144,%eax
  802bc4:	48                   	dec    %eax
  802bc5:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802bde:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802be2:	75 17                	jne    802bfb <insert_sorted_with_merge_freeList+0x183>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 0c 3d 80 00       	push   $0x803d0c
  802bec:	68 3f 01 00 00       	push   $0x13f
  802bf1:	68 2f 3d 80 00       	push   $0x803d2f
  802bf6:	e8 c9 05 00 00       	call   8031c4 <_panic>
  802bfb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c04:	89 10                	mov    %edx,(%eax)
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 0d                	je     802c1c <insert_sorted_with_merge_freeList+0x1a4>
  802c0f:	a1 48 41 80 00       	mov    0x804148,%eax
  802c14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 08                	jmp    802c24 <insert_sorted_with_merge_freeList+0x1ac>
  802c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c27:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 54 41 80 00       	mov    0x804154,%eax
  802c3b:	40                   	inc    %eax
  802c3c:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c41:	e9 7a 05 00 00       	jmp    8031c0 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802c46:	8b 45 08             	mov    0x8(%ebp),%eax
  802c49:	8b 50 08             	mov    0x8(%eax),%edx
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	8b 40 08             	mov    0x8(%eax),%eax
  802c52:	39 c2                	cmp    %eax,%edx
  802c54:	0f 82 14 01 00 00    	jb     802d6e <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	8b 50 08             	mov    0x8(%eax),%edx
  802c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c63:	8b 40 0c             	mov    0xc(%eax),%eax
  802c66:	01 c2                	add    %eax,%edx
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 40 08             	mov    0x8(%eax),%eax
  802c6e:	39 c2                	cmp    %eax,%edx
  802c70:	0f 85 90 00 00 00    	jne    802d06 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c79:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	01 c2                	add    %eax,%edx
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca2:	75 17                	jne    802cbb <insert_sorted_with_merge_freeList+0x243>
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 0c 3d 80 00       	push   $0x803d0c
  802cac:	68 49 01 00 00       	push   $0x149
  802cb1:	68 2f 3d 80 00       	push   $0x803d2f
  802cb6:	e8 09 05 00 00       	call   8031c4 <_panic>
  802cbb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	89 10                	mov    %edx,(%eax)
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	74 0d                	je     802cdc <insert_sorted_with_merge_freeList+0x264>
  802ccf:	a1 48 41 80 00       	mov    0x804148,%eax
  802cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%eax)
  802cda:	eb 08                	jmp    802ce4 <insert_sorted_with_merge_freeList+0x26c>
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	a3 48 41 80 00       	mov    %eax,0x804148
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf6:	a1 54 41 80 00       	mov    0x804154,%eax
  802cfb:	40                   	inc    %eax
  802cfc:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d01:	e9 bb 04 00 00       	jmp    8031c1 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0a:	75 17                	jne    802d23 <insert_sorted_with_merge_freeList+0x2ab>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 80 3d 80 00       	push   $0x803d80
  802d14:	68 4c 01 00 00       	push   $0x14c
  802d19:	68 2f 3d 80 00       	push   $0x803d2f
  802d1e:	e8 a1 04 00 00       	call   8031c4 <_panic>
  802d23:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	89 50 04             	mov    %edx,0x4(%eax)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 0c                	je     802d45 <insert_sorted_with_merge_freeList+0x2cd>
  802d39:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d41:	89 10                	mov    %edx,(%eax)
  802d43:	eb 08                	jmp    802d4d <insert_sorted_with_merge_freeList+0x2d5>
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 38 41 80 00       	mov    %eax,0x804138
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d5e:	a1 44 41 80 00       	mov    0x804144,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d69:	e9 53 04 00 00       	jmp    8031c1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802d6e:	a1 38 41 80 00       	mov    0x804138,%eax
  802d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d76:	e9 15 04 00 00       	jmp    803190 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 50 08             	mov    0x8(%eax),%edx
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 40 08             	mov    0x8(%eax),%eax
  802d8f:	39 c2                	cmp    %eax,%edx
  802d91:	0f 86 f1 03 00 00    	jbe    803188 <insert_sorted_with_merge_freeList+0x710>
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 50 08             	mov    0x8(%eax),%edx
  802d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da0:	8b 40 08             	mov    0x8(%eax),%eax
  802da3:	39 c2                	cmp    %eax,%edx
  802da5:	0f 83 dd 03 00 00    	jae    803188 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	01 c2                	add    %eax,%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	39 c2                	cmp    %eax,%edx
  802dc1:	0f 85 b9 01 00 00    	jne    802f80 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd3:	01 c2                	add    %eax,%edx
  802dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd8:	8b 40 08             	mov    0x8(%eax),%eax
  802ddb:	39 c2                	cmp    %eax,%edx
  802ddd:	0f 85 0d 01 00 00    	jne    802ef0 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 50 0c             	mov    0xc(%eax),%edx
  802de9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dec:	8b 40 0c             	mov    0xc(%eax),%eax
  802def:	01 c2                	add    %eax,%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802df7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dfb:	75 17                	jne    802e14 <insert_sorted_with_merge_freeList+0x39c>
  802dfd:	83 ec 04             	sub    $0x4,%esp
  802e00:	68 d8 3d 80 00       	push   $0x803dd8
  802e05:	68 5c 01 00 00       	push   $0x15c
  802e0a:	68 2f 3d 80 00       	push   $0x803d2f
  802e0f:	e8 b0 03 00 00       	call   8031c4 <_panic>
  802e14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 10                	je     802e2d <insert_sorted_with_merge_freeList+0x3b5>
  802e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e25:	8b 52 04             	mov    0x4(%edx),%edx
  802e28:	89 50 04             	mov    %edx,0x4(%eax)
  802e2b:	eb 0b                	jmp    802e38 <insert_sorted_with_merge_freeList+0x3c0>
  802e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e30:	8b 40 04             	mov    0x4(%eax),%eax
  802e33:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 0f                	je     802e51 <insert_sorted_with_merge_freeList+0x3d9>
  802e42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4b:	8b 12                	mov    (%edx),%edx
  802e4d:	89 10                	mov    %edx,(%eax)
  802e4f:	eb 0a                	jmp    802e5b <insert_sorted_with_merge_freeList+0x3e3>
  802e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	a3 38 41 80 00       	mov    %eax,0x804138
  802e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 44 41 80 00       	mov    0x804144,%eax
  802e73:	48                   	dec    %eax
  802e74:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e86:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e8d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e91:	75 17                	jne    802eaa <insert_sorted_with_merge_freeList+0x432>
  802e93:	83 ec 04             	sub    $0x4,%esp
  802e96:	68 0c 3d 80 00       	push   $0x803d0c
  802e9b:	68 5f 01 00 00       	push   $0x15f
  802ea0:	68 2f 3d 80 00       	push   $0x803d2f
  802ea5:	e8 1a 03 00 00       	call   8031c4 <_panic>
  802eaa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb3:	89 10                	mov    %edx,(%eax)
  802eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	74 0d                	je     802ecb <insert_sorted_with_merge_freeList+0x453>
  802ebe:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec6:	89 50 04             	mov    %edx,0x4(%eax)
  802ec9:	eb 08                	jmp    802ed3 <insert_sorted_with_merge_freeList+0x45b>
  802ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ece:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed6:	a3 48 41 80 00       	mov    %eax,0x804148
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee5:	a1 54 41 80 00       	mov    0x804154,%eax
  802eea:	40                   	inc    %eax
  802eeb:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  802efc:	01 c2                	add    %eax,%edx
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1c:	75 17                	jne    802f35 <insert_sorted_with_merge_freeList+0x4bd>
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 0c 3d 80 00       	push   $0x803d0c
  802f26:	68 64 01 00 00       	push   $0x164
  802f2b:	68 2f 3d 80 00       	push   $0x803d2f
  802f30:	e8 8f 02 00 00       	call   8031c4 <_panic>
  802f35:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	89 10                	mov    %edx,(%eax)
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 0d                	je     802f56 <insert_sorted_with_merge_freeList+0x4de>
  802f49:	a1 48 41 80 00       	mov    0x804148,%eax
  802f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f51:	89 50 04             	mov    %edx,0x4(%eax)
  802f54:	eb 08                	jmp    802f5e <insert_sorted_with_merge_freeList+0x4e6>
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	a3 48 41 80 00       	mov    %eax,0x804148
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f70:	a1 54 41 80 00       	mov    0x804154,%eax
  802f75:	40                   	inc    %eax
  802f76:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f7b:	e9 41 02 00 00       	jmp    8031c1 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 50 08             	mov    0x8(%eax),%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8c:	01 c2                	add    %eax,%edx
  802f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f91:	8b 40 08             	mov    0x8(%eax),%eax
  802f94:	39 c2                	cmp    %eax,%edx
  802f96:	0f 85 7c 01 00 00    	jne    803118 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa0:	74 06                	je     802fa8 <insert_sorted_with_merge_freeList+0x530>
  802fa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa6:	75 17                	jne    802fbf <insert_sorted_with_merge_freeList+0x547>
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	68 48 3d 80 00       	push   $0x803d48
  802fb0:	68 69 01 00 00       	push   $0x169
  802fb5:	68 2f 3d 80 00       	push   $0x803d2f
  802fba:	e8 05 02 00 00       	call   8031c4 <_panic>
  802fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc2:	8b 50 04             	mov    0x4(%eax),%edx
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	89 50 04             	mov    %edx,0x4(%eax)
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd6:	8b 40 04             	mov    0x4(%eax),%eax
  802fd9:	85 c0                	test   %eax,%eax
  802fdb:	74 0d                	je     802fea <insert_sorted_with_merge_freeList+0x572>
  802fdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe0:	8b 40 04             	mov    0x4(%eax),%eax
  802fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	eb 08                	jmp    802ff2 <insert_sorted_with_merge_freeList+0x57a>
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	a3 38 41 80 00       	mov    %eax,0x804138
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff8:	89 50 04             	mov    %edx,0x4(%eax)
  802ffb:	a1 44 41 80 00       	mov    0x804144,%eax
  803000:	40                   	inc    %eax
  803001:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	8b 50 0c             	mov    0xc(%eax),%edx
  80300c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80301a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80301e:	75 17                	jne    803037 <insert_sorted_with_merge_freeList+0x5bf>
  803020:	83 ec 04             	sub    $0x4,%esp
  803023:	68 d8 3d 80 00       	push   $0x803dd8
  803028:	68 6b 01 00 00       	push   $0x16b
  80302d:	68 2f 3d 80 00       	push   $0x803d2f
  803032:	e8 8d 01 00 00       	call   8031c4 <_panic>
  803037:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 10                	je     803050 <insert_sorted_with_merge_freeList+0x5d8>
  803040:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803043:	8b 00                	mov    (%eax),%eax
  803045:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803048:	8b 52 04             	mov    0x4(%edx),%edx
  80304b:	89 50 04             	mov    %edx,0x4(%eax)
  80304e:	eb 0b                	jmp    80305b <insert_sorted_with_merge_freeList+0x5e3>
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	8b 40 04             	mov    0x4(%eax),%eax
  803056:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 40 04             	mov    0x4(%eax),%eax
  803061:	85 c0                	test   %eax,%eax
  803063:	74 0f                	je     803074 <insert_sorted_with_merge_freeList+0x5fc>
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 40 04             	mov    0x4(%eax),%eax
  80306b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306e:	8b 12                	mov    (%edx),%edx
  803070:	89 10                	mov    %edx,(%eax)
  803072:	eb 0a                	jmp    80307e <insert_sorted_with_merge_freeList+0x606>
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	a3 38 41 80 00       	mov    %eax,0x804138
  80307e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803091:	a1 44 41 80 00       	mov    0x804144,%eax
  803096:	48                   	dec    %eax
  803097:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80309c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8030a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b4:	75 17                	jne    8030cd <insert_sorted_with_merge_freeList+0x655>
  8030b6:	83 ec 04             	sub    $0x4,%esp
  8030b9:	68 0c 3d 80 00       	push   $0x803d0c
  8030be:	68 6e 01 00 00       	push   $0x16e
  8030c3:	68 2f 3d 80 00       	push   $0x803d2f
  8030c8:	e8 f7 00 00 00       	call   8031c4 <_panic>
  8030cd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d6:	89 10                	mov    %edx,(%eax)
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	85 c0                	test   %eax,%eax
  8030df:	74 0d                	je     8030ee <insert_sorted_with_merge_freeList+0x676>
  8030e1:	a1 48 41 80 00       	mov    0x804148,%eax
  8030e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ec:	eb 08                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x67e>
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f9:	a3 48 41 80 00       	mov    %eax,0x804148
  8030fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803101:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803108:	a1 54 41 80 00       	mov    0x804154,%eax
  80310d:	40                   	inc    %eax
  80310e:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803113:	e9 a9 00 00 00       	jmp    8031c1 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803118:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311c:	74 06                	je     803124 <insert_sorted_with_merge_freeList+0x6ac>
  80311e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803122:	75 17                	jne    80313b <insert_sorted_with_merge_freeList+0x6c3>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 a4 3d 80 00       	push   $0x803da4
  80312c:	68 73 01 00 00       	push   $0x173
  803131:	68 2f 3d 80 00       	push   $0x803d2f
  803136:	e8 89 00 00 00       	call   8031c4 <_panic>
  80313b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313e:	8b 10                	mov    (%eax),%edx
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	89 10                	mov    %edx,(%eax)
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	85 c0                	test   %eax,%eax
  80314c:	74 0b                	je     803159 <insert_sorted_with_merge_freeList+0x6e1>
  80314e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803151:	8b 00                	mov    (%eax),%eax
  803153:	8b 55 08             	mov    0x8(%ebp),%edx
  803156:	89 50 04             	mov    %edx,0x4(%eax)
  803159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315c:	8b 55 08             	mov    0x8(%ebp),%edx
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	8b 45 08             	mov    0x8(%ebp),%eax
  803164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803167:	89 50 04             	mov    %edx,0x4(%eax)
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	75 08                	jne    80317b <insert_sorted_with_merge_freeList+0x703>
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80317b:	a1 44 41 80 00       	mov    0x804144,%eax
  803180:	40                   	inc    %eax
  803181:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803186:	eb 39                	jmp    8031c1 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803188:	a1 40 41 80 00       	mov    0x804140,%eax
  80318d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803190:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803194:	74 07                	je     80319d <insert_sorted_with_merge_freeList+0x725>
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	8b 00                	mov    (%eax),%eax
  80319b:	eb 05                	jmp    8031a2 <insert_sorted_with_merge_freeList+0x72a>
  80319d:	b8 00 00 00 00       	mov    $0x0,%eax
  8031a2:	a3 40 41 80 00       	mov    %eax,0x804140
  8031a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8031ac:	85 c0                	test   %eax,%eax
  8031ae:	0f 85 c7 fb ff ff    	jne    802d7b <insert_sorted_with_merge_freeList+0x303>
  8031b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b8:	0f 85 bd fb ff ff    	jne    802d7b <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031be:	eb 01                	jmp    8031c1 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031c0:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031c1:	90                   	nop
  8031c2:	c9                   	leave  
  8031c3:	c3                   	ret    

008031c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8031c4:	55                   	push   %ebp
  8031c5:	89 e5                	mov    %esp,%ebp
  8031c7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8031ca:	8d 45 10             	lea    0x10(%ebp),%eax
  8031cd:	83 c0 04             	add    $0x4,%eax
  8031d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8031d3:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	74 16                	je     8031f2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8031dc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031e1:	83 ec 08             	sub    $0x8,%esp
  8031e4:	50                   	push   %eax
  8031e5:	68 f8 3d 80 00       	push   $0x803df8
  8031ea:	e8 6b d2 ff ff       	call   80045a <cprintf>
  8031ef:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031f2:	a1 00 40 80 00       	mov    0x804000,%eax
  8031f7:	ff 75 0c             	pushl  0xc(%ebp)
  8031fa:	ff 75 08             	pushl  0x8(%ebp)
  8031fd:	50                   	push   %eax
  8031fe:	68 fd 3d 80 00       	push   $0x803dfd
  803203:	e8 52 d2 ff ff       	call   80045a <cprintf>
  803208:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80320b:	8b 45 10             	mov    0x10(%ebp),%eax
  80320e:	83 ec 08             	sub    $0x8,%esp
  803211:	ff 75 f4             	pushl  -0xc(%ebp)
  803214:	50                   	push   %eax
  803215:	e8 d5 d1 ff ff       	call   8003ef <vcprintf>
  80321a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80321d:	83 ec 08             	sub    $0x8,%esp
  803220:	6a 00                	push   $0x0
  803222:	68 19 3e 80 00       	push   $0x803e19
  803227:	e8 c3 d1 ff ff       	call   8003ef <vcprintf>
  80322c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80322f:	e8 44 d1 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  803234:	eb fe                	jmp    803234 <_panic+0x70>

00803236 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803236:	55                   	push   %ebp
  803237:	89 e5                	mov    %esp,%ebp
  803239:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80323c:	a1 20 40 80 00       	mov    0x804020,%eax
  803241:	8b 50 74             	mov    0x74(%eax),%edx
  803244:	8b 45 0c             	mov    0xc(%ebp),%eax
  803247:	39 c2                	cmp    %eax,%edx
  803249:	74 14                	je     80325f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	68 1c 3e 80 00       	push   $0x803e1c
  803253:	6a 26                	push   $0x26
  803255:	68 68 3e 80 00       	push   $0x803e68
  80325a:	e8 65 ff ff ff       	call   8031c4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80325f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803266:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80326d:	e9 c2 00 00 00       	jmp    803334 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803275:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	01 d0                	add    %edx,%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	75 08                	jne    80328f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803287:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80328a:	e9 a2 00 00 00       	jmp    803331 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80328f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803296:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80329d:	eb 69                	jmp    803308 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80329f:	a1 20 40 80 00       	mov    0x804020,%eax
  8032a4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ad:	89 d0                	mov    %edx,%eax
  8032af:	01 c0                	add    %eax,%eax
  8032b1:	01 d0                	add    %edx,%eax
  8032b3:	c1 e0 03             	shl    $0x3,%eax
  8032b6:	01 c8                	add    %ecx,%eax
  8032b8:	8a 40 04             	mov    0x4(%eax),%al
  8032bb:	84 c0                	test   %al,%al
  8032bd:	75 46                	jne    803305 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8032c4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cd:	89 d0                	mov    %edx,%eax
  8032cf:	01 c0                	add    %eax,%eax
  8032d1:	01 d0                	add    %edx,%eax
  8032d3:	c1 e0 03             	shl    $0x3,%eax
  8032d6:	01 c8                	add    %ecx,%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032e5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ea:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	01 c8                	add    %ecx,%eax
  8032f6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032f8:	39 c2                	cmp    %eax,%edx
  8032fa:	75 09                	jne    803305 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032fc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803303:	eb 12                	jmp    803317 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803305:	ff 45 e8             	incl   -0x18(%ebp)
  803308:	a1 20 40 80 00       	mov    0x804020,%eax
  80330d:	8b 50 74             	mov    0x74(%eax),%edx
  803310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803313:	39 c2                	cmp    %eax,%edx
  803315:	77 88                	ja     80329f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803317:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80331b:	75 14                	jne    803331 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80331d:	83 ec 04             	sub    $0x4,%esp
  803320:	68 74 3e 80 00       	push   $0x803e74
  803325:	6a 3a                	push   $0x3a
  803327:	68 68 3e 80 00       	push   $0x803e68
  80332c:	e8 93 fe ff ff       	call   8031c4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803331:	ff 45 f0             	incl   -0x10(%ebp)
  803334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803337:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80333a:	0f 8c 32 ff ff ff    	jl     803272 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803340:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803347:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80334e:	eb 26                	jmp    803376 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803350:	a1 20 40 80 00       	mov    0x804020,%eax
  803355:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80335b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80335e:	89 d0                	mov    %edx,%eax
  803360:	01 c0                	add    %eax,%eax
  803362:	01 d0                	add    %edx,%eax
  803364:	c1 e0 03             	shl    $0x3,%eax
  803367:	01 c8                	add    %ecx,%eax
  803369:	8a 40 04             	mov    0x4(%eax),%al
  80336c:	3c 01                	cmp    $0x1,%al
  80336e:	75 03                	jne    803373 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803370:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803373:	ff 45 e0             	incl   -0x20(%ebp)
  803376:	a1 20 40 80 00       	mov    0x804020,%eax
  80337b:	8b 50 74             	mov    0x74(%eax),%edx
  80337e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803381:	39 c2                	cmp    %eax,%edx
  803383:	77 cb                	ja     803350 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80338b:	74 14                	je     8033a1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80338d:	83 ec 04             	sub    $0x4,%esp
  803390:	68 c8 3e 80 00       	push   $0x803ec8
  803395:	6a 44                	push   $0x44
  803397:	68 68 3e 80 00       	push   $0x803e68
  80339c:	e8 23 fe ff ff       	call   8031c4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8033a1:	90                   	nop
  8033a2:	c9                   	leave  
  8033a3:	c3                   	ret    

008033a4 <__udivdi3>:
  8033a4:	55                   	push   %ebp
  8033a5:	57                   	push   %edi
  8033a6:	56                   	push   %esi
  8033a7:	53                   	push   %ebx
  8033a8:	83 ec 1c             	sub    $0x1c,%esp
  8033ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033bb:	89 ca                	mov    %ecx,%edx
  8033bd:	89 f8                	mov    %edi,%eax
  8033bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033c3:	85 f6                	test   %esi,%esi
  8033c5:	75 2d                	jne    8033f4 <__udivdi3+0x50>
  8033c7:	39 cf                	cmp    %ecx,%edi
  8033c9:	77 65                	ja     803430 <__udivdi3+0x8c>
  8033cb:	89 fd                	mov    %edi,%ebp
  8033cd:	85 ff                	test   %edi,%edi
  8033cf:	75 0b                	jne    8033dc <__udivdi3+0x38>
  8033d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d6:	31 d2                	xor    %edx,%edx
  8033d8:	f7 f7                	div    %edi
  8033da:	89 c5                	mov    %eax,%ebp
  8033dc:	31 d2                	xor    %edx,%edx
  8033de:	89 c8                	mov    %ecx,%eax
  8033e0:	f7 f5                	div    %ebp
  8033e2:	89 c1                	mov    %eax,%ecx
  8033e4:	89 d8                	mov    %ebx,%eax
  8033e6:	f7 f5                	div    %ebp
  8033e8:	89 cf                	mov    %ecx,%edi
  8033ea:	89 fa                	mov    %edi,%edx
  8033ec:	83 c4 1c             	add    $0x1c,%esp
  8033ef:	5b                   	pop    %ebx
  8033f0:	5e                   	pop    %esi
  8033f1:	5f                   	pop    %edi
  8033f2:	5d                   	pop    %ebp
  8033f3:	c3                   	ret    
  8033f4:	39 ce                	cmp    %ecx,%esi
  8033f6:	77 28                	ja     803420 <__udivdi3+0x7c>
  8033f8:	0f bd fe             	bsr    %esi,%edi
  8033fb:	83 f7 1f             	xor    $0x1f,%edi
  8033fe:	75 40                	jne    803440 <__udivdi3+0x9c>
  803400:	39 ce                	cmp    %ecx,%esi
  803402:	72 0a                	jb     80340e <__udivdi3+0x6a>
  803404:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803408:	0f 87 9e 00 00 00    	ja     8034ac <__udivdi3+0x108>
  80340e:	b8 01 00 00 00       	mov    $0x1,%eax
  803413:	89 fa                	mov    %edi,%edx
  803415:	83 c4 1c             	add    $0x1c,%esp
  803418:	5b                   	pop    %ebx
  803419:	5e                   	pop    %esi
  80341a:	5f                   	pop    %edi
  80341b:	5d                   	pop    %ebp
  80341c:	c3                   	ret    
  80341d:	8d 76 00             	lea    0x0(%esi),%esi
  803420:	31 ff                	xor    %edi,%edi
  803422:	31 c0                	xor    %eax,%eax
  803424:	89 fa                	mov    %edi,%edx
  803426:	83 c4 1c             	add    $0x1c,%esp
  803429:	5b                   	pop    %ebx
  80342a:	5e                   	pop    %esi
  80342b:	5f                   	pop    %edi
  80342c:	5d                   	pop    %ebp
  80342d:	c3                   	ret    
  80342e:	66 90                	xchg   %ax,%ax
  803430:	89 d8                	mov    %ebx,%eax
  803432:	f7 f7                	div    %edi
  803434:	31 ff                	xor    %edi,%edi
  803436:	89 fa                	mov    %edi,%edx
  803438:	83 c4 1c             	add    $0x1c,%esp
  80343b:	5b                   	pop    %ebx
  80343c:	5e                   	pop    %esi
  80343d:	5f                   	pop    %edi
  80343e:	5d                   	pop    %ebp
  80343f:	c3                   	ret    
  803440:	bd 20 00 00 00       	mov    $0x20,%ebp
  803445:	89 eb                	mov    %ebp,%ebx
  803447:	29 fb                	sub    %edi,%ebx
  803449:	89 f9                	mov    %edi,%ecx
  80344b:	d3 e6                	shl    %cl,%esi
  80344d:	89 c5                	mov    %eax,%ebp
  80344f:	88 d9                	mov    %bl,%cl
  803451:	d3 ed                	shr    %cl,%ebp
  803453:	89 e9                	mov    %ebp,%ecx
  803455:	09 f1                	or     %esi,%ecx
  803457:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80345b:	89 f9                	mov    %edi,%ecx
  80345d:	d3 e0                	shl    %cl,%eax
  80345f:	89 c5                	mov    %eax,%ebp
  803461:	89 d6                	mov    %edx,%esi
  803463:	88 d9                	mov    %bl,%cl
  803465:	d3 ee                	shr    %cl,%esi
  803467:	89 f9                	mov    %edi,%ecx
  803469:	d3 e2                	shl    %cl,%edx
  80346b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80346f:	88 d9                	mov    %bl,%cl
  803471:	d3 e8                	shr    %cl,%eax
  803473:	09 c2                	or     %eax,%edx
  803475:	89 d0                	mov    %edx,%eax
  803477:	89 f2                	mov    %esi,%edx
  803479:	f7 74 24 0c          	divl   0xc(%esp)
  80347d:	89 d6                	mov    %edx,%esi
  80347f:	89 c3                	mov    %eax,%ebx
  803481:	f7 e5                	mul    %ebp
  803483:	39 d6                	cmp    %edx,%esi
  803485:	72 19                	jb     8034a0 <__udivdi3+0xfc>
  803487:	74 0b                	je     803494 <__udivdi3+0xf0>
  803489:	89 d8                	mov    %ebx,%eax
  80348b:	31 ff                	xor    %edi,%edi
  80348d:	e9 58 ff ff ff       	jmp    8033ea <__udivdi3+0x46>
  803492:	66 90                	xchg   %ax,%ax
  803494:	8b 54 24 08          	mov    0x8(%esp),%edx
  803498:	89 f9                	mov    %edi,%ecx
  80349a:	d3 e2                	shl    %cl,%edx
  80349c:	39 c2                	cmp    %eax,%edx
  80349e:	73 e9                	jae    803489 <__udivdi3+0xe5>
  8034a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034a3:	31 ff                	xor    %edi,%edi
  8034a5:	e9 40 ff ff ff       	jmp    8033ea <__udivdi3+0x46>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	31 c0                	xor    %eax,%eax
  8034ae:	e9 37 ff ff ff       	jmp    8033ea <__udivdi3+0x46>
  8034b3:	90                   	nop

008034b4 <__umoddi3>:
  8034b4:	55                   	push   %ebp
  8034b5:	57                   	push   %edi
  8034b6:	56                   	push   %esi
  8034b7:	53                   	push   %ebx
  8034b8:	83 ec 1c             	sub    $0x1c,%esp
  8034bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034d3:	89 f3                	mov    %esi,%ebx
  8034d5:	89 fa                	mov    %edi,%edx
  8034d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034db:	89 34 24             	mov    %esi,(%esp)
  8034de:	85 c0                	test   %eax,%eax
  8034e0:	75 1a                	jne    8034fc <__umoddi3+0x48>
  8034e2:	39 f7                	cmp    %esi,%edi
  8034e4:	0f 86 a2 00 00 00    	jbe    80358c <__umoddi3+0xd8>
  8034ea:	89 c8                	mov    %ecx,%eax
  8034ec:	89 f2                	mov    %esi,%edx
  8034ee:	f7 f7                	div    %edi
  8034f0:	89 d0                	mov    %edx,%eax
  8034f2:	31 d2                	xor    %edx,%edx
  8034f4:	83 c4 1c             	add    $0x1c,%esp
  8034f7:	5b                   	pop    %ebx
  8034f8:	5e                   	pop    %esi
  8034f9:	5f                   	pop    %edi
  8034fa:	5d                   	pop    %ebp
  8034fb:	c3                   	ret    
  8034fc:	39 f0                	cmp    %esi,%eax
  8034fe:	0f 87 ac 00 00 00    	ja     8035b0 <__umoddi3+0xfc>
  803504:	0f bd e8             	bsr    %eax,%ebp
  803507:	83 f5 1f             	xor    $0x1f,%ebp
  80350a:	0f 84 ac 00 00 00    	je     8035bc <__umoddi3+0x108>
  803510:	bf 20 00 00 00       	mov    $0x20,%edi
  803515:	29 ef                	sub    %ebp,%edi
  803517:	89 fe                	mov    %edi,%esi
  803519:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80351d:	89 e9                	mov    %ebp,%ecx
  80351f:	d3 e0                	shl    %cl,%eax
  803521:	89 d7                	mov    %edx,%edi
  803523:	89 f1                	mov    %esi,%ecx
  803525:	d3 ef                	shr    %cl,%edi
  803527:	09 c7                	or     %eax,%edi
  803529:	89 e9                	mov    %ebp,%ecx
  80352b:	d3 e2                	shl    %cl,%edx
  80352d:	89 14 24             	mov    %edx,(%esp)
  803530:	89 d8                	mov    %ebx,%eax
  803532:	d3 e0                	shl    %cl,%eax
  803534:	89 c2                	mov    %eax,%edx
  803536:	8b 44 24 08          	mov    0x8(%esp),%eax
  80353a:	d3 e0                	shl    %cl,%eax
  80353c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803540:	8b 44 24 08          	mov    0x8(%esp),%eax
  803544:	89 f1                	mov    %esi,%ecx
  803546:	d3 e8                	shr    %cl,%eax
  803548:	09 d0                	or     %edx,%eax
  80354a:	d3 eb                	shr    %cl,%ebx
  80354c:	89 da                	mov    %ebx,%edx
  80354e:	f7 f7                	div    %edi
  803550:	89 d3                	mov    %edx,%ebx
  803552:	f7 24 24             	mull   (%esp)
  803555:	89 c6                	mov    %eax,%esi
  803557:	89 d1                	mov    %edx,%ecx
  803559:	39 d3                	cmp    %edx,%ebx
  80355b:	0f 82 87 00 00 00    	jb     8035e8 <__umoddi3+0x134>
  803561:	0f 84 91 00 00 00    	je     8035f8 <__umoddi3+0x144>
  803567:	8b 54 24 04          	mov    0x4(%esp),%edx
  80356b:	29 f2                	sub    %esi,%edx
  80356d:	19 cb                	sbb    %ecx,%ebx
  80356f:	89 d8                	mov    %ebx,%eax
  803571:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803575:	d3 e0                	shl    %cl,%eax
  803577:	89 e9                	mov    %ebp,%ecx
  803579:	d3 ea                	shr    %cl,%edx
  80357b:	09 d0                	or     %edx,%eax
  80357d:	89 e9                	mov    %ebp,%ecx
  80357f:	d3 eb                	shr    %cl,%ebx
  803581:	89 da                	mov    %ebx,%edx
  803583:	83 c4 1c             	add    $0x1c,%esp
  803586:	5b                   	pop    %ebx
  803587:	5e                   	pop    %esi
  803588:	5f                   	pop    %edi
  803589:	5d                   	pop    %ebp
  80358a:	c3                   	ret    
  80358b:	90                   	nop
  80358c:	89 fd                	mov    %edi,%ebp
  80358e:	85 ff                	test   %edi,%edi
  803590:	75 0b                	jne    80359d <__umoddi3+0xe9>
  803592:	b8 01 00 00 00       	mov    $0x1,%eax
  803597:	31 d2                	xor    %edx,%edx
  803599:	f7 f7                	div    %edi
  80359b:	89 c5                	mov    %eax,%ebp
  80359d:	89 f0                	mov    %esi,%eax
  80359f:	31 d2                	xor    %edx,%edx
  8035a1:	f7 f5                	div    %ebp
  8035a3:	89 c8                	mov    %ecx,%eax
  8035a5:	f7 f5                	div    %ebp
  8035a7:	89 d0                	mov    %edx,%eax
  8035a9:	e9 44 ff ff ff       	jmp    8034f2 <__umoddi3+0x3e>
  8035ae:	66 90                	xchg   %ax,%ax
  8035b0:	89 c8                	mov    %ecx,%eax
  8035b2:	89 f2                	mov    %esi,%edx
  8035b4:	83 c4 1c             	add    $0x1c,%esp
  8035b7:	5b                   	pop    %ebx
  8035b8:	5e                   	pop    %esi
  8035b9:	5f                   	pop    %edi
  8035ba:	5d                   	pop    %ebp
  8035bb:	c3                   	ret    
  8035bc:	3b 04 24             	cmp    (%esp),%eax
  8035bf:	72 06                	jb     8035c7 <__umoddi3+0x113>
  8035c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035c5:	77 0f                	ja     8035d6 <__umoddi3+0x122>
  8035c7:	89 f2                	mov    %esi,%edx
  8035c9:	29 f9                	sub    %edi,%ecx
  8035cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035cf:	89 14 24             	mov    %edx,(%esp)
  8035d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035da:	8b 14 24             	mov    (%esp),%edx
  8035dd:	83 c4 1c             	add    $0x1c,%esp
  8035e0:	5b                   	pop    %ebx
  8035e1:	5e                   	pop    %esi
  8035e2:	5f                   	pop    %edi
  8035e3:	5d                   	pop    %ebp
  8035e4:	c3                   	ret    
  8035e5:	8d 76 00             	lea    0x0(%esi),%esi
  8035e8:	2b 04 24             	sub    (%esp),%eax
  8035eb:	19 fa                	sbb    %edi,%edx
  8035ed:	89 d1                	mov    %edx,%ecx
  8035ef:	89 c6                	mov    %eax,%esi
  8035f1:	e9 71 ff ff ff       	jmp    803567 <__umoddi3+0xb3>
  8035f6:	66 90                	xchg   %ax,%ax
  8035f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035fc:	72 ea                	jb     8035e8 <__umoddi3+0x134>
  8035fe:	89 d9                	mov    %ebx,%ecx
  803600:	e9 62 ff ff ff       	jmp    803567 <__umoddi3+0xb3>
