
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
  800045:	68 60 37 80 00       	push   $0x803760
  80004a:	e8 28 14 00 00       	call   801477 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 64 37 80 00       	push   $0x803764
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
  80009a:	68 89 37 80 00       	push   $0x803789
  80009f:	e8 d3 13 00 00       	call   801477 <smalloc>
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
  8000d7:	68 90 37 80 00       	push   $0x803790
  8000dc:	e8 c9 17 00 00       	call   8018aa <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 92 37 80 00       	push   $0x803792
  8000f0:	e8 82 13 00 00       	call   801477 <smalloc>
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
  800127:	68 a0 37 80 00       	push   $0x8037a0
  80012c:	e8 8a 18 00 00       	call   8019bb <sys_create_env>
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
  80015a:	68 aa 37 80 00       	push   $0x8037aa
  80015f:	e8 57 18 00 00       	call   8019bb <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 64 18 00 00       	call   8019d9 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 56 18 00 00       	call   8019d9 <sys_run_env>
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
  80019a:	68 b4 37 80 00       	push   $0x8037b4
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
  8001be:	e8 a7 16 00 00       	call   80186a <sys_cputc>
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
  8001cf:	e8 62 16 00 00       	call   801836 <sys_disable_interrupt>
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
  8001e2:	e8 83 16 00 00       	call   80186a <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 61 16 00 00       	call   801850 <sys_enable_interrupt>
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
  800201:	e8 ab 14 00 00       	call   8016b1 <sys_cgetc>
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
  80021a:	e8 17 16 00 00       	call   801836 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 84 14 00 00       	call   8016b1 <sys_cgetc>
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
  800236:	e8 15 16 00 00       	call   801850 <sys_enable_interrupt>
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
  800250:	e8 d4 17 00 00       	call   801a29 <sys_getenvindex>
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
  8002bb:	e8 76 15 00 00       	call   801836 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 e4 37 80 00       	push   $0x8037e4
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
  8002eb:	68 0c 38 80 00       	push   $0x80380c
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
  80031c:	68 34 38 80 00       	push   $0x803834
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 8c 38 80 00       	push   $0x80388c
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 e4 37 80 00       	push   $0x8037e4
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 f6 14 00 00       	call   801850 <sys_enable_interrupt>

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
  80036d:	e8 83 16 00 00       	call   8019f5 <sys_destroy_env>
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
  80037e:	e8 d8 16 00 00       	call   801a5b <sys_exit_env>
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
  8003cc:	e8 b7 12 00 00       	call   801688 <sys_cputs>
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
  800443:	e8 40 12 00 00       	call   801688 <sys_cputs>
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
  80048d:	e8 a4 13 00 00       	call   801836 <sys_disable_interrupt>
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
  8004ad:	e8 9e 13 00 00       	call   801850 <sys_enable_interrupt>
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
  8004f7:	e8 f0 2f 00 00       	call   8034ec <__udivdi3>
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
  800547:	e8 b0 30 00 00       	call   8035fc <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 b4 3a 80 00       	add    $0x803ab4,%eax
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
  8006a2:	8b 04 85 d8 3a 80 00 	mov    0x803ad8(,%eax,4),%eax
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
  800783:	8b 34 9d 20 39 80 00 	mov    0x803920(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 c5 3a 80 00       	push   $0x803ac5
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
  8007a8:	68 ce 3a 80 00       	push   $0x803ace
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
  8007d5:	be d1 3a 80 00       	mov    $0x803ad1,%esi
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
  8011fb:	68 30 3c 80 00       	push   $0x803c30
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
  8012cb:	e8 fc 04 00 00       	call   8017cc <sys_allocate_chunk>
  8012d0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012d3:	a1 20 41 80 00       	mov    0x804120,%eax
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	50                   	push   %eax
  8012dc:	e8 71 0b 00 00       	call   801e52 <initialize_MemBlocksList>
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
  801309:	68 55 3c 80 00       	push   $0x803c55
  80130e:	6a 33                	push   $0x33
  801310:	68 73 3c 80 00       	push   $0x803c73
  801315:	e8 f1 1f 00 00       	call   80330b <_panic>
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
  801388:	68 80 3c 80 00       	push   $0x803c80
  80138d:	6a 34                	push   $0x34
  80138f:	68 73 3c 80 00       	push   $0x803c73
  801394:	e8 72 1f 00 00       	call   80330b <_panic>
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
  8013e5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013e8:	e8 f7 fd ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013f1:	75 07                	jne    8013fa <malloc+0x18>
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f8:	eb 61                	jmp    80145b <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8013fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801401:	8b 55 08             	mov    0x8(%ebp),%edx
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	01 d0                	add    %edx,%eax
  801409:	48                   	dec    %eax
  80140a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80140d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801410:	ba 00 00 00 00       	mov    $0x0,%edx
  801415:	f7 75 f0             	divl   -0x10(%ebp)
  801418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80141b:	29 d0                	sub    %edx,%eax
  80141d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801420:	e8 75 07 00 00       	call   801b9a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801425:	85 c0                	test   %eax,%eax
  801427:	74 11                	je     80143a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801429:	83 ec 0c             	sub    $0xc,%esp
  80142c:	ff 75 e8             	pushl  -0x18(%ebp)
  80142f:	e8 e0 0d 00 00       	call   802214 <alloc_block_FF>
  801434:	83 c4 10             	add    $0x10,%esp
  801437:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80143a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80143e:	74 16                	je     801456 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	ff 75 f4             	pushl  -0xc(%ebp)
  801446:	e8 3c 0b 00 00       	call   801f87 <insert_sorted_allocList>
  80144b:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80144e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801451:	8b 40 08             	mov    0x8(%eax),%eax
  801454:	eb 05                	jmp    80145b <malloc+0x79>
	}

    return NULL;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801463:	83 ec 04             	sub    $0x4,%esp
  801466:	68 a4 3c 80 00       	push   $0x803ca4
  80146b:	6a 6f                	push   $0x6f
  80146d:	68 73 3c 80 00       	push   $0x803c73
  801472:	e8 94 1e 00 00       	call   80330b <_panic>

00801477 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 38             	sub    $0x38,%esp
  80147d:	8b 45 10             	mov    0x10(%ebp),%eax
  801480:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801483:	e8 5c fd ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801488:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148c:	75 0a                	jne    801498 <smalloc+0x21>
  80148e:	b8 00 00 00 00       	mov    $0x0,%eax
  801493:	e9 8b 00 00 00       	jmp    801523 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801498:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80149f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a5:	01 d0                	add    %edx,%eax
  8014a7:	48                   	dec    %eax
  8014a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b3:	f7 75 f0             	divl   -0x10(%ebp)
  8014b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014b9:	29 d0                	sub    %edx,%eax
  8014bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8014be:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8014c5:	e8 d0 06 00 00       	call   801b9a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	74 11                	je     8014df <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8014ce:	83 ec 0c             	sub    $0xc,%esp
  8014d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8014d4:	e8 3b 0d 00 00       	call   802214 <alloc_block_FF>
  8014d9:	83 c4 10             	add    $0x10,%esp
  8014dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8014df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014e3:	74 39                	je     80151e <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e8:	8b 40 08             	mov    0x8(%eax),%eax
  8014eb:	89 c2                	mov    %eax,%edx
  8014ed:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014f1:	52                   	push   %edx
  8014f2:	50                   	push   %eax
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	ff 75 08             	pushl  0x8(%ebp)
  8014f9:	e8 21 04 00 00       	call   80191f <sys_createSharedObject>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801504:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801508:	74 14                	je     80151e <smalloc+0xa7>
  80150a:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80150e:	74 0e                	je     80151e <smalloc+0xa7>
  801510:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801514:	74 08                	je     80151e <smalloc+0xa7>
			return (void*) mem_block->sva;
  801516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801519:	8b 40 08             	mov    0x8(%eax),%eax
  80151c:	eb 05                	jmp    801523 <smalloc+0xac>
	}
	return NULL;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80152b:	e8 b4 fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801530:	83 ec 08             	sub    $0x8,%esp
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	e8 0b 04 00 00       	call   801949 <sys_getSizeOfSharedObject>
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801544:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801548:	74 76                	je     8015c0 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80154a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801554:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801557:	01 d0                	add    %edx,%eax
  801559:	48                   	dec    %eax
  80155a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80155d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801560:	ba 00 00 00 00       	mov    $0x0,%edx
  801565:	f7 75 ec             	divl   -0x14(%ebp)
  801568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156b:	29 d0                	sub    %edx,%eax
  80156d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801577:	e8 1e 06 00 00       	call   801b9a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 11                	je     801591 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	ff 75 e4             	pushl  -0x1c(%ebp)
  801586:	e8 89 0c 00 00       	call   802214 <alloc_block_FF>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801595:	74 29                	je     8015c0 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 40 08             	mov    0x8(%eax),%eax
  80159d:	83 ec 04             	sub    $0x4,%esp
  8015a0:	50                   	push   %eax
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	ff 75 08             	pushl  0x8(%ebp)
  8015a7:	e8 ba 03 00 00       	call   801966 <sys_getSharedObject>
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8015b2:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8015b6:	74 08                	je     8015c0 <sget+0x9b>
				return (void *)mem_block->sva;
  8015b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bb:	8b 40 08             	mov    0x8(%eax),%eax
  8015be:	eb 05                	jmp    8015c5 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015cd:	e8 12 fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 c8 3c 80 00       	push   $0x803cc8
  8015da:	68 f1 00 00 00       	push   $0xf1
  8015df:	68 73 3c 80 00       	push   $0x803c73
  8015e4:	e8 22 1d 00 00       	call   80330b <_panic>

008015e9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	68 f0 3c 80 00       	push   $0x803cf0
  8015f7:	68 05 01 00 00       	push   $0x105
  8015fc:	68 73 3c 80 00       	push   $0x803c73
  801601:	e8 05 1d 00 00       	call   80330b <_panic>

00801606 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80160c:	83 ec 04             	sub    $0x4,%esp
  80160f:	68 14 3d 80 00       	push   $0x803d14
  801614:	68 10 01 00 00       	push   $0x110
  801619:	68 73 3c 80 00       	push   $0x803c73
  80161e:	e8 e8 1c 00 00       	call   80330b <_panic>

00801623 <shrink>:

}
void shrink(uint32 newSize)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801629:	83 ec 04             	sub    $0x4,%esp
  80162c:	68 14 3d 80 00       	push   $0x803d14
  801631:	68 15 01 00 00       	push   $0x115
  801636:	68 73 3c 80 00       	push   $0x803c73
  80163b:	e8 cb 1c 00 00       	call   80330b <_panic>

00801640 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801646:	83 ec 04             	sub    $0x4,%esp
  801649:	68 14 3d 80 00       	push   $0x803d14
  80164e:	68 1a 01 00 00       	push   $0x11a
  801653:	68 73 3c 80 00       	push   $0x803c73
  801658:	e8 ae 1c 00 00       	call   80330b <_panic>

0080165d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	57                   	push   %edi
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8b 55 0c             	mov    0xc(%ebp),%edx
  80166c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801672:	8b 7d 18             	mov    0x18(%ebp),%edi
  801675:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801678:	cd 30                	int    $0x30
  80167a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	5b                   	pop    %ebx
  801684:	5e                   	pop    %esi
  801685:	5f                   	pop    %edi
  801686:	5d                   	pop    %ebp
  801687:	c3                   	ret    

00801688 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 04             	sub    $0x4,%esp
  80168e:	8b 45 10             	mov    0x10(%ebp),%eax
  801691:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801694:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	52                   	push   %edx
  8016a0:	ff 75 0c             	pushl  0xc(%ebp)
  8016a3:	50                   	push   %eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	e8 b2 ff ff ff       	call   80165d <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	90                   	nop
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 01                	push   $0x1
  8016c0:	e8 98 ff ff ff       	call   80165d <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	52                   	push   %edx
  8016da:	50                   	push   %eax
  8016db:	6a 05                	push   $0x5
  8016dd:	e8 7b ff ff ff       	call   80165d <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
}
  8016e5:	c9                   	leave  
  8016e6:	c3                   	ret    

