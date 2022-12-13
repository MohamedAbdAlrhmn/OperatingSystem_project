
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 67 18 00 00       	call   8018aa <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 80 36 80 00       	push   $0x803680
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 b7 13 00 00       	call   80140d <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 82 36 80 00       	push   $0x803682
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 a1 13 00 00       	call   80140d <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 89 36 80 00       	push   $0x803689
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 8b 13 00 00       	call   80140d <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 49 18 00 00       	call   8018dd <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 b7 30 00 00       	call   803173 <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 08 18 00 00       	call   8018dd <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 76 30 00 00       	call   803173 <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 c9 17 00 00       	call   8018dd <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 37 30 00 00       	call   803173 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 97 36 80 00       	push   $0x803697
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 10 16 00 00       	call   801769 <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 1a 17 00 00       	call   801891 <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 bc 14 00 00       	call   80169e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 b4 36 80 00       	push   $0x8036b4
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 dc 36 80 00       	push   $0x8036dc
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 04 37 80 00       	push   $0x803704
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 5c 37 80 00       	push   $0x80375c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 b4 36 80 00       	push   $0x8036b4
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 3c 14 00 00       	call   8016b8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 c9 15 00 00       	call   80185d <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 1e 16 00 00       	call   8018c3 <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 fd 11 00 00       	call   8014f0 <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 86 11 00 00       	call   8014f0 <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 ea 12 00 00       	call   80169e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 e4 12 00 00       	call   8016b8 <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 ea 2f 00 00       	call   803408 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 aa 30 00 00       	call   803518 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 94 39 80 00       	add    $0x803994,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 a5 39 80 00       	push   $0x8039a5
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 ae 39 80 00       	push   $0x8039ae
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 10 3b 80 00       	push   $0x803b10
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80113d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801144:	00 00 00 
  801147:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114e:	00 00 00 
  801151:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801158:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801162:	00 00 00 
  801165:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116c:	00 00 00 
  80116f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801176:	00 00 00 
	uint32 arr_size = 0;
  801179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801180:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801187:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80118a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80118f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801194:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801199:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8011a0:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8011a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8011aa:	a1 20 41 80 00       	mov    0x804120,%eax
  8011af:	c1 e0 04             	shl    $0x4,%eax
  8011b2:	89 c2                	mov    %eax,%edx
  8011b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b7:	01 d0                	add    %edx,%eax
  8011b9:	48                   	dec    %eax
  8011ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8011bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c5:	f7 75 ec             	divl   -0x14(%ebp)
  8011c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011cb:	29 d0                	sub    %edx,%eax
  8011cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8011d0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011e4:	83 ec 04             	sub    $0x4,%esp
  8011e7:	6a 06                	push   $0x6
  8011e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011ec:	50                   	push   %eax
  8011ed:	e8 42 04 00 00       	call   801634 <sys_allocate_chunk>
  8011f2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	e8 b7 0a 00 00       	call   801cba <initialize_MemBlocksList>
  801203:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801206:	a1 48 41 80 00       	mov    0x804148,%eax
  80120b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80120e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801211:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801218:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801222:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801226:	75 14                	jne    80123c <initialize_dyn_block_system+0x105>
  801228:	83 ec 04             	sub    $0x4,%esp
  80122b:	68 35 3b 80 00       	push   $0x803b35
  801230:	6a 33                	push   $0x33
  801232:	68 53 3b 80 00       	push   $0x803b53
  801237:	e8 eb 1f 00 00       	call   803227 <_panic>
  80123c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	85 c0                	test   %eax,%eax
  801243:	74 10                	je     801255 <initialize_dyn_block_system+0x11e>
  801245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801248:	8b 00                	mov    (%eax),%eax
  80124a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80124d:	8b 52 04             	mov    0x4(%edx),%edx
  801250:	89 50 04             	mov    %edx,0x4(%eax)
  801253:	eb 0b                	jmp    801260 <initialize_dyn_block_system+0x129>
  801255:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801258:	8b 40 04             	mov    0x4(%eax),%eax
  80125b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801260:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801263:	8b 40 04             	mov    0x4(%eax),%eax
  801266:	85 c0                	test   %eax,%eax
  801268:	74 0f                	je     801279 <initialize_dyn_block_system+0x142>
  80126a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126d:	8b 40 04             	mov    0x4(%eax),%eax
  801270:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801273:	8b 12                	mov    (%edx),%edx
  801275:	89 10                	mov    %edx,(%eax)
  801277:	eb 0a                	jmp    801283 <initialize_dyn_block_system+0x14c>
  801279:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80127c:	8b 00                	mov    (%eax),%eax
  80127e:	a3 48 41 80 00       	mov    %eax,0x804148
  801283:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801286:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80128c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801296:	a1 54 41 80 00       	mov    0x804154,%eax
  80129b:	48                   	dec    %eax
  80129c:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8012a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012a5:	75 14                	jne    8012bb <initialize_dyn_block_system+0x184>
  8012a7:	83 ec 04             	sub    $0x4,%esp
  8012aa:	68 60 3b 80 00       	push   $0x803b60
  8012af:	6a 34                	push   $0x34
  8012b1:	68 53 3b 80 00       	push   $0x803b53
  8012b6:	e8 6c 1f 00 00       	call   803227 <_panic>
  8012bb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c4:	89 10                	mov    %edx,(%eax)
  8012c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c9:	8b 00                	mov    (%eax),%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 0d                	je     8012dc <initialize_dyn_block_system+0x1a5>
  8012cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8012d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012d7:	89 50 04             	mov    %edx,0x4(%eax)
  8012da:	eb 08                	jmp    8012e4 <initialize_dyn_block_system+0x1ad>
  8012dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012df:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e7:	a3 38 41 80 00       	mov    %eax,0x804138
  8012ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012f6:	a1 44 41 80 00       	mov    0x804144,%eax
  8012fb:	40                   	inc    %eax
  8012fc:	a3 44 41 80 00       	mov    %eax,0x804144
}
  801301:	90                   	nop
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80130a:	e8 f7 fd ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  80130f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801313:	75 07                	jne    80131c <malloc+0x18>
  801315:	b8 00 00 00 00       	mov    $0x0,%eax
  80131a:	eb 14                	jmp    801330 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80131c:	83 ec 04             	sub    $0x4,%esp
  80131f:	68 84 3b 80 00       	push   $0x803b84
  801324:	6a 46                	push   $0x46
  801326:	68 53 3b 80 00       	push   $0x803b53
  80132b:	e8 f7 1e 00 00       	call   803227 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
  801335:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801338:	83 ec 04             	sub    $0x4,%esp
  80133b:	68 ac 3b 80 00       	push   $0x803bac
  801340:	6a 61                	push   $0x61
  801342:	68 53 3b 80 00       	push   $0x803b53
  801347:	e8 db 1e 00 00       	call   803227 <_panic>

0080134c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 38             	sub    $0x38,%esp
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801358:	e8 a9 fd ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  80135d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801361:	75 0a                	jne    80136d <smalloc+0x21>
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	e9 9e 00 00 00       	jmp    80140b <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80136d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137a:	01 d0                	add    %edx,%eax
  80137c:	48                   	dec    %eax
  80137d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801380:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801383:	ba 00 00 00 00       	mov    $0x0,%edx
  801388:	f7 75 f0             	divl   -0x10(%ebp)
  80138b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138e:	29 d0                	sub    %edx,%eax
  801390:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801393:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80139a:	e8 63 06 00 00       	call   801a02 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80139f:	85 c0                	test   %eax,%eax
  8013a1:	74 11                	je     8013b4 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a9:	e8 ce 0c 00 00       	call   80207c <alloc_block_FF>
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8013b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013b8:	74 4c                	je     801406 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8013ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013bd:	8b 40 08             	mov    0x8(%eax),%eax
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8013c6:	52                   	push   %edx
  8013c7:	50                   	push   %eax
  8013c8:	ff 75 0c             	pushl  0xc(%ebp)
  8013cb:	ff 75 08             	pushl  0x8(%ebp)
  8013ce:	e8 b4 03 00 00       	call   801787 <sys_createSharedObject>
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8013d9:	83 ec 08             	sub    $0x8,%esp
  8013dc:	ff 75 e0             	pushl  -0x20(%ebp)
  8013df:	68 cf 3b 80 00       	push   $0x803bcf
  8013e4:	e8 93 ef ff ff       	call   80037c <cprintf>
  8013e9:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8013ec:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8013f0:	74 14                	je     801406 <smalloc+0xba>
  8013f2:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8013f6:	74 0e                	je     801406 <smalloc+0xba>
  8013f8:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8013fc:	74 08                	je     801406 <smalloc+0xba>
			return (void*) mem_block->sva;
  8013fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801401:	8b 40 08             	mov    0x8(%eax),%eax
  801404:	eb 05                	jmp    80140b <smalloc+0xbf>
	}
	return NULL;
  801406:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801413:	e8 ee fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801418:	83 ec 04             	sub    $0x4,%esp
  80141b:	68 e4 3b 80 00       	push   $0x803be4
  801420:	68 ab 00 00 00       	push   $0xab
  801425:	68 53 3b 80 00       	push   $0x803b53
  80142a:	e8 f8 1d 00 00       	call   803227 <_panic>

0080142f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801435:	e8 cc fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 08 3c 80 00       	push   $0x803c08
  801442:	68 ef 00 00 00       	push   $0xef
  801447:	68 53 3b 80 00       	push   $0x803b53
  80144c:	e8 d6 1d 00 00       	call   803227 <_panic>

00801451 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801457:	83 ec 04             	sub    $0x4,%esp
  80145a:	68 30 3c 80 00       	push   $0x803c30
  80145f:	68 03 01 00 00       	push   $0x103
  801464:	68 53 3b 80 00       	push   $0x803b53
  801469:	e8 b9 1d 00 00       	call   803227 <_panic>

0080146e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	68 54 3c 80 00       	push   $0x803c54
  80147c:	68 0e 01 00 00       	push   $0x10e
  801481:	68 53 3b 80 00       	push   $0x803b53
  801486:	e8 9c 1d 00 00       	call   803227 <_panic>

0080148b <shrink>:

}
void shrink(uint32 newSize)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
  80148e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	68 54 3c 80 00       	push   $0x803c54
  801499:	68 13 01 00 00       	push   $0x113
  80149e:	68 53 3b 80 00       	push   $0x803b53
  8014a3:	e8 7f 1d 00 00       	call   803227 <_panic>

008014a8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014ae:	83 ec 04             	sub    $0x4,%esp
  8014b1:	68 54 3c 80 00       	push   $0x803c54
  8014b6:	68 18 01 00 00       	push   $0x118
  8014bb:	68 53 3b 80 00       	push   $0x803b53
  8014c0:	e8 62 1d 00 00       	call   803227 <_panic>

008014c5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	57                   	push   %edi
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014da:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014dd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014e0:	cd 30                	int    $0x30
  8014e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	5b                   	pop    %ebx
  8014ec:	5e                   	pop    %esi
  8014ed:	5f                   	pop    %edi
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	6a 00                	push   $0x0
  801505:	6a 00                	push   $0x0
  801507:	52                   	push   %edx
  801508:	ff 75 0c             	pushl  0xc(%ebp)
  80150b:	50                   	push   %eax
  80150c:	6a 00                	push   $0x0
  80150e:	e8 b2 ff ff ff       	call   8014c5 <syscall>
  801513:	83 c4 18             	add    $0x18,%esp
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_cgetc>:

int
sys_cgetc(void)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 01                	push   $0x1
  801528:	e8 98 ff ff ff       	call   8014c5 <syscall>
  80152d:	83 c4 18             	add    $0x18,%esp
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801535:	8b 55 0c             	mov    0xc(%ebp),%edx
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	6a 05                	push   $0x5
  801545:	e8 7b ff ff ff       	call   8014c5 <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801554:	8b 75 18             	mov    0x18(%ebp),%esi
  801557:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
  801565:	51                   	push   %ecx
  801566:	52                   	push   %edx
  801567:	50                   	push   %eax
  801568:	6a 06                	push   $0x6
  80156a:	e8 56 ff ff ff       	call   8014c5 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801575:	5b                   	pop    %ebx
  801576:	5e                   	pop    %esi
  801577:	5d                   	pop    %ebp
  801578:	c3                   	ret    

