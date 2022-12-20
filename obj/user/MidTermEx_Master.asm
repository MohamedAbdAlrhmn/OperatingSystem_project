
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
  800045:	68 20 38 80 00       	push   $0x803820
  80004a:	e8 de 14 00 00       	call   80152d <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 24 38 80 00       	push   $0x803824
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
  80009a:	68 49 38 80 00       	push   $0x803849
  80009f:	e8 89 14 00 00       	call   80152d <smalloc>
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
  8000d7:	68 50 38 80 00       	push   $0x803850
  8000dc:	e8 7f 18 00 00       	call   801960 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 52 38 80 00       	push   $0x803852
  8000f0:	e8 38 14 00 00       	call   80152d <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 50 80 00       	mov    0x805020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 60 38 80 00       	push   $0x803860
  80012c:	e8 40 19 00 00       	call   801a71 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 50 80 00       	mov    0x805020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 50 80 00       	mov    0x805020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 6a 38 80 00       	push   $0x80386a
  80015f:	e8 0d 19 00 00       	call   801a71 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 1a 19 00 00       	call   801a8f <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 0c 19 00 00       	call   801a8f <sys_run_env>
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
  80019a:	68 74 38 80 00       	push   $0x803874
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
  8001be:	e8 5d 17 00 00       	call   801920 <sys_cputc>
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
  8001cf:	e8 18 17 00 00       	call   8018ec <sys_disable_interrupt>
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
  8001e2:	e8 39 17 00 00       	call   801920 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 17 17 00 00       	call   801906 <sys_enable_interrupt>
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
  800201:	e8 61 15 00 00       	call   801767 <sys_cgetc>
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
  80021a:	e8 cd 16 00 00       	call   8018ec <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 3a 15 00 00       	call   801767 <sys_cgetc>
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
  800236:	e8 cb 16 00 00       	call   801906 <sys_enable_interrupt>
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
  800250:	e8 8a 18 00 00       	call   801adf <sys_getenvindex>
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
  800277:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 50 80 00       	mov    0x805020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 50 80 00       	mov    0x805020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 2c 16 00 00       	call   8018ec <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 a4 38 80 00       	push   $0x8038a4
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 cc 38 80 00       	push   $0x8038cc
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 50 80 00       	mov    0x805020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 50 80 00       	mov    0x805020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 f4 38 80 00       	push   $0x8038f4
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 50 80 00       	mov    0x805020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 4c 39 80 00       	push   $0x80394c
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 a4 38 80 00       	push   $0x8038a4
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 ac 15 00 00       	call   801906 <sys_enable_interrupt>

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
  80036d:	e8 39 17 00 00       	call   801aab <sys_destroy_env>
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
  80037e:	e8 8e 17 00 00       	call   801b11 <sys_exit_env>
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
  8003b1:	a0 24 50 80 00       	mov    0x805024,%al
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
  8003cc:	e8 6d 13 00 00       	call   80173e <sys_cputs>
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
  800426:	a0 24 50 80 00       	mov    0x805024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 f6 12 00 00       	call   80173e <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
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
  800460:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
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
  80048d:	e8 5a 14 00 00       	call   8018ec <sys_disable_interrupt>
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
  8004ad:	e8 54 14 00 00       	call   801906 <sys_enable_interrupt>
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
  8004f7:	e8 a8 30 00 00       	call   8035a4 <__udivdi3>
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
  800547:	e8 68 31 00 00       	call   8036b4 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 74 3b 80 00       	add    $0x803b74,%eax
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
  8006a2:	8b 04 85 98 3b 80 00 	mov    0x803b98(,%eax,4),%eax
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
  800783:	8b 34 9d e0 39 80 00 	mov    0x8039e0(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 85 3b 80 00       	push   $0x803b85
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
  8007a8:	68 8e 3b 80 00       	push   $0x803b8e
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
  8007d5:	be 91 3b 80 00       	mov    $0x803b91,%esi
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
  8011ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 f0 3c 80 00       	push   $0x803cf0
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
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
  80121b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801222:	00 00 00 
  801225:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  80122c:	00 00 00 
  80122f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801236:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801239:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801240:	00 00 00 
  801243:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80124a:	00 00 00 
  80124d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
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
  801272:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801277:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80127e:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801281:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801288:	a1 20 51 80 00       	mov    0x805120,%eax
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
  8012cb:	e8 b2 05 00 00       	call   801882 <sys_allocate_chunk>
  8012d0:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012d3:	a1 20 51 80 00       	mov    0x805120,%eax
  8012d8:	83 ec 0c             	sub    $0xc,%esp
  8012db:	50                   	push   %eax
  8012dc:	e8 27 0c 00 00       	call   801f08 <initialize_MemBlocksList>
  8012e1:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8012e4:	a1 48 51 80 00       	mov    0x805148,%eax
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
  801309:	68 15 3d 80 00       	push   $0x803d15
  80130e:	6a 33                	push   $0x33
  801310:	68 33 3d 80 00       	push   $0x803d33
  801315:	e8 a7 20 00 00       	call   8033c1 <_panic>
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
  801339:	a3 4c 51 80 00       	mov    %eax,0x80514c
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
  80135c:	a3 48 51 80 00       	mov    %eax,0x805148
  801361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80136a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801374:	a1 54 51 80 00       	mov    0x805154,%eax
  801379:	48                   	dec    %eax
  80137a:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80137f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801383:	75 14                	jne    801399 <initialize_dyn_block_system+0x184>
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 40 3d 80 00       	push   $0x803d40
  80138d:	6a 34                	push   $0x34
  80138f:	68 33 3d 80 00       	push   $0x803d33
  801394:	e8 28 20 00 00       	call   8033c1 <_panic>
  801399:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80139f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a2:	89 10                	mov    %edx,(%eax)
  8013a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a7:	8b 00                	mov    (%eax),%eax
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	74 0d                	je     8013ba <initialize_dyn_block_system+0x1a5>
  8013ad:	a1 38 51 80 00       	mov    0x805138,%eax
  8013b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013b5:	89 50 04             	mov    %edx,0x4(%eax)
  8013b8:	eb 08                	jmp    8013c2 <initialize_dyn_block_system+0x1ad>
  8013ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013bd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8013c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c5:	a3 38 51 80 00       	mov    %eax,0x805138
  8013ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8013d9:	40                   	inc    %eax
  8013da:	a3 44 51 80 00       	mov    %eax,0x805144
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
  801420:	e8 2b 08 00 00       	call   801c50 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801425:	85 c0                	test   %eax,%eax
  801427:	74 11                	je     80143a <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801429:	83 ec 0c             	sub    $0xc,%esp
  80142c:	ff 75 e8             	pushl  -0x18(%ebp)
  80142f:	e8 96 0e 00 00       	call   8022ca <alloc_block_FF>
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
  801446:	e8 f2 0b 00 00       	call   80203d <insert_sorted_allocList>
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
  801460:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	50                   	push   %eax
  80146a:	68 40 50 80 00       	push   $0x805040
  80146f:	e8 71 0b 00 00       	call   801fe5 <find_block>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80147a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80147e:	0f 84 a6 00 00 00    	je     80152a <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801487:	8b 50 0c             	mov    0xc(%eax),%edx
  80148a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148d:	8b 40 08             	mov    0x8(%eax),%eax
  801490:	83 ec 08             	sub    $0x8,%esp
  801493:	52                   	push   %edx
  801494:	50                   	push   %eax
  801495:	e8 b0 03 00 00       	call   80184a <sys_free_user_mem>
  80149a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80149d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014a1:	75 14                	jne    8014b7 <free+0x5a>
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	68 15 3d 80 00       	push   $0x803d15
  8014ab:	6a 74                	push   $0x74
  8014ad:	68 33 3d 80 00       	push   $0x803d33
  8014b2:	e8 0a 1f 00 00       	call   8033c1 <_panic>
  8014b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	74 10                	je     8014d0 <free+0x73>
  8014c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 52 04             	mov    0x4(%edx),%edx
  8014cb:	89 50 04             	mov    %edx,0x4(%eax)
  8014ce:	eb 0b                	jmp    8014db <free+0x7e>
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	8b 40 04             	mov    0x4(%eax),%eax
  8014d6:	a3 44 50 80 00       	mov    %eax,0x805044
  8014db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014de:	8b 40 04             	mov    0x4(%eax),%eax
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	74 0f                	je     8014f4 <free+0x97>
  8014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e8:	8b 40 04             	mov    0x4(%eax),%eax
  8014eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ee:	8b 12                	mov    (%edx),%edx
  8014f0:	89 10                	mov    %edx,(%eax)
  8014f2:	eb 0a                	jmp    8014fe <free+0xa1>
  8014f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	a3 40 50 80 00       	mov    %eax,0x805040
  8014fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801511:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801516:	48                   	dec    %eax
  801517:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	ff 75 f4             	pushl  -0xc(%ebp)
  801522:	e8 4e 17 00 00       	call   802c75 <insert_sorted_with_merge_freeList>
  801527:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80152a:	90                   	nop
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 38             	sub    $0x38,%esp
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801539:	e8 a6 fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  80153e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801542:	75 0a                	jne    80154e <smalloc+0x21>
  801544:	b8 00 00 00 00       	mov    $0x0,%eax
  801549:	e9 8b 00 00 00       	jmp    8015d9 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80154e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801555:	8b 55 0c             	mov    0xc(%ebp),%edx
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	01 d0                	add    %edx,%eax
  80155d:	48                   	dec    %eax
  80155e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801564:	ba 00 00 00 00       	mov    $0x0,%edx
  801569:	f7 75 f0             	divl   -0x10(%ebp)
  80156c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156f:	29 d0                	sub    %edx,%eax
  801571:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801574:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80157b:	e8 d0 06 00 00       	call   801c50 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801580:	85 c0                	test   %eax,%eax
  801582:	74 11                	je     801595 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	ff 75 e8             	pushl  -0x18(%ebp)
  80158a:	e8 3b 0d 00 00       	call   8022ca <alloc_block_FF>
  80158f:	83 c4 10             	add    $0x10,%esp
  801592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801599:	74 39                	je     8015d4 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159e:	8b 40 08             	mov    0x8(%eax),%eax
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015a7:	52                   	push   %edx
  8015a8:	50                   	push   %eax
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	ff 75 08             	pushl  0x8(%ebp)
  8015af:	e8 21 04 00 00       	call   8019d5 <sys_createSharedObject>
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015ba:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015be:	74 14                	je     8015d4 <smalloc+0xa7>
  8015c0:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015c4:	74 0e                	je     8015d4 <smalloc+0xa7>
  8015c6:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015ca:	74 08                	je     8015d4 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cf:	8b 40 08             	mov    0x8(%eax),%eax
  8015d2:	eb 05                	jmp    8015d9 <smalloc+0xac>
	}
	return NULL;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
  8015de:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e1:	e8 fe fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ec:	ff 75 08             	pushl  0x8(%ebp)
  8015ef:	e8 0b 04 00 00       	call   8019ff <sys_getSizeOfSharedObject>
  8015f4:	83 c4 10             	add    $0x10,%esp
  8015f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8015fa:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8015fe:	74 76                	je     801676 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801600:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801607:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160d:	01 d0                	add    %edx,%eax
  80160f:	48                   	dec    %eax
  801610:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801613:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801616:	ba 00 00 00 00       	mov    $0x0,%edx
  80161b:	f7 75 ec             	divl   -0x14(%ebp)
  80161e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801621:	29 d0                	sub    %edx,%eax
  801623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801626:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80162d:	e8 1e 06 00 00       	call   801c50 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801632:	85 c0                	test   %eax,%eax
  801634:	74 11                	je     801647 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163c:	e8 89 0c 00 00       	call   8022ca <alloc_block_FF>
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80164b:	74 29                	je     801676 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801650:	8b 40 08             	mov    0x8(%eax),%eax
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	50                   	push   %eax
  801657:	ff 75 0c             	pushl  0xc(%ebp)
  80165a:	ff 75 08             	pushl  0x8(%ebp)
  80165d:	e8 ba 03 00 00       	call   801a1c <sys_getSharedObject>
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801668:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80166c:	74 08                	je     801676 <sget+0x9b>
				return (void *)mem_block->sva;
  80166e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801671:	8b 40 08             	mov    0x8(%eax),%eax
  801674:	eb 05                	jmp    80167b <sget+0xa0>
		}
	}
	return NULL;
  801676:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
  801680:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801683:	e8 5c fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	68 64 3d 80 00       	push   $0x803d64
  801690:	68 f7 00 00 00       	push   $0xf7
  801695:	68 33 3d 80 00       	push   $0x803d33
  80169a:	e8 22 1d 00 00       	call   8033c1 <_panic>

