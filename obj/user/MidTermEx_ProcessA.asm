
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
  80003e:	e8 da 17 00 00       	call   80181d <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 35 80 00       	push   $0x8035e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 2a 13 00 00       	call   801380 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 35 80 00       	push   $0x8035e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 14 13 00 00       	call   801380 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 35 80 00       	push   $0x8035e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 fe 12 00 00       	call   801380 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 bc 17 00 00       	call   801850 <sys_get_virtual_time>
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
  8000b7:	e8 2a 30 00 00       	call   8030e6 <env_sleep>
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
  8000d0:	e8 7b 17 00 00       	call   801850 <sys_get_virtual_time>
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
  8000f8:	e8 e9 2f 00 00       	call   8030e6 <env_sleep>
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
  80010f:	e8 3c 17 00 00       	call   801850 <sys_get_virtual_time>
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
  800137:	e8 aa 2f 00 00       	call   8030e6 <env_sleep>
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
  80014c:	68 f7 35 80 00       	push   $0x8035f7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 83 15 00 00       	call   8016dc <sys_signalSemaphore>
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
  800172:	e8 8d 16 00 00       	call   801804 <sys_getenvindex>
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
  8001dd:	e8 2f 14 00 00       	call   801611 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 14 36 80 00       	push   $0x803614
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
  80020d:	68 3c 36 80 00       	push   $0x80363c
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
  80023e:	68 64 36 80 00       	push   $0x803664
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 bc 36 80 00       	push   $0x8036bc
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 14 36 80 00       	push   $0x803614
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 af 13 00 00       	call   80162b <sys_enable_interrupt>

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
  80028f:	e8 3c 15 00 00       	call   8017d0 <sys_destroy_env>
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
  8002a0:	e8 91 15 00 00       	call   801836 <sys_exit_env>
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
  8002ee:	e8 70 11 00 00       	call   801463 <sys_cputs>
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
  800365:	e8 f9 10 00 00       	call   801463 <sys_cputs>
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
  8003af:	e8 5d 12 00 00       	call   801611 <sys_disable_interrupt>
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
  8003cf:	e8 57 12 00 00       	call   80162b <sys_enable_interrupt>
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
  800419:	e8 5e 2f 00 00       	call   80337c <__udivdi3>
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
  800469:	e8 1e 30 00 00       	call   80348c <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 f4 38 80 00       	add    $0x8038f4,%eax
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
  8005c4:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
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
  8006a5:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 05 39 80 00       	push   $0x803905
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
  8006ca:	68 0e 39 80 00       	push   $0x80390e
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
  8006f7:	be 11 39 80 00       	mov    $0x803911,%esi
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
  80111d:	68 70 3a 80 00       	push   $0x803a70
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
  8011ed:	e8 b5 03 00 00       	call   8015a7 <sys_allocate_chunk>
  8011f2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	e8 2a 0a 00 00       	call   801c2d <initialize_MemBlocksList>
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
  80122b:	68 95 3a 80 00       	push   $0x803a95
  801230:	6a 33                	push   $0x33
  801232:	68 b3 3a 80 00       	push   $0x803ab3
  801237:	e8 5e 1f 00 00       	call   80319a <_panic>
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
  8012aa:	68 c0 3a 80 00       	push   $0x803ac0
  8012af:	6a 34                	push   $0x34
  8012b1:	68 b3 3a 80 00       	push   $0x803ab3
  8012b6:	e8 df 1e 00 00       	call   80319a <_panic>
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
  80131f:	68 e4 3a 80 00       	push   $0x803ae4
  801324:	6a 46                	push   $0x46
  801326:	68 b3 3a 80 00       	push   $0x803ab3
  80132b:	e8 6a 1e 00 00       	call   80319a <_panic>
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
  80133b:	68 0c 3b 80 00       	push   $0x803b0c
  801340:	6a 61                	push   $0x61
  801342:	68 b3 3a 80 00       	push   $0x803ab3
  801347:	e8 4e 1e 00 00       	call   80319a <_panic>

0080134c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 18             	sub    $0x18,%esp
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801358:	e8 a9 fd ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  80135d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801361:	75 07                	jne    80136a <smalloc+0x1e>
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb 14                	jmp    80137e <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80136a:	83 ec 04             	sub    $0x4,%esp
  80136d:	68 30 3b 80 00       	push   $0x803b30
  801372:	6a 76                	push   $0x76
  801374:	68 b3 3a 80 00       	push   $0x803ab3
  801379:	e8 1c 1e 00 00       	call   80319a <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801386:	e8 7b fd ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	68 58 3b 80 00       	push   $0x803b58
  801393:	68 93 00 00 00       	push   $0x93
  801398:	68 b3 3a 80 00       	push   $0x803ab3
  80139d:	e8 f8 1d 00 00       	call   80319a <_panic>

008013a2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013a8:	e8 59 fd ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013ad:	83 ec 04             	sub    $0x4,%esp
  8013b0:	68 7c 3b 80 00       	push   $0x803b7c
  8013b5:	68 c5 00 00 00       	push   $0xc5
  8013ba:	68 b3 3a 80 00       	push   $0x803ab3
  8013bf:	e8 d6 1d 00 00       	call   80319a <_panic>

008013c4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8013c4:	55                   	push   %ebp
  8013c5:	89 e5                	mov    %esp,%ebp
  8013c7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	68 a4 3b 80 00       	push   $0x803ba4
  8013d2:	68 d9 00 00 00       	push   $0xd9
  8013d7:	68 b3 3a 80 00       	push   $0x803ab3
  8013dc:	e8 b9 1d 00 00       	call   80319a <_panic>

008013e1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	68 c8 3b 80 00       	push   $0x803bc8
  8013ef:	68 e4 00 00 00       	push   $0xe4
  8013f4:	68 b3 3a 80 00       	push   $0x803ab3
  8013f9:	e8 9c 1d 00 00       	call   80319a <_panic>

008013fe <shrink>:

}
void shrink(uint32 newSize)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	68 c8 3b 80 00       	push   $0x803bc8
  80140c:	68 e9 00 00 00       	push   $0xe9
  801411:	68 b3 3a 80 00       	push   $0x803ab3
  801416:	e8 7f 1d 00 00       	call   80319a <_panic>

0080141b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801421:	83 ec 04             	sub    $0x4,%esp
  801424:	68 c8 3b 80 00       	push   $0x803bc8
  801429:	68 ee 00 00 00       	push   $0xee
  80142e:	68 b3 3a 80 00       	push   $0x803ab3
  801433:	e8 62 1d 00 00       	call   80319a <_panic>

00801438 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	57                   	push   %edi
  80143c:	56                   	push   %esi
  80143d:	53                   	push   %ebx
  80143e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	8b 55 0c             	mov    0xc(%ebp),%edx
  801447:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80144a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80144d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801450:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801453:	cd 30                	int    $0x30
  801455:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801458:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	5b                   	pop    %ebx
  80145f:	5e                   	pop    %esi
  801460:	5f                   	pop    %edi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    

00801463 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 04             	sub    $0x4,%esp
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80146f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	6a 00                	push   $0x0
  801478:	6a 00                	push   $0x0
  80147a:	52                   	push   %edx
  80147b:	ff 75 0c             	pushl  0xc(%ebp)
  80147e:	50                   	push   %eax
  80147f:	6a 00                	push   $0x0
  801481:	e8 b2 ff ff ff       	call   801438 <syscall>
  801486:	83 c4 18             	add    $0x18,%esp
}
  801489:	90                   	nop
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <sys_cgetc>:

int
sys_cgetc(void)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 01                	push   $0x1
  80149b:	e8 98 ff ff ff       	call   801438 <syscall>
  8014a0:	83 c4 18             	add    $0x18,%esp
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	52                   	push   %edx
  8014b5:	50                   	push   %eax
  8014b6:	6a 05                	push   $0x5
  8014b8:	e8 7b ff ff ff       	call   801438 <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	56                   	push   %esi
  8014c6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8014ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
  8014d8:	51                   	push   %ecx
  8014d9:	52                   	push   %edx
  8014da:	50                   	push   %eax
  8014db:	6a 06                	push   $0x6
  8014dd:	e8 56 ff ff ff       	call   801438 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
}
  8014e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e8:	5b                   	pop    %ebx
  8014e9:	5e                   	pop    %esi
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	52                   	push   %edx
  8014fc:	50                   	push   %eax
  8014fd:	6a 07                	push   $0x7
  8014ff:	e8 34 ff ff ff       	call   801438 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	ff 75 0c             	pushl  0xc(%ebp)
  801515:	ff 75 08             	pushl  0x8(%ebp)
  801518:	6a 08                	push   $0x8
  80151a:	e8 19 ff ff ff       	call   801438 <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 00                	push   $0x0
  801531:	6a 09                	push   $0x9
  801533:	e8 00 ff ff ff       	call   801438 <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 0a                	push   $0xa
  80154c:	e8 e7 fe ff ff       	call   801438 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
}
  801554:	c9                   	leave  
  801555:	c3                   	ret    

00801556 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 0b                	push   $0xb
  801565:	e8 ce fe ff ff       	call   801438 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801572:	6a 00                	push   $0x0
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	ff 75 0c             	pushl  0xc(%ebp)
  80157b:	ff 75 08             	pushl  0x8(%ebp)
  80157e:	6a 0f                	push   $0xf
  801580:	e8 b3 fe ff ff       	call   801438 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
	return;
  801588:	90                   	nop
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	ff 75 0c             	pushl  0xc(%ebp)
  801597:	ff 75 08             	pushl  0x8(%ebp)
  80159a:	6a 10                	push   $0x10
  80159c:	e8 97 fe ff ff       	call   801438 <syscall>
  8015a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a4:	90                   	nop
}
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    

008015a7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	ff 75 10             	pushl  0x10(%ebp)
  8015b1:	ff 75 0c             	pushl  0xc(%ebp)
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	6a 11                	push   $0x11
  8015b9:	e8 7a fe ff ff       	call   801438 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c1:	90                   	nop
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 0c                	push   $0xc
  8015d3:	e8 60 fe ff ff       	call   801438 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	ff 75 08             	pushl  0x8(%ebp)
  8015eb:	6a 0d                	push   $0xd
  8015ed:	e8 46 fe ff ff       	call   801438 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 0e                	push   $0xe
  801606:	e8 2d fe ff ff       	call   801438 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	90                   	nop
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 13                	push   $0x13
  801620:	e8 13 fe ff ff       	call   801438 <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
}
  801628:	90                   	nop
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 14                	push   $0x14
  80163a:	e8 f9 fd ff ff       	call   801438 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	90                   	nop
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_cputc>:


void
sys_cputc(const char c)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 04             	sub    $0x4,%esp
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801651:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	50                   	push   %eax
  80165e:	6a 15                	push   $0x15
  801660:	e8 d3 fd ff ff       	call   801438 <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	90                   	nop
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 16                	push   $0x16
  80167a:	e8 b9 fd ff ff       	call   801438 <syscall>
  80167f:	83 c4 18             	add    $0x18,%esp
}
  801682:	90                   	nop
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	50                   	push   %eax
  801695:	6a 17                	push   $0x17
  801697:	e8 9c fd ff ff       	call   801438 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	52                   	push   %edx
  8016b1:	50                   	push   %eax
  8016b2:	6a 1a                	push   $0x1a
  8016b4:	e8 7f fd ff ff       	call   801438 <syscall>
  8016b9:	83 c4 18             	add    $0x18,%esp
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	52                   	push   %edx
  8016ce:	50                   	push   %eax
  8016cf:	6a 18                	push   $0x18
  8016d1:	e8 62 fd ff ff       	call   801438 <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	90                   	nop
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	6a 19                	push   $0x19
  8016ef:	e8 44 fd ff ff       	call   801438 <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 45 10             	mov    0x10(%ebp),%eax
  801703:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801706:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801709:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	6a 00                	push   $0x0
  801712:	51                   	push   %ecx
  801713:	52                   	push   %edx
  801714:	ff 75 0c             	pushl  0xc(%ebp)
  801717:	50                   	push   %eax
  801718:	6a 1b                	push   $0x1b
  80171a:	e8 19 fd ff ff       	call   801438 <syscall>
  80171f:	83 c4 18             	add    $0x18,%esp
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801727:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	52                   	push   %edx
  801734:	50                   	push   %eax
  801735:	6a 1c                	push   $0x1c
  801737:	e8 fc fc ff ff       	call   801438 <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801744:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	51                   	push   %ecx
  801752:	52                   	push   %edx
  801753:	50                   	push   %eax
  801754:	6a 1d                	push   $0x1d
  801756:	e8 dd fc ff ff       	call   801438 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	52                   	push   %edx
  801770:	50                   	push   %eax
  801771:	6a 1e                	push   $0x1e
  801773:	e8 c0 fc ff ff       	call   801438 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 1f                	push   $0x1f
  80178c:	e8 a7 fc ff ff       	call   801438 <syscall>
  801791:	83 c4 18             	add    $0x18,%esp
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801799:	8b 45 08             	mov    0x8(%ebp),%eax
  80179c:	6a 00                	push   $0x0
  80179e:	ff 75 14             	pushl  0x14(%ebp)
  8017a1:	ff 75 10             	pushl  0x10(%ebp)
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	50                   	push   %eax
  8017a8:	6a 20                	push   $0x20
  8017aa:	e8 89 fc ff ff       	call   801438 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	50                   	push   %eax
  8017c3:	6a 21                	push   $0x21
  8017c5:	e8 6e fc ff ff       	call   801438 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
}
  8017cd:	90                   	nop
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	50                   	push   %eax
  8017df:	6a 22                	push   $0x22
  8017e1:	e8 52 fc ff ff       	call   801438 <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 02                	push   $0x2
  8017fa:	e8 39 fc ff ff       	call   801438 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 03                	push   $0x3
  801813:	e8 20 fc ff ff       	call   801438 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 04                	push   $0x4
  80182c:	e8 07 fc ff ff       	call   801438 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_exit_env>:


void sys_exit_env(void)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 23                	push   $0x23
  801845:	e8 ee fb ff ff       	call   801438 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801856:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801859:	8d 50 04             	lea    0x4(%eax),%edx
  80185c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	52                   	push   %edx
  801866:	50                   	push   %eax
  801867:	6a 24                	push   $0x24
  801869:	e8 ca fb ff ff       	call   801438 <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
	return result;
  801871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801874:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801877:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80187a:	89 01                	mov    %eax,(%ecx)
  80187c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	c9                   	leave  
  801883:	c2 04 00             	ret    $0x4

00801886 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	ff 75 10             	pushl  0x10(%ebp)
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	6a 12                	push   $0x12
  801898:	e8 9b fb ff ff       	call   801438 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
	return ;
  8018a0:	90                   	nop
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 25                	push   $0x25
  8018b2:	e8 81 fb ff ff       	call   801438 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	50                   	push   %eax
  8018d5:	6a 26                	push   $0x26
  8018d7:	e8 5c fb ff ff       	call   801438 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018df:	90                   	nop
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <rsttst>:
void rsttst()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 28                	push   $0x28
  8018f1:	e8 42 fb ff ff       	call   801438 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f9:	90                   	nop
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801908:	8b 55 18             	mov    0x18(%ebp),%edx
  80190b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80190f:	52                   	push   %edx
  801910:	50                   	push   %eax
  801911:	ff 75 10             	pushl  0x10(%ebp)
  801914:	ff 75 0c             	pushl  0xc(%ebp)
  801917:	ff 75 08             	pushl  0x8(%ebp)
  80191a:	6a 27                	push   $0x27
  80191c:	e8 17 fb ff ff       	call   801438 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
	return ;
  801924:	90                   	nop
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <chktst>:
void chktst(uint32 n)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	ff 75 08             	pushl  0x8(%ebp)
  801935:	6a 29                	push   $0x29
  801937:	e8 fc fa ff ff       	call   801438 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
	return ;
  80193f:	90                   	nop
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <inctst>:

void inctst()
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 2a                	push   $0x2a
  801951:	e8 e2 fa ff ff       	call   801438 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <gettst>:
uint32 gettst()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 2b                	push   $0x2b
  80196b:	e8 c8 fa ff ff       	call   801438 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 2c                	push   $0x2c
  801987:	e8 ac fa ff ff       	call   801438 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
  80198f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801992:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801996:	75 07                	jne    80199f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801998:	b8 01 00 00 00       	mov    $0x1,%eax
  80199d:	eb 05                	jmp    8019a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80199f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 2c                	push   $0x2c
  8019b8:	e8 7b fa ff ff       	call   801438 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
  8019c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019c3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019c7:	75 07                	jne    8019d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ce:	eb 05                	jmp    8019d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 2c                	push   $0x2c
  8019e9:	e8 4a fa ff ff       	call   801438 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
  8019f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019f4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019f8:	75 07                	jne    801a01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ff:	eb 05                	jmp    801a06 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 2c                	push   $0x2c
  801a1a:	e8 19 fa ff ff       	call   801438 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
  801a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a25:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a29:	75 07                	jne    801a32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a30:	eb 05                	jmp    801a37 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	6a 2d                	push   $0x2d
  801a49:	e8 ea f9 ff ff       	call   801438 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
	return ;
  801a51:	90                   	nop
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	53                   	push   %ebx
  801a67:	51                   	push   %ecx
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 2e                	push   $0x2e
  801a6c:	e8 c7 f9 ff ff       	call   801438 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 2f                	push   $0x2f
  801a8c:	e8 a7 f9 ff ff       	call   801438 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801a9c:	83 ec 0c             	sub    $0xc,%esp
  801a9f:	68 d8 3b 80 00       	push   $0x803bd8
  801aa4:	e8 d3 e8 ff ff       	call   80037c <cprintf>
  801aa9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801aac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ab3:	83 ec 0c             	sub    $0xc,%esp
  801ab6:	68 04 3c 80 00       	push   $0x803c04
  801abb:	e8 bc e8 ff ff       	call   80037c <cprintf>
  801ac0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ac3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ac7:	a1 38 41 80 00       	mov    0x804138,%eax
  801acc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801acf:	eb 56                	jmp    801b27 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ad5:	74 1c                	je     801af3 <print_mem_block_lists+0x5d>
  801ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ada:	8b 50 08             	mov    0x8(%eax),%edx
  801add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae0:	8b 48 08             	mov    0x8(%eax),%ecx
  801ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	39 c2                	cmp    %eax,%edx
  801aed:	73 04                	jae    801af3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801aef:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af6:	8b 50 08             	mov    0x8(%eax),%edx
  801af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afc:	8b 40 0c             	mov    0xc(%eax),%eax
  801aff:	01 c2                	add    %eax,%edx
  801b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b04:	8b 40 08             	mov    0x8(%eax),%eax
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	68 19 3c 80 00       	push   $0x803c19
  801b11:	e8 66 e8 ff ff       	call   80037c <cprintf>
  801b16:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b1f:	a1 40 41 80 00       	mov    0x804140,%eax
  801b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b2b:	74 07                	je     801b34 <print_mem_block_lists+0x9e>
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	8b 00                	mov    (%eax),%eax
  801b32:	eb 05                	jmp    801b39 <print_mem_block_lists+0xa3>
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
  801b39:	a3 40 41 80 00       	mov    %eax,0x804140
  801b3e:	a1 40 41 80 00       	mov    0x804140,%eax
  801b43:	85 c0                	test   %eax,%eax
  801b45:	75 8a                	jne    801ad1 <print_mem_block_lists+0x3b>
  801b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4b:	75 84                	jne    801ad1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801b4d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801b51:	75 10                	jne    801b63 <print_mem_block_lists+0xcd>
  801b53:	83 ec 0c             	sub    $0xc,%esp
  801b56:	68 28 3c 80 00       	push   $0x803c28
  801b5b:	e8 1c e8 ff ff       	call   80037c <cprintf>
  801b60:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801b63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801b6a:	83 ec 0c             	sub    $0xc,%esp
  801b6d:	68 4c 3c 80 00       	push   $0x803c4c
  801b72:	e8 05 e8 ff ff       	call   80037c <cprintf>
  801b77:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801b7a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801b7e:	a1 40 40 80 00       	mov    0x804040,%eax
  801b83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b86:	eb 56                	jmp    801bde <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b8c:	74 1c                	je     801baa <print_mem_block_lists+0x114>
  801b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b91:	8b 50 08             	mov    0x8(%eax),%edx
  801b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b97:	8b 48 08             	mov    0x8(%eax),%ecx
  801b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba0:	01 c8                	add    %ecx,%eax
  801ba2:	39 c2                	cmp    %eax,%edx
  801ba4:	73 04                	jae    801baa <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ba6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bad:	8b 50 08             	mov    0x8(%eax),%edx
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb6:	01 c2                	add    %eax,%edx
  801bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbb:	8b 40 08             	mov    0x8(%eax),%eax
  801bbe:	83 ec 04             	sub    $0x4,%esp
  801bc1:	52                   	push   %edx
  801bc2:	50                   	push   %eax
  801bc3:	68 19 3c 80 00       	push   $0x803c19
  801bc8:	e8 af e7 ff ff       	call   80037c <cprintf>
  801bcd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801bd6:	a1 48 40 80 00       	mov    0x804048,%eax
  801bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be2:	74 07                	je     801beb <print_mem_block_lists+0x155>
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	8b 00                	mov    (%eax),%eax
  801be9:	eb 05                	jmp    801bf0 <print_mem_block_lists+0x15a>
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf0:	a3 48 40 80 00       	mov    %eax,0x804048
  801bf5:	a1 48 40 80 00       	mov    0x804048,%eax
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	75 8a                	jne    801b88 <print_mem_block_lists+0xf2>
  801bfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c02:	75 84                	jne    801b88 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c04:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c08:	75 10                	jne    801c1a <print_mem_block_lists+0x184>
  801c0a:	83 ec 0c             	sub    $0xc,%esp
  801c0d:	68 64 3c 80 00       	push   $0x803c64
  801c12:	e8 65 e7 ff ff       	call   80037c <cprintf>
  801c17:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c1a:	83 ec 0c             	sub    $0xc,%esp
  801c1d:	68 d8 3b 80 00       	push   $0x803bd8
  801c22:	e8 55 e7 ff ff       	call   80037c <cprintf>
  801c27:	83 c4 10             	add    $0x10,%esp

}
  801c2a:	90                   	nop
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
  801c30:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801c33:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801c3a:	00 00 00 
  801c3d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801c44:	00 00 00 
  801c47:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801c4e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c58:	e9 9e 00 00 00       	jmp    801cfb <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801c5d:	a1 50 40 80 00       	mov    0x804050,%eax
  801c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c65:	c1 e2 04             	shl    $0x4,%edx
  801c68:	01 d0                	add    %edx,%eax
  801c6a:	85 c0                	test   %eax,%eax
  801c6c:	75 14                	jne    801c82 <initialize_MemBlocksList+0x55>
  801c6e:	83 ec 04             	sub    $0x4,%esp
  801c71:	68 8c 3c 80 00       	push   $0x803c8c
  801c76:	6a 46                	push   $0x46
  801c78:	68 af 3c 80 00       	push   $0x803caf
  801c7d:	e8 18 15 00 00       	call   80319a <_panic>
  801c82:	a1 50 40 80 00       	mov    0x804050,%eax
  801c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8a:	c1 e2 04             	shl    $0x4,%edx
  801c8d:	01 d0                	add    %edx,%eax
  801c8f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801c95:	89 10                	mov    %edx,(%eax)
  801c97:	8b 00                	mov    (%eax),%eax
  801c99:	85 c0                	test   %eax,%eax
  801c9b:	74 18                	je     801cb5 <initialize_MemBlocksList+0x88>
  801c9d:	a1 48 41 80 00       	mov    0x804148,%eax
  801ca2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ca8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801cab:	c1 e1 04             	shl    $0x4,%ecx
  801cae:	01 ca                	add    %ecx,%edx
  801cb0:	89 50 04             	mov    %edx,0x4(%eax)
  801cb3:	eb 12                	jmp    801cc7 <initialize_MemBlocksList+0x9a>
  801cb5:	a1 50 40 80 00       	mov    0x804050,%eax
  801cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbd:	c1 e2 04             	shl    $0x4,%edx
  801cc0:	01 d0                	add    %edx,%eax
  801cc2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801cc7:	a1 50 40 80 00       	mov    0x804050,%eax
  801ccc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ccf:	c1 e2 04             	shl    $0x4,%edx
  801cd2:	01 d0                	add    %edx,%eax
  801cd4:	a3 48 41 80 00       	mov    %eax,0x804148
  801cd9:	a1 50 40 80 00       	mov    0x804050,%eax
  801cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce1:	c1 e2 04             	shl    $0x4,%edx
  801ce4:	01 d0                	add    %edx,%eax
  801ce6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ced:	a1 54 41 80 00       	mov    0x804154,%eax
  801cf2:	40                   	inc    %eax
  801cf3:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801cf8:	ff 45 f4             	incl   -0xc(%ebp)
  801cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfe:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d01:	0f 82 56 ff ff ff    	jb     801c5d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d07:	90                   	nop
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	8b 00                	mov    (%eax),%eax
  801d15:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d18:	eb 19                	jmp    801d33 <find_block+0x29>
	{
		if(va==point->sva)
  801d1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d1d:	8b 40 08             	mov    0x8(%eax),%eax
  801d20:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d23:	75 05                	jne    801d2a <find_block+0x20>
		   return point;
  801d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d28:	eb 36                	jmp    801d60 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 40 08             	mov    0x8(%eax),%eax
  801d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d33:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d37:	74 07                	je     801d40 <find_block+0x36>
  801d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3c:	8b 00                	mov    (%eax),%eax
  801d3e:	eb 05                	jmp    801d45 <find_block+0x3b>
  801d40:	b8 00 00 00 00       	mov    $0x0,%eax
  801d45:	8b 55 08             	mov    0x8(%ebp),%edx
  801d48:	89 42 08             	mov    %eax,0x8(%edx)
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	8b 40 08             	mov    0x8(%eax),%eax
  801d51:	85 c0                	test   %eax,%eax
  801d53:	75 c5                	jne    801d1a <find_block+0x10>
  801d55:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d59:	75 bf                	jne    801d1a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801d68:	a1 40 40 80 00       	mov    0x804040,%eax
  801d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801d70:	a1 44 40 80 00       	mov    0x804044,%eax
  801d75:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d7e:	74 24                	je     801da4 <insert_sorted_allocList+0x42>
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	8b 50 08             	mov    0x8(%eax),%edx
  801d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d89:	8b 40 08             	mov    0x8(%eax),%eax
  801d8c:	39 c2                	cmp    %eax,%edx
  801d8e:	76 14                	jbe    801da4 <insert_sorted_allocList+0x42>
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	8b 50 08             	mov    0x8(%eax),%edx
  801d96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d99:	8b 40 08             	mov    0x8(%eax),%eax
  801d9c:	39 c2                	cmp    %eax,%edx
  801d9e:	0f 82 60 01 00 00    	jb     801f04 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801da4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da8:	75 65                	jne    801e0f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801daa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dae:	75 14                	jne    801dc4 <insert_sorted_allocList+0x62>
  801db0:	83 ec 04             	sub    $0x4,%esp
  801db3:	68 8c 3c 80 00       	push   $0x803c8c
  801db8:	6a 6b                	push   $0x6b
  801dba:	68 af 3c 80 00       	push   $0x803caf
  801dbf:	e8 d6 13 00 00       	call   80319a <_panic>
  801dc4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	89 10                	mov    %edx,(%eax)
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	8b 00                	mov    (%eax),%eax
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	74 0d                	je     801de5 <insert_sorted_allocList+0x83>
  801dd8:	a1 40 40 80 00       	mov    0x804040,%eax
  801ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  801de0:	89 50 04             	mov    %edx,0x4(%eax)
  801de3:	eb 08                	jmp    801ded <insert_sorted_allocList+0x8b>
  801de5:	8b 45 08             	mov    0x8(%ebp),%eax
  801de8:	a3 44 40 80 00       	mov    %eax,0x804044
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	a3 40 40 80 00       	mov    %eax,0x804040
  801df5:	8b 45 08             	mov    0x8(%ebp),%eax
  801df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dff:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e04:	40                   	inc    %eax
  801e05:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e0a:	e9 dc 01 00 00       	jmp    801feb <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	8b 50 08             	mov    0x8(%eax),%edx
  801e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e18:	8b 40 08             	mov    0x8(%eax),%eax
  801e1b:	39 c2                	cmp    %eax,%edx
  801e1d:	77 6c                	ja     801e8b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801e1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e23:	74 06                	je     801e2b <insert_sorted_allocList+0xc9>
  801e25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e29:	75 14                	jne    801e3f <insert_sorted_allocList+0xdd>
  801e2b:	83 ec 04             	sub    $0x4,%esp
  801e2e:	68 c8 3c 80 00       	push   $0x803cc8
  801e33:	6a 6f                	push   $0x6f
  801e35:	68 af 3c 80 00       	push   $0x803caf
  801e3a:	e8 5b 13 00 00       	call   80319a <_panic>
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	8b 50 04             	mov    0x4(%eax),%edx
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	89 50 04             	mov    %edx,0x4(%eax)
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e51:	89 10                	mov    %edx,(%eax)
  801e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e56:	8b 40 04             	mov    0x4(%eax),%eax
  801e59:	85 c0                	test   %eax,%eax
  801e5b:	74 0d                	je     801e6a <insert_sorted_allocList+0x108>
  801e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e60:	8b 40 04             	mov    0x4(%eax),%eax
  801e63:	8b 55 08             	mov    0x8(%ebp),%edx
  801e66:	89 10                	mov    %edx,(%eax)
  801e68:	eb 08                	jmp    801e72 <insert_sorted_allocList+0x110>
  801e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6d:	a3 40 40 80 00       	mov    %eax,0x804040
  801e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e75:	8b 55 08             	mov    0x8(%ebp),%edx
  801e78:	89 50 04             	mov    %edx,0x4(%eax)
  801e7b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e80:	40                   	inc    %eax
  801e81:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e86:	e9 60 01 00 00       	jmp    801feb <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	8b 50 08             	mov    0x8(%eax),%edx
  801e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e94:	8b 40 08             	mov    0x8(%eax),%eax
  801e97:	39 c2                	cmp    %eax,%edx
  801e99:	0f 82 4c 01 00 00    	jb     801feb <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea3:	75 14                	jne    801eb9 <insert_sorted_allocList+0x157>
  801ea5:	83 ec 04             	sub    $0x4,%esp
  801ea8:	68 00 3d 80 00       	push   $0x803d00
  801ead:	6a 73                	push   $0x73
  801eaf:	68 af 3c 80 00       	push   $0x803caf
  801eb4:	e8 e1 12 00 00       	call   80319a <_panic>
  801eb9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	89 50 04             	mov    %edx,0x4(%eax)
  801ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec8:	8b 40 04             	mov    0x4(%eax),%eax
  801ecb:	85 c0                	test   %eax,%eax
  801ecd:	74 0c                	je     801edb <insert_sorted_allocList+0x179>
  801ecf:	a1 44 40 80 00       	mov    0x804044,%eax
  801ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed7:	89 10                	mov    %edx,(%eax)
  801ed9:	eb 08                	jmp    801ee3 <insert_sorted_allocList+0x181>
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	a3 40 40 80 00       	mov    %eax,0x804040
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	a3 44 40 80 00       	mov    %eax,0x804044
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ef4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ef9:	40                   	inc    %eax
  801efa:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801eff:	e9 e7 00 00 00       	jmp    801feb <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f0a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f11:	a1 40 40 80 00       	mov    0x804040,%eax
  801f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f19:	e9 9d 00 00 00       	jmp    801fbb <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 00                	mov    (%eax),%eax
  801f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	8b 50 08             	mov    0x8(%eax),%edx
  801f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2f:	8b 40 08             	mov    0x8(%eax),%eax
  801f32:	39 c2                	cmp    %eax,%edx
  801f34:	76 7d                	jbe    801fb3 <insert_sorted_allocList+0x251>
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	8b 50 08             	mov    0x8(%eax),%edx
  801f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3f:	8b 40 08             	mov    0x8(%eax),%eax
  801f42:	39 c2                	cmp    %eax,%edx
  801f44:	73 6d                	jae    801fb3 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4a:	74 06                	je     801f52 <insert_sorted_allocList+0x1f0>
  801f4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f50:	75 14                	jne    801f66 <insert_sorted_allocList+0x204>
  801f52:	83 ec 04             	sub    $0x4,%esp
  801f55:	68 24 3d 80 00       	push   $0x803d24
  801f5a:	6a 7f                	push   $0x7f
  801f5c:	68 af 3c 80 00       	push   $0x803caf
  801f61:	e8 34 12 00 00       	call   80319a <_panic>
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 10                	mov    (%eax),%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	89 10                	mov    %edx,(%eax)
  801f70:	8b 45 08             	mov    0x8(%ebp),%eax
  801f73:	8b 00                	mov    (%eax),%eax
  801f75:	85 c0                	test   %eax,%eax
  801f77:	74 0b                	je     801f84 <insert_sorted_allocList+0x222>
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 00                	mov    (%eax),%eax
  801f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f81:	89 50 04             	mov    %edx,0x4(%eax)
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8a:	89 10                	mov    %edx,(%eax)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f92:	89 50 04             	mov    %edx,0x4(%eax)
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	8b 00                	mov    (%eax),%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	75 08                	jne    801fa6 <insert_sorted_allocList+0x244>
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	a3 44 40 80 00       	mov    %eax,0x804044
  801fa6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fab:	40                   	inc    %eax
  801fac:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  801fb1:	eb 39                	jmp    801fec <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801fb3:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbf:	74 07                	je     801fc8 <insert_sorted_allocList+0x266>
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	8b 00                	mov    (%eax),%eax
  801fc6:	eb 05                	jmp    801fcd <insert_sorted_allocList+0x26b>
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcd:	a3 48 40 80 00       	mov    %eax,0x804048
  801fd2:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	0f 85 3f ff ff ff    	jne    801f1e <insert_sorted_allocList+0x1bc>
  801fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe3:	0f 85 35 ff ff ff    	jne    801f1e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  801fe9:	eb 01                	jmp    801fec <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801feb:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  801fec:	90                   	nop
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  801ff5:	a1 38 41 80 00       	mov    0x804138,%eax
  801ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffd:	e9 85 01 00 00       	jmp    802187 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 40 0c             	mov    0xc(%eax),%eax
  802008:	3b 45 08             	cmp    0x8(%ebp),%eax
  80200b:	0f 82 6e 01 00 00    	jb     80217f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 40 0c             	mov    0xc(%eax),%eax
  802017:	3b 45 08             	cmp    0x8(%ebp),%eax
  80201a:	0f 85 8a 00 00 00    	jne    8020aa <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802020:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802024:	75 17                	jne    80203d <alloc_block_FF+0x4e>
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 58 3d 80 00       	push   $0x803d58
  80202e:	68 93 00 00 00       	push   $0x93
  802033:	68 af 3c 80 00       	push   $0x803caf
  802038:	e8 5d 11 00 00       	call   80319a <_panic>
  80203d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802040:	8b 00                	mov    (%eax),%eax
  802042:	85 c0                	test   %eax,%eax
  802044:	74 10                	je     802056 <alloc_block_FF+0x67>
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	8b 52 04             	mov    0x4(%edx),%edx
  802051:	89 50 04             	mov    %edx,0x4(%eax)
  802054:	eb 0b                	jmp    802061 <alloc_block_FF+0x72>
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 40 04             	mov    0x4(%eax),%eax
  80205c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802064:	8b 40 04             	mov    0x4(%eax),%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	74 0f                	je     80207a <alloc_block_FF+0x8b>
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 40 04             	mov    0x4(%eax),%eax
  802071:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802074:	8b 12                	mov    (%edx),%edx
  802076:	89 10                	mov    %edx,(%eax)
  802078:	eb 0a                	jmp    802084 <alloc_block_FF+0x95>
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 00                	mov    (%eax),%eax
  80207f:	a3 38 41 80 00       	mov    %eax,0x804138
  802084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802097:	a1 44 41 80 00       	mov    0x804144,%eax
  80209c:	48                   	dec    %eax
  80209d:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	e9 10 01 00 00       	jmp    8021ba <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020b3:	0f 86 c6 00 00 00    	jbe    80217f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8020b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8020be:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	8b 50 08             	mov    0x8(%eax),%edx
  8020c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ca:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d3:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8020d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020da:	75 17                	jne    8020f3 <alloc_block_FF+0x104>
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	68 58 3d 80 00       	push   $0x803d58
  8020e4:	68 9b 00 00 00       	push   $0x9b
  8020e9:	68 af 3c 80 00       	push   $0x803caf
  8020ee:	e8 a7 10 00 00       	call   80319a <_panic>
  8020f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f6:	8b 00                	mov    (%eax),%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	74 10                	je     80210c <alloc_block_FF+0x11d>
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802104:	8b 52 04             	mov    0x4(%edx),%edx
  802107:	89 50 04             	mov    %edx,0x4(%eax)
  80210a:	eb 0b                	jmp    802117 <alloc_block_FF+0x128>
  80210c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210f:	8b 40 04             	mov    0x4(%eax),%eax
  802112:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211a:	8b 40 04             	mov    0x4(%eax),%eax
  80211d:	85 c0                	test   %eax,%eax
  80211f:	74 0f                	je     802130 <alloc_block_FF+0x141>
  802121:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802124:	8b 40 04             	mov    0x4(%eax),%eax
  802127:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80212a:	8b 12                	mov    (%edx),%edx
  80212c:	89 10                	mov    %edx,(%eax)
  80212e:	eb 0a                	jmp    80213a <alloc_block_FF+0x14b>
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	a3 48 41 80 00       	mov    %eax,0x804148
  80213a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214d:	a1 54 41 80 00       	mov    0x804154,%eax
  802152:	48                   	dec    %eax
  802153:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	8b 50 08             	mov    0x8(%eax),%edx
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	01 c2                	add    %eax,%edx
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 40 0c             	mov    0xc(%eax),%eax
  80216f:	2b 45 08             	sub    0x8(%ebp),%eax
  802172:	89 c2                	mov    %eax,%edx
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80217a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217d:	eb 3b                	jmp    8021ba <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80217f:	a1 40 41 80 00       	mov    0x804140,%eax
  802184:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802187:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218b:	74 07                	je     802194 <alloc_block_FF+0x1a5>
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	eb 05                	jmp    802199 <alloc_block_FF+0x1aa>
  802194:	b8 00 00 00 00       	mov    $0x0,%eax
  802199:	a3 40 41 80 00       	mov    %eax,0x804140
  80219e:	a1 40 41 80 00       	mov    0x804140,%eax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	0f 85 57 fe ff ff    	jne    802002 <alloc_block_FF+0x13>
  8021ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021af:	0f 85 4d fe ff ff    	jne    802002 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8021b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8021c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8021c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8021ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d1:	e9 df 00 00 00       	jmp    8022b5 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021df:	0f 82 c8 00 00 00    	jb     8022ad <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8021eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ee:	0f 85 8a 00 00 00    	jne    80227e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8021f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f8:	75 17                	jne    802211 <alloc_block_BF+0x55>
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 58 3d 80 00       	push   $0x803d58
  802202:	68 b7 00 00 00       	push   $0xb7
  802207:	68 af 3c 80 00       	push   $0x803caf
  80220c:	e8 89 0f 00 00       	call   80319a <_panic>
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	85 c0                	test   %eax,%eax
  802218:	74 10                	je     80222a <alloc_block_BF+0x6e>
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 00                	mov    (%eax),%eax
  80221f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802222:	8b 52 04             	mov    0x4(%edx),%edx
  802225:	89 50 04             	mov    %edx,0x4(%eax)
  802228:	eb 0b                	jmp    802235 <alloc_block_BF+0x79>
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	8b 40 04             	mov    0x4(%eax),%eax
  802230:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	8b 40 04             	mov    0x4(%eax),%eax
  80223b:	85 c0                	test   %eax,%eax
  80223d:	74 0f                	je     80224e <alloc_block_BF+0x92>
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 40 04             	mov    0x4(%eax),%eax
  802245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802248:	8b 12                	mov    (%edx),%edx
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	eb 0a                	jmp    802258 <alloc_block_BF+0x9c>
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	a3 38 41 80 00       	mov    %eax,0x804138
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226b:	a1 44 41 80 00       	mov    0x804144,%eax
  802270:	48                   	dec    %eax
  802271:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	e9 4d 01 00 00       	jmp    8023cb <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 40 0c             	mov    0xc(%eax),%eax
  802284:	3b 45 08             	cmp    0x8(%ebp),%eax
  802287:	76 24                	jbe    8022ad <alloc_block_BF+0xf1>
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	8b 40 0c             	mov    0xc(%eax),%eax
  80228f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802292:	73 19                	jae    8022ad <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802294:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 40 08             	mov    0x8(%eax),%eax
  8022aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8022ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8022b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b9:	74 07                	je     8022c2 <alloc_block_BF+0x106>
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	eb 05                	jmp    8022c7 <alloc_block_BF+0x10b>
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c7:	a3 40 41 80 00       	mov    %eax,0x804140
  8022cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	0f 85 fd fe ff ff    	jne    8021d6 <alloc_block_BF+0x1a>
  8022d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dd:	0f 85 f3 fe ff ff    	jne    8021d6 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8022e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022e7:	0f 84 d9 00 00 00    	je     8023c6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022ed:	a1 48 41 80 00       	mov    0x804148,%eax
  8022f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8022f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022fb:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8022fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802301:	8b 55 08             	mov    0x8(%ebp),%edx
  802304:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802307:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80230b:	75 17                	jne    802324 <alloc_block_BF+0x168>
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 58 3d 80 00       	push   $0x803d58
  802315:	68 c7 00 00 00       	push   $0xc7
  80231a:	68 af 3c 80 00       	push   $0x803caf
  80231f:	e8 76 0e 00 00       	call   80319a <_panic>
  802324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 10                	je     80233d <alloc_block_BF+0x181>
  80232d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802335:	8b 52 04             	mov    0x4(%edx),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	eb 0b                	jmp    802348 <alloc_block_BF+0x18c>
  80233d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802340:	8b 40 04             	mov    0x4(%eax),%eax
  802343:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80234b:	8b 40 04             	mov    0x4(%eax),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 0f                	je     802361 <alloc_block_BF+0x1a5>
  802352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802355:	8b 40 04             	mov    0x4(%eax),%eax
  802358:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80235b:	8b 12                	mov    (%edx),%edx
  80235d:	89 10                	mov    %edx,(%eax)
  80235f:	eb 0a                	jmp    80236b <alloc_block_BF+0x1af>
  802361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802364:	8b 00                	mov    (%eax),%eax
  802366:	a3 48 41 80 00       	mov    %eax,0x804148
  80236b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802377:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237e:	a1 54 41 80 00       	mov    0x804154,%eax
  802383:	48                   	dec    %eax
  802384:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802389:	83 ec 08             	sub    $0x8,%esp
  80238c:	ff 75 ec             	pushl  -0x14(%ebp)
  80238f:	68 38 41 80 00       	push   $0x804138
  802394:	e8 71 f9 ff ff       	call   801d0a <find_block>
  802399:	83 c4 10             	add    $0x10,%esp
  80239c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80239f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a2:	8b 50 08             	mov    0x8(%eax),%edx
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	01 c2                	add    %eax,%edx
  8023aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ad:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8023b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b9:	89 c2                	mov    %eax,%edx
  8023bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023be:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8023c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c4:	eb 05                	jmp    8023cb <alloc_block_BF+0x20f>
	}
	return NULL;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8023d3:	a1 28 40 80 00       	mov    0x804028,%eax
  8023d8:	85 c0                	test   %eax,%eax
  8023da:	0f 85 de 01 00 00    	jne    8025be <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8023e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e8:	e9 9e 01 00 00       	jmp    80258b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f6:	0f 82 87 01 00 00    	jb     802583 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	3b 45 08             	cmp    0x8(%ebp),%eax
  802405:	0f 85 95 00 00 00    	jne    8024a0 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80240b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240f:	75 17                	jne    802428 <alloc_block_NF+0x5b>
  802411:	83 ec 04             	sub    $0x4,%esp
  802414:	68 58 3d 80 00       	push   $0x803d58
  802419:	68 e0 00 00 00       	push   $0xe0
  80241e:	68 af 3c 80 00       	push   $0x803caf
  802423:	e8 72 0d 00 00       	call   80319a <_panic>
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 00                	mov    (%eax),%eax
  80242d:	85 c0                	test   %eax,%eax
  80242f:	74 10                	je     802441 <alloc_block_NF+0x74>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	8b 52 04             	mov    0x4(%edx),%edx
  80243c:	89 50 04             	mov    %edx,0x4(%eax)
  80243f:	eb 0b                	jmp    80244c <alloc_block_NF+0x7f>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 40 04             	mov    0x4(%eax),%eax
  802447:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0f                	je     802465 <alloc_block_NF+0x98>
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 40 04             	mov    0x4(%eax),%eax
  80245c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245f:	8b 12                	mov    (%edx),%edx
  802461:	89 10                	mov    %edx,(%eax)
  802463:	eb 0a                	jmp    80246f <alloc_block_NF+0xa2>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	a3 38 41 80 00       	mov    %eax,0x804138
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802482:	a1 44 41 80 00       	mov    0x804144,%eax
  802487:	48                   	dec    %eax
  802488:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 40 08             	mov    0x8(%eax),%eax
  802493:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	e9 f8 04 00 00       	jmp    802998 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a9:	0f 86 d4 00 00 00    	jbe    802583 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024af:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	8b 50 08             	mov    0x8(%eax),%edx
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8024c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d0:	75 17                	jne    8024e9 <alloc_block_NF+0x11c>
  8024d2:	83 ec 04             	sub    $0x4,%esp
  8024d5:	68 58 3d 80 00       	push   $0x803d58
  8024da:	68 e9 00 00 00       	push   $0xe9
  8024df:	68 af 3c 80 00       	push   $0x803caf
  8024e4:	e8 b1 0c 00 00       	call   80319a <_panic>
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	8b 00                	mov    (%eax),%eax
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	74 10                	je     802502 <alloc_block_NF+0x135>
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fa:	8b 52 04             	mov    0x4(%edx),%edx
  8024fd:	89 50 04             	mov    %edx,0x4(%eax)
  802500:	eb 0b                	jmp    80250d <alloc_block_NF+0x140>
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80250d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 0f                	je     802526 <alloc_block_NF+0x159>
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802520:	8b 12                	mov    (%edx),%edx
  802522:	89 10                	mov    %edx,(%eax)
  802524:	eb 0a                	jmp    802530 <alloc_block_NF+0x163>
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	a3 48 41 80 00       	mov    %eax,0x804148
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802543:	a1 54 41 80 00       	mov    0x804154,%eax
  802548:	48                   	dec    %eax
  802549:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	8b 40 08             	mov    0x8(%eax),%eax
  802554:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 50 08             	mov    0x8(%eax),%edx
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	01 c2                	add    %eax,%edx
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 0c             	mov    0xc(%eax),%eax
  802570:	2b 45 08             	sub    0x8(%ebp),%eax
  802573:	89 c2                	mov    %eax,%edx
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80257b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257e:	e9 15 04 00 00       	jmp    802998 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802583:	a1 40 41 80 00       	mov    0x804140,%eax
  802588:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258f:	74 07                	je     802598 <alloc_block_NF+0x1cb>
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	eb 05                	jmp    80259d <alloc_block_NF+0x1d0>
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	a3 40 41 80 00       	mov    %eax,0x804140
  8025a2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	0f 85 3e fe ff ff    	jne    8023ed <alloc_block_NF+0x20>
  8025af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b3:	0f 85 34 fe ff ff    	jne    8023ed <alloc_block_NF+0x20>
  8025b9:	e9 d5 03 00 00       	jmp    802993 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8025be:	a1 38 41 80 00       	mov    0x804138,%eax
  8025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c6:	e9 b1 01 00 00       	jmp    80277c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 50 08             	mov    0x8(%eax),%edx
  8025d1:	a1 28 40 80 00       	mov    0x804028,%eax
  8025d6:	39 c2                	cmp    %eax,%edx
  8025d8:	0f 82 96 01 00 00    	jb     802774 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e7:	0f 82 87 01 00 00    	jb     802774 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f6:	0f 85 95 00 00 00    	jne    802691 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8025fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802600:	75 17                	jne    802619 <alloc_block_NF+0x24c>
  802602:	83 ec 04             	sub    $0x4,%esp
  802605:	68 58 3d 80 00       	push   $0x803d58
  80260a:	68 fc 00 00 00       	push   $0xfc
  80260f:	68 af 3c 80 00       	push   $0x803caf
  802614:	e8 81 0b 00 00       	call   80319a <_panic>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 00                	mov    (%eax),%eax
  80261e:	85 c0                	test   %eax,%eax
  802620:	74 10                	je     802632 <alloc_block_NF+0x265>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80262a:	8b 52 04             	mov    0x4(%edx),%edx
  80262d:	89 50 04             	mov    %edx,0x4(%eax)
  802630:	eb 0b                	jmp    80263d <alloc_block_NF+0x270>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 0f                	je     802656 <alloc_block_NF+0x289>
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802650:	8b 12                	mov    (%edx),%edx
  802652:	89 10                	mov    %edx,(%eax)
  802654:	eb 0a                	jmp    802660 <alloc_block_NF+0x293>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	a3 38 41 80 00       	mov    %eax,0x804138
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802673:	a1 44 41 80 00       	mov    0x804144,%eax
  802678:	48                   	dec    %eax
  802679:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 08             	mov    0x8(%eax),%eax
  802684:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	e9 07 03 00 00       	jmp    802998 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 0c             	mov    0xc(%eax),%eax
  802697:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269a:	0f 86 d4 00 00 00    	jbe    802774 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a0:	a1 48 41 80 00       	mov    0x804148,%eax
  8026a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 50 08             	mov    0x8(%eax),%edx
  8026ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8026b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ba:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c1:	75 17                	jne    8026da <alloc_block_NF+0x30d>
  8026c3:	83 ec 04             	sub    $0x4,%esp
  8026c6:	68 58 3d 80 00       	push   $0x803d58
  8026cb:	68 04 01 00 00       	push   $0x104
  8026d0:	68 af 3c 80 00       	push   $0x803caf
  8026d5:	e8 c0 0a 00 00       	call   80319a <_panic>
  8026da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026dd:	8b 00                	mov    (%eax),%eax
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	74 10                	je     8026f3 <alloc_block_NF+0x326>
  8026e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026eb:	8b 52 04             	mov    0x4(%edx),%edx
  8026ee:	89 50 04             	mov    %edx,0x4(%eax)
  8026f1:	eb 0b                	jmp    8026fe <alloc_block_NF+0x331>
  8026f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f6:	8b 40 04             	mov    0x4(%eax),%eax
  8026f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802701:	8b 40 04             	mov    0x4(%eax),%eax
  802704:	85 c0                	test   %eax,%eax
  802706:	74 0f                	je     802717 <alloc_block_NF+0x34a>
  802708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270b:	8b 40 04             	mov    0x4(%eax),%eax
  80270e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802711:	8b 12                	mov    (%edx),%edx
  802713:	89 10                	mov    %edx,(%eax)
  802715:	eb 0a                	jmp    802721 <alloc_block_NF+0x354>
  802717:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	a3 48 41 80 00       	mov    %eax,0x804148
  802721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802724:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802734:	a1 54 41 80 00       	mov    0x804154,%eax
  802739:	48                   	dec    %eax
  80273a:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80273f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802742:	8b 40 08             	mov    0x8(%eax),%eax
  802745:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 50 08             	mov    0x8(%eax),%edx
  802750:	8b 45 08             	mov    0x8(%ebp),%eax
  802753:	01 c2                	add    %eax,%edx
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 0c             	mov    0xc(%eax),%eax
  802761:	2b 45 08             	sub    0x8(%ebp),%eax
  802764:	89 c2                	mov    %eax,%edx
  802766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802769:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80276c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276f:	e9 24 02 00 00       	jmp    802998 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802774:	a1 40 41 80 00       	mov    0x804140,%eax
  802779:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802780:	74 07                	je     802789 <alloc_block_NF+0x3bc>
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	eb 05                	jmp    80278e <alloc_block_NF+0x3c1>
  802789:	b8 00 00 00 00       	mov    $0x0,%eax
  80278e:	a3 40 41 80 00       	mov    %eax,0x804140
  802793:	a1 40 41 80 00       	mov    0x804140,%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	0f 85 2b fe ff ff    	jne    8025cb <alloc_block_NF+0x1fe>
  8027a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a4:	0f 85 21 fe ff ff    	jne    8025cb <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027aa:	a1 38 41 80 00       	mov    0x804138,%eax
  8027af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b2:	e9 ae 01 00 00       	jmp    802965 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 50 08             	mov    0x8(%eax),%edx
  8027bd:	a1 28 40 80 00       	mov    0x804028,%eax
  8027c2:	39 c2                	cmp    %eax,%edx
  8027c4:	0f 83 93 01 00 00    	jae    80295d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d3:	0f 82 84 01 00 00    	jb     80295d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e2:	0f 85 95 00 00 00    	jne    80287d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	75 17                	jne    802805 <alloc_block_NF+0x438>
  8027ee:	83 ec 04             	sub    $0x4,%esp
  8027f1:	68 58 3d 80 00       	push   $0x803d58
  8027f6:	68 14 01 00 00       	push   $0x114
  8027fb:	68 af 3c 80 00       	push   $0x803caf
  802800:	e8 95 09 00 00       	call   80319a <_panic>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	85 c0                	test   %eax,%eax
  80280c:	74 10                	je     80281e <alloc_block_NF+0x451>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802816:	8b 52 04             	mov    0x4(%edx),%edx
  802819:	89 50 04             	mov    %edx,0x4(%eax)
  80281c:	eb 0b                	jmp    802829 <alloc_block_NF+0x45c>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 04             	mov    0x4(%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 0f                	je     802842 <alloc_block_NF+0x475>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283c:	8b 12                	mov    (%edx),%edx
  80283e:	89 10                	mov    %edx,(%eax)
  802840:	eb 0a                	jmp    80284c <alloc_block_NF+0x47f>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	a3 38 41 80 00       	mov    %eax,0x804138
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285f:	a1 44 41 80 00       	mov    0x804144,%eax
  802864:	48                   	dec    %eax
  802865:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 08             	mov    0x8(%eax),%eax
  802870:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	e9 1b 01 00 00       	jmp    802998 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 0c             	mov    0xc(%eax),%eax
  802883:	3b 45 08             	cmp    0x8(%ebp),%eax
  802886:	0f 86 d1 00 00 00    	jbe    80295d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80288c:	a1 48 41 80 00       	mov    0x804148,%eax
  802891:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 50 08             	mov    0x8(%eax),%edx
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028ad:	75 17                	jne    8028c6 <alloc_block_NF+0x4f9>
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	68 58 3d 80 00       	push   $0x803d58
  8028b7:	68 1c 01 00 00       	push   $0x11c
  8028bc:	68 af 3c 80 00       	push   $0x803caf
  8028c1:	e8 d4 08 00 00       	call   80319a <_panic>
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	8b 00                	mov    (%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	74 10                	je     8028df <alloc_block_NF+0x512>
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d7:	8b 52 04             	mov    0x4(%edx),%edx
  8028da:	89 50 04             	mov    %edx,0x4(%eax)
  8028dd:	eb 0b                	jmp    8028ea <alloc_block_NF+0x51d>
  8028df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e2:	8b 40 04             	mov    0x4(%eax),%eax
  8028e5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	8b 40 04             	mov    0x4(%eax),%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 0f                	je     802903 <alloc_block_NF+0x536>
  8028f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028fd:	8b 12                	mov    (%edx),%edx
  8028ff:	89 10                	mov    %edx,(%eax)
  802901:	eb 0a                	jmp    80290d <alloc_block_NF+0x540>
  802903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	a3 48 41 80 00       	mov    %eax,0x804148
  80290d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802910:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802920:	a1 54 41 80 00       	mov    0x804154,%eax
  802925:	48                   	dec    %eax
  802926:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80292b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292e:	8b 40 08             	mov    0x8(%eax),%eax
  802931:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 50 08             	mov    0x8(%eax),%edx
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	01 c2                	add    %eax,%edx
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 0c             	mov    0xc(%eax),%eax
  80294d:	2b 45 08             	sub    0x8(%ebp),%eax
  802950:	89 c2                	mov    %eax,%edx
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295b:	eb 3b                	jmp    802998 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80295d:	a1 40 41 80 00       	mov    0x804140,%eax
  802962:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802969:	74 07                	je     802972 <alloc_block_NF+0x5a5>
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	eb 05                	jmp    802977 <alloc_block_NF+0x5aa>
  802972:	b8 00 00 00 00       	mov    $0x0,%eax
  802977:	a3 40 41 80 00       	mov    %eax,0x804140
  80297c:	a1 40 41 80 00       	mov    0x804140,%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	0f 85 2e fe ff ff    	jne    8027b7 <alloc_block_NF+0x3ea>
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	0f 85 24 fe ff ff    	jne    8027b7 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8029a0:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8029a8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ad:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8029b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 14                	je     8029cd <insert_sorted_with_merge_freeList+0x33>
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	8b 50 08             	mov    0x8(%eax),%edx
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	8b 40 08             	mov    0x8(%eax),%eax
  8029c5:	39 c2                	cmp    %eax,%edx
  8029c7:	0f 87 9b 01 00 00    	ja     802b68 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8029cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d1:	75 17                	jne    8029ea <insert_sorted_with_merge_freeList+0x50>
  8029d3:	83 ec 04             	sub    $0x4,%esp
  8029d6:	68 8c 3c 80 00       	push   $0x803c8c
  8029db:	68 38 01 00 00       	push   $0x138
  8029e0:	68 af 3c 80 00       	push   $0x803caf
  8029e5:	e8 b0 07 00 00       	call   80319a <_panic>
  8029ea:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	89 10                	mov    %edx,(%eax)
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	8b 00                	mov    (%eax),%eax
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	74 0d                	je     802a0b <insert_sorted_with_merge_freeList+0x71>
  8029fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802a03:	8b 55 08             	mov    0x8(%ebp),%edx
  802a06:	89 50 04             	mov    %edx,0x4(%eax)
  802a09:	eb 08                	jmp    802a13 <insert_sorted_with_merge_freeList+0x79>
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	a3 38 41 80 00       	mov    %eax,0x804138
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a25:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2a:	40                   	inc    %eax
  802a2b:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802a30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a34:	0f 84 a8 06 00 00    	je     8030e2 <insert_sorted_with_merge_freeList+0x748>
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	8b 40 0c             	mov    0xc(%eax),%eax
  802a46:	01 c2                	add    %eax,%edx
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	39 c2                	cmp    %eax,%edx
  802a50:	0f 85 8c 06 00 00    	jne    8030e2 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	8b 50 0c             	mov    0xc(%eax),%edx
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	01 c2                	add    %eax,%edx
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802a6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6e:	75 17                	jne    802a87 <insert_sorted_with_merge_freeList+0xed>
  802a70:	83 ec 04             	sub    $0x4,%esp
  802a73:	68 58 3d 80 00       	push   $0x803d58
  802a78:	68 3c 01 00 00       	push   $0x13c
  802a7d:	68 af 3c 80 00       	push   $0x803caf
  802a82:	e8 13 07 00 00       	call   80319a <_panic>
  802a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a8a:	8b 00                	mov    (%eax),%eax
  802a8c:	85 c0                	test   %eax,%eax
  802a8e:	74 10                	je     802aa0 <insert_sorted_with_merge_freeList+0x106>
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a98:	8b 52 04             	mov    0x4(%edx),%edx
  802a9b:	89 50 04             	mov    %edx,0x4(%eax)
  802a9e:	eb 0b                	jmp    802aab <insert_sorted_with_merge_freeList+0x111>
  802aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aae:	8b 40 04             	mov    0x4(%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 0f                	je     802ac4 <insert_sorted_with_merge_freeList+0x12a>
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 40 04             	mov    0x4(%eax),%eax
  802abb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abe:	8b 12                	mov    (%edx),%edx
  802ac0:	89 10                	mov    %edx,(%eax)
  802ac2:	eb 0a                	jmp    802ace <insert_sorted_with_merge_freeList+0x134>
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	a3 38 41 80 00       	mov    %eax,0x804138
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ada:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae1:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae6:	48                   	dec    %eax
  802ae7:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b04:	75 17                	jne    802b1d <insert_sorted_with_merge_freeList+0x183>
  802b06:	83 ec 04             	sub    $0x4,%esp
  802b09:	68 8c 3c 80 00       	push   $0x803c8c
  802b0e:	68 3f 01 00 00       	push   $0x13f
  802b13:	68 af 3c 80 00       	push   $0x803caf
  802b18:	e8 7d 06 00 00       	call   80319a <_panic>
  802b1d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b26:	89 10                	mov    %edx,(%eax)
  802b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 0d                	je     802b3e <insert_sorted_with_merge_freeList+0x1a4>
  802b31:	a1 48 41 80 00       	mov    0x804148,%eax
  802b36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b39:	89 50 04             	mov    %edx,0x4(%eax)
  802b3c:	eb 08                	jmp    802b46 <insert_sorted_with_merge_freeList+0x1ac>
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	a3 48 41 80 00       	mov    %eax,0x804148
  802b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b58:	a1 54 41 80 00       	mov    0x804154,%eax
  802b5d:	40                   	inc    %eax
  802b5e:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b63:	e9 7a 05 00 00       	jmp    8030e2 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	39 c2                	cmp    %eax,%edx
  802b76:	0f 82 14 01 00 00    	jb     802c90 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7f:	8b 50 08             	mov    0x8(%eax),%edx
  802b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b85:	8b 40 0c             	mov    0xc(%eax),%eax
  802b88:	01 c2                	add    %eax,%edx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 40 08             	mov    0x8(%eax),%eax
  802b90:	39 c2                	cmp    %eax,%edx
  802b92:	0f 85 90 00 00 00    	jne    802c28 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba9:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc4:	75 17                	jne    802bdd <insert_sorted_with_merge_freeList+0x243>
  802bc6:	83 ec 04             	sub    $0x4,%esp
  802bc9:	68 8c 3c 80 00       	push   $0x803c8c
  802bce:	68 49 01 00 00       	push   $0x149
  802bd3:	68 af 3c 80 00       	push   $0x803caf
  802bd8:	e8 bd 05 00 00       	call   80319a <_panic>
  802bdd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	89 10                	mov    %edx,(%eax)
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	74 0d                	je     802bfe <insert_sorted_with_merge_freeList+0x264>
  802bf1:	a1 48 41 80 00       	mov    0x804148,%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	89 50 04             	mov    %edx,0x4(%eax)
  802bfc:	eb 08                	jmp    802c06 <insert_sorted_with_merge_freeList+0x26c>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	a3 48 41 80 00       	mov    %eax,0x804148
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c18:	a1 54 41 80 00       	mov    0x804154,%eax
  802c1d:	40                   	inc    %eax
  802c1e:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c23:	e9 bb 04 00 00       	jmp    8030e3 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2c:	75 17                	jne    802c45 <insert_sorted_with_merge_freeList+0x2ab>
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 00 3d 80 00       	push   $0x803d00
  802c36:	68 4c 01 00 00       	push   $0x14c
  802c3b:	68 af 3c 80 00       	push   $0x803caf
  802c40:	e8 55 05 00 00       	call   80319a <_panic>
  802c45:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	89 50 04             	mov    %edx,0x4(%eax)
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 0c                	je     802c67 <insert_sorted_with_merge_freeList+0x2cd>
  802c5b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c60:	8b 55 08             	mov    0x8(%ebp),%edx
  802c63:	89 10                	mov    %edx,(%eax)
  802c65:	eb 08                	jmp    802c6f <insert_sorted_with_merge_freeList+0x2d5>
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	a3 38 41 80 00       	mov    %eax,0x804138
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c80:	a1 44 41 80 00       	mov    0x804144,%eax
  802c85:	40                   	inc    %eax
  802c86:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c8b:	e9 53 04 00 00       	jmp    8030e3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802c90:	a1 38 41 80 00       	mov    0x804138,%eax
  802c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c98:	e9 15 04 00 00       	jmp    8030b2 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 50 08             	mov    0x8(%eax),%edx
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 08             	mov    0x8(%eax),%eax
  802cb1:	39 c2                	cmp    %eax,%edx
  802cb3:	0f 86 f1 03 00 00    	jbe    8030aa <insert_sorted_with_merge_freeList+0x710>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc2:	8b 40 08             	mov    0x8(%eax),%eax
  802cc5:	39 c2                	cmp    %eax,%edx
  802cc7:	0f 83 dd 03 00 00    	jae    8030aa <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd9:	01 c2                	add    %eax,%edx
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	39 c2                	cmp    %eax,%edx
  802ce3:	0f 85 b9 01 00 00    	jne    802ea2 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 08             	mov    0x8(%eax),%edx
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf5:	01 c2                	add    %eax,%edx
  802cf7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfa:	8b 40 08             	mov    0x8(%eax),%eax
  802cfd:	39 c2                	cmp    %eax,%edx
  802cff:	0f 85 0d 01 00 00    	jne    802e12 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d11:	01 c2                	add    %eax,%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d19:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d1d:	75 17                	jne    802d36 <insert_sorted_with_merge_freeList+0x39c>
  802d1f:	83 ec 04             	sub    $0x4,%esp
  802d22:	68 58 3d 80 00       	push   $0x803d58
  802d27:	68 5c 01 00 00       	push   $0x15c
  802d2c:	68 af 3c 80 00       	push   $0x803caf
  802d31:	e8 64 04 00 00       	call   80319a <_panic>
  802d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	74 10                	je     802d4f <insert_sorted_with_merge_freeList+0x3b5>
  802d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d47:	8b 52 04             	mov    0x4(%edx),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	eb 0b                	jmp    802d5a <insert_sorted_with_merge_freeList+0x3c0>
  802d4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d52:	8b 40 04             	mov    0x4(%eax),%eax
  802d55:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5d:	8b 40 04             	mov    0x4(%eax),%eax
  802d60:	85 c0                	test   %eax,%eax
  802d62:	74 0f                	je     802d73 <insert_sorted_with_merge_freeList+0x3d9>
  802d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d67:	8b 40 04             	mov    0x4(%eax),%eax
  802d6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6d:	8b 12                	mov    (%edx),%edx
  802d6f:	89 10                	mov    %edx,(%eax)
  802d71:	eb 0a                	jmp    802d7d <insert_sorted_with_merge_freeList+0x3e3>
  802d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	a3 38 41 80 00       	mov    %eax,0x804138
  802d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d90:	a1 44 41 80 00       	mov    0x804144,%eax
  802d95:	48                   	dec    %eax
  802d96:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802d9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802da5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802daf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802db3:	75 17                	jne    802dcc <insert_sorted_with_merge_freeList+0x432>
  802db5:	83 ec 04             	sub    $0x4,%esp
  802db8:	68 8c 3c 80 00       	push   $0x803c8c
  802dbd:	68 5f 01 00 00       	push   $0x15f
  802dc2:	68 af 3c 80 00       	push   $0x803caf
  802dc7:	e8 ce 03 00 00       	call   80319a <_panic>
  802dcc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd5:	89 10                	mov    %edx,(%eax)
  802dd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dda:	8b 00                	mov    (%eax),%eax
  802ddc:	85 c0                	test   %eax,%eax
  802dde:	74 0d                	je     802ded <insert_sorted_with_merge_freeList+0x453>
  802de0:	a1 48 41 80 00       	mov    0x804148,%eax
  802de5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de8:	89 50 04             	mov    %edx,0x4(%eax)
  802deb:	eb 08                	jmp    802df5 <insert_sorted_with_merge_freeList+0x45b>
  802ded:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df8:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e07:	a1 54 41 80 00       	mov    0x804154,%eax
  802e0c:	40                   	inc    %eax
  802e0d:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e15:	8b 50 0c             	mov    0xc(%eax),%edx
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3e:	75 17                	jne    802e57 <insert_sorted_with_merge_freeList+0x4bd>
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 8c 3c 80 00       	push   $0x803c8c
  802e48:	68 64 01 00 00       	push   $0x164
  802e4d:	68 af 3c 80 00       	push   $0x803caf
  802e52:	e8 43 03 00 00       	call   80319a <_panic>
  802e57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	85 c0                	test   %eax,%eax
  802e69:	74 0d                	je     802e78 <insert_sorted_with_merge_freeList+0x4de>
  802e6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e70:	8b 55 08             	mov    0x8(%ebp),%edx
  802e73:	89 50 04             	mov    %edx,0x4(%eax)
  802e76:	eb 08                	jmp    802e80 <insert_sorted_with_merge_freeList+0x4e6>
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	a3 48 41 80 00       	mov    %eax,0x804148
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e92:	a1 54 41 80 00       	mov    0x804154,%eax
  802e97:	40                   	inc    %eax
  802e98:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802e9d:	e9 41 02 00 00       	jmp    8030e3 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	8b 50 08             	mov    0x8(%eax),%edx
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	8b 40 0c             	mov    0xc(%eax),%eax
  802eae:	01 c2                	add    %eax,%edx
  802eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb3:	8b 40 08             	mov    0x8(%eax),%eax
  802eb6:	39 c2                	cmp    %eax,%edx
  802eb8:	0f 85 7c 01 00 00    	jne    80303a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802ebe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec2:	74 06                	je     802eca <insert_sorted_with_merge_freeList+0x530>
  802ec4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec8:	75 17                	jne    802ee1 <insert_sorted_with_merge_freeList+0x547>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 c8 3c 80 00       	push   $0x803cc8
  802ed2:	68 69 01 00 00       	push   $0x169
  802ed7:	68 af 3c 80 00       	push   $0x803caf
  802edc:	e8 b9 02 00 00       	call   80319a <_panic>
  802ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee4:	8b 50 04             	mov    0x4(%eax),%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	89 50 04             	mov    %edx,0x4(%eax)
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef3:	89 10                	mov    %edx,(%eax)
  802ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef8:	8b 40 04             	mov    0x4(%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 0d                	je     802f0c <insert_sorted_with_merge_freeList+0x572>
  802eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f02:	8b 40 04             	mov    0x4(%eax),%eax
  802f05:	8b 55 08             	mov    0x8(%ebp),%edx
  802f08:	89 10                	mov    %edx,(%eax)
  802f0a:	eb 08                	jmp    802f14 <insert_sorted_with_merge_freeList+0x57a>
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	a3 38 41 80 00       	mov    %eax,0x804138
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%eax)
  802f1d:	a1 44 41 80 00       	mov    0x804144,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	8b 40 0c             	mov    0xc(%eax),%eax
  802f34:	01 c2                	add    %eax,%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f3c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f40:	75 17                	jne    802f59 <insert_sorted_with_merge_freeList+0x5bf>
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	68 58 3d 80 00       	push   $0x803d58
  802f4a:	68 6b 01 00 00       	push   $0x16b
  802f4f:	68 af 3c 80 00       	push   $0x803caf
  802f54:	e8 41 02 00 00       	call   80319a <_panic>
  802f59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 10                	je     802f72 <insert_sorted_with_merge_freeList+0x5d8>
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f6a:	8b 52 04             	mov    0x4(%edx),%edx
  802f6d:	89 50 04             	mov    %edx,0x4(%eax)
  802f70:	eb 0b                	jmp    802f7d <insert_sorted_with_merge_freeList+0x5e3>
  802f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f75:	8b 40 04             	mov    0x4(%eax),%eax
  802f78:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0f                	je     802f96 <insert_sorted_with_merge_freeList+0x5fc>
  802f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f90:	8b 12                	mov    (%edx),%edx
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	eb 0a                	jmp    802fa0 <insert_sorted_with_merge_freeList+0x606>
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	a3 38 41 80 00       	mov    %eax,0x804138
  802fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb3:	a1 44 41 80 00       	mov    0x804144,%eax
  802fb8:	48                   	dec    %eax
  802fb9:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  802fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd6:	75 17                	jne    802fef <insert_sorted_with_merge_freeList+0x655>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 8c 3c 80 00       	push   $0x803c8c
  802fe0:	68 6e 01 00 00       	push   $0x16e
  802fe5:	68 af 3c 80 00       	push   $0x803caf
  802fea:	e8 ab 01 00 00       	call   80319a <_panic>
  802fef:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0d                	je     803010 <insert_sorted_with_merge_freeList+0x676>
  803003:	a1 48 41 80 00       	mov    0x804148,%eax
  803008:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%eax)
  80300e:	eb 08                	jmp    803018 <insert_sorted_with_merge_freeList+0x67e>
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803018:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301b:	a3 48 41 80 00       	mov    %eax,0x804148
  803020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803023:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302a:	a1 54 41 80 00       	mov    0x804154,%eax
  80302f:	40                   	inc    %eax
  803030:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803035:	e9 a9 00 00 00       	jmp    8030e3 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80303a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303e:	74 06                	je     803046 <insert_sorted_with_merge_freeList+0x6ac>
  803040:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803044:	75 17                	jne    80305d <insert_sorted_with_merge_freeList+0x6c3>
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	68 24 3d 80 00       	push   $0x803d24
  80304e:	68 73 01 00 00       	push   $0x173
  803053:	68 af 3c 80 00       	push   $0x803caf
  803058:	e8 3d 01 00 00       	call   80319a <_panic>
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 10                	mov    (%eax),%edx
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	89 10                	mov    %edx,(%eax)
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	85 c0                	test   %eax,%eax
  80306e:	74 0b                	je     80307b <insert_sorted_with_merge_freeList+0x6e1>
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 00                	mov    (%eax),%eax
  803075:	8b 55 08             	mov    0x8(%ebp),%edx
  803078:	89 50 04             	mov    %edx,0x4(%eax)
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 55 08             	mov    0x8(%ebp),%edx
  803081:	89 10                	mov    %edx,(%eax)
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803089:	89 50 04             	mov    %edx,0x4(%eax)
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	8b 00                	mov    (%eax),%eax
  803091:	85 c0                	test   %eax,%eax
  803093:	75 08                	jne    80309d <insert_sorted_with_merge_freeList+0x703>
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80309d:	a1 44 41 80 00       	mov    0x804144,%eax
  8030a2:	40                   	inc    %eax
  8030a3:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8030a8:	eb 39                	jmp    8030e3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8030af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b6:	74 07                	je     8030bf <insert_sorted_with_merge_freeList+0x725>
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	eb 05                	jmp    8030c4 <insert_sorted_with_merge_freeList+0x72a>
  8030bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c4:	a3 40 41 80 00       	mov    %eax,0x804140
  8030c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	0f 85 c7 fb ff ff    	jne    802c9d <insert_sorted_with_merge_freeList+0x303>
  8030d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030da:	0f 85 bd fb ff ff    	jne    802c9d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e0:	eb 01                	jmp    8030e3 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030e2:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e3:	90                   	nop
  8030e4:	c9                   	leave  
  8030e5:	c3                   	ret    

008030e6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030e6:	55                   	push   %ebp
  8030e7:	89 e5                	mov    %esp,%ebp
  8030e9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ef:	89 d0                	mov    %edx,%eax
  8030f1:	c1 e0 02             	shl    $0x2,%eax
  8030f4:	01 d0                	add    %edx,%eax
  8030f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030fd:	01 d0                	add    %edx,%eax
  8030ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803106:	01 d0                	add    %edx,%eax
  803108:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80310f:	01 d0                	add    %edx,%eax
  803111:	c1 e0 04             	shl    $0x4,%eax
  803114:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803117:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80311e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803121:	83 ec 0c             	sub    $0xc,%esp
  803124:	50                   	push   %eax
  803125:	e8 26 e7 ff ff       	call   801850 <sys_get_virtual_time>
  80312a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80312d:	eb 41                	jmp    803170 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80312f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803132:	83 ec 0c             	sub    $0xc,%esp
  803135:	50                   	push   %eax
  803136:	e8 15 e7 ff ff       	call   801850 <sys_get_virtual_time>
  80313b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80313e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	29 c2                	sub    %eax,%edx
  803146:	89 d0                	mov    %edx,%eax
  803148:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80314b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80314e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803151:	89 d1                	mov    %edx,%ecx
  803153:	29 c1                	sub    %eax,%ecx
  803155:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803158:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315b:	39 c2                	cmp    %eax,%edx
  80315d:	0f 97 c0             	seta   %al
  803160:	0f b6 c0             	movzbl %al,%eax
  803163:	29 c1                	sub    %eax,%ecx
  803165:	89 c8                	mov    %ecx,%eax
  803167:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80316a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80316d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803176:	72 b7                	jb     80312f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803178:	90                   	nop
  803179:	c9                   	leave  
  80317a:	c3                   	ret    

0080317b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80317b:	55                   	push   %ebp
  80317c:	89 e5                	mov    %esp,%ebp
  80317e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803181:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803188:	eb 03                	jmp    80318d <busy_wait+0x12>
  80318a:	ff 45 fc             	incl   -0x4(%ebp)
  80318d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803190:	3b 45 08             	cmp    0x8(%ebp),%eax
  803193:	72 f5                	jb     80318a <busy_wait+0xf>
	return i;
  803195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803198:	c9                   	leave  
  803199:	c3                   	ret    

0080319a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80319a:	55                   	push   %ebp
  80319b:	89 e5                	mov    %esp,%ebp
  80319d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8031a0:	8d 45 10             	lea    0x10(%ebp),%eax
  8031a3:	83 c0 04             	add    $0x4,%eax
  8031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8031a9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	74 16                	je     8031c8 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8031b2:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031b7:	83 ec 08             	sub    $0x8,%esp
  8031ba:	50                   	push   %eax
  8031bb:	68 78 3d 80 00       	push   $0x803d78
  8031c0:	e8 b7 d1 ff ff       	call   80037c <cprintf>
  8031c5:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031c8:	a1 00 40 80 00       	mov    0x804000,%eax
  8031cd:	ff 75 0c             	pushl  0xc(%ebp)
  8031d0:	ff 75 08             	pushl  0x8(%ebp)
  8031d3:	50                   	push   %eax
  8031d4:	68 7d 3d 80 00       	push   $0x803d7d
  8031d9:	e8 9e d1 ff ff       	call   80037c <cprintf>
  8031de:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e4:	83 ec 08             	sub    $0x8,%esp
  8031e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8031ea:	50                   	push   %eax
  8031eb:	e8 21 d1 ff ff       	call   800311 <vcprintf>
  8031f0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031f3:	83 ec 08             	sub    $0x8,%esp
  8031f6:	6a 00                	push   $0x0
  8031f8:	68 99 3d 80 00       	push   $0x803d99
  8031fd:	e8 0f d1 ff ff       	call   800311 <vcprintf>
  803202:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803205:	e8 90 d0 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  80320a:	eb fe                	jmp    80320a <_panic+0x70>

0080320c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80320c:	55                   	push   %ebp
  80320d:	89 e5                	mov    %esp,%ebp
  80320f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803212:	a1 20 40 80 00       	mov    0x804020,%eax
  803217:	8b 50 74             	mov    0x74(%eax),%edx
  80321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321d:	39 c2                	cmp    %eax,%edx
  80321f:	74 14                	je     803235 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 9c 3d 80 00       	push   $0x803d9c
  803229:	6a 26                	push   $0x26
  80322b:	68 e8 3d 80 00       	push   $0x803de8
  803230:	e8 65 ff ff ff       	call   80319a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80323c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803243:	e9 c2 00 00 00       	jmp    80330a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	01 d0                	add    %edx,%eax
  803257:	8b 00                	mov    (%eax),%eax
  803259:	85 c0                	test   %eax,%eax
  80325b:	75 08                	jne    803265 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80325d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803260:	e9 a2 00 00 00       	jmp    803307 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803265:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80326c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803273:	eb 69                	jmp    8032de <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803275:	a1 20 40 80 00       	mov    0x804020,%eax
  80327a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803280:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803283:	89 d0                	mov    %edx,%eax
  803285:	01 c0                	add    %eax,%eax
  803287:	01 d0                	add    %edx,%eax
  803289:	c1 e0 03             	shl    $0x3,%eax
  80328c:	01 c8                	add    %ecx,%eax
  80328e:	8a 40 04             	mov    0x4(%eax),%al
  803291:	84 c0                	test   %al,%al
  803293:	75 46                	jne    8032db <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803295:	a1 20 40 80 00       	mov    0x804020,%eax
  80329a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a3:	89 d0                	mov    %edx,%eax
  8032a5:	01 c0                	add    %eax,%eax
  8032a7:	01 d0                	add    %edx,%eax
  8032a9:	c1 e0 03             	shl    $0x3,%eax
  8032ac:	01 c8                	add    %ecx,%eax
  8032ae:	8b 00                	mov    (%eax),%eax
  8032b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	01 c8                	add    %ecx,%eax
  8032cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032ce:	39 c2                	cmp    %eax,%edx
  8032d0:	75 09                	jne    8032db <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032d9:	eb 12                	jmp    8032ed <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032db:	ff 45 e8             	incl   -0x18(%ebp)
  8032de:	a1 20 40 80 00       	mov    0x804020,%eax
  8032e3:	8b 50 74             	mov    0x74(%eax),%edx
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	39 c2                	cmp    %eax,%edx
  8032eb:	77 88                	ja     803275 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f1:	75 14                	jne    803307 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 f4 3d 80 00       	push   $0x803df4
  8032fb:	6a 3a                	push   $0x3a
  8032fd:	68 e8 3d 80 00       	push   $0x803de8
  803302:	e8 93 fe ff ff       	call   80319a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803307:	ff 45 f0             	incl   -0x10(%ebp)
  80330a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803310:	0f 8c 32 ff ff ff    	jl     803248 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803316:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80331d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803324:	eb 26                	jmp    80334c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803326:	a1 20 40 80 00       	mov    0x804020,%eax
  80332b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803331:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803334:	89 d0                	mov    %edx,%eax
  803336:	01 c0                	add    %eax,%eax
  803338:	01 d0                	add    %edx,%eax
  80333a:	c1 e0 03             	shl    $0x3,%eax
  80333d:	01 c8                	add    %ecx,%eax
  80333f:	8a 40 04             	mov    0x4(%eax),%al
  803342:	3c 01                	cmp    $0x1,%al
  803344:	75 03                	jne    803349 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803346:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803349:	ff 45 e0             	incl   -0x20(%ebp)
  80334c:	a1 20 40 80 00       	mov    0x804020,%eax
  803351:	8b 50 74             	mov    0x74(%eax),%edx
  803354:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803357:	39 c2                	cmp    %eax,%edx
  803359:	77 cb                	ja     803326 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803361:	74 14                	je     803377 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	68 48 3e 80 00       	push   $0x803e48
  80336b:	6a 44                	push   $0x44
  80336d:	68 e8 3d 80 00       	push   $0x803de8
  803372:	e8 23 fe ff ff       	call   80319a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803377:	90                   	nop
  803378:	c9                   	leave  
  803379:	c3                   	ret    
  80337a:	66 90                	xchg   %ax,%ax

0080337c <__udivdi3>:
  80337c:	55                   	push   %ebp
  80337d:	57                   	push   %edi
  80337e:	56                   	push   %esi
  80337f:	53                   	push   %ebx
  803380:	83 ec 1c             	sub    $0x1c,%esp
  803383:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803387:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80338b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80338f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803393:	89 ca                	mov    %ecx,%edx
  803395:	89 f8                	mov    %edi,%eax
  803397:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80339b:	85 f6                	test   %esi,%esi
  80339d:	75 2d                	jne    8033cc <__udivdi3+0x50>
  80339f:	39 cf                	cmp    %ecx,%edi
  8033a1:	77 65                	ja     803408 <__udivdi3+0x8c>
  8033a3:	89 fd                	mov    %edi,%ebp
  8033a5:	85 ff                	test   %edi,%edi
  8033a7:	75 0b                	jne    8033b4 <__udivdi3+0x38>
  8033a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ae:	31 d2                	xor    %edx,%edx
  8033b0:	f7 f7                	div    %edi
  8033b2:	89 c5                	mov    %eax,%ebp
  8033b4:	31 d2                	xor    %edx,%edx
  8033b6:	89 c8                	mov    %ecx,%eax
  8033b8:	f7 f5                	div    %ebp
  8033ba:	89 c1                	mov    %eax,%ecx
  8033bc:	89 d8                	mov    %ebx,%eax
  8033be:	f7 f5                	div    %ebp
  8033c0:	89 cf                	mov    %ecx,%edi
  8033c2:	89 fa                	mov    %edi,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	39 ce                	cmp    %ecx,%esi
  8033ce:	77 28                	ja     8033f8 <__udivdi3+0x7c>
  8033d0:	0f bd fe             	bsr    %esi,%edi
  8033d3:	83 f7 1f             	xor    $0x1f,%edi
  8033d6:	75 40                	jne    803418 <__udivdi3+0x9c>
  8033d8:	39 ce                	cmp    %ecx,%esi
  8033da:	72 0a                	jb     8033e6 <__udivdi3+0x6a>
  8033dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033e0:	0f 87 9e 00 00 00    	ja     803484 <__udivdi3+0x108>
  8033e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033eb:	89 fa                	mov    %edi,%edx
  8033ed:	83 c4 1c             	add    $0x1c,%esp
  8033f0:	5b                   	pop    %ebx
  8033f1:	5e                   	pop    %esi
  8033f2:	5f                   	pop    %edi
  8033f3:	5d                   	pop    %ebp
  8033f4:	c3                   	ret    
  8033f5:	8d 76 00             	lea    0x0(%esi),%esi
  8033f8:	31 ff                	xor    %edi,%edi
  8033fa:	31 c0                	xor    %eax,%eax
  8033fc:	89 fa                	mov    %edi,%edx
  8033fe:	83 c4 1c             	add    $0x1c,%esp
  803401:	5b                   	pop    %ebx
  803402:	5e                   	pop    %esi
  803403:	5f                   	pop    %edi
  803404:	5d                   	pop    %ebp
  803405:	c3                   	ret    
  803406:	66 90                	xchg   %ax,%ax
  803408:	89 d8                	mov    %ebx,%eax
  80340a:	f7 f7                	div    %edi
  80340c:	31 ff                	xor    %edi,%edi
  80340e:	89 fa                	mov    %edi,%edx
  803410:	83 c4 1c             	add    $0x1c,%esp
  803413:	5b                   	pop    %ebx
  803414:	5e                   	pop    %esi
  803415:	5f                   	pop    %edi
  803416:	5d                   	pop    %ebp
  803417:	c3                   	ret    
  803418:	bd 20 00 00 00       	mov    $0x20,%ebp
  80341d:	89 eb                	mov    %ebp,%ebx
  80341f:	29 fb                	sub    %edi,%ebx
  803421:	89 f9                	mov    %edi,%ecx
  803423:	d3 e6                	shl    %cl,%esi
  803425:	89 c5                	mov    %eax,%ebp
  803427:	88 d9                	mov    %bl,%cl
  803429:	d3 ed                	shr    %cl,%ebp
  80342b:	89 e9                	mov    %ebp,%ecx
  80342d:	09 f1                	or     %esi,%ecx
  80342f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803433:	89 f9                	mov    %edi,%ecx
  803435:	d3 e0                	shl    %cl,%eax
  803437:	89 c5                	mov    %eax,%ebp
  803439:	89 d6                	mov    %edx,%esi
  80343b:	88 d9                	mov    %bl,%cl
  80343d:	d3 ee                	shr    %cl,%esi
  80343f:	89 f9                	mov    %edi,%ecx
  803441:	d3 e2                	shl    %cl,%edx
  803443:	8b 44 24 08          	mov    0x8(%esp),%eax
  803447:	88 d9                	mov    %bl,%cl
  803449:	d3 e8                	shr    %cl,%eax
  80344b:	09 c2                	or     %eax,%edx
  80344d:	89 d0                	mov    %edx,%eax
  80344f:	89 f2                	mov    %esi,%edx
  803451:	f7 74 24 0c          	divl   0xc(%esp)
  803455:	89 d6                	mov    %edx,%esi
  803457:	89 c3                	mov    %eax,%ebx
  803459:	f7 e5                	mul    %ebp
  80345b:	39 d6                	cmp    %edx,%esi
  80345d:	72 19                	jb     803478 <__udivdi3+0xfc>
  80345f:	74 0b                	je     80346c <__udivdi3+0xf0>
  803461:	89 d8                	mov    %ebx,%eax
  803463:	31 ff                	xor    %edi,%edi
  803465:	e9 58 ff ff ff       	jmp    8033c2 <__udivdi3+0x46>
  80346a:	66 90                	xchg   %ax,%ax
  80346c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803470:	89 f9                	mov    %edi,%ecx
  803472:	d3 e2                	shl    %cl,%edx
  803474:	39 c2                	cmp    %eax,%edx
  803476:	73 e9                	jae    803461 <__udivdi3+0xe5>
  803478:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80347b:	31 ff                	xor    %edi,%edi
  80347d:	e9 40 ff ff ff       	jmp    8033c2 <__udivdi3+0x46>
  803482:	66 90                	xchg   %ax,%ax
  803484:	31 c0                	xor    %eax,%eax
  803486:	e9 37 ff ff ff       	jmp    8033c2 <__udivdi3+0x46>
  80348b:	90                   	nop

0080348c <__umoddi3>:
  80348c:	55                   	push   %ebp
  80348d:	57                   	push   %edi
  80348e:	56                   	push   %esi
  80348f:	53                   	push   %ebx
  803490:	83 ec 1c             	sub    $0x1c,%esp
  803493:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803497:	8b 74 24 34          	mov    0x34(%esp),%esi
  80349b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80349f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034ab:	89 f3                	mov    %esi,%ebx
  8034ad:	89 fa                	mov    %edi,%edx
  8034af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034b3:	89 34 24             	mov    %esi,(%esp)
  8034b6:	85 c0                	test   %eax,%eax
  8034b8:	75 1a                	jne    8034d4 <__umoddi3+0x48>
  8034ba:	39 f7                	cmp    %esi,%edi
  8034bc:	0f 86 a2 00 00 00    	jbe    803564 <__umoddi3+0xd8>
  8034c2:	89 c8                	mov    %ecx,%eax
  8034c4:	89 f2                	mov    %esi,%edx
  8034c6:	f7 f7                	div    %edi
  8034c8:	89 d0                	mov    %edx,%eax
  8034ca:	31 d2                	xor    %edx,%edx
  8034cc:	83 c4 1c             	add    $0x1c,%esp
  8034cf:	5b                   	pop    %ebx
  8034d0:	5e                   	pop    %esi
  8034d1:	5f                   	pop    %edi
  8034d2:	5d                   	pop    %ebp
  8034d3:	c3                   	ret    
  8034d4:	39 f0                	cmp    %esi,%eax
  8034d6:	0f 87 ac 00 00 00    	ja     803588 <__umoddi3+0xfc>
  8034dc:	0f bd e8             	bsr    %eax,%ebp
  8034df:	83 f5 1f             	xor    $0x1f,%ebp
  8034e2:	0f 84 ac 00 00 00    	je     803594 <__umoddi3+0x108>
  8034e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034ed:	29 ef                	sub    %ebp,%edi
  8034ef:	89 fe                	mov    %edi,%esi
  8034f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034f5:	89 e9                	mov    %ebp,%ecx
  8034f7:	d3 e0                	shl    %cl,%eax
  8034f9:	89 d7                	mov    %edx,%edi
  8034fb:	89 f1                	mov    %esi,%ecx
  8034fd:	d3 ef                	shr    %cl,%edi
  8034ff:	09 c7                	or     %eax,%edi
  803501:	89 e9                	mov    %ebp,%ecx
  803503:	d3 e2                	shl    %cl,%edx
  803505:	89 14 24             	mov    %edx,(%esp)
  803508:	89 d8                	mov    %ebx,%eax
  80350a:	d3 e0                	shl    %cl,%eax
  80350c:	89 c2                	mov    %eax,%edx
  80350e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803512:	d3 e0                	shl    %cl,%eax
  803514:	89 44 24 04          	mov    %eax,0x4(%esp)
  803518:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351c:	89 f1                	mov    %esi,%ecx
  80351e:	d3 e8                	shr    %cl,%eax
  803520:	09 d0                	or     %edx,%eax
  803522:	d3 eb                	shr    %cl,%ebx
  803524:	89 da                	mov    %ebx,%edx
  803526:	f7 f7                	div    %edi
  803528:	89 d3                	mov    %edx,%ebx
  80352a:	f7 24 24             	mull   (%esp)
  80352d:	89 c6                	mov    %eax,%esi
  80352f:	89 d1                	mov    %edx,%ecx
  803531:	39 d3                	cmp    %edx,%ebx
  803533:	0f 82 87 00 00 00    	jb     8035c0 <__umoddi3+0x134>
  803539:	0f 84 91 00 00 00    	je     8035d0 <__umoddi3+0x144>
  80353f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803543:	29 f2                	sub    %esi,%edx
  803545:	19 cb                	sbb    %ecx,%ebx
  803547:	89 d8                	mov    %ebx,%eax
  803549:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80354d:	d3 e0                	shl    %cl,%eax
  80354f:	89 e9                	mov    %ebp,%ecx
  803551:	d3 ea                	shr    %cl,%edx
  803553:	09 d0                	or     %edx,%eax
  803555:	89 e9                	mov    %ebp,%ecx
  803557:	d3 eb                	shr    %cl,%ebx
  803559:	89 da                	mov    %ebx,%edx
  80355b:	83 c4 1c             	add    $0x1c,%esp
  80355e:	5b                   	pop    %ebx
  80355f:	5e                   	pop    %esi
  803560:	5f                   	pop    %edi
  803561:	5d                   	pop    %ebp
  803562:	c3                   	ret    
  803563:	90                   	nop
  803564:	89 fd                	mov    %edi,%ebp
  803566:	85 ff                	test   %edi,%edi
  803568:	75 0b                	jne    803575 <__umoddi3+0xe9>
  80356a:	b8 01 00 00 00       	mov    $0x1,%eax
  80356f:	31 d2                	xor    %edx,%edx
  803571:	f7 f7                	div    %edi
  803573:	89 c5                	mov    %eax,%ebp
  803575:	89 f0                	mov    %esi,%eax
  803577:	31 d2                	xor    %edx,%edx
  803579:	f7 f5                	div    %ebp
  80357b:	89 c8                	mov    %ecx,%eax
  80357d:	f7 f5                	div    %ebp
  80357f:	89 d0                	mov    %edx,%eax
  803581:	e9 44 ff ff ff       	jmp    8034ca <__umoddi3+0x3e>
  803586:	66 90                	xchg   %ax,%ax
  803588:	89 c8                	mov    %ecx,%eax
  80358a:	89 f2                	mov    %esi,%edx
  80358c:	83 c4 1c             	add    $0x1c,%esp
  80358f:	5b                   	pop    %ebx
  803590:	5e                   	pop    %esi
  803591:	5f                   	pop    %edi
  803592:	5d                   	pop    %ebp
  803593:	c3                   	ret    
  803594:	3b 04 24             	cmp    (%esp),%eax
  803597:	72 06                	jb     80359f <__umoddi3+0x113>
  803599:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80359d:	77 0f                	ja     8035ae <__umoddi3+0x122>
  80359f:	89 f2                	mov    %esi,%edx
  8035a1:	29 f9                	sub    %edi,%ecx
  8035a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035a7:	89 14 24             	mov    %edx,(%esp)
  8035aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035b2:	8b 14 24             	mov    (%esp),%edx
  8035b5:	83 c4 1c             	add    $0x1c,%esp
  8035b8:	5b                   	pop    %ebx
  8035b9:	5e                   	pop    %esi
  8035ba:	5f                   	pop    %edi
  8035bb:	5d                   	pop    %ebp
  8035bc:	c3                   	ret    
  8035bd:	8d 76 00             	lea    0x0(%esi),%esi
  8035c0:	2b 04 24             	sub    (%esp),%eax
  8035c3:	19 fa                	sbb    %edi,%edx
  8035c5:	89 d1                	mov    %edx,%ecx
  8035c7:	89 c6                	mov    %eax,%esi
  8035c9:	e9 71 ff ff ff       	jmp    80353f <__umoddi3+0xb3>
  8035ce:	66 90                	xchg   %ax,%ax
  8035d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035d4:	72 ea                	jb     8035c0 <__umoddi3+0x134>
  8035d6:	89 d9                	mov    %ebx,%ecx
  8035d8:	e9 62 ff ff ff       	jmp    80353f <__umoddi3+0xb3>