00801579 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80157c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	52                   	push   %edx
  801589:	50                   	push   %eax
  80158a:	6a 07                	push   $0x7
  80158c:	e8 34 ff ff ff       	call   8014c5 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	ff 75 08             	pushl  0x8(%ebp)
  8015a5:	6a 08                	push   $0x8
  8015a7:	e8 19 ff ff ff       	call   8014c5 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 09                	push   $0x9
  8015c0:	e8 00 ff ff ff       	call   8014c5 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 0a                	push   $0xa
  8015d9:	e8 e7 fe ff ff       	call   8014c5 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 0b                	push   $0xb
  8015f2:	e8 ce fe ff ff       	call   8014c5 <syscall>
  8015f7:	83 c4 18             	add    $0x18,%esp
}
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	ff 75 0c             	pushl  0xc(%ebp)
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	6a 0f                	push   $0xf
  80160d:	e8 b3 fe ff ff       	call   8014c5 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
	return;
  801615:	90                   	nop
}
  801616:	c9                   	leave  
  801617:	c3                   	ret    

00801618 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	ff 75 08             	pushl  0x8(%ebp)
  801627:	6a 10                	push   $0x10
  801629:	e8 97 fe ff ff       	call   8014c5 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
	return ;
  801631:	90                   	nop
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	ff 75 10             	pushl  0x10(%ebp)
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	ff 75 08             	pushl  0x8(%ebp)
  801644:	6a 11                	push   $0x11
  801646:	e8 7a fe ff ff       	call   8014c5 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
	return ;
  80164e:	90                   	nop
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 0c                	push   $0xc
  801660:	e8 60 fe ff ff       	call   8014c5 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	6a 0d                	push   $0xd
  80167a:	e8 46 fe ff ff       	call   8014c5 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 0e                	push   $0xe
  801693:	e8 2d fe ff ff       	call   8014c5 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 13                	push   $0x13
  8016ad:	e8 13 fe ff ff       	call   8014c5 <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	90                   	nop
  8016b6:	c9                   	leave  
  8016b7:	c3                   	ret    

008016b8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016b8:	55                   	push   %ebp
  8016b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 14                	push   $0x14
  8016c7:	e8 f9 fd ff ff       	call   8014c5 <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	90                   	nop
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
  8016d5:	83 ec 04             	sub    $0x4,%esp
  8016d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	50                   	push   %eax
  8016eb:	6a 15                	push   $0x15
  8016ed:	e8 d3 fd ff ff       	call   8014c5 <syscall>
  8016f2:	83 c4 18             	add    $0x18,%esp
}
  8016f5:	90                   	nop
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	6a 16                	push   $0x16
  801707:	e8 b9 fd ff ff       	call   8014c5 <syscall>
  80170c:	83 c4 18             	add    $0x18,%esp
}
  80170f:	90                   	nop
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	ff 75 0c             	pushl  0xc(%ebp)
  801721:	50                   	push   %eax
  801722:	6a 17                	push   $0x17
  801724:	e8 9c fd ff ff       	call   8014c5 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801731:	8b 55 0c             	mov    0xc(%ebp),%edx
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	52                   	push   %edx
  80173e:	50                   	push   %eax
  80173f:	6a 1a                	push   $0x1a
  801741:	e8 7f fd ff ff       	call   8014c5 <syscall>
  801746:	83 c4 18             	add    $0x18,%esp
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80174e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	52                   	push   %edx
  80175b:	50                   	push   %eax
  80175c:	6a 18                	push   $0x18
  80175e:	e8 62 fd ff ff       	call   8014c5 <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80176c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	52                   	push   %edx
  801779:	50                   	push   %eax
  80177a:	6a 19                	push   $0x19
  80177c:	e8 44 fd ff ff       	call   8014c5 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	8b 45 10             	mov    0x10(%ebp),%eax
  801790:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801793:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801796:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	6a 00                	push   $0x0
  80179f:	51                   	push   %ecx
  8017a0:	52                   	push   %edx
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	50                   	push   %eax
  8017a5:	6a 1b                	push   $0x1b
  8017a7:	e8 19 fd ff ff       	call   8014c5 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	52                   	push   %edx
  8017c1:	50                   	push   %eax
  8017c2:	6a 1c                	push   $0x1c
  8017c4:	e8 fc fc ff ff       	call   8014c5 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	c9                   	leave  
  8017cd:	c3                   	ret    

008017ce <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	51                   	push   %ecx
  8017df:	52                   	push   %edx
  8017e0:	50                   	push   %eax
  8017e1:	6a 1d                	push   $0x1d
  8017e3:	e8 dd fc ff ff       	call   8014c5 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 1e                	push   $0x1e
  801800:	e8 c0 fc ff ff       	call   8014c5 <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 1f                	push   $0x1f
  801819:	e8 a7 fc ff ff       	call   8014c5 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	6a 00                	push   $0x0
  80182b:	ff 75 14             	pushl  0x14(%ebp)
  80182e:	ff 75 10             	pushl  0x10(%ebp)
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	50                   	push   %eax
  801835:	6a 20                	push   $0x20
  801837:	e8 89 fc ff ff       	call   8014c5 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801844:	8b 45 08             	mov    0x8(%ebp),%eax
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	50                   	push   %eax
  801850:	6a 21                	push   $0x21
  801852:	e8 6e fc ff ff       	call   8014c5 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	50                   	push   %eax
  80186c:	6a 22                	push   $0x22
  80186e:	e8 52 fc ff ff       	call   8014c5 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 02                	push   $0x2
  801887:	e8 39 fc ff ff       	call   8014c5 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 03                	push   $0x3
  8018a0:	e8 20 fc ff ff       	call   8014c5 <syscall>
  8018a5:	83 c4 18             	add    $0x18,%esp
}
  8018a8:	c9                   	leave  
  8018a9:	c3                   	ret    

008018aa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 04                	push   $0x4
  8018b9:	e8 07 fc ff ff       	call   8014c5 <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_exit_env>:


void sys_exit_env(void)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 23                	push   $0x23
  8018d2:	e8 ee fb ff ff       	call   8014c5 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	90                   	nop
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e6:	8d 50 04             	lea    0x4(%eax),%edx
  8018e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 24                	push   $0x24
  8018f6:	e8 ca fb ff ff       	call   8014c5 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
	return result;
  8018fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801901:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801904:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801907:	89 01                	mov    %eax,(%ecx)
  801909:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	c9                   	leave  
  801910:	c2 04 00             	ret    $0x4

00801913 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	ff 75 10             	pushl  0x10(%ebp)
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	6a 12                	push   $0x12
  801925:	e8 9b fb ff ff       	call   8014c5 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return ;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_rcr2>:
uint32 sys_rcr2()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 25                	push   $0x25
  80193f:	e8 81 fb ff ff       	call   8014c5 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 04             	sub    $0x4,%esp
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801955:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	50                   	push   %eax
  801962:	6a 26                	push   $0x26
  801964:	e8 5c fb ff ff       	call   8014c5 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return ;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <rsttst>:
void rsttst()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 28                	push   $0x28
  80197e:	e8 42 fb ff ff       	call   8014c5 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 04             	sub    $0x4,%esp
  80198f:	8b 45 14             	mov    0x14(%ebp),%eax
  801992:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801995:	8b 55 18             	mov    0x18(%ebp),%edx
  801998:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80199c:	52                   	push   %edx
  80199d:	50                   	push   %eax
  80199e:	ff 75 10             	pushl  0x10(%ebp)
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 27                	push   $0x27
  8019a9:	e8 17 fb ff ff       	call   8014c5 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b1:	90                   	nop
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <chktst>:
void chktst(uint32 n)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	6a 29                	push   $0x29
  8019c4:	e8 fc fa ff ff       	call   8014c5 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cc:	90                   	nop
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <inctst>:

void inctst()
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 2a                	push   $0x2a
  8019de:	e8 e2 fa ff ff       	call   8014c5 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e6:	90                   	nop
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <gettst>:
uint32 gettst()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 2b                	push   $0x2b
  8019f8:	e8 c8 fa ff ff       	call   8014c5 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 2c                	push   $0x2c
  801a14:	e8 ac fa ff ff       	call   8014c5 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
  801a1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a1f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a23:	75 07                	jne    801a2c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a25:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2a:	eb 05                	jmp    801a31 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 2c                	push   $0x2c
  801a45:	e8 7b fa ff ff       	call   8014c5 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
  801a4d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a50:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a54:	75 07                	jne    801a5d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a56:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5b:	eb 05                	jmp    801a62 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 2c                	push   $0x2c
  801a76:	e8 4a fa ff ff       	call   8014c5 <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
  801a7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a81:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a85:	75 07                	jne    801a8e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a87:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8c:	eb 05                	jmp    801a93 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 2c                	push   $0x2c
  801aa7:	e8 19 fa ff ff       	call   8014c5 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
  801aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ab2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ab6:	75 07                	jne    801abf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ab8:	b8 01 00 00 00       	mov    $0x1,%eax
  801abd:	eb 05                	jmp    801ac4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	ff 75 08             	pushl  0x8(%ebp)
  801ad4:	6a 2d                	push   $0x2d
  801ad6:	e8 ea f9 ff ff       	call   8014c5 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ade:	90                   	nop
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ae5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	53                   	push   %ebx
  801af4:	51                   	push   %ecx
  801af5:	52                   	push   %edx
  801af6:	50                   	push   %eax
  801af7:	6a 2e                	push   $0x2e
  801af9:	e8 c7 f9 ff ff       	call   8014c5 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 2f                	push   $0x2f
  801b19:	e8 a7 f9 ff ff       	call   8014c5 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	68 64 3c 80 00       	push   $0x803c64
  801b31:	e8 46 e8 ff ff       	call   80037c <cprintf>
  801b36:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b39:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b40:	83 ec 0c             	sub    $0xc,%esp
  801b43:	68 90 3c 80 00       	push   $0x803c90
  801b48:	e8 2f e8 ff ff       	call   80037c <cprintf>
  801b4d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b50:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b54:	a1 38 41 80 00       	mov    0x804138,%eax
  801b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b5c:	eb 56                	jmp    801bb4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b62:	74 1c                	je     801b80 <print_mem_block_lists+0x5d>
  801b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b67:	8b 50 08             	mov    0x8(%eax),%edx
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b6d:	8b 48 08             	mov    0x8(%eax),%ecx
  801b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b73:	8b 40 0c             	mov    0xc(%eax),%eax
  801b76:	01 c8                	add    %ecx,%eax
  801b78:	39 c2                	cmp    %eax,%edx
  801b7a:	73 04                	jae    801b80 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801b7c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b83:	8b 50 08             	mov    0x8(%eax),%edx
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8c:	01 c2                	add    %eax,%edx
  801b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b91:	8b 40 08             	mov    0x8(%eax),%eax
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	68 a5 3c 80 00       	push   $0x803ca5
  801b9e:	e8 d9 e7 ff ff       	call   80037c <cprintf>
  801ba3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801bac:	a1 40 41 80 00       	mov    0x804140,%eax
  801bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb8:	74 07                	je     801bc1 <print_mem_block_lists+0x9e>
  801bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	eb 05                	jmp    801bc6 <print_mem_block_lists+0xa3>
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc6:	a3 40 41 80 00       	mov    %eax,0x804140
  801bcb:	a1 40 41 80 00       	mov    0x804140,%eax
  801bd0:	85 c0                	test   %eax,%eax
  801bd2:	75 8a                	jne    801b5e <print_mem_block_lists+0x3b>
  801bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd8:	75 84                	jne    801b5e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801bda:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801bde:	75 10                	jne    801bf0 <print_mem_block_lists+0xcd>
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	68 b4 3c 80 00       	push   $0x803cb4
  801be8:	e8 8f e7 ff ff       	call   80037c <cprintf>
  801bed:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801bf0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801bf7:	83 ec 0c             	sub    $0xc,%esp
  801bfa:	68 d8 3c 80 00       	push   $0x803cd8
  801bff:	e8 78 e7 ff ff       	call   80037c <cprintf>
  801c04:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801c07:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c0b:	a1 40 40 80 00       	mov    0x804040,%eax
  801c10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c13:	eb 56                	jmp    801c6b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c19:	74 1c                	je     801c37 <print_mem_block_lists+0x114>
  801c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1e:	8b 50 08             	mov    0x8(%eax),%edx
  801c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c24:	8b 48 08             	mov    0x8(%eax),%ecx
  801c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2d:	01 c8                	add    %ecx,%eax
  801c2f:	39 c2                	cmp    %eax,%edx
  801c31:	73 04                	jae    801c37 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c33:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3a:	8b 50 08             	mov    0x8(%eax),%edx
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	8b 40 0c             	mov    0xc(%eax),%eax
  801c43:	01 c2                	add    %eax,%edx
  801c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c48:	8b 40 08             	mov    0x8(%eax),%eax
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	68 a5 3c 80 00       	push   $0x803ca5
  801c55:	e8 22 e7 ff ff       	call   80037c <cprintf>
  801c5a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c63:	a1 48 40 80 00       	mov    0x804048,%eax
  801c68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6f:	74 07                	je     801c78 <print_mem_block_lists+0x155>
  801c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	eb 05                	jmp    801c7d <print_mem_block_lists+0x15a>
  801c78:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7d:	a3 48 40 80 00       	mov    %eax,0x804048
  801c82:	a1 48 40 80 00       	mov    0x804048,%eax
  801c87:	85 c0                	test   %eax,%eax
  801c89:	75 8a                	jne    801c15 <print_mem_block_lists+0xf2>
  801c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c8f:	75 84                	jne    801c15 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c91:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c95:	75 10                	jne    801ca7 <print_mem_block_lists+0x184>
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	68 f0 3c 80 00       	push   $0x803cf0
  801c9f:	e8 d8 e6 ff ff       	call   80037c <cprintf>
  801ca4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	68 64 3c 80 00       	push   $0x803c64
  801caf:	e8 c8 e6 ff ff       	call   80037c <cprintf>
  801cb4:	83 c4 10             	add    $0x10,%esp

}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801cc0:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801cc7:	00 00 00 
  801cca:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801cd1:	00 00 00 
  801cd4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801cdb:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801cde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ce5:	e9 9e 00 00 00       	jmp    801d88 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801cea:	a1 50 40 80 00       	mov    0x804050,%eax
  801cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf2:	c1 e2 04             	shl    $0x4,%edx
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	75 14                	jne    801d0f <initialize_MemBlocksList+0x55>
  801cfb:	83 ec 04             	sub    $0x4,%esp
  801cfe:	68 18 3d 80 00       	push   $0x803d18
  801d03:	6a 46                	push   $0x46
  801d05:	68 3b 3d 80 00       	push   $0x803d3b
  801d0a:	e8 18 15 00 00       	call   803227 <_panic>
  801d0f:	a1 50 40 80 00       	mov    0x804050,%eax
  801d14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d17:	c1 e2 04             	shl    $0x4,%edx
  801d1a:	01 d0                	add    %edx,%eax
  801d1c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801d22:	89 10                	mov    %edx,(%eax)
  801d24:	8b 00                	mov    (%eax),%eax
  801d26:	85 c0                	test   %eax,%eax
  801d28:	74 18                	je     801d42 <initialize_MemBlocksList+0x88>
  801d2a:	a1 48 41 80 00       	mov    0x804148,%eax
  801d2f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d35:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d38:	c1 e1 04             	shl    $0x4,%ecx
  801d3b:	01 ca                	add    %ecx,%edx
  801d3d:	89 50 04             	mov    %edx,0x4(%eax)
  801d40:	eb 12                	jmp    801d54 <initialize_MemBlocksList+0x9a>
  801d42:	a1 50 40 80 00       	mov    0x804050,%eax
  801d47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4a:	c1 e2 04             	shl    $0x4,%edx
  801d4d:	01 d0                	add    %edx,%eax
  801d4f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d54:	a1 50 40 80 00       	mov    0x804050,%eax
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	c1 e2 04             	shl    $0x4,%edx
  801d5f:	01 d0                	add    %edx,%eax
  801d61:	a3 48 41 80 00       	mov    %eax,0x804148
  801d66:	a1 50 40 80 00       	mov    0x804050,%eax
  801d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d6e:	c1 e2 04             	shl    $0x4,%edx
  801d71:	01 d0                	add    %edx,%eax
  801d73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d7a:	a1 54 41 80 00       	mov    0x804154,%eax
  801d7f:	40                   	inc    %eax
  801d80:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801d85:	ff 45 f4             	incl   -0xc(%ebp)
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d8e:	0f 82 56 ff ff ff    	jb     801cea <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d94:	90                   	nop
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	8b 00                	mov    (%eax),%eax
  801da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801da5:	eb 19                	jmp    801dc0 <find_block+0x29>
	{
		if(va==point->sva)
  801da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801daa:	8b 40 08             	mov    0x8(%eax),%eax
  801dad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801db0:	75 05                	jne    801db7 <find_block+0x20>
		   return point;
  801db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801db5:	eb 36                	jmp    801ded <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	8b 40 08             	mov    0x8(%eax),%eax
  801dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801dc0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dc4:	74 07                	je     801dcd <find_block+0x36>
  801dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dc9:	8b 00                	mov    (%eax),%eax
  801dcb:	eb 05                	jmp    801dd2 <find_block+0x3b>
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  801dd5:	89 42 08             	mov    %eax,0x8(%edx)
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	8b 40 08             	mov    0x8(%eax),%eax
  801dde:	85 c0                	test   %eax,%eax
  801de0:	75 c5                	jne    801da7 <find_block+0x10>
  801de2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801de6:	75 bf                	jne    801da7 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801df5:	a1 40 40 80 00       	mov    0x804040,%eax
  801dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801dfd:	a1 44 40 80 00       	mov    0x804044,%eax
  801e02:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e0b:	74 24                	je     801e31 <insert_sorted_allocList+0x42>
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	8b 50 08             	mov    0x8(%eax),%edx
  801e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e16:	8b 40 08             	mov    0x8(%eax),%eax
  801e19:	39 c2                	cmp    %eax,%edx
  801e1b:	76 14                	jbe    801e31 <insert_sorted_allocList+0x42>
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	8b 50 08             	mov    0x8(%eax),%edx
  801e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e26:	8b 40 08             	mov    0x8(%eax),%eax
  801e29:	39 c2                	cmp    %eax,%edx
  801e2b:	0f 82 60 01 00 00    	jb     801f91 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e35:	75 65                	jne    801e9c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e3b:	75 14                	jne    801e51 <insert_sorted_allocList+0x62>
  801e3d:	83 ec 04             	sub    $0x4,%esp
  801e40:	68 18 3d 80 00       	push   $0x803d18
  801e45:	6a 6b                	push   $0x6b
  801e47:	68 3b 3d 80 00       	push   $0x803d3b
  801e4c:	e8 d6 13 00 00       	call   803227 <_panic>
  801e51:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	89 10                	mov    %edx,(%eax)
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	74 0d                	je     801e72 <insert_sorted_allocList+0x83>
  801e65:	a1 40 40 80 00       	mov    0x804040,%eax
  801e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6d:	89 50 04             	mov    %edx,0x4(%eax)
  801e70:	eb 08                	jmp    801e7a <insert_sorted_allocList+0x8b>
  801e72:	8b 45 08             	mov    0x8(%ebp),%eax
  801e75:	a3 44 40 80 00       	mov    %eax,0x804044
  801e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7d:	a3 40 40 80 00       	mov    %eax,0x804040
  801e82:	8b 45 08             	mov    0x8(%ebp),%eax
  801e85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e8c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e91:	40                   	inc    %eax
  801e92:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e97:	e9 dc 01 00 00       	jmp    802078 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	8b 50 08             	mov    0x8(%eax),%edx
  801ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea5:	8b 40 08             	mov    0x8(%eax),%eax
  801ea8:	39 c2                	cmp    %eax,%edx
  801eaa:	77 6c                	ja     801f18 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801eac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb0:	74 06                	je     801eb8 <insert_sorted_allocList+0xc9>
  801eb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eb6:	75 14                	jne    801ecc <insert_sorted_allocList+0xdd>
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 54 3d 80 00       	push   $0x803d54
  801ec0:	6a 6f                	push   $0x6f
  801ec2:	68 3b 3d 80 00       	push   $0x803d3b
  801ec7:	e8 5b 13 00 00       	call   803227 <_panic>
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 50 04             	mov    0x4(%eax),%edx
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	89 50 04             	mov    %edx,0x4(%eax)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ede:	89 10                	mov    %edx,(%eax)
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	8b 40 04             	mov    0x4(%eax),%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	74 0d                	je     801ef7 <insert_sorted_allocList+0x108>
  801eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eed:	8b 40 04             	mov    0x4(%eax),%eax
  801ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef3:	89 10                	mov    %edx,(%eax)
  801ef5:	eb 08                	jmp    801eff <insert_sorted_allocList+0x110>
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	a3 40 40 80 00       	mov    %eax,0x804040
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f02:	8b 55 08             	mov    0x8(%ebp),%edx
  801f05:	89 50 04             	mov    %edx,0x4(%eax)
  801f08:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f0d:	40                   	inc    %eax
  801f0e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f13:	e9 60 01 00 00       	jmp    802078 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	8b 50 08             	mov    0x8(%eax),%edx
  801f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f21:	8b 40 08             	mov    0x8(%eax),%eax
  801f24:	39 c2                	cmp    %eax,%edx
  801f26:	0f 82 4c 01 00 00    	jb     802078 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f30:	75 14                	jne    801f46 <insert_sorted_allocList+0x157>
  801f32:	83 ec 04             	sub    $0x4,%esp
  801f35:	68 8c 3d 80 00       	push   $0x803d8c
  801f3a:	6a 73                	push   $0x73
  801f3c:	68 3b 3d 80 00       	push   $0x803d3b
  801f41:	e8 e1 12 00 00       	call   803227 <_panic>
  801f46:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	89 50 04             	mov    %edx,0x4(%eax)
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	8b 40 04             	mov    0x4(%eax),%eax
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	74 0c                	je     801f68 <insert_sorted_allocList+0x179>
  801f5c:	a1 44 40 80 00       	mov    0x804044,%eax
  801f61:	8b 55 08             	mov    0x8(%ebp),%edx
  801f64:	89 10                	mov    %edx,(%eax)
  801f66:	eb 08                	jmp    801f70 <insert_sorted_allocList+0x181>
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	a3 40 40 80 00       	mov    %eax,0x804040
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	a3 44 40 80 00       	mov    %eax,0x804044
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f81:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f86:	40                   	inc    %eax
  801f87:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f8c:	e9 e7 00 00 00       	jmp    802078 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f97:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f9e:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa6:	e9 9d 00 00 00       	jmp    802048 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fae:	8b 00                	mov    (%eax),%eax
  801fb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	8b 50 08             	mov    0x8(%eax),%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 40 08             	mov    0x8(%eax),%eax
  801fbf:	39 c2                	cmp    %eax,%edx
  801fc1:	76 7d                	jbe    802040 <insert_sorted_allocList+0x251>
  801fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc6:	8b 50 08             	mov    0x8(%eax),%edx
  801fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fcc:	8b 40 08             	mov    0x8(%eax),%eax
  801fcf:	39 c2                	cmp    %eax,%edx
  801fd1:	73 6d                	jae    802040 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801fd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd7:	74 06                	je     801fdf <insert_sorted_allocList+0x1f0>
  801fd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fdd:	75 14                	jne    801ff3 <insert_sorted_allocList+0x204>
  801fdf:	83 ec 04             	sub    $0x4,%esp
  801fe2:	68 b0 3d 80 00       	push   $0x803db0
  801fe7:	6a 7f                	push   $0x7f
  801fe9:	68 3b 3d 80 00       	push   $0x803d3b
  801fee:	e8 34 12 00 00       	call   803227 <_panic>
  801ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff6:	8b 10                	mov    (%eax),%edx
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	89 10                	mov    %edx,(%eax)
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 00                	mov    (%eax),%eax
  802002:	85 c0                	test   %eax,%eax
  802004:	74 0b                	je     802011 <insert_sorted_allocList+0x222>
  802006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802009:	8b 00                	mov    (%eax),%eax
  80200b:	8b 55 08             	mov    0x8(%ebp),%edx
  80200e:	89 50 04             	mov    %edx,0x4(%eax)
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 55 08             	mov    0x8(%ebp),%edx
  802017:	89 10                	mov    %edx,(%eax)
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201f:	89 50 04             	mov    %edx,0x4(%eax)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	85 c0                	test   %eax,%eax
  802029:	75 08                	jne    802033 <insert_sorted_allocList+0x244>
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	a3 44 40 80 00       	mov    %eax,0x804044
  802033:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802038:	40                   	inc    %eax
  802039:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80203e:	eb 39                	jmp    802079 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802040:	a1 48 40 80 00       	mov    0x804048,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204c:	74 07                	je     802055 <insert_sorted_allocList+0x266>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	eb 05                	jmp    80205a <insert_sorted_allocList+0x26b>
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	a3 48 40 80 00       	mov    %eax,0x804048
  80205f:	a1 48 40 80 00       	mov    0x804048,%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	0f 85 3f ff ff ff    	jne    801fab <insert_sorted_allocList+0x1bc>
  80206c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802070:	0f 85 35 ff ff ff    	jne    801fab <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802076:	eb 01                	jmp    802079 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802078:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802079:	90                   	nop
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802082:	a1 38 41 80 00       	mov    0x804138,%eax
  802087:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80208a:	e9 85 01 00 00       	jmp    802214 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 40 0c             	mov    0xc(%eax),%eax
  802095:	3b 45 08             	cmp    0x8(%ebp),%eax
  802098:	0f 82 6e 01 00 00    	jb     80220c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a7:	0f 85 8a 00 00 00    	jne    802137 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8020ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b1:	75 17                	jne    8020ca <alloc_block_FF+0x4e>
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 e4 3d 80 00       	push   $0x803de4
  8020bb:	68 93 00 00 00       	push   $0x93
  8020c0:	68 3b 3d 80 00       	push   $0x803d3b
  8020c5:	e8 5d 11 00 00       	call   803227 <_panic>
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 00                	mov    (%eax),%eax
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	74 10                	je     8020e3 <alloc_block_FF+0x67>
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	8b 00                	mov    (%eax),%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	8b 52 04             	mov    0x4(%edx),%edx
  8020de:	89 50 04             	mov    %edx,0x4(%eax)
  8020e1:	eb 0b                	jmp    8020ee <alloc_block_FF+0x72>
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	8b 40 04             	mov    0x4(%eax),%eax
  8020e9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	8b 40 04             	mov    0x4(%eax),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	74 0f                	je     802107 <alloc_block_FF+0x8b>
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 40 04             	mov    0x4(%eax),%eax
  8020fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802101:	8b 12                	mov    (%edx),%edx
  802103:	89 10                	mov    %edx,(%eax)
  802105:	eb 0a                	jmp    802111 <alloc_block_FF+0x95>
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 00                	mov    (%eax),%eax
  80210c:	a3 38 41 80 00       	mov    %eax,0x804138
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802124:	a1 44 41 80 00       	mov    0x804144,%eax
  802129:	48                   	dec    %eax
  80212a:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	e9 10 01 00 00       	jmp    802247 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	8b 40 0c             	mov    0xc(%eax),%eax
  80213d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802140:	0f 86 c6 00 00 00    	jbe    80220c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802146:	a1 48 41 80 00       	mov    0x804148,%eax
  80214b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 50 08             	mov    0x8(%eax),%edx
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	8b 55 08             	mov    0x8(%ebp),%edx
  802160:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802163:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802167:	75 17                	jne    802180 <alloc_block_FF+0x104>
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 e4 3d 80 00       	push   $0x803de4
  802171:	68 9b 00 00 00       	push   $0x9b
  802176:	68 3b 3d 80 00       	push   $0x803d3b
  80217b:	e8 a7 10 00 00       	call   803227 <_panic>
  802180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	85 c0                	test   %eax,%eax
  802187:	74 10                	je     802199 <alloc_block_FF+0x11d>
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802191:	8b 52 04             	mov    0x4(%edx),%edx
  802194:	89 50 04             	mov    %edx,0x4(%eax)
  802197:	eb 0b                	jmp    8021a4 <alloc_block_FF+0x128>
  802199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219c:	8b 40 04             	mov    0x4(%eax),%eax
  80219f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a7:	8b 40 04             	mov    0x4(%eax),%eax
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	74 0f                	je     8021bd <alloc_block_FF+0x141>
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	8b 40 04             	mov    0x4(%eax),%eax
  8021b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b7:	8b 12                	mov    (%edx),%edx
  8021b9:	89 10                	mov    %edx,(%eax)
  8021bb:	eb 0a                	jmp    8021c7 <alloc_block_FF+0x14b>
  8021bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	a3 48 41 80 00       	mov    %eax,0x804148
  8021c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021da:	a1 54 41 80 00       	mov    0x804154,%eax
  8021df:	48                   	dec    %eax
  8021e0:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	8b 50 08             	mov    0x8(%eax),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	01 c2                	add    %eax,%edx
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8021ff:	89 c2                	mov    %eax,%edx
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	eb 3b                	jmp    802247 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80220c:	a1 40 41 80 00       	mov    0x804140,%eax
  802211:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802218:	74 07                	je     802221 <alloc_block_FF+0x1a5>
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 00                	mov    (%eax),%eax
  80221f:	eb 05                	jmp    802226 <alloc_block_FF+0x1aa>
  802221:	b8 00 00 00 00       	mov    $0x0,%eax
  802226:	a3 40 41 80 00       	mov    %eax,0x804140
  80222b:	a1 40 41 80 00       	mov    0x804140,%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	0f 85 57 fe ff ff    	jne    80208f <alloc_block_FF+0x13>
  802238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223c:	0f 85 4d fe ff ff    	jne    80208f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802247:	c9                   	leave  
  802248:	c3                   	ret    

00802249 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80224f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802256:	a1 38 41 80 00       	mov    0x804138,%eax
  80225b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225e:	e9 df 00 00 00       	jmp    802342 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802266:	8b 40 0c             	mov    0xc(%eax),%eax
  802269:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226c:	0f 82 c8 00 00 00    	jb     80233a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 40 0c             	mov    0xc(%eax),%eax
  802278:	3b 45 08             	cmp    0x8(%ebp),%eax
  80227b:	0f 85 8a 00 00 00    	jne    80230b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	75 17                	jne    80229e <alloc_block_BF+0x55>
  802287:	83 ec 04             	sub    $0x4,%esp
  80228a:	68 e4 3d 80 00       	push   $0x803de4
  80228f:	68 b7 00 00 00       	push   $0xb7
  802294:	68 3b 3d 80 00       	push   $0x803d3b
  802299:	e8 89 0f 00 00       	call   803227 <_panic>
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 00                	mov    (%eax),%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 10                	je     8022b7 <alloc_block_BF+0x6e>
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 00                	mov    (%eax),%eax
  8022ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022af:	8b 52 04             	mov    0x4(%edx),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	eb 0b                	jmp    8022c2 <alloc_block_BF+0x79>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 04             	mov    0x4(%eax),%eax
  8022bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 0f                	je     8022db <alloc_block_BF+0x92>
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 04             	mov    0x4(%eax),%eax
  8022d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d5:	8b 12                	mov    (%edx),%edx
  8022d7:	89 10                	mov    %edx,(%eax)
  8022d9:	eb 0a                	jmp    8022e5 <alloc_block_BF+0x9c>
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	a3 38 41 80 00       	mov    %eax,0x804138
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f8:	a1 44 41 80 00       	mov    0x804144,%eax
  8022fd:	48                   	dec    %eax
  8022fe:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	e9 4d 01 00 00       	jmp    802458 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 0c             	mov    0xc(%eax),%eax
  802311:	3b 45 08             	cmp    0x8(%ebp),%eax
  802314:	76 24                	jbe    80233a <alloc_block_BF+0xf1>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 40 0c             	mov    0xc(%eax),%eax
  80231c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80231f:	73 19                	jae    80233a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802321:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 40 0c             	mov    0xc(%eax),%eax
  80232e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 08             	mov    0x8(%eax),%eax
  802337:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80233a:	a1 40 41 80 00       	mov    0x804140,%eax
  80233f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	74 07                	je     80234f <alloc_block_BF+0x106>
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	eb 05                	jmp    802354 <alloc_block_BF+0x10b>
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
  802354:	a3 40 41 80 00       	mov    %eax,0x804140
  802359:	a1 40 41 80 00       	mov    0x804140,%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	0f 85 fd fe ff ff    	jne    802263 <alloc_block_BF+0x1a>
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	0f 85 f3 fe ff ff    	jne    802263 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802370:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802374:	0f 84 d9 00 00 00    	je     802453 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80237a:	a1 48 41 80 00       	mov    0x804148,%eax
  80237f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802385:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802388:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80238b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238e:	8b 55 08             	mov    0x8(%ebp),%edx
  802391:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802394:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802398:	75 17                	jne    8023b1 <alloc_block_BF+0x168>
  80239a:	83 ec 04             	sub    $0x4,%esp
  80239d:	68 e4 3d 80 00       	push   $0x803de4
  8023a2:	68 c7 00 00 00       	push   $0xc7
  8023a7:	68 3b 3d 80 00       	push   $0x803d3b
  8023ac:	e8 76 0e 00 00       	call   803227 <_panic>
  8023b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 10                	je     8023ca <alloc_block_BF+0x181>
  8023ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c2:	8b 52 04             	mov    0x4(%edx),%edx
  8023c5:	89 50 04             	mov    %edx,0x4(%eax)
  8023c8:	eb 0b                	jmp    8023d5 <alloc_block_BF+0x18c>
  8023ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d8:	8b 40 04             	mov    0x4(%eax),%eax
  8023db:	85 c0                	test   %eax,%eax
  8023dd:	74 0f                	je     8023ee <alloc_block_BF+0x1a5>
  8023df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e2:	8b 40 04             	mov    0x4(%eax),%eax
  8023e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023e8:	8b 12                	mov    (%edx),%edx
  8023ea:	89 10                	mov    %edx,(%eax)
  8023ec:	eb 0a                	jmp    8023f8 <alloc_block_BF+0x1af>
  8023ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	a3 48 41 80 00       	mov    %eax,0x804148
  8023f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802401:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802404:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80240b:	a1 54 41 80 00       	mov    0x804154,%eax
  802410:	48                   	dec    %eax
  802411:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802416:	83 ec 08             	sub    $0x8,%esp
  802419:	ff 75 ec             	pushl  -0x14(%ebp)
  80241c:	68 38 41 80 00       	push   $0x804138
  802421:	e8 71 f9 ff ff       	call   801d97 <find_block>
  802426:	83 c4 10             	add    $0x10,%esp
  802429:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80242c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242f:	8b 50 08             	mov    0x8(%eax),%edx
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	01 c2                	add    %eax,%edx
  802437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80243d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802440:	8b 40 0c             	mov    0xc(%eax),%eax
  802443:	2b 45 08             	sub    0x8(%ebp),%eax
  802446:	89 c2                	mov    %eax,%edx
  802448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80244b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80244e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802451:	eb 05                	jmp    802458 <alloc_block_BF+0x20f>
	}
	return NULL;
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802460:	a1 28 40 80 00       	mov    0x804028,%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	0f 85 de 01 00 00    	jne    80264b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80246d:	a1 38 41 80 00       	mov    0x804138,%eax
  802472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802475:	e9 9e 01 00 00       	jmp    802618 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 40 0c             	mov    0xc(%eax),%eax
  802480:	3b 45 08             	cmp    0x8(%ebp),%eax
  802483:	0f 82 87 01 00 00    	jb     802610 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 0c             	mov    0xc(%eax),%eax
  80248f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802492:	0f 85 95 00 00 00    	jne    80252d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802498:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249c:	75 17                	jne    8024b5 <alloc_block_NF+0x5b>
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	68 e4 3d 80 00       	push   $0x803de4
  8024a6:	68 e0 00 00 00       	push   $0xe0
  8024ab:	68 3b 3d 80 00       	push   $0x803d3b
  8024b0:	e8 72 0d 00 00       	call   803227 <_panic>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 10                	je     8024ce <alloc_block_NF+0x74>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c6:	8b 52 04             	mov    0x4(%edx),%edx
  8024c9:	89 50 04             	mov    %edx,0x4(%eax)
  8024cc:	eb 0b                	jmp    8024d9 <alloc_block_NF+0x7f>
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	8b 40 04             	mov    0x4(%eax),%eax
  8024d4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 40 04             	mov    0x4(%eax),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	74 0f                	je     8024f2 <alloc_block_NF+0x98>
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ec:	8b 12                	mov    (%edx),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
  8024f0:	eb 0a                	jmp    8024fc <alloc_block_NF+0xa2>
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	a3 38 41 80 00       	mov    %eax,0x804138
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250f:	a1 44 41 80 00       	mov    0x804144,%eax
  802514:	48                   	dec    %eax
  802515:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 08             	mov    0x8(%eax),%eax
  802520:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	e9 f8 04 00 00       	jmp    802a25 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	3b 45 08             	cmp    0x8(%ebp),%eax
  802536:	0f 86 d4 00 00 00    	jbe    802610 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80253c:	a1 48 41 80 00       	mov    0x804148,%eax
  802541:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 50 08             	mov    0x8(%eax),%edx
  80254a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	8b 55 08             	mov    0x8(%ebp),%edx
  802556:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80255d:	75 17                	jne    802576 <alloc_block_NF+0x11c>
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	68 e4 3d 80 00       	push   $0x803de4
  802567:	68 e9 00 00 00       	push   $0xe9
  80256c:	68 3b 3d 80 00       	push   $0x803d3b
  802571:	e8 b1 0c 00 00       	call   803227 <_panic>
  802576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	74 10                	je     80258f <alloc_block_NF+0x135>
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802587:	8b 52 04             	mov    0x4(%edx),%edx
  80258a:	89 50 04             	mov    %edx,0x4(%eax)
  80258d:	eb 0b                	jmp    80259a <alloc_block_NF+0x140>
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	8b 40 04             	mov    0x4(%eax),%eax
  802595:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80259a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259d:	8b 40 04             	mov    0x4(%eax),%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	74 0f                	je     8025b3 <alloc_block_NF+0x159>
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ad:	8b 12                	mov    (%edx),%edx
  8025af:	89 10                	mov    %edx,(%eax)
  8025b1:	eb 0a                	jmp    8025bd <alloc_block_NF+0x163>
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	a3 48 41 80 00       	mov    %eax,0x804148
  8025bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d0:	a1 54 41 80 00       	mov    0x804154,%eax
  8025d5:	48                   	dec    %eax
  8025d6:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 40 08             	mov    0x8(%eax),%eax
  8025e1:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ef:	01 c2                	add    %eax,%edx
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802600:	89 c2                	mov    %eax,%edx
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260b:	e9 15 04 00 00       	jmp    802a25 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802610:	a1 40 41 80 00       	mov    0x804140,%eax
  802615:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802618:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261c:	74 07                	je     802625 <alloc_block_NF+0x1cb>
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	eb 05                	jmp    80262a <alloc_block_NF+0x1d0>
  802625:	b8 00 00 00 00       	mov    $0x0,%eax
  80262a:	a3 40 41 80 00       	mov    %eax,0x804140
  80262f:	a1 40 41 80 00       	mov    0x804140,%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	0f 85 3e fe ff ff    	jne    80247a <alloc_block_NF+0x20>
  80263c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802640:	0f 85 34 fe ff ff    	jne    80247a <alloc_block_NF+0x20>
  802646:	e9 d5 03 00 00       	jmp    802a20 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80264b:	a1 38 41 80 00       	mov    0x804138,%eax
  802650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802653:	e9 b1 01 00 00       	jmp    802809 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 50 08             	mov    0x8(%eax),%edx
  80265e:	a1 28 40 80 00       	mov    0x804028,%eax
  802663:	39 c2                	cmp    %eax,%edx
  802665:	0f 82 96 01 00 00    	jb     802801 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 40 0c             	mov    0xc(%eax),%eax
  802671:	3b 45 08             	cmp    0x8(%ebp),%eax
  802674:	0f 82 87 01 00 00    	jb     802801 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	8b 40 0c             	mov    0xc(%eax),%eax
  802680:	3b 45 08             	cmp    0x8(%ebp),%eax
  802683:	0f 85 95 00 00 00    	jne    80271e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268d:	75 17                	jne    8026a6 <alloc_block_NF+0x24c>
  80268f:	83 ec 04             	sub    $0x4,%esp
  802692:	68 e4 3d 80 00       	push   $0x803de4
  802697:	68 fc 00 00 00       	push   $0xfc
  80269c:	68 3b 3d 80 00       	push   $0x803d3b
  8026a1:	e8 81 0b 00 00       	call   803227 <_panic>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 10                	je     8026bf <alloc_block_NF+0x265>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b7:	8b 52 04             	mov    0x4(%edx),%edx
  8026ba:	89 50 04             	mov    %edx,0x4(%eax)
  8026bd:	eb 0b                	jmp    8026ca <alloc_block_NF+0x270>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 40 04             	mov    0x4(%eax),%eax
  8026c5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 0f                	je     8026e3 <alloc_block_NF+0x289>
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 04             	mov    0x4(%eax),%eax
  8026da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dd:	8b 12                	mov    (%edx),%edx
  8026df:	89 10                	mov    %edx,(%eax)
  8026e1:	eb 0a                	jmp    8026ed <alloc_block_NF+0x293>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	a3 38 41 80 00       	mov    %eax,0x804138
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802700:	a1 44 41 80 00       	mov    0x804144,%eax
  802705:	48                   	dec    %eax
  802706:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 08             	mov    0x8(%eax),%eax
  802711:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	e9 07 03 00 00       	jmp    802a25 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 0c             	mov    0xc(%eax),%eax
  802724:	3b 45 08             	cmp    0x8(%ebp),%eax
  802727:	0f 86 d4 00 00 00    	jbe    802801 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80272d:	a1 48 41 80 00       	mov    0x804148,%eax
  802732:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 50 08             	mov    0x8(%eax),%edx
  80273b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80274a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80274e:	75 17                	jne    802767 <alloc_block_NF+0x30d>
  802750:	83 ec 04             	sub    $0x4,%esp
  802753:	68 e4 3d 80 00       	push   $0x803de4
  802758:	68 04 01 00 00       	push   $0x104
  80275d:	68 3b 3d 80 00       	push   $0x803d3b
  802762:	e8 c0 0a 00 00       	call   803227 <_panic>
  802767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 10                	je     802780 <alloc_block_NF+0x326>
  802770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802778:	8b 52 04             	mov    0x4(%edx),%edx
  80277b:	89 50 04             	mov    %edx,0x4(%eax)
  80277e:	eb 0b                	jmp    80278b <alloc_block_NF+0x331>
  802780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802783:	8b 40 04             	mov    0x4(%eax),%eax
  802786:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80278b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	74 0f                	je     8027a4 <alloc_block_NF+0x34a>
  802795:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802798:	8b 40 04             	mov    0x4(%eax),%eax
  80279b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279e:	8b 12                	mov    (%edx),%edx
  8027a0:	89 10                	mov    %edx,(%eax)
  8027a2:	eb 0a                	jmp    8027ae <alloc_block_NF+0x354>
  8027a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	a3 48 41 80 00       	mov    %eax,0x804148
  8027ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c1:	a1 54 41 80 00       	mov    0x804154,%eax
  8027c6:	48                   	dec    %eax
  8027c7:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8027cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cf:	8b 40 08             	mov    0x8(%eax),%eax
  8027d2:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 50 08             	mov    0x8(%eax),%edx
  8027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e0:	01 c2                	add    %eax,%edx
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f1:	89 c2                	mov    %eax,%edx
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8027f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fc:	e9 24 02 00 00       	jmp    802a25 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802801:	a1 40 41 80 00       	mov    0x804140,%eax
  802806:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280d:	74 07                	je     802816 <alloc_block_NF+0x3bc>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	eb 05                	jmp    80281b <alloc_block_NF+0x3c1>
  802816:	b8 00 00 00 00       	mov    $0x0,%eax
  80281b:	a3 40 41 80 00       	mov    %eax,0x804140
  802820:	a1 40 41 80 00       	mov    0x804140,%eax
  802825:	85 c0                	test   %eax,%eax
  802827:	0f 85 2b fe ff ff    	jne    802658 <alloc_block_NF+0x1fe>
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	0f 85 21 fe ff ff    	jne    802658 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802837:	a1 38 41 80 00       	mov    0x804138,%eax
  80283c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80283f:	e9 ae 01 00 00       	jmp    8029f2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 50 08             	mov    0x8(%eax),%edx
  80284a:	a1 28 40 80 00       	mov    0x804028,%eax
  80284f:	39 c2                	cmp    %eax,%edx
  802851:	0f 83 93 01 00 00    	jae    8029ea <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 82 84 01 00 00    	jb     8029ea <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286f:	0f 85 95 00 00 00    	jne    80290a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 17                	jne    802892 <alloc_block_NF+0x438>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 e4 3d 80 00       	push   $0x803de4
  802883:	68 14 01 00 00       	push   $0x114
  802888:	68 3b 3d 80 00       	push   $0x803d3b
  80288d:	e8 95 09 00 00       	call   803227 <_panic>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 10                	je     8028ab <alloc_block_NF+0x451>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a3:	8b 52 04             	mov    0x4(%edx),%edx
  8028a6:	89 50 04             	mov    %edx,0x4(%eax)
  8028a9:	eb 0b                	jmp    8028b6 <alloc_block_NF+0x45c>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0f                	je     8028cf <alloc_block_NF+0x475>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c9:	8b 12                	mov    (%edx),%edx
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	eb 0a                	jmp    8028d9 <alloc_block_NF+0x47f>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f1:	48                   	dec    %eax
  8028f2:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 08             	mov    0x8(%eax),%eax
  8028fd:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	e9 1b 01 00 00       	jmp    802a25 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	3b 45 08             	cmp    0x8(%ebp),%eax
  802913:	0f 86 d1 00 00 00    	jbe    8029ea <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802919:	a1 48 41 80 00       	mov    0x804148,%eax
  80291e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 50 08             	mov    0x8(%eax),%edx
  802927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80292d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802930:	8b 55 08             	mov    0x8(%ebp),%edx
  802933:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802936:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80293a:	75 17                	jne    802953 <alloc_block_NF+0x4f9>
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	68 e4 3d 80 00       	push   $0x803de4
  802944:	68 1c 01 00 00       	push   $0x11c
  802949:	68 3b 3d 80 00       	push   $0x803d3b
  80294e:	e8 d4 08 00 00       	call   803227 <_panic>
  802953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 10                	je     80296c <alloc_block_NF+0x512>
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802964:	8b 52 04             	mov    0x4(%edx),%edx
  802967:	89 50 04             	mov    %edx,0x4(%eax)
  80296a:	eb 0b                	jmp    802977 <alloc_block_NF+0x51d>
  80296c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297a:	8b 40 04             	mov    0x4(%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0f                	je     802990 <alloc_block_NF+0x536>
  802981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80298a:	8b 12                	mov    (%edx),%edx
  80298c:	89 10                	mov    %edx,(%eax)
  80298e:	eb 0a                	jmp    80299a <alloc_block_NF+0x540>
  802990:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	a3 48 41 80 00       	mov    %eax,0x804148
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ad:	a1 54 41 80 00       	mov    0x804154,%eax
  8029b2:	48                   	dec    %eax
  8029b3:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bb:	8b 40 08             	mov    0x8(%eax),%eax
  8029be:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 50 08             	mov    0x8(%eax),%edx
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	01 c2                	add    %eax,%edx
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	2b 45 08             	sub    0x8(%ebp),%eax
  8029dd:	89 c2                	mov    %eax,%edx
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e8:	eb 3b                	jmp    802a25 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f6:	74 07                	je     8029ff <alloc_block_NF+0x5a5>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	eb 05                	jmp    802a04 <alloc_block_NF+0x5aa>
  8029ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802a04:	a3 40 41 80 00       	mov    %eax,0x804140
  802a09:	a1 40 41 80 00       	mov    0x804140,%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	0f 85 2e fe ff ff    	jne    802844 <alloc_block_NF+0x3ea>
  802a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1a:	0f 85 24 fe ff ff    	jne    802844 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a25:	c9                   	leave  
  802a26:	c3                   	ret    

00802a27 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a27:	55                   	push   %ebp
  802a28:	89 e5                	mov    %esp,%ebp
  802a2a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a2d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a35:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a3a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a3d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a42:	85 c0                	test   %eax,%eax
  802a44:	74 14                	je     802a5a <insert_sorted_with_merge_freeList+0x33>
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	8b 50 08             	mov    0x8(%eax),%edx
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 40 08             	mov    0x8(%eax),%eax
  802a52:	39 c2                	cmp    %eax,%edx
  802a54:	0f 87 9b 01 00 00    	ja     802bf5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5e:	75 17                	jne    802a77 <insert_sorted_with_merge_freeList+0x50>
  802a60:	83 ec 04             	sub    $0x4,%esp
  802a63:	68 18 3d 80 00       	push   $0x803d18
  802a68:	68 38 01 00 00       	push   $0x138
  802a6d:	68 3b 3d 80 00       	push   $0x803d3b
  802a72:	e8 b0 07 00 00       	call   803227 <_panic>
  802a77:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	89 10                	mov    %edx,(%eax)
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 0d                	je     802a98 <insert_sorted_with_merge_freeList+0x71>
  802a8b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a90:	8b 55 08             	mov    0x8(%ebp),%edx
  802a93:	89 50 04             	mov    %edx,0x4(%eax)
  802a96:	eb 08                	jmp    802aa0 <insert_sorted_with_merge_freeList+0x79>
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab2:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab7:	40                   	inc    %eax
  802ab8:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802abd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac1:	0f 84 a8 06 00 00    	je     80316f <insert_sorted_with_merge_freeList+0x748>
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad3:	01 c2                	add    %eax,%edx
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	8b 40 08             	mov    0x8(%eax),%eax
  802adb:	39 c2                	cmp    %eax,%edx
  802add:	0f 85 8c 06 00 00    	jne    80316f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	01 c2                	add    %eax,%edx
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802af7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802afb:	75 17                	jne    802b14 <insert_sorted_with_merge_freeList+0xed>
  802afd:	83 ec 04             	sub    $0x4,%esp
  802b00:	68 e4 3d 80 00       	push   $0x803de4
  802b05:	68 3c 01 00 00       	push   $0x13c
  802b0a:	68 3b 3d 80 00       	push   $0x803d3b
  802b0f:	e8 13 07 00 00       	call   803227 <_panic>
  802b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 10                	je     802b2d <insert_sorted_with_merge_freeList+0x106>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b25:	8b 52 04             	mov    0x4(%edx),%edx
  802b28:	89 50 04             	mov    %edx,0x4(%eax)
  802b2b:	eb 0b                	jmp    802b38 <insert_sorted_with_merge_freeList+0x111>
  802b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3b:	8b 40 04             	mov    0x4(%eax),%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	74 0f                	je     802b51 <insert_sorted_with_merge_freeList+0x12a>
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 40 04             	mov    0x4(%eax),%eax
  802b48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4b:	8b 12                	mov    (%edx),%edx
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	eb 0a                	jmp    802b5b <insert_sorted_with_merge_freeList+0x134>
  802b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	a3 38 41 80 00       	mov    %eax,0x804138
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b73:	48                   	dec    %eax
  802b74:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b91:	75 17                	jne    802baa <insert_sorted_with_merge_freeList+0x183>
  802b93:	83 ec 04             	sub    $0x4,%esp
  802b96:	68 18 3d 80 00       	push   $0x803d18
  802b9b:	68 3f 01 00 00       	push   $0x13f
  802ba0:	68 3b 3d 80 00       	push   $0x803d3b
  802ba5:	e8 7d 06 00 00       	call   803227 <_panic>
  802baa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	89 10                	mov    %edx,(%eax)
  802bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	74 0d                	je     802bcb <insert_sorted_with_merge_freeList+0x1a4>
  802bbe:	a1 48 41 80 00       	mov    0x804148,%eax
  802bc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bc6:	89 50 04             	mov    %edx,0x4(%eax)
  802bc9:	eb 08                	jmp    802bd3 <insert_sorted_with_merge_freeList+0x1ac>
  802bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	a3 48 41 80 00       	mov    %eax,0x804148
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be5:	a1 54 41 80 00       	mov    0x804154,%eax
  802bea:	40                   	inc    %eax
  802beb:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bf0:	e9 7a 05 00 00       	jmp    80316f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 50 08             	mov    0x8(%eax),%edx
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	0f 82 14 01 00 00    	jb     802d1d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	8b 50 08             	mov    0x8(%eax),%edx
  802c0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c12:	8b 40 0c             	mov    0xc(%eax),%eax
  802c15:	01 c2                	add    %eax,%edx
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 40 08             	mov    0x8(%eax),%eax
  802c1d:	39 c2                	cmp    %eax,%edx
  802c1f:	0f 85 90 00 00 00    	jne    802cb5 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c28:	8b 50 0c             	mov    0xc(%eax),%edx
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c31:	01 c2                	add    %eax,%edx
  802c33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c36:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c51:	75 17                	jne    802c6a <insert_sorted_with_merge_freeList+0x243>
  802c53:	83 ec 04             	sub    $0x4,%esp
  802c56:	68 18 3d 80 00       	push   $0x803d18
  802c5b:	68 49 01 00 00       	push   $0x149
  802c60:	68 3b 3d 80 00       	push   $0x803d3b
  802c65:	e8 bd 05 00 00       	call   803227 <_panic>
  802c6a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	89 10                	mov    %edx,(%eax)
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 0d                	je     802c8b <insert_sorted_with_merge_freeList+0x264>
  802c7e:	a1 48 41 80 00       	mov    0x804148,%eax
  802c83:	8b 55 08             	mov    0x8(%ebp),%edx
  802c86:	89 50 04             	mov    %edx,0x4(%eax)
  802c89:	eb 08                	jmp    802c93 <insert_sorted_with_merge_freeList+0x26c>
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	a3 48 41 80 00       	mov    %eax,0x804148
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca5:	a1 54 41 80 00       	mov    0x804154,%eax
  802caa:	40                   	inc    %eax
  802cab:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cb0:	e9 bb 04 00 00       	jmp    803170 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802cb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb9:	75 17                	jne    802cd2 <insert_sorted_with_merge_freeList+0x2ab>
  802cbb:	83 ec 04             	sub    $0x4,%esp
  802cbe:	68 8c 3d 80 00       	push   $0x803d8c
  802cc3:	68 4c 01 00 00       	push   $0x14c
  802cc8:	68 3b 3d 80 00       	push   $0x803d3b
  802ccd:	e8 55 05 00 00       	call   803227 <_panic>
  802cd2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	89 50 04             	mov    %edx,0x4(%eax)
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	8b 40 04             	mov    0x4(%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 0c                	je     802cf4 <insert_sorted_with_merge_freeList+0x2cd>
  802ce8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ced:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf0:	89 10                	mov    %edx,(%eax)
  802cf2:	eb 08                	jmp    802cfc <insert_sorted_with_merge_freeList+0x2d5>
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0d:	a1 44 41 80 00       	mov    0x804144,%eax
  802d12:	40                   	inc    %eax
  802d13:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d18:	e9 53 04 00 00       	jmp    803170 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802d1d:	a1 38 41 80 00       	mov    0x804138,%eax
  802d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d25:	e9 15 04 00 00       	jmp    80313f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 50 08             	mov    0x8(%eax),%edx
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 08             	mov    0x8(%eax),%eax
  802d3e:	39 c2                	cmp    %eax,%edx
  802d40:	0f 86 f1 03 00 00    	jbe    803137 <insert_sorted_with_merge_freeList+0x710>
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	8b 50 08             	mov    0x8(%eax),%edx
  802d4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4f:	8b 40 08             	mov    0x8(%eax),%eax
  802d52:	39 c2                	cmp    %eax,%edx
  802d54:	0f 83 dd 03 00 00    	jae    803137 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	8b 50 08             	mov    0x8(%eax),%edx
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 0c             	mov    0xc(%eax),%eax
  802d66:	01 c2                	add    %eax,%edx
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	8b 40 08             	mov    0x8(%eax),%eax
  802d6e:	39 c2                	cmp    %eax,%edx
  802d70:	0f 85 b9 01 00 00    	jne    802f2f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	8b 50 08             	mov    0x8(%eax),%edx
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d82:	01 c2                	add    %eax,%edx
  802d84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d87:	8b 40 08             	mov    0x8(%eax),%eax
  802d8a:	39 c2                	cmp    %eax,%edx
  802d8c:	0f 85 0d 01 00 00    	jne    802e9f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	8b 50 0c             	mov    0xc(%eax),%edx
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9e:	01 c2                	add    %eax,%edx
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802da6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802daa:	75 17                	jne    802dc3 <insert_sorted_with_merge_freeList+0x39c>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 e4 3d 80 00       	push   $0x803de4
  802db4:	68 5c 01 00 00       	push   $0x15c
  802db9:	68 3b 3d 80 00       	push   $0x803d3b
  802dbe:	e8 64 04 00 00       	call   803227 <_panic>
  802dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 10                	je     802ddc <insert_sorted_with_merge_freeList+0x3b5>
  802dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd4:	8b 52 04             	mov    0x4(%edx),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	eb 0b                	jmp    802de7 <insert_sorted_with_merge_freeList+0x3c0>
  802ddc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802de7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dea:	8b 40 04             	mov    0x4(%eax),%eax
  802ded:	85 c0                	test   %eax,%eax
  802def:	74 0f                	je     802e00 <insert_sorted_with_merge_freeList+0x3d9>
  802df1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df4:	8b 40 04             	mov    0x4(%eax),%eax
  802df7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dfa:	8b 12                	mov    (%edx),%edx
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	eb 0a                	jmp    802e0a <insert_sorted_with_merge_freeList+0x3e3>
  802e00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e03:	8b 00                	mov    (%eax),%eax
  802e05:	a3 38 41 80 00       	mov    %eax,0x804138
  802e0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1d:	a1 44 41 80 00       	mov    0x804144,%eax
  802e22:	48                   	dec    %eax
  802e23:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e3c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e40:	75 17                	jne    802e59 <insert_sorted_with_merge_freeList+0x432>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 18 3d 80 00       	push   $0x803d18
  802e4a:	68 5f 01 00 00       	push   $0x15f
  802e4f:	68 3b 3d 80 00       	push   $0x803d3b
  802e54:	e8 ce 03 00 00       	call   803227 <_panic>
  802e59:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e62:	89 10                	mov    %edx,(%eax)
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	74 0d                	je     802e7a <insert_sorted_with_merge_freeList+0x453>
  802e6d:	a1 48 41 80 00       	mov    0x804148,%eax
  802e72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	eb 08                	jmp    802e82 <insert_sorted_with_merge_freeList+0x45b>
  802e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e85:	a3 48 41 80 00       	mov    %eax,0x804148
  802e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e94:	a1 54 41 80 00       	mov    0x804154,%eax
  802e99:	40                   	inc    %eax
  802e9a:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	8b 40 0c             	mov    0xc(%eax),%eax
  802eab:	01 c2                	add    %eax,%edx
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ec7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecb:	75 17                	jne    802ee4 <insert_sorted_with_merge_freeList+0x4bd>
  802ecd:	83 ec 04             	sub    $0x4,%esp
  802ed0:	68 18 3d 80 00       	push   $0x803d18
  802ed5:	68 64 01 00 00       	push   $0x164
  802eda:	68 3b 3d 80 00       	push   $0x803d3b
  802edf:	e8 43 03 00 00       	call   803227 <_panic>
  802ee4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	89 10                	mov    %edx,(%eax)
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	85 c0                	test   %eax,%eax
  802ef6:	74 0d                	je     802f05 <insert_sorted_with_merge_freeList+0x4de>
  802ef8:	a1 48 41 80 00       	mov    0x804148,%eax
  802efd:	8b 55 08             	mov    0x8(%ebp),%edx
  802f00:	89 50 04             	mov    %edx,0x4(%eax)
  802f03:	eb 08                	jmp    802f0d <insert_sorted_with_merge_freeList+0x4e6>
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	a3 48 41 80 00       	mov    %eax,0x804148
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f24:	40                   	inc    %eax
  802f25:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f2a:	e9 41 02 00 00       	jmp    803170 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	8b 50 08             	mov    0x8(%eax),%edx
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3b:	01 c2                	add    %eax,%edx
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	8b 40 08             	mov    0x8(%eax),%eax
  802f43:	39 c2                	cmp    %eax,%edx
  802f45:	0f 85 7c 01 00 00    	jne    8030c7 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f4b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f4f:	74 06                	je     802f57 <insert_sorted_with_merge_freeList+0x530>
  802f51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f55:	75 17                	jne    802f6e <insert_sorted_with_merge_freeList+0x547>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 54 3d 80 00       	push   $0x803d54
  802f5f:	68 69 01 00 00       	push   $0x169
  802f64:	68 3b 3d 80 00       	push   $0x803d3b
  802f69:	e8 b9 02 00 00       	call   803227 <_panic>
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	8b 50 04             	mov    0x4(%eax),%edx
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	89 50 04             	mov    %edx,0x4(%eax)
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 0d                	je     802f99 <insert_sorted_with_merge_freeList+0x572>
  802f8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	8b 55 08             	mov    0x8(%ebp),%edx
  802f95:	89 10                	mov    %edx,(%eax)
  802f97:	eb 08                	jmp    802fa1 <insert_sorted_with_merge_freeList+0x57a>
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	a3 38 41 80 00       	mov    %eax,0x804138
  802fa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa7:	89 50 04             	mov    %edx,0x4(%eax)
  802faa:	a1 44 41 80 00       	mov    0x804144,%eax
  802faf:	40                   	inc    %eax
  802fb0:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 50 0c             	mov    0xc(%eax),%edx
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc1:	01 c2                	add    %eax,%edx
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fcd:	75 17                	jne    802fe6 <insert_sorted_with_merge_freeList+0x5bf>
  802fcf:	83 ec 04             	sub    $0x4,%esp
  802fd2:	68 e4 3d 80 00       	push   $0x803de4
  802fd7:	68 6b 01 00 00       	push   $0x16b
  802fdc:	68 3b 3d 80 00       	push   $0x803d3b
  802fe1:	e8 41 02 00 00       	call   803227 <_panic>
  802fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 10                	je     802fff <insert_sorted_with_merge_freeList+0x5d8>
  802fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff7:	8b 52 04             	mov    0x4(%edx),%edx
  802ffa:	89 50 04             	mov    %edx,0x4(%eax)
  802ffd:	eb 0b                	jmp    80300a <insert_sorted_with_merge_freeList+0x5e3>
  802fff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803002:	8b 40 04             	mov    0x4(%eax),%eax
  803005:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80300a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300d:	8b 40 04             	mov    0x4(%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0f                	je     803023 <insert_sorted_with_merge_freeList+0x5fc>
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	8b 40 04             	mov    0x4(%eax),%eax
  80301a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301d:	8b 12                	mov    (%edx),%edx
  80301f:	89 10                	mov    %edx,(%eax)
  803021:	eb 0a                	jmp    80302d <insert_sorted_with_merge_freeList+0x606>
  803023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803026:	8b 00                	mov    (%eax),%eax
  803028:	a3 38 41 80 00       	mov    %eax,0x804138
  80302d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803036:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803039:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803040:	a1 44 41 80 00       	mov    0x804144,%eax
  803045:	48                   	dec    %eax
  803046:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803055:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803058:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80305f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803063:	75 17                	jne    80307c <insert_sorted_with_merge_freeList+0x655>
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	68 18 3d 80 00       	push   $0x803d18
  80306d:	68 6e 01 00 00       	push   $0x16e
  803072:	68 3b 3d 80 00       	push   $0x803d3b
  803077:	e8 ab 01 00 00       	call   803227 <_panic>
  80307c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 0d                	je     80309d <insert_sorted_with_merge_freeList+0x676>
  803090:	a1 48 41 80 00       	mov    0x804148,%eax
  803095:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	eb 08                	jmp    8030a5 <insert_sorted_with_merge_freeList+0x67e>
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a8:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8030bc:	40                   	inc    %eax
  8030bd:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030c2:	e9 a9 00 00 00       	jmp    803170 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8030c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cb:	74 06                	je     8030d3 <insert_sorted_with_merge_freeList+0x6ac>
  8030cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x6c3>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 b0 3d 80 00       	push   $0x803db0
  8030db:	68 73 01 00 00       	push   $0x173
  8030e0:	68 3b 3d 80 00       	push   $0x803d3b
  8030e5:	e8 3d 01 00 00       	call   803227 <_panic>
  8030ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ed:	8b 10                	mov    (%eax),%edx
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	89 10                	mov    %edx,(%eax)
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	74 0b                	je     803108 <insert_sorted_with_merge_freeList+0x6e1>
  8030fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803100:	8b 00                	mov    (%eax),%eax
  803102:	8b 55 08             	mov    0x8(%ebp),%edx
  803105:	89 50 04             	mov    %edx,0x4(%eax)
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 55 08             	mov    0x8(%ebp),%edx
  80310e:	89 10                	mov    %edx,(%eax)
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	8b 45 08             	mov    0x8(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	75 08                	jne    80312a <insert_sorted_with_merge_freeList+0x703>
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80312a:	a1 44 41 80 00       	mov    0x804144,%eax
  80312f:	40                   	inc    %eax
  803130:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803135:	eb 39                	jmp    803170 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803137:	a1 40 41 80 00       	mov    0x804140,%eax
  80313c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80313f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803143:	74 07                	je     80314c <insert_sorted_with_merge_freeList+0x725>
  803145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	eb 05                	jmp    803151 <insert_sorted_with_merge_freeList+0x72a>
  80314c:	b8 00 00 00 00       	mov    $0x0,%eax
  803151:	a3 40 41 80 00       	mov    %eax,0x804140
  803156:	a1 40 41 80 00       	mov    0x804140,%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	0f 85 c7 fb ff ff    	jne    802d2a <insert_sorted_with_merge_freeList+0x303>
  803163:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803167:	0f 85 bd fb ff ff    	jne    802d2a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80316d:	eb 01                	jmp    803170 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80316f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803170:	90                   	nop
  803171:	c9                   	leave  
  803172:	c3                   	ret    

00803173 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803173:	55                   	push   %ebp
  803174:	89 e5                	mov    %esp,%ebp
  803176:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803179:	8b 55 08             	mov    0x8(%ebp),%edx
  80317c:	89 d0                	mov    %edx,%eax
  80317e:	c1 e0 02             	shl    $0x2,%eax
  803181:	01 d0                	add    %edx,%eax
  803183:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80318a:	01 d0                	add    %edx,%eax
  80318c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803193:	01 d0                	add    %edx,%eax
  803195:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80319c:	01 d0                	add    %edx,%eax
  80319e:	c1 e0 04             	shl    $0x4,%eax
  8031a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8031ab:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8031ae:	83 ec 0c             	sub    $0xc,%esp
  8031b1:	50                   	push   %eax
  8031b2:	e8 26 e7 ff ff       	call   8018dd <sys_get_virtual_time>
  8031b7:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8031ba:	eb 41                	jmp    8031fd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8031bc:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031bf:	83 ec 0c             	sub    $0xc,%esp
  8031c2:	50                   	push   %eax
  8031c3:	e8 15 e7 ff ff       	call   8018dd <sys_get_virtual_time>
  8031c8:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8031cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	29 c2                	sub    %eax,%edx
  8031d3:	89 d0                	mov    %edx,%eax
  8031d5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8031d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031de:	89 d1                	mov    %edx,%ecx
  8031e0:	29 c1                	sub    %eax,%ecx
  8031e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e8:	39 c2                	cmp    %eax,%edx
  8031ea:	0f 97 c0             	seta   %al
  8031ed:	0f b6 c0             	movzbl %al,%eax
  8031f0:	29 c1                	sub    %eax,%ecx
  8031f2:	89 c8                	mov    %ecx,%eax
  8031f4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8031f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803203:	72 b7                	jb     8031bc <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803205:	90                   	nop
  803206:	c9                   	leave  
  803207:	c3                   	ret    

00803208 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803208:	55                   	push   %ebp
  803209:	89 e5                	mov    %esp,%ebp
  80320b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80320e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803215:	eb 03                	jmp    80321a <busy_wait+0x12>
  803217:	ff 45 fc             	incl   -0x4(%ebp)
  80321a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80321d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803220:	72 f5                	jb     803217 <busy_wait+0xf>
	return i;
  803222:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803225:	c9                   	leave  
  803226:	c3                   	ret    

00803227 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803227:	55                   	push   %ebp
  803228:	89 e5                	mov    %esp,%ebp
  80322a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80322d:	8d 45 10             	lea    0x10(%ebp),%eax
  803230:	83 c0 04             	add    $0x4,%eax
  803233:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803236:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80323b:	85 c0                	test   %eax,%eax
  80323d:	74 16                	je     803255 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80323f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803244:	83 ec 08             	sub    $0x8,%esp
  803247:	50                   	push   %eax
  803248:	68 04 3e 80 00       	push   $0x803e04
  80324d:	e8 2a d1 ff ff       	call   80037c <cprintf>
  803252:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803255:	a1 00 40 80 00       	mov    0x804000,%eax
  80325a:	ff 75 0c             	pushl  0xc(%ebp)
  80325d:	ff 75 08             	pushl  0x8(%ebp)
  803260:	50                   	push   %eax
  803261:	68 09 3e 80 00       	push   $0x803e09
  803266:	e8 11 d1 ff ff       	call   80037c <cprintf>
  80326b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80326e:	8b 45 10             	mov    0x10(%ebp),%eax
  803271:	83 ec 08             	sub    $0x8,%esp
  803274:	ff 75 f4             	pushl  -0xc(%ebp)
  803277:	50                   	push   %eax
  803278:	e8 94 d0 ff ff       	call   800311 <vcprintf>
  80327d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803280:	83 ec 08             	sub    $0x8,%esp
  803283:	6a 00                	push   $0x0
  803285:	68 25 3e 80 00       	push   $0x803e25
  80328a:	e8 82 d0 ff ff       	call   800311 <vcprintf>
  80328f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803292:	e8 03 d0 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  803297:	eb fe                	jmp    803297 <_panic+0x70>

00803299 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803299:	55                   	push   %ebp
  80329a:	89 e5                	mov    %esp,%ebp
  80329c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80329f:	a1 20 40 80 00       	mov    0x804020,%eax
  8032a4:	8b 50 74             	mov    0x74(%eax),%edx
  8032a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032aa:	39 c2                	cmp    %eax,%edx
  8032ac:	74 14                	je     8032c2 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	68 28 3e 80 00       	push   $0x803e28
  8032b6:	6a 26                	push   $0x26
  8032b8:	68 74 3e 80 00       	push   $0x803e74
  8032bd:	e8 65 ff ff ff       	call   803227 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032d0:	e9 c2 00 00 00       	jmp    803397 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	01 d0                	add    %edx,%eax
  8032e4:	8b 00                	mov    (%eax),%eax
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	75 08                	jne    8032f2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8032ea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8032ed:	e9 a2 00 00 00       	jmp    803394 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8032f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803300:	eb 69                	jmp    80336b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803302:	a1 20 40 80 00       	mov    0x804020,%eax
  803307:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80330d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803310:	89 d0                	mov    %edx,%eax
  803312:	01 c0                	add    %eax,%eax
  803314:	01 d0                	add    %edx,%eax
  803316:	c1 e0 03             	shl    $0x3,%eax
  803319:	01 c8                	add    %ecx,%eax
  80331b:	8a 40 04             	mov    0x4(%eax),%al
  80331e:	84 c0                	test   %al,%al
  803320:	75 46                	jne    803368 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803322:	a1 20 40 80 00       	mov    0x804020,%eax
  803327:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80332d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803330:	89 d0                	mov    %edx,%eax
  803332:	01 c0                	add    %eax,%eax
  803334:	01 d0                	add    %edx,%eax
  803336:	c1 e0 03             	shl    $0x3,%eax
  803339:	01 c8                	add    %ecx,%eax
  80333b:	8b 00                	mov    (%eax),%eax
  80333d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803343:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803348:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80334a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	01 c8                	add    %ecx,%eax
  803359:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80335b:	39 c2                	cmp    %eax,%edx
  80335d:	75 09                	jne    803368 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80335f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803366:	eb 12                	jmp    80337a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803368:	ff 45 e8             	incl   -0x18(%ebp)
  80336b:	a1 20 40 80 00       	mov    0x804020,%eax
  803370:	8b 50 74             	mov    0x74(%eax),%edx
  803373:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803376:	39 c2                	cmp    %eax,%edx
  803378:	77 88                	ja     803302 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80337a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80337e:	75 14                	jne    803394 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803380:	83 ec 04             	sub    $0x4,%esp
  803383:	68 80 3e 80 00       	push   $0x803e80
  803388:	6a 3a                	push   $0x3a
  80338a:	68 74 3e 80 00       	push   $0x803e74
  80338f:	e8 93 fe ff ff       	call   803227 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803394:	ff 45 f0             	incl   -0x10(%ebp)
  803397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80339a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80339d:	0f 8c 32 ff ff ff    	jl     8032d5 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033b1:	eb 26                	jmp    8033d9 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8033b8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c1:	89 d0                	mov    %edx,%eax
  8033c3:	01 c0                	add    %eax,%eax
  8033c5:	01 d0                	add    %edx,%eax
  8033c7:	c1 e0 03             	shl    $0x3,%eax
  8033ca:	01 c8                	add    %ecx,%eax
  8033cc:	8a 40 04             	mov    0x4(%eax),%al
  8033cf:	3c 01                	cmp    $0x1,%al
  8033d1:	75 03                	jne    8033d6 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033d3:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033d6:	ff 45 e0             	incl   -0x20(%ebp)
  8033d9:	a1 20 40 80 00       	mov    0x804020,%eax
  8033de:	8b 50 74             	mov    0x74(%eax),%edx
  8033e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e4:	39 c2                	cmp    %eax,%edx
  8033e6:	77 cb                	ja     8033b3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033ee:	74 14                	je     803404 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8033f0:	83 ec 04             	sub    $0x4,%esp
  8033f3:	68 d4 3e 80 00       	push   $0x803ed4
  8033f8:	6a 44                	push   $0x44
  8033fa:	68 74 3e 80 00       	push   $0x803e74
  8033ff:	e8 23 fe ff ff       	call   803227 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803404:	90                   	nop
  803405:	c9                   	leave  
  803406:	c3                   	ret    
  803407:	90                   	nop

00803408 <__udivdi3>:
  803408:	55                   	push   %ebp
  803409:	57                   	push   %edi
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
  80340c:	83 ec 1c             	sub    $0x1c,%esp
  80340f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803413:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80341f:	89 ca                	mov    %ecx,%edx
  803421:	89 f8                	mov    %edi,%eax
  803423:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803427:	85 f6                	test   %esi,%esi
  803429:	75 2d                	jne    803458 <__udivdi3+0x50>
  80342b:	39 cf                	cmp    %ecx,%edi
  80342d:	77 65                	ja     803494 <__udivdi3+0x8c>
  80342f:	89 fd                	mov    %edi,%ebp
  803431:	85 ff                	test   %edi,%edi
  803433:	75 0b                	jne    803440 <__udivdi3+0x38>
  803435:	b8 01 00 00 00       	mov    $0x1,%eax
  80343a:	31 d2                	xor    %edx,%edx
  80343c:	f7 f7                	div    %edi
  80343e:	89 c5                	mov    %eax,%ebp
  803440:	31 d2                	xor    %edx,%edx
  803442:	89 c8                	mov    %ecx,%eax
  803444:	f7 f5                	div    %ebp
  803446:	89 c1                	mov    %eax,%ecx
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f5                	div    %ebp
  80344c:	89 cf                	mov    %ecx,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	39 ce                	cmp    %ecx,%esi
  80345a:	77 28                	ja     803484 <__udivdi3+0x7c>
  80345c:	0f bd fe             	bsr    %esi,%edi
  80345f:	83 f7 1f             	xor    $0x1f,%edi
  803462:	75 40                	jne    8034a4 <__udivdi3+0x9c>
  803464:	39 ce                	cmp    %ecx,%esi
  803466:	72 0a                	jb     803472 <__udivdi3+0x6a>
  803468:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80346c:	0f 87 9e 00 00 00    	ja     803510 <__udivdi3+0x108>
  803472:	b8 01 00 00 00       	mov    $0x1,%eax
  803477:	89 fa                	mov    %edi,%edx
  803479:	83 c4 1c             	add    $0x1c,%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5e                   	pop    %esi
  80347e:	5f                   	pop    %edi
  80347f:	5d                   	pop    %ebp
  803480:	c3                   	ret    
  803481:	8d 76 00             	lea    0x0(%esi),%esi
  803484:	31 ff                	xor    %edi,%edi
  803486:	31 c0                	xor    %eax,%eax
  803488:	89 fa                	mov    %edi,%edx
  80348a:	83 c4 1c             	add    $0x1c,%esp
  80348d:	5b                   	pop    %ebx
  80348e:	5e                   	pop    %esi
  80348f:	5f                   	pop    %edi
  803490:	5d                   	pop    %ebp
  803491:	c3                   	ret    
  803492:	66 90                	xchg   %ax,%ax
  803494:	89 d8                	mov    %ebx,%eax
  803496:	f7 f7                	div    %edi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	89 fa                	mov    %edi,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a9:	89 eb                	mov    %ebp,%ebx
  8034ab:	29 fb                	sub    %edi,%ebx
  8034ad:	89 f9                	mov    %edi,%ecx
  8034af:	d3 e6                	shl    %cl,%esi
  8034b1:	89 c5                	mov    %eax,%ebp
  8034b3:	88 d9                	mov    %bl,%cl
  8034b5:	d3 ed                	shr    %cl,%ebp
  8034b7:	89 e9                	mov    %ebp,%ecx
  8034b9:	09 f1                	or     %esi,%ecx
  8034bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034bf:	89 f9                	mov    %edi,%ecx
  8034c1:	d3 e0                	shl    %cl,%eax
  8034c3:	89 c5                	mov    %eax,%ebp
  8034c5:	89 d6                	mov    %edx,%esi
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ee                	shr    %cl,%esi
  8034cb:	89 f9                	mov    %edi,%ecx
  8034cd:	d3 e2                	shl    %cl,%edx
  8034cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d3:	88 d9                	mov    %bl,%cl
  8034d5:	d3 e8                	shr    %cl,%eax
  8034d7:	09 c2                	or     %eax,%edx
  8034d9:	89 d0                	mov    %edx,%eax
  8034db:	89 f2                	mov    %esi,%edx
  8034dd:	f7 74 24 0c          	divl   0xc(%esp)
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	89 c3                	mov    %eax,%ebx
  8034e5:	f7 e5                	mul    %ebp
  8034e7:	39 d6                	cmp    %edx,%esi
  8034e9:	72 19                	jb     803504 <__udivdi3+0xfc>
  8034eb:	74 0b                	je     8034f8 <__udivdi3+0xf0>
  8034ed:	89 d8                	mov    %ebx,%eax
  8034ef:	31 ff                	xor    %edi,%edi
  8034f1:	e9 58 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034fc:	89 f9                	mov    %edi,%ecx
  8034fe:	d3 e2                	shl    %cl,%edx
  803500:	39 c2                	cmp    %eax,%edx
  803502:	73 e9                	jae    8034ed <__udivdi3+0xe5>
  803504:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803507:	31 ff                	xor    %edi,%edi
  803509:	e9 40 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  80350e:	66 90                	xchg   %ax,%ax
  803510:	31 c0                	xor    %eax,%eax
  803512:	e9 37 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  803517:	90                   	nop

00803518 <__umoddi3>:
  803518:	55                   	push   %ebp
  803519:	57                   	push   %edi
  80351a:	56                   	push   %esi
  80351b:	53                   	push   %ebx
  80351c:	83 ec 1c             	sub    $0x1c,%esp
  80351f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803523:	8b 74 24 34          	mov    0x34(%esp),%esi
  803527:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80352f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803537:	89 f3                	mov    %esi,%ebx
  803539:	89 fa                	mov    %edi,%edx
  80353b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353f:	89 34 24             	mov    %esi,(%esp)
  803542:	85 c0                	test   %eax,%eax
  803544:	75 1a                	jne    803560 <__umoddi3+0x48>
  803546:	39 f7                	cmp    %esi,%edi
  803548:	0f 86 a2 00 00 00    	jbe    8035f0 <__umoddi3+0xd8>
  80354e:	89 c8                	mov    %ecx,%eax
  803550:	89 f2                	mov    %esi,%edx
  803552:	f7 f7                	div    %edi
  803554:	89 d0                	mov    %edx,%eax
  803556:	31 d2                	xor    %edx,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	39 f0                	cmp    %esi,%eax
  803562:	0f 87 ac 00 00 00    	ja     803614 <__umoddi3+0xfc>
  803568:	0f bd e8             	bsr    %eax,%ebp
  80356b:	83 f5 1f             	xor    $0x1f,%ebp
  80356e:	0f 84 ac 00 00 00    	je     803620 <__umoddi3+0x108>
  803574:	bf 20 00 00 00       	mov    $0x20,%edi
  803579:	29 ef                	sub    %ebp,%edi
  80357b:	89 fe                	mov    %edi,%esi
  80357d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803581:	89 e9                	mov    %ebp,%ecx
  803583:	d3 e0                	shl    %cl,%eax
  803585:	89 d7                	mov    %edx,%edi
  803587:	89 f1                	mov    %esi,%ecx
  803589:	d3 ef                	shr    %cl,%edi
  80358b:	09 c7                	or     %eax,%edi
  80358d:	89 e9                	mov    %ebp,%ecx
  80358f:	d3 e2                	shl    %cl,%edx
  803591:	89 14 24             	mov    %edx,(%esp)
  803594:	89 d8                	mov    %ebx,%eax
  803596:	d3 e0                	shl    %cl,%eax
  803598:	89 c2                	mov    %eax,%edx
  80359a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359e:	d3 e0                	shl    %cl,%eax
  8035a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a8:	89 f1                	mov    %esi,%ecx
  8035aa:	d3 e8                	shr    %cl,%eax
  8035ac:	09 d0                	or     %edx,%eax
  8035ae:	d3 eb                	shr    %cl,%ebx
  8035b0:	89 da                	mov    %ebx,%edx
  8035b2:	f7 f7                	div    %edi
  8035b4:	89 d3                	mov    %edx,%ebx
  8035b6:	f7 24 24             	mull   (%esp)
  8035b9:	89 c6                	mov    %eax,%esi
  8035bb:	89 d1                	mov    %edx,%ecx
  8035bd:	39 d3                	cmp    %edx,%ebx
  8035bf:	0f 82 87 00 00 00    	jb     80364c <__umoddi3+0x134>
  8035c5:	0f 84 91 00 00 00    	je     80365c <__umoddi3+0x144>
  8035cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035cf:	29 f2                	sub    %esi,%edx
  8035d1:	19 cb                	sbb    %ecx,%ebx
  8035d3:	89 d8                	mov    %ebx,%eax
  8035d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d9:	d3 e0                	shl    %cl,%eax
  8035db:	89 e9                	mov    %ebp,%ecx
  8035dd:	d3 ea                	shr    %cl,%edx
  8035df:	09 d0                	or     %edx,%eax
  8035e1:	89 e9                	mov    %ebp,%ecx
  8035e3:	d3 eb                	shr    %cl,%ebx
  8035e5:	89 da                	mov    %ebx,%edx
  8035e7:	83 c4 1c             	add    $0x1c,%esp
  8035ea:	5b                   	pop    %ebx
  8035eb:	5e                   	pop    %esi
  8035ec:	5f                   	pop    %edi
  8035ed:	5d                   	pop    %ebp
  8035ee:	c3                   	ret    
  8035ef:	90                   	nop
  8035f0:	89 fd                	mov    %edi,%ebp
  8035f2:	85 ff                	test   %edi,%edi
  8035f4:	75 0b                	jne    803601 <__umoddi3+0xe9>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	f7 f7                	div    %edi
  8035ff:	89 c5                	mov    %eax,%ebp
  803601:	89 f0                	mov    %esi,%eax
  803603:	31 d2                	xor    %edx,%edx
  803605:	f7 f5                	div    %ebp
  803607:	89 c8                	mov    %ecx,%eax
  803609:	f7 f5                	div    %ebp
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	e9 44 ff ff ff       	jmp    803556 <__umoddi3+0x3e>
  803612:	66 90                	xchg   %ax,%ax
  803614:	89 c8                	mov    %ecx,%eax
  803616:	89 f2                	mov    %esi,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	3b 04 24             	cmp    (%esp),%eax
  803623:	72 06                	jb     80362b <__umoddi3+0x113>
  803625:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803629:	77 0f                	ja     80363a <__umoddi3+0x122>
  80362b:	89 f2                	mov    %esi,%edx
  80362d:	29 f9                	sub    %edi,%ecx
  80362f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803633:	89 14 24             	mov    %edx,(%esp)
  803636:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80363e:	8b 14 24             	mov    (%esp),%edx
  803641:	83 c4 1c             	add    $0x1c,%esp
  803644:	5b                   	pop    %ebx
  803645:	5e                   	pop    %esi
  803646:	5f                   	pop    %edi
  803647:	5d                   	pop    %ebp
  803648:	c3                   	ret    
  803649:	8d 76 00             	lea    0x0(%esi),%esi
  80364c:	2b 04 24             	sub    (%esp),%eax
  80364f:	19 fa                	sbb    %edi,%edx
  803651:	89 d1                	mov    %edx,%ecx
  803653:	89 c6                	mov    %eax,%esi
  803655:	e9 71 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803660:	72 ea                	jb     80364c <__umoddi3+0x134>
  803662:	89 d9                	mov    %ebx,%ecx
  803664:	e9 62 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
