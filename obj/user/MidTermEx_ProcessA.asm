
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
  80003e:	e8 21 19 00 00       	call   801964 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 40 37 80 00       	push   $0x803740
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 f1 13 00 00       	call   801447 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 42 37 80 00       	push   $0x803742
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 db 13 00 00       	call   801447 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 49 37 80 00       	push   $0x803749
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 c5 13 00 00       	call   801447 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 03 19 00 00       	call   801997 <sys_get_virtual_time>
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
  8000b7:	e8 71 31 00 00       	call   80322d <env_sleep>
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
  8000d0:	e8 c2 18 00 00       	call   801997 <sys_get_virtual_time>
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
  8000f8:	e8 30 31 00 00       	call   80322d <env_sleep>
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
  80010f:	e8 83 18 00 00       	call   801997 <sys_get_virtual_time>
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
  800137:	e8 f1 30 00 00       	call   80322d <env_sleep>
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
  80014c:	68 57 37 80 00       	push   $0x803757
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 ca 16 00 00       	call   801823 <sys_signalSemaphore>
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
  800172:	e8 d4 17 00 00       	call   80194b <sys_getenvindex>
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
  8001dd:	e8 76 15 00 00       	call   801758 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 74 37 80 00       	push   $0x803774
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
  80020d:	68 9c 37 80 00       	push   $0x80379c
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
  80023e:	68 c4 37 80 00       	push   $0x8037c4
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 1c 38 80 00       	push   $0x80381c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 74 37 80 00       	push   $0x803774
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 f6 14 00 00       	call   801772 <sys_enable_interrupt>

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
  80028f:	e8 83 16 00 00       	call   801917 <sys_destroy_env>
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
  8002a0:	e8 d8 16 00 00       	call   80197d <sys_exit_env>
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
  8002ee:	e8 b7 12 00 00       	call   8015aa <sys_cputs>
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
  800365:	e8 40 12 00 00       	call   8015aa <sys_cputs>
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
  8003af:	e8 a4 13 00 00       	call   801758 <sys_disable_interrupt>
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
  8003cf:	e8 9e 13 00 00       	call   801772 <sys_enable_interrupt>
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
  800419:	e8 a6 30 00 00       	call   8034c4 <__udivdi3>
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
  800469:	e8 66 31 00 00       	call   8035d4 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 54 3a 80 00       	add    $0x803a54,%eax
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
  8005c4:	8b 04 85 78 3a 80 00 	mov    0x803a78(,%eax,4),%eax
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
  8006a5:	8b 34 9d c0 38 80 00 	mov    0x8038c0(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 65 3a 80 00       	push   $0x803a65
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
  8006ca:	68 6e 3a 80 00       	push   $0x803a6e
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
  8006f7:	be 71 3a 80 00       	mov    $0x803a71,%esi
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
  80111d:	68 d0 3b 80 00       	push   $0x803bd0
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
  8011ed:	e8 fc 04 00 00       	call   8016ee <sys_allocate_chunk>
  8011f2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	e8 71 0b 00 00       	call   801d74 <initialize_MemBlocksList>
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
  80122b:	68 f5 3b 80 00       	push   $0x803bf5
  801230:	6a 33                	push   $0x33
  801232:	68 13 3c 80 00       	push   $0x803c13
  801237:	e8 a5 20 00 00       	call   8032e1 <_panic>
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
  8012aa:	68 20 3c 80 00       	push   $0x803c20
  8012af:	6a 34                	push   $0x34
  8012b1:	68 13 3c 80 00       	push   $0x803c13
  8012b6:	e8 26 20 00 00       	call   8032e1 <_panic>
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
  801307:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80130a:	e8 f7 fd ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  80130f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801313:	75 07                	jne    80131c <malloc+0x18>
  801315:	b8 00 00 00 00       	mov    $0x0,%eax
  80131a:	eb 61                	jmp    80137d <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80131c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801323:	8b 55 08             	mov    0x8(%ebp),%edx
  801326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	48                   	dec    %eax
  80132c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80132f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801332:	ba 00 00 00 00       	mov    $0x0,%edx
  801337:	f7 75 f0             	divl   -0x10(%ebp)
  80133a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133d:	29 d0                	sub    %edx,%eax
  80133f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801342:	e8 75 07 00 00       	call   801abc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801347:	85 c0                	test   %eax,%eax
  801349:	74 11                	je     80135c <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	ff 75 e8             	pushl  -0x18(%ebp)
  801351:	e8 e0 0d 00 00       	call   802136 <alloc_block_FF>
  801356:	83 c4 10             	add    $0x10,%esp
  801359:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80135c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801360:	74 16                	je     801378 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801362:	83 ec 0c             	sub    $0xc,%esp
  801365:	ff 75 f4             	pushl  -0xc(%ebp)
  801368:	e8 3c 0b 00 00       	call   801ea9 <insert_sorted_allocList>
  80136d:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801373:	8b 40 08             	mov    0x8(%eax),%eax
  801376:	eb 05                	jmp    80137d <malloc+0x79>
	}

    return NULL;
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	68 44 3c 80 00       	push   $0x803c44
  80138d:	6a 6f                	push   $0x6f
  80138f:	68 13 3c 80 00       	push   $0x803c13
  801394:	e8 48 1f 00 00       	call   8032e1 <_panic>

00801399 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 38             	sub    $0x38,%esp
  80139f:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a2:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013a5:	e8 5c fd ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ae:	75 0a                	jne    8013ba <smalloc+0x21>
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	e9 8b 00 00 00       	jmp    801445 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8013ba:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	48                   	dec    %eax
  8013ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d5:	f7 75 f0             	divl   -0x10(%ebp)
  8013d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013db:	29 d0                	sub    %edx,%eax
  8013dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8013e0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013e7:	e8 d0 06 00 00       	call   801abc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	74 11                	je     801401 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8013f0:	83 ec 0c             	sub    $0xc,%esp
  8013f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f6:	e8 3b 0d 00 00       	call   802136 <alloc_block_FF>
  8013fb:	83 c4 10             	add    $0x10,%esp
  8013fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801401:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801405:	74 39                	je     801440 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140a:	8b 40 08             	mov    0x8(%eax),%eax
  80140d:	89 c2                	mov    %eax,%edx
  80140f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801413:	52                   	push   %edx
  801414:	50                   	push   %eax
  801415:	ff 75 0c             	pushl  0xc(%ebp)
  801418:	ff 75 08             	pushl  0x8(%ebp)
  80141b:	e8 21 04 00 00       	call   801841 <sys_createSharedObject>
  801420:	83 c4 10             	add    $0x10,%esp
  801423:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801426:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80142a:	74 14                	je     801440 <smalloc+0xa7>
  80142c:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801430:	74 0e                	je     801440 <smalloc+0xa7>
  801432:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801436:	74 08                	je     801440 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143b:	8b 40 08             	mov    0x8(%eax),%eax
  80143e:	eb 05                	jmp    801445 <smalloc+0xac>
	}
	return NULL;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80144d:	e8 b4 fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801452:	83 ec 08             	sub    $0x8,%esp
  801455:	ff 75 0c             	pushl  0xc(%ebp)
  801458:	ff 75 08             	pushl  0x8(%ebp)
  80145b:	e8 0b 04 00 00       	call   80186b <sys_getSizeOfSharedObject>
  801460:	83 c4 10             	add    $0x10,%esp
  801463:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801466:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80146a:	74 76                	je     8014e2 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80146c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	48                   	dec    %eax
  80147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80147f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801482:	ba 00 00 00 00       	mov    $0x0,%edx
  801487:	f7 75 ec             	divl   -0x14(%ebp)
  80148a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148d:	29 d0                	sub    %edx,%eax
  80148f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801499:	e8 1e 06 00 00       	call   801abc <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	74 11                	je     8014b3 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a8:	e8 89 0c 00 00       	call   802136 <alloc_block_FF>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8014b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014b7:	74 29                	je     8014e2 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8014b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bc:	8b 40 08             	mov    0x8(%eax),%eax
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	50                   	push   %eax
  8014c3:	ff 75 0c             	pushl  0xc(%ebp)
  8014c6:	ff 75 08             	pushl  0x8(%ebp)
  8014c9:	e8 ba 03 00 00       	call   801888 <sys_getSharedObject>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8014d4:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8014d8:	74 08                	je     8014e2 <sget+0x9b>
				return (void *)mem_block->sva;
  8014da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dd:	8b 40 08             	mov    0x8(%eax),%eax
  8014e0:	eb 05                	jmp    8014e7 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8014e2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014e7:	c9                   	leave  
  8014e8:	c3                   	ret    

008014e9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ef:	e8 12 fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	68 68 3c 80 00       	push   $0x803c68
  8014fc:	68 f1 00 00 00       	push   $0xf1
  801501:	68 13 3c 80 00       	push   $0x803c13
  801506:	e8 d6 1d 00 00       	call   8032e1 <_panic>

0080150b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801511:	83 ec 04             	sub    $0x4,%esp
  801514:	68 90 3c 80 00       	push   $0x803c90
  801519:	68 05 01 00 00       	push   $0x105
  80151e:	68 13 3c 80 00       	push   $0x803c13
  801523:	e8 b9 1d 00 00       	call   8032e1 <_panic>

00801528 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	68 b4 3c 80 00       	push   $0x803cb4
  801536:	68 10 01 00 00       	push   $0x110
  80153b:	68 13 3c 80 00       	push   $0x803c13
  801540:	e8 9c 1d 00 00       	call   8032e1 <_panic>

00801545 <shrink>:

}
void shrink(uint32 newSize)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154b:	83 ec 04             	sub    $0x4,%esp
  80154e:	68 b4 3c 80 00       	push   $0x803cb4
  801553:	68 15 01 00 00       	push   $0x115
  801558:	68 13 3c 80 00       	push   $0x803c13
  80155d:	e8 7f 1d 00 00       	call   8032e1 <_panic>

00801562 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
  801565:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801568:	83 ec 04             	sub    $0x4,%esp
  80156b:	68 b4 3c 80 00       	push   $0x803cb4
  801570:	68 1a 01 00 00       	push   $0x11a
  801575:	68 13 3c 80 00       	push   $0x803c13
  80157a:	e8 62 1d 00 00       	call   8032e1 <_panic>

0080157f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	57                   	push   %edi
  801583:	56                   	push   %esi
  801584:	53                   	push   %ebx
  801585:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801591:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801594:	8b 7d 18             	mov    0x18(%ebp),%edi
  801597:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80159a:	cd 30                	int    $0x30
  80159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	52                   	push   %edx
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	50                   	push   %eax
  8015c6:	6a 00                	push   $0x0
  8015c8:	e8 b2 ff ff ff       	call   80157f <syscall>
  8015cd:	83 c4 18             	add    $0x18,%esp
}
  8015d0:	90                   	nop
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 01                	push   $0x1
  8015e2:	e8 98 ff ff ff       	call   80157f <syscall>
  8015e7:	83 c4 18             	add    $0x18,%esp
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	52                   	push   %edx
  8015fc:	50                   	push   %eax
  8015fd:	6a 05                	push   $0x5
  8015ff:	e8 7b ff ff ff       	call   80157f <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	56                   	push   %esi
  80160d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80160e:	8b 75 18             	mov    0x18(%ebp),%esi
  801611:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801614:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	56                   	push   %esi
  80161e:	53                   	push   %ebx
  80161f:	51                   	push   %ecx
  801620:	52                   	push   %edx
  801621:	50                   	push   %eax
  801622:	6a 06                	push   $0x6
  801624:	e8 56 ff ff ff       	call   80157f <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
}
  80162c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162f:	5b                   	pop    %ebx
  801630:	5e                   	pop    %esi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801636:	8b 55 0c             	mov    0xc(%ebp),%edx
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	52                   	push   %edx
  801643:	50                   	push   %eax
  801644:	6a 07                	push   $0x7
  801646:	e8 34 ff ff ff       	call   80157f <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	ff 75 0c             	pushl  0xc(%ebp)
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	6a 08                	push   $0x8
  801661:	e8 19 ff ff ff       	call   80157f <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 09                	push   $0x9
  80167a:	e8 00 ff ff ff       	call   80157f <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 0a                	push   $0xa
  801693:	e8 e7 fe ff ff       	call   80157f <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 0b                	push   $0xb
  8016ac:	e8 ce fe ff ff       	call   80157f <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	6a 0f                	push   $0xf
  8016c7:	e8 b3 fe ff ff       	call   80157f <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
	return;
  8016cf:	90                   	nop
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	ff 75 08             	pushl  0x8(%ebp)
  8016e1:	6a 10                	push   $0x10
  8016e3:	e8 97 fe ff ff       	call   80157f <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8016eb:	90                   	nop
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	ff 75 10             	pushl  0x10(%ebp)
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	ff 75 08             	pushl  0x8(%ebp)
  8016fe:	6a 11                	push   $0x11
  801700:	e8 7a fe ff ff       	call   80157f <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
	return ;
  801708:	90                   	nop
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 0c                	push   $0xc
  80171a:	e8 60 fe ff ff       	call   80157f <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	6a 0d                	push   $0xd
  801734:	e8 46 fe ff ff       	call   80157f <syscall>
  801739:	83 c4 18             	add    $0x18,%esp
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 0e                	push   $0xe
  80174d:	e8 2d fe ff ff       	call   80157f <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	90                   	nop
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 13                	push   $0x13
  801767:	e8 13 fe ff ff       	call   80157f <syscall>
  80176c:	83 c4 18             	add    $0x18,%esp
}
  80176f:	90                   	nop
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 14                	push   $0x14
  801781:	e8 f9 fd ff ff       	call   80157f <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	90                   	nop
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_cputc>:


void
sys_cputc(const char c)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801798:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	50                   	push   %eax
  8017a5:	6a 15                	push   $0x15
  8017a7:	e8 d3 fd ff ff       	call   80157f <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	90                   	nop
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 16                	push   $0x16
  8017c1:	e8 b9 fd ff ff       	call   80157f <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	90                   	nop
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	50                   	push   %eax
  8017dc:	6a 17                	push   $0x17
  8017de:	e8 9c fd ff ff       	call   80157f <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 1a                	push   $0x1a
  8017fb:	e8 7f fd ff ff       	call   80157f <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	52                   	push   %edx
  801815:	50                   	push   %eax
  801816:	6a 18                	push   $0x18
  801818:	e8 62 fd ff ff       	call   80157f <syscall>
  80181d:	83 c4 18             	add    $0x18,%esp
}
  801820:	90                   	nop
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801826:	8b 55 0c             	mov    0xc(%ebp),%edx
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	52                   	push   %edx
  801833:	50                   	push   %eax
  801834:	6a 19                	push   $0x19
  801836:	e8 44 fd ff ff       	call   80157f <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
}
  80183e:	90                   	nop
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	8b 45 10             	mov    0x10(%ebp),%eax
  80184a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80184d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801850:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	51                   	push   %ecx
  80185a:	52                   	push   %edx
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	50                   	push   %eax
  80185f:	6a 1b                	push   $0x1b
  801861:	e8 19 fd ff ff       	call   80157f <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80186e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	52                   	push   %edx
  80187b:	50                   	push   %eax
  80187c:	6a 1c                	push   $0x1c
  80187e:	e8 fc fc ff ff       	call   80157f <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80188b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	51                   	push   %ecx
  801899:	52                   	push   %edx
  80189a:	50                   	push   %eax
  80189b:	6a 1d                	push   $0x1d
  80189d:	e8 dd fc ff ff       	call   80157f <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 1e                	push   $0x1e
  8018ba:	e8 c0 fc ff ff       	call   80157f <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 1f                	push   $0x1f
  8018d3:	e8 a7 fc ff ff       	call   80157f <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	6a 00                	push   $0x0
  8018e5:	ff 75 14             	pushl  0x14(%ebp)
  8018e8:	ff 75 10             	pushl  0x10(%ebp)
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	50                   	push   %eax
  8018ef:	6a 20                	push   $0x20
  8018f1:	e8 89 fc ff ff       	call   80157f <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	50                   	push   %eax
  80190a:	6a 21                	push   $0x21
  80190c:	e8 6e fc ff ff       	call   80157f <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	90                   	nop
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	50                   	push   %eax
  801926:	6a 22                	push   $0x22
  801928:	e8 52 fc ff ff       	call   80157f <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 02                	push   $0x2
  801941:	e8 39 fc ff ff       	call   80157f <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 03                	push   $0x3
  80195a:	e8 20 fc ff ff       	call   80157f <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 04                	push   $0x4
  801973:	e8 07 fc ff ff       	call   80157f <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_exit_env>:


void sys_exit_env(void)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 23                	push   $0x23
  80198c:	e8 ee fb ff ff       	call   80157f <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80199d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a0:	8d 50 04             	lea    0x4(%eax),%edx
  8019a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	52                   	push   %edx
  8019ad:	50                   	push   %eax
  8019ae:	6a 24                	push   $0x24
  8019b0:	e8 ca fb ff ff       	call   80157f <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c1:	89 01                	mov    %eax,(%ecx)
  8019c3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	c9                   	leave  
  8019ca:	c2 04 00             	ret    $0x4

008019cd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 10             	pushl  0x10(%ebp)
  8019d7:	ff 75 0c             	pushl  0xc(%ebp)
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 12                	push   $0x12
  8019df:	e8 9b fb ff ff       	call   80157f <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_rcr2>:
uint32 sys_rcr2()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 25                	push   $0x25
  8019f9:	e8 81 fb ff ff       	call   80157f <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	50                   	push   %eax
  801a1c:	6a 26                	push   $0x26
  801a1e:	e8 5c fb ff ff       	call   80157f <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return ;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <rsttst>:
void rsttst()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 28                	push   $0x28
  801a38:	e8 42 fb ff ff       	call   80157f <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4f:	8b 55 18             	mov    0x18(%ebp),%edx
  801a52:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	ff 75 10             	pushl  0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	6a 27                	push   $0x27
  801a63:	e8 17 fb ff ff       	call   80157f <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6b:	90                   	nop
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <chktst>:
void chktst(uint32 n)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	6a 29                	push   $0x29
  801a7e:	e8 fc fa ff ff       	call   80157f <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
	return ;
  801a86:	90                   	nop
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <inctst>:

void inctst()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 2a                	push   $0x2a
  801a98:	e8 e2 fa ff ff       	call   80157f <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa0:	90                   	nop
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <gettst>:
uint32 gettst()
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 2b                	push   $0x2b
  801ab2:	e8 c8 fa ff ff       	call   80157f <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 2c                	push   $0x2c
  801ace:	e8 ac fa ff ff       	call   80157f <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
  801ad6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ad9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801add:	75 07                	jne    801ae6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801adf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae4:	eb 05                	jmp    801aeb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 2c                	push   $0x2c
  801aff:	e8 7b fa ff ff       	call   80157f <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
  801b07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b0a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b0e:	75 07                	jne    801b17 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b10:	b8 01 00 00 00       	mov    $0x1,%eax
  801b15:	eb 05                	jmp    801b1c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 2c                	push   $0x2c
  801b30:	e8 4a fa ff ff       	call   80157f <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
  801b38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b3b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b3f:	75 07                	jne    801b48 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b41:	b8 01 00 00 00       	mov    $0x1,%eax
  801b46:	eb 05                	jmp    801b4d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 2c                	push   $0x2c
  801b61:	e8 19 fa ff ff       	call   80157f <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
  801b69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b6c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b70:	75 07                	jne    801b79 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b72:	b8 01 00 00 00       	mov    $0x1,%eax
  801b77:	eb 05                	jmp    801b7e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	ff 75 08             	pushl  0x8(%ebp)
  801b8e:	6a 2d                	push   $0x2d
  801b90:	e8 ea f9 ff ff       	call   80157f <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
	return ;
  801b98:	90                   	nop
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b9f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	53                   	push   %ebx
  801bae:	51                   	push   %ecx
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 2e                	push   $0x2e
  801bb3:	e8 c7 f9 ff ff       	call   80157f <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	52                   	push   %edx
  801bd0:	50                   	push   %eax
  801bd1:	6a 2f                	push   $0x2f
  801bd3:	e8 a7 f9 ff ff       	call   80157f <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	68 c4 3c 80 00       	push   $0x803cc4
  801beb:	e8 8c e7 ff ff       	call   80037c <cprintf>
  801bf0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801bf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 f0 3c 80 00       	push   $0x803cf0
  801c02:	e8 75 e7 ff ff       	call   80037c <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c0a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c0e:	a1 38 41 80 00       	mov    0x804138,%eax
  801c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c16:	eb 56                	jmp    801c6e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c1c:	74 1c                	je     801c3a <print_mem_block_lists+0x5d>
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	8b 50 08             	mov    0x8(%eax),%edx
  801c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c27:	8b 48 08             	mov    0x8(%eax),%ecx
  801c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c30:	01 c8                	add    %ecx,%eax
  801c32:	39 c2                	cmp    %eax,%edx
  801c34:	73 04                	jae    801c3a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c36:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3d:	8b 50 08             	mov    0x8(%eax),%edx
  801c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c43:	8b 40 0c             	mov    0xc(%eax),%eax
  801c46:	01 c2                	add    %eax,%edx
  801c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4b:	8b 40 08             	mov    0x8(%eax),%eax
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	68 05 3d 80 00       	push   $0x803d05
  801c58:	e8 1f e7 ff ff       	call   80037c <cprintf>
  801c5d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c66:	a1 40 41 80 00       	mov    0x804140,%eax
  801c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c72:	74 07                	je     801c7b <print_mem_block_lists+0x9e>
  801c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c77:	8b 00                	mov    (%eax),%eax
  801c79:	eb 05                	jmp    801c80 <print_mem_block_lists+0xa3>
  801c7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801c80:	a3 40 41 80 00       	mov    %eax,0x804140
  801c85:	a1 40 41 80 00       	mov    0x804140,%eax
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	75 8a                	jne    801c18 <print_mem_block_lists+0x3b>
  801c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c92:	75 84                	jne    801c18 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c94:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c98:	75 10                	jne    801caa <print_mem_block_lists+0xcd>
  801c9a:	83 ec 0c             	sub    $0xc,%esp
  801c9d:	68 14 3d 80 00       	push   $0x803d14
  801ca2:	e8 d5 e6 ff ff       	call   80037c <cprintf>
  801ca7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801cb1:	83 ec 0c             	sub    $0xc,%esp
  801cb4:	68 38 3d 80 00       	push   $0x803d38
  801cb9:	e8 be e6 ff ff       	call   80037c <cprintf>
  801cbe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801cc1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801cc5:	a1 40 40 80 00       	mov    0x804040,%eax
  801cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ccd:	eb 56                	jmp    801d25 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ccf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd3:	74 1c                	je     801cf1 <print_mem_block_lists+0x114>
  801cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd8:	8b 50 08             	mov    0x8(%eax),%edx
  801cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cde:	8b 48 08             	mov    0x8(%eax),%ecx
  801ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce7:	01 c8                	add    %ecx,%eax
  801ce9:	39 c2                	cmp    %eax,%edx
  801ceb:	73 04                	jae    801cf1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ced:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf4:	8b 50 08             	mov    0x8(%eax),%edx
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfd:	01 c2                	add    %eax,%edx
  801cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d02:	8b 40 08             	mov    0x8(%eax),%eax
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	52                   	push   %edx
  801d09:	50                   	push   %eax
  801d0a:	68 05 3d 80 00       	push   $0x803d05
  801d0f:	e8 68 e6 ff ff       	call   80037c <cprintf>
  801d14:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d1d:	a1 48 40 80 00       	mov    0x804048,%eax
  801d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d29:	74 07                	je     801d32 <print_mem_block_lists+0x155>
  801d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2e:	8b 00                	mov    (%eax),%eax
  801d30:	eb 05                	jmp    801d37 <print_mem_block_lists+0x15a>
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
  801d37:	a3 48 40 80 00       	mov    %eax,0x804048
  801d3c:	a1 48 40 80 00       	mov    0x804048,%eax
  801d41:	85 c0                	test   %eax,%eax
  801d43:	75 8a                	jne    801ccf <print_mem_block_lists+0xf2>
  801d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d49:	75 84                	jne    801ccf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d4b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d4f:	75 10                	jne    801d61 <print_mem_block_lists+0x184>
  801d51:	83 ec 0c             	sub    $0xc,%esp
  801d54:	68 50 3d 80 00       	push   $0x803d50
  801d59:	e8 1e e6 ff ff       	call   80037c <cprintf>
  801d5e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	68 c4 3c 80 00       	push   $0x803cc4
  801d69:	e8 0e e6 ff ff       	call   80037c <cprintf>
  801d6e:	83 c4 10             	add    $0x10,%esp

}
  801d71:	90                   	nop
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801d7a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801d81:	00 00 00 
  801d84:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801d8b:	00 00 00 
  801d8e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d95:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d9f:	e9 9e 00 00 00       	jmp    801e42 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801da4:	a1 50 40 80 00       	mov    0x804050,%eax
  801da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dac:	c1 e2 04             	shl    $0x4,%edx
  801daf:	01 d0                	add    %edx,%eax
  801db1:	85 c0                	test   %eax,%eax
  801db3:	75 14                	jne    801dc9 <initialize_MemBlocksList+0x55>
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	68 78 3d 80 00       	push   $0x803d78
  801dbd:	6a 46                	push   $0x46
  801dbf:	68 9b 3d 80 00       	push   $0x803d9b
  801dc4:	e8 18 15 00 00       	call   8032e1 <_panic>
  801dc9:	a1 50 40 80 00       	mov    0x804050,%eax
  801dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd1:	c1 e2 04             	shl    $0x4,%edx
  801dd4:	01 d0                	add    %edx,%eax
  801dd6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ddc:	89 10                	mov    %edx,(%eax)
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	85 c0                	test   %eax,%eax
  801de2:	74 18                	je     801dfc <initialize_MemBlocksList+0x88>
  801de4:	a1 48 41 80 00       	mov    0x804148,%eax
  801de9:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801def:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801df2:	c1 e1 04             	shl    $0x4,%ecx
  801df5:	01 ca                	add    %ecx,%edx
  801df7:	89 50 04             	mov    %edx,0x4(%eax)
  801dfa:	eb 12                	jmp    801e0e <initialize_MemBlocksList+0x9a>
  801dfc:	a1 50 40 80 00       	mov    0x804050,%eax
  801e01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e04:	c1 e2 04             	shl    $0x4,%edx
  801e07:	01 d0                	add    %edx,%eax
  801e09:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e0e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e16:	c1 e2 04             	shl    $0x4,%edx
  801e19:	01 d0                	add    %edx,%eax
  801e1b:	a3 48 41 80 00       	mov    %eax,0x804148
  801e20:	a1 50 40 80 00       	mov    0x804050,%eax
  801e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e28:	c1 e2 04             	shl    $0x4,%edx
  801e2b:	01 d0                	add    %edx,%eax
  801e2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e34:	a1 54 41 80 00       	mov    0x804154,%eax
  801e39:	40                   	inc    %eax
  801e3a:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801e3f:	ff 45 f4             	incl   -0xc(%ebp)
  801e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e45:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e48:	0f 82 56 ff ff ff    	jb     801da4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801e4e:	90                   	nop
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	8b 00                	mov    (%eax),%eax
  801e5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e5f:	eb 19                	jmp    801e7a <find_block+0x29>
	{
		if(va==point->sva)
  801e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e64:	8b 40 08             	mov    0x8(%eax),%eax
  801e67:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e6a:	75 05                	jne    801e71 <find_block+0x20>
		   return point;
  801e6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6f:	eb 36                	jmp    801ea7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	8b 40 08             	mov    0x8(%eax),%eax
  801e77:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e7a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e7e:	74 07                	je     801e87 <find_block+0x36>
  801e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e83:	8b 00                	mov    (%eax),%eax
  801e85:	eb 05                	jmp    801e8c <find_block+0x3b>
  801e87:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8f:	89 42 08             	mov    %eax,0x8(%edx)
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	8b 40 08             	mov    0x8(%eax),%eax
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	75 c5                	jne    801e61 <find_block+0x10>
  801e9c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ea0:	75 bf                	jne    801e61 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801eaf:	a1 40 40 80 00       	mov    0x804040,%eax
  801eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801eb7:	a1 44 40 80 00       	mov    0x804044,%eax
  801ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ec5:	74 24                	je     801eeb <insert_sorted_allocList+0x42>
  801ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eca:	8b 50 08             	mov    0x8(%eax),%edx
  801ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed0:	8b 40 08             	mov    0x8(%eax),%eax
  801ed3:	39 c2                	cmp    %eax,%edx
  801ed5:	76 14                	jbe    801eeb <insert_sorted_allocList+0x42>
  801ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eda:	8b 50 08             	mov    0x8(%eax),%edx
  801edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee0:	8b 40 08             	mov    0x8(%eax),%eax
  801ee3:	39 c2                	cmp    %eax,%edx
  801ee5:	0f 82 60 01 00 00    	jb     80204b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801eeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eef:	75 65                	jne    801f56 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ef5:	75 14                	jne    801f0b <insert_sorted_allocList+0x62>
  801ef7:	83 ec 04             	sub    $0x4,%esp
  801efa:	68 78 3d 80 00       	push   $0x803d78
  801eff:	6a 6b                	push   $0x6b
  801f01:	68 9b 3d 80 00       	push   $0x803d9b
  801f06:	e8 d6 13 00 00       	call   8032e1 <_panic>
  801f0b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	89 10                	mov    %edx,(%eax)
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	74 0d                	je     801f2c <insert_sorted_allocList+0x83>
  801f1f:	a1 40 40 80 00       	mov    0x804040,%eax
  801f24:	8b 55 08             	mov    0x8(%ebp),%edx
  801f27:	89 50 04             	mov    %edx,0x4(%eax)
  801f2a:	eb 08                	jmp    801f34 <insert_sorted_allocList+0x8b>
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	a3 44 40 80 00       	mov    %eax,0x804044
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	a3 40 40 80 00       	mov    %eax,0x804040
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f46:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f4b:	40                   	inc    %eax
  801f4c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f51:	e9 dc 01 00 00       	jmp    802132 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	8b 50 08             	mov    0x8(%eax),%edx
  801f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	39 c2                	cmp    %eax,%edx
  801f64:	77 6c                	ja     801fd2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801f66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6a:	74 06                	je     801f72 <insert_sorted_allocList+0xc9>
  801f6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f70:	75 14                	jne    801f86 <insert_sorted_allocList+0xdd>
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	68 b4 3d 80 00       	push   $0x803db4
  801f7a:	6a 6f                	push   $0x6f
  801f7c:	68 9b 3d 80 00       	push   $0x803d9b
  801f81:	e8 5b 13 00 00       	call   8032e1 <_panic>
  801f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f89:	8b 50 04             	mov    0x4(%eax),%edx
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	89 50 04             	mov    %edx,0x4(%eax)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f98:	89 10                	mov    %edx,(%eax)
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	8b 40 04             	mov    0x4(%eax),%eax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	74 0d                	je     801fb1 <insert_sorted_allocList+0x108>
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	8b 40 04             	mov    0x4(%eax),%eax
  801faa:	8b 55 08             	mov    0x8(%ebp),%edx
  801fad:	89 10                	mov    %edx,(%eax)
  801faf:	eb 08                	jmp    801fb9 <insert_sorted_allocList+0x110>
  801fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb4:	a3 40 40 80 00       	mov    %eax,0x804040
  801fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbf:	89 50 04             	mov    %edx,0x4(%eax)
  801fc2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fc7:	40                   	inc    %eax
  801fc8:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fcd:	e9 60 01 00 00       	jmp    802132 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdb:	8b 40 08             	mov    0x8(%eax),%eax
  801fde:	39 c2                	cmp    %eax,%edx
  801fe0:	0f 82 4c 01 00 00    	jb     802132 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801fe6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fea:	75 14                	jne    802000 <insert_sorted_allocList+0x157>
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	68 ec 3d 80 00       	push   $0x803dec
  801ff4:	6a 73                	push   $0x73
  801ff6:	68 9b 3d 80 00       	push   $0x803d9b
  801ffb:	e8 e1 12 00 00       	call   8032e1 <_panic>
  802000:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	89 50 04             	mov    %edx,0x4(%eax)
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	8b 40 04             	mov    0x4(%eax),%eax
  802012:	85 c0                	test   %eax,%eax
  802014:	74 0c                	je     802022 <insert_sorted_allocList+0x179>
  802016:	a1 44 40 80 00       	mov    0x804044,%eax
  80201b:	8b 55 08             	mov    0x8(%ebp),%edx
  80201e:	89 10                	mov    %edx,(%eax)
  802020:	eb 08                	jmp    80202a <insert_sorted_allocList+0x181>
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	a3 40 40 80 00       	mov    %eax,0x804040
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	a3 44 40 80 00       	mov    %eax,0x804044
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802040:	40                   	inc    %eax
  802041:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802046:	e9 e7 00 00 00       	jmp    802132 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80204b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802051:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802058:	a1 40 40 80 00       	mov    0x804040,%eax
  80205d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802060:	e9 9d 00 00 00       	jmp    802102 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 50 08             	mov    0x8(%eax),%edx
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	39 c2                	cmp    %eax,%edx
  80207b:	76 7d                	jbe    8020fa <insert_sorted_allocList+0x251>
  80207d:	8b 45 08             	mov    0x8(%ebp),%eax
  802080:	8b 50 08             	mov    0x8(%eax),%edx
  802083:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802086:	8b 40 08             	mov    0x8(%eax),%eax
  802089:	39 c2                	cmp    %eax,%edx
  80208b:	73 6d                	jae    8020fa <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80208d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802091:	74 06                	je     802099 <insert_sorted_allocList+0x1f0>
  802093:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802097:	75 14                	jne    8020ad <insert_sorted_allocList+0x204>
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	68 10 3e 80 00       	push   $0x803e10
  8020a1:	6a 7f                	push   $0x7f
  8020a3:	68 9b 3d 80 00       	push   $0x803d9b
  8020a8:	e8 34 12 00 00       	call   8032e1 <_panic>
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 10                	mov    (%eax),%edx
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	89 10                	mov    %edx,(%eax)
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	8b 00                	mov    (%eax),%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	74 0b                	je     8020cb <insert_sorted_allocList+0x222>
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c8:	89 50 04             	mov    %edx,0x4(%eax)
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d1:	89 10                	mov    %edx,(%eax)
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	89 50 04             	mov    %edx,0x4(%eax)
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	75 08                	jne    8020ed <insert_sorted_allocList+0x244>
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	a3 44 40 80 00       	mov    %eax,0x804044
  8020ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f2:	40                   	inc    %eax
  8020f3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020f8:	eb 39                	jmp    802133 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020fa:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802106:	74 07                	je     80210f <insert_sorted_allocList+0x266>
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210b:	8b 00                	mov    (%eax),%eax
  80210d:	eb 05                	jmp    802114 <insert_sorted_allocList+0x26b>
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	a3 48 40 80 00       	mov    %eax,0x804048
  802119:	a1 48 40 80 00       	mov    0x804048,%eax
  80211e:	85 c0                	test   %eax,%eax
  802120:	0f 85 3f ff ff ff    	jne    802065 <insert_sorted_allocList+0x1bc>
  802126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212a:	0f 85 35 ff ff ff    	jne    802065 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802130:	eb 01                	jmp    802133 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802132:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802133:	90                   	nop
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80213c:	a1 38 41 80 00       	mov    0x804138,%eax
  802141:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802144:	e9 85 01 00 00       	jmp    8022ce <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 40 0c             	mov    0xc(%eax),%eax
  80214f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802152:	0f 82 6e 01 00 00    	jb     8022c6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	8b 40 0c             	mov    0xc(%eax),%eax
  80215e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802161:	0f 85 8a 00 00 00    	jne    8021f1 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216b:	75 17                	jne    802184 <alloc_block_FF+0x4e>
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	68 44 3e 80 00       	push   $0x803e44
  802175:	68 93 00 00 00       	push   $0x93
  80217a:	68 9b 3d 80 00       	push   $0x803d9b
  80217f:	e8 5d 11 00 00       	call   8032e1 <_panic>
  802184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802187:	8b 00                	mov    (%eax),%eax
  802189:	85 c0                	test   %eax,%eax
  80218b:	74 10                	je     80219d <alloc_block_FF+0x67>
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802195:	8b 52 04             	mov    0x4(%edx),%edx
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	eb 0b                	jmp    8021a8 <alloc_block_FF+0x72>
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 40 04             	mov    0x4(%eax),%eax
  8021a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 40 04             	mov    0x4(%eax),%eax
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	74 0f                	je     8021c1 <alloc_block_FF+0x8b>
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 40 04             	mov    0x4(%eax),%eax
  8021b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bb:	8b 12                	mov    (%edx),%edx
  8021bd:	89 10                	mov    %edx,(%eax)
  8021bf:	eb 0a                	jmp    8021cb <alloc_block_FF+0x95>
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021de:	a1 44 41 80 00       	mov    0x804144,%eax
  8021e3:	48                   	dec    %eax
  8021e4:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	e9 10 01 00 00       	jmp    802301 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021fa:	0f 86 c6 00 00 00    	jbe    8022c6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802200:	a1 48 41 80 00       	mov    0x804148,%eax
  802205:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220b:	8b 50 08             	mov    0x8(%eax),%edx
  80220e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802211:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802217:	8b 55 08             	mov    0x8(%ebp),%edx
  80221a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80221d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802221:	75 17                	jne    80223a <alloc_block_FF+0x104>
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 44 3e 80 00       	push   $0x803e44
  80222b:	68 9b 00 00 00       	push   $0x9b
  802230:	68 9b 3d 80 00       	push   $0x803d9b
  802235:	e8 a7 10 00 00       	call   8032e1 <_panic>
  80223a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 10                	je     802253 <alloc_block_FF+0x11d>
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224b:	8b 52 04             	mov    0x4(%edx),%edx
  80224e:	89 50 04             	mov    %edx,0x4(%eax)
  802251:	eb 0b                	jmp    80225e <alloc_block_FF+0x128>
  802253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802256:	8b 40 04             	mov    0x4(%eax),%eax
  802259:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	8b 40 04             	mov    0x4(%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 0f                	je     802277 <alloc_block_FF+0x141>
  802268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226b:	8b 40 04             	mov    0x4(%eax),%eax
  80226e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802271:	8b 12                	mov    (%edx),%edx
  802273:	89 10                	mov    %edx,(%eax)
  802275:	eb 0a                	jmp    802281 <alloc_block_FF+0x14b>
  802277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	a3 48 41 80 00       	mov    %eax,0x804148
  802281:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802284:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802294:	a1 54 41 80 00       	mov    0x804154,%eax
  802299:	48                   	dec    %eax
  80229a:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 50 08             	mov    0x8(%eax),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	01 c2                	add    %eax,%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8022b9:	89 c2                	mov    %eax,%edx
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8022c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c4:	eb 3b                	jmp    802301 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8022cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d2:	74 07                	je     8022db <alloc_block_FF+0x1a5>
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	eb 05                	jmp    8022e0 <alloc_block_FF+0x1aa>
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e0:	a3 40 41 80 00       	mov    %eax,0x804140
  8022e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ea:	85 c0                	test   %eax,%eax
  8022ec:	0f 85 57 fe ff ff    	jne    802149 <alloc_block_FF+0x13>
  8022f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f6:	0f 85 4d fe ff ff    	jne    802149 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8022fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802309:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802310:	a1 38 41 80 00       	mov    0x804138,%eax
  802315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802318:	e9 df 00 00 00       	jmp    8023fc <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 40 0c             	mov    0xc(%eax),%eax
  802323:	3b 45 08             	cmp    0x8(%ebp),%eax
  802326:	0f 82 c8 00 00 00    	jb     8023f4 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 0c             	mov    0xc(%eax),%eax
  802332:	3b 45 08             	cmp    0x8(%ebp),%eax
  802335:	0f 85 8a 00 00 00    	jne    8023c5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80233b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233f:	75 17                	jne    802358 <alloc_block_BF+0x55>
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	68 44 3e 80 00       	push   $0x803e44
  802349:	68 b7 00 00 00       	push   $0xb7
  80234e:	68 9b 3d 80 00       	push   $0x803d9b
  802353:	e8 89 0f 00 00       	call   8032e1 <_panic>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 10                	je     802371 <alloc_block_BF+0x6e>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 00                	mov    (%eax),%eax
  802366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802369:	8b 52 04             	mov    0x4(%edx),%edx
  80236c:	89 50 04             	mov    %edx,0x4(%eax)
  80236f:	eb 0b                	jmp    80237c <alloc_block_BF+0x79>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 40 04             	mov    0x4(%eax),%eax
  802377:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 40 04             	mov    0x4(%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 0f                	je     802395 <alloc_block_BF+0x92>
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238f:	8b 12                	mov    (%edx),%edx
  802391:	89 10                	mov    %edx,(%eax)
  802393:	eb 0a                	jmp    80239f <alloc_block_BF+0x9c>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	a3 38 41 80 00       	mov    %eax,0x804138
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b2:	a1 44 41 80 00       	mov    0x804144,%eax
  8023b7:	48                   	dec    %eax
  8023b8:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	e9 4d 01 00 00       	jmp    802512 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ce:	76 24                	jbe    8023f4 <alloc_block_BF+0xf1>
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023d9:	73 19                	jae    8023f4 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8023db:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 08             	mov    0x8(%eax),%eax
  8023f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023f4:	a1 40 41 80 00       	mov    0x804140,%eax
  8023f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802400:	74 07                	je     802409 <alloc_block_BF+0x106>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	eb 05                	jmp    80240e <alloc_block_BF+0x10b>
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	a3 40 41 80 00       	mov    %eax,0x804140
  802413:	a1 40 41 80 00       	mov    0x804140,%eax
  802418:	85 c0                	test   %eax,%eax
  80241a:	0f 85 fd fe ff ff    	jne    80231d <alloc_block_BF+0x1a>
  802420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802424:	0f 85 f3 fe ff ff    	jne    80231d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80242a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80242e:	0f 84 d9 00 00 00    	je     80250d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802434:	a1 48 41 80 00       	mov    0x804148,%eax
  802439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80243c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802442:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802445:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802448:	8b 55 08             	mov    0x8(%ebp),%edx
  80244b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80244e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802452:	75 17                	jne    80246b <alloc_block_BF+0x168>
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	68 44 3e 80 00       	push   $0x803e44
  80245c:	68 c7 00 00 00       	push   $0xc7
  802461:	68 9b 3d 80 00       	push   $0x803d9b
  802466:	e8 76 0e 00 00       	call   8032e1 <_panic>
  80246b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 10                	je     802484 <alloc_block_BF+0x181>
  802474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80247c:	8b 52 04             	mov    0x4(%edx),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	eb 0b                	jmp    80248f <alloc_block_BF+0x18c>
  802484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802487:	8b 40 04             	mov    0x4(%eax),%eax
  80248a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80248f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 0f                	je     8024a8 <alloc_block_BF+0x1a5>
  802499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a2:	8b 12                	mov    (%edx),%edx
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	eb 0a                	jmp    8024b2 <alloc_block_BF+0x1af>
  8024a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8024b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ca:	48                   	dec    %eax
  8024cb:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8024d0:	83 ec 08             	sub    $0x8,%esp
  8024d3:	ff 75 ec             	pushl  -0x14(%ebp)
  8024d6:	68 38 41 80 00       	push   $0x804138
  8024db:	e8 71 f9 ff ff       	call   801e51 <find_block>
  8024e0:	83 c4 10             	add    $0x10,%esp
  8024e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8024e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e9:	8b 50 08             	mov    0x8(%eax),%edx
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	01 c2                	add    %eax,%edx
  8024f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f4:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8024f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802500:	89 c2                	mov    %eax,%edx
  802502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802505:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250b:	eb 05                	jmp    802512 <alloc_block_BF+0x20f>
	}
	return NULL;
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80251a:	a1 28 40 80 00       	mov    0x804028,%eax
  80251f:	85 c0                	test   %eax,%eax
  802521:	0f 85 de 01 00 00    	jne    802705 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802527:	a1 38 41 80 00       	mov    0x804138,%eax
  80252c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252f:	e9 9e 01 00 00       	jmp    8026d2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 0c             	mov    0xc(%eax),%eax
  80253a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253d:	0f 82 87 01 00 00    	jb     8026ca <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 40 0c             	mov    0xc(%eax),%eax
  802549:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254c:	0f 85 95 00 00 00    	jne    8025e7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802556:	75 17                	jne    80256f <alloc_block_NF+0x5b>
  802558:	83 ec 04             	sub    $0x4,%esp
  80255b:	68 44 3e 80 00       	push   $0x803e44
  802560:	68 e0 00 00 00       	push   $0xe0
  802565:	68 9b 3d 80 00       	push   $0x803d9b
  80256a:	e8 72 0d 00 00       	call   8032e1 <_panic>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	85 c0                	test   %eax,%eax
  802576:	74 10                	je     802588 <alloc_block_NF+0x74>
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802580:	8b 52 04             	mov    0x4(%edx),%edx
  802583:	89 50 04             	mov    %edx,0x4(%eax)
  802586:	eb 0b                	jmp    802593 <alloc_block_NF+0x7f>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 40 04             	mov    0x4(%eax),%eax
  80258e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 40 04             	mov    0x4(%eax),%eax
  802599:	85 c0                	test   %eax,%eax
  80259b:	74 0f                	je     8025ac <alloc_block_NF+0x98>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 04             	mov    0x4(%eax),%eax
  8025a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a6:	8b 12                	mov    (%edx),%edx
  8025a8:	89 10                	mov    %edx,(%eax)
  8025aa:	eb 0a                	jmp    8025b6 <alloc_block_NF+0xa2>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8025ce:	48                   	dec    %eax
  8025cf:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 08             	mov    0x8(%eax),%eax
  8025da:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	e9 f8 04 00 00       	jmp    802adf <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f0:	0f 86 d4 00 00 00    	jbe    8026ca <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f6:	a1 48 41 80 00       	mov    0x804148,%eax
  8025fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 50 08             	mov    0x8(%eax),%edx
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	8b 55 08             	mov    0x8(%ebp),%edx
  802610:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802613:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802617:	75 17                	jne    802630 <alloc_block_NF+0x11c>
  802619:	83 ec 04             	sub    $0x4,%esp
  80261c:	68 44 3e 80 00       	push   $0x803e44
  802621:	68 e9 00 00 00       	push   $0xe9
  802626:	68 9b 3d 80 00       	push   $0x803d9b
  80262b:	e8 b1 0c 00 00       	call   8032e1 <_panic>
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	74 10                	je     802649 <alloc_block_NF+0x135>
  802639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802641:	8b 52 04             	mov    0x4(%edx),%edx
  802644:	89 50 04             	mov    %edx,0x4(%eax)
  802647:	eb 0b                	jmp    802654 <alloc_block_NF+0x140>
  802649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	8b 40 04             	mov    0x4(%eax),%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	74 0f                	je     80266d <alloc_block_NF+0x159>
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	8b 40 04             	mov    0x4(%eax),%eax
  802664:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802667:	8b 12                	mov    (%edx),%edx
  802669:	89 10                	mov    %edx,(%eax)
  80266b:	eb 0a                	jmp    802677 <alloc_block_NF+0x163>
  80266d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	a3 48 41 80 00       	mov    %eax,0x804148
  802677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802683:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268a:	a1 54 41 80 00       	mov    0x804154,%eax
  80268f:	48                   	dec    %eax
  802690:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802698:	8b 40 08             	mov    0x8(%eax),%eax
  80269b:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 50 08             	mov    0x8(%eax),%edx
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	01 c2                	add    %eax,%edx
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ba:	89 c2                	mov    %eax,%edx
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8026c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c5:	e9 15 04 00 00       	jmp    802adf <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d6:	74 07                	je     8026df <alloc_block_NF+0x1cb>
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	eb 05                	jmp    8026e4 <alloc_block_NF+0x1d0>
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	0f 85 3e fe ff ff    	jne    802534 <alloc_block_NF+0x20>
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	0f 85 34 fe ff ff    	jne    802534 <alloc_block_NF+0x20>
  802700:	e9 d5 03 00 00       	jmp    802ada <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802705:	a1 38 41 80 00       	mov    0x804138,%eax
  80270a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270d:	e9 b1 01 00 00       	jmp    8028c3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 50 08             	mov    0x8(%eax),%edx
  802718:	a1 28 40 80 00       	mov    0x804028,%eax
  80271d:	39 c2                	cmp    %eax,%edx
  80271f:	0f 82 96 01 00 00    	jb     8028bb <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 40 0c             	mov    0xc(%eax),%eax
  80272b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272e:	0f 82 87 01 00 00    	jb     8028bb <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273d:	0f 85 95 00 00 00    	jne    8027d8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	75 17                	jne    802760 <alloc_block_NF+0x24c>
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	68 44 3e 80 00       	push   $0x803e44
  802751:	68 fc 00 00 00       	push   $0xfc
  802756:	68 9b 3d 80 00       	push   $0x803d9b
  80275b:	e8 81 0b 00 00       	call   8032e1 <_panic>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 10                	je     802779 <alloc_block_NF+0x265>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802771:	8b 52 04             	mov    0x4(%edx),%edx
  802774:	89 50 04             	mov    %edx,0x4(%eax)
  802777:	eb 0b                	jmp    802784 <alloc_block_NF+0x270>
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 0f                	je     80279d <alloc_block_NF+0x289>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802797:	8b 12                	mov    (%edx),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	eb 0a                	jmp    8027a7 <alloc_block_NF+0x293>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8027bf:	48                   	dec    %eax
  8027c0:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 08             	mov    0x8(%eax),%eax
  8027cb:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	e9 07 03 00 00       	jmp    802adf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e1:	0f 86 d4 00 00 00    	jbe    8028bb <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e7:	a1 48 41 80 00       	mov    0x804148,%eax
  8027ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 50 08             	mov    0x8(%eax),%edx
  8027f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f8:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8027fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802801:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802804:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802808:	75 17                	jne    802821 <alloc_block_NF+0x30d>
  80280a:	83 ec 04             	sub    $0x4,%esp
  80280d:	68 44 3e 80 00       	push   $0x803e44
  802812:	68 04 01 00 00       	push   $0x104
  802817:	68 9b 3d 80 00       	push   $0x803d9b
  80281c:	e8 c0 0a 00 00       	call   8032e1 <_panic>
  802821:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	74 10                	je     80283a <alloc_block_NF+0x326>
  80282a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802832:	8b 52 04             	mov    0x4(%edx),%edx
  802835:	89 50 04             	mov    %edx,0x4(%eax)
  802838:	eb 0b                	jmp    802845 <alloc_block_NF+0x331>
  80283a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283d:	8b 40 04             	mov    0x4(%eax),%eax
  802840:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802845:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 0f                	je     80285e <alloc_block_NF+0x34a>
  80284f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802858:	8b 12                	mov    (%edx),%edx
  80285a:	89 10                	mov    %edx,(%eax)
  80285c:	eb 0a                	jmp    802868 <alloc_block_NF+0x354>
  80285e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	a3 48 41 80 00       	mov    %eax,0x804148
  802868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802874:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287b:	a1 54 41 80 00       	mov    0x804154,%eax
  802880:	48                   	dec    %eax
  802881:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802889:	8b 40 08             	mov    0x8(%eax),%eax
  80288c:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 50 08             	mov    0x8(%eax),%edx
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	01 c2                	add    %eax,%edx
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a8:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ab:	89 c2                	mov    %eax,%edx
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8028b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b6:	e9 24 02 00 00       	jmp    802adf <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8028c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c7:	74 07                	je     8028d0 <alloc_block_NF+0x3bc>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	eb 05                	jmp    8028d5 <alloc_block_NF+0x3c1>
  8028d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8028da:	a1 40 41 80 00       	mov    0x804140,%eax
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	0f 85 2b fe ff ff    	jne    802712 <alloc_block_NF+0x1fe>
  8028e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028eb:	0f 85 21 fe ff ff    	jne    802712 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028f1:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f9:	e9 ae 01 00 00       	jmp    802aac <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	a1 28 40 80 00       	mov    0x804028,%eax
  802909:	39 c2                	cmp    %eax,%edx
  80290b:	0f 83 93 01 00 00    	jae    802aa4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 0c             	mov    0xc(%eax),%eax
  802917:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291a:	0f 82 84 01 00 00    	jb     802aa4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 0c             	mov    0xc(%eax),%eax
  802926:	3b 45 08             	cmp    0x8(%ebp),%eax
  802929:	0f 85 95 00 00 00    	jne    8029c4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802933:	75 17                	jne    80294c <alloc_block_NF+0x438>
  802935:	83 ec 04             	sub    $0x4,%esp
  802938:	68 44 3e 80 00       	push   $0x803e44
  80293d:	68 14 01 00 00       	push   $0x114
  802942:	68 9b 3d 80 00       	push   $0x803d9b
  802947:	e8 95 09 00 00       	call   8032e1 <_panic>
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	74 10                	je     802965 <alloc_block_NF+0x451>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295d:	8b 52 04             	mov    0x4(%edx),%edx
  802960:	89 50 04             	mov    %edx,0x4(%eax)
  802963:	eb 0b                	jmp    802970 <alloc_block_NF+0x45c>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	85 c0                	test   %eax,%eax
  802978:	74 0f                	je     802989 <alloc_block_NF+0x475>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802983:	8b 12                	mov    (%edx),%edx
  802985:	89 10                	mov    %edx,(%eax)
  802987:	eb 0a                	jmp    802993 <alloc_block_NF+0x47f>
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	a3 38 41 80 00       	mov    %eax,0x804138
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ab:	48                   	dec    %eax
  8029ac:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 08             	mov    0x8(%eax),%eax
  8029b7:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	e9 1b 01 00 00       	jmp    802adf <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cd:	0f 86 d1 00 00 00    	jbe    802aa4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d3:	a1 48 41 80 00       	mov    0x804148,%eax
  8029d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 50 08             	mov    0x8(%eax),%edx
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ed:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f4:	75 17                	jne    802a0d <alloc_block_NF+0x4f9>
  8029f6:	83 ec 04             	sub    $0x4,%esp
  8029f9:	68 44 3e 80 00       	push   $0x803e44
  8029fe:	68 1c 01 00 00       	push   $0x11c
  802a03:	68 9b 3d 80 00       	push   $0x803d9b
  802a08:	e8 d4 08 00 00       	call   8032e1 <_panic>
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	85 c0                	test   %eax,%eax
  802a14:	74 10                	je     802a26 <alloc_block_NF+0x512>
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1e:	8b 52 04             	mov    0x4(%edx),%edx
  802a21:	89 50 04             	mov    %edx,0x4(%eax)
  802a24:	eb 0b                	jmp    802a31 <alloc_block_NF+0x51d>
  802a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a34:	8b 40 04             	mov    0x4(%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 0f                	je     802a4a <alloc_block_NF+0x536>
  802a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a44:	8b 12                	mov    (%edx),%edx
  802a46:	89 10                	mov    %edx,(%eax)
  802a48:	eb 0a                	jmp    802a54 <alloc_block_NF+0x540>
  802a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a67:	a1 54 41 80 00       	mov    0x804154,%eax
  802a6c:	48                   	dec    %eax
  802a6d:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a75:	8b 40 08             	mov    0x8(%eax),%eax
  802a78:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 50 08             	mov    0x8(%eax),%edx
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	01 c2                	add    %eax,%edx
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	2b 45 08             	sub    0x8(%ebp),%eax
  802a97:	89 c2                	mov    %eax,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa2:	eb 3b                	jmp    802adf <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa4:	a1 40 41 80 00       	mov    0x804140,%eax
  802aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab0:	74 07                	je     802ab9 <alloc_block_NF+0x5a5>
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	eb 05                	jmp    802abe <alloc_block_NF+0x5aa>
  802ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  802abe:	a3 40 41 80 00       	mov    %eax,0x804140
  802ac3:	a1 40 41 80 00       	mov    0x804140,%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	0f 85 2e fe ff ff    	jne    8028fe <alloc_block_NF+0x3ea>
  802ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad4:	0f 85 24 fe ff ff    	jne    8028fe <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ada:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802adf:	c9                   	leave  
  802ae0:	c3                   	ret    

00802ae1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ae1:	55                   	push   %ebp
  802ae2:	89 e5                	mov    %esp,%ebp
  802ae4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ae7:	a1 38 41 80 00       	mov    0x804138,%eax
  802aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802aef:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802af7:	a1 38 41 80 00       	mov    0x804138,%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	74 14                	je     802b14 <insert_sorted_with_merge_freeList+0x33>
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	8b 50 08             	mov    0x8(%eax),%edx
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	8b 40 08             	mov    0x8(%eax),%eax
  802b0c:	39 c2                	cmp    %eax,%edx
  802b0e:	0f 87 9b 01 00 00    	ja     802caf <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b18:	75 17                	jne    802b31 <insert_sorted_with_merge_freeList+0x50>
  802b1a:	83 ec 04             	sub    $0x4,%esp
  802b1d:	68 78 3d 80 00       	push   $0x803d78
  802b22:	68 38 01 00 00       	push   $0x138
  802b27:	68 9b 3d 80 00       	push   $0x803d9b
  802b2c:	e8 b0 07 00 00       	call   8032e1 <_panic>
  802b31:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0d                	je     802b52 <insert_sorted_with_merge_freeList+0x71>
  802b45:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4d:	89 50 04             	mov    %edx,0x4(%eax)
  802b50:	eb 08                	jmp    802b5a <insert_sorted_with_merge_freeList+0x79>
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6c:	a1 44 41 80 00       	mov    0x804144,%eax
  802b71:	40                   	inc    %eax
  802b72:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7b:	0f 84 a8 06 00 00    	je     803229 <insert_sorted_with_merge_freeList+0x748>
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	8b 50 08             	mov    0x8(%eax),%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8d:	01 c2                	add    %eax,%edx
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 40 08             	mov    0x8(%eax),%eax
  802b95:	39 c2                	cmp    %eax,%edx
  802b97:	0f 85 8c 06 00 00    	jne    803229 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba9:	01 c2                	add    %eax,%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802bb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb5:	75 17                	jne    802bce <insert_sorted_with_merge_freeList+0xed>
  802bb7:	83 ec 04             	sub    $0x4,%esp
  802bba:	68 44 3e 80 00       	push   $0x803e44
  802bbf:	68 3c 01 00 00       	push   $0x13c
  802bc4:	68 9b 3d 80 00       	push   $0x803d9b
  802bc9:	e8 13 07 00 00       	call   8032e1 <_panic>
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	74 10                	je     802be7 <insert_sorted_with_merge_freeList+0x106>
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdf:	8b 52 04             	mov    0x4(%edx),%edx
  802be2:	89 50 04             	mov    %edx,0x4(%eax)
  802be5:	eb 0b                	jmp    802bf2 <insert_sorted_with_merge_freeList+0x111>
  802be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf5:	8b 40 04             	mov    0x4(%eax),%eax
  802bf8:	85 c0                	test   %eax,%eax
  802bfa:	74 0f                	je     802c0b <insert_sorted_with_merge_freeList+0x12a>
  802bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bff:	8b 40 04             	mov    0x4(%eax),%eax
  802c02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c05:	8b 12                	mov    (%edx),%edx
  802c07:	89 10                	mov    %edx,(%eax)
  802c09:	eb 0a                	jmp    802c15 <insert_sorted_with_merge_freeList+0x134>
  802c0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	a3 38 41 80 00       	mov    %eax,0x804138
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c28:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2d:	48                   	dec    %eax
  802c2e:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4b:	75 17                	jne    802c64 <insert_sorted_with_merge_freeList+0x183>
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	68 78 3d 80 00       	push   $0x803d78
  802c55:	68 3f 01 00 00       	push   $0x13f
  802c5a:	68 9b 3d 80 00       	push   $0x803d9b
  802c5f:	e8 7d 06 00 00       	call   8032e1 <_panic>
  802c64:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	89 10                	mov    %edx,(%eax)
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	74 0d                	je     802c85 <insert_sorted_with_merge_freeList+0x1a4>
  802c78:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c80:	89 50 04             	mov    %edx,0x4(%eax)
  802c83:	eb 08                	jmp    802c8d <insert_sorted_with_merge_freeList+0x1ac>
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	a3 48 41 80 00       	mov    %eax,0x804148
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9f:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca4:	40                   	inc    %eax
  802ca5:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802caa:	e9 7a 05 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 08             	mov    0x8(%eax),%eax
  802cbb:	39 c2                	cmp    %eax,%edx
  802cbd:	0f 82 14 01 00 00    	jb     802dd7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	8b 50 08             	mov    0x8(%eax),%edx
  802cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	01 c2                	add    %eax,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 40 08             	mov    0x8(%eax),%eax
  802cd7:	39 c2                	cmp    %eax,%edx
  802cd9:	0f 85 90 00 00 00    	jne    802d6f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c2                	add    %eax,%edx
  802ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf0:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0b:	75 17                	jne    802d24 <insert_sorted_with_merge_freeList+0x243>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 78 3d 80 00       	push   $0x803d78
  802d15:	68 49 01 00 00       	push   $0x149
  802d1a:	68 9b 3d 80 00       	push   $0x803d9b
  802d1f:	e8 bd 05 00 00       	call   8032e1 <_panic>
  802d24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	89 10                	mov    %edx,(%eax)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 0d                	je     802d45 <insert_sorted_with_merge_freeList+0x264>
  802d38:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d40:	89 50 04             	mov    %edx,0x4(%eax)
  802d43:	eb 08                	jmp    802d4d <insert_sorted_with_merge_freeList+0x26c>
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	a3 48 41 80 00       	mov    %eax,0x804148
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d64:	40                   	inc    %eax
  802d65:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d6a:	e9 bb 04 00 00       	jmp    80322a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	75 17                	jne    802d8c <insert_sorted_with_merge_freeList+0x2ab>
  802d75:	83 ec 04             	sub    $0x4,%esp
  802d78:	68 ec 3d 80 00       	push   $0x803dec
  802d7d:	68 4c 01 00 00       	push   $0x14c
  802d82:	68 9b 3d 80 00       	push   $0x803d9b
  802d87:	e8 55 05 00 00       	call   8032e1 <_panic>
  802d8c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	89 50 04             	mov    %edx,0x4(%eax)
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 0c                	je     802dae <insert_sorted_with_merge_freeList+0x2cd>
  802da2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802da7:	8b 55 08             	mov    0x8(%ebp),%edx
  802daa:	89 10                	mov    %edx,(%eax)
  802dac:	eb 08                	jmp    802db6 <insert_sorted_with_merge_freeList+0x2d5>
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	a3 38 41 80 00       	mov    %eax,0x804138
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dcc:	40                   	inc    %eax
  802dcd:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dd2:	e9 53 04 00 00       	jmp    80322a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802dd7:	a1 38 41 80 00       	mov    0x804138,%eax
  802ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ddf:	e9 15 04 00 00       	jmp    8031f9 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	8b 50 08             	mov    0x8(%eax),%edx
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 40 08             	mov    0x8(%eax),%eax
  802df8:	39 c2                	cmp    %eax,%edx
  802dfa:	0f 86 f1 03 00 00    	jbe    8031f1 <insert_sorted_with_merge_freeList+0x710>
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	8b 50 08             	mov    0x8(%eax),%edx
  802e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	0f 83 dd 03 00 00    	jae    8031f1 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 50 08             	mov    0x8(%eax),%edx
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e20:	01 c2                	add    %eax,%edx
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	8b 40 08             	mov    0x8(%eax),%eax
  802e28:	39 c2                	cmp    %eax,%edx
  802e2a:	0f 85 b9 01 00 00    	jne    802fe9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 50 08             	mov    0x8(%eax),%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3c:	01 c2                	add    %eax,%edx
  802e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	39 c2                	cmp    %eax,%edx
  802e46:	0f 85 0d 01 00 00    	jne    802f59 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	01 c2                	add    %eax,%edx
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802e60:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e64:	75 17                	jne    802e7d <insert_sorted_with_merge_freeList+0x39c>
  802e66:	83 ec 04             	sub    $0x4,%esp
  802e69:	68 44 3e 80 00       	push   $0x803e44
  802e6e:	68 5c 01 00 00       	push   $0x15c
  802e73:	68 9b 3d 80 00       	push   $0x803d9b
  802e78:	e8 64 04 00 00       	call   8032e1 <_panic>
  802e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 10                	je     802e96 <insert_sorted_with_merge_freeList+0x3b5>
  802e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e8e:	8b 52 04             	mov    0x4(%edx),%edx
  802e91:	89 50 04             	mov    %edx,0x4(%eax)
  802e94:	eb 0b                	jmp    802ea1 <insert_sorted_with_merge_freeList+0x3c0>
  802e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea4:	8b 40 04             	mov    0x4(%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 0f                	je     802eba <insert_sorted_with_merge_freeList+0x3d9>
  802eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eae:	8b 40 04             	mov    0x4(%eax),%eax
  802eb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb4:	8b 12                	mov    (%edx),%edx
  802eb6:	89 10                	mov    %edx,(%eax)
  802eb8:	eb 0a                	jmp    802ec4 <insert_sorted_with_merge_freeList+0x3e3>
  802eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	a3 38 41 80 00       	mov    %eax,0x804138
  802ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed7:	a1 44 41 80 00       	mov    0x804144,%eax
  802edc:	48                   	dec    %eax
  802edd:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802ee2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802eec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ef6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802efa:	75 17                	jne    802f13 <insert_sorted_with_merge_freeList+0x432>
  802efc:	83 ec 04             	sub    $0x4,%esp
  802eff:	68 78 3d 80 00       	push   $0x803d78
  802f04:	68 5f 01 00 00       	push   $0x15f
  802f09:	68 9b 3d 80 00       	push   $0x803d9b
  802f0e:	e8 ce 03 00 00       	call   8032e1 <_panic>
  802f13:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1c:	89 10                	mov    %edx,(%eax)
  802f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	85 c0                	test   %eax,%eax
  802f25:	74 0d                	je     802f34 <insert_sorted_with_merge_freeList+0x453>
  802f27:	a1 48 41 80 00       	mov    0x804148,%eax
  802f2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2f:	89 50 04             	mov    %edx,0x4(%eax)
  802f32:	eb 08                	jmp    802f3c <insert_sorted_with_merge_freeList+0x45b>
  802f34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f37:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	a3 48 41 80 00       	mov    %eax,0x804148
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4e:	a1 54 41 80 00       	mov    0x804154,%eax
  802f53:	40                   	inc    %eax
  802f54:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c2                	add    %eax,%edx
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f85:	75 17                	jne    802f9e <insert_sorted_with_merge_freeList+0x4bd>
  802f87:	83 ec 04             	sub    $0x4,%esp
  802f8a:	68 78 3d 80 00       	push   $0x803d78
  802f8f:	68 64 01 00 00       	push   $0x164
  802f94:	68 9b 3d 80 00       	push   $0x803d9b
  802f99:	e8 43 03 00 00       	call   8032e1 <_panic>
  802f9e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0d                	je     802fbf <insert_sorted_with_merge_freeList+0x4de>
  802fb2:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	eb 08                	jmp    802fc7 <insert_sorted_with_merge_freeList+0x4e6>
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 48 41 80 00       	mov    %eax,0x804148
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802fe4:	e9 41 02 00 00       	jmp    80322a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff5:	01 c2                	add    %eax,%edx
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	8b 40 08             	mov    0x8(%eax),%eax
  802ffd:	39 c2                	cmp    %eax,%edx
  802fff:	0f 85 7c 01 00 00    	jne    803181 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803005:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803009:	74 06                	je     803011 <insert_sorted_with_merge_freeList+0x530>
  80300b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300f:	75 17                	jne    803028 <insert_sorted_with_merge_freeList+0x547>
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	68 b4 3d 80 00       	push   $0x803db4
  803019:	68 69 01 00 00       	push   $0x169
  80301e:	68 9b 3d 80 00       	push   $0x803d9b
  803023:	e8 b9 02 00 00       	call   8032e1 <_panic>
  803028:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302b:	8b 50 04             	mov    0x4(%eax),%edx
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	89 50 04             	mov    %edx,0x4(%eax)
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303a:	89 10                	mov    %edx,(%eax)
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	8b 40 04             	mov    0x4(%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 0d                	je     803053 <insert_sorted_with_merge_freeList+0x572>
  803046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803049:	8b 40 04             	mov    0x4(%eax),%eax
  80304c:	8b 55 08             	mov    0x8(%ebp),%edx
  80304f:	89 10                	mov    %edx,(%eax)
  803051:	eb 08                	jmp    80305b <insert_sorted_with_merge_freeList+0x57a>
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	a3 38 41 80 00       	mov    %eax,0x804138
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	8b 55 08             	mov    0x8(%ebp),%edx
  803061:	89 50 04             	mov    %edx,0x4(%eax)
  803064:	a1 44 41 80 00       	mov    0x804144,%eax
  803069:	40                   	inc    %eax
  80306a:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	8b 50 0c             	mov    0xc(%eax),%edx
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	8b 40 0c             	mov    0xc(%eax),%eax
  80307b:	01 c2                	add    %eax,%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803083:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x5bf>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 44 3e 80 00       	push   $0x803e44
  803091:	68 6b 01 00 00       	push   $0x16b
  803096:	68 9b 3d 80 00       	push   $0x803d9b
  80309b:	e8 41 02 00 00       	call   8032e1 <_panic>
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	85 c0                	test   %eax,%eax
  8030a7:	74 10                	je     8030b9 <insert_sorted_with_merge_freeList+0x5d8>
  8030a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b1:	8b 52 04             	mov    0x4(%edx),%edx
  8030b4:	89 50 04             	mov    %edx,0x4(%eax)
  8030b7:	eb 0b                	jmp    8030c4 <insert_sorted_with_merge_freeList+0x5e3>
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ca:	85 c0                	test   %eax,%eax
  8030cc:	74 0f                	je     8030dd <insert_sorted_with_merge_freeList+0x5fc>
  8030ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d1:	8b 40 04             	mov    0x4(%eax),%eax
  8030d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d7:	8b 12                	mov    (%edx),%edx
  8030d9:	89 10                	mov    %edx,(%eax)
  8030db:	eb 0a                	jmp    8030e7 <insert_sorted_with_merge_freeList+0x606>
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	a3 38 41 80 00       	mov    %eax,0x804138
  8030e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fa:	a1 44 41 80 00       	mov    0x804144,%eax
  8030ff:	48                   	dec    %eax
  803100:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80310f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803112:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803119:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311d:	75 17                	jne    803136 <insert_sorted_with_merge_freeList+0x655>
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	68 78 3d 80 00       	push   $0x803d78
  803127:	68 6e 01 00 00       	push   $0x16e
  80312c:	68 9b 3d 80 00       	push   $0x803d9b
  803131:	e8 ab 01 00 00       	call   8032e1 <_panic>
  803136:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313f:	89 10                	mov    %edx,(%eax)
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	74 0d                	je     803157 <insert_sorted_with_merge_freeList+0x676>
  80314a:	a1 48 41 80 00       	mov    0x804148,%eax
  80314f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803152:	89 50 04             	mov    %edx,0x4(%eax)
  803155:	eb 08                	jmp    80315f <insert_sorted_with_merge_freeList+0x67e>
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	a3 48 41 80 00       	mov    %eax,0x804148
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803171:	a1 54 41 80 00       	mov    0x804154,%eax
  803176:	40                   	inc    %eax
  803177:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80317c:	e9 a9 00 00 00       	jmp    80322a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803185:	74 06                	je     80318d <insert_sorted_with_merge_freeList+0x6ac>
  803187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318b:	75 17                	jne    8031a4 <insert_sorted_with_merge_freeList+0x6c3>
  80318d:	83 ec 04             	sub    $0x4,%esp
  803190:	68 10 3e 80 00       	push   $0x803e10
  803195:	68 73 01 00 00       	push   $0x173
  80319a:	68 9b 3d 80 00       	push   $0x803d9b
  80319f:	e8 3d 01 00 00       	call   8032e1 <_panic>
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 10                	mov    (%eax),%edx
  8031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ac:	89 10                	mov    %edx,(%eax)
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0b                	je     8031c2 <insert_sorted_with_merge_freeList+0x6e1>
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c8:	89 10                	mov    %edx,(%eax)
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d0:	89 50 04             	mov    %edx,0x4(%eax)
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	8b 00                	mov    (%eax),%eax
  8031d8:	85 c0                	test   %eax,%eax
  8031da:	75 08                	jne    8031e4 <insert_sorted_with_merge_freeList+0x703>
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8031e9:	40                   	inc    %eax
  8031ea:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8031ef:	eb 39                	jmp    80322a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8031f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fd:	74 07                	je     803206 <insert_sorted_with_merge_freeList+0x725>
  8031ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803202:	8b 00                	mov    (%eax),%eax
  803204:	eb 05                	jmp    80320b <insert_sorted_with_merge_freeList+0x72a>
  803206:	b8 00 00 00 00       	mov    $0x0,%eax
  80320b:	a3 40 41 80 00       	mov    %eax,0x804140
  803210:	a1 40 41 80 00       	mov    0x804140,%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	0f 85 c7 fb ff ff    	jne    802de4 <insert_sorted_with_merge_freeList+0x303>
  80321d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803221:	0f 85 bd fb ff ff    	jne    802de4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803227:	eb 01                	jmp    80322a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803229:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80322a:	90                   	nop
  80322b:	c9                   	leave  
  80322c:	c3                   	ret    

0080322d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80322d:	55                   	push   %ebp
  80322e:	89 e5                	mov    %esp,%ebp
  803230:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803233:	8b 55 08             	mov    0x8(%ebp),%edx
  803236:	89 d0                	mov    %edx,%eax
  803238:	c1 e0 02             	shl    $0x2,%eax
  80323b:	01 d0                	add    %edx,%eax
  80323d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803244:	01 d0                	add    %edx,%eax
  803246:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80324d:	01 d0                	add    %edx,%eax
  80324f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803256:	01 d0                	add    %edx,%eax
  803258:	c1 e0 04             	shl    $0x4,%eax
  80325b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80325e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803265:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803268:	83 ec 0c             	sub    $0xc,%esp
  80326b:	50                   	push   %eax
  80326c:	e8 26 e7 ff ff       	call   801997 <sys_get_virtual_time>
  803271:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803274:	eb 41                	jmp    8032b7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803276:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803279:	83 ec 0c             	sub    $0xc,%esp
  80327c:	50                   	push   %eax
  80327d:	e8 15 e7 ff ff       	call   801997 <sys_get_virtual_time>
  803282:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803285:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	29 c2                	sub    %eax,%edx
  80328d:	89 d0                	mov    %edx,%eax
  80328f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803292:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803295:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803298:	89 d1                	mov    %edx,%ecx
  80329a:	29 c1                	sub    %eax,%ecx
  80329c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80329f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a2:	39 c2                	cmp    %eax,%edx
  8032a4:	0f 97 c0             	seta   %al
  8032a7:	0f b6 c0             	movzbl %al,%eax
  8032aa:	29 c1                	sub    %eax,%ecx
  8032ac:	89 c8                	mov    %ecx,%eax
  8032ae:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032bd:	72 b7                	jb     803276 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032bf:	90                   	nop
  8032c0:	c9                   	leave  
  8032c1:	c3                   	ret    

008032c2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8032c2:	55                   	push   %ebp
  8032c3:	89 e5                	mov    %esp,%ebp
  8032c5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8032c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8032cf:	eb 03                	jmp    8032d4 <busy_wait+0x12>
  8032d1:	ff 45 fc             	incl   -0x4(%ebp)
  8032d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032da:	72 f5                	jb     8032d1 <busy_wait+0xf>
	return i;
  8032dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8032df:	c9                   	leave  
  8032e0:	c3                   	ret    

008032e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8032e1:	55                   	push   %ebp
  8032e2:	89 e5                	mov    %esp,%ebp
  8032e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8032e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8032ea:	83 c0 04             	add    $0x4,%eax
  8032ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8032f0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8032f5:	85 c0                	test   %eax,%eax
  8032f7:	74 16                	je     80330f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8032f9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8032fe:	83 ec 08             	sub    $0x8,%esp
  803301:	50                   	push   %eax
  803302:	68 64 3e 80 00       	push   $0x803e64
  803307:	e8 70 d0 ff ff       	call   80037c <cprintf>
  80330c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80330f:	a1 00 40 80 00       	mov    0x804000,%eax
  803314:	ff 75 0c             	pushl  0xc(%ebp)
  803317:	ff 75 08             	pushl  0x8(%ebp)
  80331a:	50                   	push   %eax
  80331b:	68 69 3e 80 00       	push   $0x803e69
  803320:	e8 57 d0 ff ff       	call   80037c <cprintf>
  803325:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803328:	8b 45 10             	mov    0x10(%ebp),%eax
  80332b:	83 ec 08             	sub    $0x8,%esp
  80332e:	ff 75 f4             	pushl  -0xc(%ebp)
  803331:	50                   	push   %eax
  803332:	e8 da cf ff ff       	call   800311 <vcprintf>
  803337:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80333a:	83 ec 08             	sub    $0x8,%esp
  80333d:	6a 00                	push   $0x0
  80333f:	68 85 3e 80 00       	push   $0x803e85
  803344:	e8 c8 cf ff ff       	call   800311 <vcprintf>
  803349:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80334c:	e8 49 cf ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  803351:	eb fe                	jmp    803351 <_panic+0x70>

00803353 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803353:	55                   	push   %ebp
  803354:	89 e5                	mov    %esp,%ebp
  803356:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803359:	a1 20 40 80 00       	mov    0x804020,%eax
  80335e:	8b 50 74             	mov    0x74(%eax),%edx
  803361:	8b 45 0c             	mov    0xc(%ebp),%eax
  803364:	39 c2                	cmp    %eax,%edx
  803366:	74 14                	je     80337c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803368:	83 ec 04             	sub    $0x4,%esp
  80336b:	68 88 3e 80 00       	push   $0x803e88
  803370:	6a 26                	push   $0x26
  803372:	68 d4 3e 80 00       	push   $0x803ed4
  803377:	e8 65 ff ff ff       	call   8032e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80337c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80338a:	e9 c2 00 00 00       	jmp    803451 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80338f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803392:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	01 d0                	add    %edx,%eax
  80339e:	8b 00                	mov    (%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	75 08                	jne    8033ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8033a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8033a7:	e9 a2 00 00 00       	jmp    80344e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8033ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033ba:	eb 69                	jmp    803425 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8033bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8033c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ca:	89 d0                	mov    %edx,%eax
  8033cc:	01 c0                	add    %eax,%eax
  8033ce:	01 d0                	add    %edx,%eax
  8033d0:	c1 e0 03             	shl    $0x3,%eax
  8033d3:	01 c8                	add    %ecx,%eax
  8033d5:	8a 40 04             	mov    0x4(%eax),%al
  8033d8:	84 c0                	test   %al,%al
  8033da:	75 46                	jne    803422 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8033dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8033e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ea:	89 d0                	mov    %edx,%eax
  8033ec:	01 c0                	add    %eax,%eax
  8033ee:	01 d0                	add    %edx,%eax
  8033f0:	c1 e0 03             	shl    $0x3,%eax
  8033f3:	01 c8                	add    %ecx,%eax
  8033f5:	8b 00                	mov    (%eax),%eax
  8033f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803402:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803407:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80340e:	8b 45 08             	mov    0x8(%ebp),%eax
  803411:	01 c8                	add    %ecx,%eax
  803413:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803415:	39 c2                	cmp    %eax,%edx
  803417:	75 09                	jne    803422 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803419:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803420:	eb 12                	jmp    803434 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803422:	ff 45 e8             	incl   -0x18(%ebp)
  803425:	a1 20 40 80 00       	mov    0x804020,%eax
  80342a:	8b 50 74             	mov    0x74(%eax),%edx
  80342d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803430:	39 c2                	cmp    %eax,%edx
  803432:	77 88                	ja     8033bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803434:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803438:	75 14                	jne    80344e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80343a:	83 ec 04             	sub    $0x4,%esp
  80343d:	68 e0 3e 80 00       	push   $0x803ee0
  803442:	6a 3a                	push   $0x3a
  803444:	68 d4 3e 80 00       	push   $0x803ed4
  803449:	e8 93 fe ff ff       	call   8032e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80344e:	ff 45 f0             	incl   -0x10(%ebp)
  803451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803454:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803457:	0f 8c 32 ff ff ff    	jl     80338f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80345d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803464:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80346b:	eb 26                	jmp    803493 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80346d:	a1 20 40 80 00       	mov    0x804020,%eax
  803472:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803478:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80347b:	89 d0                	mov    %edx,%eax
  80347d:	01 c0                	add    %eax,%eax
  80347f:	01 d0                	add    %edx,%eax
  803481:	c1 e0 03             	shl    $0x3,%eax
  803484:	01 c8                	add    %ecx,%eax
  803486:	8a 40 04             	mov    0x4(%eax),%al
  803489:	3c 01                	cmp    $0x1,%al
  80348b:	75 03                	jne    803490 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80348d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803490:	ff 45 e0             	incl   -0x20(%ebp)
  803493:	a1 20 40 80 00       	mov    0x804020,%eax
  803498:	8b 50 74             	mov    0x74(%eax),%edx
  80349b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349e:	39 c2                	cmp    %eax,%edx
  8034a0:	77 cb                	ja     80346d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034a8:	74 14                	je     8034be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8034aa:	83 ec 04             	sub    $0x4,%esp
  8034ad:	68 34 3f 80 00       	push   $0x803f34
  8034b2:	6a 44                	push   $0x44
  8034b4:	68 d4 3e 80 00       	push   $0x803ed4
  8034b9:	e8 23 fe ff ff       	call   8032e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8034be:	90                   	nop
  8034bf:	c9                   	leave  
  8034c0:	c3                   	ret    
  8034c1:	66 90                	xchg   %ax,%ax
  8034c3:	90                   	nop

008034c4 <__udivdi3>:
  8034c4:	55                   	push   %ebp
  8034c5:	57                   	push   %edi
  8034c6:	56                   	push   %esi
  8034c7:	53                   	push   %ebx
  8034c8:	83 ec 1c             	sub    $0x1c,%esp
  8034cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034db:	89 ca                	mov    %ecx,%edx
  8034dd:	89 f8                	mov    %edi,%eax
  8034df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034e3:	85 f6                	test   %esi,%esi
  8034e5:	75 2d                	jne    803514 <__udivdi3+0x50>
  8034e7:	39 cf                	cmp    %ecx,%edi
  8034e9:	77 65                	ja     803550 <__udivdi3+0x8c>
  8034eb:	89 fd                	mov    %edi,%ebp
  8034ed:	85 ff                	test   %edi,%edi
  8034ef:	75 0b                	jne    8034fc <__udivdi3+0x38>
  8034f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f6:	31 d2                	xor    %edx,%edx
  8034f8:	f7 f7                	div    %edi
  8034fa:	89 c5                	mov    %eax,%ebp
  8034fc:	31 d2                	xor    %edx,%edx
  8034fe:	89 c8                	mov    %ecx,%eax
  803500:	f7 f5                	div    %ebp
  803502:	89 c1                	mov    %eax,%ecx
  803504:	89 d8                	mov    %ebx,%eax
  803506:	f7 f5                	div    %ebp
  803508:	89 cf                	mov    %ecx,%edi
  80350a:	89 fa                	mov    %edi,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	39 ce                	cmp    %ecx,%esi
  803516:	77 28                	ja     803540 <__udivdi3+0x7c>
  803518:	0f bd fe             	bsr    %esi,%edi
  80351b:	83 f7 1f             	xor    $0x1f,%edi
  80351e:	75 40                	jne    803560 <__udivdi3+0x9c>
  803520:	39 ce                	cmp    %ecx,%esi
  803522:	72 0a                	jb     80352e <__udivdi3+0x6a>
  803524:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803528:	0f 87 9e 00 00 00    	ja     8035cc <__udivdi3+0x108>
  80352e:	b8 01 00 00 00       	mov    $0x1,%eax
  803533:	89 fa                	mov    %edi,%edx
  803535:	83 c4 1c             	add    $0x1c,%esp
  803538:	5b                   	pop    %ebx
  803539:	5e                   	pop    %esi
  80353a:	5f                   	pop    %edi
  80353b:	5d                   	pop    %ebp
  80353c:	c3                   	ret    
  80353d:	8d 76 00             	lea    0x0(%esi),%esi
  803540:	31 ff                	xor    %edi,%edi
  803542:	31 c0                	xor    %eax,%eax
  803544:	89 fa                	mov    %edi,%edx
  803546:	83 c4 1c             	add    $0x1c,%esp
  803549:	5b                   	pop    %ebx
  80354a:	5e                   	pop    %esi
  80354b:	5f                   	pop    %edi
  80354c:	5d                   	pop    %ebp
  80354d:	c3                   	ret    
  80354e:	66 90                	xchg   %ax,%ax
  803550:	89 d8                	mov    %ebx,%eax
  803552:	f7 f7                	div    %edi
  803554:	31 ff                	xor    %edi,%edi
  803556:	89 fa                	mov    %edi,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	bd 20 00 00 00       	mov    $0x20,%ebp
  803565:	89 eb                	mov    %ebp,%ebx
  803567:	29 fb                	sub    %edi,%ebx
  803569:	89 f9                	mov    %edi,%ecx
  80356b:	d3 e6                	shl    %cl,%esi
  80356d:	89 c5                	mov    %eax,%ebp
  80356f:	88 d9                	mov    %bl,%cl
  803571:	d3 ed                	shr    %cl,%ebp
  803573:	89 e9                	mov    %ebp,%ecx
  803575:	09 f1                	or     %esi,%ecx
  803577:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80357b:	89 f9                	mov    %edi,%ecx
  80357d:	d3 e0                	shl    %cl,%eax
  80357f:	89 c5                	mov    %eax,%ebp
  803581:	89 d6                	mov    %edx,%esi
  803583:	88 d9                	mov    %bl,%cl
  803585:	d3 ee                	shr    %cl,%esi
  803587:	89 f9                	mov    %edi,%ecx
  803589:	d3 e2                	shl    %cl,%edx
  80358b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 e8                	shr    %cl,%eax
  803593:	09 c2                	or     %eax,%edx
  803595:	89 d0                	mov    %edx,%eax
  803597:	89 f2                	mov    %esi,%edx
  803599:	f7 74 24 0c          	divl   0xc(%esp)
  80359d:	89 d6                	mov    %edx,%esi
  80359f:	89 c3                	mov    %eax,%ebx
  8035a1:	f7 e5                	mul    %ebp
  8035a3:	39 d6                	cmp    %edx,%esi
  8035a5:	72 19                	jb     8035c0 <__udivdi3+0xfc>
  8035a7:	74 0b                	je     8035b4 <__udivdi3+0xf0>
  8035a9:	89 d8                	mov    %ebx,%eax
  8035ab:	31 ff                	xor    %edi,%edi
  8035ad:	e9 58 ff ff ff       	jmp    80350a <__udivdi3+0x46>
  8035b2:	66 90                	xchg   %ax,%ax
  8035b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035b8:	89 f9                	mov    %edi,%ecx
  8035ba:	d3 e2                	shl    %cl,%edx
  8035bc:	39 c2                	cmp    %eax,%edx
  8035be:	73 e9                	jae    8035a9 <__udivdi3+0xe5>
  8035c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035c3:	31 ff                	xor    %edi,%edi
  8035c5:	e9 40 ff ff ff       	jmp    80350a <__udivdi3+0x46>
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	31 c0                	xor    %eax,%eax
  8035ce:	e9 37 ff ff ff       	jmp    80350a <__udivdi3+0x46>
  8035d3:	90                   	nop

008035d4 <__umoddi3>:
  8035d4:	55                   	push   %ebp
  8035d5:	57                   	push   %edi
  8035d6:	56                   	push   %esi
  8035d7:	53                   	push   %ebx
  8035d8:	83 ec 1c             	sub    $0x1c,%esp
  8035db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035f3:	89 f3                	mov    %esi,%ebx
  8035f5:	89 fa                	mov    %edi,%edx
  8035f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035fb:	89 34 24             	mov    %esi,(%esp)
  8035fe:	85 c0                	test   %eax,%eax
  803600:	75 1a                	jne    80361c <__umoddi3+0x48>
  803602:	39 f7                	cmp    %esi,%edi
  803604:	0f 86 a2 00 00 00    	jbe    8036ac <__umoddi3+0xd8>
  80360a:	89 c8                	mov    %ecx,%eax
  80360c:	89 f2                	mov    %esi,%edx
  80360e:	f7 f7                	div    %edi
  803610:	89 d0                	mov    %edx,%eax
  803612:	31 d2                	xor    %edx,%edx
  803614:	83 c4 1c             	add    $0x1c,%esp
  803617:	5b                   	pop    %ebx
  803618:	5e                   	pop    %esi
  803619:	5f                   	pop    %edi
  80361a:	5d                   	pop    %ebp
  80361b:	c3                   	ret    
  80361c:	39 f0                	cmp    %esi,%eax
  80361e:	0f 87 ac 00 00 00    	ja     8036d0 <__umoddi3+0xfc>
  803624:	0f bd e8             	bsr    %eax,%ebp
  803627:	83 f5 1f             	xor    $0x1f,%ebp
  80362a:	0f 84 ac 00 00 00    	je     8036dc <__umoddi3+0x108>
  803630:	bf 20 00 00 00       	mov    $0x20,%edi
  803635:	29 ef                	sub    %ebp,%edi
  803637:	89 fe                	mov    %edi,%esi
  803639:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 e0                	shl    %cl,%eax
  803641:	89 d7                	mov    %edx,%edi
  803643:	89 f1                	mov    %esi,%ecx
  803645:	d3 ef                	shr    %cl,%edi
  803647:	09 c7                	or     %eax,%edi
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 e2                	shl    %cl,%edx
  80364d:	89 14 24             	mov    %edx,(%esp)
  803650:	89 d8                	mov    %ebx,%eax
  803652:	d3 e0                	shl    %cl,%eax
  803654:	89 c2                	mov    %eax,%edx
  803656:	8b 44 24 08          	mov    0x8(%esp),%eax
  80365a:	d3 e0                	shl    %cl,%eax
  80365c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803660:	8b 44 24 08          	mov    0x8(%esp),%eax
  803664:	89 f1                	mov    %esi,%ecx
  803666:	d3 e8                	shr    %cl,%eax
  803668:	09 d0                	or     %edx,%eax
  80366a:	d3 eb                	shr    %cl,%ebx
  80366c:	89 da                	mov    %ebx,%edx
  80366e:	f7 f7                	div    %edi
  803670:	89 d3                	mov    %edx,%ebx
  803672:	f7 24 24             	mull   (%esp)
  803675:	89 c6                	mov    %eax,%esi
  803677:	89 d1                	mov    %edx,%ecx
  803679:	39 d3                	cmp    %edx,%ebx
  80367b:	0f 82 87 00 00 00    	jb     803708 <__umoddi3+0x134>
  803681:	0f 84 91 00 00 00    	je     803718 <__umoddi3+0x144>
  803687:	8b 54 24 04          	mov    0x4(%esp),%edx
  80368b:	29 f2                	sub    %esi,%edx
  80368d:	19 cb                	sbb    %ecx,%ebx
  80368f:	89 d8                	mov    %ebx,%eax
  803691:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803695:	d3 e0                	shl    %cl,%eax
  803697:	89 e9                	mov    %ebp,%ecx
  803699:	d3 ea                	shr    %cl,%edx
  80369b:	09 d0                	or     %edx,%eax
  80369d:	89 e9                	mov    %ebp,%ecx
  80369f:	d3 eb                	shr    %cl,%ebx
  8036a1:	89 da                	mov    %ebx,%edx
  8036a3:	83 c4 1c             	add    $0x1c,%esp
  8036a6:	5b                   	pop    %ebx
  8036a7:	5e                   	pop    %esi
  8036a8:	5f                   	pop    %edi
  8036a9:	5d                   	pop    %ebp
  8036aa:	c3                   	ret    
  8036ab:	90                   	nop
  8036ac:	89 fd                	mov    %edi,%ebp
  8036ae:	85 ff                	test   %edi,%edi
  8036b0:	75 0b                	jne    8036bd <__umoddi3+0xe9>
  8036b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b7:	31 d2                	xor    %edx,%edx
  8036b9:	f7 f7                	div    %edi
  8036bb:	89 c5                	mov    %eax,%ebp
  8036bd:	89 f0                	mov    %esi,%eax
  8036bf:	31 d2                	xor    %edx,%edx
  8036c1:	f7 f5                	div    %ebp
  8036c3:	89 c8                	mov    %ecx,%eax
  8036c5:	f7 f5                	div    %ebp
  8036c7:	89 d0                	mov    %edx,%eax
  8036c9:	e9 44 ff ff ff       	jmp    803612 <__umoddi3+0x3e>
  8036ce:	66 90                	xchg   %ax,%ax
  8036d0:	89 c8                	mov    %ecx,%eax
  8036d2:	89 f2                	mov    %esi,%edx
  8036d4:	83 c4 1c             	add    $0x1c,%esp
  8036d7:	5b                   	pop    %ebx
  8036d8:	5e                   	pop    %esi
  8036d9:	5f                   	pop    %edi
  8036da:	5d                   	pop    %ebp
  8036db:	c3                   	ret    
  8036dc:	3b 04 24             	cmp    (%esp),%eax
  8036df:	72 06                	jb     8036e7 <__umoddi3+0x113>
  8036e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036e5:	77 0f                	ja     8036f6 <__umoddi3+0x122>
  8036e7:	89 f2                	mov    %esi,%edx
  8036e9:	29 f9                	sub    %edi,%ecx
  8036eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036ef:	89 14 24             	mov    %edx,(%esp)
  8036f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036fa:	8b 14 24             	mov    (%esp),%edx
  8036fd:	83 c4 1c             	add    $0x1c,%esp
  803700:	5b                   	pop    %ebx
  803701:	5e                   	pop    %esi
  803702:	5f                   	pop    %edi
  803703:	5d                   	pop    %ebp
  803704:	c3                   	ret    
  803705:	8d 76 00             	lea    0x0(%esi),%esi
  803708:	2b 04 24             	sub    (%esp),%eax
  80370b:	19 fa                	sbb    %edi,%edx
  80370d:	89 d1                	mov    %edx,%ecx
  80370f:	89 c6                	mov    %eax,%esi
  803711:	e9 71 ff ff ff       	jmp    803687 <__umoddi3+0xb3>
  803716:	66 90                	xchg   %ax,%ax
  803718:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80371c:	72 ea                	jb     803708 <__umoddi3+0x134>
  80371e:	89 d9                	mov    %ebx,%ecx
  803720:	e9 62 ff ff ff       	jmp    803687 <__umoddi3+0xb3>
