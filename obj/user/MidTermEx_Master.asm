
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
  800045:	68 a0 36 80 00       	push   $0x8036a0
  80004a:	e8 db 13 00 00       	call   80142a <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 a4 36 80 00       	push   $0x8036a4
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
  80009a:	68 c9 36 80 00       	push   $0x8036c9
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
  8000d7:	68 d0 36 80 00       	push   $0x8036d0
  8000dc:	e8 0f 17 00 00       	call   8017f0 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 d2 36 80 00       	push   $0x8036d2
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
  800127:	68 e0 36 80 00       	push   $0x8036e0
  80012c:	e8 d0 17 00 00       	call   801901 <sys_create_env>
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
  80015a:	68 ea 36 80 00       	push   $0x8036ea
  80015f:	e8 9d 17 00 00       	call   801901 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 aa 17 00 00       	call   80191f <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 9c 17 00 00       	call   80191f <sys_run_env>
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
  80019a:	68 f4 36 80 00       	push   $0x8036f4
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
  8001be:	e8 ed 15 00 00       	call   8017b0 <sys_cputc>
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
  8001cf:	e8 a8 15 00 00       	call   80177c <sys_disable_interrupt>
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
  8001e2:	e8 c9 15 00 00       	call   8017b0 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 a7 15 00 00       	call   801796 <sys_enable_interrupt>
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
  800201:	e8 f1 13 00 00       	call   8015f7 <sys_cgetc>
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
  80021a:	e8 5d 15 00 00       	call   80177c <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 ca 13 00 00       	call   8015f7 <sys_cgetc>
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
  800236:	e8 5b 15 00 00       	call   801796 <sys_enable_interrupt>
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
  800250:	e8 1a 17 00 00       	call   80196f <sys_getenvindex>
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
  8002bb:	e8 bc 14 00 00       	call   80177c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 24 37 80 00       	push   $0x803724
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
  8002eb:	68 4c 37 80 00       	push   $0x80374c
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
  80031c:	68 74 37 80 00       	push   $0x803774
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 cc 37 80 00       	push   $0x8037cc
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 24 37 80 00       	push   $0x803724
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 3c 14 00 00       	call   801796 <sys_enable_interrupt>

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
  80036d:	e8 c9 15 00 00       	call   80193b <sys_destroy_env>
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
  80037e:	e8 1e 16 00 00       	call   8019a1 <sys_exit_env>
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
  8003cc:	e8 fd 11 00 00       	call   8015ce <sys_cputs>
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
  800443:	e8 86 11 00 00       	call   8015ce <sys_cputs>
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
  80048d:	e8 ea 12 00 00       	call   80177c <sys_disable_interrupt>
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
  8004ad:	e8 e4 12 00 00       	call   801796 <sys_enable_interrupt>
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
  8004f7:	e8 38 2f 00 00       	call   803434 <__udivdi3>
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
  800547:	e8 f8 2f 00 00       	call   803544 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 f4 39 80 00       	add    $0x8039f4,%eax
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
  8006a2:	8b 04 85 18 3a 80 00 	mov    0x803a18(,%eax,4),%eax
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
  800783:	8b 34 9d 60 38 80 00 	mov    0x803860(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 05 3a 80 00       	push   $0x803a05
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
  8007a8:	68 0e 3a 80 00       	push   $0x803a0e
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
  8007d5:	be 11 3a 80 00       	mov    $0x803a11,%esi
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
  8011fb:	68 70 3b 80 00       	push   $0x803b70
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
  8012cb:	e8 42 04 00 00       	call   801712 <sys_allocate_chunk>
  8012d0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012d3:	a1 20 41 80 00       	mov    0x804120,%eax
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	50                   	push   %eax
  8012dc:	e8 b7 0a 00 00       	call   801d98 <initialize_MemBlocksList>
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
  801309:	68 95 3b 80 00       	push   $0x803b95
  80130e:	6a 33                	push   $0x33
  801310:	68 b3 3b 80 00       	push   $0x803bb3
  801315:	e8 37 1f 00 00       	call   803251 <_panic>
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
  801388:	68 c0 3b 80 00       	push   $0x803bc0
  80138d:	6a 34                	push   $0x34
  80138f:	68 b3 3b 80 00       	push   $0x803bb3
  801394:	e8 b8 1e 00 00       	call   803251 <_panic>
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
  8013fd:	68 e4 3b 80 00       	push   $0x803be4
  801402:	6a 46                	push   $0x46
  801404:	68 b3 3b 80 00       	push   $0x803bb3
  801409:	e8 43 1e 00 00       	call   803251 <_panic>
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
  801419:	68 0c 3c 80 00       	push   $0x803c0c
  80141e:	6a 61                	push   $0x61
  801420:	68 b3 3b 80 00       	push   $0x803bb3
  801425:	e8 27 1e 00 00       	call   803251 <_panic>

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
  80143f:	75 0a                	jne    80144b <smalloc+0x21>
  801441:	b8 00 00 00 00       	mov    $0x0,%eax
  801446:	e9 9e 00 00 00       	jmp    8014e9 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80144b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801452:	8b 55 0c             	mov    0xc(%ebp),%edx
  801455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801458:	01 d0                	add    %edx,%eax
  80145a:	48                   	dec    %eax
  80145b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80145e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801461:	ba 00 00 00 00       	mov    $0x0,%edx
  801466:	f7 75 f0             	divl   -0x10(%ebp)
  801469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80146c:	29 d0                	sub    %edx,%eax
  80146e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801471:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801478:	e8 63 06 00 00       	call   801ae0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80147d:	85 c0                	test   %eax,%eax
  80147f:	74 11                	je     801492 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801481:	83 ec 0c             	sub    $0xc,%esp
  801484:	ff 75 e8             	pushl  -0x18(%ebp)
  801487:	e8 ce 0c 00 00       	call   80215a <alloc_block_FF>
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801496:	74 4c                	je     8014e4 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149b:	8b 40 08             	mov    0x8(%eax),%eax
  80149e:	89 c2                	mov    %eax,%edx
  8014a0:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014a4:	52                   	push   %edx
  8014a5:	50                   	push   %eax
  8014a6:	ff 75 0c             	pushl  0xc(%ebp)
  8014a9:	ff 75 08             	pushl  0x8(%ebp)
  8014ac:	e8 b4 03 00 00       	call   801865 <sys_createSharedObject>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8014bd:	68 2f 3c 80 00       	push   $0x803c2f
  8014c2:	e8 93 ef ff ff       	call   80045a <cprintf>
  8014c7:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8014ca:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8014ce:	74 14                	je     8014e4 <smalloc+0xba>
  8014d0:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8014d4:	74 0e                	je     8014e4 <smalloc+0xba>
  8014d6:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8014da:	74 08                	je     8014e4 <smalloc+0xba>
			return (void*) mem_block->sva;
  8014dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014df:	8b 40 08             	mov    0x8(%eax),%eax
  8014e2:	eb 05                	jmp    8014e9 <smalloc+0xbf>
	}
	return NULL;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014f1:	e8 ee fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8014f6:	83 ec 04             	sub    $0x4,%esp
  8014f9:	68 44 3c 80 00       	push   $0x803c44
  8014fe:	68 ab 00 00 00       	push   $0xab
  801503:	68 b3 3b 80 00       	push   $0x803bb3
  801508:	e8 44 1d 00 00       	call   803251 <_panic>

0080150d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
  801510:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801513:	e8 cc fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	68 68 3c 80 00       	push   $0x803c68
  801520:	68 ef 00 00 00       	push   $0xef
  801525:	68 b3 3b 80 00       	push   $0x803bb3
  80152a:	e8 22 1d 00 00       	call   803251 <_panic>

0080152f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	68 90 3c 80 00       	push   $0x803c90
  80153d:	68 03 01 00 00       	push   $0x103
  801542:	68 b3 3b 80 00       	push   $0x803bb3
  801547:	e8 05 1d 00 00       	call   803251 <_panic>

0080154c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801552:	83 ec 04             	sub    $0x4,%esp
  801555:	68 b4 3c 80 00       	push   $0x803cb4
  80155a:	68 0e 01 00 00       	push   $0x10e
  80155f:	68 b3 3b 80 00       	push   $0x803bb3
  801564:	e8 e8 1c 00 00       	call   803251 <_panic>

00801569 <shrink>:

}
void shrink(uint32 newSize)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	68 b4 3c 80 00       	push   $0x803cb4
  801577:	68 13 01 00 00       	push   $0x113
  80157c:	68 b3 3b 80 00       	push   $0x803bb3
  801581:	e8 cb 1c 00 00       	call   803251 <_panic>

00801586 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80158c:	83 ec 04             	sub    $0x4,%esp
  80158f:	68 b4 3c 80 00       	push   $0x803cb4
  801594:	68 18 01 00 00       	push   $0x118
  801599:	68 b3 3b 80 00       	push   $0x803bb3
  80159e:	e8 ae 1c 00 00       	call   803251 <_panic>

008015a3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	57                   	push   %edi
  8015a7:	56                   	push   %esi
  8015a8:	53                   	push   %ebx
  8015a9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015bb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015be:	cd 30                	int    $0x30
  8015c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5f                   	pop    %edi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	83 ec 04             	sub    $0x4,%esp
  8015d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015de:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	52                   	push   %edx
  8015e6:	ff 75 0c             	pushl  0xc(%ebp)
  8015e9:	50                   	push   %eax
  8015ea:	6a 00                	push   $0x0
  8015ec:	e8 b2 ff ff ff       	call   8015a3 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	90                   	nop
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 01                	push   $0x1
  801606:	e8 98 ff ff ff       	call   8015a3 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801613:	8b 55 0c             	mov    0xc(%ebp),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	6a 05                	push   $0x5
  801623:	e8 7b ff ff ff       	call   8015a3 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801632:	8b 75 18             	mov    0x18(%ebp),%esi
  801635:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801638:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80163b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	56                   	push   %esi
  801642:	53                   	push   %ebx
  801643:	51                   	push   %ecx
  801644:	52                   	push   %edx
  801645:	50                   	push   %eax
  801646:	6a 06                	push   $0x6
  801648:	e8 56 ff ff ff       	call   8015a3 <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
}
  801650:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801653:	5b                   	pop    %ebx
  801654:	5e                   	pop    %esi
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    

00801657 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80165a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	52                   	push   %edx
  801667:	50                   	push   %eax
  801668:	6a 07                	push   $0x7
  80166a:	e8 34 ff ff ff       	call   8015a3 <syscall>
  80166f:	83 c4 18             	add    $0x18,%esp
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	ff 75 0c             	pushl  0xc(%ebp)
  801680:	ff 75 08             	pushl  0x8(%ebp)
  801683:	6a 08                	push   $0x8
  801685:	e8 19 ff ff ff       	call   8015a3 <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
}
  80168d:	c9                   	leave  
  80168e:	c3                   	ret    

0080168f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 09                	push   $0x9
  80169e:	e8 00 ff ff ff       	call   8015a3 <syscall>
  8016a3:	83 c4 18             	add    $0x18,%esp
}
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 0a                	push   $0xa
  8016b7:	e8 e7 fe ff ff       	call   8015a3 <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	c9                   	leave  
  8016c0:	c3                   	ret    