008016e7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
  8016ea:	56                   	push   %esi
  8016eb:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8016ef:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
  8016fd:	51                   	push   %ecx
  8016fe:	52                   	push   %edx
  8016ff:	50                   	push   %eax
  801700:	6a 06                	push   $0x6
  801702:	e8 56 ff ff ff       	call   80165d <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5e                   	pop    %esi
  80170f:	5d                   	pop    %ebp
  801710:	c3                   	ret    

00801711 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 07                	push   $0x7
  801724:	e8 34 ff ff ff       	call   80165d <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	ff 75 0c             	pushl  0xc(%ebp)
  80173a:	ff 75 08             	pushl  0x8(%ebp)
  80173d:	6a 08                	push   $0x8
  80173f:	e8 19 ff ff ff       	call   80165d <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 09                	push   $0x9
  801758:	e8 00 ff ff ff       	call   80165d <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 0a                	push   $0xa
  801771:	e8 e7 fe ff ff       	call   80165d <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 0b                	push   $0xb
  80178a:	e8 ce fe ff ff       	call   80165d <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	6a 0f                	push   $0xf
  8017a5:	e8 b3 fe ff ff       	call   80165d <syscall>
  8017aa:	83 c4 18             	add    $0x18,%esp
	return;
  8017ad:	90                   	nop
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	6a 10                	push   $0x10
  8017c1:	e8 97 fe ff ff       	call   80165d <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c9:	90                   	nop
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	ff 75 10             	pushl  0x10(%ebp)
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 11                	push   $0x11
  8017de:	e8 7a fe ff ff       	call   80165d <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 0c                	push   $0xc
  8017f8:	e8 60 fe ff ff       	call   80165d <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	ff 75 08             	pushl  0x8(%ebp)
  801810:	6a 0d                	push   $0xd
  801812:	e8 46 fe ff ff       	call   80165d <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 0e                	push   $0xe
  80182b:	e8 2d fe ff ff       	call   80165d <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	90                   	nop
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 13                	push   $0x13
  801845:	e8 13 fe ff ff       	call   80165d <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 14                	push   $0x14
  80185f:	e8 f9 fd ff ff       	call   80165d <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	90                   	nop
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_cputc>:


void
sys_cputc(const char c)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801876:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	50                   	push   %eax
  801883:	6a 15                	push   $0x15
  801885:	e8 d3 fd ff ff       	call   80165d <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	90                   	nop
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 16                	push   $0x16
  80189f:	e8 b9 fd ff ff       	call   80165d <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	90                   	nop
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	50                   	push   %eax
  8018ba:	6a 17                	push   $0x17
  8018bc:	e8 9c fd ff ff       	call   80165d <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	52                   	push   %edx
  8018d6:	50                   	push   %eax
  8018d7:	6a 1a                	push   $0x1a
  8018d9:	e8 7f fd ff ff       	call   80165d <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 18                	push   $0x18
  8018f6:	e8 62 fd ff ff       	call   80165d <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 19                	push   $0x19
  801914:	e8 44 fd ff ff       	call   80165d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80192b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80192e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	51                   	push   %ecx
  801938:	52                   	push   %edx
  801939:	ff 75 0c             	pushl  0xc(%ebp)
  80193c:	50                   	push   %eax
  80193d:	6a 1b                	push   $0x1b
  80193f:	e8 19 fd ff ff       	call   80165d <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 1c                	push   $0x1c
  80195c:	e8 fc fc ff ff       	call   80165d <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801969:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	51                   	push   %ecx
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 1d                	push   $0x1d
  80197b:	e8 dd fc ff ff       	call   80165d <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801988:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	52                   	push   %edx
  801995:	50                   	push   %eax
  801996:	6a 1e                	push   $0x1e
  801998:	e8 c0 fc ff ff       	call   80165d <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 1f                	push   $0x1f
  8019b1:	e8 a7 fc ff ff       	call   80165d <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 14             	pushl  0x14(%ebp)
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	50                   	push   %eax
  8019cd:	6a 20                	push   $0x20
  8019cf:	e8 89 fc ff ff       	call   80165d <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	50                   	push   %eax
  8019e8:	6a 21                	push   $0x21
  8019ea:	e8 6e fc ff ff       	call   80165d <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	50                   	push   %eax
  801a04:	6a 22                	push   $0x22
  801a06:	e8 52 fc ff ff       	call   80165d <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 02                	push   $0x2
  801a1f:	e8 39 fc ff ff       	call   80165d <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 03                	push   $0x3
  801a38:	e8 20 fc ff ff       	call   80165d <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 04                	push   $0x4
  801a51:	e8 07 fc ff ff       	call   80165d <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_exit_env>:


void sys_exit_env(void)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 23                	push   $0x23
  801a6a:	e8 ee fb ff ff       	call   80165d <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	90                   	nop
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a7b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7e:	8d 50 04             	lea    0x4(%eax),%edx
  801a81:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	52                   	push   %edx
  801a8b:	50                   	push   %eax
  801a8c:	6a 24                	push   $0x24
  801a8e:	e8 ca fb ff ff       	call   80165d <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
	return result;
  801a96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a9c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9f:	89 01                	mov    %eax,(%ecx)
  801aa1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	c9                   	leave  
  801aa8:	c2 04 00             	ret    $0x4

00801aab <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	ff 75 10             	pushl  0x10(%ebp)
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	ff 75 08             	pushl  0x8(%ebp)
  801abb:	6a 12                	push   $0x12
  801abd:	e8 9b fb ff ff       	call   80165d <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac5:	90                   	nop
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 25                	push   $0x25
  801ad7:	e8 81 fb ff ff       	call   80165d <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aed:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	50                   	push   %eax
  801afa:	6a 26                	push   $0x26
  801afc:	e8 5c fb ff ff       	call   80165d <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
	return ;
  801b04:	90                   	nop
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <rsttst>:
void rsttst()
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 28                	push   $0x28
  801b16:	e8 42 fb ff ff       	call   80165d <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1e:	90                   	nop
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 04             	sub    $0x4,%esp
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b2d:	8b 55 18             	mov    0x18(%ebp),%edx
  801b30:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b34:	52                   	push   %edx
  801b35:	50                   	push   %eax
  801b36:	ff 75 10             	pushl  0x10(%ebp)
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 27                	push   $0x27
  801b41:	e8 17 fb ff ff       	call   80165d <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return ;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <chktst>:
void chktst(uint32 n)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 29                	push   $0x29
  801b5c:	e8 fc fa ff ff       	call   80165d <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return ;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <inctst>:

