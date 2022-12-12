
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
  80003e:	e8 42 18 00 00       	call   801885 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 60 36 80 00       	push   $0x803660
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 92 13 00 00       	call   8013e8 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 36 80 00       	push   $0x803662
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 7c 13 00 00       	call   8013e8 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 36 80 00       	push   $0x803669
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 66 13 00 00       	call   8013e8 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 24 18 00 00       	call   8018b8 <sys_get_virtual_time>
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
  8000b7:	e8 92 30 00 00       	call   80314e <env_sleep>
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
  8000d0:	e8 e3 17 00 00       	call   8018b8 <sys_get_virtual_time>
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
  8000f8:	e8 51 30 00 00       	call   80314e <env_sleep>
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
  80010f:	e8 a4 17 00 00       	call   8018b8 <sys_get_virtual_time>
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
  800137:	e8 12 30 00 00       	call   80314e <env_sleep>
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
  80014c:	68 77 36 80 00       	push   $0x803677
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 eb 15 00 00       	call   801744 <sys_signalSemaphore>
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
  800172:	e8 f5 16 00 00       	call   80186c <sys_getenvindex>
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
  8001dd:	e8 97 14 00 00       	call   801679 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 94 36 80 00       	push   $0x803694
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
  80020d:	68 bc 36 80 00       	push   $0x8036bc
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
  80023e:	68 e4 36 80 00       	push   $0x8036e4
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 3c 37 80 00       	push   $0x80373c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 94 36 80 00       	push   $0x803694
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 17 14 00 00       	call   801693 <sys_enable_interrupt>

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
  80028f:	e8 a4 15 00 00       	call   801838 <sys_destroy_env>
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
  8002a0:	e8 f9 15 00 00       	call   80189e <sys_exit_env>
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
  8002ee:	e8 d8 11 00 00       	call   8014cb <sys_cputs>
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
  800365:	e8 61 11 00 00       	call   8014cb <sys_cputs>
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
  8003af:	e8 c5 12 00 00       	call   801679 <sys_disable_interrupt>
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
  8003cf:	e8 bf 12 00 00       	call   801693 <sys_enable_interrupt>
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
  800419:	e8 c6 2f 00 00       	call   8033e4 <__udivdi3>
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
  800469:	e8 86 30 00 00       	call   8034f4 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 74 39 80 00       	add    $0x803974,%eax
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
  8005c4:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
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
  8006a5:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 85 39 80 00       	push   $0x803985
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
  8006ca:	68 8e 39 80 00       	push   $0x80398e
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
  8006f7:	be 91 39 80 00       	mov    $0x803991,%esi
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
  80111d:	68 f0 3a 80 00       	push   $0x803af0
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
  8011ed:	e8 1d 04 00 00       	call   80160f <sys_allocate_chunk>
  8011f2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	e8 92 0a 00 00       	call   801c95 <initialize_MemBlocksList>
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
  80122b:	68 15 3b 80 00       	push   $0x803b15
  801230:	6a 33                	push   $0x33
  801232:	68 33 3b 80 00       	push   $0x803b33
  801237:	e8 c6 1f 00 00       	call   803202 <_panic>
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
  8012aa:	68 40 3b 80 00       	push   $0x803b40
  8012af:	6a 34                	push   $0x34
  8012b1:	68 33 3b 80 00       	push   $0x803b33
  8012b6:	e8 47 1f 00 00       	call   803202 <_panic>
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
  80131f:	68 64 3b 80 00       	push   $0x803b64
  801324:	6a 46                	push   $0x46
  801326:	68 33 3b 80 00       	push   $0x803b33
  80132b:	e8 d2 1e 00 00       	call   803202 <_panic>
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
  80133b:	68 8c 3b 80 00       	push   $0x803b8c
  801340:	6a 61                	push   $0x61
  801342:	68 33 3b 80 00       	push   $0x803b33
  801347:	e8 b6 1e 00 00       	call   803202 <_panic>

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
  801361:	75 07                	jne    80136a <smalloc+0x1e>
  801363:	b8 00 00 00 00       	mov    $0x0,%eax
  801368:	eb 7c                	jmp    8013e6 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80136a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801371:	8b 55 0c             	mov    0xc(%ebp),%edx
  801374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801377:	01 d0                	add    %edx,%eax
  801379:	48                   	dec    %eax
  80137a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80137d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801380:	ba 00 00 00 00       	mov    $0x0,%edx
  801385:	f7 75 f0             	divl   -0x10(%ebp)
  801388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138b:	29 d0                	sub    %edx,%eax
  80138d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801390:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801397:	e8 41 06 00 00       	call   8019dd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80139c:	85 c0                	test   %eax,%eax
  80139e:	74 11                	je     8013b1 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8013a0:	83 ec 0c             	sub    $0xc,%esp
  8013a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a6:	e8 ac 0c 00 00       	call   802057 <alloc_block_FF>
  8013ab:	83 c4 10             	add    $0x10,%esp
  8013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8013b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013b5:	74 2a                	je     8013e1 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8013b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ba:	8b 40 08             	mov    0x8(%eax),%eax
  8013bd:	89 c2                	mov    %eax,%edx
  8013bf:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8013c3:	52                   	push   %edx
  8013c4:	50                   	push   %eax
  8013c5:	ff 75 0c             	pushl  0xc(%ebp)
  8013c8:	ff 75 08             	pushl  0x8(%ebp)
  8013cb:	e8 92 03 00 00       	call   801762 <sys_createSharedObject>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8013d6:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8013da:	74 05                	je     8013e1 <smalloc+0x95>
			return (void*)virtual_address;
  8013dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013df:	eb 05                	jmp    8013e6 <smalloc+0x9a>
	}
	return NULL;
  8013e1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013ee:	e8 13 fd ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	68 b0 3b 80 00       	push   $0x803bb0
  8013fb:	68 a2 00 00 00       	push   $0xa2
  801400:	68 33 3b 80 00       	push   $0x803b33
  801405:	e8 f8 1d 00 00       	call   803202 <_panic>

0080140a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80140a:	55                   	push   %ebp
  80140b:	89 e5                	mov    %esp,%ebp
  80140d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801410:	e8 f1 fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	68 d4 3b 80 00       	push   $0x803bd4
  80141d:	68 e6 00 00 00       	push   $0xe6
  801422:	68 33 3b 80 00       	push   $0x803b33
  801427:	e8 d6 1d 00 00       	call   803202 <_panic>

0080142c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	68 fc 3b 80 00       	push   $0x803bfc
  80143a:	68 fa 00 00 00       	push   $0xfa
  80143f:	68 33 3b 80 00       	push   $0x803b33
  801444:	e8 b9 1d 00 00       	call   803202 <_panic>

00801449 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	68 20 3c 80 00       	push   $0x803c20
  801457:	68 05 01 00 00       	push   $0x105
  80145c:	68 33 3b 80 00       	push   $0x803b33
  801461:	e8 9c 1d 00 00       	call   803202 <_panic>

00801466 <shrink>:

}
void shrink(uint32 newSize)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	68 20 3c 80 00       	push   $0x803c20
  801474:	68 0a 01 00 00       	push   $0x10a
  801479:	68 33 3b 80 00       	push   $0x803b33
  80147e:	e8 7f 1d 00 00       	call   803202 <_panic>

00801483 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 20 3c 80 00       	push   $0x803c20
  801491:	68 0f 01 00 00       	push   $0x10f
  801496:	68 33 3b 80 00       	push   $0x803b33
  80149b:	e8 62 1d 00 00       	call   803202 <_panic>

008014a0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	57                   	push   %edi
  8014a4:	56                   	push   %esi
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014bb:	cd 30                	int    $0x30
  8014bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	5b                   	pop    %ebx
  8014c7:	5e                   	pop    %esi
  8014c8:	5f                   	pop    %edi
  8014c9:	5d                   	pop    %ebp
  8014ca:	c3                   	ret    

008014cb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	83 ec 04             	sub    $0x4,%esp
  8014d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014d7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	52                   	push   %edx
  8014e3:	ff 75 0c             	pushl  0xc(%ebp)
  8014e6:	50                   	push   %eax
  8014e7:	6a 00                	push   $0x0
  8014e9:	e8 b2 ff ff ff       	call   8014a0 <syscall>
  8014ee:	83 c4 18             	add    $0x18,%esp
}
  8014f1:	90                   	nop
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 01                	push   $0x1
  801503:	e8 98 ff ff ff       	call   8014a0 <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	6a 05                	push   $0x5
  801520:	e8 7b ff ff ff       	call   8014a0 <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	56                   	push   %esi
  80152e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80152f:	8b 75 18             	mov    0x18(%ebp),%esi
  801532:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801535:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	56                   	push   %esi
  80153f:	53                   	push   %ebx
  801540:	51                   	push   %ecx
  801541:	52                   	push   %edx
  801542:	50                   	push   %eax
  801543:	6a 06                	push   $0x6
  801545:	e8 56 ff ff ff       	call   8014a0 <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
}
  80154d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801550:	5b                   	pop    %ebx
  801551:	5e                   	pop    %esi
  801552:	5d                   	pop    %ebp
  801553:	c3                   	ret    

00801554 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 45 08             	mov    0x8(%ebp),%eax
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	52                   	push   %edx
  801564:	50                   	push   %eax
  801565:	6a 07                	push   $0x7
  801567:	e8 34 ff ff ff       	call   8014a0 <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 0c             	pushl  0xc(%ebp)
  80157d:	ff 75 08             	pushl  0x8(%ebp)
  801580:	6a 08                	push   $0x8
  801582:	e8 19 ff ff ff       	call   8014a0 <syscall>
  801587:	83 c4 18             	add    $0x18,%esp
}
  80158a:	c9                   	leave  
  80158b:	c3                   	ret    

0080158c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 09                	push   $0x9
  80159b:	e8 00 ff ff ff       	call   8014a0 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 0a                	push   $0xa
  8015b4:	e8 e7 fe ff ff       	call   8014a0 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 0b                	push   $0xb
  8015cd:	e8 ce fe ff ff       	call   8014a0 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	ff 75 08             	pushl  0x8(%ebp)
  8015e6:	6a 0f                	push   $0xf
  8015e8:	e8 b3 fe ff ff       	call   8014a0 <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
	return;
  8015f0:	90                   	nop
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	ff 75 0c             	pushl  0xc(%ebp)
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	6a 10                	push   $0x10
  801604:	e8 97 fe ff ff       	call   8014a0 <syscall>
  801609:	83 c4 18             	add    $0x18,%esp
	return ;
  80160c:	90                   	nop
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	ff 75 10             	pushl  0x10(%ebp)
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	ff 75 08             	pushl  0x8(%ebp)
  80161f:	6a 11                	push   $0x11
  801621:	e8 7a fe ff ff       	call   8014a0 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return ;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 0c                	push   $0xc
  80163b:	e8 60 fe ff ff       	call   8014a0 <syscall>
  801640:	83 c4 18             	add    $0x18,%esp
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	6a 0d                	push   $0xd
  801655:	e8 46 fe ff ff       	call   8014a0 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 0e                	push   $0xe
  80166e:	e8 2d fe ff ff       	call   8014a0 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 13                	push   $0x13
  801688:	e8 13 fe ff ff       	call   8014a0 <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	90                   	nop
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 14                	push   $0x14
  8016a2:	e8 f9 fd ff ff       	call   8014a0 <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	90                   	nop
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_cputc>:


void
sys_cputc(const char c)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	50                   	push   %eax
  8016c6:	6a 15                	push   $0x15
  8016c8:	e8 d3 fd ff ff       	call   8014a0 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 16                	push   $0x16
  8016e2:	e8 b9 fd ff ff       	call   8014a0 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	50                   	push   %eax
  8016fd:	6a 17                	push   $0x17
  8016ff:	e8 9c fd ff ff       	call   8014a0 <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80170c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	52                   	push   %edx
  801719:	50                   	push   %eax
  80171a:	6a 1a                	push   $0x1a
  80171c:	e8 7f fd ff ff       	call   8014a0 <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	52                   	push   %edx
  801736:	50                   	push   %eax
  801737:	6a 18                	push   $0x18
  801739:	e8 62 fd ff ff       	call   8014a0 <syscall>
  80173e:	83 c4 18             	add    $0x18,%esp
}
  801741:	90                   	nop
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801747:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	52                   	push   %edx
  801754:	50                   	push   %eax
  801755:	6a 19                	push   $0x19
  801757:	e8 44 fd ff ff       	call   8014a0 <syscall>
  80175c:	83 c4 18             	add    $0x18,%esp
}
  80175f:	90                   	nop
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80176e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801771:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801775:	8b 45 08             	mov    0x8(%ebp),%eax
  801778:	6a 00                	push   $0x0
  80177a:	51                   	push   %ecx
  80177b:	52                   	push   %edx
  80177c:	ff 75 0c             	pushl  0xc(%ebp)
  80177f:	50                   	push   %eax
  801780:	6a 1b                	push   $0x1b
  801782:	e8 19 fd ff ff       	call   8014a0 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801792:	8b 45 08             	mov    0x8(%ebp),%eax
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 00                	push   $0x0
  80179b:	52                   	push   %edx
  80179c:	50                   	push   %eax
  80179d:	6a 1c                	push   $0x1c
  80179f:	e8 fc fc ff ff       	call   8014a0 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	51                   	push   %ecx
  8017ba:	52                   	push   %edx
  8017bb:	50                   	push   %eax
  8017bc:	6a 1d                	push   $0x1d
  8017be:	e8 dd fc ff ff       	call   8014a0 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	52                   	push   %edx
  8017d8:	50                   	push   %eax
  8017d9:	6a 1e                	push   $0x1e
  8017db:	e8 c0 fc ff ff       	call   8014a0 <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
}
  8017e3:	c9                   	leave  
  8017e4:	c3                   	ret    

008017e5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017e5:	55                   	push   %ebp
  8017e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 1f                	push   $0x1f
  8017f4:	e8 a7 fc ff ff       	call   8014a0 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	ff 75 14             	pushl  0x14(%ebp)
  801809:	ff 75 10             	pushl  0x10(%ebp)
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	50                   	push   %eax
  801810:	6a 20                	push   $0x20
  801812:	e8 89 fc ff ff       	call   8014a0 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	50                   	push   %eax
  80182b:	6a 21                	push   $0x21
  80182d:	e8 6e fc ff ff       	call   8014a0 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	50                   	push   %eax
  801847:	6a 22                	push   $0x22
  801849:	e8 52 fc ff ff       	call   8014a0 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 02                	push   $0x2
  801862:	e8 39 fc ff ff       	call   8014a0 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 03                	push   $0x3
  80187b:	e8 20 fc ff ff       	call   8014a0 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 04                	push   $0x4
  801894:	e8 07 fc ff ff       	call   8014a0 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_exit_env>:


void sys_exit_env(void)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 23                	push   $0x23
  8018ad:	e8 ee fb ff ff       	call   8014a0 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c1:	8d 50 04             	lea    0x4(%eax),%edx
  8018c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	6a 24                	push   $0x24
  8018d1:	e8 ca fb ff ff       	call   8014a0 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8018d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e2:	89 01                	mov    %eax,(%ecx)
  8018e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	c9                   	leave  
  8018eb:	c2 04 00             	ret    $0x4

008018ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 10             	pushl  0x10(%ebp)
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	6a 12                	push   $0x12
  801900:	e8 9b fb ff ff       	call   8014a0 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
	return ;
  801908:	90                   	nop
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_rcr2>:
uint32 sys_rcr2()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 25                	push   $0x25
  80191a:	e8 81 fb ff ff       	call   8014a0 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801930:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 26                	push   $0x26
  80193f:	e8 5c fb ff ff       	call   8014a0 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <rsttst>:
void rsttst()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 28                	push   $0x28
  801959:	e8 42 fb ff ff       	call   8014a0 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801970:	8b 55 18             	mov    0x18(%ebp),%edx
  801973:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	ff 75 10             	pushl  0x10(%ebp)
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 27                	push   $0x27
  801984:	e8 17 fb ff ff       	call   8014a0 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
	return ;
  80198c:	90                   	nop
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <chktst>:
void chktst(uint32 n)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	6a 29                	push   $0x29
  80199f:	e8 fc fa ff ff       	call   8014a0 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <inctst>:

void inctst()
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 2a                	push   $0x2a
  8019b9:	e8 e2 fa ff ff       	call   8014a0 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c1:	90                   	nop
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <gettst>:
uint32 gettst()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 2b                	push   $0x2b
  8019d3:	e8 c8 fa ff ff       	call   8014a0 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 2c                	push   $0x2c
  8019ef:	e8 ac fa ff ff       	call   8014a0 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
  8019f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019fa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019fe:	75 07                	jne    801a07 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a00:	b8 01 00 00 00       	mov    $0x1,%eax
  801a05:	eb 05                	jmp    801a0c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 2c                	push   $0x2c
  801a20:	e8 7b fa ff ff       	call   8014a0 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
  801a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a2b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a2f:	75 07                	jne    801a38 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a31:	b8 01 00 00 00       	mov    $0x1,%eax
  801a36:	eb 05                	jmp    801a3d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 2c                	push   $0x2c
  801a51:	e8 4a fa ff ff       	call   8014a0 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
  801a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a5c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a60:	75 07                	jne    801a69 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a62:	b8 01 00 00 00       	mov    $0x1,%eax
  801a67:	eb 05                	jmp    801a6e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 2c                	push   $0x2c
  801a82:	e8 19 fa ff ff       	call   8014a0 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
  801a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a8d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a91:	75 07                	jne    801a9a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a93:	b8 01 00 00 00       	mov    $0x1,%eax
  801a98:	eb 05                	jmp    801a9f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 2d                	push   $0x2d
  801ab1:	e8 ea f9 ff ff       	call   8014a0 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab9:	90                   	nop
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ac0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	53                   	push   %ebx
  801acf:	51                   	push   %ecx
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 2e                	push   $0x2e
  801ad4:	e8 c7 f9 ff ff       	call   8014a0 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	52                   	push   %edx
  801af1:	50                   	push   %eax
  801af2:	6a 2f                	push   $0x2f
  801af4:	e8 a7 f9 ff ff       	call   8014a0 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
  801b01:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b04:	83 ec 0c             	sub    $0xc,%esp
  801b07:	68 30 3c 80 00       	push   $0x803c30
  801b0c:	e8 6b e8 ff ff       	call   80037c <cprintf>
  801b11:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b1b:	83 ec 0c             	sub    $0xc,%esp
  801b1e:	68 5c 3c 80 00       	push   $0x803c5c
  801b23:	e8 54 e8 ff ff       	call   80037c <cprintf>
  801b28:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b2b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b2f:	a1 38 41 80 00       	mov    0x804138,%eax
  801b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b37:	eb 56                	jmp    801b8f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b3d:	74 1c                	je     801b5b <print_mem_block_lists+0x5d>
  801b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b42:	8b 50 08             	mov    0x8(%eax),%edx
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b48:	8b 48 08             	mov    0x8(%eax),%ecx
  801b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b51:	01 c8                	add    %ecx,%eax
  801b53:	39 c2                	cmp    %eax,%edx
  801b55:	73 04                	jae    801b5b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801b57:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	8b 50 08             	mov    0x8(%eax),%edx
  801b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b64:	8b 40 0c             	mov    0xc(%eax),%eax
  801b67:	01 c2                	add    %eax,%edx
  801b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6c:	8b 40 08             	mov    0x8(%eax),%eax
  801b6f:	83 ec 04             	sub    $0x4,%esp
  801b72:	52                   	push   %edx
  801b73:	50                   	push   %eax
  801b74:	68 71 3c 80 00       	push   $0x803c71
  801b79:	e8 fe e7 ff ff       	call   80037c <cprintf>
  801b7e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b87:	a1 40 41 80 00       	mov    0x804140,%eax
  801b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b93:	74 07                	je     801b9c <print_mem_block_lists+0x9e>
  801b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b98:	8b 00                	mov    (%eax),%eax
  801b9a:	eb 05                	jmp    801ba1 <print_mem_block_lists+0xa3>
  801b9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba1:	a3 40 41 80 00       	mov    %eax,0x804140
  801ba6:	a1 40 41 80 00       	mov    0x804140,%eax
  801bab:	85 c0                	test   %eax,%eax
  801bad:	75 8a                	jne    801b39 <print_mem_block_lists+0x3b>
  801baf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb3:	75 84                	jne    801b39 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801bb5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801bb9:	75 10                	jne    801bcb <print_mem_block_lists+0xcd>
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	68 80 3c 80 00       	push   $0x803c80
  801bc3:	e8 b4 e7 ff ff       	call   80037c <cprintf>
  801bc8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801bcb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	68 a4 3c 80 00       	push   $0x803ca4
  801bda:	e8 9d e7 ff ff       	call   80037c <cprintf>
  801bdf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801be2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801be6:	a1 40 40 80 00       	mov    0x804040,%eax
  801beb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bee:	eb 56                	jmp    801c46 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801bf0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf4:	74 1c                	je     801c12 <print_mem_block_lists+0x114>
  801bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf9:	8b 50 08             	mov    0x8(%eax),%edx
  801bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bff:	8b 48 08             	mov    0x8(%eax),%ecx
  801c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c05:	8b 40 0c             	mov    0xc(%eax),%eax
  801c08:	01 c8                	add    %ecx,%eax
  801c0a:	39 c2                	cmp    %eax,%edx
  801c0c:	73 04                	jae    801c12 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c0e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	8b 50 08             	mov    0x8(%eax),%edx
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1e:	01 c2                	add    %eax,%edx
  801c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c23:	8b 40 08             	mov    0x8(%eax),%eax
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	52                   	push   %edx
  801c2a:	50                   	push   %eax
  801c2b:	68 71 3c 80 00       	push   $0x803c71
  801c30:	e8 47 e7 ff ff       	call   80037c <cprintf>
  801c35:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c3e:	a1 48 40 80 00       	mov    0x804048,%eax
  801c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c4a:	74 07                	je     801c53 <print_mem_block_lists+0x155>
  801c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	eb 05                	jmp    801c58 <print_mem_block_lists+0x15a>
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	a3 48 40 80 00       	mov    %eax,0x804048
  801c5d:	a1 48 40 80 00       	mov    0x804048,%eax
  801c62:	85 c0                	test   %eax,%eax
  801c64:	75 8a                	jne    801bf0 <print_mem_block_lists+0xf2>
  801c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6a:	75 84                	jne    801bf0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c6c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c70:	75 10                	jne    801c82 <print_mem_block_lists+0x184>
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	68 bc 3c 80 00       	push   $0x803cbc
  801c7a:	e8 fd e6 ff ff       	call   80037c <cprintf>
  801c7f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c82:	83 ec 0c             	sub    $0xc,%esp
  801c85:	68 30 3c 80 00       	push   $0x803c30
  801c8a:	e8 ed e6 ff ff       	call   80037c <cprintf>
  801c8f:	83 c4 10             	add    $0x10,%esp

}
  801c92:	90                   	nop
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801c9b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ca2:	00 00 00 
  801ca5:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801cac:	00 00 00 
  801caf:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801cb6:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801cb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cc0:	e9 9e 00 00 00       	jmp    801d63 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801cc5:	a1 50 40 80 00       	mov    0x804050,%eax
  801cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ccd:	c1 e2 04             	shl    $0x4,%edx
  801cd0:	01 d0                	add    %edx,%eax
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	75 14                	jne    801cea <initialize_MemBlocksList+0x55>
  801cd6:	83 ec 04             	sub    $0x4,%esp
  801cd9:	68 e4 3c 80 00       	push   $0x803ce4
  801cde:	6a 46                	push   $0x46
  801ce0:	68 07 3d 80 00       	push   $0x803d07
  801ce5:	e8 18 15 00 00       	call   803202 <_panic>
  801cea:	a1 50 40 80 00       	mov    0x804050,%eax
  801cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf2:	c1 e2 04             	shl    $0x4,%edx
  801cf5:	01 d0                	add    %edx,%eax
  801cf7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801cfd:	89 10                	mov    %edx,(%eax)
  801cff:	8b 00                	mov    (%eax),%eax
  801d01:	85 c0                	test   %eax,%eax
  801d03:	74 18                	je     801d1d <initialize_MemBlocksList+0x88>
  801d05:	a1 48 41 80 00       	mov    0x804148,%eax
  801d0a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d10:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d13:	c1 e1 04             	shl    $0x4,%ecx
  801d16:	01 ca                	add    %ecx,%edx
  801d18:	89 50 04             	mov    %edx,0x4(%eax)
  801d1b:	eb 12                	jmp    801d2f <initialize_MemBlocksList+0x9a>
  801d1d:	a1 50 40 80 00       	mov    0x804050,%eax
  801d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d25:	c1 e2 04             	shl    $0x4,%edx
  801d28:	01 d0                	add    %edx,%eax
  801d2a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d2f:	a1 50 40 80 00       	mov    0x804050,%eax
  801d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d37:	c1 e2 04             	shl    $0x4,%edx
  801d3a:	01 d0                	add    %edx,%eax
  801d3c:	a3 48 41 80 00       	mov    %eax,0x804148
  801d41:	a1 50 40 80 00       	mov    0x804050,%eax
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	c1 e2 04             	shl    $0x4,%edx
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d55:	a1 54 41 80 00       	mov    0x804154,%eax
  801d5a:	40                   	inc    %eax
  801d5b:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801d60:	ff 45 f4             	incl   -0xc(%ebp)
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d69:	0f 82 56 ff ff ff    	jb     801cc5 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d6f:	90                   	nop
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	8b 00                	mov    (%eax),%eax
  801d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d80:	eb 19                	jmp    801d9b <find_block+0x29>
	{
		if(va==point->sva)
  801d82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d85:	8b 40 08             	mov    0x8(%eax),%eax
  801d88:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d8b:	75 05                	jne    801d92 <find_block+0x20>
		   return point;
  801d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d90:	eb 36                	jmp    801dc8 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8b 40 08             	mov    0x8(%eax),%eax
  801d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d9f:	74 07                	je     801da8 <find_block+0x36>
  801da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da4:	8b 00                	mov    (%eax),%eax
  801da6:	eb 05                	jmp    801dad <find_block+0x3b>
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dad:	8b 55 08             	mov    0x8(%ebp),%edx
  801db0:	89 42 08             	mov    %eax,0x8(%edx)
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	8b 40 08             	mov    0x8(%eax),%eax
  801db9:	85 c0                	test   %eax,%eax
  801dbb:	75 c5                	jne    801d82 <find_block+0x10>
  801dbd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dc1:	75 bf                	jne    801d82 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801dc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc8:	c9                   	leave  
  801dc9:	c3                   	ret    

00801dca <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801dd0:	a1 40 40 80 00       	mov    0x804040,%eax
  801dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801dd8:	a1 44 40 80 00       	mov    0x804044,%eax
  801ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801de6:	74 24                	je     801e0c <insert_sorted_allocList+0x42>
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	8b 50 08             	mov    0x8(%eax),%edx
  801dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df1:	8b 40 08             	mov    0x8(%eax),%eax
  801df4:	39 c2                	cmp    %eax,%edx
  801df6:	76 14                	jbe    801e0c <insert_sorted_allocList+0x42>
  801df8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfb:	8b 50 08             	mov    0x8(%eax),%edx
  801dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e01:	8b 40 08             	mov    0x8(%eax),%eax
  801e04:	39 c2                	cmp    %eax,%edx
  801e06:	0f 82 60 01 00 00    	jb     801f6c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e10:	75 65                	jne    801e77 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e16:	75 14                	jne    801e2c <insert_sorted_allocList+0x62>
  801e18:	83 ec 04             	sub    $0x4,%esp
  801e1b:	68 e4 3c 80 00       	push   $0x803ce4
  801e20:	6a 6b                	push   $0x6b
  801e22:	68 07 3d 80 00       	push   $0x803d07
  801e27:	e8 d6 13 00 00       	call   803202 <_panic>
  801e2c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	89 10                	mov    %edx,(%eax)
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	8b 00                	mov    (%eax),%eax
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	74 0d                	je     801e4d <insert_sorted_allocList+0x83>
  801e40:	a1 40 40 80 00       	mov    0x804040,%eax
  801e45:	8b 55 08             	mov    0x8(%ebp),%edx
  801e48:	89 50 04             	mov    %edx,0x4(%eax)
  801e4b:	eb 08                	jmp    801e55 <insert_sorted_allocList+0x8b>
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	a3 44 40 80 00       	mov    %eax,0x804044
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	a3 40 40 80 00       	mov    %eax,0x804040
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e67:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e6c:	40                   	inc    %eax
  801e6d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e72:	e9 dc 01 00 00       	jmp    802053 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	8b 50 08             	mov    0x8(%eax),%edx
  801e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e80:	8b 40 08             	mov    0x8(%eax),%eax
  801e83:	39 c2                	cmp    %eax,%edx
  801e85:	77 6c                	ja     801ef3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801e87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8b:	74 06                	je     801e93 <insert_sorted_allocList+0xc9>
  801e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e91:	75 14                	jne    801ea7 <insert_sorted_allocList+0xdd>
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	68 20 3d 80 00       	push   $0x803d20
  801e9b:	6a 6f                	push   $0x6f
  801e9d:	68 07 3d 80 00       	push   $0x803d07
  801ea2:	e8 5b 13 00 00       	call   803202 <_panic>
  801ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaa:	8b 50 04             	mov    0x4(%eax),%edx
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	89 50 04             	mov    %edx,0x4(%eax)
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb9:	89 10                	mov    %edx,(%eax)
  801ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebe:	8b 40 04             	mov    0x4(%eax),%eax
  801ec1:	85 c0                	test   %eax,%eax
  801ec3:	74 0d                	je     801ed2 <insert_sorted_allocList+0x108>
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 40 04             	mov    0x4(%eax),%eax
  801ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ece:	89 10                	mov    %edx,(%eax)
  801ed0:	eb 08                	jmp    801eda <insert_sorted_allocList+0x110>
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	a3 40 40 80 00       	mov    %eax,0x804040
  801eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edd:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee0:	89 50 04             	mov    %edx,0x4(%eax)
  801ee3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ee8:	40                   	inc    %eax
  801ee9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801eee:	e9 60 01 00 00       	jmp    802053 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8b 50 08             	mov    0x8(%eax),%edx
  801ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efc:	8b 40 08             	mov    0x8(%eax),%eax
  801eff:	39 c2                	cmp    %eax,%edx
  801f01:	0f 82 4c 01 00 00    	jb     802053 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f0b:	75 14                	jne    801f21 <insert_sorted_allocList+0x157>
  801f0d:	83 ec 04             	sub    $0x4,%esp
  801f10:	68 58 3d 80 00       	push   $0x803d58
  801f15:	6a 73                	push   $0x73
  801f17:	68 07 3d 80 00       	push   $0x803d07
  801f1c:	e8 e1 12 00 00       	call   803202 <_panic>
  801f21:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	89 50 04             	mov    %edx,0x4(%eax)
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	8b 40 04             	mov    0x4(%eax),%eax
  801f33:	85 c0                	test   %eax,%eax
  801f35:	74 0c                	je     801f43 <insert_sorted_allocList+0x179>
  801f37:	a1 44 40 80 00       	mov    0x804044,%eax
  801f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3f:	89 10                	mov    %edx,(%eax)
  801f41:	eb 08                	jmp    801f4b <insert_sorted_allocList+0x181>
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	a3 40 40 80 00       	mov    %eax,0x804040
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	a3 44 40 80 00       	mov    %eax,0x804044
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f5c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f61:	40                   	inc    %eax
  801f62:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f67:	e9 e7 00 00 00       	jmp    802053 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f72:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f79:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f81:	e9 9d 00 00 00       	jmp    802023 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f89:	8b 00                	mov    (%eax),%eax
  801f8b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	8b 50 08             	mov    0x8(%eax),%edx
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 40 08             	mov    0x8(%eax),%eax
  801f9a:	39 c2                	cmp    %eax,%edx
  801f9c:	76 7d                	jbe    80201b <insert_sorted_allocList+0x251>
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	8b 50 08             	mov    0x8(%eax),%edx
  801fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa7:	8b 40 08             	mov    0x8(%eax),%eax
  801faa:	39 c2                	cmp    %eax,%edx
  801fac:	73 6d                	jae    80201b <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb2:	74 06                	je     801fba <insert_sorted_allocList+0x1f0>
  801fb4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb8:	75 14                	jne    801fce <insert_sorted_allocList+0x204>
  801fba:	83 ec 04             	sub    $0x4,%esp
  801fbd:	68 7c 3d 80 00       	push   $0x803d7c
  801fc2:	6a 7f                	push   $0x7f
  801fc4:	68 07 3d 80 00       	push   $0x803d07
  801fc9:	e8 34 12 00 00       	call   803202 <_panic>
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 10                	mov    (%eax),%edx
  801fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd6:	89 10                	mov    %edx,(%eax)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 00                	mov    (%eax),%eax
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	74 0b                	je     801fec <insert_sorted_allocList+0x222>
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe9:	89 50 04             	mov    %edx,0x4(%eax)
  801fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fef:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff2:	89 10                	mov    %edx,(%eax)
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffa:	89 50 04             	mov    %edx,0x4(%eax)
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 00                	mov    (%eax),%eax
  802002:	85 c0                	test   %eax,%eax
  802004:	75 08                	jne    80200e <insert_sorted_allocList+0x244>
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	a3 44 40 80 00       	mov    %eax,0x804044
  80200e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802013:	40                   	inc    %eax
  802014:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802019:	eb 39                	jmp    802054 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80201b:	a1 48 40 80 00       	mov    0x804048,%eax
  802020:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802023:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802027:	74 07                	je     802030 <insert_sorted_allocList+0x266>
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 00                	mov    (%eax),%eax
  80202e:	eb 05                	jmp    802035 <insert_sorted_allocList+0x26b>
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
  802035:	a3 48 40 80 00       	mov    %eax,0x804048
  80203a:	a1 48 40 80 00       	mov    0x804048,%eax
  80203f:	85 c0                	test   %eax,%eax
  802041:	0f 85 3f ff ff ff    	jne    801f86 <insert_sorted_allocList+0x1bc>
  802047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204b:	0f 85 35 ff ff ff    	jne    801f86 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802051:	eb 01                	jmp    802054 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802053:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802054:	90                   	nop
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80205d:	a1 38 41 80 00       	mov    0x804138,%eax
  802062:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802065:	e9 85 01 00 00       	jmp    8021ef <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 0c             	mov    0xc(%eax),%eax
  802070:	3b 45 08             	cmp    0x8(%ebp),%eax
  802073:	0f 82 6e 01 00 00    	jb     8021e7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 40 0c             	mov    0xc(%eax),%eax
  80207f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802082:	0f 85 8a 00 00 00    	jne    802112 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208c:	75 17                	jne    8020a5 <alloc_block_FF+0x4e>
  80208e:	83 ec 04             	sub    $0x4,%esp
  802091:	68 b0 3d 80 00       	push   $0x803db0
  802096:	68 93 00 00 00       	push   $0x93
  80209b:	68 07 3d 80 00       	push   $0x803d07
  8020a0:	e8 5d 11 00 00       	call   803202 <_panic>
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 00                	mov    (%eax),%eax
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	74 10                	je     8020be <alloc_block_FF+0x67>
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b6:	8b 52 04             	mov    0x4(%edx),%edx
  8020b9:	89 50 04             	mov    %edx,0x4(%eax)
  8020bc:	eb 0b                	jmp    8020c9 <alloc_block_FF+0x72>
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 40 04             	mov    0x4(%eax),%eax
  8020c4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 40 04             	mov    0x4(%eax),%eax
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	74 0f                	je     8020e2 <alloc_block_FF+0x8b>
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	8b 40 04             	mov    0x4(%eax),%eax
  8020d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dc:	8b 12                	mov    (%edx),%edx
  8020de:	89 10                	mov    %edx,(%eax)
  8020e0:	eb 0a                	jmp    8020ec <alloc_block_FF+0x95>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	a3 38 41 80 00       	mov    %eax,0x804138
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ff:	a1 44 41 80 00       	mov    0x804144,%eax
  802104:	48                   	dec    %eax
  802105:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	e9 10 01 00 00       	jmp    802222 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	8b 40 0c             	mov    0xc(%eax),%eax
  802118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211b:	0f 86 c6 00 00 00    	jbe    8021e7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802121:	a1 48 41 80 00       	mov    0x804148,%eax
  802126:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	8b 50 08             	mov    0x8(%eax),%edx
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802138:	8b 55 08             	mov    0x8(%ebp),%edx
  80213b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80213e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802142:	75 17                	jne    80215b <alloc_block_FF+0x104>
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	68 b0 3d 80 00       	push   $0x803db0
  80214c:	68 9b 00 00 00       	push   $0x9b
  802151:	68 07 3d 80 00       	push   $0x803d07
  802156:	e8 a7 10 00 00       	call   803202 <_panic>
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	85 c0                	test   %eax,%eax
  802162:	74 10                	je     802174 <alloc_block_FF+0x11d>
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 00                	mov    (%eax),%eax
  802169:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80216c:	8b 52 04             	mov    0x4(%edx),%edx
  80216f:	89 50 04             	mov    %edx,0x4(%eax)
  802172:	eb 0b                	jmp    80217f <alloc_block_FF+0x128>
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	8b 40 04             	mov    0x4(%eax),%eax
  80217a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	85 c0                	test   %eax,%eax
  802187:	74 0f                	je     802198 <alloc_block_FF+0x141>
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 40 04             	mov    0x4(%eax),%eax
  80218f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802192:	8b 12                	mov    (%edx),%edx
  802194:	89 10                	mov    %edx,(%eax)
  802196:	eb 0a                	jmp    8021a2 <alloc_block_FF+0x14b>
  802198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	a3 48 41 80 00       	mov    %eax,0x804148
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b5:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ba:	48                   	dec    %eax
  8021bb:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 50 08             	mov    0x8(%eax),%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	01 c2                	add    %eax,%edx
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8021da:	89 c2                	mov    %eax,%edx
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8021e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e5:	eb 3b                	jmp    802222 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8021ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f3:	74 07                	je     8021fc <alloc_block_FF+0x1a5>
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	8b 00                	mov    (%eax),%eax
  8021fa:	eb 05                	jmp    802201 <alloc_block_FF+0x1aa>
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	a3 40 41 80 00       	mov    %eax,0x804140
  802206:	a1 40 41 80 00       	mov    0x804140,%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	0f 85 57 fe ff ff    	jne    80206a <alloc_block_FF+0x13>
  802213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802217:	0f 85 4d fe ff ff    	jne    80206a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80221d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80222a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802231:	a1 38 41 80 00       	mov    0x804138,%eax
  802236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802239:	e9 df 00 00 00       	jmp    80231d <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 40 0c             	mov    0xc(%eax),%eax
  802244:	3b 45 08             	cmp    0x8(%ebp),%eax
  802247:	0f 82 c8 00 00 00    	jb     802315 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 0c             	mov    0xc(%eax),%eax
  802253:	3b 45 08             	cmp    0x8(%ebp),%eax
  802256:	0f 85 8a 00 00 00    	jne    8022e6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80225c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802260:	75 17                	jne    802279 <alloc_block_BF+0x55>
  802262:	83 ec 04             	sub    $0x4,%esp
  802265:	68 b0 3d 80 00       	push   $0x803db0
  80226a:	68 b7 00 00 00       	push   $0xb7
  80226f:	68 07 3d 80 00       	push   $0x803d07
  802274:	e8 89 0f 00 00       	call   803202 <_panic>
  802279:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227c:	8b 00                	mov    (%eax),%eax
  80227e:	85 c0                	test   %eax,%eax
  802280:	74 10                	je     802292 <alloc_block_BF+0x6e>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228a:	8b 52 04             	mov    0x4(%edx),%edx
  80228d:	89 50 04             	mov    %edx,0x4(%eax)
  802290:	eb 0b                	jmp    80229d <alloc_block_BF+0x79>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 40 04             	mov    0x4(%eax),%eax
  802298:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	8b 40 04             	mov    0x4(%eax),%eax
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	74 0f                	je     8022b6 <alloc_block_BF+0x92>
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 40 04             	mov    0x4(%eax),%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	8b 12                	mov    (%edx),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
  8022b4:	eb 0a                	jmp    8022c0 <alloc_block_BF+0x9c>
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8022d8:	48                   	dec    %eax
  8022d9:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	e9 4d 01 00 00       	jmp    802433 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ef:	76 24                	jbe    802315 <alloc_block_BF+0xf1>
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022fa:	73 19                	jae    802315 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8022fc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 0c             	mov    0xc(%eax),%eax
  802309:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 08             	mov    0x8(%eax),%eax
  802312:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802315:	a1 40 41 80 00       	mov    0x804140,%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802321:	74 07                	je     80232a <alloc_block_BF+0x106>
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	eb 05                	jmp    80232f <alloc_block_BF+0x10b>
  80232a:	b8 00 00 00 00       	mov    $0x0,%eax
  80232f:	a3 40 41 80 00       	mov    %eax,0x804140
  802334:	a1 40 41 80 00       	mov    0x804140,%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	0f 85 fd fe ff ff    	jne    80223e <alloc_block_BF+0x1a>
  802341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802345:	0f 85 f3 fe ff ff    	jne    80223e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80234b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80234f:	0f 84 d9 00 00 00    	je     80242e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802355:	a1 48 41 80 00       	mov    0x804148,%eax
  80235a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80235d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802360:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802363:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802369:	8b 55 08             	mov    0x8(%ebp),%edx
  80236c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80236f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802373:	75 17                	jne    80238c <alloc_block_BF+0x168>
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	68 b0 3d 80 00       	push   $0x803db0
  80237d:	68 c7 00 00 00       	push   $0xc7
  802382:	68 07 3d 80 00       	push   $0x803d07
  802387:	e8 76 0e 00 00       	call   803202 <_panic>
  80238c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	74 10                	je     8023a5 <alloc_block_BF+0x181>
  802395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80239d:	8b 52 04             	mov    0x4(%edx),%edx
  8023a0:	89 50 04             	mov    %edx,0x4(%eax)
  8023a3:	eb 0b                	jmp    8023b0 <alloc_block_BF+0x18c>
  8023a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a8:	8b 40 04             	mov    0x4(%eax),%eax
  8023ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 0f                	je     8023c9 <alloc_block_BF+0x1a5>
  8023ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bd:	8b 40 04             	mov    0x4(%eax),%eax
  8023c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c3:	8b 12                	mov    (%edx),%edx
  8023c5:	89 10                	mov    %edx,(%eax)
  8023c7:	eb 0a                	jmp    8023d3 <alloc_block_BF+0x1af>
  8023c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8023d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e6:	a1 54 41 80 00       	mov    0x804154,%eax
  8023eb:	48                   	dec    %eax
  8023ec:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8023f1:	83 ec 08             	sub    $0x8,%esp
  8023f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8023f7:	68 38 41 80 00       	push   $0x804138
  8023fc:	e8 71 f9 ff ff       	call   801d72 <find_block>
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802407:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80240a:	8b 50 08             	mov    0x8(%eax),%edx
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	01 c2                	add    %eax,%edx
  802412:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802415:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241b:	8b 40 0c             	mov    0xc(%eax),%eax
  80241e:	2b 45 08             	sub    0x8(%ebp),%eax
  802421:	89 c2                	mov    %eax,%edx
  802423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802426:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242c:	eb 05                	jmp    802433 <alloc_block_BF+0x20f>
	}
	return NULL;
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80243b:	a1 28 40 80 00       	mov    0x804028,%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	0f 85 de 01 00 00    	jne    802626 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802448:	a1 38 41 80 00       	mov    0x804138,%eax
  80244d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802450:	e9 9e 01 00 00       	jmp    8025f3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245e:	0f 82 87 01 00 00    	jb     8025eb <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 0c             	mov    0xc(%eax),%eax
  80246a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246d:	0f 85 95 00 00 00    	jne    802508 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802477:	75 17                	jne    802490 <alloc_block_NF+0x5b>
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	68 b0 3d 80 00       	push   $0x803db0
  802481:	68 e0 00 00 00       	push   $0xe0
  802486:	68 07 3d 80 00       	push   $0x803d07
  80248b:	e8 72 0d 00 00       	call   803202 <_panic>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 10                	je     8024a9 <alloc_block_NF+0x74>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	8b 52 04             	mov    0x4(%edx),%edx
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	eb 0b                	jmp    8024b4 <alloc_block_NF+0x7f>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 04             	mov    0x4(%eax),%eax
  8024af:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 0f                	je     8024cd <alloc_block_NF+0x98>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c7:	8b 12                	mov    (%edx),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	eb 0a                	jmp    8024d7 <alloc_block_NF+0xa2>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	a3 38 41 80 00       	mov    %eax,0x804138
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ef:	48                   	dec    %eax
  8024f0:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 08             	mov    0x8(%eax),%eax
  8024fb:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	e9 f8 04 00 00       	jmp    802a00 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 40 0c             	mov    0xc(%eax),%eax
  80250e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802511:	0f 86 d4 00 00 00    	jbe    8025eb <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802517:	a1 48 41 80 00       	mov    0x804148,%eax
  80251c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 50 08             	mov    0x8(%eax),%edx
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80252b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252e:	8b 55 08             	mov    0x8(%ebp),%edx
  802531:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802534:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802538:	75 17                	jne    802551 <alloc_block_NF+0x11c>
  80253a:	83 ec 04             	sub    $0x4,%esp
  80253d:	68 b0 3d 80 00       	push   $0x803db0
  802542:	68 e9 00 00 00       	push   $0xe9
  802547:	68 07 3d 80 00       	push   $0x803d07
  80254c:	e8 b1 0c 00 00       	call   803202 <_panic>
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	85 c0                	test   %eax,%eax
  802558:	74 10                	je     80256a <alloc_block_NF+0x135>
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802562:	8b 52 04             	mov    0x4(%edx),%edx
  802565:	89 50 04             	mov    %edx,0x4(%eax)
  802568:	eb 0b                	jmp    802575 <alloc_block_NF+0x140>
  80256a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802578:	8b 40 04             	mov    0x4(%eax),%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	74 0f                	je     80258e <alloc_block_NF+0x159>
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	8b 40 04             	mov    0x4(%eax),%eax
  802585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802588:	8b 12                	mov    (%edx),%edx
  80258a:	89 10                	mov    %edx,(%eax)
  80258c:	eb 0a                	jmp    802598 <alloc_block_NF+0x163>
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	a3 48 41 80 00       	mov    %eax,0x804148
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8025b0:	48                   	dec    %eax
  8025b1:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 40 08             	mov    0x8(%eax),%eax
  8025bc:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 50 08             	mov    0x8(%eax),%edx
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	01 c2                	add    %eax,%edx
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8025db:	89 c2                	mov    %eax,%edx
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8025e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e6:	e9 15 04 00 00       	jmp    802a00 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f7:	74 07                	je     802600 <alloc_block_NF+0x1cb>
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	eb 05                	jmp    802605 <alloc_block_NF+0x1d0>
  802600:	b8 00 00 00 00       	mov    $0x0,%eax
  802605:	a3 40 41 80 00       	mov    %eax,0x804140
  80260a:	a1 40 41 80 00       	mov    0x804140,%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	0f 85 3e fe ff ff    	jne    802455 <alloc_block_NF+0x20>
  802617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261b:	0f 85 34 fe ff ff    	jne    802455 <alloc_block_NF+0x20>
  802621:	e9 d5 03 00 00       	jmp    8029fb <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802626:	a1 38 41 80 00       	mov    0x804138,%eax
  80262b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262e:	e9 b1 01 00 00       	jmp    8027e4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 50 08             	mov    0x8(%eax),%edx
  802639:	a1 28 40 80 00       	mov    0x804028,%eax
  80263e:	39 c2                	cmp    %eax,%edx
  802640:	0f 82 96 01 00 00    	jb     8027dc <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264f:	0f 82 87 01 00 00    	jb     8027dc <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 40 0c             	mov    0xc(%eax),%eax
  80265b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265e:	0f 85 95 00 00 00    	jne    8026f9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802668:	75 17                	jne    802681 <alloc_block_NF+0x24c>
  80266a:	83 ec 04             	sub    $0x4,%esp
  80266d:	68 b0 3d 80 00       	push   $0x803db0
  802672:	68 fc 00 00 00       	push   $0xfc
  802677:	68 07 3d 80 00       	push   $0x803d07
  80267c:	e8 81 0b 00 00       	call   803202 <_panic>
  802681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	74 10                	je     80269a <alloc_block_NF+0x265>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802692:	8b 52 04             	mov    0x4(%edx),%edx
  802695:	89 50 04             	mov    %edx,0x4(%eax)
  802698:	eb 0b                	jmp    8026a5 <alloc_block_NF+0x270>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 0f                	je     8026be <alloc_block_NF+0x289>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b8:	8b 12                	mov    (%edx),%edx
  8026ba:	89 10                	mov    %edx,(%eax)
  8026bc:	eb 0a                	jmp    8026c8 <alloc_block_NF+0x293>
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026db:	a1 44 41 80 00       	mov    0x804144,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 40 08             	mov    0x8(%eax),%eax
  8026ec:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	e9 07 03 00 00       	jmp    802a00 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802702:	0f 86 d4 00 00 00    	jbe    8027dc <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802708:	a1 48 41 80 00       	mov    0x804148,%eax
  80270d:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 50 08             	mov    0x8(%eax),%edx
  802716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802719:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80271c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271f:	8b 55 08             	mov    0x8(%ebp),%edx
  802722:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802725:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802729:	75 17                	jne    802742 <alloc_block_NF+0x30d>
  80272b:	83 ec 04             	sub    $0x4,%esp
  80272e:	68 b0 3d 80 00       	push   $0x803db0
  802733:	68 04 01 00 00       	push   $0x104
  802738:	68 07 3d 80 00       	push   $0x803d07
  80273d:	e8 c0 0a 00 00       	call   803202 <_panic>
  802742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	85 c0                	test   %eax,%eax
  802749:	74 10                	je     80275b <alloc_block_NF+0x326>
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802753:	8b 52 04             	mov    0x4(%edx),%edx
  802756:	89 50 04             	mov    %edx,0x4(%eax)
  802759:	eb 0b                	jmp    802766 <alloc_block_NF+0x331>
  80275b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275e:	8b 40 04             	mov    0x4(%eax),%eax
  802761:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 0f                	je     80277f <alloc_block_NF+0x34a>
  802770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802779:	8b 12                	mov    (%edx),%edx
  80277b:	89 10                	mov    %edx,(%eax)
  80277d:	eb 0a                	jmp    802789 <alloc_block_NF+0x354>
  80277f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	a3 48 41 80 00       	mov    %eax,0x804148
  802789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802792:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279c:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a1:	48                   	dec    %eax
  8027a2:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8027a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027aa:	8b 40 08             	mov    0x8(%eax),%eax
  8027ad:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 50 08             	mov    0x8(%eax),%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	01 c2                	add    %eax,%edx
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cc:	89 c2                	mov    %eax,%edx
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8027d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d7:	e9 24 02 00 00       	jmp    802a00 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e8:	74 07                	je     8027f1 <alloc_block_NF+0x3bc>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	eb 05                	jmp    8027f6 <alloc_block_NF+0x3c1>
  8027f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f6:	a3 40 41 80 00       	mov    %eax,0x804140
  8027fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	0f 85 2b fe ff ff    	jne    802633 <alloc_block_NF+0x1fe>
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	0f 85 21 fe ff ff    	jne    802633 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802812:	a1 38 41 80 00       	mov    0x804138,%eax
  802817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80281a:	e9 ae 01 00 00       	jmp    8029cd <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 50 08             	mov    0x8(%eax),%edx
  802825:	a1 28 40 80 00       	mov    0x804028,%eax
  80282a:	39 c2                	cmp    %eax,%edx
  80282c:	0f 83 93 01 00 00    	jae    8029c5 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283b:	0f 82 84 01 00 00    	jb     8029c5 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 40 0c             	mov    0xc(%eax),%eax
  802847:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284a:	0f 85 95 00 00 00    	jne    8028e5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802854:	75 17                	jne    80286d <alloc_block_NF+0x438>
  802856:	83 ec 04             	sub    $0x4,%esp
  802859:	68 b0 3d 80 00       	push   $0x803db0
  80285e:	68 14 01 00 00       	push   $0x114
  802863:	68 07 3d 80 00       	push   $0x803d07
  802868:	e8 95 09 00 00       	call   803202 <_panic>
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 10                	je     802886 <alloc_block_NF+0x451>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287e:	8b 52 04             	mov    0x4(%edx),%edx
  802881:	89 50 04             	mov    %edx,0x4(%eax)
  802884:	eb 0b                	jmp    802891 <alloc_block_NF+0x45c>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 04             	mov    0x4(%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 0f                	je     8028aa <alloc_block_NF+0x475>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 04             	mov    0x4(%eax),%eax
  8028a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a4:	8b 12                	mov    (%edx),%edx
  8028a6:	89 10                	mov    %edx,(%eax)
  8028a8:	eb 0a                	jmp    8028b4 <alloc_block_NF+0x47f>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	a3 38 41 80 00       	mov    %eax,0x804138
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028cc:	48                   	dec    %eax
  8028cd:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 08             	mov    0x8(%eax),%eax
  8028d8:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	e9 1b 01 00 00       	jmp    802a00 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ee:	0f 86 d1 00 00 00    	jbe    8029c5 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f4:	a1 48 41 80 00       	mov    0x804148,%eax
  8028f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 50 08             	mov    0x8(%eax),%edx
  802902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802905:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802911:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802915:	75 17                	jne    80292e <alloc_block_NF+0x4f9>
  802917:	83 ec 04             	sub    $0x4,%esp
  80291a:	68 b0 3d 80 00       	push   $0x803db0
  80291f:	68 1c 01 00 00       	push   $0x11c
  802924:	68 07 3d 80 00       	push   $0x803d07
  802929:	e8 d4 08 00 00       	call   803202 <_panic>
  80292e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802931:	8b 00                	mov    (%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 10                	je     802947 <alloc_block_NF+0x512>
  802937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80293f:	8b 52 04             	mov    0x4(%edx),%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	eb 0b                	jmp    802952 <alloc_block_NF+0x51d>
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 40 04             	mov    0x4(%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 0f                	je     80296b <alloc_block_NF+0x536>
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802965:	8b 12                	mov    (%edx),%edx
  802967:	89 10                	mov    %edx,(%eax)
  802969:	eb 0a                	jmp    802975 <alloc_block_NF+0x540>
  80296b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296e:	8b 00                	mov    (%eax),%eax
  802970:	a3 48 41 80 00       	mov    %eax,0x804148
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802981:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802988:	a1 54 41 80 00       	mov    0x804154,%eax
  80298d:	48                   	dec    %eax
  80298e:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802996:	8b 40 08             	mov    0x8(%eax),%eax
  802999:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 50 08             	mov    0x8(%eax),%edx
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	01 c2                	add    %eax,%edx
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b8:	89 c2                	mov    %eax,%edx
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c3:	eb 3b                	jmp    802a00 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d1:	74 07                	je     8029da <alloc_block_NF+0x5a5>
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	eb 05                	jmp    8029df <alloc_block_NF+0x5aa>
  8029da:	b8 00 00 00 00       	mov    $0x0,%eax
  8029df:	a3 40 41 80 00       	mov    %eax,0x804140
  8029e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	0f 85 2e fe ff ff    	jne    80281f <alloc_block_NF+0x3ea>
  8029f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f5:	0f 85 24 fe ff ff    	jne    80281f <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a00:	c9                   	leave  
  802a01:	c3                   	ret    

00802a02 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a02:	55                   	push   %ebp
  802a03:	89 e5                	mov    %esp,%ebp
  802a05:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a08:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a10:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a15:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a18:	a1 38 41 80 00       	mov    0x804138,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	74 14                	je     802a35 <insert_sorted_with_merge_freeList+0x33>
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 50 08             	mov    0x8(%eax),%edx
  802a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	39 c2                	cmp    %eax,%edx
  802a2f:	0f 87 9b 01 00 00    	ja     802bd0 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a39:	75 17                	jne    802a52 <insert_sorted_with_merge_freeList+0x50>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 e4 3c 80 00       	push   $0x803ce4
  802a43:	68 38 01 00 00       	push   $0x138
  802a48:	68 07 3d 80 00       	push   $0x803d07
  802a4d:	e8 b0 07 00 00       	call   803202 <_panic>
  802a52:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	89 10                	mov    %edx,(%eax)
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 0d                	je     802a73 <insert_sorted_with_merge_freeList+0x71>
  802a66:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	eb 08                	jmp    802a7b <insert_sorted_with_merge_freeList+0x79>
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a92:	40                   	inc    %eax
  802a93:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802a98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9c:	0f 84 a8 06 00 00    	je     80314a <insert_sorted_with_merge_freeList+0x748>
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	8b 40 0c             	mov    0xc(%eax),%eax
  802aae:	01 c2                	add    %eax,%edx
  802ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab3:	8b 40 08             	mov    0x8(%eax),%eax
  802ab6:	39 c2                	cmp    %eax,%edx
  802ab8:	0f 85 8c 06 00 00    	jne    80314a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aca:	01 c2                	add    %eax,%edx
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ad2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad6:	75 17                	jne    802aef <insert_sorted_with_merge_freeList+0xed>
  802ad8:	83 ec 04             	sub    $0x4,%esp
  802adb:	68 b0 3d 80 00       	push   $0x803db0
  802ae0:	68 3c 01 00 00       	push   $0x13c
  802ae5:	68 07 3d 80 00       	push   $0x803d07
  802aea:	e8 13 07 00 00       	call   803202 <_panic>
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	74 10                	je     802b08 <insert_sorted_with_merge_freeList+0x106>
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b00:	8b 52 04             	mov    0x4(%edx),%edx
  802b03:	89 50 04             	mov    %edx,0x4(%eax)
  802b06:	eb 0b                	jmp    802b13 <insert_sorted_with_merge_freeList+0x111>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b16:	8b 40 04             	mov    0x4(%eax),%eax
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	74 0f                	je     802b2c <insert_sorted_with_merge_freeList+0x12a>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 40 04             	mov    0x4(%eax),%eax
  802b23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b26:	8b 12                	mov    (%edx),%edx
  802b28:	89 10                	mov    %edx,(%eax)
  802b2a:	eb 0a                	jmp    802b36 <insert_sorted_with_merge_freeList+0x134>
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	a3 38 41 80 00       	mov    %eax,0x804138
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b49:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4e:	48                   	dec    %eax
  802b4f:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b6c:	75 17                	jne    802b85 <insert_sorted_with_merge_freeList+0x183>
  802b6e:	83 ec 04             	sub    $0x4,%esp
  802b71:	68 e4 3c 80 00       	push   $0x803ce4
  802b76:	68 3f 01 00 00       	push   $0x13f
  802b7b:	68 07 3d 80 00       	push   $0x803d07
  802b80:	e8 7d 06 00 00       	call   803202 <_panic>
  802b85:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	89 10                	mov    %edx,(%eax)
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0d                	je     802ba6 <insert_sorted_with_merge_freeList+0x1a4>
  802b99:	a1 48 41 80 00       	mov    0x804148,%eax
  802b9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba1:	89 50 04             	mov    %edx,0x4(%eax)
  802ba4:	eb 08                	jmp    802bae <insert_sorted_with_merge_freeList+0x1ac>
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb1:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc0:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc5:	40                   	inc    %eax
  802bc6:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bcb:	e9 7a 05 00 00       	jmp    80314a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 50 08             	mov    0x8(%eax),%edx
  802bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd9:	8b 40 08             	mov    0x8(%eax),%eax
  802bdc:	39 c2                	cmp    %eax,%edx
  802bde:	0f 82 14 01 00 00    	jb     802cf8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 50 08             	mov    0x8(%eax),%edx
  802bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bed:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf0:	01 c2                	add    %eax,%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 40 08             	mov    0x8(%eax),%eax
  802bf8:	39 c2                	cmp    %eax,%edx
  802bfa:	0f 85 90 00 00 00    	jne    802c90 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c03:	8b 50 0c             	mov    0xc(%eax),%edx
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0c:	01 c2                	add    %eax,%edx
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2c:	75 17                	jne    802c45 <insert_sorted_with_merge_freeList+0x243>
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 e4 3c 80 00       	push   $0x803ce4
  802c36:	68 49 01 00 00       	push   $0x149
  802c3b:	68 07 3d 80 00       	push   $0x803d07
  802c40:	e8 bd 05 00 00       	call   803202 <_panic>
  802c45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 0d                	je     802c66 <insert_sorted_with_merge_freeList+0x264>
  802c59:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c61:	89 50 04             	mov    %edx,0x4(%eax)
  802c64:	eb 08                	jmp    802c6e <insert_sorted_with_merge_freeList+0x26c>
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 48 41 80 00       	mov    %eax,0x804148
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c80:	a1 54 41 80 00       	mov    0x804154,%eax
  802c85:	40                   	inc    %eax
  802c86:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c8b:	e9 bb 04 00 00       	jmp    80314b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c94:	75 17                	jne    802cad <insert_sorted_with_merge_freeList+0x2ab>
  802c96:	83 ec 04             	sub    $0x4,%esp
  802c99:	68 58 3d 80 00       	push   $0x803d58
  802c9e:	68 4c 01 00 00       	push   $0x14c
  802ca3:	68 07 3d 80 00       	push   $0x803d07
  802ca8:	e8 55 05 00 00       	call   803202 <_panic>
  802cad:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	89 50 04             	mov    %edx,0x4(%eax)
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 40 04             	mov    0x4(%eax),%eax
  802cbf:	85 c0                	test   %eax,%eax
  802cc1:	74 0c                	je     802ccf <insert_sorted_with_merge_freeList+0x2cd>
  802cc3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccb:	89 10                	mov    %edx,(%eax)
  802ccd:	eb 08                	jmp    802cd7 <insert_sorted_with_merge_freeList+0x2d5>
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	a3 38 41 80 00       	mov    %eax,0x804138
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ced:	40                   	inc    %eax
  802cee:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cf3:	e9 53 04 00 00       	jmp    80314b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802cf8:	a1 38 41 80 00       	mov    0x804138,%eax
  802cfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d00:	e9 15 04 00 00       	jmp    80311a <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	8b 50 08             	mov    0x8(%eax),%edx
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 40 08             	mov    0x8(%eax),%eax
  802d19:	39 c2                	cmp    %eax,%edx
  802d1b:	0f 86 f1 03 00 00    	jbe    803112 <insert_sorted_with_merge_freeList+0x710>
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 50 08             	mov    0x8(%eax),%edx
  802d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2a:	8b 40 08             	mov    0x8(%eax),%eax
  802d2d:	39 c2                	cmp    %eax,%edx
  802d2f:	0f 83 dd 03 00 00    	jae    803112 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 50 08             	mov    0x8(%eax),%edx
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	01 c2                	add    %eax,%edx
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	8b 40 08             	mov    0x8(%eax),%eax
  802d49:	39 c2                	cmp    %eax,%edx
  802d4b:	0f 85 b9 01 00 00    	jne    802f0a <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 50 08             	mov    0x8(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5d:	01 c2                	add    %eax,%edx
  802d5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d62:	8b 40 08             	mov    0x8(%eax),%eax
  802d65:	39 c2                	cmp    %eax,%edx
  802d67:	0f 85 0d 01 00 00    	jne    802e7a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 50 0c             	mov    0xc(%eax),%edx
  802d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d76:	8b 40 0c             	mov    0xc(%eax),%eax
  802d79:	01 c2                	add    %eax,%edx
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d85:	75 17                	jne    802d9e <insert_sorted_with_merge_freeList+0x39c>
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	68 b0 3d 80 00       	push   $0x803db0
  802d8f:	68 5c 01 00 00       	push   $0x15c
  802d94:	68 07 3d 80 00       	push   $0x803d07
  802d99:	e8 64 04 00 00       	call   803202 <_panic>
  802d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 10                	je     802db7 <insert_sorted_with_merge_freeList+0x3b5>
  802da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802daf:	8b 52 04             	mov    0x4(%edx),%edx
  802db2:	89 50 04             	mov    %edx,0x4(%eax)
  802db5:	eb 0b                	jmp    802dc2 <insert_sorted_with_merge_freeList+0x3c0>
  802db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dba:	8b 40 04             	mov    0x4(%eax),%eax
  802dbd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 0f                	je     802ddb <insert_sorted_with_merge_freeList+0x3d9>
  802dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcf:	8b 40 04             	mov    0x4(%eax),%eax
  802dd2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd5:	8b 12                	mov    (%edx),%edx
  802dd7:	89 10                	mov    %edx,(%eax)
  802dd9:	eb 0a                	jmp    802de5 <insert_sorted_with_merge_freeList+0x3e3>
  802ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	a3 38 41 80 00       	mov    %eax,0x804138
  802de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df8:	a1 44 41 80 00       	mov    0x804144,%eax
  802dfd:	48                   	dec    %eax
  802dfe:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e1b:	75 17                	jne    802e34 <insert_sorted_with_merge_freeList+0x432>
  802e1d:	83 ec 04             	sub    $0x4,%esp
  802e20:	68 e4 3c 80 00       	push   $0x803ce4
  802e25:	68 5f 01 00 00       	push   $0x15f
  802e2a:	68 07 3d 80 00       	push   $0x803d07
  802e2f:	e8 ce 03 00 00       	call   803202 <_panic>
  802e34:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	89 10                	mov    %edx,(%eax)
  802e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e42:	8b 00                	mov    (%eax),%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	74 0d                	je     802e55 <insert_sorted_with_merge_freeList+0x453>
  802e48:	a1 48 41 80 00       	mov    0x804148,%eax
  802e4d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e50:	89 50 04             	mov    %edx,0x4(%eax)
  802e53:	eb 08                	jmp    802e5d <insert_sorted_with_merge_freeList+0x45b>
  802e55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e58:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e60:	a3 48 41 80 00       	mov    %eax,0x804148
  802e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e74:	40                   	inc    %eax
  802e75:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	01 c2                	add    %eax,%edx
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea6:	75 17                	jne    802ebf <insert_sorted_with_merge_freeList+0x4bd>
  802ea8:	83 ec 04             	sub    $0x4,%esp
  802eab:	68 e4 3c 80 00       	push   $0x803ce4
  802eb0:	68 64 01 00 00       	push   $0x164
  802eb5:	68 07 3d 80 00       	push   $0x803d07
  802eba:	e8 43 03 00 00       	call   803202 <_panic>
  802ebf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	89 10                	mov    %edx,(%eax)
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 00                	mov    (%eax),%eax
  802ecf:	85 c0                	test   %eax,%eax
  802ed1:	74 0d                	je     802ee0 <insert_sorted_with_merge_freeList+0x4de>
  802ed3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  802edb:	89 50 04             	mov    %edx,0x4(%eax)
  802ede:	eb 08                	jmp    802ee8 <insert_sorted_with_merge_freeList+0x4e6>
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efa:	a1 54 41 80 00       	mov    0x804154,%eax
  802eff:	40                   	inc    %eax
  802f00:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f05:	e9 41 02 00 00       	jmp    80314b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	8b 50 08             	mov    0x8(%eax),%edx
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	8b 40 0c             	mov    0xc(%eax),%eax
  802f16:	01 c2                	add    %eax,%edx
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	8b 40 08             	mov    0x8(%eax),%eax
  802f1e:	39 c2                	cmp    %eax,%edx
  802f20:	0f 85 7c 01 00 00    	jne    8030a2 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f2a:	74 06                	je     802f32 <insert_sorted_with_merge_freeList+0x530>
  802f2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f30:	75 17                	jne    802f49 <insert_sorted_with_merge_freeList+0x547>
  802f32:	83 ec 04             	sub    $0x4,%esp
  802f35:	68 20 3d 80 00       	push   $0x803d20
  802f3a:	68 69 01 00 00       	push   $0x169
  802f3f:	68 07 3d 80 00       	push   $0x803d07
  802f44:	e8 b9 02 00 00       	call   803202 <_panic>
  802f49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4c:	8b 50 04             	mov    0x4(%eax),%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	89 50 04             	mov    %edx,0x4(%eax)
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5b:	89 10                	mov    %edx,(%eax)
  802f5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f60:	8b 40 04             	mov    0x4(%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 0d                	je     802f74 <insert_sorted_with_merge_freeList+0x572>
  802f67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	eb 08                	jmp    802f7c <insert_sorted_with_merge_freeList+0x57a>
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	a3 38 41 80 00       	mov    %eax,0x804138
  802f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f82:	89 50 04             	mov    %edx,0x4(%eax)
  802f85:	a1 44 41 80 00       	mov    0x804144,%eax
  802f8a:	40                   	inc    %eax
  802f8b:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 50 0c             	mov    0xc(%eax),%edx
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9c:	01 c2                	add    %eax,%edx
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fa4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa8:	75 17                	jne    802fc1 <insert_sorted_with_merge_freeList+0x5bf>
  802faa:	83 ec 04             	sub    $0x4,%esp
  802fad:	68 b0 3d 80 00       	push   $0x803db0
  802fb2:	68 6b 01 00 00       	push   $0x16b
  802fb7:	68 07 3d 80 00       	push   $0x803d07
  802fbc:	e8 41 02 00 00       	call   803202 <_panic>
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 10                	je     802fda <insert_sorted_with_merge_freeList+0x5d8>
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd2:	8b 52 04             	mov    0x4(%edx),%edx
  802fd5:	89 50 04             	mov    %edx,0x4(%eax)
  802fd8:	eb 0b                	jmp    802fe5 <insert_sorted_with_merge_freeList+0x5e3>
  802fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	8b 40 04             	mov    0x4(%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 0f                	je     802ffe <insert_sorted_with_merge_freeList+0x5fc>
  802fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff8:	8b 12                	mov    (%edx),%edx
  802ffa:	89 10                	mov    %edx,(%eax)
  802ffc:	eb 0a                	jmp    803008 <insert_sorted_with_merge_freeList+0x606>
  802ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	a3 38 41 80 00       	mov    %eax,0x804138
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803014:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301b:	a1 44 41 80 00       	mov    0x804144,%eax
  803020:	48                   	dec    %eax
  803021:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803026:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803029:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80303a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303e:	75 17                	jne    803057 <insert_sorted_with_merge_freeList+0x655>
  803040:	83 ec 04             	sub    $0x4,%esp
  803043:	68 e4 3c 80 00       	push   $0x803ce4
  803048:	68 6e 01 00 00       	push   $0x16e
  80304d:	68 07 3d 80 00       	push   $0x803d07
  803052:	e8 ab 01 00 00       	call   803202 <_panic>
  803057:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	89 10                	mov    %edx,(%eax)
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 00                	mov    (%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 0d                	je     803078 <insert_sorted_with_merge_freeList+0x676>
  80306b:	a1 48 41 80 00       	mov    0x804148,%eax
  803070:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803073:	89 50 04             	mov    %edx,0x4(%eax)
  803076:	eb 08                	jmp    803080 <insert_sorted_with_merge_freeList+0x67e>
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	a3 48 41 80 00       	mov    %eax,0x804148
  803088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803092:	a1 54 41 80 00       	mov    0x804154,%eax
  803097:	40                   	inc    %eax
  803098:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80309d:	e9 a9 00 00 00       	jmp    80314b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8030a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a6:	74 06                	je     8030ae <insert_sorted_with_merge_freeList+0x6ac>
  8030a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ac:	75 17                	jne    8030c5 <insert_sorted_with_merge_freeList+0x6c3>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 7c 3d 80 00       	push   $0x803d7c
  8030b6:	68 73 01 00 00       	push   $0x173
  8030bb:	68 07 3d 80 00       	push   $0x803d07
  8030c0:	e8 3d 01 00 00       	call   803202 <_panic>
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 10                	mov    (%eax),%edx
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0b                	je     8030e3 <insert_sorted_with_merge_freeList+0x6e1>
  8030d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030db:	8b 00                	mov    (%eax),%eax
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f1:	89 50 04             	mov    %edx,0x4(%eax)
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	8b 00                	mov    (%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	75 08                	jne    803105 <insert_sorted_with_merge_freeList+0x703>
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803105:	a1 44 41 80 00       	mov    0x804144,%eax
  80310a:	40                   	inc    %eax
  80310b:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803110:	eb 39                	jmp    80314b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803112:	a1 40 41 80 00       	mov    0x804140,%eax
  803117:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311e:	74 07                	je     803127 <insert_sorted_with_merge_freeList+0x725>
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	eb 05                	jmp    80312c <insert_sorted_with_merge_freeList+0x72a>
  803127:	b8 00 00 00 00       	mov    $0x0,%eax
  80312c:	a3 40 41 80 00       	mov    %eax,0x804140
  803131:	a1 40 41 80 00       	mov    0x804140,%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	0f 85 c7 fb ff ff    	jne    802d05 <insert_sorted_with_merge_freeList+0x303>
  80313e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803142:	0f 85 bd fb ff ff    	jne    802d05 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803148:	eb 01                	jmp    80314b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80314a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80314b:	90                   	nop
  80314c:	c9                   	leave  
  80314d:	c3                   	ret    

0080314e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80314e:	55                   	push   %ebp
  80314f:	89 e5                	mov    %esp,%ebp
  803151:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803154:	8b 55 08             	mov    0x8(%ebp),%edx
  803157:	89 d0                	mov    %edx,%eax
  803159:	c1 e0 02             	shl    $0x2,%eax
  80315c:	01 d0                	add    %edx,%eax
  80315e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803165:	01 d0                	add    %edx,%eax
  803167:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80316e:	01 d0                	add    %edx,%eax
  803170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803177:	01 d0                	add    %edx,%eax
  803179:	c1 e0 04             	shl    $0x4,%eax
  80317c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80317f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803186:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803189:	83 ec 0c             	sub    $0xc,%esp
  80318c:	50                   	push   %eax
  80318d:	e8 26 e7 ff ff       	call   8018b8 <sys_get_virtual_time>
  803192:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803195:	eb 41                	jmp    8031d8 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803197:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80319a:	83 ec 0c             	sub    $0xc,%esp
  80319d:	50                   	push   %eax
  80319e:	e8 15 e7 ff ff       	call   8018b8 <sys_get_virtual_time>
  8031a3:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8031a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	29 c2                	sub    %eax,%edx
  8031ae:	89 d0                	mov    %edx,%eax
  8031b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8031b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b9:	89 d1                	mov    %edx,%ecx
  8031bb:	29 c1                	sub    %eax,%ecx
  8031bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c3:	39 c2                	cmp    %eax,%edx
  8031c5:	0f 97 c0             	seta   %al
  8031c8:	0f b6 c0             	movzbl %al,%eax
  8031cb:	29 c1                	sub    %eax,%ecx
  8031cd:	89 c8                	mov    %ecx,%eax
  8031cf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8031d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031de:	72 b7                	jb     803197 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8031e0:	90                   	nop
  8031e1:	c9                   	leave  
  8031e2:	c3                   	ret    

008031e3 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8031e3:	55                   	push   %ebp
  8031e4:	89 e5                	mov    %esp,%ebp
  8031e6:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8031e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8031f0:	eb 03                	jmp    8031f5 <busy_wait+0x12>
  8031f2:	ff 45 fc             	incl   -0x4(%ebp)
  8031f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fb:	72 f5                	jb     8031f2 <busy_wait+0xf>
	return i;
  8031fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803200:	c9                   	leave  
  803201:	c3                   	ret    

00803202 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803202:	55                   	push   %ebp
  803203:	89 e5                	mov    %esp,%ebp
  803205:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803208:	8d 45 10             	lea    0x10(%ebp),%eax
  80320b:	83 c0 04             	add    $0x4,%eax
  80320e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803211:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 16                	je     803230 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80321a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80321f:	83 ec 08             	sub    $0x8,%esp
  803222:	50                   	push   %eax
  803223:	68 d0 3d 80 00       	push   $0x803dd0
  803228:	e8 4f d1 ff ff       	call   80037c <cprintf>
  80322d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803230:	a1 00 40 80 00       	mov    0x804000,%eax
  803235:	ff 75 0c             	pushl  0xc(%ebp)
  803238:	ff 75 08             	pushl  0x8(%ebp)
  80323b:	50                   	push   %eax
  80323c:	68 d5 3d 80 00       	push   $0x803dd5
  803241:	e8 36 d1 ff ff       	call   80037c <cprintf>
  803246:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803249:	8b 45 10             	mov    0x10(%ebp),%eax
  80324c:	83 ec 08             	sub    $0x8,%esp
  80324f:	ff 75 f4             	pushl  -0xc(%ebp)
  803252:	50                   	push   %eax
  803253:	e8 b9 d0 ff ff       	call   800311 <vcprintf>
  803258:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80325b:	83 ec 08             	sub    $0x8,%esp
  80325e:	6a 00                	push   $0x0
  803260:	68 f1 3d 80 00       	push   $0x803df1
  803265:	e8 a7 d0 ff ff       	call   800311 <vcprintf>
  80326a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80326d:	e8 28 d0 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  803272:	eb fe                	jmp    803272 <_panic+0x70>

00803274 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803274:	55                   	push   %ebp
  803275:	89 e5                	mov    %esp,%ebp
  803277:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80327a:	a1 20 40 80 00       	mov    0x804020,%eax
  80327f:	8b 50 74             	mov    0x74(%eax),%edx
  803282:	8b 45 0c             	mov    0xc(%ebp),%eax
  803285:	39 c2                	cmp    %eax,%edx
  803287:	74 14                	je     80329d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803289:	83 ec 04             	sub    $0x4,%esp
  80328c:	68 f4 3d 80 00       	push   $0x803df4
  803291:	6a 26                	push   $0x26
  803293:	68 40 3e 80 00       	push   $0x803e40
  803298:	e8 65 ff ff ff       	call   803202 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80329d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032ab:	e9 c2 00 00 00       	jmp    803372 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	01 d0                	add    %edx,%eax
  8032bf:	8b 00                	mov    (%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	75 08                	jne    8032cd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8032c5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8032c8:	e9 a2 00 00 00       	jmp    80336f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8032cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8032db:	eb 69                	jmp    803346 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8032dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8032e2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032eb:	89 d0                	mov    %edx,%eax
  8032ed:	01 c0                	add    %eax,%eax
  8032ef:	01 d0                	add    %edx,%eax
  8032f1:	c1 e0 03             	shl    $0x3,%eax
  8032f4:	01 c8                	add    %ecx,%eax
  8032f6:	8a 40 04             	mov    0x4(%eax),%al
  8032f9:	84 c0                	test   %al,%al
  8032fb:	75 46                	jne    803343 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032fd:	a1 20 40 80 00       	mov    0x804020,%eax
  803302:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803308:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330b:	89 d0                	mov    %edx,%eax
  80330d:	01 c0                	add    %eax,%eax
  80330f:	01 d0                	add    %edx,%eax
  803311:	c1 e0 03             	shl    $0x3,%eax
  803314:	01 c8                	add    %ecx,%eax
  803316:	8b 00                	mov    (%eax),%eax
  803318:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80331b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803323:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803328:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	01 c8                	add    %ecx,%eax
  803334:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803336:	39 c2                	cmp    %eax,%edx
  803338:	75 09                	jne    803343 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80333a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803341:	eb 12                	jmp    803355 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803343:	ff 45 e8             	incl   -0x18(%ebp)
  803346:	a1 20 40 80 00       	mov    0x804020,%eax
  80334b:	8b 50 74             	mov    0x74(%eax),%edx
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	39 c2                	cmp    %eax,%edx
  803353:	77 88                	ja     8032dd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803355:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803359:	75 14                	jne    80336f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80335b:	83 ec 04             	sub    $0x4,%esp
  80335e:	68 4c 3e 80 00       	push   $0x803e4c
  803363:	6a 3a                	push   $0x3a
  803365:	68 40 3e 80 00       	push   $0x803e40
  80336a:	e8 93 fe ff ff       	call   803202 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80336f:	ff 45 f0             	incl   -0x10(%ebp)
  803372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803375:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803378:	0f 8c 32 ff ff ff    	jl     8032b0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80337e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803385:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80338c:	eb 26                	jmp    8033b4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80338e:	a1 20 40 80 00       	mov    0x804020,%eax
  803393:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803399:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80339c:	89 d0                	mov    %edx,%eax
  80339e:	01 c0                	add    %eax,%eax
  8033a0:	01 d0                	add    %edx,%eax
  8033a2:	c1 e0 03             	shl    $0x3,%eax
  8033a5:	01 c8                	add    %ecx,%eax
  8033a7:	8a 40 04             	mov    0x4(%eax),%al
  8033aa:	3c 01                	cmp    $0x1,%al
  8033ac:	75 03                	jne    8033b1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033ae:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033b1:	ff 45 e0             	incl   -0x20(%ebp)
  8033b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8033b9:	8b 50 74             	mov    0x74(%eax),%edx
  8033bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033bf:	39 c2                	cmp    %eax,%edx
  8033c1:	77 cb                	ja     80338e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033c9:	74 14                	je     8033df <CheckWSWithoutLastIndex+0x16b>
		panic(
  8033cb:	83 ec 04             	sub    $0x4,%esp
  8033ce:	68 a0 3e 80 00       	push   $0x803ea0
  8033d3:	6a 44                	push   $0x44
  8033d5:	68 40 3e 80 00       	push   $0x803e40
  8033da:	e8 23 fe ff ff       	call   803202 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8033df:	90                   	nop
  8033e0:	c9                   	leave  
  8033e1:	c3                   	ret    
  8033e2:	66 90                	xchg   %ax,%ax

008033e4 <__udivdi3>:
  8033e4:	55                   	push   %ebp
  8033e5:	57                   	push   %edi
  8033e6:	56                   	push   %esi
  8033e7:	53                   	push   %ebx
  8033e8:	83 ec 1c             	sub    $0x1c,%esp
  8033eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033fb:	89 ca                	mov    %ecx,%edx
  8033fd:	89 f8                	mov    %edi,%eax
  8033ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803403:	85 f6                	test   %esi,%esi
  803405:	75 2d                	jne    803434 <__udivdi3+0x50>
  803407:	39 cf                	cmp    %ecx,%edi
  803409:	77 65                	ja     803470 <__udivdi3+0x8c>
  80340b:	89 fd                	mov    %edi,%ebp
  80340d:	85 ff                	test   %edi,%edi
  80340f:	75 0b                	jne    80341c <__udivdi3+0x38>
  803411:	b8 01 00 00 00       	mov    $0x1,%eax
  803416:	31 d2                	xor    %edx,%edx
  803418:	f7 f7                	div    %edi
  80341a:	89 c5                	mov    %eax,%ebp
  80341c:	31 d2                	xor    %edx,%edx
  80341e:	89 c8                	mov    %ecx,%eax
  803420:	f7 f5                	div    %ebp
  803422:	89 c1                	mov    %eax,%ecx
  803424:	89 d8                	mov    %ebx,%eax
  803426:	f7 f5                	div    %ebp
  803428:	89 cf                	mov    %ecx,%edi
  80342a:	89 fa                	mov    %edi,%edx
  80342c:	83 c4 1c             	add    $0x1c,%esp
  80342f:	5b                   	pop    %ebx
  803430:	5e                   	pop    %esi
  803431:	5f                   	pop    %edi
  803432:	5d                   	pop    %ebp
  803433:	c3                   	ret    
  803434:	39 ce                	cmp    %ecx,%esi
  803436:	77 28                	ja     803460 <__udivdi3+0x7c>
  803438:	0f bd fe             	bsr    %esi,%edi
  80343b:	83 f7 1f             	xor    $0x1f,%edi
  80343e:	75 40                	jne    803480 <__udivdi3+0x9c>
  803440:	39 ce                	cmp    %ecx,%esi
  803442:	72 0a                	jb     80344e <__udivdi3+0x6a>
  803444:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803448:	0f 87 9e 00 00 00    	ja     8034ec <__udivdi3+0x108>
  80344e:	b8 01 00 00 00       	mov    $0x1,%eax
  803453:	89 fa                	mov    %edi,%edx
  803455:	83 c4 1c             	add    $0x1c,%esp
  803458:	5b                   	pop    %ebx
  803459:	5e                   	pop    %esi
  80345a:	5f                   	pop    %edi
  80345b:	5d                   	pop    %ebp
  80345c:	c3                   	ret    
  80345d:	8d 76 00             	lea    0x0(%esi),%esi
  803460:	31 ff                	xor    %edi,%edi
  803462:	31 c0                	xor    %eax,%eax
  803464:	89 fa                	mov    %edi,%edx
  803466:	83 c4 1c             	add    $0x1c,%esp
  803469:	5b                   	pop    %ebx
  80346a:	5e                   	pop    %esi
  80346b:	5f                   	pop    %edi
  80346c:	5d                   	pop    %ebp
  80346d:	c3                   	ret    
  80346e:	66 90                	xchg   %ax,%ax
  803470:	89 d8                	mov    %ebx,%eax
  803472:	f7 f7                	div    %edi
  803474:	31 ff                	xor    %edi,%edi
  803476:	89 fa                	mov    %edi,%edx
  803478:	83 c4 1c             	add    $0x1c,%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	bd 20 00 00 00       	mov    $0x20,%ebp
  803485:	89 eb                	mov    %ebp,%ebx
  803487:	29 fb                	sub    %edi,%ebx
  803489:	89 f9                	mov    %edi,%ecx
  80348b:	d3 e6                	shl    %cl,%esi
  80348d:	89 c5                	mov    %eax,%ebp
  80348f:	88 d9                	mov    %bl,%cl
  803491:	d3 ed                	shr    %cl,%ebp
  803493:	89 e9                	mov    %ebp,%ecx
  803495:	09 f1                	or     %esi,%ecx
  803497:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80349b:	89 f9                	mov    %edi,%ecx
  80349d:	d3 e0                	shl    %cl,%eax
  80349f:	89 c5                	mov    %eax,%ebp
  8034a1:	89 d6                	mov    %edx,%esi
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 ee                	shr    %cl,%esi
  8034a7:	89 f9                	mov    %edi,%ecx
  8034a9:	d3 e2                	shl    %cl,%edx
  8034ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034af:	88 d9                	mov    %bl,%cl
  8034b1:	d3 e8                	shr    %cl,%eax
  8034b3:	09 c2                	or     %eax,%edx
  8034b5:	89 d0                	mov    %edx,%eax
  8034b7:	89 f2                	mov    %esi,%edx
  8034b9:	f7 74 24 0c          	divl   0xc(%esp)
  8034bd:	89 d6                	mov    %edx,%esi
  8034bf:	89 c3                	mov    %eax,%ebx
  8034c1:	f7 e5                	mul    %ebp
  8034c3:	39 d6                	cmp    %edx,%esi
  8034c5:	72 19                	jb     8034e0 <__udivdi3+0xfc>
  8034c7:	74 0b                	je     8034d4 <__udivdi3+0xf0>
  8034c9:	89 d8                	mov    %ebx,%eax
  8034cb:	31 ff                	xor    %edi,%edi
  8034cd:	e9 58 ff ff ff       	jmp    80342a <__udivdi3+0x46>
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034d8:	89 f9                	mov    %edi,%ecx
  8034da:	d3 e2                	shl    %cl,%edx
  8034dc:	39 c2                	cmp    %eax,%edx
  8034de:	73 e9                	jae    8034c9 <__udivdi3+0xe5>
  8034e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034e3:	31 ff                	xor    %edi,%edi
  8034e5:	e9 40 ff ff ff       	jmp    80342a <__udivdi3+0x46>
  8034ea:	66 90                	xchg   %ax,%ax
  8034ec:	31 c0                	xor    %eax,%eax
  8034ee:	e9 37 ff ff ff       	jmp    80342a <__udivdi3+0x46>
  8034f3:	90                   	nop

008034f4 <__umoddi3>:
  8034f4:	55                   	push   %ebp
  8034f5:	57                   	push   %edi
  8034f6:	56                   	push   %esi
  8034f7:	53                   	push   %ebx
  8034f8:	83 ec 1c             	sub    $0x1c,%esp
  8034fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803503:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803507:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80350b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80350f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803513:	89 f3                	mov    %esi,%ebx
  803515:	89 fa                	mov    %edi,%edx
  803517:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80351b:	89 34 24             	mov    %esi,(%esp)
  80351e:	85 c0                	test   %eax,%eax
  803520:	75 1a                	jne    80353c <__umoddi3+0x48>
  803522:	39 f7                	cmp    %esi,%edi
  803524:	0f 86 a2 00 00 00    	jbe    8035cc <__umoddi3+0xd8>
  80352a:	89 c8                	mov    %ecx,%eax
  80352c:	89 f2                	mov    %esi,%edx
  80352e:	f7 f7                	div    %edi
  803530:	89 d0                	mov    %edx,%eax
  803532:	31 d2                	xor    %edx,%edx
  803534:	83 c4 1c             	add    $0x1c,%esp
  803537:	5b                   	pop    %ebx
  803538:	5e                   	pop    %esi
  803539:	5f                   	pop    %edi
  80353a:	5d                   	pop    %ebp
  80353b:	c3                   	ret    
  80353c:	39 f0                	cmp    %esi,%eax
  80353e:	0f 87 ac 00 00 00    	ja     8035f0 <__umoddi3+0xfc>
  803544:	0f bd e8             	bsr    %eax,%ebp
  803547:	83 f5 1f             	xor    $0x1f,%ebp
  80354a:	0f 84 ac 00 00 00    	je     8035fc <__umoddi3+0x108>
  803550:	bf 20 00 00 00       	mov    $0x20,%edi
  803555:	29 ef                	sub    %ebp,%edi
  803557:	89 fe                	mov    %edi,%esi
  803559:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 e0                	shl    %cl,%eax
  803561:	89 d7                	mov    %edx,%edi
  803563:	89 f1                	mov    %esi,%ecx
  803565:	d3 ef                	shr    %cl,%edi
  803567:	09 c7                	or     %eax,%edi
  803569:	89 e9                	mov    %ebp,%ecx
  80356b:	d3 e2                	shl    %cl,%edx
  80356d:	89 14 24             	mov    %edx,(%esp)
  803570:	89 d8                	mov    %ebx,%eax
  803572:	d3 e0                	shl    %cl,%eax
  803574:	89 c2                	mov    %eax,%edx
  803576:	8b 44 24 08          	mov    0x8(%esp),%eax
  80357a:	d3 e0                	shl    %cl,%eax
  80357c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803580:	8b 44 24 08          	mov    0x8(%esp),%eax
  803584:	89 f1                	mov    %esi,%ecx
  803586:	d3 e8                	shr    %cl,%eax
  803588:	09 d0                	or     %edx,%eax
  80358a:	d3 eb                	shr    %cl,%ebx
  80358c:	89 da                	mov    %ebx,%edx
  80358e:	f7 f7                	div    %edi
  803590:	89 d3                	mov    %edx,%ebx
  803592:	f7 24 24             	mull   (%esp)
  803595:	89 c6                	mov    %eax,%esi
  803597:	89 d1                	mov    %edx,%ecx
  803599:	39 d3                	cmp    %edx,%ebx
  80359b:	0f 82 87 00 00 00    	jb     803628 <__umoddi3+0x134>
  8035a1:	0f 84 91 00 00 00    	je     803638 <__umoddi3+0x144>
  8035a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035ab:	29 f2                	sub    %esi,%edx
  8035ad:	19 cb                	sbb    %ecx,%ebx
  8035af:	89 d8                	mov    %ebx,%eax
  8035b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035b5:	d3 e0                	shl    %cl,%eax
  8035b7:	89 e9                	mov    %ebp,%ecx
  8035b9:	d3 ea                	shr    %cl,%edx
  8035bb:	09 d0                	or     %edx,%eax
  8035bd:	89 e9                	mov    %ebp,%ecx
  8035bf:	d3 eb                	shr    %cl,%ebx
  8035c1:	89 da                	mov    %ebx,%edx
  8035c3:	83 c4 1c             	add    $0x1c,%esp
  8035c6:	5b                   	pop    %ebx
  8035c7:	5e                   	pop    %esi
  8035c8:	5f                   	pop    %edi
  8035c9:	5d                   	pop    %ebp
  8035ca:	c3                   	ret    
  8035cb:	90                   	nop
  8035cc:	89 fd                	mov    %edi,%ebp
  8035ce:	85 ff                	test   %edi,%edi
  8035d0:	75 0b                	jne    8035dd <__umoddi3+0xe9>
  8035d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d7:	31 d2                	xor    %edx,%edx
  8035d9:	f7 f7                	div    %edi
  8035db:	89 c5                	mov    %eax,%ebp
  8035dd:	89 f0                	mov    %esi,%eax
  8035df:	31 d2                	xor    %edx,%edx
  8035e1:	f7 f5                	div    %ebp
  8035e3:	89 c8                	mov    %ecx,%eax
  8035e5:	f7 f5                	div    %ebp
  8035e7:	89 d0                	mov    %edx,%eax
  8035e9:	e9 44 ff ff ff       	jmp    803532 <__umoddi3+0x3e>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	89 c8                	mov    %ecx,%eax
  8035f2:	89 f2                	mov    %esi,%edx
  8035f4:	83 c4 1c             	add    $0x1c,%esp
  8035f7:	5b                   	pop    %ebx
  8035f8:	5e                   	pop    %esi
  8035f9:	5f                   	pop    %edi
  8035fa:	5d                   	pop    %ebp
  8035fb:	c3                   	ret    
  8035fc:	3b 04 24             	cmp    (%esp),%eax
  8035ff:	72 06                	jb     803607 <__umoddi3+0x113>
  803601:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803605:	77 0f                	ja     803616 <__umoddi3+0x122>
  803607:	89 f2                	mov    %esi,%edx
  803609:	29 f9                	sub    %edi,%ecx
  80360b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80360f:	89 14 24             	mov    %edx,(%esp)
  803612:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803616:	8b 44 24 04          	mov    0x4(%esp),%eax
  80361a:	8b 14 24             	mov    (%esp),%edx
  80361d:	83 c4 1c             	add    $0x1c,%esp
  803620:	5b                   	pop    %ebx
  803621:	5e                   	pop    %esi
  803622:	5f                   	pop    %edi
  803623:	5d                   	pop    %ebp
  803624:	c3                   	ret    
  803625:	8d 76 00             	lea    0x0(%esi),%esi
  803628:	2b 04 24             	sub    (%esp),%eax
  80362b:	19 fa                	sbb    %edi,%edx
  80362d:	89 d1                	mov    %edx,%ecx
  80362f:	89 c6                	mov    %eax,%esi
  803631:	e9 71 ff ff ff       	jmp    8035a7 <__umoddi3+0xb3>
  803636:	66 90                	xchg   %ax,%ax
  803638:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80363c:	72 ea                	jb     803628 <__umoddi3+0x134>
  80363e:	89 d9                	mov    %ebx,%ecx
  803640:	e9 62 ff ff ff       	jmp    8035a7 <__umoddi3+0xb3>