0080169f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016a5:	83 ec 04             	sub    $0x4,%esp
  8016a8:	68 8c 3d 80 00       	push   $0x803d8c
  8016ad:	68 0c 01 00 00       	push   $0x10c
  8016b2:	68 33 3d 80 00       	push   $0x803d33
  8016b7:	e8 05 1d 00 00       	call   8033c1 <_panic>

008016bc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c2:	83 ec 04             	sub    $0x4,%esp
  8016c5:	68 b0 3d 80 00       	push   $0x803db0
  8016ca:	68 44 01 00 00       	push   $0x144
  8016cf:	68 33 3d 80 00       	push   $0x803d33
  8016d4:	e8 e8 1c 00 00       	call   8033c1 <_panic>

008016d9 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016df:	83 ec 04             	sub    $0x4,%esp
  8016e2:	68 b0 3d 80 00       	push   $0x803db0
  8016e7:	68 49 01 00 00       	push   $0x149
  8016ec:	68 33 3d 80 00       	push   $0x803d33
  8016f1:	e8 cb 1c 00 00       	call   8033c1 <_panic>

008016f6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	68 b0 3d 80 00       	push   $0x803db0
  801704:	68 4e 01 00 00       	push   $0x14e
  801709:	68 33 3d 80 00       	push   $0x803d33
  80170e:	e8 ae 1c 00 00       	call   8033c1 <_panic>

00801713 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	57                   	push   %edi
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
  801719:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801722:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801725:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801728:	8b 7d 18             	mov    0x18(%ebp),%edi
  80172b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80172e:	cd 30                	int    $0x30
  801730:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801733:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	5b                   	pop    %ebx
  80173a:	5e                   	pop    %esi
  80173b:	5f                   	pop    %edi
  80173c:	5d                   	pop    %ebp
  80173d:	c3                   	ret    

0080173e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80174a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	52                   	push   %edx
  801756:	ff 75 0c             	pushl  0xc(%ebp)
  801759:	50                   	push   %eax
  80175a:	6a 00                	push   $0x0
  80175c:	e8 b2 ff ff ff       	call   801713 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	90                   	nop
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_cgetc>:

int
sys_cgetc(void)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 01                	push   $0x1
  801776:	e8 98 ff ff ff       	call   801713 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	52                   	push   %edx
  801790:	50                   	push   %eax
  801791:	6a 05                	push   $0x5
  801793:	e8 7b ff ff ff       	call   801713 <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017a2:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	56                   	push   %esi
  8017b2:	53                   	push   %ebx
  8017b3:	51                   	push   %ecx
  8017b4:	52                   	push   %edx
  8017b5:	50                   	push   %eax
  8017b6:	6a 06                	push   $0x6
  8017b8:	e8 56 ff ff ff       	call   801713 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5e                   	pop    %esi
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 07                	push   $0x7
  8017da:	e8 34 ff ff ff       	call   801713 <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	ff 75 0c             	pushl  0xc(%ebp)
  8017f0:	ff 75 08             	pushl  0x8(%ebp)
  8017f3:	6a 08                	push   $0x8
  8017f5:	e8 19 ff ff ff       	call   801713 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 09                	push   $0x9
  80180e:	e8 00 ff ff ff       	call   801713 <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 0a                	push   $0xa
  801827:	e8 e7 fe ff ff       	call   801713 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 0b                	push   $0xb
  801840:	e8 ce fe ff ff       	call   801713 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 0f                	push   $0xf
  80185b:	e8 b3 fe ff ff       	call   801713 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	ff 75 0c             	pushl  0xc(%ebp)
  801872:	ff 75 08             	pushl  0x8(%ebp)
  801875:	6a 10                	push   $0x10
  801877:	e8 97 fe ff ff       	call   801713 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
	return ;
  80187f:	90                   	nop
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	ff 75 10             	pushl  0x10(%ebp)
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	6a 11                	push   $0x11
  801894:	e8 7a fe ff ff       	call   801713 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
	return ;
  80189c:	90                   	nop
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 0c                	push   $0xc
  8018ae:	e8 60 fe ff ff       	call   801713 <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	6a 0d                	push   $0xd
  8018c8:	e8 46 fe ff ff       	call   801713 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 0e                	push   $0xe
  8018e1:	e8 2d fe ff ff       	call   801713 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	90                   	nop
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 13                	push   $0x13
  8018fb:	e8 13 fe ff ff       	call   801713 <syscall>
  801900:	83 c4 18             	add    $0x18,%esp
}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 14                	push   $0x14
  801915:	e8 f9 fd ff ff       	call   801713 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	90                   	nop
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_cputc>:


void
sys_cputc(const char c)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80192c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	50                   	push   %eax
  801939:	6a 15                	push   $0x15
  80193b:	e8 d3 fd ff ff       	call   801713 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	90                   	nop
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 16                	push   $0x16
  801955:	e8 b9 fd ff ff       	call   801713 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	90                   	nop
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	50                   	push   %eax
  801970:	6a 17                	push   $0x17
  801972:	e8 9c fd ff ff       	call   801713 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	52                   	push   %edx
  80198c:	50                   	push   %eax
  80198d:	6a 1a                	push   $0x1a
  80198f:	e8 7f fd ff ff       	call   801713 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	52                   	push   %edx
  8019a9:	50                   	push   %eax
  8019aa:	6a 18                	push   $0x18
  8019ac:	e8 62 fd ff ff       	call   801713 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	90                   	nop
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	52                   	push   %edx
  8019c7:	50                   	push   %eax
  8019c8:	6a 19                	push   $0x19
  8019ca:	e8 44 fd ff ff       	call   801713 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	8b 45 10             	mov    0x10(%ebp),%eax
  8019de:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	6a 00                	push   $0x0
  8019ed:	51                   	push   %ecx
  8019ee:	52                   	push   %edx
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	50                   	push   %eax
  8019f3:	6a 1b                	push   $0x1b
  8019f5:	e8 19 fd ff ff       	call   801713 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a05:	8b 45 08             	mov    0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	52                   	push   %edx
  801a0f:	50                   	push   %eax
  801a10:	6a 1c                	push   $0x1c
  801a12:	e8 fc fc ff ff       	call   801713 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
}
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	51                   	push   %ecx
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 1d                	push   $0x1d
  801a31:	e8 dd fc ff ff       	call   801713 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	52                   	push   %edx
  801a4b:	50                   	push   %eax
  801a4c:	6a 1e                	push   $0x1e
  801a4e:	e8 c0 fc ff ff       	call   801713 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 1f                	push   $0x1f
  801a67:	e8 a7 fc ff ff       	call   801713 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	ff 75 14             	pushl  0x14(%ebp)
  801a7c:	ff 75 10             	pushl  0x10(%ebp)
  801a7f:	ff 75 0c             	pushl  0xc(%ebp)
  801a82:	50                   	push   %eax
  801a83:	6a 20                	push   $0x20
  801a85:	e8 89 fc ff ff       	call   801713 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	50                   	push   %eax
  801a9e:	6a 21                	push   $0x21
  801aa0:	e8 6e fc ff ff       	call   801713 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	90                   	nop
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aae:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	50                   	push   %eax
  801aba:	6a 22                	push   $0x22
  801abc:	e8 52 fc ff ff       	call   801713 <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 02                	push   $0x2
  801ad5:	e8 39 fc ff ff       	call   801713 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 03                	push   $0x3
  801aee:	e8 20 fc ff ff       	call   801713 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 04                	push   $0x4
  801b07:	e8 07 fc ff ff       	call   801713 <syscall>
  801b0c:	83 c4 18             	add    $0x18,%esp
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_exit_env>:


void sys_exit_env(void)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 23                	push   $0x23
  801b20:	e8 ee fb ff ff       	call   801713 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b34:	8d 50 04             	lea    0x4(%eax),%edx
  801b37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	52                   	push   %edx
  801b41:	50                   	push   %eax
  801b42:	6a 24                	push   $0x24
  801b44:	e8 ca fb ff ff       	call   801713 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return result;
  801b4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b55:	89 01                	mov    %eax,(%ecx)
  801b57:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	c9                   	leave  
  801b5e:	c2 04 00             	ret    $0x4

00801b61 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 10             	pushl  0x10(%ebp)
  801b6b:	ff 75 0c             	pushl  0xc(%ebp)
  801b6e:	ff 75 08             	pushl  0x8(%ebp)
  801b71:	6a 12                	push   $0x12
  801b73:	e8 9b fb ff ff       	call   801713 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_rcr2>:
uint32 sys_rcr2()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 25                	push   $0x25
  801b8d:	e8 81 fb ff ff       	call   801713 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 04             	sub    $0x4,%esp
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	50                   	push   %eax
  801bb0:	6a 26                	push   $0x26
  801bb2:	e8 5c fb ff ff       	call   801713 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bba:	90                   	nop
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <rsttst>:
void rsttst()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 28                	push   $0x28
  801bcc:	e8 42 fb ff ff       	call   801713 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	8b 45 14             	mov    0x14(%ebp),%eax
  801be0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be3:	8b 55 18             	mov    0x18(%ebp),%edx
  801be6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bea:	52                   	push   %edx
  801beb:	50                   	push   %eax
  801bec:	ff 75 10             	pushl  0x10(%ebp)
  801bef:	ff 75 0c             	pushl  0xc(%ebp)
  801bf2:	ff 75 08             	pushl  0x8(%ebp)
  801bf5:	6a 27                	push   $0x27
  801bf7:	e8 17 fb ff ff       	call   801713 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bff:	90                   	nop
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <chktst>:
void chktst(uint32 n)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	6a 29                	push   $0x29
  801c12:	e8 fc fa ff ff       	call   801713 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <inctst>:

void inctst()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 2a                	push   $0x2a
  801c2c:	e8 e2 fa ff ff       	call   801713 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <gettst>:
uint32 gettst()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 2b                	push   $0x2b
  801c46:	e8 c8 fa ff ff       	call   801713 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 2c                	push   $0x2c
  801c62:	e8 ac fa ff ff       	call   801713 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
  801c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c6d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c71:	75 07                	jne    801c7a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
  801c78:	eb 05                	jmp    801c7f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 2c                	push   $0x2c
  801c93:	e8 7b fa ff ff       	call   801713 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
  801c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c9e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca2:	75 07                	jne    801cab <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ca4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca9:	eb 05                	jmp    801cb0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 2c                	push   $0x2c
  801cc4:	e8 4a fa ff ff       	call   801713 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
  801ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ccf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd3:	75 07                	jne    801cdc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cda:	eb 05                	jmp    801ce1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 2c                	push   $0x2c
  801cf5:	e8 19 fa ff ff       	call   801713 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
  801cfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d00:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d04:	75 07                	jne    801d0d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	eb 05                	jmp    801d12 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 08             	pushl  0x8(%ebp)
  801d22:	6a 2d                	push   $0x2d
  801d24:	e8 ea f9 ff ff       	call   801713 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2c:	90                   	nop
}
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d33:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d36:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	53                   	push   %ebx
  801d42:	51                   	push   %ecx
  801d43:	52                   	push   %edx
  801d44:	50                   	push   %eax
  801d45:	6a 2e                	push   $0x2e
  801d47:	e8 c7 f9 ff ff       	call   801713 <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	52                   	push   %edx
  801d64:	50                   	push   %eax
  801d65:	6a 2f                	push   $0x2f
  801d67:	e8 a7 f9 ff ff       	call   801713 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	68 c0 3d 80 00       	push   $0x803dc0
  801d7f:	e8 d6 e6 ff ff       	call   80045a <cprintf>
  801d84:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d87:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d8e:	83 ec 0c             	sub    $0xc,%esp
  801d91:	68 ec 3d 80 00       	push   $0x803dec
  801d96:	e8 bf e6 ff ff       	call   80045a <cprintf>
  801d9b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d9e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801da2:	a1 38 51 80 00       	mov    0x805138,%eax
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801daa:	eb 56                	jmp    801e02 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801db0:	74 1c                	je     801dce <print_mem_block_lists+0x5d>
  801db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db5:	8b 50 08             	mov    0x8(%eax),%edx
  801db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbb:	8b 48 08             	mov    0x8(%eax),%ecx
  801dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc4:	01 c8                	add    %ecx,%eax
  801dc6:	39 c2                	cmp    %eax,%edx
  801dc8:	73 04                	jae    801dce <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dca:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	8b 50 08             	mov    0x8(%eax),%edx
  801dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  801dda:	01 c2                	add    %eax,%edx
  801ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddf:	8b 40 08             	mov    0x8(%eax),%eax
  801de2:	83 ec 04             	sub    $0x4,%esp
  801de5:	52                   	push   %edx
  801de6:	50                   	push   %eax
  801de7:	68 01 3e 80 00       	push   $0x803e01
  801dec:	e8 69 e6 ff ff       	call   80045a <cprintf>
  801df1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dfa:	a1 40 51 80 00       	mov    0x805140,%eax
  801dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e06:	74 07                	je     801e0f <print_mem_block_lists+0x9e>
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 00                	mov    (%eax),%eax
  801e0d:	eb 05                	jmp    801e14 <print_mem_block_lists+0xa3>
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e14:	a3 40 51 80 00       	mov    %eax,0x805140
  801e19:	a1 40 51 80 00       	mov    0x805140,%eax
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	75 8a                	jne    801dac <print_mem_block_lists+0x3b>
  801e22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e26:	75 84                	jne    801dac <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e28:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e2c:	75 10                	jne    801e3e <print_mem_block_lists+0xcd>
  801e2e:	83 ec 0c             	sub    $0xc,%esp
  801e31:	68 10 3e 80 00       	push   $0x803e10
  801e36:	e8 1f e6 ff ff       	call   80045a <cprintf>
  801e3b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e3e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e45:	83 ec 0c             	sub    $0xc,%esp
  801e48:	68 34 3e 80 00       	push   $0x803e34
  801e4d:	e8 08 e6 ff ff       	call   80045a <cprintf>
  801e52:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e55:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e59:	a1 40 50 80 00       	mov    0x805040,%eax
  801e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e61:	eb 56                	jmp    801eb9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e67:	74 1c                	je     801e85 <print_mem_block_lists+0x114>
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	8b 50 08             	mov    0x8(%eax),%edx
  801e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e72:	8b 48 08             	mov    0x8(%eax),%ecx
  801e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e78:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7b:	01 c8                	add    %ecx,%eax
  801e7d:	39 c2                	cmp    %eax,%edx
  801e7f:	73 04                	jae    801e85 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e81:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	8b 50 08             	mov    0x8(%eax),%edx
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e91:	01 c2                	add    %eax,%edx
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	8b 40 08             	mov    0x8(%eax),%eax
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	52                   	push   %edx
  801e9d:	50                   	push   %eax
  801e9e:	68 01 3e 80 00       	push   $0x803e01
  801ea3:	e8 b2 e5 ff ff       	call   80045a <cprintf>
  801ea8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eb1:	a1 48 50 80 00       	mov    0x805048,%eax
  801eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebd:	74 07                	je     801ec6 <print_mem_block_lists+0x155>
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	8b 00                	mov    (%eax),%eax
  801ec4:	eb 05                	jmp    801ecb <print_mem_block_lists+0x15a>
  801ec6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecb:	a3 48 50 80 00       	mov    %eax,0x805048
  801ed0:	a1 48 50 80 00       	mov    0x805048,%eax
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	75 8a                	jne    801e63 <print_mem_block_lists+0xf2>
  801ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edd:	75 84                	jne    801e63 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801edf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ee3:	75 10                	jne    801ef5 <print_mem_block_lists+0x184>
  801ee5:	83 ec 0c             	sub    $0xc,%esp
  801ee8:	68 4c 3e 80 00       	push   $0x803e4c
  801eed:	e8 68 e5 ff ff       	call   80045a <cprintf>
  801ef2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	68 c0 3d 80 00       	push   $0x803dc0
  801efd:	e8 58 e5 ff ff       	call   80045a <cprintf>
  801f02:	83 c4 10             	add    $0x10,%esp

}
  801f05:	90                   	nop
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f0e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f15:	00 00 00 
  801f18:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f1f:	00 00 00 
  801f22:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f29:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f33:	e9 9e 00 00 00       	jmp    801fd6 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f38:	a1 50 50 80 00       	mov    0x805050,%eax
  801f3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f40:	c1 e2 04             	shl    $0x4,%edx
  801f43:	01 d0                	add    %edx,%eax
  801f45:	85 c0                	test   %eax,%eax
  801f47:	75 14                	jne    801f5d <initialize_MemBlocksList+0x55>
  801f49:	83 ec 04             	sub    $0x4,%esp
  801f4c:	68 74 3e 80 00       	push   $0x803e74
  801f51:	6a 46                	push   $0x46
  801f53:	68 97 3e 80 00       	push   $0x803e97
  801f58:	e8 64 14 00 00       	call   8033c1 <_panic>
  801f5d:	a1 50 50 80 00       	mov    0x805050,%eax
  801f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f65:	c1 e2 04             	shl    $0x4,%edx
  801f68:	01 d0                	add    %edx,%eax
  801f6a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f70:	89 10                	mov    %edx,(%eax)
  801f72:	8b 00                	mov    (%eax),%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	74 18                	je     801f90 <initialize_MemBlocksList+0x88>
  801f78:	a1 48 51 80 00       	mov    0x805148,%eax
  801f7d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f83:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f86:	c1 e1 04             	shl    $0x4,%ecx
  801f89:	01 ca                	add    %ecx,%edx
  801f8b:	89 50 04             	mov    %edx,0x4(%eax)
  801f8e:	eb 12                	jmp    801fa2 <initialize_MemBlocksList+0x9a>
  801f90:	a1 50 50 80 00       	mov    0x805050,%eax
  801f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f98:	c1 e2 04             	shl    $0x4,%edx
  801f9b:	01 d0                	add    %edx,%eax
  801f9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fa2:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801faa:	c1 e2 04             	shl    $0x4,%edx
  801fad:	01 d0                	add    %edx,%eax
  801faf:	a3 48 51 80 00       	mov    %eax,0x805148
  801fb4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbc:	c1 e2 04             	shl    $0x4,%edx
  801fbf:	01 d0                	add    %edx,%eax
  801fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc8:	a1 54 51 80 00       	mov    0x805154,%eax
  801fcd:	40                   	inc    %eax
  801fce:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fd3:	ff 45 f4             	incl   -0xc(%ebp)
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fdc:	0f 82 56 ff ff ff    	jb     801f38 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fe2:	90                   	nop
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	8b 00                	mov    (%eax),%eax
  801ff0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ff3:	eb 19                	jmp    80200e <find_block+0x29>
	{
		if(va==point->sva)
  801ff5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff8:	8b 40 08             	mov    0x8(%eax),%eax
  801ffb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ffe:	75 05                	jne    802005 <find_block+0x20>
		   return point;
  802000:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802003:	eb 36                	jmp    80203b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	8b 40 08             	mov    0x8(%eax),%eax
  80200b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80200e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802012:	74 07                	je     80201b <find_block+0x36>
  802014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802017:	8b 00                	mov    (%eax),%eax
  802019:	eb 05                	jmp    802020 <find_block+0x3b>
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
  802020:	8b 55 08             	mov    0x8(%ebp),%edx
  802023:	89 42 08             	mov    %eax,0x8(%edx)
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8b 40 08             	mov    0x8(%eax),%eax
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 c5                	jne    801ff5 <find_block+0x10>
  802030:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802034:	75 bf                	jne    801ff5 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802043:	a1 40 50 80 00       	mov    0x805040,%eax
  802048:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80204b:	a1 44 50 80 00       	mov    0x805044,%eax
  802050:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802053:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802056:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802059:	74 24                	je     80207f <insert_sorted_allocList+0x42>
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	8b 50 08             	mov    0x8(%eax),%edx
  802061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802064:	8b 40 08             	mov    0x8(%eax),%eax
  802067:	39 c2                	cmp    %eax,%edx
  802069:	76 14                	jbe    80207f <insert_sorted_allocList+0x42>
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8b 50 08             	mov    0x8(%eax),%edx
  802071:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802074:	8b 40 08             	mov    0x8(%eax),%eax
  802077:	39 c2                	cmp    %eax,%edx
  802079:	0f 82 60 01 00 00    	jb     8021df <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80207f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802083:	75 65                	jne    8020ea <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802089:	75 14                	jne    80209f <insert_sorted_allocList+0x62>
  80208b:	83 ec 04             	sub    $0x4,%esp
  80208e:	68 74 3e 80 00       	push   $0x803e74
  802093:	6a 6b                	push   $0x6b
  802095:	68 97 3e 80 00       	push   $0x803e97
  80209a:	e8 22 13 00 00       	call   8033c1 <_panic>
  80209f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	89 10                	mov    %edx,(%eax)
  8020aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ad:	8b 00                	mov    (%eax),%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	74 0d                	je     8020c0 <insert_sorted_allocList+0x83>
  8020b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020bb:	89 50 04             	mov    %edx,0x4(%eax)
  8020be:	eb 08                	jmp    8020c8 <insert_sorted_allocList+0x8b>
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	a3 44 50 80 00       	mov    %eax,0x805044
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	a3 40 50 80 00       	mov    %eax,0x805040
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020da:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020df:	40                   	inc    %eax
  8020e0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e5:	e9 dc 01 00 00       	jmp    8022c6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8b 50 08             	mov    0x8(%eax),%edx
  8020f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f3:	8b 40 08             	mov    0x8(%eax),%eax
  8020f6:	39 c2                	cmp    %eax,%edx
  8020f8:	77 6c                	ja     802166 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fe:	74 06                	je     802106 <insert_sorted_allocList+0xc9>
  802100:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802104:	75 14                	jne    80211a <insert_sorted_allocList+0xdd>
  802106:	83 ec 04             	sub    $0x4,%esp
  802109:	68 b0 3e 80 00       	push   $0x803eb0
  80210e:	6a 6f                	push   $0x6f
  802110:	68 97 3e 80 00       	push   $0x803e97
  802115:	e8 a7 12 00 00       	call   8033c1 <_panic>
  80211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211d:	8b 50 04             	mov    0x4(%eax),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	89 50 04             	mov    %edx,0x4(%eax)
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80212c:	89 10                	mov    %edx,(%eax)
  80212e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802131:	8b 40 04             	mov    0x4(%eax),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 0d                	je     802145 <insert_sorted_allocList+0x108>
  802138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213b:	8b 40 04             	mov    0x4(%eax),%eax
  80213e:	8b 55 08             	mov    0x8(%ebp),%edx
  802141:	89 10                	mov    %edx,(%eax)
  802143:	eb 08                	jmp    80214d <insert_sorted_allocList+0x110>
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	a3 40 50 80 00       	mov    %eax,0x805040
  80214d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802150:	8b 55 08             	mov    0x8(%ebp),%edx
  802153:	89 50 04             	mov    %edx,0x4(%eax)
  802156:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80215b:	40                   	inc    %eax
  80215c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802161:	e9 60 01 00 00       	jmp    8022c6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8b 50 08             	mov    0x8(%eax),%edx
  80216c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216f:	8b 40 08             	mov    0x8(%eax),%eax
  802172:	39 c2                	cmp    %eax,%edx
  802174:	0f 82 4c 01 00 00    	jb     8022c6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80217a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217e:	75 14                	jne    802194 <insert_sorted_allocList+0x157>
  802180:	83 ec 04             	sub    $0x4,%esp
  802183:	68 e8 3e 80 00       	push   $0x803ee8
  802188:	6a 73                	push   $0x73
  80218a:	68 97 3e 80 00       	push   $0x803e97
  80218f:	e8 2d 12 00 00       	call   8033c1 <_panic>
  802194:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	89 50 04             	mov    %edx,0x4(%eax)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8b 40 04             	mov    0x4(%eax),%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	74 0c                	je     8021b6 <insert_sorted_allocList+0x179>
  8021aa:	a1 44 50 80 00       	mov    0x805044,%eax
  8021af:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b2:	89 10                	mov    %edx,(%eax)
  8021b4:	eb 08                	jmp    8021be <insert_sorted_allocList+0x181>
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	a3 40 50 80 00       	mov    %eax,0x805040
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	a3 44 50 80 00       	mov    %eax,0x805044
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021cf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021d4:	40                   	inc    %eax
  8021d5:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021da:	e9 e7 00 00 00       	jmp    8022c6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021e5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021ec:	a1 40 50 80 00       	mov    0x805040,%eax
  8021f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f4:	e9 9d 00 00 00       	jmp    802296 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	8b 00                	mov    (%eax),%eax
  8021fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 50 08             	mov    0x8(%eax),%edx
  802207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220a:	8b 40 08             	mov    0x8(%eax),%eax
  80220d:	39 c2                	cmp    %eax,%edx
  80220f:	76 7d                	jbe    80228e <insert_sorted_allocList+0x251>
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	8b 50 08             	mov    0x8(%eax),%edx
  802217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80221a:	8b 40 08             	mov    0x8(%eax),%eax
  80221d:	39 c2                	cmp    %eax,%edx
  80221f:	73 6d                	jae    80228e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802225:	74 06                	je     80222d <insert_sorted_allocList+0x1f0>
  802227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222b:	75 14                	jne    802241 <insert_sorted_allocList+0x204>
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	68 0c 3f 80 00       	push   $0x803f0c
  802235:	6a 7f                	push   $0x7f
  802237:	68 97 3e 80 00       	push   $0x803e97
  80223c:	e8 80 11 00 00       	call   8033c1 <_panic>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 10                	mov    (%eax),%edx
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	89 10                	mov    %edx,(%eax)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	74 0b                	je     80225f <insert_sorted_allocList+0x222>
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 00                	mov    (%eax),%eax
  802259:	8b 55 08             	mov    0x8(%ebp),%edx
  80225c:	89 50 04             	mov    %edx,0x4(%eax)
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 55 08             	mov    0x8(%ebp),%edx
  802265:	89 10                	mov    %edx,(%eax)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226d:	89 50 04             	mov    %edx,0x4(%eax)
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	8b 00                	mov    (%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	75 08                	jne    802281 <insert_sorted_allocList+0x244>
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	a3 44 50 80 00       	mov    %eax,0x805044
  802281:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802286:	40                   	inc    %eax
  802287:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80228c:	eb 39                	jmp    8022c7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80228e:	a1 48 50 80 00       	mov    0x805048,%eax
  802293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802296:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229a:	74 07                	je     8022a3 <insert_sorted_allocList+0x266>
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 00                	mov    (%eax),%eax
  8022a1:	eb 05                	jmp    8022a8 <insert_sorted_allocList+0x26b>
  8022a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a8:	a3 48 50 80 00       	mov    %eax,0x805048
  8022ad:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	0f 85 3f ff ff ff    	jne    8021f9 <insert_sorted_allocList+0x1bc>
  8022ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022be:	0f 85 35 ff ff ff    	jne    8021f9 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c4:	eb 01                	jmp    8022c7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c7:	90                   	nop
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8022d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d8:	e9 85 01 00 00       	jmp    802462 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e6:	0f 82 6e 01 00 00    	jb     80245a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f5:	0f 85 8a 00 00 00    	jne    802385 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ff:	75 17                	jne    802318 <alloc_block_FF+0x4e>
  802301:	83 ec 04             	sub    $0x4,%esp
  802304:	68 40 3f 80 00       	push   $0x803f40
  802309:	68 93 00 00 00       	push   $0x93
  80230e:	68 97 3e 80 00       	push   $0x803e97
  802313:	e8 a9 10 00 00       	call   8033c1 <_panic>
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 00                	mov    (%eax),%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 10                	je     802331 <alloc_block_FF+0x67>
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 00                	mov    (%eax),%eax
  802326:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802329:	8b 52 04             	mov    0x4(%edx),%edx
  80232c:	89 50 04             	mov    %edx,0x4(%eax)
  80232f:	eb 0b                	jmp    80233c <alloc_block_FF+0x72>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 04             	mov    0x4(%eax),%eax
  802337:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 40 04             	mov    0x4(%eax),%eax
  802342:	85 c0                	test   %eax,%eax
  802344:	74 0f                	je     802355 <alloc_block_FF+0x8b>
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 40 04             	mov    0x4(%eax),%eax
  80234c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234f:	8b 12                	mov    (%edx),%edx
  802351:	89 10                	mov    %edx,(%eax)
  802353:	eb 0a                	jmp    80235f <alloc_block_FF+0x95>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	a3 38 51 80 00       	mov    %eax,0x805138
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802372:	a1 44 51 80 00       	mov    0x805144,%eax
  802377:	48                   	dec    %eax
  802378:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	e9 10 01 00 00       	jmp    802495 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 40 0c             	mov    0xc(%eax),%eax
  80238b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80238e:	0f 86 c6 00 00 00    	jbe    80245a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802394:	a1 48 51 80 00       	mov    0x805148,%eax
  802399:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 50 08             	mov    0x8(%eax),%edx
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ae:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b5:	75 17                	jne    8023ce <alloc_block_FF+0x104>
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	68 40 3f 80 00       	push   $0x803f40
  8023bf:	68 9b 00 00 00       	push   $0x9b
  8023c4:	68 97 3e 80 00       	push   $0x803e97
  8023c9:	e8 f3 0f 00 00       	call   8033c1 <_panic>
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 10                	je     8023e7 <alloc_block_FF+0x11d>
  8023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023da:	8b 00                	mov    (%eax),%eax
  8023dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023df:	8b 52 04             	mov    0x4(%edx),%edx
  8023e2:	89 50 04             	mov    %edx,0x4(%eax)
  8023e5:	eb 0b                	jmp    8023f2 <alloc_block_FF+0x128>
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	8b 40 04             	mov    0x4(%eax),%eax
  8023ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 0f                	je     80240b <alloc_block_FF+0x141>
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802405:	8b 12                	mov    (%edx),%edx
  802407:	89 10                	mov    %edx,(%eax)
  802409:	eb 0a                	jmp    802415 <alloc_block_FF+0x14b>
  80240b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	a3 48 51 80 00       	mov    %eax,0x805148
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802428:	a1 54 51 80 00       	mov    0x805154,%eax
  80242d:	48                   	dec    %eax
  80242e:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 50 08             	mov    0x8(%eax),%edx
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	01 c2                	add    %eax,%edx
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 40 0c             	mov    0xc(%eax),%eax
  80244a:	2b 45 08             	sub    0x8(%ebp),%eax
  80244d:	89 c2                	mov    %eax,%edx
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	eb 3b                	jmp    802495 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80245a:	a1 40 51 80 00       	mov    0x805140,%eax
  80245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802466:	74 07                	je     80246f <alloc_block_FF+0x1a5>
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	eb 05                	jmp    802474 <alloc_block_FF+0x1aa>
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
  802474:	a3 40 51 80 00       	mov    %eax,0x805140
  802479:	a1 40 51 80 00       	mov    0x805140,%eax
  80247e:	85 c0                	test   %eax,%eax
  802480:	0f 85 57 fe ff ff    	jne    8022dd <alloc_block_FF+0x13>
  802486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248a:	0f 85 4d fe ff ff    	jne    8022dd <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80249d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ac:	e9 df 00 00 00       	jmp    802590 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ba:	0f 82 c8 00 00 00    	jb     802588 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c9:	0f 85 8a 00 00 00    	jne    802559 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d3:	75 17                	jne    8024ec <alloc_block_BF+0x55>
  8024d5:	83 ec 04             	sub    $0x4,%esp
  8024d8:	68 40 3f 80 00       	push   $0x803f40
  8024dd:	68 b7 00 00 00       	push   $0xb7
  8024e2:	68 97 3e 80 00       	push   $0x803e97
  8024e7:	e8 d5 0e 00 00       	call   8033c1 <_panic>
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 00                	mov    (%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 10                	je     802505 <alloc_block_BF+0x6e>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	8b 52 04             	mov    0x4(%edx),%edx
  802500:	89 50 04             	mov    %edx,0x4(%eax)
  802503:	eb 0b                	jmp    802510 <alloc_block_BF+0x79>
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 04             	mov    0x4(%eax),%eax
  80250b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 40 04             	mov    0x4(%eax),%eax
  802516:	85 c0                	test   %eax,%eax
  802518:	74 0f                	je     802529 <alloc_block_BF+0x92>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802523:	8b 12                	mov    (%edx),%edx
  802525:	89 10                	mov    %edx,(%eax)
  802527:	eb 0a                	jmp    802533 <alloc_block_BF+0x9c>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	a3 38 51 80 00       	mov    %eax,0x805138
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802546:	a1 44 51 80 00       	mov    0x805144,%eax
  80254b:	48                   	dec    %eax
  80254c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	e9 4d 01 00 00       	jmp    8026a6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 0c             	mov    0xc(%eax),%eax
  80255f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802562:	76 24                	jbe    802588 <alloc_block_BF+0xf1>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 0c             	mov    0xc(%eax),%eax
  80256a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80256d:	73 19                	jae    802588 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80256f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 0c             	mov    0xc(%eax),%eax
  80257c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 08             	mov    0x8(%eax),%eax
  802585:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802588:	a1 40 51 80 00       	mov    0x805140,%eax
  80258d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802594:	74 07                	je     80259d <alloc_block_BF+0x106>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	eb 05                	jmp    8025a2 <alloc_block_BF+0x10b>
  80259d:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a2:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	0f 85 fd fe ff ff    	jne    8024b1 <alloc_block_BF+0x1a>
  8025b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b8:	0f 85 f3 fe ff ff    	jne    8024b1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025c2:	0f 84 d9 00 00 00    	je     8026a1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8025cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d6:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025df:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025e6:	75 17                	jne    8025ff <alloc_block_BF+0x168>
  8025e8:	83 ec 04             	sub    $0x4,%esp
  8025eb:	68 40 3f 80 00       	push   $0x803f40
  8025f0:	68 c7 00 00 00       	push   $0xc7
  8025f5:	68 97 3e 80 00       	push   $0x803e97
  8025fa:	e8 c2 0d 00 00       	call   8033c1 <_panic>
  8025ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 10                	je     802618 <alloc_block_BF+0x181>
  802608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260b:	8b 00                	mov    (%eax),%eax
  80260d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802610:	8b 52 04             	mov    0x4(%edx),%edx
  802613:	89 50 04             	mov    %edx,0x4(%eax)
  802616:	eb 0b                	jmp    802623 <alloc_block_BF+0x18c>
  802618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261b:	8b 40 04             	mov    0x4(%eax),%eax
  80261e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802626:	8b 40 04             	mov    0x4(%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	74 0f                	je     80263c <alloc_block_BF+0x1a5>
  80262d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802630:	8b 40 04             	mov    0x4(%eax),%eax
  802633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802636:	8b 12                	mov    (%edx),%edx
  802638:	89 10                	mov    %edx,(%eax)
  80263a:	eb 0a                	jmp    802646 <alloc_block_BF+0x1af>
  80263c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	a3 48 51 80 00       	mov    %eax,0x805148
  802646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802649:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802659:	a1 54 51 80 00       	mov    0x805154,%eax
  80265e:	48                   	dec    %eax
  80265f:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802664:	83 ec 08             	sub    $0x8,%esp
  802667:	ff 75 ec             	pushl  -0x14(%ebp)
  80266a:	68 38 51 80 00       	push   $0x805138
  80266f:	e8 71 f9 ff ff       	call   801fe5 <find_block>
  802674:	83 c4 10             	add    $0x10,%esp
  802677:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80267a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267d:	8b 50 08             	mov    0x8(%eax),%edx
  802680:	8b 45 08             	mov    0x8(%ebp),%eax
  802683:	01 c2                	add    %eax,%edx
  802685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802688:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80268b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268e:	8b 40 0c             	mov    0xc(%eax),%eax
  802691:	2b 45 08             	sub    0x8(%ebp),%eax
  802694:	89 c2                	mov    %eax,%edx
  802696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802699:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80269c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269f:	eb 05                	jmp    8026a6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026ae:	a1 28 50 80 00       	mov    0x805028,%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	0f 85 de 01 00 00    	jne    802899 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8026c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c3:	e9 9e 01 00 00       	jmp    802866 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d1:	0f 82 87 01 00 00    	jb     80285e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e0:	0f 85 95 00 00 00    	jne    80277b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ea:	75 17                	jne    802703 <alloc_block_NF+0x5b>
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	68 40 3f 80 00       	push   $0x803f40
  8026f4:	68 e0 00 00 00       	push   $0xe0
  8026f9:	68 97 3e 80 00       	push   $0x803e97
  8026fe:	e8 be 0c 00 00       	call   8033c1 <_panic>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 10                	je     80271c <alloc_block_NF+0x74>
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	8b 52 04             	mov    0x4(%edx),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 0b                	jmp    802727 <alloc_block_NF+0x7f>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 0f                	je     802740 <alloc_block_NF+0x98>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	8b 12                	mov    (%edx),%edx
  80273c:	89 10                	mov    %edx,(%eax)
  80273e:	eb 0a                	jmp    80274a <alloc_block_NF+0xa2>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	a3 38 51 80 00       	mov    %eax,0x805138
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275d:	a1 44 51 80 00       	mov    0x805144,%eax
  802762:	48                   	dec    %eax
  802763:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 08             	mov    0x8(%eax),%eax
  80276e:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	e9 f8 04 00 00       	jmp    802c73 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 0c             	mov    0xc(%eax),%eax
  802781:	3b 45 08             	cmp    0x8(%ebp),%eax
  802784:	0f 86 d4 00 00 00    	jbe    80285e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80278a:	a1 48 51 80 00       	mov    0x805148,%eax
  80278f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 50 08             	mov    0x8(%eax),%edx
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ab:	75 17                	jne    8027c4 <alloc_block_NF+0x11c>
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	68 40 3f 80 00       	push   $0x803f40
  8027b5:	68 e9 00 00 00       	push   $0xe9
  8027ba:	68 97 3e 80 00       	push   $0x803e97
  8027bf:	e8 fd 0b 00 00       	call   8033c1 <_panic>
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	8b 00                	mov    (%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	74 10                	je     8027dd <alloc_block_NF+0x135>
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d5:	8b 52 04             	mov    0x4(%edx),%edx
  8027d8:	89 50 04             	mov    %edx,0x4(%eax)
  8027db:	eb 0b                	jmp    8027e8 <alloc_block_NF+0x140>
  8027dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e0:	8b 40 04             	mov    0x4(%eax),%eax
  8027e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	85 c0                	test   %eax,%eax
  8027f0:	74 0f                	je     802801 <alloc_block_NF+0x159>
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fb:	8b 12                	mov    (%edx),%edx
  8027fd:	89 10                	mov    %edx,(%eax)
  8027ff:	eb 0a                	jmp    80280b <alloc_block_NF+0x163>
  802801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	a3 48 51 80 00       	mov    %eax,0x805148
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281e:	a1 54 51 80 00       	mov    0x805154,%eax
  802823:	48                   	dec    %eax
  802824:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	8b 40 08             	mov    0x8(%eax),%eax
  80282f:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 50 08             	mov    0x8(%eax),%edx
  80283a:	8b 45 08             	mov    0x8(%ebp),%eax
  80283d:	01 c2                	add    %eax,%edx
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 40 0c             	mov    0xc(%eax),%eax
  80284b:	2b 45 08             	sub    0x8(%ebp),%eax
  80284e:	89 c2                	mov    %eax,%edx
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802859:	e9 15 04 00 00       	jmp    802c73 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80285e:	a1 40 51 80 00       	mov    0x805140,%eax
  802863:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	74 07                	je     802873 <alloc_block_NF+0x1cb>
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	eb 05                	jmp    802878 <alloc_block_NF+0x1d0>
  802873:	b8 00 00 00 00       	mov    $0x0,%eax
  802878:	a3 40 51 80 00       	mov    %eax,0x805140
  80287d:	a1 40 51 80 00       	mov    0x805140,%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	0f 85 3e fe ff ff    	jne    8026c8 <alloc_block_NF+0x20>
  80288a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288e:	0f 85 34 fe ff ff    	jne    8026c8 <alloc_block_NF+0x20>
  802894:	e9 d5 03 00 00       	jmp    802c6e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802899:	a1 38 51 80 00       	mov    0x805138,%eax
  80289e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a1:	e9 b1 01 00 00       	jmp    802a57 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	a1 28 50 80 00       	mov    0x805028,%eax
  8028b1:	39 c2                	cmp    %eax,%edx
  8028b3:	0f 82 96 01 00 00    	jb     802a4f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c2:	0f 82 87 01 00 00    	jb     802a4f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d1:	0f 85 95 00 00 00    	jne    80296c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028db:	75 17                	jne    8028f4 <alloc_block_NF+0x24c>
  8028dd:	83 ec 04             	sub    $0x4,%esp
  8028e0:	68 40 3f 80 00       	push   $0x803f40
  8028e5:	68 fc 00 00 00       	push   $0xfc
  8028ea:	68 97 3e 80 00       	push   $0x803e97
  8028ef:	e8 cd 0a 00 00       	call   8033c1 <_panic>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 10                	je     80290d <alloc_block_NF+0x265>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802905:	8b 52 04             	mov    0x4(%edx),%edx
  802908:	89 50 04             	mov    %edx,0x4(%eax)
  80290b:	eb 0b                	jmp    802918 <alloc_block_NF+0x270>
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 04             	mov    0x4(%eax),%eax
  802913:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 40 04             	mov    0x4(%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	74 0f                	je     802931 <alloc_block_NF+0x289>
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292b:	8b 12                	mov    (%edx),%edx
  80292d:	89 10                	mov    %edx,(%eax)
  80292f:	eb 0a                	jmp    80293b <alloc_block_NF+0x293>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	a3 38 51 80 00       	mov    %eax,0x805138
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294e:	a1 44 51 80 00       	mov    0x805144,%eax
  802953:	48                   	dec    %eax
  802954:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 40 08             	mov    0x8(%eax),%eax
  80295f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	e9 07 03 00 00       	jmp    802c73 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	3b 45 08             	cmp    0x8(%ebp),%eax
  802975:	0f 86 d4 00 00 00    	jbe    802a4f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80297b:	a1 48 51 80 00       	mov    0x805148,%eax
  802980:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	8b 50 08             	mov    0x8(%eax),%edx
  802989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80298f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802992:	8b 55 08             	mov    0x8(%ebp),%edx
  802995:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802998:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80299c:	75 17                	jne    8029b5 <alloc_block_NF+0x30d>
  80299e:	83 ec 04             	sub    $0x4,%esp
  8029a1:	68 40 3f 80 00       	push   $0x803f40
  8029a6:	68 04 01 00 00       	push   $0x104
  8029ab:	68 97 3e 80 00       	push   $0x803e97
  8029b0:	e8 0c 0a 00 00       	call   8033c1 <_panic>
  8029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 10                	je     8029ce <alloc_block_NF+0x326>
  8029be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c1:	8b 00                	mov    (%eax),%eax
  8029c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c6:	8b 52 04             	mov    0x4(%edx),%edx
  8029c9:	89 50 04             	mov    %edx,0x4(%eax)
  8029cc:	eb 0b                	jmp    8029d9 <alloc_block_NF+0x331>
  8029ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d1:	8b 40 04             	mov    0x4(%eax),%eax
  8029d4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	74 0f                	je     8029f2 <alloc_block_NF+0x34a>
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029ec:	8b 12                	mov    (%edx),%edx
  8029ee:	89 10                	mov    %edx,(%eax)
  8029f0:	eb 0a                	jmp    8029fc <alloc_block_NF+0x354>
  8029f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8029fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 54 51 80 00       	mov    0x805154,%eax
  802a14:	48                   	dec    %eax
  802a15:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1d:	8b 40 08             	mov    0x8(%eax),%eax
  802a20:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 50 08             	mov    0x8(%eax),%edx
  802a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2e:	01 c2                	add    %eax,%edx
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3c:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3f:	89 c2                	mov    %eax,%edx
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4a:	e9 24 02 00 00       	jmp    802c73 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a4f:	a1 40 51 80 00       	mov    0x805140,%eax
  802a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5b:	74 07                	je     802a64 <alloc_block_NF+0x3bc>
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	eb 05                	jmp    802a69 <alloc_block_NF+0x3c1>
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
  802a69:	a3 40 51 80 00       	mov    %eax,0x805140
  802a6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	0f 85 2b fe ff ff    	jne    8028a6 <alloc_block_NF+0x1fe>
  802a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7f:	0f 85 21 fe ff ff    	jne    8028a6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a85:	a1 38 51 80 00       	mov    0x805138,%eax
  802a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8d:	e9 ae 01 00 00       	jmp    802c40 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 50 08             	mov    0x8(%eax),%edx
  802a98:	a1 28 50 80 00       	mov    0x805028,%eax
  802a9d:	39 c2                	cmp    %eax,%edx
  802a9f:	0f 83 93 01 00 00    	jae    802c38 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aab:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aae:	0f 82 84 01 00 00    	jb     802c38 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aba:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abd:	0f 85 95 00 00 00    	jne    802b58 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac7:	75 17                	jne    802ae0 <alloc_block_NF+0x438>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 40 3f 80 00       	push   $0x803f40
  802ad1:	68 14 01 00 00       	push   $0x114
  802ad6:	68 97 3e 80 00       	push   $0x803e97
  802adb:	e8 e1 08 00 00       	call   8033c1 <_panic>
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 10                	je     802af9 <alloc_block_NF+0x451>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af1:	8b 52 04             	mov    0x4(%edx),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%eax)
  802af7:	eb 0b                	jmp    802b04 <alloc_block_NF+0x45c>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 0f                	je     802b1d <alloc_block_NF+0x475>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b17:	8b 12                	mov    (%edx),%edx
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	eb 0a                	jmp    802b27 <alloc_block_NF+0x47f>
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	a3 38 51 80 00       	mov    %eax,0x805138
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	a1 44 51 80 00       	mov    0x805144,%eax
  802b3f:	48                   	dec    %eax
  802b40:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 40 08             	mov    0x8(%eax),%eax
  802b4b:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	e9 1b 01 00 00       	jmp    802c73 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b61:	0f 86 d1 00 00 00    	jbe    802c38 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b67:	a1 48 51 80 00       	mov    0x805148,%eax
  802b6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 50 08             	mov    0x8(%eax),%edx
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b81:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b88:	75 17                	jne    802ba1 <alloc_block_NF+0x4f9>
  802b8a:	83 ec 04             	sub    $0x4,%esp
  802b8d:	68 40 3f 80 00       	push   $0x803f40
  802b92:	68 1c 01 00 00       	push   $0x11c
  802b97:	68 97 3e 80 00       	push   $0x803e97
  802b9c:	e8 20 08 00 00       	call   8033c1 <_panic>
  802ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 10                	je     802bba <alloc_block_NF+0x512>
  802baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb2:	8b 52 04             	mov    0x4(%edx),%edx
  802bb5:	89 50 04             	mov    %edx,0x4(%eax)
  802bb8:	eb 0b                	jmp    802bc5 <alloc_block_NF+0x51d>
  802bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	85 c0                	test   %eax,%eax
  802bcd:	74 0f                	je     802bde <alloc_block_NF+0x536>
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	8b 40 04             	mov    0x4(%eax),%eax
  802bd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd8:	8b 12                	mov    (%edx),%edx
  802bda:	89 10                	mov    %edx,(%eax)
  802bdc:	eb 0a                	jmp    802be8 <alloc_block_NF+0x540>
  802bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be1:	8b 00                	mov    (%eax),%eax
  802be3:	a3 48 51 80 00       	mov    %eax,0x805148
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfb:	a1 54 51 80 00       	mov    0x805154,%eax
  802c00:	48                   	dec    %eax
  802c01:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	8b 40 08             	mov    0x8(%eax),%eax
  802c0c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 50 08             	mov    0x8(%eax),%edx
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	01 c2                	add    %eax,%edx
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 40 0c             	mov    0xc(%eax),%eax
  802c28:	2b 45 08             	sub    0x8(%ebp),%eax
  802c2b:	89 c2                	mov    %eax,%edx
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	eb 3b                	jmp    802c73 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c38:	a1 40 51 80 00       	mov    0x805140,%eax
  802c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c44:	74 07                	je     802c4d <alloc_block_NF+0x5a5>
  802c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	eb 05                	jmp    802c52 <alloc_block_NF+0x5aa>
  802c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c52:	a3 40 51 80 00       	mov    %eax,0x805140
  802c57:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5c:	85 c0                	test   %eax,%eax
  802c5e:	0f 85 2e fe ff ff    	jne    802a92 <alloc_block_NF+0x3ea>
  802c64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c68:	0f 85 24 fe ff ff    	jne    802a92 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c73:	c9                   	leave  
  802c74:	c3                   	ret    

00802c75 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
  802c78:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c83:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c88:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c8b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c90:	85 c0                	test   %eax,%eax
  802c92:	74 14                	je     802ca8 <insert_sorted_with_merge_freeList+0x33>
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ca0:	39 c2                	cmp    %eax,%edx
  802ca2:	0f 87 9b 01 00 00    	ja     802e43 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ca8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cac:	75 17                	jne    802cc5 <insert_sorted_with_merge_freeList+0x50>
  802cae:	83 ec 04             	sub    $0x4,%esp
  802cb1:	68 74 3e 80 00       	push   $0x803e74
  802cb6:	68 38 01 00 00       	push   $0x138
  802cbb:	68 97 3e 80 00       	push   $0x803e97
  802cc0:	e8 fc 06 00 00       	call   8033c1 <_panic>
  802cc5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	89 10                	mov    %edx,(%eax)
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 00                	mov    (%eax),%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	74 0d                	je     802ce6 <insert_sorted_with_merge_freeList+0x71>
  802cd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802cde:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce1:	89 50 04             	mov    %edx,0x4(%eax)
  802ce4:	eb 08                	jmp    802cee <insert_sorted_with_merge_freeList+0x79>
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d00:	a1 44 51 80 00       	mov    0x805144,%eax
  802d05:	40                   	inc    %eax
  802d06:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0f:	0f 84 a8 06 00 00    	je     8033bd <insert_sorted_with_merge_freeList+0x748>
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	8b 50 08             	mov    0x8(%eax),%edx
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d21:	01 c2                	add    %eax,%edx
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 40 08             	mov    0x8(%eax),%eax
  802d29:	39 c2                	cmp    %eax,%edx
  802d2b:	0f 85 8c 06 00 00    	jne    8033bd <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 50 0c             	mov    0xc(%eax),%edx
  802d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3d:	01 c2                	add    %eax,%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d49:	75 17                	jne    802d62 <insert_sorted_with_merge_freeList+0xed>
  802d4b:	83 ec 04             	sub    $0x4,%esp
  802d4e:	68 40 3f 80 00       	push   $0x803f40
  802d53:	68 3c 01 00 00       	push   $0x13c
  802d58:	68 97 3e 80 00       	push   $0x803e97
  802d5d:	e8 5f 06 00 00       	call   8033c1 <_panic>
  802d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 10                	je     802d7b <insert_sorted_with_merge_freeList+0x106>
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d73:	8b 52 04             	mov    0x4(%edx),%edx
  802d76:	89 50 04             	mov    %edx,0x4(%eax)
  802d79:	eb 0b                	jmp    802d86 <insert_sorted_with_merge_freeList+0x111>
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	8b 40 04             	mov    0x4(%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 0f                	je     802d9f <insert_sorted_with_merge_freeList+0x12a>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d99:	8b 12                	mov    (%edx),%edx
  802d9b:	89 10                	mov    %edx,(%eax)
  802d9d:	eb 0a                	jmp    802da9 <insert_sorted_with_merge_freeList+0x134>
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	a3 38 51 80 00       	mov    %eax,0x805138
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbc:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc1:	48                   	dec    %eax
  802dc2:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ddb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ddf:	75 17                	jne    802df8 <insert_sorted_with_merge_freeList+0x183>
  802de1:	83 ec 04             	sub    $0x4,%esp
  802de4:	68 74 3e 80 00       	push   $0x803e74
  802de9:	68 3f 01 00 00       	push   $0x13f
  802dee:	68 97 3e 80 00       	push   $0x803e97
  802df3:	e8 c9 05 00 00       	call   8033c1 <_panic>
  802df8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	89 10                	mov    %edx,(%eax)
  802e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 0d                	je     802e19 <insert_sorted_with_merge_freeList+0x1a4>
  802e0c:	a1 48 51 80 00       	mov    0x805148,%eax
  802e11:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e14:	89 50 04             	mov    %edx,0x4(%eax)
  802e17:	eb 08                	jmp    802e21 <insert_sorted_with_merge_freeList+0x1ac>
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e24:	a3 48 51 80 00       	mov    %eax,0x805148
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e33:	a1 54 51 80 00       	mov    0x805154,%eax
  802e38:	40                   	inc    %eax
  802e39:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e3e:	e9 7a 05 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	8b 50 08             	mov    0x8(%eax),%edx
  802e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4c:	8b 40 08             	mov    0x8(%eax),%eax
  802e4f:	39 c2                	cmp    %eax,%edx
  802e51:	0f 82 14 01 00 00    	jb     802f6b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5a:	8b 50 08             	mov    0x8(%eax),%edx
  802e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e60:	8b 40 0c             	mov    0xc(%eax),%eax
  802e63:	01 c2                	add    %eax,%edx
  802e65:	8b 45 08             	mov    0x8(%ebp),%eax
  802e68:	8b 40 08             	mov    0x8(%eax),%eax
  802e6b:	39 c2                	cmp    %eax,%edx
  802e6d:	0f 85 90 00 00 00    	jne    802f03 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e76:	8b 50 0c             	mov    0xc(%eax),%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	01 c2                	add    %eax,%edx
  802e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e84:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9f:	75 17                	jne    802eb8 <insert_sorted_with_merge_freeList+0x243>
  802ea1:	83 ec 04             	sub    $0x4,%esp
  802ea4:	68 74 3e 80 00       	push   $0x803e74
  802ea9:	68 49 01 00 00       	push   $0x149
  802eae:	68 97 3e 80 00       	push   $0x803e97
  802eb3:	e8 09 05 00 00       	call   8033c1 <_panic>
  802eb8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec6:	8b 00                	mov    (%eax),%eax
  802ec8:	85 c0                	test   %eax,%eax
  802eca:	74 0d                	je     802ed9 <insert_sorted_with_merge_freeList+0x264>
  802ecc:	a1 48 51 80 00       	mov    0x805148,%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 50 04             	mov    %edx,0x4(%eax)
  802ed7:	eb 08                	jmp    802ee1 <insert_sorted_with_merge_freeList+0x26c>
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef8:	40                   	inc    %eax
  802ef9:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802efe:	e9 bb 04 00 00       	jmp    8033be <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x2ab>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 e8 3e 80 00       	push   $0x803ee8
  802f11:	68 4c 01 00 00       	push   $0x14c
  802f16:	68 97 3e 80 00       	push   $0x803e97
  802f1b:	e8 a1 04 00 00       	call   8033c1 <_panic>
  802f20:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	89 50 04             	mov    %edx,0x4(%eax)
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	8b 40 04             	mov    0x4(%eax),%eax
  802f32:	85 c0                	test   %eax,%eax
  802f34:	74 0c                	je     802f42 <insert_sorted_with_merge_freeList+0x2cd>
  802f36:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3e:	89 10                	mov    %edx,(%eax)
  802f40:	eb 08                	jmp    802f4a <insert_sorted_with_merge_freeList+0x2d5>
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 38 51 80 00       	mov    %eax,0x805138
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f66:	e9 53 04 00 00       	jmp    8033be <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f73:	e9 15 04 00 00       	jmp    80338d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 50 08             	mov    0x8(%eax),%edx
  802f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f89:	8b 40 08             	mov    0x8(%eax),%eax
  802f8c:	39 c2                	cmp    %eax,%edx
  802f8e:	0f 86 f1 03 00 00    	jbe    803385 <insert_sorted_with_merge_freeList+0x710>
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	8b 50 08             	mov    0x8(%eax),%edx
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	8b 40 08             	mov    0x8(%eax),%eax
  802fa0:	39 c2                	cmp    %eax,%edx
  802fa2:	0f 83 dd 03 00 00    	jae    803385 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 50 08             	mov    0x8(%eax),%edx
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb4:	01 c2                	add    %eax,%edx
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 40 08             	mov    0x8(%eax),%eax
  802fbc:	39 c2                	cmp    %eax,%edx
  802fbe:	0f 85 b9 01 00 00    	jne    80317d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	8b 50 08             	mov    0x8(%eax),%edx
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd0:	01 c2                	add    %eax,%edx
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 40 08             	mov    0x8(%eax),%eax
  802fd8:	39 c2                	cmp    %eax,%edx
  802fda:	0f 85 0d 01 00 00    	jne    8030ed <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fec:	01 c2                	add    %eax,%edx
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ff4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff8:	75 17                	jne    803011 <insert_sorted_with_merge_freeList+0x39c>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 40 3f 80 00       	push   $0x803f40
  803002:	68 5c 01 00 00       	push   $0x15c
  803007:	68 97 3e 80 00       	push   $0x803e97
  80300c:	e8 b0 03 00 00       	call   8033c1 <_panic>
  803011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 10                	je     80302a <insert_sorted_with_merge_freeList+0x3b5>
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803022:	8b 52 04             	mov    0x4(%edx),%edx
  803025:	89 50 04             	mov    %edx,0x4(%eax)
  803028:	eb 0b                	jmp    803035 <insert_sorted_with_merge_freeList+0x3c0>
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803038:	8b 40 04             	mov    0x4(%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0f                	je     80304e <insert_sorted_with_merge_freeList+0x3d9>
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803048:	8b 12                	mov    (%edx),%edx
  80304a:	89 10                	mov    %edx,(%eax)
  80304c:	eb 0a                	jmp    803058 <insert_sorted_with_merge_freeList+0x3e3>
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8b 00                	mov    (%eax),%eax
  803053:	a3 38 51 80 00       	mov    %eax,0x805138
  803058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 44 51 80 00       	mov    0x805144,%eax
  803070:	48                   	dec    %eax
  803071:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80308a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308e:	75 17                	jne    8030a7 <insert_sorted_with_merge_freeList+0x432>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 74 3e 80 00       	push   $0x803e74
  803098:	68 5f 01 00 00       	push   $0x15f
  80309d:	68 97 3e 80 00       	push   $0x803e97
  8030a2:	e8 1a 03 00 00       	call   8033c1 <_panic>
  8030a7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	89 10                	mov    %edx,(%eax)
  8030b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b5:	8b 00                	mov    (%eax),%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	74 0d                	je     8030c8 <insert_sorted_with_merge_freeList+0x453>
  8030bb:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c3:	89 50 04             	mov    %edx,0x4(%eax)
  8030c6:	eb 08                	jmp    8030d0 <insert_sorted_with_merge_freeList+0x45b>
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e7:	40                   	inc    %eax
  8030e8:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f9:	01 c2                	add    %eax,%edx
  8030fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fe:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803101:	8b 45 08             	mov    0x8(%ebp),%eax
  803104:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803119:	75 17                	jne    803132 <insert_sorted_with_merge_freeList+0x4bd>
  80311b:	83 ec 04             	sub    $0x4,%esp
  80311e:	68 74 3e 80 00       	push   $0x803e74
  803123:	68 64 01 00 00       	push   $0x164
  803128:	68 97 3e 80 00       	push   $0x803e97
  80312d:	e8 8f 02 00 00       	call   8033c1 <_panic>
  803132:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	85 c0                	test   %eax,%eax
  803144:	74 0d                	je     803153 <insert_sorted_with_merge_freeList+0x4de>
  803146:	a1 48 51 80 00       	mov    0x805148,%eax
  80314b:	8b 55 08             	mov    0x8(%ebp),%edx
  80314e:	89 50 04             	mov    %edx,0x4(%eax)
  803151:	eb 08                	jmp    80315b <insert_sorted_with_merge_freeList+0x4e6>
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	a3 48 51 80 00       	mov    %eax,0x805148
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316d:	a1 54 51 80 00       	mov    0x805154,%eax
  803172:	40                   	inc    %eax
  803173:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803178:	e9 41 02 00 00       	jmp    8033be <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 50 08             	mov    0x8(%eax),%edx
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	01 c2                	add    %eax,%edx
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 40 08             	mov    0x8(%eax),%eax
  803191:	39 c2                	cmp    %eax,%edx
  803193:	0f 85 7c 01 00 00    	jne    803315 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803199:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319d:	74 06                	je     8031a5 <insert_sorted_with_merge_freeList+0x530>
  80319f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a3:	75 17                	jne    8031bc <insert_sorted_with_merge_freeList+0x547>
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 b0 3e 80 00       	push   $0x803eb0
  8031ad:	68 69 01 00 00       	push   $0x169
  8031b2:	68 97 3e 80 00       	push   $0x803e97
  8031b7:	e8 05 02 00 00       	call   8033c1 <_panic>
  8031bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bf:	8b 50 04             	mov    0x4(%eax),%edx
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	89 50 04             	mov    %edx,0x4(%eax)
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	85 c0                	test   %eax,%eax
  8031d8:	74 0d                	je     8031e7 <insert_sorted_with_merge_freeList+0x572>
  8031da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e3:	89 10                	mov    %edx,(%eax)
  8031e5:	eb 08                	jmp    8031ef <insert_sorted_with_merge_freeList+0x57a>
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f5:	89 50 04             	mov    %edx,0x4(%eax)
  8031f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031fd:	40                   	inc    %eax
  8031fe:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	8b 50 0c             	mov    0xc(%eax),%edx
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	8b 40 0c             	mov    0xc(%eax),%eax
  80320f:	01 c2                	add    %eax,%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803217:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321b:	75 17                	jne    803234 <insert_sorted_with_merge_freeList+0x5bf>
  80321d:	83 ec 04             	sub    $0x4,%esp
  803220:	68 40 3f 80 00       	push   $0x803f40
  803225:	68 6b 01 00 00       	push   $0x16b
  80322a:	68 97 3e 80 00       	push   $0x803e97
  80322f:	e8 8d 01 00 00       	call   8033c1 <_panic>
  803234:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803237:	8b 00                	mov    (%eax),%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	74 10                	je     80324d <insert_sorted_with_merge_freeList+0x5d8>
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803245:	8b 52 04             	mov    0x4(%edx),%edx
  803248:	89 50 04             	mov    %edx,0x4(%eax)
  80324b:	eb 0b                	jmp    803258 <insert_sorted_with_merge_freeList+0x5e3>
  80324d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803250:	8b 40 04             	mov    0x4(%eax),%eax
  803253:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	8b 40 04             	mov    0x4(%eax),%eax
  80325e:	85 c0                	test   %eax,%eax
  803260:	74 0f                	je     803271 <insert_sorted_with_merge_freeList+0x5fc>
  803262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803265:	8b 40 04             	mov    0x4(%eax),%eax
  803268:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326b:	8b 12                	mov    (%edx),%edx
  80326d:	89 10                	mov    %edx,(%eax)
  80326f:	eb 0a                	jmp    80327b <insert_sorted_with_merge_freeList+0x606>
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 00                	mov    (%eax),%eax
  803276:	a3 38 51 80 00       	mov    %eax,0x805138
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328e:	a1 44 51 80 00       	mov    0x805144,%eax
  803293:	48                   	dec    %eax
  803294:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b1:	75 17                	jne    8032ca <insert_sorted_with_merge_freeList+0x655>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 74 3e 80 00       	push   $0x803e74
  8032bb:	68 6e 01 00 00       	push   $0x16e
  8032c0:	68 97 3e 80 00       	push   $0x803e97
  8032c5:	e8 f7 00 00 00       	call   8033c1 <_panic>
  8032ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d3:	89 10                	mov    %edx,(%eax)
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0d                	je     8032eb <insert_sorted_with_merge_freeList+0x676>
  8032de:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e6:	89 50 04             	mov    %edx,0x4(%eax)
  8032e9:	eb 08                	jmp    8032f3 <insert_sorted_with_merge_freeList+0x67e>
  8032eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803305:	a1 54 51 80 00       	mov    0x805154,%eax
  80330a:	40                   	inc    %eax
  80330b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803310:	e9 a9 00 00 00       	jmp    8033be <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803319:	74 06                	je     803321 <insert_sorted_with_merge_freeList+0x6ac>
  80331b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331f:	75 17                	jne    803338 <insert_sorted_with_merge_freeList+0x6c3>
  803321:	83 ec 04             	sub    $0x4,%esp
  803324:	68 0c 3f 80 00       	push   $0x803f0c
  803329:	68 73 01 00 00       	push   $0x173
  80332e:	68 97 3e 80 00       	push   $0x803e97
  803333:	e8 89 00 00 00       	call   8033c1 <_panic>
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 10                	mov    (%eax),%edx
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	89 10                	mov    %edx,(%eax)
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 0b                	je     803356 <insert_sorted_with_merge_freeList+0x6e1>
  80334b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	8b 55 08             	mov    0x8(%ebp),%edx
  803353:	89 50 04             	mov    %edx,0x4(%eax)
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	8b 55 08             	mov    0x8(%ebp),%edx
  80335c:	89 10                	mov    %edx,(%eax)
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803364:	89 50 04             	mov    %edx,0x4(%eax)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	8b 00                	mov    (%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	75 08                	jne    803378 <insert_sorted_with_merge_freeList+0x703>
  803370:	8b 45 08             	mov    0x8(%ebp),%eax
  803373:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803378:	a1 44 51 80 00       	mov    0x805144,%eax
  80337d:	40                   	inc    %eax
  80337e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803383:	eb 39                	jmp    8033be <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803385:	a1 40 51 80 00       	mov    0x805140,%eax
  80338a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803391:	74 07                	je     80339a <insert_sorted_with_merge_freeList+0x725>
  803393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	eb 05                	jmp    80339f <insert_sorted_with_merge_freeList+0x72a>
  80339a:	b8 00 00 00 00       	mov    $0x0,%eax
  80339f:	a3 40 51 80 00       	mov    %eax,0x805140
  8033a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	0f 85 c7 fb ff ff    	jne    802f78 <insert_sorted_with_merge_freeList+0x303>
  8033b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b5:	0f 85 bd fb ff ff    	jne    802f78 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033bb:	eb 01                	jmp    8033be <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033bd:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033be:	90                   	nop
  8033bf:	c9                   	leave  
  8033c0:	c3                   	ret    

008033c1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8033c1:	55                   	push   %ebp
  8033c2:	89 e5                	mov    %esp,%ebp
  8033c4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8033c7:	8d 45 10             	lea    0x10(%ebp),%eax
  8033ca:	83 c0 04             	add    $0x4,%eax
  8033cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8033d0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8033d5:	85 c0                	test   %eax,%eax
  8033d7:	74 16                	je     8033ef <_panic+0x2e>
		cprintf("%s: ", argv0);
  8033d9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8033de:	83 ec 08             	sub    $0x8,%esp
  8033e1:	50                   	push   %eax
  8033e2:	68 60 3f 80 00       	push   $0x803f60
  8033e7:	e8 6e d0 ff ff       	call   80045a <cprintf>
  8033ec:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033ef:	a1 00 50 80 00       	mov    0x805000,%eax
  8033f4:	ff 75 0c             	pushl  0xc(%ebp)
  8033f7:	ff 75 08             	pushl  0x8(%ebp)
  8033fa:	50                   	push   %eax
  8033fb:	68 65 3f 80 00       	push   $0x803f65
  803400:	e8 55 d0 ff ff       	call   80045a <cprintf>
  803405:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803408:	8b 45 10             	mov    0x10(%ebp),%eax
  80340b:	83 ec 08             	sub    $0x8,%esp
  80340e:	ff 75 f4             	pushl  -0xc(%ebp)
  803411:	50                   	push   %eax
  803412:	e8 d8 cf ff ff       	call   8003ef <vcprintf>
  803417:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80341a:	83 ec 08             	sub    $0x8,%esp
  80341d:	6a 00                	push   $0x0
  80341f:	68 81 3f 80 00       	push   $0x803f81
  803424:	e8 c6 cf ff ff       	call   8003ef <vcprintf>
  803429:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80342c:	e8 47 cf ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  803431:	eb fe                	jmp    803431 <_panic+0x70>

00803433 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803433:	55                   	push   %ebp
  803434:	89 e5                	mov    %esp,%ebp
  803436:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803439:	a1 20 50 80 00       	mov    0x805020,%eax
  80343e:	8b 50 74             	mov    0x74(%eax),%edx
  803441:	8b 45 0c             	mov    0xc(%ebp),%eax
  803444:	39 c2                	cmp    %eax,%edx
  803446:	74 14                	je     80345c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 84 3f 80 00       	push   $0x803f84
  803450:	6a 26                	push   $0x26
  803452:	68 d0 3f 80 00       	push   $0x803fd0
  803457:	e8 65 ff ff ff       	call   8033c1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80345c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803463:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80346a:	e9 c2 00 00 00       	jmp    803531 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80346f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803472:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	01 d0                	add    %edx,%eax
  80347e:	8b 00                	mov    (%eax),%eax
  803480:	85 c0                	test   %eax,%eax
  803482:	75 08                	jne    80348c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803484:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803487:	e9 a2 00 00 00       	jmp    80352e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80348c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803493:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80349a:	eb 69                	jmp    803505 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80349c:	a1 20 50 80 00       	mov    0x805020,%eax
  8034a1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034aa:	89 d0                	mov    %edx,%eax
  8034ac:	01 c0                	add    %eax,%eax
  8034ae:	01 d0                	add    %edx,%eax
  8034b0:	c1 e0 03             	shl    $0x3,%eax
  8034b3:	01 c8                	add    %ecx,%eax
  8034b5:	8a 40 04             	mov    0x4(%eax),%al
  8034b8:	84 c0                	test   %al,%al
  8034ba:	75 46                	jne    803502 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8034c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8034c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ca:	89 d0                	mov    %edx,%eax
  8034cc:	01 c0                	add    %eax,%eax
  8034ce:	01 d0                	add    %edx,%eax
  8034d0:	c1 e0 03             	shl    $0x3,%eax
  8034d3:	01 c8                	add    %ecx,%eax
  8034d5:	8b 00                	mov    (%eax),%eax
  8034d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034e2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034e7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	01 c8                	add    %ecx,%eax
  8034f3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034f5:	39 c2                	cmp    %eax,%edx
  8034f7:	75 09                	jne    803502 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8034f9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803500:	eb 12                	jmp    803514 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803502:	ff 45 e8             	incl   -0x18(%ebp)
  803505:	a1 20 50 80 00       	mov    0x805020,%eax
  80350a:	8b 50 74             	mov    0x74(%eax),%edx
  80350d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803510:	39 c2                	cmp    %eax,%edx
  803512:	77 88                	ja     80349c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803518:	75 14                	jne    80352e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80351a:	83 ec 04             	sub    $0x4,%esp
  80351d:	68 dc 3f 80 00       	push   $0x803fdc
  803522:	6a 3a                	push   $0x3a
  803524:	68 d0 3f 80 00       	push   $0x803fd0
  803529:	e8 93 fe ff ff       	call   8033c1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80352e:	ff 45 f0             	incl   -0x10(%ebp)
  803531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803534:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803537:	0f 8c 32 ff ff ff    	jl     80346f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80353d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803544:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80354b:	eb 26                	jmp    803573 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80354d:	a1 20 50 80 00       	mov    0x805020,%eax
  803552:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803558:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80355b:	89 d0                	mov    %edx,%eax
  80355d:	01 c0                	add    %eax,%eax
  80355f:	01 d0                	add    %edx,%eax
  803561:	c1 e0 03             	shl    $0x3,%eax
  803564:	01 c8                	add    %ecx,%eax
  803566:	8a 40 04             	mov    0x4(%eax),%al
  803569:	3c 01                	cmp    $0x1,%al
  80356b:	75 03                	jne    803570 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80356d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803570:	ff 45 e0             	incl   -0x20(%ebp)
  803573:	a1 20 50 80 00       	mov    0x805020,%eax
  803578:	8b 50 74             	mov    0x74(%eax),%edx
  80357b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357e:	39 c2                	cmp    %eax,%edx
  803580:	77 cb                	ja     80354d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803588:	74 14                	je     80359e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80358a:	83 ec 04             	sub    $0x4,%esp
  80358d:	68 30 40 80 00       	push   $0x804030
  803592:	6a 44                	push   $0x44
  803594:	68 d0 3f 80 00       	push   $0x803fd0
  803599:	e8 23 fe ff ff       	call   8033c1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80359e:	90                   	nop
  80359f:	c9                   	leave  
  8035a0:	c3                   	ret    
  8035a1:	66 90                	xchg   %ax,%ax
  8035a3:	90                   	nop

008035a4 <__udivdi3>:
  8035a4:	55                   	push   %ebp
  8035a5:	57                   	push   %edi
  8035a6:	56                   	push   %esi
  8035a7:	53                   	push   %ebx
  8035a8:	83 ec 1c             	sub    $0x1c,%esp
  8035ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8035af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8035b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035bb:	89 ca                	mov    %ecx,%edx
  8035bd:	89 f8                	mov    %edi,%eax
  8035bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035c3:	85 f6                	test   %esi,%esi
  8035c5:	75 2d                	jne    8035f4 <__udivdi3+0x50>
  8035c7:	39 cf                	cmp    %ecx,%edi
  8035c9:	77 65                	ja     803630 <__udivdi3+0x8c>
  8035cb:	89 fd                	mov    %edi,%ebp
  8035cd:	85 ff                	test   %edi,%edi
  8035cf:	75 0b                	jne    8035dc <__udivdi3+0x38>
  8035d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d6:	31 d2                	xor    %edx,%edx
  8035d8:	f7 f7                	div    %edi
  8035da:	89 c5                	mov    %eax,%ebp
  8035dc:	31 d2                	xor    %edx,%edx
  8035de:	89 c8                	mov    %ecx,%eax
  8035e0:	f7 f5                	div    %ebp
  8035e2:	89 c1                	mov    %eax,%ecx
  8035e4:	89 d8                	mov    %ebx,%eax
  8035e6:	f7 f5                	div    %ebp
  8035e8:	89 cf                	mov    %ecx,%edi
  8035ea:	89 fa                	mov    %edi,%edx
  8035ec:	83 c4 1c             	add    $0x1c,%esp
  8035ef:	5b                   	pop    %ebx
  8035f0:	5e                   	pop    %esi
  8035f1:	5f                   	pop    %edi
  8035f2:	5d                   	pop    %ebp
  8035f3:	c3                   	ret    
  8035f4:	39 ce                	cmp    %ecx,%esi
  8035f6:	77 28                	ja     803620 <__udivdi3+0x7c>
  8035f8:	0f bd fe             	bsr    %esi,%edi
  8035fb:	83 f7 1f             	xor    $0x1f,%edi
  8035fe:	75 40                	jne    803640 <__udivdi3+0x9c>
  803600:	39 ce                	cmp    %ecx,%esi
  803602:	72 0a                	jb     80360e <__udivdi3+0x6a>
  803604:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803608:	0f 87 9e 00 00 00    	ja     8036ac <__udivdi3+0x108>
  80360e:	b8 01 00 00 00       	mov    $0x1,%eax
  803613:	89 fa                	mov    %edi,%edx
  803615:	83 c4 1c             	add    $0x1c,%esp
  803618:	5b                   	pop    %ebx
  803619:	5e                   	pop    %esi
  80361a:	5f                   	pop    %edi
  80361b:	5d                   	pop    %ebp
  80361c:	c3                   	ret    
  80361d:	8d 76 00             	lea    0x0(%esi),%esi
  803620:	31 ff                	xor    %edi,%edi
  803622:	31 c0                	xor    %eax,%eax
  803624:	89 fa                	mov    %edi,%edx
  803626:	83 c4 1c             	add    $0x1c,%esp
  803629:	5b                   	pop    %ebx
  80362a:	5e                   	pop    %esi
  80362b:	5f                   	pop    %edi
  80362c:	5d                   	pop    %ebp
  80362d:	c3                   	ret    
  80362e:	66 90                	xchg   %ax,%ax
  803630:	89 d8                	mov    %ebx,%eax
  803632:	f7 f7                	div    %edi
  803634:	31 ff                	xor    %edi,%edi
  803636:	89 fa                	mov    %edi,%edx
  803638:	83 c4 1c             	add    $0x1c,%esp
  80363b:	5b                   	pop    %ebx
  80363c:	5e                   	pop    %esi
  80363d:	5f                   	pop    %edi
  80363e:	5d                   	pop    %ebp
  80363f:	c3                   	ret    
  803640:	bd 20 00 00 00       	mov    $0x20,%ebp
  803645:	89 eb                	mov    %ebp,%ebx
  803647:	29 fb                	sub    %edi,%ebx
  803649:	89 f9                	mov    %edi,%ecx
  80364b:	d3 e6                	shl    %cl,%esi
  80364d:	89 c5                	mov    %eax,%ebp
  80364f:	88 d9                	mov    %bl,%cl
  803651:	d3 ed                	shr    %cl,%ebp
  803653:	89 e9                	mov    %ebp,%ecx
  803655:	09 f1                	or     %esi,%ecx
  803657:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80365b:	89 f9                	mov    %edi,%ecx
  80365d:	d3 e0                	shl    %cl,%eax
  80365f:	89 c5                	mov    %eax,%ebp
  803661:	89 d6                	mov    %edx,%esi
  803663:	88 d9                	mov    %bl,%cl
  803665:	d3 ee                	shr    %cl,%esi
  803667:	89 f9                	mov    %edi,%ecx
  803669:	d3 e2                	shl    %cl,%edx
  80366b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80366f:	88 d9                	mov    %bl,%cl
  803671:	d3 e8                	shr    %cl,%eax
  803673:	09 c2                	or     %eax,%edx
  803675:	89 d0                	mov    %edx,%eax
  803677:	89 f2                	mov    %esi,%edx
  803679:	f7 74 24 0c          	divl   0xc(%esp)
  80367d:	89 d6                	mov    %edx,%esi
  80367f:	89 c3                	mov    %eax,%ebx
  803681:	f7 e5                	mul    %ebp
  803683:	39 d6                	cmp    %edx,%esi
  803685:	72 19                	jb     8036a0 <__udivdi3+0xfc>
  803687:	74 0b                	je     803694 <__udivdi3+0xf0>
  803689:	89 d8                	mov    %ebx,%eax
  80368b:	31 ff                	xor    %edi,%edi
  80368d:	e9 58 ff ff ff       	jmp    8035ea <__udivdi3+0x46>
  803692:	66 90                	xchg   %ax,%ax
  803694:	8b 54 24 08          	mov    0x8(%esp),%edx
  803698:	89 f9                	mov    %edi,%ecx
  80369a:	d3 e2                	shl    %cl,%edx
  80369c:	39 c2                	cmp    %eax,%edx
  80369e:	73 e9                	jae    803689 <__udivdi3+0xe5>
  8036a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036a3:	31 ff                	xor    %edi,%edi
  8036a5:	e9 40 ff ff ff       	jmp    8035ea <__udivdi3+0x46>
  8036aa:	66 90                	xchg   %ax,%ax
  8036ac:	31 c0                	xor    %eax,%eax
  8036ae:	e9 37 ff ff ff       	jmp    8035ea <__udivdi3+0x46>
  8036b3:	90                   	nop

008036b4 <__umoddi3>:
  8036b4:	55                   	push   %ebp
  8036b5:	57                   	push   %edi
  8036b6:	56                   	push   %esi
  8036b7:	53                   	push   %ebx
  8036b8:	83 ec 1c             	sub    $0x1c,%esp
  8036bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036d3:	89 f3                	mov    %esi,%ebx
  8036d5:	89 fa                	mov    %edi,%edx
  8036d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036db:	89 34 24             	mov    %esi,(%esp)
  8036de:	85 c0                	test   %eax,%eax
  8036e0:	75 1a                	jne    8036fc <__umoddi3+0x48>
  8036e2:	39 f7                	cmp    %esi,%edi
  8036e4:	0f 86 a2 00 00 00    	jbe    80378c <__umoddi3+0xd8>
  8036ea:	89 c8                	mov    %ecx,%eax
  8036ec:	89 f2                	mov    %esi,%edx
  8036ee:	f7 f7                	div    %edi
  8036f0:	89 d0                	mov    %edx,%eax
  8036f2:	31 d2                	xor    %edx,%edx
  8036f4:	83 c4 1c             	add    $0x1c,%esp
  8036f7:	5b                   	pop    %ebx
  8036f8:	5e                   	pop    %esi
  8036f9:	5f                   	pop    %edi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    
  8036fc:	39 f0                	cmp    %esi,%eax
  8036fe:	0f 87 ac 00 00 00    	ja     8037b0 <__umoddi3+0xfc>
  803704:	0f bd e8             	bsr    %eax,%ebp
  803707:	83 f5 1f             	xor    $0x1f,%ebp
  80370a:	0f 84 ac 00 00 00    	je     8037bc <__umoddi3+0x108>
  803710:	bf 20 00 00 00       	mov    $0x20,%edi
  803715:	29 ef                	sub    %ebp,%edi
  803717:	89 fe                	mov    %edi,%esi
  803719:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80371d:	89 e9                	mov    %ebp,%ecx
  80371f:	d3 e0                	shl    %cl,%eax
  803721:	89 d7                	mov    %edx,%edi
  803723:	89 f1                	mov    %esi,%ecx
  803725:	d3 ef                	shr    %cl,%edi
  803727:	09 c7                	or     %eax,%edi
  803729:	89 e9                	mov    %ebp,%ecx
  80372b:	d3 e2                	shl    %cl,%edx
  80372d:	89 14 24             	mov    %edx,(%esp)
  803730:	89 d8                	mov    %ebx,%eax
  803732:	d3 e0                	shl    %cl,%eax
  803734:	89 c2                	mov    %eax,%edx
  803736:	8b 44 24 08          	mov    0x8(%esp),%eax
  80373a:	d3 e0                	shl    %cl,%eax
  80373c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803740:	8b 44 24 08          	mov    0x8(%esp),%eax
  803744:	89 f1                	mov    %esi,%ecx
  803746:	d3 e8                	shr    %cl,%eax
  803748:	09 d0                	or     %edx,%eax
  80374a:	d3 eb                	shr    %cl,%ebx
  80374c:	89 da                	mov    %ebx,%edx
  80374e:	f7 f7                	div    %edi
  803750:	89 d3                	mov    %edx,%ebx
  803752:	f7 24 24             	mull   (%esp)
  803755:	89 c6                	mov    %eax,%esi
  803757:	89 d1                	mov    %edx,%ecx
  803759:	39 d3                	cmp    %edx,%ebx
  80375b:	0f 82 87 00 00 00    	jb     8037e8 <__umoddi3+0x134>
  803761:	0f 84 91 00 00 00    	je     8037f8 <__umoddi3+0x144>
  803767:	8b 54 24 04          	mov    0x4(%esp),%edx
  80376b:	29 f2                	sub    %esi,%edx
  80376d:	19 cb                	sbb    %ecx,%ebx
  80376f:	89 d8                	mov    %ebx,%eax
  803771:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803775:	d3 e0                	shl    %cl,%eax
  803777:	89 e9                	mov    %ebp,%ecx
  803779:	d3 ea                	shr    %cl,%edx
  80377b:	09 d0                	or     %edx,%eax
  80377d:	89 e9                	mov    %ebp,%ecx
  80377f:	d3 eb                	shr    %cl,%ebx
  803781:	89 da                	mov    %ebx,%edx
  803783:	83 c4 1c             	add    $0x1c,%esp
  803786:	5b                   	pop    %ebx
  803787:	5e                   	pop    %esi
  803788:	5f                   	pop    %edi
  803789:	5d                   	pop    %ebp
  80378a:	c3                   	ret    
  80378b:	90                   	nop
  80378c:	89 fd                	mov    %edi,%ebp
  80378e:	85 ff                	test   %edi,%edi
  803790:	75 0b                	jne    80379d <__umoddi3+0xe9>
  803792:	b8 01 00 00 00       	mov    $0x1,%eax
  803797:	31 d2                	xor    %edx,%edx
  803799:	f7 f7                	div    %edi
  80379b:	89 c5                	mov    %eax,%ebp
  80379d:	89 f0                	mov    %esi,%eax
  80379f:	31 d2                	xor    %edx,%edx
  8037a1:	f7 f5                	div    %ebp
  8037a3:	89 c8                	mov    %ecx,%eax
  8037a5:	f7 f5                	div    %ebp
  8037a7:	89 d0                	mov    %edx,%eax
  8037a9:	e9 44 ff ff ff       	jmp    8036f2 <__umoddi3+0x3e>
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	89 c8                	mov    %ecx,%eax
  8037b2:	89 f2                	mov    %esi,%edx
  8037b4:	83 c4 1c             	add    $0x1c,%esp
  8037b7:	5b                   	pop    %ebx
  8037b8:	5e                   	pop    %esi
  8037b9:	5f                   	pop    %edi
  8037ba:	5d                   	pop    %ebp
  8037bb:	c3                   	ret    
  8037bc:	3b 04 24             	cmp    (%esp),%eax
  8037bf:	72 06                	jb     8037c7 <__umoddi3+0x113>
  8037c1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037c5:	77 0f                	ja     8037d6 <__umoddi3+0x122>
  8037c7:	89 f2                	mov    %esi,%edx
  8037c9:	29 f9                	sub    %edi,%ecx
  8037cb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037cf:	89 14 24             	mov    %edx,(%esp)
  8037d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037d6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037da:	8b 14 24             	mov    (%esp),%edx
  8037dd:	83 c4 1c             	add    $0x1c,%esp
  8037e0:	5b                   	pop    %ebx
  8037e1:	5e                   	pop    %esi
  8037e2:	5f                   	pop    %edi
  8037e3:	5d                   	pop    %ebp
  8037e4:	c3                   	ret    
  8037e5:	8d 76 00             	lea    0x0(%esi),%esi
  8037e8:	2b 04 24             	sub    (%esp),%eax
  8037eb:	19 fa                	sbb    %edi,%edx
  8037ed:	89 d1                	mov    %edx,%ecx
  8037ef:	89 c6                	mov    %eax,%esi
  8037f1:	e9 71 ff ff ff       	jmp    803767 <__umoddi3+0xb3>
  8037f6:	66 90                	xchg   %ax,%ax
  8037f8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037fc:	72 ea                	jb     8037e8 <__umoddi3+0x134>
  8037fe:	89 d9                	mov    %ebx,%ecx
  803800:	e9 62 ff ff ff       	jmp    803767 <__umoddi3+0xb3>