void inctst()
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 2a                	push   $0x2a
  801b76:	e8 e2 fa ff ff       	call   80165d <syscall>
  801b7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7e:	90                   	nop
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <gettst>:
uint32 gettst()
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 2b                	push   $0x2b
  801b90:	e8 c8 fa ff ff       	call   80165d <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 2c                	push   $0x2c
  801bac:	e8 ac fa ff ff       	call   80165d <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
  801bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bb7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bbb:	75 07                	jne    801bc4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc2:	eb 05                	jmp    801bc9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 2c                	push   $0x2c
  801bdd:	e8 7b fa ff ff       	call   80165d <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
  801be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801be8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bec:	75 07                	jne    801bf5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf3:	eb 05                	jmp    801bfa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 2c                	push   $0x2c
  801c0e:	e8 4a fa ff ff       	call   80165d <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
  801c16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c19:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c1d:	75 07                	jne    801c26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c24:	eb 05                	jmp    801c2b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 2c                	push   $0x2c
  801c3f:	e8 19 fa ff ff       	call   80165d <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
  801c47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c4a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c4e:	75 07                	jne    801c57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c50:	b8 01 00 00 00       	mov    $0x1,%eax
  801c55:	eb 05                	jmp    801c5c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	ff 75 08             	pushl  0x8(%ebp)
  801c6c:	6a 2d                	push   $0x2d
  801c6e:	e8 ea f9 ff ff       	call   80165d <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
	return ;
  801c76:	90                   	nop
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c7d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c80:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	8b 45 08             	mov    0x8(%ebp),%eax
  801c89:	6a 00                	push   $0x0
  801c8b:	53                   	push   %ebx
  801c8c:	51                   	push   %ecx
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	6a 2e                	push   $0x2e
  801c91:	e8 c7 f9 ff ff       	call   80165d <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	52                   	push   %edx
  801cae:	50                   	push   %eax
  801caf:	6a 2f                	push   $0x2f
  801cb1:	e8 a7 f9 ff ff       	call   80165d <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	68 24 3d 80 00       	push   $0x803d24
  801cc9:	e8 8c e7 ff ff       	call   80045a <cprintf>
  801cce:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cd1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	68 50 3d 80 00       	push   $0x803d50
  801ce0:	e8 75 e7 ff ff       	call   80045a <cprintf>
  801ce5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ce8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cec:	a1 38 41 80 00       	mov    0x804138,%eax
  801cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf4:	eb 56                	jmp    801d4c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cf6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cfa:	74 1c                	je     801d18 <print_mem_block_lists+0x5d>
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	8b 50 08             	mov    0x8(%eax),%edx
  801d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d05:	8b 48 08             	mov    0x8(%eax),%ecx
  801d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0e:	01 c8                	add    %ecx,%eax
  801d10:	39 c2                	cmp    %eax,%edx
  801d12:	73 04                	jae    801d18 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d14:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1b:	8b 50 08             	mov    0x8(%eax),%edx
  801d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d21:	8b 40 0c             	mov    0xc(%eax),%eax
  801d24:	01 c2                	add    %eax,%edx
  801d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d29:	8b 40 08             	mov    0x8(%eax),%eax
  801d2c:	83 ec 04             	sub    $0x4,%esp
  801d2f:	52                   	push   %edx
  801d30:	50                   	push   %eax
  801d31:	68 65 3d 80 00       	push   $0x803d65
  801d36:	e8 1f e7 ff ff       	call   80045a <cprintf>
  801d3b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d44:	a1 40 41 80 00       	mov    0x804140,%eax
  801d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d50:	74 07                	je     801d59 <print_mem_block_lists+0x9e>
  801d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d55:	8b 00                	mov    (%eax),%eax
  801d57:	eb 05                	jmp    801d5e <print_mem_block_lists+0xa3>
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	a3 40 41 80 00       	mov    %eax,0x804140
  801d63:	a1 40 41 80 00       	mov    0x804140,%eax
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	75 8a                	jne    801cf6 <print_mem_block_lists+0x3b>
  801d6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d70:	75 84                	jne    801cf6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d72:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d76:	75 10                	jne    801d88 <print_mem_block_lists+0xcd>
  801d78:	83 ec 0c             	sub    $0xc,%esp
  801d7b:	68 74 3d 80 00       	push   $0x803d74
  801d80:	e8 d5 e6 ff ff       	call   80045a <cprintf>
  801d85:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d8f:	83 ec 0c             	sub    $0xc,%esp
  801d92:	68 98 3d 80 00       	push   $0x803d98
  801d97:	e8 be e6 ff ff       	call   80045a <cprintf>
  801d9c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d9f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801da3:	a1 40 40 80 00       	mov    0x804040,%eax
  801da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dab:	eb 56                	jmp    801e03 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801db1:	74 1c                	je     801dcf <print_mem_block_lists+0x114>
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	8b 50 08             	mov    0x8(%eax),%edx
  801db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbc:	8b 48 08             	mov    0x8(%eax),%ecx
  801dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc5:	01 c8                	add    %ecx,%eax
  801dc7:	39 c2                	cmp    %eax,%edx
  801dc9:	73 04                	jae    801dcf <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dcb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	8b 50 08             	mov    0x8(%eax),%edx
  801dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddb:	01 c2                	add    %eax,%edx
  801ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de0:	8b 40 08             	mov    0x8(%eax),%eax
  801de3:	83 ec 04             	sub    $0x4,%esp
  801de6:	52                   	push   %edx
  801de7:	50                   	push   %eax
  801de8:	68 65 3d 80 00       	push   $0x803d65
  801ded:	e8 68 e6 ff ff       	call   80045a <cprintf>
  801df2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dfb:	a1 48 40 80 00       	mov    0x804048,%eax
  801e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e07:	74 07                	je     801e10 <print_mem_block_lists+0x155>
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	8b 00                	mov    (%eax),%eax
  801e0e:	eb 05                	jmp    801e15 <print_mem_block_lists+0x15a>
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
  801e15:	a3 48 40 80 00       	mov    %eax,0x804048
  801e1a:	a1 48 40 80 00       	mov    0x804048,%eax
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	75 8a                	jne    801dad <print_mem_block_lists+0xf2>
  801e23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e27:	75 84                	jne    801dad <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e29:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e2d:	75 10                	jne    801e3f <print_mem_block_lists+0x184>
  801e2f:	83 ec 0c             	sub    $0xc,%esp
  801e32:	68 b0 3d 80 00       	push   $0x803db0
  801e37:	e8 1e e6 ff ff       	call   80045a <cprintf>
  801e3c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	68 24 3d 80 00       	push   $0x803d24
  801e47:	e8 0e e6 ff ff       	call   80045a <cprintf>
  801e4c:	83 c4 10             	add    $0x10,%esp

}
  801e4f:	90                   	nop
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e58:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e5f:	00 00 00 
  801e62:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e69:	00 00 00 
  801e6c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e73:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e7d:	e9 9e 00 00 00       	jmp    801f20 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e82:	a1 50 40 80 00       	mov    0x804050,%eax
  801e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8a:	c1 e2 04             	shl    $0x4,%edx
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	75 14                	jne    801ea7 <initialize_MemBlocksList+0x55>
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	68 d8 3d 80 00       	push   $0x803dd8
  801e9b:	6a 46                	push   $0x46
  801e9d:	68 fb 3d 80 00       	push   $0x803dfb
  801ea2:	e8 64 14 00 00       	call   80330b <_panic>
  801ea7:	a1 50 40 80 00       	mov    0x804050,%eax
  801eac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eaf:	c1 e2 04             	shl    $0x4,%edx
  801eb2:	01 d0                	add    %edx,%eax
  801eb4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801eba:	89 10                	mov    %edx,(%eax)
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	85 c0                	test   %eax,%eax
  801ec0:	74 18                	je     801eda <initialize_MemBlocksList+0x88>
  801ec2:	a1 48 41 80 00       	mov    0x804148,%eax
  801ec7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ecd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ed0:	c1 e1 04             	shl    $0x4,%ecx
  801ed3:	01 ca                	add    %ecx,%edx
  801ed5:	89 50 04             	mov    %edx,0x4(%eax)
  801ed8:	eb 12                	jmp    801eec <initialize_MemBlocksList+0x9a>
  801eda:	a1 50 40 80 00       	mov    0x804050,%eax
  801edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee2:	c1 e2 04             	shl    $0x4,%edx
  801ee5:	01 d0                	add    %edx,%eax
  801ee7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801eec:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef4:	c1 e2 04             	shl    $0x4,%edx
  801ef7:	01 d0                	add    %edx,%eax
  801ef9:	a3 48 41 80 00       	mov    %eax,0x804148
  801efe:	a1 50 40 80 00       	mov    0x804050,%eax
  801f03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f06:	c1 e2 04             	shl    $0x4,%edx
  801f09:	01 d0                	add    %edx,%eax
  801f0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f12:	a1 54 41 80 00       	mov    0x804154,%eax
  801f17:	40                   	inc    %eax
  801f18:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f1d:	ff 45 f4             	incl   -0xc(%ebp)
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f26:	0f 82 56 ff ff ff    	jb     801e82 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f2c:	90                   	nop
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	8b 00                	mov    (%eax),%eax
  801f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f3d:	eb 19                	jmp    801f58 <find_block+0x29>
	{
		if(va==point->sva)
  801f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f48:	75 05                	jne    801f4f <find_block+0x20>
		   return point;
  801f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4d:	eb 36                	jmp    801f85 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	8b 40 08             	mov    0x8(%eax),%eax
  801f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f58:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f5c:	74 07                	je     801f65 <find_block+0x36>
  801f5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	eb 05                	jmp    801f6a <find_block+0x3b>
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6d:	89 42 08             	mov    %eax,0x8(%edx)
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	85 c0                	test   %eax,%eax
  801f78:	75 c5                	jne    801f3f <find_block+0x10>
  801f7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7e:	75 bf                	jne    801f3f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f85:	c9                   	leave  
  801f86:	c3                   	ret    

00801f87 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f8d:	a1 40 40 80 00       	mov    0x804040,%eax
  801f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f95:	a1 44 40 80 00       	mov    0x804044,%eax
  801f9a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fa3:	74 24                	je     801fc9 <insert_sorted_allocList+0x42>
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	8b 50 08             	mov    0x8(%eax),%edx
  801fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fae:	8b 40 08             	mov    0x8(%eax),%eax
  801fb1:	39 c2                	cmp    %eax,%edx
  801fb3:	76 14                	jbe    801fc9 <insert_sorted_allocList+0x42>
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	8b 50 08             	mov    0x8(%eax),%edx
  801fbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbe:	8b 40 08             	mov    0x8(%eax),%eax
  801fc1:	39 c2                	cmp    %eax,%edx
  801fc3:	0f 82 60 01 00 00    	jb     802129 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fcd:	75 65                	jne    802034 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fd3:	75 14                	jne    801fe9 <insert_sorted_allocList+0x62>
  801fd5:	83 ec 04             	sub    $0x4,%esp
  801fd8:	68 d8 3d 80 00       	push   $0x803dd8
  801fdd:	6a 6b                	push   $0x6b
  801fdf:	68 fb 3d 80 00       	push   $0x803dfb
  801fe4:	e8 22 13 00 00       	call   80330b <_panic>
  801fe9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	89 10                	mov    %edx,(%eax)
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	8b 00                	mov    (%eax),%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	74 0d                	je     80200a <insert_sorted_allocList+0x83>
  801ffd:	a1 40 40 80 00       	mov    0x804040,%eax
  802002:	8b 55 08             	mov    0x8(%ebp),%edx
  802005:	89 50 04             	mov    %edx,0x4(%eax)
  802008:	eb 08                	jmp    802012 <insert_sorted_allocList+0x8b>
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	a3 44 40 80 00       	mov    %eax,0x804044
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	a3 40 40 80 00       	mov    %eax,0x804040
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802024:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802029:	40                   	inc    %eax
  80202a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80202f:	e9 dc 01 00 00       	jmp    802210 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	8b 50 08             	mov    0x8(%eax),%edx
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203d:	8b 40 08             	mov    0x8(%eax),%eax
  802040:	39 c2                	cmp    %eax,%edx
  802042:	77 6c                	ja     8020b0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802044:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802048:	74 06                	je     802050 <insert_sorted_allocList+0xc9>
  80204a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204e:	75 14                	jne    802064 <insert_sorted_allocList+0xdd>
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	68 14 3e 80 00       	push   $0x803e14
  802058:	6a 6f                	push   $0x6f
  80205a:	68 fb 3d 80 00       	push   $0x803dfb
  80205f:	e8 a7 12 00 00       	call   80330b <_panic>
  802064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802067:	8b 50 04             	mov    0x4(%eax),%edx
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	89 50 04             	mov    %edx,0x4(%eax)
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802076:	89 10                	mov    %edx,(%eax)
  802078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207b:	8b 40 04             	mov    0x4(%eax),%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	74 0d                	je     80208f <insert_sorted_allocList+0x108>
  802082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802085:	8b 40 04             	mov    0x4(%eax),%eax
  802088:	8b 55 08             	mov    0x8(%ebp),%edx
  80208b:	89 10                	mov    %edx,(%eax)
  80208d:	eb 08                	jmp    802097 <insert_sorted_allocList+0x110>
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	a3 40 40 80 00       	mov    %eax,0x804040
  802097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209a:	8b 55 08             	mov    0x8(%ebp),%edx
  80209d:	89 50 04             	mov    %edx,0x4(%eax)
  8020a0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a5:	40                   	inc    %eax
  8020a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ab:	e9 60 01 00 00       	jmp    802210 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	8b 50 08             	mov    0x8(%eax),%edx
  8020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	39 c2                	cmp    %eax,%edx
  8020be:	0f 82 4c 01 00 00    	jb     802210 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c8:	75 14                	jne    8020de <insert_sorted_allocList+0x157>
  8020ca:	83 ec 04             	sub    $0x4,%esp
  8020cd:	68 4c 3e 80 00       	push   $0x803e4c
  8020d2:	6a 73                	push   $0x73
  8020d4:	68 fb 3d 80 00       	push   $0x803dfb
  8020d9:	e8 2d 12 00 00       	call   80330b <_panic>
  8020de:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	89 50 04             	mov    %edx,0x4(%eax)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8b 40 04             	mov    0x4(%eax),%eax
  8020f0:	85 c0                	test   %eax,%eax
  8020f2:	74 0c                	je     802100 <insert_sorted_allocList+0x179>
  8020f4:	a1 44 40 80 00       	mov    0x804044,%eax
  8020f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fc:	89 10                	mov    %edx,(%eax)
  8020fe:	eb 08                	jmp    802108 <insert_sorted_allocList+0x181>
  802100:	8b 45 08             	mov    0x8(%ebp),%eax
  802103:	a3 40 40 80 00       	mov    %eax,0x804040
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	a3 44 40 80 00       	mov    %eax,0x804044
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802119:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211e:	40                   	inc    %eax
  80211f:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802124:	e9 e7 00 00 00       	jmp    802210 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802129:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80212f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802136:	a1 40 40 80 00       	mov    0x804040,%eax
  80213b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213e:	e9 9d 00 00 00       	jmp    8021e0 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 00                	mov    (%eax),%eax
  802148:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	8b 50 08             	mov    0x8(%eax),%edx
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	8b 40 08             	mov    0x8(%eax),%eax
  802157:	39 c2                	cmp    %eax,%edx
  802159:	76 7d                	jbe    8021d8 <insert_sorted_allocList+0x251>
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	8b 50 08             	mov    0x8(%eax),%edx
  802161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802164:	8b 40 08             	mov    0x8(%eax),%eax
  802167:	39 c2                	cmp    %eax,%edx
  802169:	73 6d                	jae    8021d8 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80216b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216f:	74 06                	je     802177 <insert_sorted_allocList+0x1f0>
  802171:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802175:	75 14                	jne    80218b <insert_sorted_allocList+0x204>
  802177:	83 ec 04             	sub    $0x4,%esp
  80217a:	68 70 3e 80 00       	push   $0x803e70
  80217f:	6a 7f                	push   $0x7f
  802181:	68 fb 3d 80 00       	push   $0x803dfb
  802186:	e8 80 11 00 00       	call   80330b <_panic>
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 10                	mov    (%eax),%edx
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	89 10                	mov    %edx,(%eax)
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	8b 00                	mov    (%eax),%eax
  80219a:	85 c0                	test   %eax,%eax
  80219c:	74 0b                	je     8021a9 <insert_sorted_allocList+0x222>
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a6:	89 50 04             	mov    %edx,0x4(%eax)
  8021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8021af:	89 10                	mov    %edx,(%eax)
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 00                	mov    (%eax),%eax
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	75 08                	jne    8021cb <insert_sorted_allocList+0x244>
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d0:	40                   	inc    %eax
  8021d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021d6:	eb 39                	jmp    802211 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d8:	a1 48 40 80 00       	mov    0x804048,%eax
  8021dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e4:	74 07                	je     8021ed <insert_sorted_allocList+0x266>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	eb 05                	jmp    8021f2 <insert_sorted_allocList+0x26b>
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f7:	a1 48 40 80 00       	mov    0x804048,%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	0f 85 3f ff ff ff    	jne    802143 <insert_sorted_allocList+0x1bc>
  802204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802208:	0f 85 35 ff ff ff    	jne    802143 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220e:	eb 01                	jmp    802211 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802210:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80221a:	a1 38 41 80 00       	mov    0x804138,%eax
  80221f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802222:	e9 85 01 00 00       	jmp    8023ac <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802227:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222a:	8b 40 0c             	mov    0xc(%eax),%eax
  80222d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802230:	0f 82 6e 01 00 00    	jb     8023a4 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	8b 40 0c             	mov    0xc(%eax),%eax
  80223c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223f:	0f 85 8a 00 00 00    	jne    8022cf <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802249:	75 17                	jne    802262 <alloc_block_FF+0x4e>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 a4 3e 80 00       	push   $0x803ea4
  802253:	68 93 00 00 00       	push   $0x93
  802258:	68 fb 3d 80 00       	push   $0x803dfb
  80225d:	e8 a9 10 00 00       	call   80330b <_panic>
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	85 c0                	test   %eax,%eax
  802269:	74 10                	je     80227b <alloc_block_FF+0x67>
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 00                	mov    (%eax),%eax
  802270:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802273:	8b 52 04             	mov    0x4(%edx),%edx
  802276:	89 50 04             	mov    %edx,0x4(%eax)
  802279:	eb 0b                	jmp    802286 <alloc_block_FF+0x72>
  80227b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227e:	8b 40 04             	mov    0x4(%eax),%eax
  802281:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 40 04             	mov    0x4(%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0f                	je     80229f <alloc_block_FF+0x8b>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 40 04             	mov    0x4(%eax),%eax
  802296:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802299:	8b 12                	mov    (%edx),%edx
  80229b:	89 10                	mov    %edx,(%eax)
  80229d:	eb 0a                	jmp    8022a9 <alloc_block_FF+0x95>
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8022c1:	48                   	dec    %eax
  8022c2:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	e9 10 01 00 00       	jmp    8023df <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d8:	0f 86 c6 00 00 00    	jbe    8023a4 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022de:	a1 48 41 80 00       	mov    0x804148,%eax
  8022e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 50 08             	mov    0x8(%eax),%edx
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f8:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022ff:	75 17                	jne    802318 <alloc_block_FF+0x104>
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	68 a4 3e 80 00       	push   $0x803ea4
  802309:	68 9b 00 00 00       	push   $0x9b
  80230e:	68 fb 3d 80 00       	push   $0x803dfb
  802313:	e8 f3 0f 00 00       	call   80330b <_panic>
  802318:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231b:	8b 00                	mov    (%eax),%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 10                	je     802331 <alloc_block_FF+0x11d>
  802321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802324:	8b 00                	mov    (%eax),%eax
  802326:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802329:	8b 52 04             	mov    0x4(%edx),%edx
  80232c:	89 50 04             	mov    %edx,0x4(%eax)
  80232f:	eb 0b                	jmp    80233c <alloc_block_FF+0x128>
  802331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802334:	8b 40 04             	mov    0x4(%eax),%eax
  802337:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80233c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233f:	8b 40 04             	mov    0x4(%eax),%eax
  802342:	85 c0                	test   %eax,%eax
  802344:	74 0f                	je     802355 <alloc_block_FF+0x141>
  802346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802349:	8b 40 04             	mov    0x4(%eax),%eax
  80234c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234f:	8b 12                	mov    (%edx),%edx
  802351:	89 10                	mov    %edx,(%eax)
  802353:	eb 0a                	jmp    80235f <alloc_block_FF+0x14b>
  802355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	a3 48 41 80 00       	mov    %eax,0x804148
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802372:	a1 54 41 80 00       	mov    0x804154,%eax
  802377:	48                   	dec    %eax
  802378:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 50 08             	mov    0x8(%eax),%edx
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	01 c2                	add    %eax,%edx
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 40 0c             	mov    0xc(%eax),%eax
  802394:	2b 45 08             	sub    0x8(%ebp),%eax
  802397:	89 c2                	mov    %eax,%edx
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	eb 3b                	jmp    8023df <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8023a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b0:	74 07                	je     8023b9 <alloc_block_FF+0x1a5>
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	eb 05                	jmp    8023be <alloc_block_FF+0x1aa>
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023be:	a3 40 41 80 00       	mov    %eax,0x804140
  8023c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	0f 85 57 fe ff ff    	jne    802227 <alloc_block_FF+0x13>
  8023d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d4:	0f 85 4d fe ff ff    	jne    802227 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8023f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f6:	e9 df 00 00 00       	jmp    8024da <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802401:	3b 45 08             	cmp    0x8(%ebp),%eax
  802404:	0f 82 c8 00 00 00    	jb     8024d2 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 40 0c             	mov    0xc(%eax),%eax
  802410:	3b 45 08             	cmp    0x8(%ebp),%eax
  802413:	0f 85 8a 00 00 00    	jne    8024a3 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	75 17                	jne    802436 <alloc_block_BF+0x55>
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	68 a4 3e 80 00       	push   $0x803ea4
  802427:	68 b7 00 00 00       	push   $0xb7
  80242c:	68 fb 3d 80 00       	push   $0x803dfb
  802431:	e8 d5 0e 00 00       	call   80330b <_panic>
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 00                	mov    (%eax),%eax
  80243b:	85 c0                	test   %eax,%eax
  80243d:	74 10                	je     80244f <alloc_block_BF+0x6e>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802447:	8b 52 04             	mov    0x4(%edx),%edx
  80244a:	89 50 04             	mov    %edx,0x4(%eax)
  80244d:	eb 0b                	jmp    80245a <alloc_block_BF+0x79>
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 40 04             	mov    0x4(%eax),%eax
  802455:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 0f                	je     802473 <alloc_block_BF+0x92>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246d:	8b 12                	mov    (%edx),%edx
  80246f:	89 10                	mov    %edx,(%eax)
  802471:	eb 0a                	jmp    80247d <alloc_block_BF+0x9c>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	a3 38 41 80 00       	mov    %eax,0x804138
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802490:	a1 44 41 80 00       	mov    0x804144,%eax
  802495:	48                   	dec    %eax
  802496:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	e9 4d 01 00 00       	jmp    8025f0 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ac:	76 24                	jbe    8024d2 <alloc_block_BF+0xf1>
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024b7:	73 19                	jae    8024d2 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024b9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	8b 40 08             	mov    0x8(%eax),%eax
  8024cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024d2:	a1 40 41 80 00       	mov    0x804140,%eax
  8024d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024de:	74 07                	je     8024e7 <alloc_block_BF+0x106>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	eb 05                	jmp    8024ec <alloc_block_BF+0x10b>
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ec:	a3 40 41 80 00       	mov    %eax,0x804140
  8024f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	0f 85 fd fe ff ff    	jne    8023fb <alloc_block_BF+0x1a>
  8024fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802502:	0f 85 f3 fe ff ff    	jne    8023fb <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802508:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80250c:	0f 84 d9 00 00 00    	je     8025eb <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802512:	a1 48 41 80 00       	mov    0x804148,%eax
  802517:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80251a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802520:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802523:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802526:	8b 55 08             	mov    0x8(%ebp),%edx
  802529:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80252c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802530:	75 17                	jne    802549 <alloc_block_BF+0x168>
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	68 a4 3e 80 00       	push   $0x803ea4
  80253a:	68 c7 00 00 00       	push   $0xc7
  80253f:	68 fb 3d 80 00       	push   $0x803dfb
  802544:	e8 c2 0d 00 00       	call   80330b <_panic>
  802549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 10                	je     802562 <alloc_block_BF+0x181>
  802552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80255a:	8b 52 04             	mov    0x4(%edx),%edx
  80255d:	89 50 04             	mov    %edx,0x4(%eax)
  802560:	eb 0b                	jmp    80256d <alloc_block_BF+0x18c>
  802562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802565:	8b 40 04             	mov    0x4(%eax),%eax
  802568:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80256d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802570:	8b 40 04             	mov    0x4(%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 0f                	je     802586 <alloc_block_BF+0x1a5>
  802577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257a:	8b 40 04             	mov    0x4(%eax),%eax
  80257d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802580:	8b 12                	mov    (%edx),%edx
  802582:	89 10                	mov    %edx,(%eax)
  802584:	eb 0a                	jmp    802590 <alloc_block_BF+0x1af>
  802586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802589:	8b 00                	mov    (%eax),%eax
  80258b:	a3 48 41 80 00       	mov    %eax,0x804148
  802590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8025a8:	48                   	dec    %eax
  8025a9:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025ae:	83 ec 08             	sub    $0x8,%esp
  8025b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8025b4:	68 38 41 80 00       	push   $0x804138
  8025b9:	e8 71 f9 ff ff       	call   801f2f <find_block>
  8025be:	83 c4 10             	add    $0x10,%esp
  8025c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c7:	8b 50 08             	mov    0x8(%eax),%edx
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	01 c2                	add    %eax,%edx
  8025cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d2:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025db:	2b 45 08             	sub    0x8(%ebp),%eax
  8025de:	89 c2                	mov    %eax,%edx
  8025e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e3:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e9:	eb 05                	jmp    8025f0 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025f8:	a1 28 40 80 00       	mov    0x804028,%eax
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	0f 85 de 01 00 00    	jne    8027e3 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802605:	a1 38 41 80 00       	mov    0x804138,%eax
  80260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260d:	e9 9e 01 00 00       	jmp    8027b0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 0c             	mov    0xc(%eax),%eax
  802618:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261b:	0f 82 87 01 00 00    	jb     8027a8 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 40 0c             	mov    0xc(%eax),%eax
  802627:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262a:	0f 85 95 00 00 00    	jne    8026c5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	75 17                	jne    80264d <alloc_block_NF+0x5b>
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	68 a4 3e 80 00       	push   $0x803ea4
  80263e:	68 e0 00 00 00       	push   $0xe0
  802643:	68 fb 3d 80 00       	push   $0x803dfb
  802648:	e8 be 0c 00 00       	call   80330b <_panic>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	74 10                	je     802666 <alloc_block_NF+0x74>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265e:	8b 52 04             	mov    0x4(%edx),%edx
  802661:	89 50 04             	mov    %edx,0x4(%eax)
  802664:	eb 0b                	jmp    802671 <alloc_block_NF+0x7f>
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	74 0f                	je     80268a <alloc_block_NF+0x98>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802684:	8b 12                	mov    (%edx),%edx
  802686:	89 10                	mov    %edx,(%eax)
  802688:	eb 0a                	jmp    802694 <alloc_block_NF+0xa2>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	a3 38 41 80 00       	mov    %eax,0x804138
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a7:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ac:	48                   	dec    %eax
  8026ad:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 08             	mov    0x8(%eax),%eax
  8026b8:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	e9 f8 04 00 00       	jmp    802bbd <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ce:	0f 86 d4 00 00 00    	jbe    8027a8 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d4:	a1 48 41 80 00       	mov    0x804148,%eax
  8026d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 50 08             	mov    0x8(%eax),%edx
  8026e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e5:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ee:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f5:	75 17                	jne    80270e <alloc_block_NF+0x11c>
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	68 a4 3e 80 00       	push   $0x803ea4
  8026ff:	68 e9 00 00 00       	push   $0xe9
  802704:	68 fb 3d 80 00       	push   $0x803dfb
  802709:	e8 fd 0b 00 00       	call   80330b <_panic>
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	74 10                	je     802727 <alloc_block_NF+0x135>
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271f:	8b 52 04             	mov    0x4(%edx),%edx
  802722:	89 50 04             	mov    %edx,0x4(%eax)
  802725:	eb 0b                	jmp    802732 <alloc_block_NF+0x140>
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802732:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802735:	8b 40 04             	mov    0x4(%eax),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 0f                	je     80274b <alloc_block_NF+0x159>
  80273c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802745:	8b 12                	mov    (%edx),%edx
  802747:	89 10                	mov    %edx,(%eax)
  802749:	eb 0a                	jmp    802755 <alloc_block_NF+0x163>
  80274b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	a3 48 41 80 00       	mov    %eax,0x804148
  802755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802758:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802768:	a1 54 41 80 00       	mov    0x804154,%eax
  80276d:	48                   	dec    %eax
  80276e:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 50 08             	mov    0x8(%eax),%edx
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	01 c2                	add    %eax,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 40 0c             	mov    0xc(%eax),%eax
  802795:	2b 45 08             	sub    0x8(%ebp),%eax
  802798:	89 c2                	mov    %eax,%edx
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	e9 15 04 00 00       	jmp    802bbd <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b4:	74 07                	je     8027bd <alloc_block_NF+0x1cb>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	eb 05                	jmp    8027c2 <alloc_block_NF+0x1d0>
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c2:	a3 40 41 80 00       	mov    %eax,0x804140
  8027c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	0f 85 3e fe ff ff    	jne    802612 <alloc_block_NF+0x20>
  8027d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d8:	0f 85 34 fe ff ff    	jne    802612 <alloc_block_NF+0x20>
  8027de:	e9 d5 03 00 00       	jmp    802bb8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027eb:	e9 b1 01 00 00       	jmp    8029a1 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 50 08             	mov    0x8(%eax),%edx
  8027f6:	a1 28 40 80 00       	mov    0x804028,%eax
  8027fb:	39 c2                	cmp    %eax,%edx
  8027fd:	0f 82 96 01 00 00    	jb     802999 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 0c             	mov    0xc(%eax),%eax
  802809:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280c:	0f 82 87 01 00 00    	jb     802999 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	8b 40 0c             	mov    0xc(%eax),%eax
  802818:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281b:	0f 85 95 00 00 00    	jne    8028b6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	75 17                	jne    80283e <alloc_block_NF+0x24c>
  802827:	83 ec 04             	sub    $0x4,%esp
  80282a:	68 a4 3e 80 00       	push   $0x803ea4
  80282f:	68 fc 00 00 00       	push   $0xfc
  802834:	68 fb 3d 80 00       	push   $0x803dfb
  802839:	e8 cd 0a 00 00       	call   80330b <_panic>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	74 10                	je     802857 <alloc_block_NF+0x265>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284f:	8b 52 04             	mov    0x4(%edx),%edx
  802852:	89 50 04             	mov    %edx,0x4(%eax)
  802855:	eb 0b                	jmp    802862 <alloc_block_NF+0x270>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 04             	mov    0x4(%eax),%eax
  80285d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 0f                	je     80287b <alloc_block_NF+0x289>
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802875:	8b 12                	mov    (%edx),%edx
  802877:	89 10                	mov    %edx,(%eax)
  802879:	eb 0a                	jmp    802885 <alloc_block_NF+0x293>
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	a3 38 41 80 00       	mov    %eax,0x804138
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802898:	a1 44 41 80 00       	mov    0x804144,%eax
  80289d:	48                   	dec    %eax
  80289e:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 08             	mov    0x8(%eax),%eax
  8028a9:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	e9 07 03 00 00       	jmp    802bbd <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bf:	0f 86 d4 00 00 00    	jbe    802999 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028c5:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	8b 50 08             	mov    0x8(%eax),%edx
  8028d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028df:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e6:	75 17                	jne    8028ff <alloc_block_NF+0x30d>
  8028e8:	83 ec 04             	sub    $0x4,%esp
  8028eb:	68 a4 3e 80 00       	push   $0x803ea4
  8028f0:	68 04 01 00 00       	push   $0x104
  8028f5:	68 fb 3d 80 00       	push   $0x803dfb
  8028fa:	e8 0c 0a 00 00       	call   80330b <_panic>
  8028ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	85 c0                	test   %eax,%eax
  802906:	74 10                	je     802918 <alloc_block_NF+0x326>
  802908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802910:	8b 52 04             	mov    0x4(%edx),%edx
  802913:	89 50 04             	mov    %edx,0x4(%eax)
  802916:	eb 0b                	jmp    802923 <alloc_block_NF+0x331>
  802918:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802923:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802926:	8b 40 04             	mov    0x4(%eax),%eax
  802929:	85 c0                	test   %eax,%eax
  80292b:	74 0f                	je     80293c <alloc_block_NF+0x34a>
  80292d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802936:	8b 12                	mov    (%edx),%edx
  802938:	89 10                	mov    %edx,(%eax)
  80293a:	eb 0a                	jmp    802946 <alloc_block_NF+0x354>
  80293c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293f:	8b 00                	mov    (%eax),%eax
  802941:	a3 48 41 80 00       	mov    %eax,0x804148
  802946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802952:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802959:	a1 54 41 80 00       	mov    0x804154,%eax
  80295e:	48                   	dec    %eax
  80295f:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	8b 40 08             	mov    0x8(%eax),%eax
  80296a:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 50 08             	mov    0x8(%eax),%edx
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	01 c2                	add    %eax,%edx
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 0c             	mov    0xc(%eax),%eax
  802986:	2b 45 08             	sub    0x8(%ebp),%eax
  802989:	89 c2                	mov    %eax,%edx
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802991:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802994:	e9 24 02 00 00       	jmp    802bbd <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802999:	a1 40 41 80 00       	mov    0x804140,%eax
  80299e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a5:	74 07                	je     8029ae <alloc_block_NF+0x3bc>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	eb 05                	jmp    8029b3 <alloc_block_NF+0x3c1>
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b3:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b8:	a1 40 41 80 00       	mov    0x804140,%eax
  8029bd:	85 c0                	test   %eax,%eax
  8029bf:	0f 85 2b fe ff ff    	jne    8027f0 <alloc_block_NF+0x1fe>
  8029c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c9:	0f 85 21 fe ff ff    	jne    8027f0 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d7:	e9 ae 01 00 00       	jmp    802b8a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 50 08             	mov    0x8(%eax),%edx
  8029e2:	a1 28 40 80 00       	mov    0x804028,%eax
  8029e7:	39 c2                	cmp    %eax,%edx
  8029e9:	0f 83 93 01 00 00    	jae    802b82 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f8:	0f 82 84 01 00 00    	jb     802b82 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 40 0c             	mov    0xc(%eax),%eax
  802a04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a07:	0f 85 95 00 00 00    	jne    802aa2 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a11:	75 17                	jne    802a2a <alloc_block_NF+0x438>
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 a4 3e 80 00       	push   $0x803ea4
  802a1b:	68 14 01 00 00       	push   $0x114
  802a20:	68 fb 3d 80 00       	push   $0x803dfb
  802a25:	e8 e1 08 00 00       	call   80330b <_panic>
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 00                	mov    (%eax),%eax
  802a2f:	85 c0                	test   %eax,%eax
  802a31:	74 10                	je     802a43 <alloc_block_NF+0x451>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3b:	8b 52 04             	mov    0x4(%edx),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 0b                	jmp    802a4e <alloc_block_NF+0x45c>
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	8b 40 04             	mov    0x4(%eax),%eax
  802a49:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0f                	je     802a67 <alloc_block_NF+0x475>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 40 04             	mov    0x4(%eax),%eax
  802a5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a61:	8b 12                	mov    (%edx),%edx
  802a63:	89 10                	mov    %edx,(%eax)
  802a65:	eb 0a                	jmp    802a71 <alloc_block_NF+0x47f>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a84:	a1 44 41 80 00       	mov    0x804144,%eax
  802a89:	48                   	dec    %eax
  802a8a:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 08             	mov    0x8(%eax),%eax
  802a95:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	e9 1b 01 00 00       	jmp    802bbd <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aab:	0f 86 d1 00 00 00    	jbe    802b82 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ab1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ab6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 50 08             	mov    0x8(%eax),%edx
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  802acb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ace:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ad2:	75 17                	jne    802aeb <alloc_block_NF+0x4f9>
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	68 a4 3e 80 00       	push   $0x803ea4
  802adc:	68 1c 01 00 00       	push   $0x11c
  802ae1:	68 fb 3d 80 00       	push   $0x803dfb
  802ae6:	e8 20 08 00 00       	call   80330b <_panic>
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 10                	je     802b04 <alloc_block_NF+0x512>
  802af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afc:	8b 52 04             	mov    0x4(%edx),%edx
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	eb 0b                	jmp    802b0f <alloc_block_NF+0x51d>
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 0f                	je     802b28 <alloc_block_NF+0x536>
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b22:	8b 12                	mov    (%edx),%edx
  802b24:	89 10                	mov    %edx,(%eax)
  802b26:	eb 0a                	jmp    802b32 <alloc_block_NF+0x540>
  802b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b45:	a1 54 41 80 00       	mov    0x804154,%eax
  802b4a:	48                   	dec    %eax
  802b4b:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	8b 40 08             	mov    0x8(%eax),%eax
  802b56:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 50 08             	mov    0x8(%eax),%edx
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	01 c2                	add    %eax,%edx
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b72:	2b 45 08             	sub    0x8(%ebp),%eax
  802b75:	89 c2                	mov    %eax,%edx
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	eb 3b                	jmp    802bbd <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b82:	a1 40 41 80 00       	mov    0x804140,%eax
  802b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	74 07                	je     802b97 <alloc_block_NF+0x5a5>
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	eb 05                	jmp    802b9c <alloc_block_NF+0x5aa>
  802b97:	b8 00 00 00 00       	mov    $0x0,%eax
  802b9c:	a3 40 41 80 00       	mov    %eax,0x804140
  802ba1:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	0f 85 2e fe ff ff    	jne    8029dc <alloc_block_NF+0x3ea>
  802bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb2:	0f 85 24 fe ff ff    	jne    8029dc <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bbd:	c9                   	leave  
  802bbe:	c3                   	ret    

00802bbf <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bbf:	55                   	push   %ebp
  802bc0:	89 e5                	mov    %esp,%ebp
  802bc2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bc5:	a1 38 41 80 00       	mov    0x804138,%eax
  802bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bcd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bd5:	a1 38 41 80 00       	mov    0x804138,%eax
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	74 14                	je     802bf2 <insert_sorted_with_merge_freeList+0x33>
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	8b 50 08             	mov    0x8(%eax),%edx
  802be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be7:	8b 40 08             	mov    0x8(%eax),%eax
  802bea:	39 c2                	cmp    %eax,%edx
  802bec:	0f 87 9b 01 00 00    	ja     802d8d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf6:	75 17                	jne    802c0f <insert_sorted_with_merge_freeList+0x50>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 d8 3d 80 00       	push   $0x803dd8
  802c00:	68 38 01 00 00       	push   $0x138
  802c05:	68 fb 3d 80 00       	push   $0x803dfb
  802c0a:	e8 fc 06 00 00       	call   80330b <_panic>
  802c0f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	89 10                	mov    %edx,(%eax)
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0d                	je     802c30 <insert_sorted_with_merge_freeList+0x71>
  802c23:	a1 38 41 80 00       	mov    0x804138,%eax
  802c28:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2b:	89 50 04             	mov    %edx,0x4(%eax)
  802c2e:	eb 08                	jmp    802c38 <insert_sorted_with_merge_freeList+0x79>
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4f:	40                   	inc    %eax
  802c50:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c59:	0f 84 a8 06 00 00    	je     803307 <insert_sorted_with_merge_freeList+0x748>
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 50 08             	mov    0x8(%eax),%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	01 c2                	add    %eax,%edx
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 40 08             	mov    0x8(%eax),%eax
  802c73:	39 c2                	cmp    %eax,%edx
  802c75:	0f 85 8c 06 00 00    	jne    803307 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c84:	8b 40 0c             	mov    0xc(%eax),%eax
  802c87:	01 c2                	add    %eax,%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c8f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c93:	75 17                	jne    802cac <insert_sorted_with_merge_freeList+0xed>
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	68 a4 3e 80 00       	push   $0x803ea4
  802c9d:	68 3c 01 00 00       	push   $0x13c
  802ca2:	68 fb 3d 80 00       	push   $0x803dfb
  802ca7:	e8 5f 06 00 00       	call   80330b <_panic>
  802cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 10                	je     802cc5 <insert_sorted_with_merge_freeList+0x106>
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbd:	8b 52 04             	mov    0x4(%edx),%edx
  802cc0:	89 50 04             	mov    %edx,0x4(%eax)
  802cc3:	eb 0b                	jmp    802cd0 <insert_sorted_with_merge_freeList+0x111>
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 0f                	je     802ce9 <insert_sorted_with_merge_freeList+0x12a>
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce3:	8b 12                	mov    (%edx),%edx
  802ce5:	89 10                	mov    %edx,(%eax)
  802ce7:	eb 0a                	jmp    802cf3 <insert_sorted_with_merge_freeList+0x134>
  802ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 44 41 80 00       	mov    0x804144,%eax
  802d0b:	48                   	dec    %eax
  802d0c:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d29:	75 17                	jne    802d42 <insert_sorted_with_merge_freeList+0x183>
  802d2b:	83 ec 04             	sub    $0x4,%esp
  802d2e:	68 d8 3d 80 00       	push   $0x803dd8
  802d33:	68 3f 01 00 00       	push   $0x13f
  802d38:	68 fb 3d 80 00       	push   $0x803dfb
  802d3d:	e8 c9 05 00 00       	call   80330b <_panic>
  802d42:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	89 10                	mov    %edx,(%eax)
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 0d                	je     802d63 <insert_sorted_with_merge_freeList+0x1a4>
  802d56:	a1 48 41 80 00       	mov    0x804148,%eax
  802d5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5e:	89 50 04             	mov    %edx,0x4(%eax)
  802d61:	eb 08                	jmp    802d6b <insert_sorted_with_merge_freeList+0x1ac>
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	a3 48 41 80 00       	mov    %eax,0x804148
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7d:	a1 54 41 80 00       	mov    0x804154,%eax
  802d82:	40                   	inc    %eax
  802d83:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d88:	e9 7a 05 00 00       	jmp    803307 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	8b 50 08             	mov    0x8(%eax),%edx
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 40 08             	mov    0x8(%eax),%eax
  802d99:	39 c2                	cmp    %eax,%edx
  802d9b:	0f 82 14 01 00 00    	jb     802eb5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 50 08             	mov    0x8(%eax),%edx
  802da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dad:	01 c2                	add    %eax,%edx
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	8b 40 08             	mov    0x8(%eax),%eax
  802db5:	39 c2                	cmp    %eax,%edx
  802db7:	0f 85 90 00 00 00    	jne    802e4d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	01 c2                	add    %eax,%edx
  802dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dce:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802de5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de9:	75 17                	jne    802e02 <insert_sorted_with_merge_freeList+0x243>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 d8 3d 80 00       	push   $0x803dd8
  802df3:	68 49 01 00 00       	push   $0x149
  802df8:	68 fb 3d 80 00       	push   $0x803dfb
  802dfd:	e8 09 05 00 00       	call   80330b <_panic>
  802e02:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	89 10                	mov    %edx,(%eax)
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 0d                	je     802e23 <insert_sorted_with_merge_freeList+0x264>
  802e16:	a1 48 41 80 00       	mov    0x804148,%eax
  802e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1e:	89 50 04             	mov    %edx,0x4(%eax)
  802e21:	eb 08                	jmp    802e2b <insert_sorted_with_merge_freeList+0x26c>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	a3 48 41 80 00       	mov    %eax,0x804148
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3d:	a1 54 41 80 00       	mov    0x804154,%eax
  802e42:	40                   	inc    %eax
  802e43:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e48:	e9 bb 04 00 00       	jmp    803308 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e51:	75 17                	jne    802e6a <insert_sorted_with_merge_freeList+0x2ab>
  802e53:	83 ec 04             	sub    $0x4,%esp
  802e56:	68 4c 3e 80 00       	push   $0x803e4c
  802e5b:	68 4c 01 00 00       	push   $0x14c
  802e60:	68 fb 3d 80 00       	push   $0x803dfb
  802e65:	e8 a1 04 00 00       	call   80330b <_panic>
  802e6a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	89 50 04             	mov    %edx,0x4(%eax)
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 0c                	je     802e8c <insert_sorted_with_merge_freeList+0x2cd>
  802e80:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e85:	8b 55 08             	mov    0x8(%ebp),%edx
  802e88:	89 10                	mov    %edx,(%eax)
  802e8a:	eb 08                	jmp    802e94 <insert_sorted_with_merge_freeList+0x2d5>
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea5:	a1 44 41 80 00       	mov    0x804144,%eax
  802eaa:	40                   	inc    %eax
  802eab:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eb0:	e9 53 04 00 00       	jmp    803308 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eb5:	a1 38 41 80 00       	mov    0x804138,%eax
  802eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ebd:	e9 15 04 00 00       	jmp    8032d7 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 50 08             	mov    0x8(%eax),%edx
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 08             	mov    0x8(%eax),%eax
  802ed6:	39 c2                	cmp    %eax,%edx
  802ed8:	0f 86 f1 03 00 00    	jbe    8032cf <insert_sorted_with_merge_freeList+0x710>
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 50 08             	mov    0x8(%eax),%edx
  802ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee7:	8b 40 08             	mov    0x8(%eax),%eax
  802eea:	39 c2                	cmp    %eax,%edx
  802eec:	0f 83 dd 03 00 00    	jae    8032cf <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 50 08             	mov    0x8(%eax),%edx
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 0c             	mov    0xc(%eax),%eax
  802efe:	01 c2                	add    %eax,%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 40 08             	mov    0x8(%eax),%eax
  802f06:	39 c2                	cmp    %eax,%edx
  802f08:	0f 85 b9 01 00 00    	jne    8030c7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1a:	01 c2                	add    %eax,%edx
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	8b 40 08             	mov    0x8(%eax),%eax
  802f22:	39 c2                	cmp    %eax,%edx
  802f24:	0f 85 0d 01 00 00    	jne    803037 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f33:	8b 40 0c             	mov    0xc(%eax),%eax
  802f36:	01 c2                	add    %eax,%edx
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f3e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f42:	75 17                	jne    802f5b <insert_sorted_with_merge_freeList+0x39c>
  802f44:	83 ec 04             	sub    $0x4,%esp
  802f47:	68 a4 3e 80 00       	push   $0x803ea4
  802f4c:	68 5c 01 00 00       	push   $0x15c
  802f51:	68 fb 3d 80 00       	push   $0x803dfb
  802f56:	e8 b0 03 00 00       	call   80330b <_panic>
  802f5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 10                	je     802f74 <insert_sorted_with_merge_freeList+0x3b5>
  802f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f6c:	8b 52 04             	mov    0x4(%edx),%edx
  802f6f:	89 50 04             	mov    %edx,0x4(%eax)
  802f72:	eb 0b                	jmp    802f7f <insert_sorted_with_merge_freeList+0x3c0>
  802f74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f77:	8b 40 04             	mov    0x4(%eax),%eax
  802f7a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	74 0f                	je     802f98 <insert_sorted_with_merge_freeList+0x3d9>
  802f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f92:	8b 12                	mov    (%edx),%edx
  802f94:	89 10                	mov    %edx,(%eax)
  802f96:	eb 0a                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x3e3>
  802f98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	a3 38 41 80 00       	mov    %eax,0x804138
  802fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb5:	a1 44 41 80 00       	mov    0x804144,%eax
  802fba:	48                   	dec    %eax
  802fbb:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fd4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd8:	75 17                	jne    802ff1 <insert_sorted_with_merge_freeList+0x432>
  802fda:	83 ec 04             	sub    $0x4,%esp
  802fdd:	68 d8 3d 80 00       	push   $0x803dd8
  802fe2:	68 5f 01 00 00       	push   $0x15f
  802fe7:	68 fb 3d 80 00       	push   $0x803dfb
  802fec:	e8 1a 03 00 00       	call   80330b <_panic>
  802ff1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	89 10                	mov    %edx,(%eax)
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	74 0d                	je     803012 <insert_sorted_with_merge_freeList+0x453>
  803005:	a1 48 41 80 00       	mov    0x804148,%eax
  80300a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300d:	89 50 04             	mov    %edx,0x4(%eax)
  803010:	eb 08                	jmp    80301a <insert_sorted_with_merge_freeList+0x45b>
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	a3 48 41 80 00       	mov    %eax,0x804148
  803022:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803025:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302c:	a1 54 41 80 00       	mov    0x804154,%eax
  803031:	40                   	inc    %eax
  803032:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 50 0c             	mov    0xc(%eax),%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	8b 40 0c             	mov    0xc(%eax),%eax
  803043:	01 c2                	add    %eax,%edx
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803063:	75 17                	jne    80307c <insert_sorted_with_merge_freeList+0x4bd>
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	68 d8 3d 80 00       	push   $0x803dd8
  80306d:	68 64 01 00 00       	push   $0x164
  803072:	68 fb 3d 80 00       	push   $0x803dfb
  803077:	e8 8f 02 00 00       	call   80330b <_panic>
  80307c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 0d                	je     80309d <insert_sorted_with_merge_freeList+0x4de>
  803090:	a1 48 41 80 00       	mov    0x804148,%eax
  803095:	8b 55 08             	mov    0x8(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	eb 08                	jmp    8030a5 <insert_sorted_with_merge_freeList+0x4e6>
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8030bc:	40                   	inc    %eax
  8030bd:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030c2:	e9 41 02 00 00       	jmp    803308 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	8b 50 08             	mov    0x8(%eax),%edx
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d3:	01 c2                	add    %eax,%edx
  8030d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d8:	8b 40 08             	mov    0x8(%eax),%eax
  8030db:	39 c2                	cmp    %eax,%edx
  8030dd:	0f 85 7c 01 00 00    	jne    80325f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e7:	74 06                	je     8030ef <insert_sorted_with_merge_freeList+0x530>
  8030e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ed:	75 17                	jne    803106 <insert_sorted_with_merge_freeList+0x547>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 14 3e 80 00       	push   $0x803e14
  8030f7:	68 69 01 00 00       	push   $0x169
  8030fc:	68 fb 3d 80 00       	push   $0x803dfb
  803101:	e8 05 02 00 00       	call   80330b <_panic>
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 50 04             	mov    0x4(%eax),%edx
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803118:	89 10                	mov    %edx,(%eax)
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0d                	je     803131 <insert_sorted_with_merge_freeList+0x572>
  803124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	8b 55 08             	mov    0x8(%ebp),%edx
  80312d:	89 10                	mov    %edx,(%eax)
  80312f:	eb 08                	jmp    803139 <insert_sorted_with_merge_freeList+0x57a>
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	a3 38 41 80 00       	mov    %eax,0x804138
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 55 08             	mov    0x8(%ebp),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	a1 44 41 80 00       	mov    0x804144,%eax
  803147:	40                   	inc    %eax
  803148:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	8b 50 0c             	mov    0xc(%eax),%edx
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 0c             	mov    0xc(%eax),%eax
  803159:	01 c2                	add    %eax,%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803161:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803165:	75 17                	jne    80317e <insert_sorted_with_merge_freeList+0x5bf>
  803167:	83 ec 04             	sub    $0x4,%esp
  80316a:	68 a4 3e 80 00       	push   $0x803ea4
  80316f:	68 6b 01 00 00       	push   $0x16b
  803174:	68 fb 3d 80 00       	push   $0x803dfb
  803179:	e8 8d 01 00 00       	call   80330b <_panic>
  80317e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803181:	8b 00                	mov    (%eax),%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	74 10                	je     803197 <insert_sorted_with_merge_freeList+0x5d8>
  803187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318f:	8b 52 04             	mov    0x4(%edx),%edx
  803192:	89 50 04             	mov    %edx,0x4(%eax)
  803195:	eb 0b                	jmp    8031a2 <insert_sorted_with_merge_freeList+0x5e3>
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	8b 40 04             	mov    0x4(%eax),%eax
  80319d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	74 0f                	je     8031bb <insert_sorted_with_merge_freeList+0x5fc>
  8031ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031af:	8b 40 04             	mov    0x4(%eax),%eax
  8031b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b5:	8b 12                	mov    (%edx),%edx
  8031b7:	89 10                	mov    %edx,(%eax)
  8031b9:	eb 0a                	jmp    8031c5 <insert_sorted_with_merge_freeList+0x606>
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	8b 00                	mov    (%eax),%eax
  8031c0:	a3 38 41 80 00       	mov    %eax,0x804138
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d8:	a1 44 41 80 00       	mov    0x804144,%eax
  8031dd:	48                   	dec    %eax
  8031de:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031fb:	75 17                	jne    803214 <insert_sorted_with_merge_freeList+0x655>
  8031fd:	83 ec 04             	sub    $0x4,%esp
  803200:	68 d8 3d 80 00       	push   $0x803dd8
  803205:	68 6e 01 00 00       	push   $0x16e
  80320a:	68 fb 3d 80 00       	push   $0x803dfb
  80320f:	e8 f7 00 00 00       	call   80330b <_panic>
  803214:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 0d                	je     803235 <insert_sorted_with_merge_freeList+0x676>
  803228:	a1 48 41 80 00       	mov    0x804148,%eax
  80322d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803230:	89 50 04             	mov    %edx,0x4(%eax)
  803233:	eb 08                	jmp    80323d <insert_sorted_with_merge_freeList+0x67e>
  803235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803238:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	a3 48 41 80 00       	mov    %eax,0x804148
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324f:	a1 54 41 80 00       	mov    0x804154,%eax
  803254:	40                   	inc    %eax
  803255:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80325a:	e9 a9 00 00 00       	jmp    803308 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80325f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803263:	74 06                	je     80326b <insert_sorted_with_merge_freeList+0x6ac>
  803265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803269:	75 17                	jne    803282 <insert_sorted_with_merge_freeList+0x6c3>
  80326b:	83 ec 04             	sub    $0x4,%esp
  80326e:	68 70 3e 80 00       	push   $0x803e70
  803273:	68 73 01 00 00       	push   $0x173
  803278:	68 fb 3d 80 00       	push   $0x803dfb
  80327d:	e8 89 00 00 00       	call   80330b <_panic>
  803282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803285:	8b 10                	mov    (%eax),%edx
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	89 10                	mov    %edx,(%eax)
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	85 c0                	test   %eax,%eax
  803293:	74 0b                	je     8032a0 <insert_sorted_with_merge_freeList+0x6e1>
  803295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803298:	8b 00                	mov    (%eax),%eax
  80329a:	8b 55 08             	mov    0x8(%ebp),%edx
  80329d:	89 50 04             	mov    %edx,0x4(%eax)
  8032a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a6:	89 10                	mov    %edx,(%eax)
  8032a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	8b 00                	mov    (%eax),%eax
  8032b6:	85 c0                	test   %eax,%eax
  8032b8:	75 08                	jne    8032c2 <insert_sorted_with_merge_freeList+0x703>
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032c2:	a1 44 41 80 00       	mov    0x804144,%eax
  8032c7:	40                   	inc    %eax
  8032c8:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032cd:	eb 39                	jmp    803308 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8032d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032db:	74 07                	je     8032e4 <insert_sorted_with_merge_freeList+0x725>
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	eb 05                	jmp    8032e9 <insert_sorted_with_merge_freeList+0x72a>
  8032e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e9:	a3 40 41 80 00       	mov    %eax,0x804140
  8032ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	0f 85 c7 fb ff ff    	jne    802ec2 <insert_sorted_with_merge_freeList+0x303>
  8032fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ff:	0f 85 bd fb ff ff    	jne    802ec2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803305:	eb 01                	jmp    803308 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803307:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803308:	90                   	nop
  803309:	c9                   	leave  
  80330a:	c3                   	ret    

0080330b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80330b:	55                   	push   %ebp
  80330c:	89 e5                	mov    %esp,%ebp
  80330e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803311:	8d 45 10             	lea    0x10(%ebp),%eax
  803314:	83 c0 04             	add    $0x4,%eax
  803317:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80331a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80331f:	85 c0                	test   %eax,%eax
  803321:	74 16                	je     803339 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803323:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803328:	83 ec 08             	sub    $0x8,%esp
  80332b:	50                   	push   %eax
  80332c:	68 c4 3e 80 00       	push   $0x803ec4
  803331:	e8 24 d1 ff ff       	call   80045a <cprintf>
  803336:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803339:	a1 00 40 80 00       	mov    0x804000,%eax
  80333e:	ff 75 0c             	pushl  0xc(%ebp)
  803341:	ff 75 08             	pushl  0x8(%ebp)
  803344:	50                   	push   %eax
  803345:	68 c9 3e 80 00       	push   $0x803ec9
  80334a:	e8 0b d1 ff ff       	call   80045a <cprintf>
  80334f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803352:	8b 45 10             	mov    0x10(%ebp),%eax
  803355:	83 ec 08             	sub    $0x8,%esp
  803358:	ff 75 f4             	pushl  -0xc(%ebp)
  80335b:	50                   	push   %eax
  80335c:	e8 8e d0 ff ff       	call   8003ef <vcprintf>
  803361:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803364:	83 ec 08             	sub    $0x8,%esp
  803367:	6a 00                	push   $0x0
  803369:	68 e5 3e 80 00       	push   $0x803ee5
  80336e:	e8 7c d0 ff ff       	call   8003ef <vcprintf>
  803373:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803376:	e8 fd cf ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  80337b:	eb fe                	jmp    80337b <_panic+0x70>

0080337d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80337d:	55                   	push   %ebp
  80337e:	89 e5                	mov    %esp,%ebp
  803380:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803383:	a1 20 40 80 00       	mov    0x804020,%eax
  803388:	8b 50 74             	mov    0x74(%eax),%edx
  80338b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80338e:	39 c2                	cmp    %eax,%edx
  803390:	74 14                	je     8033a6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	68 e8 3e 80 00       	push   $0x803ee8
  80339a:	6a 26                	push   $0x26
  80339c:	68 34 3f 80 00       	push   $0x803f34
  8033a1:	e8 65 ff ff ff       	call   80330b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8033a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8033ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8033b4:	e9 c2 00 00 00       	jmp    80347b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8033b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c6:	01 d0                	add    %edx,%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	75 08                	jne    8033d6 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8033ce:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8033d1:	e9 a2 00 00 00       	jmp    803478 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8033d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033e4:	eb 69                	jmp    80344f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8033e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8033eb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f4:	89 d0                	mov    %edx,%eax
  8033f6:	01 c0                	add    %eax,%eax
  8033f8:	01 d0                	add    %edx,%eax
  8033fa:	c1 e0 03             	shl    $0x3,%eax
  8033fd:	01 c8                	add    %ecx,%eax
  8033ff:	8a 40 04             	mov    0x4(%eax),%al
  803402:	84 c0                	test   %al,%al
  803404:	75 46                	jne    80344c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803406:	a1 20 40 80 00       	mov    0x804020,%eax
  80340b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803411:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803414:	89 d0                	mov    %edx,%eax
  803416:	01 c0                	add    %eax,%eax
  803418:	01 d0                	add    %edx,%eax
  80341a:	c1 e0 03             	shl    $0x3,%eax
  80341d:	01 c8                	add    %ecx,%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803424:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803427:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80342c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803431:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	01 c8                	add    %ecx,%eax
  80343d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80343f:	39 c2                	cmp    %eax,%edx
  803441:	75 09                	jne    80344c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803443:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80344a:	eb 12                	jmp    80345e <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80344c:	ff 45 e8             	incl   -0x18(%ebp)
  80344f:	a1 20 40 80 00       	mov    0x804020,%eax
  803454:	8b 50 74             	mov    0x74(%eax),%edx
  803457:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345a:	39 c2                	cmp    %eax,%edx
  80345c:	77 88                	ja     8033e6 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80345e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803462:	75 14                	jne    803478 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803464:	83 ec 04             	sub    $0x4,%esp
  803467:	68 40 3f 80 00       	push   $0x803f40
  80346c:	6a 3a                	push   $0x3a
  80346e:	68 34 3f 80 00       	push   $0x803f34
  803473:	e8 93 fe ff ff       	call   80330b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803478:	ff 45 f0             	incl   -0x10(%ebp)
  80347b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803481:	0f 8c 32 ff ff ff    	jl     8033b9 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803487:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80348e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803495:	eb 26                	jmp    8034bd <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803497:	a1 20 40 80 00       	mov    0x804020,%eax
  80349c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8034a5:	89 d0                	mov    %edx,%eax
  8034a7:	01 c0                	add    %eax,%eax
  8034a9:	01 d0                	add    %edx,%eax
  8034ab:	c1 e0 03             	shl    $0x3,%eax
  8034ae:	01 c8                	add    %ecx,%eax
  8034b0:	8a 40 04             	mov    0x4(%eax),%al
  8034b3:	3c 01                	cmp    $0x1,%al
  8034b5:	75 03                	jne    8034ba <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8034b7:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034ba:	ff 45 e0             	incl   -0x20(%ebp)
  8034bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8034c2:	8b 50 74             	mov    0x74(%eax),%edx
  8034c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034c8:	39 c2                	cmp    %eax,%edx
  8034ca:	77 cb                	ja     803497 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034d2:	74 14                	je     8034e8 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8034d4:	83 ec 04             	sub    $0x4,%esp
  8034d7:	68 94 3f 80 00       	push   $0x803f94
  8034dc:	6a 44                	push   $0x44
  8034de:	68 34 3f 80 00       	push   $0x803f34
  8034e3:	e8 23 fe ff ff       	call   80330b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8034e8:	90                   	nop
  8034e9:	c9                   	leave  
  8034ea:	c3                   	ret    
  8034eb:	90                   	nop

008034ec <__udivdi3>:
  8034ec:	55                   	push   %ebp
  8034ed:	57                   	push   %edi
  8034ee:	56                   	push   %esi
  8034ef:	53                   	push   %ebx
  8034f0:	83 ec 1c             	sub    $0x1c,%esp
  8034f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803503:	89 ca                	mov    %ecx,%edx
  803505:	89 f8                	mov    %edi,%eax
  803507:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80350b:	85 f6                	test   %esi,%esi
  80350d:	75 2d                	jne    80353c <__udivdi3+0x50>
  80350f:	39 cf                	cmp    %ecx,%edi
  803511:	77 65                	ja     803578 <__udivdi3+0x8c>
  803513:	89 fd                	mov    %edi,%ebp
  803515:	85 ff                	test   %edi,%edi
  803517:	75 0b                	jne    803524 <__udivdi3+0x38>
  803519:	b8 01 00 00 00       	mov    $0x1,%eax
  80351e:	31 d2                	xor    %edx,%edx
  803520:	f7 f7                	div    %edi
  803522:	89 c5                	mov    %eax,%ebp
  803524:	31 d2                	xor    %edx,%edx
  803526:	89 c8                	mov    %ecx,%eax
  803528:	f7 f5                	div    %ebp
  80352a:	89 c1                	mov    %eax,%ecx
  80352c:	89 d8                	mov    %ebx,%eax
  80352e:	f7 f5                	div    %ebp
  803530:	89 cf                	mov    %ecx,%edi
  803532:	89 fa                	mov    %edi,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	39 ce                	cmp    %ecx,%esi
  80353e:	77 28                	ja     803568 <__udivdi3+0x7c>
  803540:	0f bd fe             	bsr    %esi,%edi
  803543:	83 f7 1f             	xor    $0x1f,%edi
  803546:	75 40                	jne    803588 <__udivdi3+0x9c>
  803548:	39 ce                	cmp    %ecx,%esi
  80354a:	72 0a                	jb     803556 <__udivdi3+0x6a>
  80354c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803550:	0f 87 9e 00 00 00    	ja     8035f4 <__udivdi3+0x108>
  803556:	b8 01 00 00 00       	mov    $0x1,%eax
  80355b:	89 fa                	mov    %edi,%edx
  80355d:	83 c4 1c             	add    $0x1c,%esp
  803560:	5b                   	pop    %ebx
  803561:	5e                   	pop    %esi
  803562:	5f                   	pop    %edi
  803563:	5d                   	pop    %ebp
  803564:	c3                   	ret    
  803565:	8d 76 00             	lea    0x0(%esi),%esi
  803568:	31 ff                	xor    %edi,%edi
  80356a:	31 c0                	xor    %eax,%eax
  80356c:	89 fa                	mov    %edi,%edx
  80356e:	83 c4 1c             	add    $0x1c,%esp
  803571:	5b                   	pop    %ebx
  803572:	5e                   	pop    %esi
  803573:	5f                   	pop    %edi
  803574:	5d                   	pop    %ebp
  803575:	c3                   	ret    
  803576:	66 90                	xchg   %ax,%ax
  803578:	89 d8                	mov    %ebx,%eax
  80357a:	f7 f7                	div    %edi
  80357c:	31 ff                	xor    %edi,%edi
  80357e:	89 fa                	mov    %edi,%edx
  803580:	83 c4 1c             	add    $0x1c,%esp
  803583:	5b                   	pop    %ebx
  803584:	5e                   	pop    %esi
  803585:	5f                   	pop    %edi
  803586:	5d                   	pop    %ebp
  803587:	c3                   	ret    
  803588:	bd 20 00 00 00       	mov    $0x20,%ebp
  80358d:	89 eb                	mov    %ebp,%ebx
  80358f:	29 fb                	sub    %edi,%ebx
  803591:	89 f9                	mov    %edi,%ecx
  803593:	d3 e6                	shl    %cl,%esi
  803595:	89 c5                	mov    %eax,%ebp
  803597:	88 d9                	mov    %bl,%cl
  803599:	d3 ed                	shr    %cl,%ebp
  80359b:	89 e9                	mov    %ebp,%ecx
  80359d:	09 f1                	or     %esi,%ecx
  80359f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035a3:	89 f9                	mov    %edi,%ecx
  8035a5:	d3 e0                	shl    %cl,%eax
  8035a7:	89 c5                	mov    %eax,%ebp
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	88 d9                	mov    %bl,%cl
  8035ad:	d3 ee                	shr    %cl,%esi
  8035af:	89 f9                	mov    %edi,%ecx
  8035b1:	d3 e2                	shl    %cl,%edx
  8035b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b7:	88 d9                	mov    %bl,%cl
  8035b9:	d3 e8                	shr    %cl,%eax
  8035bb:	09 c2                	or     %eax,%edx
  8035bd:	89 d0                	mov    %edx,%eax
  8035bf:	89 f2                	mov    %esi,%edx
  8035c1:	f7 74 24 0c          	divl   0xc(%esp)
  8035c5:	89 d6                	mov    %edx,%esi
  8035c7:	89 c3                	mov    %eax,%ebx
  8035c9:	f7 e5                	mul    %ebp
  8035cb:	39 d6                	cmp    %edx,%esi
  8035cd:	72 19                	jb     8035e8 <__udivdi3+0xfc>
  8035cf:	74 0b                	je     8035dc <__udivdi3+0xf0>
  8035d1:	89 d8                	mov    %ebx,%eax
  8035d3:	31 ff                	xor    %edi,%edi
  8035d5:	e9 58 ff ff ff       	jmp    803532 <__udivdi3+0x46>
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035e0:	89 f9                	mov    %edi,%ecx
  8035e2:	d3 e2                	shl    %cl,%edx
  8035e4:	39 c2                	cmp    %eax,%edx
  8035e6:	73 e9                	jae    8035d1 <__udivdi3+0xe5>
  8035e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035eb:	31 ff                	xor    %edi,%edi
  8035ed:	e9 40 ff ff ff       	jmp    803532 <__udivdi3+0x46>
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	31 c0                	xor    %eax,%eax
  8035f6:	e9 37 ff ff ff       	jmp    803532 <__udivdi3+0x46>
  8035fb:	90                   	nop

008035fc <__umoddi3>:
  8035fc:	55                   	push   %ebp
  8035fd:	57                   	push   %edi
  8035fe:	56                   	push   %esi
  8035ff:	53                   	push   %ebx
  803600:	83 ec 1c             	sub    $0x1c,%esp
  803603:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803607:	8b 74 24 34          	mov    0x34(%esp),%esi
  80360b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803613:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803617:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80361b:	89 f3                	mov    %esi,%ebx
  80361d:	89 fa                	mov    %edi,%edx
  80361f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803623:	89 34 24             	mov    %esi,(%esp)
  803626:	85 c0                	test   %eax,%eax
  803628:	75 1a                	jne    803644 <__umoddi3+0x48>
  80362a:	39 f7                	cmp    %esi,%edi
  80362c:	0f 86 a2 00 00 00    	jbe    8036d4 <__umoddi3+0xd8>
  803632:	89 c8                	mov    %ecx,%eax
  803634:	89 f2                	mov    %esi,%edx
  803636:	f7 f7                	div    %edi
  803638:	89 d0                	mov    %edx,%eax
  80363a:	31 d2                	xor    %edx,%edx
  80363c:	83 c4 1c             	add    $0x1c,%esp
  80363f:	5b                   	pop    %ebx
  803640:	5e                   	pop    %esi
  803641:	5f                   	pop    %edi
  803642:	5d                   	pop    %ebp
  803643:	c3                   	ret    
  803644:	39 f0                	cmp    %esi,%eax
  803646:	0f 87 ac 00 00 00    	ja     8036f8 <__umoddi3+0xfc>
  80364c:	0f bd e8             	bsr    %eax,%ebp
  80364f:	83 f5 1f             	xor    $0x1f,%ebp
  803652:	0f 84 ac 00 00 00    	je     803704 <__umoddi3+0x108>
  803658:	bf 20 00 00 00       	mov    $0x20,%edi
  80365d:	29 ef                	sub    %ebp,%edi
  80365f:	89 fe                	mov    %edi,%esi
  803661:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803665:	89 e9                	mov    %ebp,%ecx
  803667:	d3 e0                	shl    %cl,%eax
  803669:	89 d7                	mov    %edx,%edi
  80366b:	89 f1                	mov    %esi,%ecx
  80366d:	d3 ef                	shr    %cl,%edi
  80366f:	09 c7                	or     %eax,%edi
  803671:	89 e9                	mov    %ebp,%ecx
  803673:	d3 e2                	shl    %cl,%edx
  803675:	89 14 24             	mov    %edx,(%esp)
  803678:	89 d8                	mov    %ebx,%eax
  80367a:	d3 e0                	shl    %cl,%eax
  80367c:	89 c2                	mov    %eax,%edx
  80367e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803682:	d3 e0                	shl    %cl,%eax
  803684:	89 44 24 04          	mov    %eax,0x4(%esp)
  803688:	8b 44 24 08          	mov    0x8(%esp),%eax
  80368c:	89 f1                	mov    %esi,%ecx
  80368e:	d3 e8                	shr    %cl,%eax
  803690:	09 d0                	or     %edx,%eax
  803692:	d3 eb                	shr    %cl,%ebx
  803694:	89 da                	mov    %ebx,%edx
  803696:	f7 f7                	div    %edi
  803698:	89 d3                	mov    %edx,%ebx
  80369a:	f7 24 24             	mull   (%esp)
  80369d:	89 c6                	mov    %eax,%esi
  80369f:	89 d1                	mov    %edx,%ecx
  8036a1:	39 d3                	cmp    %edx,%ebx
  8036a3:	0f 82 87 00 00 00    	jb     803730 <__umoddi3+0x134>
  8036a9:	0f 84 91 00 00 00    	je     803740 <__umoddi3+0x144>
  8036af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036b3:	29 f2                	sub    %esi,%edx
  8036b5:	19 cb                	sbb    %ecx,%ebx
  8036b7:	89 d8                	mov    %ebx,%eax
  8036b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036bd:	d3 e0                	shl    %cl,%eax
  8036bf:	89 e9                	mov    %ebp,%ecx
  8036c1:	d3 ea                	shr    %cl,%edx
  8036c3:	09 d0                	or     %edx,%eax
  8036c5:	89 e9                	mov    %ebp,%ecx
  8036c7:	d3 eb                	shr    %cl,%ebx
  8036c9:	89 da                	mov    %ebx,%edx
  8036cb:	83 c4 1c             	add    $0x1c,%esp
  8036ce:	5b                   	pop    %ebx
  8036cf:	5e                   	pop    %esi
  8036d0:	5f                   	pop    %edi
  8036d1:	5d                   	pop    %ebp
  8036d2:	c3                   	ret    
  8036d3:	90                   	nop
  8036d4:	89 fd                	mov    %edi,%ebp
  8036d6:	85 ff                	test   %edi,%edi
  8036d8:	75 0b                	jne    8036e5 <__umoddi3+0xe9>
  8036da:	b8 01 00 00 00       	mov    $0x1,%eax
  8036df:	31 d2                	xor    %edx,%edx
  8036e1:	f7 f7                	div    %edi
  8036e3:	89 c5                	mov    %eax,%ebp
  8036e5:	89 f0                	mov    %esi,%eax
  8036e7:	31 d2                	xor    %edx,%edx
  8036e9:	f7 f5                	div    %ebp
  8036eb:	89 c8                	mov    %ecx,%eax
  8036ed:	f7 f5                	div    %ebp
  8036ef:	89 d0                	mov    %edx,%eax
  8036f1:	e9 44 ff ff ff       	jmp    80363a <__umoddi3+0x3e>
  8036f6:	66 90                	xchg   %ax,%ax
  8036f8:	89 c8                	mov    %ecx,%eax
  8036fa:	89 f2                	mov    %esi,%edx
  8036fc:	83 c4 1c             	add    $0x1c,%esp
  8036ff:	5b                   	pop    %ebx
  803700:	5e                   	pop    %esi
  803701:	5f                   	pop    %edi
  803702:	5d                   	pop    %ebp
  803703:	c3                   	ret    
  803704:	3b 04 24             	cmp    (%esp),%eax
  803707:	72 06                	jb     80370f <__umoddi3+0x113>
  803709:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80370d:	77 0f                	ja     80371e <__umoddi3+0x122>
  80370f:	89 f2                	mov    %esi,%edx
  803711:	29 f9                	sub    %edi,%ecx
  803713:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803717:	89 14 24             	mov    %edx,(%esp)
  80371a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80371e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803722:	8b 14 24             	mov    (%esp),%edx
  803725:	83 c4 1c             	add    $0x1c,%esp
  803728:	5b                   	pop    %ebx
  803729:	5e                   	pop    %esi
  80372a:	5f                   	pop    %edi
  80372b:	5d                   	pop    %ebp
  80372c:	c3                   	ret    
  80372d:	8d 76 00             	lea    0x0(%esi),%esi
  803730:	2b 04 24             	sub    (%esp),%eax
  803733:	19 fa                	sbb    %edi,%edx
  803735:	89 d1                	mov    %edx,%ecx
  803737:	89 c6                	mov    %eax,%esi
  803739:	e9 71 ff ff ff       	jmp    8036af <__umoddi3+0xb3>
  80373e:	66 90                	xchg   %ax,%ax
  803740:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803744:	72 ea                	jb     803730 <__umoddi3+0x134>
  803746:	89 d9                	mov    %ebx,%ecx
  803748:	e9 62 ff ff ff       	jmp    8036af <__umoddi3+0xb3>