008016c1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 0b                	push   $0xb
  8016d0:	e8 ce fe ff ff       	call   8015a3 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	ff 75 0c             	pushl  0xc(%ebp)
  8016e6:	ff 75 08             	pushl  0x8(%ebp)
  8016e9:	6a 0f                	push   $0xf
  8016eb:	e8 b3 fe ff ff       	call   8015a3 <syscall>
  8016f0:	83 c4 18             	add    $0x18,%esp
	return;
  8016f3:	90                   	nop
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	ff 75 0c             	pushl  0xc(%ebp)
  801702:	ff 75 08             	pushl  0x8(%ebp)
  801705:	6a 10                	push   $0x10
  801707:	e8 97 fe ff ff       	call   8015a3 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
	return ;
  80170f:	90                   	nop
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	ff 75 10             	pushl  0x10(%ebp)
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	6a 11                	push   $0x11
  801724:	e8 7a fe ff ff       	call   8015a3 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
	return ;
  80172c:	90                   	nop
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 0c                	push   $0xc
  80173e:	e8 60 fe ff ff       	call   8015a3 <syscall>
  801743:	83 c4 18             	add    $0x18,%esp
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	6a 0d                	push   $0xd
  801758:	e8 46 fe ff ff       	call   8015a3 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 0e                	push   $0xe
  801771:	e8 2d fe ff ff       	call   8015a3 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	90                   	nop
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 13                	push   $0x13
  80178b:	e8 13 fe ff ff       	call   8015a3 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	90                   	nop
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 14                	push   $0x14
  8017a5:	e8 f9 fd ff ff       	call   8015a3 <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
}
  8017ad:	90                   	nop
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	50                   	push   %eax
  8017c9:	6a 15                	push   $0x15
  8017cb:	e8 d3 fd ff ff       	call   8015a3 <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
}
  8017d3:	90                   	nop
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 16                	push   $0x16
  8017e5:	e8 b9 fd ff ff       	call   8015a3 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	90                   	nop
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	50                   	push   %eax
  801800:	6a 17                	push   $0x17
  801802:	e8 9c fd ff ff       	call   8015a3 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	52                   	push   %edx
  80181c:	50                   	push   %eax
  80181d:	6a 1a                	push   $0x1a
  80181f:	e8 7f fd ff ff       	call   8015a3 <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80182c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	52                   	push   %edx
  801839:	50                   	push   %eax
  80183a:	6a 18                	push   $0x18
  80183c:	e8 62 fd ff ff       	call   8015a3 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	52                   	push   %edx
  801857:	50                   	push   %eax
  801858:	6a 19                	push   $0x19
  80185a:	e8 44 fd ff ff       	call   8015a3 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	90                   	nop
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801871:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801874:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	6a 00                	push   $0x0
  80187d:	51                   	push   %ecx
  80187e:	52                   	push   %edx
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	50                   	push   %eax
  801883:	6a 1b                	push   $0x1b
  801885:	e8 19 fd ff ff       	call   8015a3 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 1c                	push   $0x1c
  8018a2:	e8 fc fc ff ff       	call   8015a3 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	51                   	push   %ecx
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	6a 1d                	push   $0x1d
  8018c1:	e8 dd fc ff ff       	call   8015a3 <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	52                   	push   %edx
  8018db:	50                   	push   %eax
  8018dc:	6a 1e                	push   $0x1e
  8018de:	e8 c0 fc ff ff       	call   8015a3 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 1f                	push   $0x1f
  8018f7:	e8 a7 fc ff ff       	call   8015a3 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	ff 75 14             	pushl  0x14(%ebp)
  80190c:	ff 75 10             	pushl  0x10(%ebp)
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	50                   	push   %eax
  801913:	6a 20                	push   $0x20
  801915:	e8 89 fc ff ff       	call   8015a3 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	50                   	push   %eax
  80192e:	6a 21                	push   $0x21
  801930:	e8 6e fc ff ff       	call   8015a3 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	90                   	nop
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	50                   	push   %eax
  80194a:	6a 22                	push   $0x22
  80194c:	e8 52 fc ff ff       	call   8015a3 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 02                	push   $0x2
  801965:	e8 39 fc ff ff       	call   8015a3 <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 03                	push   $0x3
  80197e:	e8 20 fc ff ff       	call   8015a3 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 04                	push   $0x4
  801997:	e8 07 fc ff ff       	call   8015a3 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_exit_env>:


void sys_exit_env(void)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 23                	push   $0x23
  8019b0:	e8 ee fb ff ff       	call   8015a3 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019c1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019c4:	8d 50 04             	lea    0x4(%eax),%edx
  8019c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	52                   	push   %edx
  8019d1:	50                   	push   %eax
  8019d2:	6a 24                	push   $0x24
  8019d4:	e8 ca fb ff ff       	call   8015a3 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
	return result;
  8019dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e5:	89 01                	mov    %eax,(%ecx)
  8019e7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	c9                   	leave  
  8019ee:	c2 04 00             	ret    $0x4

008019f1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	ff 75 10             	pushl  0x10(%ebp)
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	6a 12                	push   $0x12
  801a03:	e8 9b fb ff ff       	call   8015a3 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0b:	90                   	nop
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_rcr2>:
uint32 sys_rcr2()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 25                	push   $0x25
  801a1d:	e8 81 fb ff ff       	call   8015a3 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a33:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	50                   	push   %eax
  801a40:	6a 26                	push   $0x26
  801a42:	e8 5c fb ff ff       	call   8015a3 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4a:	90                   	nop
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <rsttst>:
void rsttst()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 28                	push   $0x28
  801a5c:	e8 42 fb ff ff       	call   8015a3 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
	return ;
  801a64:	90                   	nop
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a73:	8b 55 18             	mov    0x18(%ebp),%edx
  801a76:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7a:	52                   	push   %edx
  801a7b:	50                   	push   %eax
  801a7c:	ff 75 10             	pushl  0x10(%ebp)
  801a7f:	ff 75 0c             	pushl  0xc(%ebp)
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	6a 27                	push   $0x27
  801a87:	e8 17 fb ff ff       	call   8015a3 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8f:	90                   	nop
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <chktst>:
void chktst(uint32 n)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 08             	pushl  0x8(%ebp)
  801aa0:	6a 29                	push   $0x29
  801aa2:	e8 fc fa ff ff       	call   8015a3 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aaa:	90                   	nop
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <inctst>:

void inctst()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 2a                	push   $0x2a
  801abc:	e8 e2 fa ff ff       	call   8015a3 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac4:	90                   	nop
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <gettst>:
uint32 gettst()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 2b                	push   $0x2b
  801ad6:	e8 c8 fa ff ff       	call   8015a3 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 2c                	push   $0x2c
  801af2:	e8 ac fa ff ff       	call   8015a3 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
  801afa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801afd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b01:	75 07                	jne    801b0a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
  801b08:	eb 05                	jmp    801b0f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 2c                	push   $0x2c
  801b23:	e8 7b fa ff ff       	call   8015a3 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
  801b2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b2e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b32:	75 07                	jne    801b3b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b34:	b8 01 00 00 00       	mov    $0x1,%eax
  801b39:	eb 05                	jmp    801b40 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 2c                	push   $0x2c
  801b54:	e8 4a fa ff ff       	call   8015a3 <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
  801b5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b5f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b63:	75 07                	jne    801b6c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b65:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6a:	eb 05                	jmp    801b71 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 2c                	push   $0x2c
  801b85:	e8 19 fa ff ff       	call   8015a3 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
  801b8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b90:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b94:	75 07                	jne    801b9d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b96:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9b:	eb 05                	jmp    801ba2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 08             	pushl  0x8(%ebp)
  801bb2:	6a 2d                	push   $0x2d
  801bb4:	e8 ea f9 ff ff       	call   8015a3 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbc:	90                   	nop
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801bc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	53                   	push   %ebx
  801bd2:	51                   	push   %ecx
  801bd3:	52                   	push   %edx
  801bd4:	50                   	push   %eax
  801bd5:	6a 2e                	push   $0x2e
  801bd7:	e8 c7 f9 ff ff       	call   8015a3 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	52                   	push   %edx
  801bf4:	50                   	push   %eax
  801bf5:	6a 2f                	push   $0x2f
  801bf7:	e8 a7 f9 ff ff       	call   8015a3 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	68 c4 3c 80 00       	push   $0x803cc4
  801c0f:	e8 46 e8 ff ff       	call   80045a <cprintf>
  801c14:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	68 f0 3c 80 00       	push   $0x803cf0
  801c26:	e8 2f e8 ff ff       	call   80045a <cprintf>
  801c2b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c2e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c32:	a1 38 41 80 00       	mov    0x804138,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 56                	jmp    801c92 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c40:	74 1c                	je     801c5e <print_mem_block_lists+0x5d>
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	8b 50 08             	mov    0x8(%eax),%edx
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	8b 48 08             	mov    0x8(%eax),%ecx
  801c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c51:	8b 40 0c             	mov    0xc(%eax),%eax
  801c54:	01 c8                	add    %ecx,%eax
  801c56:	39 c2                	cmp    %eax,%edx
  801c58:	73 04                	jae    801c5e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c5a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	8b 50 08             	mov    0x8(%eax),%edx
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6a:	01 c2                	add    %eax,%edx
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	8b 40 08             	mov    0x8(%eax),%eax
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	68 05 3d 80 00       	push   $0x803d05
  801c7c:	e8 d9 e7 ff ff       	call   80045a <cprintf>
  801c81:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c8a:	a1 40 41 80 00       	mov    0x804140,%eax
  801c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c96:	74 07                	je     801c9f <print_mem_block_lists+0x9e>
  801c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9b:	8b 00                	mov    (%eax),%eax
  801c9d:	eb 05                	jmp    801ca4 <print_mem_block_lists+0xa3>
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca4:	a3 40 41 80 00       	mov    %eax,0x804140
  801ca9:	a1 40 41 80 00       	mov    0x804140,%eax
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	75 8a                	jne    801c3c <print_mem_block_lists+0x3b>
  801cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cb6:	75 84                	jne    801c3c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801cb8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801cbc:	75 10                	jne    801cce <print_mem_block_lists+0xcd>
  801cbe:	83 ec 0c             	sub    $0xc,%esp
  801cc1:	68 14 3d 80 00       	push   $0x803d14
  801cc6:	e8 8f e7 ff ff       	call   80045a <cprintf>
  801ccb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801cce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	68 38 3d 80 00       	push   $0x803d38
  801cdd:	e8 78 e7 ff ff       	call   80045a <cprintf>
  801ce2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ce5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ce9:	a1 40 40 80 00       	mov    0x804040,%eax
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf1:	eb 56                	jmp    801d49 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf7:	74 1c                	je     801d15 <print_mem_block_lists+0x114>
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	8b 50 08             	mov    0x8(%eax),%edx
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	8b 48 08             	mov    0x8(%eax),%ecx
  801d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d08:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0b:	01 c8                	add    %ecx,%eax
  801d0d:	39 c2                	cmp    %eax,%edx
  801d0f:	73 04                	jae    801d15 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d11:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d18:	8b 50 08             	mov    0x8(%eax),%edx
  801d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d21:	01 c2                	add    %eax,%edx
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	8b 40 08             	mov    0x8(%eax),%eax
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	52                   	push   %edx
  801d2d:	50                   	push   %eax
  801d2e:	68 05 3d 80 00       	push   $0x803d05
  801d33:	e8 22 e7 ff ff       	call   80045a <cprintf>
  801d38:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d41:	a1 48 40 80 00       	mov    0x804048,%eax
  801d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4d:	74 07                	je     801d56 <print_mem_block_lists+0x155>
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	8b 00                	mov    (%eax),%eax
  801d54:	eb 05                	jmp    801d5b <print_mem_block_lists+0x15a>
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5b:	a3 48 40 80 00       	mov    %eax,0x804048
  801d60:	a1 48 40 80 00       	mov    0x804048,%eax
  801d65:	85 c0                	test   %eax,%eax
  801d67:	75 8a                	jne    801cf3 <print_mem_block_lists+0xf2>
  801d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6d:	75 84                	jne    801cf3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d6f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d73:	75 10                	jne    801d85 <print_mem_block_lists+0x184>
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	68 50 3d 80 00       	push   $0x803d50
  801d7d:	e8 d8 e6 ff ff       	call   80045a <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801d85:	83 ec 0c             	sub    $0xc,%esp
  801d88:	68 c4 3c 80 00       	push   $0x803cc4
  801d8d:	e8 c8 e6 ff ff       	call   80045a <cprintf>
  801d92:	83 c4 10             	add    $0x10,%esp

}
  801d95:	90                   	nop
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801d9e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801da5:	00 00 00 
  801da8:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801daf:	00 00 00 
  801db2:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801db9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801dbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801dc3:	e9 9e 00 00 00       	jmp    801e66 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801dc8:	a1 50 40 80 00       	mov    0x804050,%eax
  801dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd0:	c1 e2 04             	shl    $0x4,%edx
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	75 14                	jne    801ded <initialize_MemBlocksList+0x55>
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	68 78 3d 80 00       	push   $0x803d78
  801de1:	6a 46                	push   $0x46
  801de3:	68 9b 3d 80 00       	push   $0x803d9b
  801de8:	e8 64 14 00 00       	call   803251 <_panic>
  801ded:	a1 50 40 80 00       	mov    0x804050,%eax
  801df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df5:	c1 e2 04             	shl    $0x4,%edx
  801df8:	01 d0                	add    %edx,%eax
  801dfa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e00:	89 10                	mov    %edx,(%eax)
  801e02:	8b 00                	mov    (%eax),%eax
  801e04:	85 c0                	test   %eax,%eax
  801e06:	74 18                	je     801e20 <initialize_MemBlocksList+0x88>
  801e08:	a1 48 41 80 00       	mov    0x804148,%eax
  801e0d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e13:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e16:	c1 e1 04             	shl    $0x4,%ecx
  801e19:	01 ca                	add    %ecx,%edx
  801e1b:	89 50 04             	mov    %edx,0x4(%eax)
  801e1e:	eb 12                	jmp    801e32 <initialize_MemBlocksList+0x9a>
  801e20:	a1 50 40 80 00       	mov    0x804050,%eax
  801e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e28:	c1 e2 04             	shl    $0x4,%edx
  801e2b:	01 d0                	add    %edx,%eax
  801e2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e32:	a1 50 40 80 00       	mov    0x804050,%eax
  801e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e3a:	c1 e2 04             	shl    $0x4,%edx
  801e3d:	01 d0                	add    %edx,%eax
  801e3f:	a3 48 41 80 00       	mov    %eax,0x804148
  801e44:	a1 50 40 80 00       	mov    0x804050,%eax
  801e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e4c:	c1 e2 04             	shl    $0x4,%edx
  801e4f:	01 d0                	add    %edx,%eax
  801e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e58:	a1 54 41 80 00       	mov    0x804154,%eax
  801e5d:	40                   	inc    %eax
  801e5e:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801e63:	ff 45 f4             	incl   -0xc(%ebp)
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e6c:	0f 82 56 ff ff ff    	jb     801dc8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801e72:	90                   	nop
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	8b 00                	mov    (%eax),%eax
  801e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e83:	eb 19                	jmp    801e9e <find_block+0x29>
	{
		if(va==point->sva)
  801e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e88:	8b 40 08             	mov    0x8(%eax),%eax
  801e8b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e8e:	75 05                	jne    801e95 <find_block+0x20>
		   return point;
  801e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e93:	eb 36                	jmp    801ecb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	8b 40 08             	mov    0x8(%eax),%eax
  801e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ea2:	74 07                	je     801eab <find_block+0x36>
  801ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ea7:	8b 00                	mov    (%eax),%eax
  801ea9:	eb 05                	jmp    801eb0 <find_block+0x3b>
  801eab:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb3:	89 42 08             	mov    %eax,0x8(%edx)
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	8b 40 08             	mov    0x8(%eax),%eax
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	75 c5                	jne    801e85 <find_block+0x10>
  801ec0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ec4:	75 bf                	jne    801e85 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801ed3:	a1 40 40 80 00       	mov    0x804040,%eax
  801ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801edb:	a1 44 40 80 00       	mov    0x804044,%eax
  801ee0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ee9:	74 24                	je     801f0f <insert_sorted_allocList+0x42>
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	8b 50 08             	mov    0x8(%eax),%edx
  801ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef4:	8b 40 08             	mov    0x8(%eax),%eax
  801ef7:	39 c2                	cmp    %eax,%edx
  801ef9:	76 14                	jbe    801f0f <insert_sorted_allocList+0x42>
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	8b 50 08             	mov    0x8(%eax),%edx
  801f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f04:	8b 40 08             	mov    0x8(%eax),%eax
  801f07:	39 c2                	cmp    %eax,%edx
  801f09:	0f 82 60 01 00 00    	jb     80206f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f13:	75 65                	jne    801f7a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f19:	75 14                	jne    801f2f <insert_sorted_allocList+0x62>
  801f1b:	83 ec 04             	sub    $0x4,%esp
  801f1e:	68 78 3d 80 00       	push   $0x803d78
  801f23:	6a 6b                	push   $0x6b
  801f25:	68 9b 3d 80 00       	push   $0x803d9b
  801f2a:	e8 22 13 00 00       	call   803251 <_panic>
  801f2f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	89 10                	mov    %edx,(%eax)
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	8b 00                	mov    (%eax),%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	74 0d                	je     801f50 <insert_sorted_allocList+0x83>
  801f43:	a1 40 40 80 00       	mov    0x804040,%eax
  801f48:	8b 55 08             	mov    0x8(%ebp),%edx
  801f4b:	89 50 04             	mov    %edx,0x4(%eax)
  801f4e:	eb 08                	jmp    801f58 <insert_sorted_allocList+0x8b>
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	a3 44 40 80 00       	mov    %eax,0x804044
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	a3 40 40 80 00       	mov    %eax,0x804040
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f6a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f6f:	40                   	inc    %eax
  801f70:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f75:	e9 dc 01 00 00       	jmp    802156 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	8b 50 08             	mov    0x8(%eax),%edx
  801f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	39 c2                	cmp    %eax,%edx
  801f88:	77 6c                	ja     801ff6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801f8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8e:	74 06                	je     801f96 <insert_sorted_allocList+0xc9>
  801f90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f94:	75 14                	jne    801faa <insert_sorted_allocList+0xdd>
  801f96:	83 ec 04             	sub    $0x4,%esp
  801f99:	68 b4 3d 80 00       	push   $0x803db4
  801f9e:	6a 6f                	push   $0x6f
  801fa0:	68 9b 3d 80 00       	push   $0x803d9b
  801fa5:	e8 a7 12 00 00       	call   803251 <_panic>
  801faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fad:	8b 50 04             	mov    0x4(%eax),%edx
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	89 50 04             	mov    %edx,0x4(%eax)
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fbc:	89 10                	mov    %edx,(%eax)
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	8b 40 04             	mov    0x4(%eax),%eax
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	74 0d                	je     801fd5 <insert_sorted_allocList+0x108>
  801fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcb:	8b 40 04             	mov    0x4(%eax),%eax
  801fce:	8b 55 08             	mov    0x8(%ebp),%edx
  801fd1:	89 10                	mov    %edx,(%eax)
  801fd3:	eb 08                	jmp    801fdd <insert_sorted_allocList+0x110>
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	a3 40 40 80 00       	mov    %eax,0x804040
  801fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe3:	89 50 04             	mov    %edx,0x4(%eax)
  801fe6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801feb:	40                   	inc    %eax
  801fec:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ff1:	e9 60 01 00 00       	jmp    802156 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	8b 50 08             	mov    0x8(%eax),%edx
  801ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fff:	8b 40 08             	mov    0x8(%eax),%eax
  802002:	39 c2                	cmp    %eax,%edx
  802004:	0f 82 4c 01 00 00    	jb     802156 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80200a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80200e:	75 14                	jne    802024 <insert_sorted_allocList+0x157>
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	68 ec 3d 80 00       	push   $0x803dec
  802018:	6a 73                	push   $0x73
  80201a:	68 9b 3d 80 00       	push   $0x803d9b
  80201f:	e8 2d 12 00 00       	call   803251 <_panic>
  802024:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	89 50 04             	mov    %edx,0x4(%eax)
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	8b 40 04             	mov    0x4(%eax),%eax
  802036:	85 c0                	test   %eax,%eax
  802038:	74 0c                	je     802046 <insert_sorted_allocList+0x179>
  80203a:	a1 44 40 80 00       	mov    0x804044,%eax
  80203f:	8b 55 08             	mov    0x8(%ebp),%edx
  802042:	89 10                	mov    %edx,(%eax)
  802044:	eb 08                	jmp    80204e <insert_sorted_allocList+0x181>
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	a3 40 40 80 00       	mov    %eax,0x804040
  80204e:	8b 45 08             	mov    0x8(%ebp),%eax
  802051:	a3 44 40 80 00       	mov    %eax,0x804044
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80205f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802064:	40                   	inc    %eax
  802065:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80206a:	e9 e7 00 00 00       	jmp    802156 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802075:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80207c:	a1 40 40 80 00       	mov    0x804040,%eax
  802081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802084:	e9 9d 00 00 00       	jmp    802126 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	8b 00                	mov    (%eax),%eax
  80208e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	8b 50 08             	mov    0x8(%eax),%edx
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 40 08             	mov    0x8(%eax),%eax
  80209d:	39 c2                	cmp    %eax,%edx
  80209f:	76 7d                	jbe    80211e <insert_sorted_allocList+0x251>
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	8b 50 08             	mov    0x8(%eax),%edx
  8020a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020aa:	8b 40 08             	mov    0x8(%eax),%eax
  8020ad:	39 c2                	cmp    %eax,%edx
  8020af:	73 6d                	jae    80211e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8020b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b5:	74 06                	je     8020bd <insert_sorted_allocList+0x1f0>
  8020b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020bb:	75 14                	jne    8020d1 <insert_sorted_allocList+0x204>
  8020bd:	83 ec 04             	sub    $0x4,%esp
  8020c0:	68 10 3e 80 00       	push   $0x803e10
  8020c5:	6a 7f                	push   $0x7f
  8020c7:	68 9b 3d 80 00       	push   $0x803d9b
  8020cc:	e8 80 11 00 00       	call   803251 <_panic>
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 10                	mov    (%eax),%edx
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	89 10                	mov    %edx,(%eax)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	74 0b                	je     8020ef <insert_sorted_allocList+0x222>
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	8b 00                	mov    (%eax),%eax
  8020e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ec:	89 50 04             	mov    %edx,0x4(%eax)
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f5:	89 10                	mov    %edx,(%eax)
  8020f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fd:	89 50 04             	mov    %edx,0x4(%eax)
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	75 08                	jne    802111 <insert_sorted_allocList+0x244>
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	a3 44 40 80 00       	mov    %eax,0x804044
  802111:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802116:	40                   	inc    %eax
  802117:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80211c:	eb 39                	jmp    802157 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80211e:	a1 48 40 80 00       	mov    0x804048,%eax
  802123:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212a:	74 07                	je     802133 <insert_sorted_allocList+0x266>
  80212c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	eb 05                	jmp    802138 <insert_sorted_allocList+0x26b>
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	a3 48 40 80 00       	mov    %eax,0x804048
  80213d:	a1 48 40 80 00       	mov    0x804048,%eax
  802142:	85 c0                	test   %eax,%eax
  802144:	0f 85 3f ff ff ff    	jne    802089 <insert_sorted_allocList+0x1bc>
  80214a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214e:	0f 85 35 ff ff ff    	jne    802089 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802154:	eb 01                	jmp    802157 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802156:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802157:	90                   	nop
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802160:	a1 38 41 80 00       	mov    0x804138,%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802168:	e9 85 01 00 00       	jmp    8022f2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 0c             	mov    0xc(%eax),%eax
  802173:	3b 45 08             	cmp    0x8(%ebp),%eax
  802176:	0f 82 6e 01 00 00    	jb     8022ea <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	8b 40 0c             	mov    0xc(%eax),%eax
  802182:	3b 45 08             	cmp    0x8(%ebp),%eax
  802185:	0f 85 8a 00 00 00    	jne    802215 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80218b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218f:	75 17                	jne    8021a8 <alloc_block_FF+0x4e>
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 44 3e 80 00       	push   $0x803e44
  802199:	68 93 00 00 00       	push   $0x93
  80219e:	68 9b 3d 80 00       	push   $0x803d9b
  8021a3:	e8 a9 10 00 00       	call   803251 <_panic>
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 00                	mov    (%eax),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 10                	je     8021c1 <alloc_block_FF+0x67>
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b9:	8b 52 04             	mov    0x4(%edx),%edx
  8021bc:	89 50 04             	mov    %edx,0x4(%eax)
  8021bf:	eb 0b                	jmp    8021cc <alloc_block_FF+0x72>
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 40 04             	mov    0x4(%eax),%eax
  8021c7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 40 04             	mov    0x4(%eax),%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	74 0f                	je     8021e5 <alloc_block_FF+0x8b>
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 40 04             	mov    0x4(%eax),%eax
  8021dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021df:	8b 12                	mov    (%edx),%edx
  8021e1:	89 10                	mov    %edx,(%eax)
  8021e3:	eb 0a                	jmp    8021ef <alloc_block_FF+0x95>
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	a3 38 41 80 00       	mov    %eax,0x804138
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802202:	a1 44 41 80 00       	mov    0x804144,%eax
  802207:	48                   	dec    %eax
  802208:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	e9 10 01 00 00       	jmp    802325 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 40 0c             	mov    0xc(%eax),%eax
  80221b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80221e:	0f 86 c6 00 00 00    	jbe    8022ea <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802224:	a1 48 41 80 00       	mov    0x804148,%eax
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 50 08             	mov    0x8(%eax),%edx
  802232:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802235:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223b:	8b 55 08             	mov    0x8(%ebp),%edx
  80223e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802241:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802245:	75 17                	jne    80225e <alloc_block_FF+0x104>
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	68 44 3e 80 00       	push   $0x803e44
  80224f:	68 9b 00 00 00       	push   $0x9b
  802254:	68 9b 3d 80 00       	push   $0x803d9b
  802259:	e8 f3 0f 00 00       	call   803251 <_panic>
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	8b 00                	mov    (%eax),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	74 10                	je     802277 <alloc_block_FF+0x11d>
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226f:	8b 52 04             	mov    0x4(%edx),%edx
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	eb 0b                	jmp    802282 <alloc_block_FF+0x128>
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 40 04             	mov    0x4(%eax),%eax
  80227d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802282:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802285:	8b 40 04             	mov    0x4(%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	74 0f                	je     80229b <alloc_block_FF+0x141>
  80228c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228f:	8b 40 04             	mov    0x4(%eax),%eax
  802292:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802295:	8b 12                	mov    (%edx),%edx
  802297:	89 10                	mov    %edx,(%eax)
  802299:	eb 0a                	jmp    8022a5 <alloc_block_FF+0x14b>
  80229b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	a3 48 41 80 00       	mov    %eax,0x804148
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b8:	a1 54 41 80 00       	mov    0x804154,%eax
  8022bd:	48                   	dec    %eax
  8022be:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 50 08             	mov    0x8(%eax),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	01 c2                	add    %eax,%edx
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022da:	2b 45 08             	sub    0x8(%ebp),%eax
  8022dd:	89 c2                	mov    %eax,%edx
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8022e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e8:	eb 3b                	jmp    802325 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f6:	74 07                	je     8022ff <alloc_block_FF+0x1a5>
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 00                	mov    (%eax),%eax
  8022fd:	eb 05                	jmp    802304 <alloc_block_FF+0x1aa>
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	a3 40 41 80 00       	mov    %eax,0x804140
  802309:	a1 40 41 80 00       	mov    0x804140,%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	0f 85 57 fe ff ff    	jne    80216d <alloc_block_FF+0x13>
  802316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231a:	0f 85 4d fe ff ff    	jne    80216d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80232d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802334:	a1 38 41 80 00       	mov    0x804138,%eax
  802339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233c:	e9 df 00 00 00       	jmp    802420 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 40 0c             	mov    0xc(%eax),%eax
  802347:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234a:	0f 82 c8 00 00 00    	jb     802418 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 0c             	mov    0xc(%eax),%eax
  802356:	3b 45 08             	cmp    0x8(%ebp),%eax
  802359:	0f 85 8a 00 00 00    	jne    8023e9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80235f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802363:	75 17                	jne    80237c <alloc_block_BF+0x55>
  802365:	83 ec 04             	sub    $0x4,%esp
  802368:	68 44 3e 80 00       	push   $0x803e44
  80236d:	68 b7 00 00 00       	push   $0xb7
  802372:	68 9b 3d 80 00       	push   $0x803d9b
  802377:	e8 d5 0e 00 00       	call   803251 <_panic>
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 00                	mov    (%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 10                	je     802395 <alloc_block_BF+0x6e>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 00                	mov    (%eax),%eax
  80238a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238d:	8b 52 04             	mov    0x4(%edx),%edx
  802390:	89 50 04             	mov    %edx,0x4(%eax)
  802393:	eb 0b                	jmp    8023a0 <alloc_block_BF+0x79>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 40 04             	mov    0x4(%eax),%eax
  80239b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 40 04             	mov    0x4(%eax),%eax
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	74 0f                	je     8023b9 <alloc_block_BF+0x92>
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 40 04             	mov    0x4(%eax),%eax
  8023b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b3:	8b 12                	mov    (%edx),%edx
  8023b5:	89 10                	mov    %edx,(%eax)
  8023b7:	eb 0a                	jmp    8023c3 <alloc_block_BF+0x9c>
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 00                	mov    (%eax),%eax
  8023be:	a3 38 41 80 00       	mov    %eax,0x804138
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8023db:	48                   	dec    %eax
  8023dc:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	e9 4d 01 00 00       	jmp    802536 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f2:	76 24                	jbe    802418 <alloc_block_BF+0xf1>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023fd:	73 19                	jae    802418 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8023ff:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 40 0c             	mov    0xc(%eax),%eax
  80240c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 08             	mov    0x8(%eax),%eax
  802415:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802418:	a1 40 41 80 00       	mov    0x804140,%eax
  80241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802424:	74 07                	je     80242d <alloc_block_BF+0x106>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	eb 05                	jmp    802432 <alloc_block_BF+0x10b>
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
  802432:	a3 40 41 80 00       	mov    %eax,0x804140
  802437:	a1 40 41 80 00       	mov    0x804140,%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	0f 85 fd fe ff ff    	jne    802341 <alloc_block_BF+0x1a>
  802444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802448:	0f 85 f3 fe ff ff    	jne    802341 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80244e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802452:	0f 84 d9 00 00 00    	je     802531 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802458:	a1 48 41 80 00       	mov    0x804148,%eax
  80245d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802460:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802463:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802466:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802469:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246c:	8b 55 08             	mov    0x8(%ebp),%edx
  80246f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802472:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802476:	75 17                	jne    80248f <alloc_block_BF+0x168>
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	68 44 3e 80 00       	push   $0x803e44
  802480:	68 c7 00 00 00       	push   $0xc7
  802485:	68 9b 3d 80 00       	push   $0x803d9b
  80248a:	e8 c2 0d 00 00       	call   803251 <_panic>
  80248f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 10                	je     8024a8 <alloc_block_BF+0x181>
  802498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a0:	8b 52 04             	mov    0x4(%edx),%edx
  8024a3:	89 50 04             	mov    %edx,0x4(%eax)
  8024a6:	eb 0b                	jmp    8024b3 <alloc_block_BF+0x18c>
  8024a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 0f                	je     8024cc <alloc_block_BF+0x1a5>
  8024bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024c6:	8b 12                	mov    (%edx),%edx
  8024c8:	89 10                	mov    %edx,(%eax)
  8024ca:	eb 0a                	jmp    8024d6 <alloc_block_BF+0x1af>
  8024cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	a3 48 41 80 00       	mov    %eax,0x804148
  8024d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e9:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ee:	48                   	dec    %eax
  8024ef:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8024f4:	83 ec 08             	sub    $0x8,%esp
  8024f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8024fa:	68 38 41 80 00       	push   $0x804138
  8024ff:	e8 71 f9 ff ff       	call   801e75 <find_block>
  802504:	83 c4 10             	add    $0x10,%esp
  802507:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80250a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80250d:	8b 50 08             	mov    0x8(%eax),%edx
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	01 c2                	add    %eax,%edx
  802515:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802518:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80251b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251e:	8b 40 0c             	mov    0xc(%eax),%eax
  802521:	2b 45 08             	sub    0x8(%ebp),%eax
  802524:	89 c2                	mov    %eax,%edx
  802526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802529:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80252c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252f:	eb 05                	jmp    802536 <alloc_block_BF+0x20f>
	}
	return NULL;
  802531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802536:	c9                   	leave  
  802537:	c3                   	ret    

00802538 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802538:	55                   	push   %ebp
  802539:	89 e5                	mov    %esp,%ebp
  80253b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80253e:	a1 28 40 80 00       	mov    0x804028,%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 85 de 01 00 00    	jne    802729 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80254b:	a1 38 41 80 00       	mov    0x804138,%eax
  802550:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802553:	e9 9e 01 00 00       	jmp    8026f6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802561:	0f 82 87 01 00 00    	jb     8026ee <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 40 0c             	mov    0xc(%eax),%eax
  80256d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802570:	0f 85 95 00 00 00    	jne    80260b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257a:	75 17                	jne    802593 <alloc_block_NF+0x5b>
  80257c:	83 ec 04             	sub    $0x4,%esp
  80257f:	68 44 3e 80 00       	push   $0x803e44
  802584:	68 e0 00 00 00       	push   $0xe0
  802589:	68 9b 3d 80 00       	push   $0x803d9b
  80258e:	e8 be 0c 00 00       	call   803251 <_panic>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 10                	je     8025ac <alloc_block_NF+0x74>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a4:	8b 52 04             	mov    0x4(%edx),%edx
  8025a7:	89 50 04             	mov    %edx,0x4(%eax)
  8025aa:	eb 0b                	jmp    8025b7 <alloc_block_NF+0x7f>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0f                	je     8025d0 <alloc_block_NF+0x98>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ca:	8b 12                	mov    (%edx),%edx
  8025cc:	89 10                	mov    %edx,(%eax)
  8025ce:	eb 0a                	jmp    8025da <alloc_block_NF+0xa2>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ed:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f2:	48                   	dec    %eax
  8025f3:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 08             	mov    0x8(%eax),%eax
  8025fe:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	e9 f8 04 00 00       	jmp    802b03 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 40 0c             	mov    0xc(%eax),%eax
  802611:	3b 45 08             	cmp    0x8(%ebp),%eax
  802614:	0f 86 d4 00 00 00    	jbe    8026ee <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80261a:	a1 48 41 80 00       	mov    0x804148,%eax
  80261f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 50 08             	mov    0x8(%eax),%edx
  802628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	8b 55 08             	mov    0x8(%ebp),%edx
  802634:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802637:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263b:	75 17                	jne    802654 <alloc_block_NF+0x11c>
  80263d:	83 ec 04             	sub    $0x4,%esp
  802640:	68 44 3e 80 00       	push   $0x803e44
  802645:	68 e9 00 00 00       	push   $0xe9
  80264a:	68 9b 3d 80 00       	push   $0x803d9b
  80264f:	e8 fd 0b 00 00       	call   803251 <_panic>
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 10                	je     80266d <alloc_block_NF+0x135>
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	8b 00                	mov    (%eax),%eax
  802662:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802665:	8b 52 04             	mov    0x4(%edx),%edx
  802668:	89 50 04             	mov    %edx,0x4(%eax)
  80266b:	eb 0b                	jmp    802678 <alloc_block_NF+0x140>
  80266d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802670:	8b 40 04             	mov    0x4(%eax),%eax
  802673:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	74 0f                	je     802691 <alloc_block_NF+0x159>
  802682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802685:	8b 40 04             	mov    0x4(%eax),%eax
  802688:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268b:	8b 12                	mov    (%edx),%edx
  80268d:	89 10                	mov    %edx,(%eax)
  80268f:	eb 0a                	jmp    80269b <alloc_block_NF+0x163>
  802691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	a3 48 41 80 00       	mov    %eax,0x804148
  80269b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8026b3:	48                   	dec    %eax
  8026b4:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	8b 40 08             	mov    0x8(%eax),%eax
  8026bf:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	01 c2                	add    %eax,%edx
  8026cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	2b 45 08             	sub    0x8(%ebp),%eax
  8026de:	89 c2                	mov    %eax,%edx
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	e9 15 04 00 00       	jmp    802b03 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	74 07                	je     802703 <alloc_block_NF+0x1cb>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	eb 05                	jmp    802708 <alloc_block_NF+0x1d0>
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	a3 40 41 80 00       	mov    %eax,0x804140
  80270d:	a1 40 41 80 00       	mov    0x804140,%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	0f 85 3e fe ff ff    	jne    802558 <alloc_block_NF+0x20>
  80271a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271e:	0f 85 34 fe ff ff    	jne    802558 <alloc_block_NF+0x20>
  802724:	e9 d5 03 00 00       	jmp    802afe <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802729:	a1 38 41 80 00       	mov    0x804138,%eax
  80272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802731:	e9 b1 01 00 00       	jmp    8028e7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 50 08             	mov    0x8(%eax),%edx
  80273c:	a1 28 40 80 00       	mov    0x804028,%eax
  802741:	39 c2                	cmp    %eax,%edx
  802743:	0f 82 96 01 00 00    	jb     8028df <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 40 0c             	mov    0xc(%eax),%eax
  80274f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802752:	0f 82 87 01 00 00    	jb     8028df <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 0c             	mov    0xc(%eax),%eax
  80275e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802761:	0f 85 95 00 00 00    	jne    8027fc <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802767:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276b:	75 17                	jne    802784 <alloc_block_NF+0x24c>
  80276d:	83 ec 04             	sub    $0x4,%esp
  802770:	68 44 3e 80 00       	push   $0x803e44
  802775:	68 fc 00 00 00       	push   $0xfc
  80277a:	68 9b 3d 80 00       	push   $0x803d9b
  80277f:	e8 cd 0a 00 00       	call   803251 <_panic>
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 10                	je     80279d <alloc_block_NF+0x265>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802795:	8b 52 04             	mov    0x4(%edx),%edx
  802798:	89 50 04             	mov    %edx,0x4(%eax)
  80279b:	eb 0b                	jmp    8027a8 <alloc_block_NF+0x270>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 40 04             	mov    0x4(%eax),%eax
  8027a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	74 0f                	je     8027c1 <alloc_block_NF+0x289>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bb:	8b 12                	mov    (%edx),%edx
  8027bd:	89 10                	mov    %edx,(%eax)
  8027bf:	eb 0a                	jmp    8027cb <alloc_block_NF+0x293>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027de:	a1 44 41 80 00       	mov    0x804144,%eax
  8027e3:	48                   	dec    %eax
  8027e4:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 40 08             	mov    0x8(%eax),%eax
  8027ef:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	e9 07 03 00 00       	jmp    802b03 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802802:	3b 45 08             	cmp    0x8(%ebp),%eax
  802805:	0f 86 d4 00 00 00    	jbe    8028df <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80280b:	a1 48 41 80 00       	mov    0x804148,%eax
  802810:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 50 08             	mov    0x8(%eax),%edx
  802819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80281f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802822:	8b 55 08             	mov    0x8(%ebp),%edx
  802825:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802828:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80282c:	75 17                	jne    802845 <alloc_block_NF+0x30d>
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	68 44 3e 80 00       	push   $0x803e44
  802836:	68 04 01 00 00       	push   $0x104
  80283b:	68 9b 3d 80 00       	push   $0x803d9b
  802840:	e8 0c 0a 00 00       	call   803251 <_panic>
  802845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 10                	je     80285e <alloc_block_NF+0x326>
  80284e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802856:	8b 52 04             	mov    0x4(%edx),%edx
  802859:	89 50 04             	mov    %edx,0x4(%eax)
  80285c:	eb 0b                	jmp    802869 <alloc_block_NF+0x331>
  80285e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802861:	8b 40 04             	mov    0x4(%eax),%eax
  802864:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802869:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286c:	8b 40 04             	mov    0x4(%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 0f                	je     802882 <alloc_block_NF+0x34a>
  802873:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80287c:	8b 12                	mov    (%edx),%edx
  80287e:	89 10                	mov    %edx,(%eax)
  802880:	eb 0a                	jmp    80288c <alloc_block_NF+0x354>
  802882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	a3 48 41 80 00       	mov    %eax,0x804148
  80288c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802898:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289f:	a1 54 41 80 00       	mov    0x804154,%eax
  8028a4:	48                   	dec    %eax
  8028a5:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ad:	8b 40 08             	mov    0x8(%eax),%eax
  8028b0:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 50 08             	mov    0x8(%eax),%edx
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	01 c2                	add    %eax,%edx
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cc:	2b 45 08             	sub    0x8(%ebp),%eax
  8028cf:	89 c2                	mov    %eax,%edx
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028da:	e9 24 02 00 00       	jmp    802b03 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028df:	a1 40 41 80 00       	mov    0x804140,%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028eb:	74 07                	je     8028f4 <alloc_block_NF+0x3bc>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	eb 05                	jmp    8028f9 <alloc_block_NF+0x3c1>
  8028f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f9:	a3 40 41 80 00       	mov    %eax,0x804140
  8028fe:	a1 40 41 80 00       	mov    0x804140,%eax
  802903:	85 c0                	test   %eax,%eax
  802905:	0f 85 2b fe ff ff    	jne    802736 <alloc_block_NF+0x1fe>
  80290b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290f:	0f 85 21 fe ff ff    	jne    802736 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802915:	a1 38 41 80 00       	mov    0x804138,%eax
  80291a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291d:	e9 ae 01 00 00       	jmp    802ad0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	a1 28 40 80 00       	mov    0x804028,%eax
  80292d:	39 c2                	cmp    %eax,%edx
  80292f:	0f 83 93 01 00 00    	jae    802ac8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 0c             	mov    0xc(%eax),%eax
  80293b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293e:	0f 82 84 01 00 00    	jb     802ac8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 0c             	mov    0xc(%eax),%eax
  80294a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294d:	0f 85 95 00 00 00    	jne    8029e8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802953:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802957:	75 17                	jne    802970 <alloc_block_NF+0x438>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 44 3e 80 00       	push   $0x803e44
  802961:	68 14 01 00 00       	push   $0x114
  802966:	68 9b 3d 80 00       	push   $0x803d9b
  80296b:	e8 e1 08 00 00       	call   803251 <_panic>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 10                	je     802989 <alloc_block_NF+0x451>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802981:	8b 52 04             	mov    0x4(%edx),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 0b                	jmp    802994 <alloc_block_NF+0x45c>
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 04             	mov    0x4(%eax),%eax
  80298f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 0f                	je     8029ad <alloc_block_NF+0x475>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	8b 12                	mov    (%edx),%edx
  8029a9:	89 10                	mov    %edx,(%eax)
  8029ab:	eb 0a                	jmp    8029b7 <alloc_block_NF+0x47f>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8029cf:	48                   	dec    %eax
  8029d0:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 08             	mov    0x8(%eax),%eax
  8029db:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	e9 1b 01 00 00       	jmp    802b03 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f1:	0f 86 d1 00 00 00    	jbe    802ac8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029f7:	a1 48 41 80 00       	mov    0x804148,%eax
  8029fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a18:	75 17                	jne    802a31 <alloc_block_NF+0x4f9>
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 44 3e 80 00       	push   $0x803e44
  802a22:	68 1c 01 00 00       	push   $0x11c
  802a27:	68 9b 3d 80 00       	push   $0x803d9b
  802a2c:	e8 20 08 00 00       	call   803251 <_panic>
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 10                	je     802a4a <alloc_block_NF+0x512>
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a42:	8b 52 04             	mov    0x4(%edx),%edx
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	eb 0b                	jmp    802a55 <alloc_block_NF+0x51d>
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 0f                	je     802a6e <alloc_block_NF+0x536>
  802a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a68:	8b 12                	mov    (%edx),%edx
  802a6a:	89 10                	mov    %edx,(%eax)
  802a6c:	eb 0a                	jmp    802a78 <alloc_block_NF+0x540>
  802a6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	a3 48 41 80 00       	mov    %eax,0x804148
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8b:	a1 54 41 80 00       	mov    0x804154,%eax
  802a90:	48                   	dec    %eax
  802a91:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a99:	8b 40 08             	mov    0x8(%eax),%eax
  802a9c:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 50 08             	mov    0x8(%eax),%edx
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	01 c2                	add    %eax,%edx
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab8:	2b 45 08             	sub    0x8(%ebp),%eax
  802abb:	89 c2                	mov    %eax,%edx
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac6:	eb 3b                	jmp    802b03 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac8:	a1 40 41 80 00       	mov    0x804140,%eax
  802acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad4:	74 07                	je     802add <alloc_block_NF+0x5a5>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 00                	mov    (%eax),%eax
  802adb:	eb 05                	jmp    802ae2 <alloc_block_NF+0x5aa>
  802add:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae2:	a3 40 41 80 00       	mov    %eax,0x804140
  802ae7:	a1 40 41 80 00       	mov    0x804140,%eax
  802aec:	85 c0                	test   %eax,%eax
  802aee:	0f 85 2e fe ff ff    	jne    802922 <alloc_block_NF+0x3ea>
  802af4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af8:	0f 85 24 fe ff ff    	jne    802922 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802afe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b0b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b13:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b18:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b1b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 14                	je     802b38 <insert_sorted_with_merge_freeList+0x33>
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	8b 50 08             	mov    0x8(%eax),%edx
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	8b 40 08             	mov    0x8(%eax),%eax
  802b30:	39 c2                	cmp    %eax,%edx
  802b32:	0f 87 9b 01 00 00    	ja     802cd3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3c:	75 17                	jne    802b55 <insert_sorted_with_merge_freeList+0x50>
  802b3e:	83 ec 04             	sub    $0x4,%esp
  802b41:	68 78 3d 80 00       	push   $0x803d78
  802b46:	68 38 01 00 00       	push   $0x138
  802b4b:	68 9b 3d 80 00       	push   $0x803d9b
  802b50:	e8 fc 06 00 00       	call   803251 <_panic>
  802b55:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	89 10                	mov    %edx,(%eax)
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 0d                	je     802b76 <insert_sorted_with_merge_freeList+0x71>
  802b69:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	eb 08                	jmp    802b7e <insert_sorted_with_merge_freeList+0x79>
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	a3 38 41 80 00       	mov    %eax,0x804138
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b90:	a1 44 41 80 00       	mov    0x804144,%eax
  802b95:	40                   	inc    %eax
  802b96:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b9f:	0f 84 a8 06 00 00    	je     80324d <insert_sorted_with_merge_freeList+0x748>
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	8b 50 08             	mov    0x8(%eax),%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb1:	01 c2                	add    %eax,%edx
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 40 08             	mov    0x8(%eax),%eax
  802bb9:	39 c2                	cmp    %eax,%edx
  802bbb:	0f 85 8c 06 00 00    	jne    80324d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcd:	01 c2                	add    %eax,%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802bd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd9:	75 17                	jne    802bf2 <insert_sorted_with_merge_freeList+0xed>
  802bdb:	83 ec 04             	sub    $0x4,%esp
  802bde:	68 44 3e 80 00       	push   $0x803e44
  802be3:	68 3c 01 00 00       	push   $0x13c
  802be8:	68 9b 3d 80 00       	push   $0x803d9b
  802bed:	e8 5f 06 00 00       	call   803251 <_panic>
  802bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 10                	je     802c0b <insert_sorted_with_merge_freeList+0x106>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c03:	8b 52 04             	mov    0x4(%edx),%edx
  802c06:	89 50 04             	mov    %edx,0x4(%eax)
  802c09:	eb 0b                	jmp    802c16 <insert_sorted_with_merge_freeList+0x111>
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0f                	je     802c2f <insert_sorted_with_merge_freeList+0x12a>
  802c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c23:	8b 40 04             	mov    0x4(%eax),%eax
  802c26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c29:	8b 12                	mov    (%edx),%edx
  802c2b:	89 10                	mov    %edx,(%eax)
  802c2d:	eb 0a                	jmp    802c39 <insert_sorted_with_merge_freeList+0x134>
  802c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	a3 38 41 80 00       	mov    %eax,0x804138
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c51:	48                   	dec    %eax
  802c52:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802c6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6f:	75 17                	jne    802c88 <insert_sorted_with_merge_freeList+0x183>
  802c71:	83 ec 04             	sub    $0x4,%esp
  802c74:	68 78 3d 80 00       	push   $0x803d78
  802c79:	68 3f 01 00 00       	push   $0x13f
  802c7e:	68 9b 3d 80 00       	push   $0x803d9b
  802c83:	e8 c9 05 00 00       	call   803251 <_panic>
  802c88:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	89 10                	mov    %edx,(%eax)
  802c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	85 c0                	test   %eax,%eax
  802c9a:	74 0d                	je     802ca9 <insert_sorted_with_merge_freeList+0x1a4>
  802c9c:	a1 48 41 80 00       	mov    0x804148,%eax
  802ca1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca4:	89 50 04             	mov    %edx,0x4(%eax)
  802ca7:	eb 08                	jmp    802cb1 <insert_sorted_with_merge_freeList+0x1ac>
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	a3 48 41 80 00       	mov    %eax,0x804148
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc3:	a1 54 41 80 00       	mov    0x804154,%eax
  802cc8:	40                   	inc    %eax
  802cc9:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cce:	e9 7a 05 00 00       	jmp    80324d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	8b 50 08             	mov    0x8(%eax),%edx
  802cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdc:	8b 40 08             	mov    0x8(%eax),%eax
  802cdf:	39 c2                	cmp    %eax,%edx
  802ce1:	0f 82 14 01 00 00    	jb     802dfb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 50 08             	mov    0x8(%eax),%edx
  802ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	01 c2                	add    %eax,%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	8b 40 08             	mov    0x8(%eax),%eax
  802cfb:	39 c2                	cmp    %eax,%edx
  802cfd:	0f 85 90 00 00 00    	jne    802d93 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d06:	8b 50 0c             	mov    0xc(%eax),%edx
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0f:	01 c2                	add    %eax,%edx
  802d11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d14:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2f:	75 17                	jne    802d48 <insert_sorted_with_merge_freeList+0x243>
  802d31:	83 ec 04             	sub    $0x4,%esp
  802d34:	68 78 3d 80 00       	push   $0x803d78
  802d39:	68 49 01 00 00       	push   $0x149
  802d3e:	68 9b 3d 80 00       	push   $0x803d9b
  802d43:	e8 09 05 00 00       	call   803251 <_panic>
  802d48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	89 10                	mov    %edx,(%eax)
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0d                	je     802d69 <insert_sorted_with_merge_freeList+0x264>
  802d5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d61:	8b 55 08             	mov    0x8(%ebp),%edx
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	eb 08                	jmp    802d71 <insert_sorted_with_merge_freeList+0x26c>
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	a3 48 41 80 00       	mov    %eax,0x804148
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d83:	a1 54 41 80 00       	mov    0x804154,%eax
  802d88:	40                   	inc    %eax
  802d89:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d8e:	e9 bb 04 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d97:	75 17                	jne    802db0 <insert_sorted_with_merge_freeList+0x2ab>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 ec 3d 80 00       	push   $0x803dec
  802da1:	68 4c 01 00 00       	push   $0x14c
  802da6:	68 9b 3d 80 00       	push   $0x803d9b
  802dab:	e8 a1 04 00 00       	call   803251 <_panic>
  802db0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 0c                	je     802dd2 <insert_sorted_with_merge_freeList+0x2cd>
  802dc6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dce:	89 10                	mov    %edx,(%eax)
  802dd0:	eb 08                	jmp    802dda <insert_sorted_with_merge_freeList+0x2d5>
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	a3 38 41 80 00       	mov    %eax,0x804138
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802deb:	a1 44 41 80 00       	mov    0x804144,%eax
  802df0:	40                   	inc    %eax
  802df1:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802df6:	e9 53 04 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802dfb:	a1 38 41 80 00       	mov    0x804138,%eax
  802e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e03:	e9 15 04 00 00       	jmp    80321d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	8b 50 08             	mov    0x8(%eax),%edx
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 08             	mov    0x8(%eax),%eax
  802e1c:	39 c2                	cmp    %eax,%edx
  802e1e:	0f 86 f1 03 00 00    	jbe    803215 <insert_sorted_with_merge_freeList+0x710>
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	8b 50 08             	mov    0x8(%eax),%edx
  802e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2d:	8b 40 08             	mov    0x8(%eax),%eax
  802e30:	39 c2                	cmp    %eax,%edx
  802e32:	0f 83 dd 03 00 00    	jae    803215 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 50 08             	mov    0x8(%eax),%edx
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 0c             	mov    0xc(%eax),%eax
  802e44:	01 c2                	add    %eax,%edx
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 40 08             	mov    0x8(%eax),%eax
  802e4c:	39 c2                	cmp    %eax,%edx
  802e4e:	0f 85 b9 01 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 50 08             	mov    0x8(%eax),%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e60:	01 c2                	add    %eax,%edx
  802e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	0f 85 0d 01 00 00    	jne    802f7d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	8b 50 0c             	mov    0xc(%eax),%edx
  802e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e79:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7c:	01 c2                	add    %eax,%edx
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802e84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e88:	75 17                	jne    802ea1 <insert_sorted_with_merge_freeList+0x39c>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 44 3e 80 00       	push   $0x803e44
  802e92:	68 5c 01 00 00       	push   $0x15c
  802e97:	68 9b 3d 80 00       	push   $0x803d9b
  802e9c:	e8 b0 03 00 00       	call   803251 <_panic>
  802ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 10                	je     802eba <insert_sorted_with_merge_freeList+0x3b5>
  802eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb2:	8b 52 04             	mov    0x4(%edx),%edx
  802eb5:	89 50 04             	mov    %edx,0x4(%eax)
  802eb8:	eb 0b                	jmp    802ec5 <insert_sorted_with_merge_freeList+0x3c0>
  802eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebd:	8b 40 04             	mov    0x4(%eax),%eax
  802ec0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	74 0f                	je     802ede <insert_sorted_with_merge_freeList+0x3d9>
  802ecf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed2:	8b 40 04             	mov    0x4(%eax),%eax
  802ed5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ed8:	8b 12                	mov    (%edx),%edx
  802eda:	89 10                	mov    %edx,(%eax)
  802edc:	eb 0a                	jmp    802ee8 <insert_sorted_with_merge_freeList+0x3e3>
  802ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eeb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efb:	a1 44 41 80 00       	mov    0x804144,%eax
  802f00:	48                   	dec    %eax
  802f01:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f1e:	75 17                	jne    802f37 <insert_sorted_with_merge_freeList+0x432>
  802f20:	83 ec 04             	sub    $0x4,%esp
  802f23:	68 78 3d 80 00       	push   $0x803d78
  802f28:	68 5f 01 00 00       	push   $0x15f
  802f2d:	68 9b 3d 80 00       	push   $0x803d9b
  802f32:	e8 1a 03 00 00       	call   803251 <_panic>
  802f37:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	89 10                	mov    %edx,(%eax)
  802f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f45:	8b 00                	mov    (%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 0d                	je     802f58 <insert_sorted_with_merge_freeList+0x453>
  802f4b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f50:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f53:	89 50 04             	mov    %edx,0x4(%eax)
  802f56:	eb 08                	jmp    802f60 <insert_sorted_with_merge_freeList+0x45b>
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	a3 48 41 80 00       	mov    %eax,0x804148
  802f68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f72:	a1 54 41 80 00       	mov    0x804154,%eax
  802f77:	40                   	inc    %eax
  802f78:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	8b 50 0c             	mov    0xc(%eax),%edx
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	8b 40 0c             	mov    0xc(%eax),%eax
  802f89:	01 c2                	add    %eax,%edx
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa9:	75 17                	jne    802fc2 <insert_sorted_with_merge_freeList+0x4bd>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 78 3d 80 00       	push   $0x803d78
  802fb3:	68 64 01 00 00       	push   $0x164
  802fb8:	68 9b 3d 80 00       	push   $0x803d9b
  802fbd:	e8 8f 02 00 00       	call   803251 <_panic>
  802fc2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	89 10                	mov    %edx,(%eax)
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 0d                	je     802fe3 <insert_sorted_with_merge_freeList+0x4de>
  802fd6:	a1 48 41 80 00       	mov    0x804148,%eax
  802fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fde:	89 50 04             	mov    %edx,0x4(%eax)
  802fe1:	eb 08                	jmp    802feb <insert_sorted_with_merge_freeList+0x4e6>
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffd:	a1 54 41 80 00       	mov    0x804154,%eax
  803002:	40                   	inc    %eax
  803003:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803008:	e9 41 02 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 50 08             	mov    0x8(%eax),%edx
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 40 0c             	mov    0xc(%eax),%eax
  803019:	01 c2                	add    %eax,%edx
  80301b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301e:	8b 40 08             	mov    0x8(%eax),%eax
  803021:	39 c2                	cmp    %eax,%edx
  803023:	0f 85 7c 01 00 00    	jne    8031a5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803029:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80302d:	74 06                	je     803035 <insert_sorted_with_merge_freeList+0x530>
  80302f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803033:	75 17                	jne    80304c <insert_sorted_with_merge_freeList+0x547>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 b4 3d 80 00       	push   $0x803db4
  80303d:	68 69 01 00 00       	push   $0x169
  803042:	68 9b 3d 80 00       	push   $0x803d9b
  803047:	e8 05 02 00 00       	call   803251 <_panic>
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	8b 50 04             	mov    0x4(%eax),%edx
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	8b 40 04             	mov    0x4(%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 0d                	je     803077 <insert_sorted_with_merge_freeList+0x572>
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	8b 40 04             	mov    0x4(%eax),%eax
  803070:	8b 55 08             	mov    0x8(%ebp),%edx
  803073:	89 10                	mov    %edx,(%eax)
  803075:	eb 08                	jmp    80307f <insert_sorted_with_merge_freeList+0x57a>
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	a3 38 41 80 00       	mov    %eax,0x804138
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	8b 55 08             	mov    0x8(%ebp),%edx
  803085:	89 50 04             	mov    %edx,0x4(%eax)
  803088:	a1 44 41 80 00       	mov    0x804144,%eax
  80308d:	40                   	inc    %eax
  80308e:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	8b 50 0c             	mov    0xc(%eax),%edx
  803099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309c:	8b 40 0c             	mov    0xc(%eax),%eax
  80309f:	01 c2                	add    %eax,%edx
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ab:	75 17                	jne    8030c4 <insert_sorted_with_merge_freeList+0x5bf>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 44 3e 80 00       	push   $0x803e44
  8030b5:	68 6b 01 00 00       	push   $0x16b
  8030ba:	68 9b 3d 80 00       	push   $0x803d9b
  8030bf:	e8 8d 01 00 00       	call   803251 <_panic>
  8030c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 10                	je     8030dd <insert_sorted_with_merge_freeList+0x5d8>
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d5:	8b 52 04             	mov    0x4(%edx),%edx
  8030d8:	89 50 04             	mov    %edx,0x4(%eax)
  8030db:	eb 0b                	jmp    8030e8 <insert_sorted_with_merge_freeList+0x5e3>
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	8b 40 04             	mov    0x4(%eax),%eax
  8030e3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ee:	85 c0                	test   %eax,%eax
  8030f0:	74 0f                	je     803101 <insert_sorted_with_merge_freeList+0x5fc>
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	8b 40 04             	mov    0x4(%eax),%eax
  8030f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fb:	8b 12                	mov    (%edx),%edx
  8030fd:	89 10                	mov    %edx,(%eax)
  8030ff:	eb 0a                	jmp    80310b <insert_sorted_with_merge_freeList+0x606>
  803101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803104:	8b 00                	mov    (%eax),%eax
  803106:	a3 38 41 80 00       	mov    %eax,0x804138
  80310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311e:	a1 44 41 80 00       	mov    0x804144,%eax
  803123:	48                   	dec    %eax
  803124:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80313d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803141:	75 17                	jne    80315a <insert_sorted_with_merge_freeList+0x655>
  803143:	83 ec 04             	sub    $0x4,%esp
  803146:	68 78 3d 80 00       	push   $0x803d78
  80314b:	68 6e 01 00 00       	push   $0x16e
  803150:	68 9b 3d 80 00       	push   $0x803d9b
  803155:	e8 f7 00 00 00       	call   803251 <_panic>
  80315a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	89 10                	mov    %edx,(%eax)
  803165:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	74 0d                	je     80317b <insert_sorted_with_merge_freeList+0x676>
  80316e:	a1 48 41 80 00       	mov    0x804148,%eax
  803173:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803176:	89 50 04             	mov    %edx,0x4(%eax)
  803179:	eb 08                	jmp    803183 <insert_sorted_with_merge_freeList+0x67e>
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	a3 48 41 80 00       	mov    %eax,0x804148
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803195:	a1 54 41 80 00       	mov    0x804154,%eax
  80319a:	40                   	inc    %eax
  80319b:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031a0:	e9 a9 00 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8031a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a9:	74 06                	je     8031b1 <insert_sorted_with_merge_freeList+0x6ac>
  8031ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031af:	75 17                	jne    8031c8 <insert_sorted_with_merge_freeList+0x6c3>
  8031b1:	83 ec 04             	sub    $0x4,%esp
  8031b4:	68 10 3e 80 00       	push   $0x803e10
  8031b9:	68 73 01 00 00       	push   $0x173
  8031be:	68 9b 3d 80 00       	push   $0x803d9b
  8031c3:	e8 89 00 00 00       	call   803251 <_panic>
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 10                	mov    (%eax),%edx
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	89 10                	mov    %edx,(%eax)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	74 0b                	je     8031e6 <insert_sorted_with_merge_freeList+0x6e1>
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 00                	mov    (%eax),%eax
  8031e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e3:	89 50 04             	mov    %edx,0x4(%eax)
  8031e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ec:	89 10                	mov    %edx,(%eax)
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f4:	89 50 04             	mov    %edx,0x4(%eax)
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	75 08                	jne    803208 <insert_sorted_with_merge_freeList+0x703>
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803208:	a1 44 41 80 00       	mov    0x804144,%eax
  80320d:	40                   	inc    %eax
  80320e:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803213:	eb 39                	jmp    80324e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803215:	a1 40 41 80 00       	mov    0x804140,%eax
  80321a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	74 07                	je     80322a <insert_sorted_with_merge_freeList+0x725>
  803223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803226:	8b 00                	mov    (%eax),%eax
  803228:	eb 05                	jmp    80322f <insert_sorted_with_merge_freeList+0x72a>
  80322a:	b8 00 00 00 00       	mov    $0x0,%eax
  80322f:	a3 40 41 80 00       	mov    %eax,0x804140
  803234:	a1 40 41 80 00       	mov    0x804140,%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	0f 85 c7 fb ff ff    	jne    802e08 <insert_sorted_with_merge_freeList+0x303>
  803241:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803245:	0f 85 bd fb ff ff    	jne    802e08 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80324b:	eb 01                	jmp    80324e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80324d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80324e:	90                   	nop
  80324f:	c9                   	leave  
  803250:	c3                   	ret    

00803251 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803251:	55                   	push   %ebp
  803252:	89 e5                	mov    %esp,%ebp
  803254:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803257:	8d 45 10             	lea    0x10(%ebp),%eax
  80325a:	83 c0 04             	add    $0x4,%eax
  80325d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803260:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803265:	85 c0                	test   %eax,%eax
  803267:	74 16                	je     80327f <_panic+0x2e>
		cprintf("%s: ", argv0);
  803269:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80326e:	83 ec 08             	sub    $0x8,%esp
  803271:	50                   	push   %eax
  803272:	68 64 3e 80 00       	push   $0x803e64
  803277:	e8 de d1 ff ff       	call   80045a <cprintf>
  80327c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80327f:	a1 00 40 80 00       	mov    0x804000,%eax
  803284:	ff 75 0c             	pushl  0xc(%ebp)
  803287:	ff 75 08             	pushl  0x8(%ebp)
  80328a:	50                   	push   %eax
  80328b:	68 69 3e 80 00       	push   $0x803e69
  803290:	e8 c5 d1 ff ff       	call   80045a <cprintf>
  803295:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803298:	8b 45 10             	mov    0x10(%ebp),%eax
  80329b:	83 ec 08             	sub    $0x8,%esp
  80329e:	ff 75 f4             	pushl  -0xc(%ebp)
  8032a1:	50                   	push   %eax
  8032a2:	e8 48 d1 ff ff       	call   8003ef <vcprintf>
  8032a7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8032aa:	83 ec 08             	sub    $0x8,%esp
  8032ad:	6a 00                	push   $0x0
  8032af:	68 85 3e 80 00       	push   $0x803e85
  8032b4:	e8 36 d1 ff ff       	call   8003ef <vcprintf>
  8032b9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8032bc:	e8 b7 d0 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  8032c1:	eb fe                	jmp    8032c1 <_panic+0x70>

008032c3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8032c3:	55                   	push   %ebp
  8032c4:	89 e5                	mov    %esp,%ebp
  8032c6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8032ce:	8b 50 74             	mov    0x74(%eax),%edx
  8032d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d4:	39 c2                	cmp    %eax,%edx
  8032d6:	74 14                	je     8032ec <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032d8:	83 ec 04             	sub    $0x4,%esp
  8032db:	68 88 3e 80 00       	push   $0x803e88
  8032e0:	6a 26                	push   $0x26
  8032e2:	68 d4 3e 80 00       	push   $0x803ed4
  8032e7:	e8 65 ff ff ff       	call   803251 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032fa:	e9 c2 00 00 00       	jmp    8033c1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803302:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	01 d0                	add    %edx,%eax
  80330e:	8b 00                	mov    (%eax),%eax
  803310:	85 c0                	test   %eax,%eax
  803312:	75 08                	jne    80331c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803314:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803317:	e9 a2 00 00 00       	jmp    8033be <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80331c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803323:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80332a:	eb 69                	jmp    803395 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80332c:	a1 20 40 80 00       	mov    0x804020,%eax
  803331:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803337:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333a:	89 d0                	mov    %edx,%eax
  80333c:	01 c0                	add    %eax,%eax
  80333e:	01 d0                	add    %edx,%eax
  803340:	c1 e0 03             	shl    $0x3,%eax
  803343:	01 c8                	add    %ecx,%eax
  803345:	8a 40 04             	mov    0x4(%eax),%al
  803348:	84 c0                	test   %al,%al
  80334a:	75 46                	jne    803392 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80334c:	a1 20 40 80 00       	mov    0x804020,%eax
  803351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335a:	89 d0                	mov    %edx,%eax
  80335c:	01 c0                	add    %eax,%eax
  80335e:	01 d0                	add    %edx,%eax
  803360:	c1 e0 03             	shl    $0x3,%eax
  803363:	01 c8                	add    %ecx,%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80336a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803372:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803377:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80337e:	8b 45 08             	mov    0x8(%ebp),%eax
  803381:	01 c8                	add    %ecx,%eax
  803383:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803385:	39 c2                	cmp    %eax,%edx
  803387:	75 09                	jne    803392 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803389:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803390:	eb 12                	jmp    8033a4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803392:	ff 45 e8             	incl   -0x18(%ebp)
  803395:	a1 20 40 80 00       	mov    0x804020,%eax
  80339a:	8b 50 74             	mov    0x74(%eax),%edx
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	39 c2                	cmp    %eax,%edx
  8033a2:	77 88                	ja     80332c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8033a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033a8:	75 14                	jne    8033be <CheckWSWithoutLastIndex+0xfb>
			panic(
  8033aa:	83 ec 04             	sub    $0x4,%esp
  8033ad:	68 e0 3e 80 00       	push   $0x803ee0
  8033b2:	6a 3a                	push   $0x3a
  8033b4:	68 d4 3e 80 00       	push   $0x803ed4
  8033b9:	e8 93 fe ff ff       	call   803251 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8033be:	ff 45 f0             	incl   -0x10(%ebp)
  8033c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033c7:	0f 8c 32 ff ff ff    	jl     8032ff <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033db:	eb 26                	jmp    803403 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8033e2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033eb:	89 d0                	mov    %edx,%eax
  8033ed:	01 c0                	add    %eax,%eax
  8033ef:	01 d0                	add    %edx,%eax
  8033f1:	c1 e0 03             	shl    $0x3,%eax
  8033f4:	01 c8                	add    %ecx,%eax
  8033f6:	8a 40 04             	mov    0x4(%eax),%al
  8033f9:	3c 01                	cmp    $0x1,%al
  8033fb:	75 03                	jne    803400 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033fd:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803400:	ff 45 e0             	incl   -0x20(%ebp)
  803403:	a1 20 40 80 00       	mov    0x804020,%eax
  803408:	8b 50 74             	mov    0x74(%eax),%edx
  80340b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80340e:	39 c2                	cmp    %eax,%edx
  803410:	77 cb                	ja     8033dd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803415:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803418:	74 14                	je     80342e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80341a:	83 ec 04             	sub    $0x4,%esp
  80341d:	68 34 3f 80 00       	push   $0x803f34
  803422:	6a 44                	push   $0x44
  803424:	68 d4 3e 80 00       	push   $0x803ed4
  803429:	e8 23 fe ff ff       	call   803251 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80342e:	90                   	nop
  80342f:	c9                   	leave  
  803430:	c3                   	ret    
  803431:	66 90                	xchg   %ax,%ax
  803433:	90                   	nop

00803434 <__udivdi3>:
  803434:	55                   	push   %ebp
  803435:	57                   	push   %edi
  803436:	56                   	push   %esi
  803437:	53                   	push   %ebx
  803438:	83 ec 1c             	sub    $0x1c,%esp
  80343b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80343f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803443:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803447:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80344b:	89 ca                	mov    %ecx,%edx
  80344d:	89 f8                	mov    %edi,%eax
  80344f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803453:	85 f6                	test   %esi,%esi
  803455:	75 2d                	jne    803484 <__udivdi3+0x50>
  803457:	39 cf                	cmp    %ecx,%edi
  803459:	77 65                	ja     8034c0 <__udivdi3+0x8c>
  80345b:	89 fd                	mov    %edi,%ebp
  80345d:	85 ff                	test   %edi,%edi
  80345f:	75 0b                	jne    80346c <__udivdi3+0x38>
  803461:	b8 01 00 00 00       	mov    $0x1,%eax
  803466:	31 d2                	xor    %edx,%edx
  803468:	f7 f7                	div    %edi
  80346a:	89 c5                	mov    %eax,%ebp
  80346c:	31 d2                	xor    %edx,%edx
  80346e:	89 c8                	mov    %ecx,%eax
  803470:	f7 f5                	div    %ebp
  803472:	89 c1                	mov    %eax,%ecx
  803474:	89 d8                	mov    %ebx,%eax
  803476:	f7 f5                	div    %ebp
  803478:	89 cf                	mov    %ecx,%edi
  80347a:	89 fa                	mov    %edi,%edx
  80347c:	83 c4 1c             	add    $0x1c,%esp
  80347f:	5b                   	pop    %ebx
  803480:	5e                   	pop    %esi
  803481:	5f                   	pop    %edi
  803482:	5d                   	pop    %ebp
  803483:	c3                   	ret    
  803484:	39 ce                	cmp    %ecx,%esi
  803486:	77 28                	ja     8034b0 <__udivdi3+0x7c>
  803488:	0f bd fe             	bsr    %esi,%edi
  80348b:	83 f7 1f             	xor    $0x1f,%edi
  80348e:	75 40                	jne    8034d0 <__udivdi3+0x9c>
  803490:	39 ce                	cmp    %ecx,%esi
  803492:	72 0a                	jb     80349e <__udivdi3+0x6a>
  803494:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803498:	0f 87 9e 00 00 00    	ja     80353c <__udivdi3+0x108>
  80349e:	b8 01 00 00 00       	mov    $0x1,%eax
  8034a3:	89 fa                	mov    %edi,%edx
  8034a5:	83 c4 1c             	add    $0x1c,%esp
  8034a8:	5b                   	pop    %ebx
  8034a9:	5e                   	pop    %esi
  8034aa:	5f                   	pop    %edi
  8034ab:	5d                   	pop    %ebp
  8034ac:	c3                   	ret    
  8034ad:	8d 76 00             	lea    0x0(%esi),%esi
  8034b0:	31 ff                	xor    %edi,%edi
  8034b2:	31 c0                	xor    %eax,%eax
  8034b4:	89 fa                	mov    %edi,%edx
  8034b6:	83 c4 1c             	add    $0x1c,%esp
  8034b9:	5b                   	pop    %ebx
  8034ba:	5e                   	pop    %esi
  8034bb:	5f                   	pop    %edi
  8034bc:	5d                   	pop    %ebp
  8034bd:	c3                   	ret    
  8034be:	66 90                	xchg   %ax,%ax
  8034c0:	89 d8                	mov    %ebx,%eax
  8034c2:	f7 f7                	div    %edi
  8034c4:	31 ff                	xor    %edi,%edi
  8034c6:	89 fa                	mov    %edi,%edx
  8034c8:	83 c4 1c             	add    $0x1c,%esp
  8034cb:	5b                   	pop    %ebx
  8034cc:	5e                   	pop    %esi
  8034cd:	5f                   	pop    %edi
  8034ce:	5d                   	pop    %ebp
  8034cf:	c3                   	ret    
  8034d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034d5:	89 eb                	mov    %ebp,%ebx
  8034d7:	29 fb                	sub    %edi,%ebx
  8034d9:	89 f9                	mov    %edi,%ecx
  8034db:	d3 e6                	shl    %cl,%esi
  8034dd:	89 c5                	mov    %eax,%ebp
  8034df:	88 d9                	mov    %bl,%cl
  8034e1:	d3 ed                	shr    %cl,%ebp
  8034e3:	89 e9                	mov    %ebp,%ecx
  8034e5:	09 f1                	or     %esi,%ecx
  8034e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034eb:	89 f9                	mov    %edi,%ecx
  8034ed:	d3 e0                	shl    %cl,%eax
  8034ef:	89 c5                	mov    %eax,%ebp
  8034f1:	89 d6                	mov    %edx,%esi
  8034f3:	88 d9                	mov    %bl,%cl
  8034f5:	d3 ee                	shr    %cl,%esi
  8034f7:	89 f9                	mov    %edi,%ecx
  8034f9:	d3 e2                	shl    %cl,%edx
  8034fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ff:	88 d9                	mov    %bl,%cl
  803501:	d3 e8                	shr    %cl,%eax
  803503:	09 c2                	or     %eax,%edx
  803505:	89 d0                	mov    %edx,%eax
  803507:	89 f2                	mov    %esi,%edx
  803509:	f7 74 24 0c          	divl   0xc(%esp)
  80350d:	89 d6                	mov    %edx,%esi
  80350f:	89 c3                	mov    %eax,%ebx
  803511:	f7 e5                	mul    %ebp
  803513:	39 d6                	cmp    %edx,%esi
  803515:	72 19                	jb     803530 <__udivdi3+0xfc>
  803517:	74 0b                	je     803524 <__udivdi3+0xf0>
  803519:	89 d8                	mov    %ebx,%eax
  80351b:	31 ff                	xor    %edi,%edi
  80351d:	e9 58 ff ff ff       	jmp    80347a <__udivdi3+0x46>
  803522:	66 90                	xchg   %ax,%ax
  803524:	8b 54 24 08          	mov    0x8(%esp),%edx
  803528:	89 f9                	mov    %edi,%ecx
  80352a:	d3 e2                	shl    %cl,%edx
  80352c:	39 c2                	cmp    %eax,%edx
  80352e:	73 e9                	jae    803519 <__udivdi3+0xe5>
  803530:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803533:	31 ff                	xor    %edi,%edi
  803535:	e9 40 ff ff ff       	jmp    80347a <__udivdi3+0x46>
  80353a:	66 90                	xchg   %ax,%ax
  80353c:	31 c0                	xor    %eax,%eax
  80353e:	e9 37 ff ff ff       	jmp    80347a <__udivdi3+0x46>
  803543:	90                   	nop

00803544 <__umoddi3>:
  803544:	55                   	push   %ebp
  803545:	57                   	push   %edi
  803546:	56                   	push   %esi
  803547:	53                   	push   %ebx
  803548:	83 ec 1c             	sub    $0x1c,%esp
  80354b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80354f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803553:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803557:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80355b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80355f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803563:	89 f3                	mov    %esi,%ebx
  803565:	89 fa                	mov    %edi,%edx
  803567:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80356b:	89 34 24             	mov    %esi,(%esp)
  80356e:	85 c0                	test   %eax,%eax
  803570:	75 1a                	jne    80358c <__umoddi3+0x48>
  803572:	39 f7                	cmp    %esi,%edi
  803574:	0f 86 a2 00 00 00    	jbe    80361c <__umoddi3+0xd8>
  80357a:	89 c8                	mov    %ecx,%eax
  80357c:	89 f2                	mov    %esi,%edx
  80357e:	f7 f7                	div    %edi
  803580:	89 d0                	mov    %edx,%eax
  803582:	31 d2                	xor    %edx,%edx
  803584:	83 c4 1c             	add    $0x1c,%esp
  803587:	5b                   	pop    %ebx
  803588:	5e                   	pop    %esi
  803589:	5f                   	pop    %edi
  80358a:	5d                   	pop    %ebp
  80358b:	c3                   	ret    
  80358c:	39 f0                	cmp    %esi,%eax
  80358e:	0f 87 ac 00 00 00    	ja     803640 <__umoddi3+0xfc>
  803594:	0f bd e8             	bsr    %eax,%ebp
  803597:	83 f5 1f             	xor    $0x1f,%ebp
  80359a:	0f 84 ac 00 00 00    	je     80364c <__umoddi3+0x108>
  8035a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8035a5:	29 ef                	sub    %ebp,%edi
  8035a7:	89 fe                	mov    %edi,%esi
  8035a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035ad:	89 e9                	mov    %ebp,%ecx
  8035af:	d3 e0                	shl    %cl,%eax
  8035b1:	89 d7                	mov    %edx,%edi
  8035b3:	89 f1                	mov    %esi,%ecx
  8035b5:	d3 ef                	shr    %cl,%edi
  8035b7:	09 c7                	or     %eax,%edi
  8035b9:	89 e9                	mov    %ebp,%ecx
  8035bb:	d3 e2                	shl    %cl,%edx
  8035bd:	89 14 24             	mov    %edx,(%esp)
  8035c0:	89 d8                	mov    %ebx,%eax
  8035c2:	d3 e0                	shl    %cl,%eax
  8035c4:	89 c2                	mov    %eax,%edx
  8035c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ca:	d3 e0                	shl    %cl,%eax
  8035cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d4:	89 f1                	mov    %esi,%ecx
  8035d6:	d3 e8                	shr    %cl,%eax
  8035d8:	09 d0                	or     %edx,%eax
  8035da:	d3 eb                	shr    %cl,%ebx
  8035dc:	89 da                	mov    %ebx,%edx
  8035de:	f7 f7                	div    %edi
  8035e0:	89 d3                	mov    %edx,%ebx
  8035e2:	f7 24 24             	mull   (%esp)
  8035e5:	89 c6                	mov    %eax,%esi
  8035e7:	89 d1                	mov    %edx,%ecx
  8035e9:	39 d3                	cmp    %edx,%ebx
  8035eb:	0f 82 87 00 00 00    	jb     803678 <__umoddi3+0x134>
  8035f1:	0f 84 91 00 00 00    	je     803688 <__umoddi3+0x144>
  8035f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035fb:	29 f2                	sub    %esi,%edx
  8035fd:	19 cb                	sbb    %ecx,%ebx
  8035ff:	89 d8                	mov    %ebx,%eax
  803601:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803605:	d3 e0                	shl    %cl,%eax
  803607:	89 e9                	mov    %ebp,%ecx
  803609:	d3 ea                	shr    %cl,%edx
  80360b:	09 d0                	or     %edx,%eax
  80360d:	89 e9                	mov    %ebp,%ecx
  80360f:	d3 eb                	shr    %cl,%ebx
  803611:	89 da                	mov    %ebx,%edx
  803613:	83 c4 1c             	add    $0x1c,%esp
  803616:	5b                   	pop    %ebx
  803617:	5e                   	pop    %esi
  803618:	5f                   	pop    %edi
  803619:	5d                   	pop    %ebp
  80361a:	c3                   	ret    
  80361b:	90                   	nop
  80361c:	89 fd                	mov    %edi,%ebp
  80361e:	85 ff                	test   %edi,%edi
  803620:	75 0b                	jne    80362d <__umoddi3+0xe9>
  803622:	b8 01 00 00 00       	mov    $0x1,%eax
  803627:	31 d2                	xor    %edx,%edx
  803629:	f7 f7                	div    %edi
  80362b:	89 c5                	mov    %eax,%ebp
  80362d:	89 f0                	mov    %esi,%eax
  80362f:	31 d2                	xor    %edx,%edx
  803631:	f7 f5                	div    %ebp
  803633:	89 c8                	mov    %ecx,%eax
  803635:	f7 f5                	div    %ebp
  803637:	89 d0                	mov    %edx,%eax
  803639:	e9 44 ff ff ff       	jmp    803582 <__umoddi3+0x3e>
  80363e:	66 90                	xchg   %ax,%ax
  803640:	89 c8                	mov    %ecx,%eax
  803642:	89 f2                	mov    %esi,%edx
  803644:	83 c4 1c             	add    $0x1c,%esp
  803647:	5b                   	pop    %ebx
  803648:	5e                   	pop    %esi
  803649:	5f                   	pop    %edi
  80364a:	5d                   	pop    %ebp
  80364b:	c3                   	ret    
  80364c:	3b 04 24             	cmp    (%esp),%eax
  80364f:	72 06                	jb     803657 <__umoddi3+0x113>
  803651:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803655:	77 0f                	ja     803666 <__umoddi3+0x122>
  803657:	89 f2                	mov    %esi,%edx
  803659:	29 f9                	sub    %edi,%ecx
  80365b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80365f:	89 14 24             	mov    %edx,(%esp)
  803662:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803666:	8b 44 24 04          	mov    0x4(%esp),%eax
  80366a:	8b 14 24             	mov    (%esp),%edx
  80366d:	83 c4 1c             	add    $0x1c,%esp
  803670:	5b                   	pop    %ebx
  803671:	5e                   	pop    %esi
  803672:	5f                   	pop    %edi
  803673:	5d                   	pop    %ebp
  803674:	c3                   	ret    
  803675:	8d 76 00             	lea    0x0(%esi),%esi
  803678:	2b 04 24             	sub    (%esp),%eax
  80367b:	19 fa                	sbb    %edi,%edx
  80367d:	89 d1                	mov    %edx,%ecx
  80367f:	89 c6                	mov    %eax,%esi
  803681:	e9 71 ff ff ff       	jmp    8035f7 <__umoddi3+0xb3>
  803686:	66 90                	xchg   %ax,%ax
  803688:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80368c:	72 ea                	jb     803678 <__umoddi3+0x134>
  80368e:	89 d9                	mov    %ebx,%ecx
  803690:	e9 62 ff ff ff       	jmp    8035f7 <__umoddi3+0xb3>
