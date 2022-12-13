
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
  80003e:	e8 8f 18 00 00       	call   8018d2 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 36 80 00       	push   $0x8036a0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 df 13 00 00       	call   801435 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 36 80 00       	push   $0x8036a2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 c9 13 00 00       	call   801435 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 36 80 00       	push   $0x8036a9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 b3 13 00 00       	call   801435 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 71 18 00 00       	call   801905 <sys_get_virtual_time>
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
  8000b7:	e8 df 30 00 00       	call   80319b <env_sleep>
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
  8000d0:	e8 30 18 00 00       	call   801905 <sys_get_virtual_time>
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
  8000f8:	e8 9e 30 00 00       	call   80319b <env_sleep>
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
  80010f:	e8 f1 17 00 00       	call   801905 <sys_get_virtual_time>
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
  800137:	e8 5f 30 00 00       	call   80319b <env_sleep>
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
  80014c:	68 b7 36 80 00       	push   $0x8036b7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 38 16 00 00       	call   801791 <sys_signalSemaphore>
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
  800172:	e8 42 17 00 00       	call   8018b9 <sys_getenvindex>
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
  8001dd:	e8 e4 14 00 00       	call   8016c6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 d4 36 80 00       	push   $0x8036d4
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
  80020d:	68 fc 36 80 00       	push   $0x8036fc
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
  80023e:	68 24 37 80 00       	push   $0x803724
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 7c 37 80 00       	push   $0x80377c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 d4 36 80 00       	push   $0x8036d4
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 64 14 00 00       	call   8016e0 <sys_enable_interrupt>

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
  80028f:	e8 f1 15 00 00       	call   801885 <sys_destroy_env>
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
  8002a0:	e8 46 16 00 00       	call   8018eb <sys_exit_env>
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
  8002ee:	e8 25 12 00 00       	call   801518 <sys_cputs>
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
  800365:	e8 ae 11 00 00       	call   801518 <sys_cputs>
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
  8003af:	e8 12 13 00 00       	call   8016c6 <sys_disable_interrupt>
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
  8003cf:	e8 0c 13 00 00       	call   8016e0 <sys_enable_interrupt>
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
  800419:	e8 12 30 00 00       	call   803430 <__udivdi3>
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
  800469:	e8 d2 30 00 00       	call   803540 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 b4 39 80 00       	add    $0x8039b4,%eax
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
  8005c4:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
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
  8006a5:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 c5 39 80 00       	push   $0x8039c5
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
  8006ca:	68 ce 39 80 00       	push   $0x8039ce
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
  8006f7:	be d1 39 80 00       	mov    $0x8039d1,%esi
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
  80111d:	68 30 3b 80 00       	push   $0x803b30
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
  8011ed:	e8 6a 04 00 00       	call   80165c <sys_allocate_chunk>
  8011f2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	e8 df 0a 00 00       	call   801ce2 <initialize_MemBlocksList>
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
  80122b:	68 55 3b 80 00       	push   $0x803b55
  801230:	6a 33                	push   $0x33
  801232:	68 73 3b 80 00       	push   $0x803b73
  801237:	e8 13 20 00 00       	call   80324f <_panic>
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
  8012aa:	68 80 3b 80 00       	push   $0x803b80
  8012af:	6a 34                	push   $0x34
  8012b1:	68 73 3b 80 00       	push   $0x803b73
  8012b6:	e8 94 1f 00 00       	call   80324f <_panic>
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
  801342:	e8 e3 06 00 00       	call   801a2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801347:	85 c0                	test   %eax,%eax
  801349:	74 11                	je     80135c <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	ff 75 e8             	pushl  -0x18(%ebp)
  801351:	e8 4e 0d 00 00       	call   8020a4 <alloc_block_FF>
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
  801368:	e8 aa 0a 00 00       	call   801e17 <insert_sorted_allocList>
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
  801388:	68 a4 3b 80 00       	push   $0x803ba4
  80138d:	6a 6f                	push   $0x6f
  80138f:	68 73 3b 80 00       	push   $0x803b73
  801394:	e8 b6 1e 00 00       	call   80324f <_panic>

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
  8013ae:	75 07                	jne    8013b7 <smalloc+0x1e>
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b5:	eb 7c                	jmp    801433 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8013b7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c4:	01 d0                	add    %edx,%eax
  8013c6:	48                   	dec    %eax
  8013c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d2:	f7 75 f0             	divl   -0x10(%ebp)
  8013d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d8:	29 d0                	sub    %edx,%eax
  8013da:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8013dd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013e4:	e8 41 06 00 00       	call   801a2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013e9:	85 c0                	test   %eax,%eax
  8013eb:	74 11                	je     8013fe <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f3:	e8 ac 0c 00 00       	call   8020a4 <alloc_block_FF>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8013fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801402:	74 2a                	je     80142e <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	8b 40 08             	mov    0x8(%eax),%eax
  80140a:	89 c2                	mov    %eax,%edx
  80140c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801410:	52                   	push   %edx
  801411:	50                   	push   %eax
  801412:	ff 75 0c             	pushl  0xc(%ebp)
  801415:	ff 75 08             	pushl  0x8(%ebp)
  801418:	e8 92 03 00 00       	call   8017af <sys_createSharedObject>
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801423:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801427:	74 05                	je     80142e <smalloc+0x95>
			return (void*)virtual_address;
  801429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142c:	eb 05                	jmp    801433 <smalloc+0x9a>
	}
	return NULL;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80143b:	e8 c6 fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	68 c8 3b 80 00       	push   $0x803bc8
  801448:	68 b0 00 00 00       	push   $0xb0
  80144d:	68 73 3b 80 00       	push   $0x803b73
  801452:	e8 f8 1d 00 00       	call   80324f <_panic>

00801457 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80145d:	e8 a4 fc ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	68 ec 3b 80 00       	push   $0x803bec
  80146a:	68 f4 00 00 00       	push   $0xf4
  80146f:	68 73 3b 80 00       	push   $0x803b73
  801474:	e8 d6 1d 00 00       	call   80324f <_panic>

00801479 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	68 14 3c 80 00       	push   $0x803c14
  801487:	68 08 01 00 00       	push   $0x108
  80148c:	68 73 3b 80 00       	push   $0x803b73
  801491:	e8 b9 1d 00 00       	call   80324f <_panic>

00801496 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	68 38 3c 80 00       	push   $0x803c38
  8014a4:	68 13 01 00 00       	push   $0x113
  8014a9:	68 73 3b 80 00       	push   $0x803b73
  8014ae:	e8 9c 1d 00 00       	call   80324f <_panic>

008014b3 <shrink>:

}
void shrink(uint32 newSize)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	68 38 3c 80 00       	push   $0x803c38
  8014c1:	68 18 01 00 00       	push   $0x118
  8014c6:	68 73 3b 80 00       	push   $0x803b73
  8014cb:	e8 7f 1d 00 00       	call   80324f <_panic>

008014d0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	68 38 3c 80 00       	push   $0x803c38
  8014de:	68 1d 01 00 00       	push   $0x11d
  8014e3:	68 73 3b 80 00       	push   $0x803b73
  8014e8:	e8 62 1d 00 00       	call   80324f <_panic>

008014ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	57                   	push   %edi
  8014f1:	56                   	push   %esi
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801502:	8b 7d 18             	mov    0x18(%ebp),%edi
  801505:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801508:	cd 30                	int    $0x30
  80150a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	5b                   	pop    %ebx
  801514:	5e                   	pop    %esi
  801515:	5f                   	pop    %edi
  801516:	5d                   	pop    %ebp
  801517:	c3                   	ret    

00801518 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 04             	sub    $0x4,%esp
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801524:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	52                   	push   %edx
  801530:	ff 75 0c             	pushl  0xc(%ebp)
  801533:	50                   	push   %eax
  801534:	6a 00                	push   $0x0
  801536:	e8 b2 ff ff ff       	call   8014ed <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	90                   	nop
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_cgetc>:

int
sys_cgetc(void)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801544:	6a 00                	push   $0x0
  801546:	6a 00                	push   $0x0
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 01                	push   $0x1
  801550:	e8 98 ff ff ff       	call   8014ed <syscall>
  801555:	83 c4 18             	add    $0x18,%esp
}
  801558:	c9                   	leave  
  801559:	c3                   	ret    

0080155a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80155a:	55                   	push   %ebp
  80155b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80155d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	52                   	push   %edx
  80156a:	50                   	push   %eax
  80156b:	6a 05                	push   $0x5
  80156d:	e8 7b ff ff ff       	call   8014ed <syscall>
  801572:	83 c4 18             	add    $0x18,%esp
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	56                   	push   %esi
  80157b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80157c:	8b 75 18             	mov    0x18(%ebp),%esi
  80157f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801582:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	56                   	push   %esi
  80158c:	53                   	push   %ebx
  80158d:	51                   	push   %ecx
  80158e:	52                   	push   %edx
  80158f:	50                   	push   %eax
  801590:	6a 06                	push   $0x6
  801592:	e8 56 ff ff ff       	call   8014ed <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5e                   	pop    %esi
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    

008015a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	52                   	push   %edx
  8015b1:	50                   	push   %eax
  8015b2:	6a 07                	push   $0x7
  8015b4:	e8 34 ff ff ff       	call   8014ed <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	ff 75 08             	pushl  0x8(%ebp)
  8015cd:	6a 08                	push   $0x8
  8015cf:	e8 19 ff ff ff       	call   8014ed <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 09                	push   $0x9
  8015e8:	e8 00 ff ff ff       	call   8014ed <syscall>
  8015ed:	83 c4 18             	add    $0x18,%esp
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 0a                	push   $0xa
  801601:	e8 e7 fe ff ff       	call   8014ed <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 0b                	push   $0xb
  80161a:	e8 ce fe ff ff       	call   8014ed <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
}
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 00                	push   $0x0
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	ff 75 08             	pushl  0x8(%ebp)
  801633:	6a 0f                	push   $0xf
  801635:	e8 b3 fe ff ff       	call   8014ed <syscall>
  80163a:	83 c4 18             	add    $0x18,%esp
	return;
  80163d:	90                   	nop
}
  80163e:	c9                   	leave  
  80163f:	c3                   	ret    

00801640 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	6a 00                	push   $0x0
  801649:	ff 75 0c             	pushl  0xc(%ebp)
  80164c:	ff 75 08             	pushl  0x8(%ebp)
  80164f:	6a 10                	push   $0x10
  801651:	e8 97 fe ff ff       	call   8014ed <syscall>
  801656:	83 c4 18             	add    $0x18,%esp
	return ;
  801659:	90                   	nop
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	ff 75 10             	pushl  0x10(%ebp)
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	6a 11                	push   $0x11
  80166e:	e8 7a fe ff ff       	call   8014ed <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
	return ;
  801676:	90                   	nop
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 0c                	push   $0xc
  801688:	e8 60 fe ff ff       	call   8014ed <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	6a 0d                	push   $0xd
  8016a2:	e8 46 fe ff ff       	call   8014ed <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 0e                	push   $0xe
  8016bb:	e8 2d fe ff ff       	call   8014ed <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	90                   	nop
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 13                	push   $0x13
  8016d5:	e8 13 fe ff ff       	call   8014ed <syscall>
  8016da:	83 c4 18             	add    $0x18,%esp
}
  8016dd:	90                   	nop
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 14                	push   $0x14
  8016ef:	e8 f9 fd ff ff       	call   8014ed <syscall>
  8016f4:	83 c4 18             	add    $0x18,%esp
}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_cputc>:


void
sys_cputc(const char c)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801706:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	50                   	push   %eax
  801713:	6a 15                	push   $0x15
  801715:	e8 d3 fd ff ff       	call   8014ed <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	90                   	nop
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 16                	push   $0x16
  80172f:	e8 b9 fd ff ff       	call   8014ed <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	90                   	nop
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	50                   	push   %eax
  80174a:	6a 17                	push   $0x17
  80174c:	e8 9c fd ff ff       	call   8014ed <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801759:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	52                   	push   %edx
  801766:	50                   	push   %eax
  801767:	6a 1a                	push   $0x1a
  801769:	e8 7f fd ff ff       	call   8014ed <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801776:	8b 55 0c             	mov    0xc(%ebp),%edx
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 00                	push   $0x0
  801782:	52                   	push   %edx
  801783:	50                   	push   %eax
  801784:	6a 18                	push   $0x18
  801786:	e8 62 fd ff ff       	call   8014ed <syscall>
  80178b:	83 c4 18             	add    $0x18,%esp
}
  80178e:	90                   	nop
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801794:	8b 55 0c             	mov    0xc(%ebp),%edx
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	52                   	push   %edx
  8017a1:	50                   	push   %eax
  8017a2:	6a 19                	push   $0x19
  8017a4:	e8 44 fd ff ff       	call   8014ed <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	90                   	nop
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017bb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	ff 75 0c             	pushl  0xc(%ebp)
  8017cc:	50                   	push   %eax
  8017cd:	6a 1b                	push   $0x1b
  8017cf:	e8 19 fd ff ff       	call   8014ed <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	52                   	push   %edx
  8017e9:	50                   	push   %eax
  8017ea:	6a 1c                	push   $0x1c
  8017ec:	e8 fc fc ff ff       	call   8014ed <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	51                   	push   %ecx
  801807:	52                   	push   %edx
  801808:	50                   	push   %eax
  801809:	6a 1d                	push   $0x1d
  80180b:	e8 dd fc ff ff       	call   8014ed <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	52                   	push   %edx
  801825:	50                   	push   %eax
  801826:	6a 1e                	push   $0x1e
  801828:	e8 c0 fc ff ff       	call   8014ed <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 1f                	push   $0x1f
  801841:	e8 a7 fc ff ff       	call   8014ed <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	ff 75 14             	pushl  0x14(%ebp)
  801856:	ff 75 10             	pushl  0x10(%ebp)
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	6a 20                	push   $0x20
  80185f:	e8 89 fc ff ff       	call   8014ed <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	50                   	push   %eax
  801878:	6a 21                	push   $0x21
  80187a:	e8 6e fc ff ff       	call   8014ed <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	90                   	nop
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 22                	push   $0x22
  801896:	e8 52 fc ff ff       	call   8014ed <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 02                	push   $0x2
  8018af:	e8 39 fc ff ff       	call   8014ed <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 03                	push   $0x3
  8018c8:	e8 20 fc ff ff       	call   8014ed <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 04                	push   $0x4
  8018e1:	e8 07 fc ff ff       	call   8014ed <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_exit_env>:


void sys_exit_env(void)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 23                	push   $0x23
  8018fa:	e8 ee fb ff ff       	call   8014ed <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80190e:	8d 50 04             	lea    0x4(%eax),%edx
  801911:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 24                	push   $0x24
  80191e:	e8 ca fb ff ff       	call   8014ed <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
	return result;
  801926:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801929:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80192f:	89 01                	mov    %eax,(%ecx)
  801931:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	c9                   	leave  
  801938:	c2 04 00             	ret    $0x4

0080193b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 10             	pushl  0x10(%ebp)
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	6a 12                	push   $0x12
  80194d:	e8 9b fb ff ff       	call   8014ed <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
	return ;
  801955:	90                   	nop
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_rcr2>:
uint32 sys_rcr2()
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 25                	push   $0x25
  801967:	e8 81 fb ff ff       	call   8014ed <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80197d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	50                   	push   %eax
  80198a:	6a 26                	push   $0x26
  80198c:	e8 5c fb ff ff       	call   8014ed <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
	return ;
  801994:	90                   	nop
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <rsttst>:
void rsttst()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 28                	push   $0x28
  8019a6:	e8 42 fb ff ff       	call   8014ed <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ae:	90                   	nop
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019bd:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	ff 75 08             	pushl  0x8(%ebp)
  8019cf:	6a 27                	push   $0x27
  8019d1:	e8 17 fb ff ff       	call   8014ed <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d9:	90                   	nop
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <chktst>:
void chktst(uint32 n)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 29                	push   $0x29
  8019ec:	e8 fc fa ff ff       	call   8014ed <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f4:	90                   	nop
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <inctst>:

void inctst()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 2a                	push   $0x2a
  801a06:	e8 e2 fa ff ff       	call   8014ed <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0e:	90                   	nop
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <gettst>:
uint32 gettst()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 2b                	push   $0x2b
  801a20:	e8 c8 fa ff ff       	call   8014ed <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 2c                	push   $0x2c
  801a3c:	e8 ac fa ff ff       	call   8014ed <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
  801a44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a4b:	75 07                	jne    801a54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a52:	eb 05                	jmp    801a59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 2c                	push   $0x2c
  801a6d:	e8 7b fa ff ff       	call   8014ed <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
  801a75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a7c:	75 07                	jne    801a85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a83:	eb 05                	jmp    801a8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 2c                	push   $0x2c
  801a9e:	e8 4a fa ff ff       	call   8014ed <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
  801aa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aa9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aad:	75 07                	jne    801ab6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aaf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab4:	eb 05                	jmp    801abb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ab6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 2c                	push   $0x2c
  801acf:	e8 19 fa ff ff       	call   8014ed <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ada:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ade:	75 07                	jne    801ae7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ae0:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae5:	eb 05                	jmp    801aec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 08             	pushl  0x8(%ebp)
  801afc:	6a 2d                	push   $0x2d
  801afe:	e8 ea f9 ff ff       	call   8014ed <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return ;
  801b06:	90                   	nop
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	53                   	push   %ebx
  801b1c:	51                   	push   %ecx
  801b1d:	52                   	push   %edx
  801b1e:	50                   	push   %eax
  801b1f:	6a 2e                	push   $0x2e
  801b21:	e8 c7 f9 ff ff       	call   8014ed <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	6a 2f                	push   $0x2f
  801b41:	e8 a7 f9 ff ff       	call   8014ed <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b51:	83 ec 0c             	sub    $0xc,%esp
  801b54:	68 48 3c 80 00       	push   $0x803c48
  801b59:	e8 1e e8 ff ff       	call   80037c <cprintf>
  801b5e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b68:	83 ec 0c             	sub    $0xc,%esp
  801b6b:	68 74 3c 80 00       	push   $0x803c74
  801b70:	e8 07 e8 ff ff       	call   80037c <cprintf>
  801b75:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b78:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b7c:	a1 38 41 80 00       	mov    0x804138,%eax
  801b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b84:	eb 56                	jmp    801bdc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b8a:	74 1c                	je     801ba8 <print_mem_block_lists+0x5d>
  801b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8f:	8b 50 08             	mov    0x8(%eax),%edx
  801b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b95:	8b 48 08             	mov    0x8(%eax),%ecx
  801b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9e:	01 c8                	add    %ecx,%eax
  801ba0:	39 c2                	cmp    %eax,%edx
  801ba2:	73 04                	jae    801ba8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ba4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bab:	8b 50 08             	mov    0x8(%eax),%edx
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb4:	01 c2                	add    %eax,%edx
  801bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb9:	8b 40 08             	mov    0x8(%eax),%eax
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	52                   	push   %edx
  801bc0:	50                   	push   %eax
  801bc1:	68 89 3c 80 00       	push   $0x803c89
  801bc6:	e8 b1 e7 ff ff       	call   80037c <cprintf>
  801bcb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801bd4:	a1 40 41 80 00       	mov    0x804140,%eax
  801bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be0:	74 07                	je     801be9 <print_mem_block_lists+0x9e>
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 00                	mov    (%eax),%eax
  801be7:	eb 05                	jmp    801bee <print_mem_block_lists+0xa3>
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bee:	a3 40 41 80 00       	mov    %eax,0x804140
  801bf3:	a1 40 41 80 00       	mov    0x804140,%eax
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	75 8a                	jne    801b86 <print_mem_block_lists+0x3b>
  801bfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c00:	75 84                	jne    801b86 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c02:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c06:	75 10                	jne    801c18 <print_mem_block_lists+0xcd>
  801c08:	83 ec 0c             	sub    $0xc,%esp
  801c0b:	68 98 3c 80 00       	push   $0x803c98
  801c10:	e8 67 e7 ff ff       	call   80037c <cprintf>
  801c15:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801c18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	68 bc 3c 80 00       	push   $0x803cbc
  801c27:	e8 50 e7 ff ff       	call   80037c <cprintf>
  801c2c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801c2f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c33:	a1 40 40 80 00       	mov    0x804040,%eax
  801c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3b:	eb 56                	jmp    801c93 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c41:	74 1c                	je     801c5f <print_mem_block_lists+0x114>
  801c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c46:	8b 50 08             	mov    0x8(%eax),%edx
  801c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4c:	8b 48 08             	mov    0x8(%eax),%ecx
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c52:	8b 40 0c             	mov    0xc(%eax),%eax
  801c55:	01 c8                	add    %ecx,%eax
  801c57:	39 c2                	cmp    %eax,%edx
  801c59:	73 04                	jae    801c5f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c5b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c62:	8b 50 08             	mov    0x8(%eax),%edx
  801c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c68:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6b:	01 c2                	add    %eax,%edx
  801c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c70:	8b 40 08             	mov    0x8(%eax),%eax
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	52                   	push   %edx
  801c77:	50                   	push   %eax
  801c78:	68 89 3c 80 00       	push   $0x803c89
  801c7d:	e8 fa e6 ff ff       	call   80037c <cprintf>
  801c82:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c8b:	a1 48 40 80 00       	mov    0x804048,%eax
  801c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c97:	74 07                	je     801ca0 <print_mem_block_lists+0x155>
  801c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9c:	8b 00                	mov    (%eax),%eax
  801c9e:	eb 05                	jmp    801ca5 <print_mem_block_lists+0x15a>
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca5:	a3 48 40 80 00       	mov    %eax,0x804048
  801caa:	a1 48 40 80 00       	mov    0x804048,%eax
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	75 8a                	jne    801c3d <print_mem_block_lists+0xf2>
  801cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cb7:	75 84                	jne    801c3d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801cb9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801cbd:	75 10                	jne    801ccf <print_mem_block_lists+0x184>
  801cbf:	83 ec 0c             	sub    $0xc,%esp
  801cc2:	68 d4 3c 80 00       	push   $0x803cd4
  801cc7:	e8 b0 e6 ff ff       	call   80037c <cprintf>
  801ccc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ccf:	83 ec 0c             	sub    $0xc,%esp
  801cd2:	68 48 3c 80 00       	push   $0x803c48
  801cd7:	e8 a0 e6 ff ff       	call   80037c <cprintf>
  801cdc:	83 c4 10             	add    $0x10,%esp

}
  801cdf:	90                   	nop
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ce8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801cef:	00 00 00 
  801cf2:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801cf9:	00 00 00 
  801cfc:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d03:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d0d:	e9 9e 00 00 00       	jmp    801db0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801d12:	a1 50 40 80 00       	mov    0x804050,%eax
  801d17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1a:	c1 e2 04             	shl    $0x4,%edx
  801d1d:	01 d0                	add    %edx,%eax
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	75 14                	jne    801d37 <initialize_MemBlocksList+0x55>
  801d23:	83 ec 04             	sub    $0x4,%esp
  801d26:	68 fc 3c 80 00       	push   $0x803cfc
  801d2b:	6a 46                	push   $0x46
  801d2d:	68 1f 3d 80 00       	push   $0x803d1f
  801d32:	e8 18 15 00 00       	call   80324f <_panic>
  801d37:	a1 50 40 80 00       	mov    0x804050,%eax
  801d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3f:	c1 e2 04             	shl    $0x4,%edx
  801d42:	01 d0                	add    %edx,%eax
  801d44:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801d4a:	89 10                	mov    %edx,(%eax)
  801d4c:	8b 00                	mov    (%eax),%eax
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	74 18                	je     801d6a <initialize_MemBlocksList+0x88>
  801d52:	a1 48 41 80 00       	mov    0x804148,%eax
  801d57:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d5d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d60:	c1 e1 04             	shl    $0x4,%ecx
  801d63:	01 ca                	add    %ecx,%edx
  801d65:	89 50 04             	mov    %edx,0x4(%eax)
  801d68:	eb 12                	jmp    801d7c <initialize_MemBlocksList+0x9a>
  801d6a:	a1 50 40 80 00       	mov    0x804050,%eax
  801d6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d72:	c1 e2 04             	shl    $0x4,%edx
  801d75:	01 d0                	add    %edx,%eax
  801d77:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d7c:	a1 50 40 80 00       	mov    0x804050,%eax
  801d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d84:	c1 e2 04             	shl    $0x4,%edx
  801d87:	01 d0                	add    %edx,%eax
  801d89:	a3 48 41 80 00       	mov    %eax,0x804148
  801d8e:	a1 50 40 80 00       	mov    0x804050,%eax
  801d93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d96:	c1 e2 04             	shl    $0x4,%edx
  801d99:	01 d0                	add    %edx,%eax
  801d9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801da2:	a1 54 41 80 00       	mov    0x804154,%eax
  801da7:	40                   	inc    %eax
  801da8:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801dad:	ff 45 f4             	incl   -0xc(%ebp)
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801db6:	0f 82 56 ff ff ff    	jb     801d12 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801dbc:	90                   	nop
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	8b 00                	mov    (%eax),%eax
  801dca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801dcd:	eb 19                	jmp    801de8 <find_block+0x29>
	{
		if(va==point->sva)
  801dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd2:	8b 40 08             	mov    0x8(%eax),%eax
  801dd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dd8:	75 05                	jne    801ddf <find_block+0x20>
		   return point;
  801dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ddd:	eb 36                	jmp    801e15 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	8b 40 08             	mov    0x8(%eax),%eax
  801de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801de8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dec:	74 07                	je     801df5 <find_block+0x36>
  801dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df1:	8b 00                	mov    (%eax),%eax
  801df3:	eb 05                	jmp    801dfa <find_block+0x3b>
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfd:	89 42 08             	mov    %eax,0x8(%edx)
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	8b 40 08             	mov    0x8(%eax),%eax
  801e06:	85 c0                	test   %eax,%eax
  801e08:	75 c5                	jne    801dcf <find_block+0x10>
  801e0a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e0e:	75 bf                	jne    801dcf <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801e1d:	a1 40 40 80 00       	mov    0x804040,%eax
  801e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801e25:	a1 44 40 80 00       	mov    0x804044,%eax
  801e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e33:	74 24                	je     801e59 <insert_sorted_allocList+0x42>
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	8b 50 08             	mov    0x8(%eax),%edx
  801e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3e:	8b 40 08             	mov    0x8(%eax),%eax
  801e41:	39 c2                	cmp    %eax,%edx
  801e43:	76 14                	jbe    801e59 <insert_sorted_allocList+0x42>
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	8b 50 08             	mov    0x8(%eax),%edx
  801e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4e:	8b 40 08             	mov    0x8(%eax),%eax
  801e51:	39 c2                	cmp    %eax,%edx
  801e53:	0f 82 60 01 00 00    	jb     801fb9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5d:	75 65                	jne    801ec4 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e63:	75 14                	jne    801e79 <insert_sorted_allocList+0x62>
  801e65:	83 ec 04             	sub    $0x4,%esp
  801e68:	68 fc 3c 80 00       	push   $0x803cfc
  801e6d:	6a 6b                	push   $0x6b
  801e6f:	68 1f 3d 80 00       	push   $0x803d1f
  801e74:	e8 d6 13 00 00       	call   80324f <_panic>
  801e79:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	89 10                	mov    %edx,(%eax)
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	8b 00                	mov    (%eax),%eax
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	74 0d                	je     801e9a <insert_sorted_allocList+0x83>
  801e8d:	a1 40 40 80 00       	mov    0x804040,%eax
  801e92:	8b 55 08             	mov    0x8(%ebp),%edx
  801e95:	89 50 04             	mov    %edx,0x4(%eax)
  801e98:	eb 08                	jmp    801ea2 <insert_sorted_allocList+0x8b>
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	a3 44 40 80 00       	mov    %eax,0x804044
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	a3 40 40 80 00       	mov    %eax,0x804040
  801eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ead:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801eb9:	40                   	inc    %eax
  801eba:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ebf:	e9 dc 01 00 00       	jmp    8020a0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8b 50 08             	mov    0x8(%eax),%edx
  801eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecd:	8b 40 08             	mov    0x8(%eax),%eax
  801ed0:	39 c2                	cmp    %eax,%edx
  801ed2:	77 6c                	ja     801f40 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801ed4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed8:	74 06                	je     801ee0 <insert_sorted_allocList+0xc9>
  801eda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ede:	75 14                	jne    801ef4 <insert_sorted_allocList+0xdd>
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 38 3d 80 00       	push   $0x803d38
  801ee8:	6a 6f                	push   $0x6f
  801eea:	68 1f 3d 80 00       	push   $0x803d1f
  801eef:	e8 5b 13 00 00       	call   80324f <_panic>
  801ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef7:	8b 50 04             	mov    0x4(%eax),%edx
  801efa:	8b 45 08             	mov    0x8(%ebp),%eax
  801efd:	89 50 04             	mov    %edx,0x4(%eax)
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f06:	89 10                	mov    %edx,(%eax)
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	8b 40 04             	mov    0x4(%eax),%eax
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	74 0d                	je     801f1f <insert_sorted_allocList+0x108>
  801f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f15:	8b 40 04             	mov    0x4(%eax),%eax
  801f18:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1b:	89 10                	mov    %edx,(%eax)
  801f1d:	eb 08                	jmp    801f27 <insert_sorted_allocList+0x110>
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	a3 40 40 80 00       	mov    %eax,0x804040
  801f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2d:	89 50 04             	mov    %edx,0x4(%eax)
  801f30:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f35:	40                   	inc    %eax
  801f36:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f3b:	e9 60 01 00 00       	jmp    8020a0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	8b 50 08             	mov    0x8(%eax),%edx
  801f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f49:	8b 40 08             	mov    0x8(%eax),%eax
  801f4c:	39 c2                	cmp    %eax,%edx
  801f4e:	0f 82 4c 01 00 00    	jb     8020a0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f58:	75 14                	jne    801f6e <insert_sorted_allocList+0x157>
  801f5a:	83 ec 04             	sub    $0x4,%esp
  801f5d:	68 70 3d 80 00       	push   $0x803d70
  801f62:	6a 73                	push   $0x73
  801f64:	68 1f 3d 80 00       	push   $0x803d1f
  801f69:	e8 e1 12 00 00       	call   80324f <_panic>
  801f6e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	89 50 04             	mov    %edx,0x4(%eax)
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	8b 40 04             	mov    0x4(%eax),%eax
  801f80:	85 c0                	test   %eax,%eax
  801f82:	74 0c                	je     801f90 <insert_sorted_allocList+0x179>
  801f84:	a1 44 40 80 00       	mov    0x804044,%eax
  801f89:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8c:	89 10                	mov    %edx,(%eax)
  801f8e:	eb 08                	jmp    801f98 <insert_sorted_allocList+0x181>
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	a3 40 40 80 00       	mov    %eax,0x804040
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	a3 44 40 80 00       	mov    %eax,0x804044
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fae:	40                   	inc    %eax
  801faf:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fb4:	e9 e7 00 00 00       	jmp    8020a0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801fbf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801fc6:	a1 40 40 80 00       	mov    0x804040,%eax
  801fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fce:	e9 9d 00 00 00       	jmp    802070 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	8b 00                	mov    (%eax),%eax
  801fd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	8b 50 08             	mov    0x8(%eax),%edx
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 40 08             	mov    0x8(%eax),%eax
  801fe7:	39 c2                	cmp    %eax,%edx
  801fe9:	76 7d                	jbe    802068 <insert_sorted_allocList+0x251>
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	8b 50 08             	mov    0x8(%eax),%edx
  801ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff4:	8b 40 08             	mov    0x8(%eax),%eax
  801ff7:	39 c2                	cmp    %eax,%edx
  801ff9:	73 6d                	jae    802068 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fff:	74 06                	je     802007 <insert_sorted_allocList+0x1f0>
  802001:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802005:	75 14                	jne    80201b <insert_sorted_allocList+0x204>
  802007:	83 ec 04             	sub    $0x4,%esp
  80200a:	68 94 3d 80 00       	push   $0x803d94
  80200f:	6a 7f                	push   $0x7f
  802011:	68 1f 3d 80 00       	push   $0x803d1f
  802016:	e8 34 12 00 00       	call   80324f <_panic>
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	8b 10                	mov    (%eax),%edx
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	89 10                	mov    %edx,(%eax)
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	8b 00                	mov    (%eax),%eax
  80202a:	85 c0                	test   %eax,%eax
  80202c:	74 0b                	je     802039 <insert_sorted_allocList+0x222>
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 00                	mov    (%eax),%eax
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
  802036:	89 50 04             	mov    %edx,0x4(%eax)
  802039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203c:	8b 55 08             	mov    0x8(%ebp),%edx
  80203f:	89 10                	mov    %edx,(%eax)
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802047:	89 50 04             	mov    %edx,0x4(%eax)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	8b 00                	mov    (%eax),%eax
  80204f:	85 c0                	test   %eax,%eax
  802051:	75 08                	jne    80205b <insert_sorted_allocList+0x244>
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	a3 44 40 80 00       	mov    %eax,0x804044
  80205b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802060:	40                   	inc    %eax
  802061:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802066:	eb 39                	jmp    8020a1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802068:	a1 48 40 80 00       	mov    0x804048,%eax
  80206d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802074:	74 07                	je     80207d <insert_sorted_allocList+0x266>
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	eb 05                	jmp    802082 <insert_sorted_allocList+0x26b>
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	a3 48 40 80 00       	mov    %eax,0x804048
  802087:	a1 48 40 80 00       	mov    0x804048,%eax
  80208c:	85 c0                	test   %eax,%eax
  80208e:	0f 85 3f ff ff ff    	jne    801fd3 <insert_sorted_allocList+0x1bc>
  802094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802098:	0f 85 35 ff ff ff    	jne    801fd3 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80209e:	eb 01                	jmp    8020a1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8020a1:	90                   	nop
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8020aa:	a1 38 41 80 00       	mov    0x804138,%eax
  8020af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b2:	e9 85 01 00 00       	jmp    80223c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c0:	0f 82 6e 01 00 00    	jb     802234 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020cf:	0f 85 8a 00 00 00    	jne    80215f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8020d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d9:	75 17                	jne    8020f2 <alloc_block_FF+0x4e>
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 c8 3d 80 00       	push   $0x803dc8
  8020e3:	68 93 00 00 00       	push   $0x93
  8020e8:	68 1f 3d 80 00       	push   $0x803d1f
  8020ed:	e8 5d 11 00 00       	call   80324f <_panic>
  8020f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	74 10                	je     80210b <alloc_block_FF+0x67>
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802103:	8b 52 04             	mov    0x4(%edx),%edx
  802106:	89 50 04             	mov    %edx,0x4(%eax)
  802109:	eb 0b                	jmp    802116 <alloc_block_FF+0x72>
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	8b 40 04             	mov    0x4(%eax),%eax
  802111:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802116:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802119:	8b 40 04             	mov    0x4(%eax),%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	74 0f                	je     80212f <alloc_block_FF+0x8b>
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 40 04             	mov    0x4(%eax),%eax
  802126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802129:	8b 12                	mov    (%edx),%edx
  80212b:	89 10                	mov    %edx,(%eax)
  80212d:	eb 0a                	jmp    802139 <alloc_block_FF+0x95>
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	a3 38 41 80 00       	mov    %eax,0x804138
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214c:	a1 44 41 80 00       	mov    0x804144,%eax
  802151:	48                   	dec    %eax
  802152:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	e9 10 01 00 00       	jmp    80226f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 40 0c             	mov    0xc(%eax),%eax
  802165:	3b 45 08             	cmp    0x8(%ebp),%eax
  802168:	0f 86 c6 00 00 00    	jbe    802234 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80216e:	a1 48 41 80 00       	mov    0x804148,%eax
  802173:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	8b 50 08             	mov    0x8(%eax),%edx
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802185:	8b 55 08             	mov    0x8(%ebp),%edx
  802188:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80218b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218f:	75 17                	jne    8021a8 <alloc_block_FF+0x104>
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 c8 3d 80 00       	push   $0x803dc8
  802199:	68 9b 00 00 00       	push   $0x9b
  80219e:	68 1f 3d 80 00       	push   $0x803d1f
  8021a3:	e8 a7 10 00 00       	call   80324f <_panic>
  8021a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ab:	8b 00                	mov    (%eax),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 10                	je     8021c1 <alloc_block_FF+0x11d>
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b9:	8b 52 04             	mov    0x4(%edx),%edx
  8021bc:	89 50 04             	mov    %edx,0x4(%eax)
  8021bf:	eb 0b                	jmp    8021cc <alloc_block_FF+0x128>
  8021c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c4:	8b 40 04             	mov    0x4(%eax),%eax
  8021c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cf:	8b 40 04             	mov    0x4(%eax),%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	74 0f                	je     8021e5 <alloc_block_FF+0x141>
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	8b 40 04             	mov    0x4(%eax),%eax
  8021dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021df:	8b 12                	mov    (%edx),%edx
  8021e1:	89 10                	mov    %edx,(%eax)
  8021e3:	eb 0a                	jmp    8021ef <alloc_block_FF+0x14b>
  8021e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802202:	a1 54 41 80 00       	mov    0x804154,%eax
  802207:	48                   	dec    %eax
  802208:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 50 08             	mov    0x8(%eax),%edx
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	01 c2                	add    %eax,%edx
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 40 0c             	mov    0xc(%eax),%eax
  802224:	2b 45 08             	sub    0x8(%ebp),%eax
  802227:	89 c2                	mov    %eax,%edx
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80222f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802232:	eb 3b                	jmp    80226f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802234:	a1 40 41 80 00       	mov    0x804140,%eax
  802239:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802240:	74 07                	je     802249 <alloc_block_FF+0x1a5>
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	eb 05                	jmp    80224e <alloc_block_FF+0x1aa>
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
  80224e:	a3 40 41 80 00       	mov    %eax,0x804140
  802253:	a1 40 41 80 00       	mov    0x804140,%eax
  802258:	85 c0                	test   %eax,%eax
  80225a:	0f 85 57 fe ff ff    	jne    8020b7 <alloc_block_FF+0x13>
  802260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802264:	0f 85 4d fe ff ff    	jne    8020b7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80226a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802277:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80227e:	a1 38 41 80 00       	mov    0x804138,%eax
  802283:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802286:	e9 df 00 00 00       	jmp    80236a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 0c             	mov    0xc(%eax),%eax
  802291:	3b 45 08             	cmp    0x8(%ebp),%eax
  802294:	0f 82 c8 00 00 00    	jb     802362 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a3:	0f 85 8a 00 00 00    	jne    802333 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8022a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ad:	75 17                	jne    8022c6 <alloc_block_BF+0x55>
  8022af:	83 ec 04             	sub    $0x4,%esp
  8022b2:	68 c8 3d 80 00       	push   $0x803dc8
  8022b7:	68 b7 00 00 00       	push   $0xb7
  8022bc:	68 1f 3d 80 00       	push   $0x803d1f
  8022c1:	e8 89 0f 00 00       	call   80324f <_panic>
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 10                	je     8022df <alloc_block_BF+0x6e>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d7:	8b 52 04             	mov    0x4(%edx),%edx
  8022da:	89 50 04             	mov    %edx,0x4(%eax)
  8022dd:	eb 0b                	jmp    8022ea <alloc_block_BF+0x79>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 40 04             	mov    0x4(%eax),%eax
  8022e5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 40 04             	mov    0x4(%eax),%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 0f                	je     802303 <alloc_block_BF+0x92>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 04             	mov    0x4(%eax),%eax
  8022fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fd:	8b 12                	mov    (%edx),%edx
  8022ff:	89 10                	mov    %edx,(%eax)
  802301:	eb 0a                	jmp    80230d <alloc_block_BF+0x9c>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	a3 38 41 80 00       	mov    %eax,0x804138
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802320:	a1 44 41 80 00       	mov    0x804144,%eax
  802325:	48                   	dec    %eax
  802326:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	e9 4d 01 00 00       	jmp    802480 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 0c             	mov    0xc(%eax),%eax
  802339:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233c:	76 24                	jbe    802362 <alloc_block_BF+0xf1>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 40 0c             	mov    0xc(%eax),%eax
  802344:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802347:	73 19                	jae    802362 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802349:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 0c             	mov    0xc(%eax),%eax
  802356:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 40 08             	mov    0x8(%eax),%eax
  80235f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802362:	a1 40 41 80 00       	mov    0x804140,%eax
  802367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236e:	74 07                	je     802377 <alloc_block_BF+0x106>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	eb 05                	jmp    80237c <alloc_block_BF+0x10b>
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
  80237c:	a3 40 41 80 00       	mov    %eax,0x804140
  802381:	a1 40 41 80 00       	mov    0x804140,%eax
  802386:	85 c0                	test   %eax,%eax
  802388:	0f 85 fd fe ff ff    	jne    80228b <alloc_block_BF+0x1a>
  80238e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802392:	0f 85 f3 fe ff ff    	jne    80228b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802398:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80239c:	0f 84 d9 00 00 00    	je     80247b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8023a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8023aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8023b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8023bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023c0:	75 17                	jne    8023d9 <alloc_block_BF+0x168>
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	68 c8 3d 80 00       	push   $0x803dc8
  8023ca:	68 c7 00 00 00       	push   $0xc7
  8023cf:	68 1f 3d 80 00       	push   $0x803d1f
  8023d4:	e8 76 0e 00 00       	call   80324f <_panic>
  8023d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	74 10                	je     8023f2 <alloc_block_BF+0x181>
  8023e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023ea:	8b 52 04             	mov    0x4(%edx),%edx
  8023ed:	89 50 04             	mov    %edx,0x4(%eax)
  8023f0:	eb 0b                	jmp    8023fd <alloc_block_BF+0x18c>
  8023f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f5:	8b 40 04             	mov    0x4(%eax),%eax
  8023f8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802400:	8b 40 04             	mov    0x4(%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 0f                	je     802416 <alloc_block_BF+0x1a5>
  802407:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240a:	8b 40 04             	mov    0x4(%eax),%eax
  80240d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802410:	8b 12                	mov    (%edx),%edx
  802412:	89 10                	mov    %edx,(%eax)
  802414:	eb 0a                	jmp    802420 <alloc_block_BF+0x1af>
  802416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	a3 48 41 80 00       	mov    %eax,0x804148
  802420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802429:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802433:	a1 54 41 80 00       	mov    0x804154,%eax
  802438:	48                   	dec    %eax
  802439:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80243e:	83 ec 08             	sub    $0x8,%esp
  802441:	ff 75 ec             	pushl  -0x14(%ebp)
  802444:	68 38 41 80 00       	push   $0x804138
  802449:	e8 71 f9 ff ff       	call   801dbf <find_block>
  80244e:	83 c4 10             	add    $0x10,%esp
  802451:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802457:	8b 50 08             	mov    0x8(%eax),%edx
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	01 c2                	add    %eax,%edx
  80245f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802462:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802465:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802468:	8b 40 0c             	mov    0xc(%eax),%eax
  80246b:	2b 45 08             	sub    0x8(%ebp),%eax
  80246e:	89 c2                	mov    %eax,%edx
  802470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802473:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802479:	eb 05                	jmp    802480 <alloc_block_BF+0x20f>
	}
	return NULL;
  80247b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802480:	c9                   	leave  
  802481:	c3                   	ret    

00802482 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802482:	55                   	push   %ebp
  802483:	89 e5                	mov    %esp,%ebp
  802485:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802488:	a1 28 40 80 00       	mov    0x804028,%eax
  80248d:	85 c0                	test   %eax,%eax
  80248f:	0f 85 de 01 00 00    	jne    802673 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802495:	a1 38 41 80 00       	mov    0x804138,%eax
  80249a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249d:	e9 9e 01 00 00       	jmp    802640 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ab:	0f 82 87 01 00 00    	jb     802638 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ba:	0f 85 95 00 00 00    	jne    802555 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8024c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c4:	75 17                	jne    8024dd <alloc_block_NF+0x5b>
  8024c6:	83 ec 04             	sub    $0x4,%esp
  8024c9:	68 c8 3d 80 00       	push   $0x803dc8
  8024ce:	68 e0 00 00 00       	push   $0xe0
  8024d3:	68 1f 3d 80 00       	push   $0x803d1f
  8024d8:	e8 72 0d 00 00       	call   80324f <_panic>
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	74 10                	je     8024f6 <alloc_block_NF+0x74>
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ee:	8b 52 04             	mov    0x4(%edx),%edx
  8024f1:	89 50 04             	mov    %edx,0x4(%eax)
  8024f4:	eb 0b                	jmp    802501 <alloc_block_NF+0x7f>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 40 04             	mov    0x4(%eax),%eax
  8024fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 40 04             	mov    0x4(%eax),%eax
  802507:	85 c0                	test   %eax,%eax
  802509:	74 0f                	je     80251a <alloc_block_NF+0x98>
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 40 04             	mov    0x4(%eax),%eax
  802511:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802514:	8b 12                	mov    (%edx),%edx
  802516:	89 10                	mov    %edx,(%eax)
  802518:	eb 0a                	jmp    802524 <alloc_block_NF+0xa2>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	a3 38 41 80 00       	mov    %eax,0x804138
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802537:	a1 44 41 80 00       	mov    0x804144,%eax
  80253c:	48                   	dec    %eax
  80253d:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 08             	mov    0x8(%eax),%eax
  802548:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	e9 f8 04 00 00       	jmp    802a4d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 40 0c             	mov    0xc(%eax),%eax
  80255b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255e:	0f 86 d4 00 00 00    	jbe    802638 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802564:	a1 48 41 80 00       	mov    0x804148,%eax
  802569:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 50 08             	mov    0x8(%eax),%edx
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257b:	8b 55 08             	mov    0x8(%ebp),%edx
  80257e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802581:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802585:	75 17                	jne    80259e <alloc_block_NF+0x11c>
  802587:	83 ec 04             	sub    $0x4,%esp
  80258a:	68 c8 3d 80 00       	push   $0x803dc8
  80258f:	68 e9 00 00 00       	push   $0xe9
  802594:	68 1f 3d 80 00       	push   $0x803d1f
  802599:	e8 b1 0c 00 00       	call   80324f <_panic>
  80259e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a1:	8b 00                	mov    (%eax),%eax
  8025a3:	85 c0                	test   %eax,%eax
  8025a5:	74 10                	je     8025b7 <alloc_block_NF+0x135>
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025af:	8b 52 04             	mov    0x4(%edx),%edx
  8025b2:	89 50 04             	mov    %edx,0x4(%eax)
  8025b5:	eb 0b                	jmp    8025c2 <alloc_block_NF+0x140>
  8025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c5:	8b 40 04             	mov    0x4(%eax),%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	74 0f                	je     8025db <alloc_block_NF+0x159>
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d5:	8b 12                	mov    (%edx),%edx
  8025d7:	89 10                	mov    %edx,(%eax)
  8025d9:	eb 0a                	jmp    8025e5 <alloc_block_NF+0x163>
  8025db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025de:	8b 00                	mov    (%eax),%eax
  8025e0:	a3 48 41 80 00       	mov    %eax,0x804148
  8025e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f8:	a1 54 41 80 00       	mov    0x804154,%eax
  8025fd:	48                   	dec    %eax
  8025fe:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	8b 40 08             	mov    0x8(%eax),%eax
  802609:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 50 08             	mov    0x8(%eax),%edx
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	01 c2                	add    %eax,%edx
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 0c             	mov    0xc(%eax),%eax
  802625:	2b 45 08             	sub    0x8(%ebp),%eax
  802628:	89 c2                	mov    %eax,%edx
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	e9 15 04 00 00       	jmp    802a4d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802638:	a1 40 41 80 00       	mov    0x804140,%eax
  80263d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802644:	74 07                	je     80264d <alloc_block_NF+0x1cb>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	eb 05                	jmp    802652 <alloc_block_NF+0x1d0>
  80264d:	b8 00 00 00 00       	mov    $0x0,%eax
  802652:	a3 40 41 80 00       	mov    %eax,0x804140
  802657:	a1 40 41 80 00       	mov    0x804140,%eax
  80265c:	85 c0                	test   %eax,%eax
  80265e:	0f 85 3e fe ff ff    	jne    8024a2 <alloc_block_NF+0x20>
  802664:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802668:	0f 85 34 fe ff ff    	jne    8024a2 <alloc_block_NF+0x20>
  80266e:	e9 d5 03 00 00       	jmp    802a48 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802673:	a1 38 41 80 00       	mov    0x804138,%eax
  802678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267b:	e9 b1 01 00 00       	jmp    802831 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 50 08             	mov    0x8(%eax),%edx
  802686:	a1 28 40 80 00       	mov    0x804028,%eax
  80268b:	39 c2                	cmp    %eax,%edx
  80268d:	0f 82 96 01 00 00    	jb     802829 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	8b 40 0c             	mov    0xc(%eax),%eax
  802699:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269c:	0f 82 87 01 00 00    	jb     802829 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8026a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ab:	0f 85 95 00 00 00    	jne    802746 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8026b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b5:	75 17                	jne    8026ce <alloc_block_NF+0x24c>
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 c8 3d 80 00       	push   $0x803dc8
  8026bf:	68 fc 00 00 00       	push   $0xfc
  8026c4:	68 1f 3d 80 00       	push   $0x803d1f
  8026c9:	e8 81 0b 00 00       	call   80324f <_panic>
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 00                	mov    (%eax),%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	74 10                	je     8026e7 <alloc_block_NF+0x265>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026df:	8b 52 04             	mov    0x4(%edx),%edx
  8026e2:	89 50 04             	mov    %edx,0x4(%eax)
  8026e5:	eb 0b                	jmp    8026f2 <alloc_block_NF+0x270>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 0f                	je     80270b <alloc_block_NF+0x289>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802705:	8b 12                	mov    (%edx),%edx
  802707:	89 10                	mov    %edx,(%eax)
  802709:	eb 0a                	jmp    802715 <alloc_block_NF+0x293>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	a3 38 41 80 00       	mov    %eax,0x804138
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802728:	a1 44 41 80 00       	mov    0x804144,%eax
  80272d:	48                   	dec    %eax
  80272e:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 08             	mov    0x8(%eax),%eax
  802739:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	e9 07 03 00 00       	jmp    802a4d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 0c             	mov    0xc(%eax),%eax
  80274c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274f:	0f 86 d4 00 00 00    	jbe    802829 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802755:	a1 48 41 80 00       	mov    0x804148,%eax
  80275a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 50 08             	mov    0x8(%eax),%edx
  802763:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802766:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276c:	8b 55 08             	mov    0x8(%ebp),%edx
  80276f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802772:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802776:	75 17                	jne    80278f <alloc_block_NF+0x30d>
  802778:	83 ec 04             	sub    $0x4,%esp
  80277b:	68 c8 3d 80 00       	push   $0x803dc8
  802780:	68 04 01 00 00       	push   $0x104
  802785:	68 1f 3d 80 00       	push   $0x803d1f
  80278a:	e8 c0 0a 00 00       	call   80324f <_panic>
  80278f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	74 10                	je     8027a8 <alloc_block_NF+0x326>
  802798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027a0:	8b 52 04             	mov    0x4(%edx),%edx
  8027a3:	89 50 04             	mov    %edx,0x4(%eax)
  8027a6:	eb 0b                	jmp    8027b3 <alloc_block_NF+0x331>
  8027a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	74 0f                	je     8027cc <alloc_block_NF+0x34a>
  8027bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c0:	8b 40 04             	mov    0x4(%eax),%eax
  8027c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027c6:	8b 12                	mov    (%edx),%edx
  8027c8:	89 10                	mov    %edx,(%eax)
  8027ca:	eb 0a                	jmp    8027d6 <alloc_block_NF+0x354>
  8027cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	a3 48 41 80 00       	mov    %eax,0x804148
  8027d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e9:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ee:	48                   	dec    %eax
  8027ef:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8027f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f7:	8b 40 08             	mov    0x8(%eax),%eax
  8027fa:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 50 08             	mov    0x8(%eax),%edx
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	01 c2                	add    %eax,%edx
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 0c             	mov    0xc(%eax),%eax
  802816:	2b 45 08             	sub    0x8(%ebp),%eax
  802819:	89 c2                	mov    %eax,%edx
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802821:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802824:	e9 24 02 00 00       	jmp    802a4d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802829:	a1 40 41 80 00       	mov    0x804140,%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	74 07                	je     80283e <alloc_block_NF+0x3bc>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	eb 05                	jmp    802843 <alloc_block_NF+0x3c1>
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
  802843:	a3 40 41 80 00       	mov    %eax,0x804140
  802848:	a1 40 41 80 00       	mov    0x804140,%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	0f 85 2b fe ff ff    	jne    802680 <alloc_block_NF+0x1fe>
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	0f 85 21 fe ff ff    	jne    802680 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80285f:	a1 38 41 80 00       	mov    0x804138,%eax
  802864:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802867:	e9 ae 01 00 00       	jmp    802a1a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 50 08             	mov    0x8(%eax),%edx
  802872:	a1 28 40 80 00       	mov    0x804028,%eax
  802877:	39 c2                	cmp    %eax,%edx
  802879:	0f 83 93 01 00 00    	jae    802a12 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	8b 40 0c             	mov    0xc(%eax),%eax
  802885:	3b 45 08             	cmp    0x8(%ebp),%eax
  802888:	0f 82 84 01 00 00    	jb     802a12 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 0c             	mov    0xc(%eax),%eax
  802894:	3b 45 08             	cmp    0x8(%ebp),%eax
  802897:	0f 85 95 00 00 00    	jne    802932 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80289d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a1:	75 17                	jne    8028ba <alloc_block_NF+0x438>
  8028a3:	83 ec 04             	sub    $0x4,%esp
  8028a6:	68 c8 3d 80 00       	push   $0x803dc8
  8028ab:	68 14 01 00 00       	push   $0x114
  8028b0:	68 1f 3d 80 00       	push   $0x803d1f
  8028b5:	e8 95 09 00 00       	call   80324f <_panic>
  8028ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bd:	8b 00                	mov    (%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	74 10                	je     8028d3 <alloc_block_NF+0x451>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	8b 52 04             	mov    0x4(%edx),%edx
  8028ce:	89 50 04             	mov    %edx,0x4(%eax)
  8028d1:	eb 0b                	jmp    8028de <alloc_block_NF+0x45c>
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 40 04             	mov    0x4(%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	74 0f                	je     8028f7 <alloc_block_NF+0x475>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f1:	8b 12                	mov    (%edx),%edx
  8028f3:	89 10                	mov    %edx,(%eax)
  8028f5:	eb 0a                	jmp    802901 <alloc_block_NF+0x47f>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802914:	a1 44 41 80 00       	mov    0x804144,%eax
  802919:	48                   	dec    %eax
  80291a:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 08             	mov    0x8(%eax),%eax
  802925:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	e9 1b 01 00 00       	jmp    802a4d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802935:	8b 40 0c             	mov    0xc(%eax),%eax
  802938:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293b:	0f 86 d1 00 00 00    	jbe    802a12 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802941:	a1 48 41 80 00       	mov    0x804148,%eax
  802946:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 50 08             	mov    0x8(%eax),%edx
  80294f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802952:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802958:	8b 55 08             	mov    0x8(%ebp),%edx
  80295b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80295e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802962:	75 17                	jne    80297b <alloc_block_NF+0x4f9>
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 c8 3d 80 00       	push   $0x803dc8
  80296c:	68 1c 01 00 00       	push   $0x11c
  802971:	68 1f 3d 80 00       	push   $0x803d1f
  802976:	e8 d4 08 00 00       	call   80324f <_panic>
  80297b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 10                	je     802994 <alloc_block_NF+0x512>
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80298c:	8b 52 04             	mov    0x4(%edx),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	eb 0b                	jmp    80299f <alloc_block_NF+0x51d>
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80299f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 0f                	je     8029b8 <alloc_block_NF+0x536>
  8029a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ac:	8b 40 04             	mov    0x4(%eax),%eax
  8029af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b2:	8b 12                	mov    (%edx),%edx
  8029b4:	89 10                	mov    %edx,(%eax)
  8029b6:	eb 0a                	jmp    8029c2 <alloc_block_NF+0x540>
  8029b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	a3 48 41 80 00       	mov    %eax,0x804148
  8029c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d5:	a1 54 41 80 00       	mov    0x804154,%eax
  8029da:	48                   	dec    %eax
  8029db:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	01 c2                	add    %eax,%edx
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	2b 45 08             	sub    0x8(%ebp),%eax
  802a05:	89 c2                	mov    %eax,%edx
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	eb 3b                	jmp    802a4d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a12:	a1 40 41 80 00       	mov    0x804140,%eax
  802a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1e:	74 07                	je     802a27 <alloc_block_NF+0x5a5>
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	eb 05                	jmp    802a2c <alloc_block_NF+0x5aa>
  802a27:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2c:	a3 40 41 80 00       	mov    %eax,0x804140
  802a31:	a1 40 41 80 00       	mov    0x804140,%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	0f 85 2e fe ff ff    	jne    80286c <alloc_block_NF+0x3ea>
  802a3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a42:	0f 85 24 fe ff ff    	jne    80286c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a55:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a5d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a62:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a65:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6a:	85 c0                	test   %eax,%eax
  802a6c:	74 14                	je     802a82 <insert_sorted_with_merge_freeList+0x33>
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 50 08             	mov    0x8(%eax),%edx
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	39 c2                	cmp    %eax,%edx
  802a7c:	0f 87 9b 01 00 00    	ja     802c1d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a86:	75 17                	jne    802a9f <insert_sorted_with_merge_freeList+0x50>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 fc 3c 80 00       	push   $0x803cfc
  802a90:	68 38 01 00 00       	push   $0x138
  802a95:	68 1f 3d 80 00       	push   $0x803d1f
  802a9a:	e8 b0 07 00 00       	call   80324f <_panic>
  802a9f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	8b 00                	mov    (%eax),%eax
  802aaf:	85 c0                	test   %eax,%eax
  802ab1:	74 0d                	je     802ac0 <insert_sorted_with_merge_freeList+0x71>
  802ab3:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab8:	8b 55 08             	mov    0x8(%ebp),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 08                	jmp    802ac8 <insert_sorted_with_merge_freeList+0x79>
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	a3 38 41 80 00       	mov    %eax,0x804138
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 44 41 80 00       	mov    0x804144,%eax
  802adf:	40                   	inc    %eax
  802ae0:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ae5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae9:	0f 84 a8 06 00 00    	je     803197 <insert_sorted_with_merge_freeList+0x748>
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	8b 50 08             	mov    0x8(%eax),%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	8b 40 0c             	mov    0xc(%eax),%eax
  802afb:	01 c2                	add    %eax,%edx
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	39 c2                	cmp    %eax,%edx
  802b05:	0f 85 8c 06 00 00    	jne    803197 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 40 0c             	mov    0xc(%eax),%eax
  802b17:	01 c2                	add    %eax,%edx
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802b1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b23:	75 17                	jne    802b3c <insert_sorted_with_merge_freeList+0xed>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 c8 3d 80 00       	push   $0x803dc8
  802b2d:	68 3c 01 00 00       	push   $0x13c
  802b32:	68 1f 3d 80 00       	push   $0x803d1f
  802b37:	e8 13 07 00 00       	call   80324f <_panic>
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 10                	je     802b55 <insert_sorted_with_merge_freeList+0x106>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4d:	8b 52 04             	mov    0x4(%edx),%edx
  802b50:	89 50 04             	mov    %edx,0x4(%eax)
  802b53:	eb 0b                	jmp    802b60 <insert_sorted_with_merge_freeList+0x111>
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b63:	8b 40 04             	mov    0x4(%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0f                	je     802b79 <insert_sorted_with_merge_freeList+0x12a>
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 40 04             	mov    0x4(%eax),%eax
  802b70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b73:	8b 12                	mov    (%edx),%edx
  802b75:	89 10                	mov    %edx,(%eax)
  802b77:	eb 0a                	jmp    802b83 <insert_sorted_with_merge_freeList+0x134>
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	a3 38 41 80 00       	mov    %eax,0x804138
  802b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b96:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9b:	48                   	dec    %eax
  802b9c:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802bb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb9:	75 17                	jne    802bd2 <insert_sorted_with_merge_freeList+0x183>
  802bbb:	83 ec 04             	sub    $0x4,%esp
  802bbe:	68 fc 3c 80 00       	push   $0x803cfc
  802bc3:	68 3f 01 00 00       	push   $0x13f
  802bc8:	68 1f 3d 80 00       	push   $0x803d1f
  802bcd:	e8 7d 06 00 00       	call   80324f <_panic>
  802bd2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdb:	89 10                	mov    %edx,(%eax)
  802bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 0d                	je     802bf3 <insert_sorted_with_merge_freeList+0x1a4>
  802be6:	a1 48 41 80 00       	mov    0x804148,%eax
  802beb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bee:	89 50 04             	mov    %edx,0x4(%eax)
  802bf1:	eb 08                	jmp    802bfb <insert_sorted_with_merge_freeList+0x1ac>
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	a3 48 41 80 00       	mov    %eax,0x804148
  802c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0d:	a1 54 41 80 00       	mov    0x804154,%eax
  802c12:	40                   	inc    %eax
  802c13:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c18:	e9 7a 05 00 00       	jmp    803197 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	8b 50 08             	mov    0x8(%eax),%edx
  802c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c26:	8b 40 08             	mov    0x8(%eax),%eax
  802c29:	39 c2                	cmp    %eax,%edx
  802c2b:	0f 82 14 01 00 00    	jb     802d45 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3d:	01 c2                	add    %eax,%edx
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	8b 40 08             	mov    0x8(%eax),%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 85 90 00 00 00    	jne    802cdd <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 50 0c             	mov    0xc(%eax),%edx
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 40 0c             	mov    0xc(%eax),%eax
  802c59:	01 c2                	add    %eax,%edx
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c79:	75 17                	jne    802c92 <insert_sorted_with_merge_freeList+0x243>
  802c7b:	83 ec 04             	sub    $0x4,%esp
  802c7e:	68 fc 3c 80 00       	push   $0x803cfc
  802c83:	68 49 01 00 00       	push   $0x149
  802c88:	68 1f 3d 80 00       	push   $0x803d1f
  802c8d:	e8 bd 05 00 00       	call   80324f <_panic>
  802c92:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	89 10                	mov    %edx,(%eax)
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	85 c0                	test   %eax,%eax
  802ca4:	74 0d                	je     802cb3 <insert_sorted_with_merge_freeList+0x264>
  802ca6:	a1 48 41 80 00       	mov    0x804148,%eax
  802cab:	8b 55 08             	mov    0x8(%ebp),%edx
  802cae:	89 50 04             	mov    %edx,0x4(%eax)
  802cb1:	eb 08                	jmp    802cbb <insert_sorted_with_merge_freeList+0x26c>
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	a3 48 41 80 00       	mov    %eax,0x804148
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccd:	a1 54 41 80 00       	mov    0x804154,%eax
  802cd2:	40                   	inc    %eax
  802cd3:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cd8:	e9 bb 04 00 00       	jmp    803198 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802cdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce1:	75 17                	jne    802cfa <insert_sorted_with_merge_freeList+0x2ab>
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	68 70 3d 80 00       	push   $0x803d70
  802ceb:	68 4c 01 00 00       	push   $0x14c
  802cf0:	68 1f 3d 80 00       	push   $0x803d1f
  802cf5:	e8 55 05 00 00       	call   80324f <_panic>
  802cfa:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 0c                	je     802d1c <insert_sorted_with_merge_freeList+0x2cd>
  802d10:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d15:	8b 55 08             	mov    0x8(%ebp),%edx
  802d18:	89 10                	mov    %edx,(%eax)
  802d1a:	eb 08                	jmp    802d24 <insert_sorted_with_merge_freeList+0x2d5>
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	a3 38 41 80 00       	mov    %eax,0x804138
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d35:	a1 44 41 80 00       	mov    0x804144,%eax
  802d3a:	40                   	inc    %eax
  802d3b:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d40:	e9 53 04 00 00       	jmp    803198 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802d45:	a1 38 41 80 00       	mov    0x804138,%eax
  802d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4d:	e9 15 04 00 00       	jmp    803167 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 00                	mov    (%eax),%eax
  802d57:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	8b 50 08             	mov    0x8(%eax),%edx
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 08             	mov    0x8(%eax),%eax
  802d66:	39 c2                	cmp    %eax,%edx
  802d68:	0f 86 f1 03 00 00    	jbe    80315f <insert_sorted_with_merge_freeList+0x710>
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 50 08             	mov    0x8(%eax),%edx
  802d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d77:	8b 40 08             	mov    0x8(%eax),%eax
  802d7a:	39 c2                	cmp    %eax,%edx
  802d7c:	0f 83 dd 03 00 00    	jae    80315f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	01 c2                	add    %eax,%edx
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	39 c2                	cmp    %eax,%edx
  802d98:	0f 85 b9 01 00 00    	jne    802f57 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	8b 50 08             	mov    0x8(%eax),%edx
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	8b 40 0c             	mov    0xc(%eax),%eax
  802daa:	01 c2                	add    %eax,%edx
  802dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daf:	8b 40 08             	mov    0x8(%eax),%eax
  802db2:	39 c2                	cmp    %eax,%edx
  802db4:	0f 85 0d 01 00 00    	jne    802ec7 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c2                	add    %eax,%edx
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802dce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dd2:	75 17                	jne    802deb <insert_sorted_with_merge_freeList+0x39c>
  802dd4:	83 ec 04             	sub    $0x4,%esp
  802dd7:	68 c8 3d 80 00       	push   $0x803dc8
  802ddc:	68 5c 01 00 00       	push   $0x15c
  802de1:	68 1f 3d 80 00       	push   $0x803d1f
  802de6:	e8 64 04 00 00       	call   80324f <_panic>
  802deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 10                	je     802e04 <insert_sorted_with_merge_freeList+0x3b5>
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dfc:	8b 52 04             	mov    0x4(%edx),%edx
  802dff:	89 50 04             	mov    %edx,0x4(%eax)
  802e02:	eb 0b                	jmp    802e0f <insert_sorted_with_merge_freeList+0x3c0>
  802e04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e07:	8b 40 04             	mov    0x4(%eax),%eax
  802e0a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e12:	8b 40 04             	mov    0x4(%eax),%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	74 0f                	je     802e28 <insert_sorted_with_merge_freeList+0x3d9>
  802e19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e22:	8b 12                	mov    (%edx),%edx
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	eb 0a                	jmp    802e32 <insert_sorted_with_merge_freeList+0x3e3>
  802e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	a3 38 41 80 00       	mov    %eax,0x804138
  802e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e45:	a1 44 41 80 00       	mov    0x804144,%eax
  802e4a:	48                   	dec    %eax
  802e4b:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e68:	75 17                	jne    802e81 <insert_sorted_with_merge_freeList+0x432>
  802e6a:	83 ec 04             	sub    $0x4,%esp
  802e6d:	68 fc 3c 80 00       	push   $0x803cfc
  802e72:	68 5f 01 00 00       	push   $0x15f
  802e77:	68 1f 3d 80 00       	push   $0x803d1f
  802e7c:	e8 ce 03 00 00       	call   80324f <_panic>
  802e81:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8a:	89 10                	mov    %edx,(%eax)
  802e8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	85 c0                	test   %eax,%eax
  802e93:	74 0d                	je     802ea2 <insert_sorted_with_merge_freeList+0x453>
  802e95:	a1 48 41 80 00       	mov    0x804148,%eax
  802e9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	eb 08                	jmp    802eaa <insert_sorted_with_merge_freeList+0x45b>
  802ea2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ead:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebc:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec1:	40                   	inc    %eax
  802ec2:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed3:	01 c2                	add    %eax,%edx
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef3:	75 17                	jne    802f0c <insert_sorted_with_merge_freeList+0x4bd>
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	68 fc 3c 80 00       	push   $0x803cfc
  802efd:	68 64 01 00 00       	push   $0x164
  802f02:	68 1f 3d 80 00       	push   $0x803d1f
  802f07:	e8 43 03 00 00       	call   80324f <_panic>
  802f0c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	89 10                	mov    %edx,(%eax)
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	74 0d                	je     802f2d <insert_sorted_with_merge_freeList+0x4de>
  802f20:	a1 48 41 80 00       	mov    0x804148,%eax
  802f25:	8b 55 08             	mov    0x8(%ebp),%edx
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	eb 08                	jmp    802f35 <insert_sorted_with_merge_freeList+0x4e6>
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	a3 48 41 80 00       	mov    %eax,0x804148
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f47:	a1 54 41 80 00       	mov    0x804154,%eax
  802f4c:	40                   	inc    %eax
  802f4d:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f52:	e9 41 02 00 00       	jmp    803198 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	8b 50 08             	mov    0x8(%eax),%edx
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 40 0c             	mov    0xc(%eax),%eax
  802f63:	01 c2                	add    %eax,%edx
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	8b 40 08             	mov    0x8(%eax),%eax
  802f6b:	39 c2                	cmp    %eax,%edx
  802f6d:	0f 85 7c 01 00 00    	jne    8030ef <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f77:	74 06                	je     802f7f <insert_sorted_with_merge_freeList+0x530>
  802f79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7d:	75 17                	jne    802f96 <insert_sorted_with_merge_freeList+0x547>
  802f7f:	83 ec 04             	sub    $0x4,%esp
  802f82:	68 38 3d 80 00       	push   $0x803d38
  802f87:	68 69 01 00 00       	push   $0x169
  802f8c:	68 1f 3d 80 00       	push   $0x803d1f
  802f91:	e8 b9 02 00 00       	call   80324f <_panic>
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 50 04             	mov    0x4(%eax),%edx
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa8:	89 10                	mov    %edx,(%eax)
  802faa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fad:	8b 40 04             	mov    0x4(%eax),%eax
  802fb0:	85 c0                	test   %eax,%eax
  802fb2:	74 0d                	je     802fc1 <insert_sorted_with_merge_freeList+0x572>
  802fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb7:	8b 40 04             	mov    0x4(%eax),%eax
  802fba:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	eb 08                	jmp    802fc9 <insert_sorted_with_merge_freeList+0x57a>
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	a3 38 41 80 00       	mov    %eax,0x804138
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fcf:	89 50 04             	mov    %edx,0x4(%eax)
  802fd2:	a1 44 41 80 00       	mov    0x804144,%eax
  802fd7:	40                   	inc    %eax
  802fd8:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe0:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe9:	01 c2                	add    %eax,%edx
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ff1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff5:	75 17                	jne    80300e <insert_sorted_with_merge_freeList+0x5bf>
  802ff7:	83 ec 04             	sub    $0x4,%esp
  802ffa:	68 c8 3d 80 00       	push   $0x803dc8
  802fff:	68 6b 01 00 00       	push   $0x16b
  803004:	68 1f 3d 80 00       	push   $0x803d1f
  803009:	e8 41 02 00 00       	call   80324f <_panic>
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 10                	je     803027 <insert_sorted_with_merge_freeList+0x5d8>
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301f:	8b 52 04             	mov    0x4(%edx),%edx
  803022:	89 50 04             	mov    %edx,0x4(%eax)
  803025:	eb 0b                	jmp    803032 <insert_sorted_with_merge_freeList+0x5e3>
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 40 04             	mov    0x4(%eax),%eax
  80302d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803032:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803035:	8b 40 04             	mov    0x4(%eax),%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	74 0f                	je     80304b <insert_sorted_with_merge_freeList+0x5fc>
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	8b 40 04             	mov    0x4(%eax),%eax
  803042:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803045:	8b 12                	mov    (%edx),%edx
  803047:	89 10                	mov    %edx,(%eax)
  803049:	eb 0a                	jmp    803055 <insert_sorted_with_merge_freeList+0x606>
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	8b 00                	mov    (%eax),%eax
  803050:	a3 38 41 80 00       	mov    %eax,0x804138
  803055:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803068:	a1 44 41 80 00       	mov    0x804144,%eax
  80306d:	48                   	dec    %eax
  80306e:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80307d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803080:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803087:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308b:	75 17                	jne    8030a4 <insert_sorted_with_merge_freeList+0x655>
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 fc 3c 80 00       	push   $0x803cfc
  803095:	68 6e 01 00 00       	push   $0x16e
  80309a:	68 1f 3d 80 00       	push   $0x803d1f
  80309f:	e8 ab 01 00 00       	call   80324f <_panic>
  8030a4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	74 0d                	je     8030c5 <insert_sorted_with_merge_freeList+0x676>
  8030b8:	a1 48 41 80 00       	mov    0x804148,%eax
  8030bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	eb 08                	jmp    8030cd <insert_sorted_with_merge_freeList+0x67e>
  8030c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030df:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e4:	40                   	inc    %eax
  8030e5:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030ea:	e9 a9 00 00 00       	jmp    803198 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8030ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f3:	74 06                	je     8030fb <insert_sorted_with_merge_freeList+0x6ac>
  8030f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f9:	75 17                	jne    803112 <insert_sorted_with_merge_freeList+0x6c3>
  8030fb:	83 ec 04             	sub    $0x4,%esp
  8030fe:	68 94 3d 80 00       	push   $0x803d94
  803103:	68 73 01 00 00       	push   $0x173
  803108:	68 1f 3d 80 00       	push   $0x803d1f
  80310d:	e8 3d 01 00 00       	call   80324f <_panic>
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 10                	mov    (%eax),%edx
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	89 10                	mov    %edx,(%eax)
  80311c:	8b 45 08             	mov    0x8(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	74 0b                	je     803130 <insert_sorted_with_merge_freeList+0x6e1>
  803125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803128:	8b 00                	mov    (%eax),%eax
  80312a:	8b 55 08             	mov    0x8(%ebp),%edx
  80312d:	89 50 04             	mov    %edx,0x4(%eax)
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 55 08             	mov    0x8(%ebp),%edx
  803136:	89 10                	mov    %edx,(%eax)
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313e:	89 50 04             	mov    %edx,0x4(%eax)
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	8b 00                	mov    (%eax),%eax
  803146:	85 c0                	test   %eax,%eax
  803148:	75 08                	jne    803152 <insert_sorted_with_merge_freeList+0x703>
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803152:	a1 44 41 80 00       	mov    0x804144,%eax
  803157:	40                   	inc    %eax
  803158:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80315d:	eb 39                	jmp    803198 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80315f:	a1 40 41 80 00       	mov    0x804140,%eax
  803164:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803167:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316b:	74 07                	je     803174 <insert_sorted_with_merge_freeList+0x725>
  80316d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	eb 05                	jmp    803179 <insert_sorted_with_merge_freeList+0x72a>
  803174:	b8 00 00 00 00       	mov    $0x0,%eax
  803179:	a3 40 41 80 00       	mov    %eax,0x804140
  80317e:	a1 40 41 80 00       	mov    0x804140,%eax
  803183:	85 c0                	test   %eax,%eax
  803185:	0f 85 c7 fb ff ff    	jne    802d52 <insert_sorted_with_merge_freeList+0x303>
  80318b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318f:	0f 85 bd fb ff ff    	jne    802d52 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803195:	eb 01                	jmp    803198 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803197:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803198:	90                   	nop
  803199:	c9                   	leave  
  80319a:	c3                   	ret    

0080319b <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80319b:	55                   	push   %ebp
  80319c:	89 e5                	mov    %esp,%ebp
  80319e:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8031a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a4:	89 d0                	mov    %edx,%eax
  8031a6:	c1 e0 02             	shl    $0x2,%eax
  8031a9:	01 d0                	add    %edx,%eax
  8031ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031b2:	01 d0                	add    %edx,%eax
  8031b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031bb:	01 d0                	add    %edx,%eax
  8031bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031c4:	01 d0                	add    %edx,%eax
  8031c6:	c1 e0 04             	shl    $0x4,%eax
  8031c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8031d3:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8031d6:	83 ec 0c             	sub    $0xc,%esp
  8031d9:	50                   	push   %eax
  8031da:	e8 26 e7 ff ff       	call   801905 <sys_get_virtual_time>
  8031df:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8031e2:	eb 41                	jmp    803225 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8031e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031e7:	83 ec 0c             	sub    $0xc,%esp
  8031ea:	50                   	push   %eax
  8031eb:	e8 15 e7 ff ff       	call   801905 <sys_get_virtual_time>
  8031f0:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8031f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f9:	29 c2                	sub    %eax,%edx
  8031fb:	89 d0                	mov    %edx,%eax
  8031fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803203:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803206:	89 d1                	mov    %edx,%ecx
  803208:	29 c1                	sub    %eax,%ecx
  80320a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80320d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803210:	39 c2                	cmp    %eax,%edx
  803212:	0f 97 c0             	seta   %al
  803215:	0f b6 c0             	movzbl %al,%eax
  803218:	29 c1                	sub    %eax,%ecx
  80321a:	89 c8                	mov    %ecx,%eax
  80321c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80321f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803222:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80322b:	72 b7                	jb     8031e4 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80322d:	90                   	nop
  80322e:	c9                   	leave  
  80322f:	c3                   	ret    

00803230 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
  803233:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803236:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80323d:	eb 03                	jmp    803242 <busy_wait+0x12>
  80323f:	ff 45 fc             	incl   -0x4(%ebp)
  803242:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803245:	3b 45 08             	cmp    0x8(%ebp),%eax
  803248:	72 f5                	jb     80323f <busy_wait+0xf>
	return i;
  80324a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80324d:	c9                   	leave  
  80324e:	c3                   	ret    

0080324f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80324f:	55                   	push   %ebp
  803250:	89 e5                	mov    %esp,%ebp
  803252:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803255:	8d 45 10             	lea    0x10(%ebp),%eax
  803258:	83 c0 04             	add    $0x4,%eax
  80325b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80325e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803263:	85 c0                	test   %eax,%eax
  803265:	74 16                	je     80327d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803267:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80326c:	83 ec 08             	sub    $0x8,%esp
  80326f:	50                   	push   %eax
  803270:	68 e8 3d 80 00       	push   $0x803de8
  803275:	e8 02 d1 ff ff       	call   80037c <cprintf>
  80327a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80327d:	a1 00 40 80 00       	mov    0x804000,%eax
  803282:	ff 75 0c             	pushl  0xc(%ebp)
  803285:	ff 75 08             	pushl  0x8(%ebp)
  803288:	50                   	push   %eax
  803289:	68 ed 3d 80 00       	push   $0x803ded
  80328e:	e8 e9 d0 ff ff       	call   80037c <cprintf>
  803293:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803296:	8b 45 10             	mov    0x10(%ebp),%eax
  803299:	83 ec 08             	sub    $0x8,%esp
  80329c:	ff 75 f4             	pushl  -0xc(%ebp)
  80329f:	50                   	push   %eax
  8032a0:	e8 6c d0 ff ff       	call   800311 <vcprintf>
  8032a5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8032a8:	83 ec 08             	sub    $0x8,%esp
  8032ab:	6a 00                	push   $0x0
  8032ad:	68 09 3e 80 00       	push   $0x803e09
  8032b2:	e8 5a d0 ff ff       	call   800311 <vcprintf>
  8032b7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8032ba:	e8 db cf ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  8032bf:	eb fe                	jmp    8032bf <_panic+0x70>

008032c1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
  8032c4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8032cc:	8b 50 74             	mov    0x74(%eax),%edx
  8032cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d2:	39 c2                	cmp    %eax,%edx
  8032d4:	74 14                	je     8032ea <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 0c 3e 80 00       	push   $0x803e0c
  8032de:	6a 26                	push   $0x26
  8032e0:	68 58 3e 80 00       	push   $0x803e58
  8032e5:	e8 65 ff ff ff       	call   80324f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032f8:	e9 c2 00 00 00       	jmp    8033bf <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	01 d0                	add    %edx,%eax
  80330c:	8b 00                	mov    (%eax),%eax
  80330e:	85 c0                	test   %eax,%eax
  803310:	75 08                	jne    80331a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803312:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803315:	e9 a2 00 00 00       	jmp    8033bc <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80331a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803321:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803328:	eb 69                	jmp    803393 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80332a:	a1 20 40 80 00       	mov    0x804020,%eax
  80332f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803335:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803338:	89 d0                	mov    %edx,%eax
  80333a:	01 c0                	add    %eax,%eax
  80333c:	01 d0                	add    %edx,%eax
  80333e:	c1 e0 03             	shl    $0x3,%eax
  803341:	01 c8                	add    %ecx,%eax
  803343:	8a 40 04             	mov    0x4(%eax),%al
  803346:	84 c0                	test   %al,%al
  803348:	75 46                	jne    803390 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80334a:	a1 20 40 80 00       	mov    0x804020,%eax
  80334f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803355:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803358:	89 d0                	mov    %edx,%eax
  80335a:	01 c0                	add    %eax,%eax
  80335c:	01 d0                	add    %edx,%eax
  80335e:	c1 e0 03             	shl    $0x3,%eax
  803361:	01 c8                	add    %ecx,%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803368:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803370:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803375:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	01 c8                	add    %ecx,%eax
  803381:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803383:	39 c2                	cmp    %eax,%edx
  803385:	75 09                	jne    803390 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803387:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80338e:	eb 12                	jmp    8033a2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803390:	ff 45 e8             	incl   -0x18(%ebp)
  803393:	a1 20 40 80 00       	mov    0x804020,%eax
  803398:	8b 50 74             	mov    0x74(%eax),%edx
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	39 c2                	cmp    %eax,%edx
  8033a0:	77 88                	ja     80332a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8033a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033a6:	75 14                	jne    8033bc <CheckWSWithoutLastIndex+0xfb>
			panic(
  8033a8:	83 ec 04             	sub    $0x4,%esp
  8033ab:	68 64 3e 80 00       	push   $0x803e64
  8033b0:	6a 3a                	push   $0x3a
  8033b2:	68 58 3e 80 00       	push   $0x803e58
  8033b7:	e8 93 fe ff ff       	call   80324f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8033bc:	ff 45 f0             	incl   -0x10(%ebp)
  8033bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033c5:	0f 8c 32 ff ff ff    	jl     8032fd <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033d9:	eb 26                	jmp    803401 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033db:	a1 20 40 80 00       	mov    0x804020,%eax
  8033e0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033e9:	89 d0                	mov    %edx,%eax
  8033eb:	01 c0                	add    %eax,%eax
  8033ed:	01 d0                	add    %edx,%eax
  8033ef:	c1 e0 03             	shl    $0x3,%eax
  8033f2:	01 c8                	add    %ecx,%eax
  8033f4:	8a 40 04             	mov    0x4(%eax),%al
  8033f7:	3c 01                	cmp    $0x1,%al
  8033f9:	75 03                	jne    8033fe <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033fb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033fe:	ff 45 e0             	incl   -0x20(%ebp)
  803401:	a1 20 40 80 00       	mov    0x804020,%eax
  803406:	8b 50 74             	mov    0x74(%eax),%edx
  803409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80340c:	39 c2                	cmp    %eax,%edx
  80340e:	77 cb                	ja     8033db <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803413:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803416:	74 14                	je     80342c <CheckWSWithoutLastIndex+0x16b>
		panic(
  803418:	83 ec 04             	sub    $0x4,%esp
  80341b:	68 b8 3e 80 00       	push   $0x803eb8
  803420:	6a 44                	push   $0x44
  803422:	68 58 3e 80 00       	push   $0x803e58
  803427:	e8 23 fe ff ff       	call   80324f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80342c:	90                   	nop
  80342d:	c9                   	leave  
  80342e:	c3                   	ret    
  80342f:	90                   	nop

00803430 <__udivdi3>:
  803430:	55                   	push   %ebp
  803431:	57                   	push   %edi
  803432:	56                   	push   %esi
  803433:	53                   	push   %ebx
  803434:	83 ec 1c             	sub    $0x1c,%esp
  803437:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80343b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80343f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803443:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803447:	89 ca                	mov    %ecx,%edx
  803449:	89 f8                	mov    %edi,%eax
  80344b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80344f:	85 f6                	test   %esi,%esi
  803451:	75 2d                	jne    803480 <__udivdi3+0x50>
  803453:	39 cf                	cmp    %ecx,%edi
  803455:	77 65                	ja     8034bc <__udivdi3+0x8c>
  803457:	89 fd                	mov    %edi,%ebp
  803459:	85 ff                	test   %edi,%edi
  80345b:	75 0b                	jne    803468 <__udivdi3+0x38>
  80345d:	b8 01 00 00 00       	mov    $0x1,%eax
  803462:	31 d2                	xor    %edx,%edx
  803464:	f7 f7                	div    %edi
  803466:	89 c5                	mov    %eax,%ebp
  803468:	31 d2                	xor    %edx,%edx
  80346a:	89 c8                	mov    %ecx,%eax
  80346c:	f7 f5                	div    %ebp
  80346e:	89 c1                	mov    %eax,%ecx
  803470:	89 d8                	mov    %ebx,%eax
  803472:	f7 f5                	div    %ebp
  803474:	89 cf                	mov    %ecx,%edi
  803476:	89 fa                	mov    %edi,%edx
  803478:	83 c4 1c             	add    $0x1c,%esp
  80347b:	5b                   	pop    %ebx
  80347c:	5e                   	pop    %esi
  80347d:	5f                   	pop    %edi
  80347e:	5d                   	pop    %ebp
  80347f:	c3                   	ret    
  803480:	39 ce                	cmp    %ecx,%esi
  803482:	77 28                	ja     8034ac <__udivdi3+0x7c>
  803484:	0f bd fe             	bsr    %esi,%edi
  803487:	83 f7 1f             	xor    $0x1f,%edi
  80348a:	75 40                	jne    8034cc <__udivdi3+0x9c>
  80348c:	39 ce                	cmp    %ecx,%esi
  80348e:	72 0a                	jb     80349a <__udivdi3+0x6a>
  803490:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803494:	0f 87 9e 00 00 00    	ja     803538 <__udivdi3+0x108>
  80349a:	b8 01 00 00 00       	mov    $0x1,%eax
  80349f:	89 fa                	mov    %edi,%edx
  8034a1:	83 c4 1c             	add    $0x1c,%esp
  8034a4:	5b                   	pop    %ebx
  8034a5:	5e                   	pop    %esi
  8034a6:	5f                   	pop    %edi
  8034a7:	5d                   	pop    %ebp
  8034a8:	c3                   	ret    
  8034a9:	8d 76 00             	lea    0x0(%esi),%esi
  8034ac:	31 ff                	xor    %edi,%edi
  8034ae:	31 c0                	xor    %eax,%eax
  8034b0:	89 fa                	mov    %edi,%edx
  8034b2:	83 c4 1c             	add    $0x1c,%esp
  8034b5:	5b                   	pop    %ebx
  8034b6:	5e                   	pop    %esi
  8034b7:	5f                   	pop    %edi
  8034b8:	5d                   	pop    %ebp
  8034b9:	c3                   	ret    
  8034ba:	66 90                	xchg   %ax,%ax
  8034bc:	89 d8                	mov    %ebx,%eax
  8034be:	f7 f7                	div    %edi
  8034c0:	31 ff                	xor    %edi,%edi
  8034c2:	89 fa                	mov    %edi,%edx
  8034c4:	83 c4 1c             	add    $0x1c,%esp
  8034c7:	5b                   	pop    %ebx
  8034c8:	5e                   	pop    %esi
  8034c9:	5f                   	pop    %edi
  8034ca:	5d                   	pop    %ebp
  8034cb:	c3                   	ret    
  8034cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034d1:	89 eb                	mov    %ebp,%ebx
  8034d3:	29 fb                	sub    %edi,%ebx
  8034d5:	89 f9                	mov    %edi,%ecx
  8034d7:	d3 e6                	shl    %cl,%esi
  8034d9:	89 c5                	mov    %eax,%ebp
  8034db:	88 d9                	mov    %bl,%cl
  8034dd:	d3 ed                	shr    %cl,%ebp
  8034df:	89 e9                	mov    %ebp,%ecx
  8034e1:	09 f1                	or     %esi,%ecx
  8034e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034e7:	89 f9                	mov    %edi,%ecx
  8034e9:	d3 e0                	shl    %cl,%eax
  8034eb:	89 c5                	mov    %eax,%ebp
  8034ed:	89 d6                	mov    %edx,%esi
  8034ef:	88 d9                	mov    %bl,%cl
  8034f1:	d3 ee                	shr    %cl,%esi
  8034f3:	89 f9                	mov    %edi,%ecx
  8034f5:	d3 e2                	shl    %cl,%edx
  8034f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034fb:	88 d9                	mov    %bl,%cl
  8034fd:	d3 e8                	shr    %cl,%eax
  8034ff:	09 c2                	or     %eax,%edx
  803501:	89 d0                	mov    %edx,%eax
  803503:	89 f2                	mov    %esi,%edx
  803505:	f7 74 24 0c          	divl   0xc(%esp)
  803509:	89 d6                	mov    %edx,%esi
  80350b:	89 c3                	mov    %eax,%ebx
  80350d:	f7 e5                	mul    %ebp
  80350f:	39 d6                	cmp    %edx,%esi
  803511:	72 19                	jb     80352c <__udivdi3+0xfc>
  803513:	74 0b                	je     803520 <__udivdi3+0xf0>
  803515:	89 d8                	mov    %ebx,%eax
  803517:	31 ff                	xor    %edi,%edi
  803519:	e9 58 ff ff ff       	jmp    803476 <__udivdi3+0x46>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	8b 54 24 08          	mov    0x8(%esp),%edx
  803524:	89 f9                	mov    %edi,%ecx
  803526:	d3 e2                	shl    %cl,%edx
  803528:	39 c2                	cmp    %eax,%edx
  80352a:	73 e9                	jae    803515 <__udivdi3+0xe5>
  80352c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80352f:	31 ff                	xor    %edi,%edi
  803531:	e9 40 ff ff ff       	jmp    803476 <__udivdi3+0x46>
  803536:	66 90                	xchg   %ax,%ax
  803538:	31 c0                	xor    %eax,%eax
  80353a:	e9 37 ff ff ff       	jmp    803476 <__udivdi3+0x46>
  80353f:	90                   	nop

00803540 <__umoddi3>:
  803540:	55                   	push   %ebp
  803541:	57                   	push   %edi
  803542:	56                   	push   %esi
  803543:	53                   	push   %ebx
  803544:	83 ec 1c             	sub    $0x1c,%esp
  803547:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80354b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80354f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803553:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803557:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80355b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80355f:	89 f3                	mov    %esi,%ebx
  803561:	89 fa                	mov    %edi,%edx
  803563:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803567:	89 34 24             	mov    %esi,(%esp)
  80356a:	85 c0                	test   %eax,%eax
  80356c:	75 1a                	jne    803588 <__umoddi3+0x48>
  80356e:	39 f7                	cmp    %esi,%edi
  803570:	0f 86 a2 00 00 00    	jbe    803618 <__umoddi3+0xd8>
  803576:	89 c8                	mov    %ecx,%eax
  803578:	89 f2                	mov    %esi,%edx
  80357a:	f7 f7                	div    %edi
  80357c:	89 d0                	mov    %edx,%eax
  80357e:	31 d2                	xor    %edx,%edx
  803580:	83 c4 1c             	add    $0x1c,%esp
  803583:	5b                   	pop    %ebx
  803584:	5e                   	pop    %esi
  803585:	5f                   	pop    %edi
  803586:	5d                   	pop    %ebp
  803587:	c3                   	ret    
  803588:	39 f0                	cmp    %esi,%eax
  80358a:	0f 87 ac 00 00 00    	ja     80363c <__umoddi3+0xfc>
  803590:	0f bd e8             	bsr    %eax,%ebp
  803593:	83 f5 1f             	xor    $0x1f,%ebp
  803596:	0f 84 ac 00 00 00    	je     803648 <__umoddi3+0x108>
  80359c:	bf 20 00 00 00       	mov    $0x20,%edi
  8035a1:	29 ef                	sub    %ebp,%edi
  8035a3:	89 fe                	mov    %edi,%esi
  8035a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035a9:	89 e9                	mov    %ebp,%ecx
  8035ab:	d3 e0                	shl    %cl,%eax
  8035ad:	89 d7                	mov    %edx,%edi
  8035af:	89 f1                	mov    %esi,%ecx
  8035b1:	d3 ef                	shr    %cl,%edi
  8035b3:	09 c7                	or     %eax,%edi
  8035b5:	89 e9                	mov    %ebp,%ecx
  8035b7:	d3 e2                	shl    %cl,%edx
  8035b9:	89 14 24             	mov    %edx,(%esp)
  8035bc:	89 d8                	mov    %ebx,%eax
  8035be:	d3 e0                	shl    %cl,%eax
  8035c0:	89 c2                	mov    %eax,%edx
  8035c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c6:	d3 e0                	shl    %cl,%eax
  8035c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d0:	89 f1                	mov    %esi,%ecx
  8035d2:	d3 e8                	shr    %cl,%eax
  8035d4:	09 d0                	or     %edx,%eax
  8035d6:	d3 eb                	shr    %cl,%ebx
  8035d8:	89 da                	mov    %ebx,%edx
  8035da:	f7 f7                	div    %edi
  8035dc:	89 d3                	mov    %edx,%ebx
  8035de:	f7 24 24             	mull   (%esp)
  8035e1:	89 c6                	mov    %eax,%esi
  8035e3:	89 d1                	mov    %edx,%ecx
  8035e5:	39 d3                	cmp    %edx,%ebx
  8035e7:	0f 82 87 00 00 00    	jb     803674 <__umoddi3+0x134>
  8035ed:	0f 84 91 00 00 00    	je     803684 <__umoddi3+0x144>
  8035f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035f7:	29 f2                	sub    %esi,%edx
  8035f9:	19 cb                	sbb    %ecx,%ebx
  8035fb:	89 d8                	mov    %ebx,%eax
  8035fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803601:	d3 e0                	shl    %cl,%eax
  803603:	89 e9                	mov    %ebp,%ecx
  803605:	d3 ea                	shr    %cl,%edx
  803607:	09 d0                	or     %edx,%eax
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 eb                	shr    %cl,%ebx
  80360d:	89 da                	mov    %ebx,%edx
  80360f:	83 c4 1c             	add    $0x1c,%esp
  803612:	5b                   	pop    %ebx
  803613:	5e                   	pop    %esi
  803614:	5f                   	pop    %edi
  803615:	5d                   	pop    %ebp
  803616:	c3                   	ret    
  803617:	90                   	nop
  803618:	89 fd                	mov    %edi,%ebp
  80361a:	85 ff                	test   %edi,%edi
  80361c:	75 0b                	jne    803629 <__umoddi3+0xe9>
  80361e:	b8 01 00 00 00       	mov    $0x1,%eax
  803623:	31 d2                	xor    %edx,%edx
  803625:	f7 f7                	div    %edi
  803627:	89 c5                	mov    %eax,%ebp
  803629:	89 f0                	mov    %esi,%eax
  80362b:	31 d2                	xor    %edx,%edx
  80362d:	f7 f5                	div    %ebp
  80362f:	89 c8                	mov    %ecx,%eax
  803631:	f7 f5                	div    %ebp
  803633:	89 d0                	mov    %edx,%eax
  803635:	e9 44 ff ff ff       	jmp    80357e <__umoddi3+0x3e>
  80363a:	66 90                	xchg   %ax,%ax
  80363c:	89 c8                	mov    %ecx,%eax
  80363e:	89 f2                	mov    %esi,%edx
  803640:	83 c4 1c             	add    $0x1c,%esp
  803643:	5b                   	pop    %ebx
  803644:	5e                   	pop    %esi
  803645:	5f                   	pop    %edi
  803646:	5d                   	pop    %ebp
  803647:	c3                   	ret    
  803648:	3b 04 24             	cmp    (%esp),%eax
  80364b:	72 06                	jb     803653 <__umoddi3+0x113>
  80364d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803651:	77 0f                	ja     803662 <__umoddi3+0x122>
  803653:	89 f2                	mov    %esi,%edx
  803655:	29 f9                	sub    %edi,%ecx
  803657:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80365b:	89 14 24             	mov    %edx,(%esp)
  80365e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803662:	8b 44 24 04          	mov    0x4(%esp),%eax
  803666:	8b 14 24             	mov    (%esp),%edx
  803669:	83 c4 1c             	add    $0x1c,%esp
  80366c:	5b                   	pop    %ebx
  80366d:	5e                   	pop    %esi
  80366e:	5f                   	pop    %edi
  80366f:	5d                   	pop    %ebp
  803670:	c3                   	ret    
  803671:	8d 76 00             	lea    0x0(%esi),%esi
  803674:	2b 04 24             	sub    (%esp),%eax
  803677:	19 fa                	sbb    %edi,%edx
  803679:	89 d1                	mov    %edx,%ecx
  80367b:	89 c6                	mov    %eax,%esi
  80367d:	e9 71 ff ff ff       	jmp    8035f3 <__umoddi3+0xb3>
  803682:	66 90                	xchg   %ax,%ax
  803684:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803688:	72 ea                	jb     803674 <__umoddi3+0x134>
  80368a:	89 d9                	mov    %ebx,%ecx
  80368c:	e9 62 ff ff ff       	jmp    8035f3 <__umoddi3+0xb3>
