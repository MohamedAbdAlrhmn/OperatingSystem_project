
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
  80003e:	e8 d7 19 00 00       	call   801a1a <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 37 80 00       	push   $0x8037e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 a7 14 00 00       	call   8014fd <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 37 80 00       	push   $0x8037e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 91 14 00 00       	call   8014fd <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 37 80 00       	push   $0x8037e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 7b 14 00 00       	call   8014fd <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 b9 19 00 00       	call   801a4d <sys_get_virtual_time>
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
  8000b7:	e8 27 32 00 00       	call   8032e3 <env_sleep>
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
  8000d0:	e8 78 19 00 00       	call   801a4d <sys_get_virtual_time>
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
  8000f8:	e8 e6 31 00 00       	call   8032e3 <env_sleep>
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
  80010f:	e8 39 19 00 00       	call   801a4d <sys_get_virtual_time>
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
  800137:	e8 a7 31 00 00       	call   8032e3 <env_sleep>
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
  80014c:	68 f7 37 80 00       	push   $0x8037f7
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 80 17 00 00       	call   8018d9 <sys_signalSemaphore>
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
  800172:	e8 8a 18 00 00       	call   801a01 <sys_getenvindex>
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
  8001dd:	e8 2c 16 00 00       	call   80180e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 14 38 80 00       	push   $0x803814
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
  80020d:	68 3c 38 80 00       	push   $0x80383c
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
  80023e:	68 64 38 80 00       	push   $0x803864
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 bc 38 80 00       	push   $0x8038bc
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 14 38 80 00       	push   $0x803814
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 ac 15 00 00       	call   801828 <sys_enable_interrupt>

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
  80028f:	e8 39 17 00 00       	call   8019cd <sys_destroy_env>
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
  8002a0:	e8 8e 17 00 00       	call   801a33 <sys_exit_env>
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
  8002ee:	e8 6d 13 00 00       	call   801660 <sys_cputs>
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
  800365:	e8 f6 12 00 00       	call   801660 <sys_cputs>
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
  8003af:	e8 5a 14 00 00       	call   80180e <sys_disable_interrupt>
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
  8003cf:	e8 54 14 00 00       	call   801828 <sys_enable_interrupt>
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
  800419:	e8 5a 31 00 00       	call   803578 <__udivdi3>
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
  800469:	e8 1a 32 00 00       	call   803688 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 f4 3a 80 00       	add    $0x803af4,%eax
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
  8005c4:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
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
  8006a5:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 05 3b 80 00       	push   $0x803b05
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
  8006ca:	68 0e 3b 80 00       	push   $0x803b0e
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
  8006f7:	be 11 3b 80 00       	mov    $0x803b11,%esi
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
  80111d:	68 70 3c 80 00       	push   $0x803c70
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
  8011ed:	e8 b2 05 00 00       	call   8017a4 <sys_allocate_chunk>
  8011f2:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	50                   	push   %eax
  8011fe:	e8 27 0c 00 00       	call   801e2a <initialize_MemBlocksList>
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
  80122b:	68 95 3c 80 00       	push   $0x803c95
  801230:	6a 33                	push   $0x33
  801232:	68 b3 3c 80 00       	push   $0x803cb3
  801237:	e8 5b 21 00 00       	call   803397 <_panic>
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
  8012aa:	68 c0 3c 80 00       	push   $0x803cc0
  8012af:	6a 34                	push   $0x34
  8012b1:	68 b3 3c 80 00       	push   $0x803cb3
  8012b6:	e8 dc 20 00 00       	call   803397 <_panic>
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
  801342:	e8 2b 08 00 00       	call   801b72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801347:	85 c0                	test   %eax,%eax
  801349:	74 11                	je     80135c <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80134b:	83 ec 0c             	sub    $0xc,%esp
  80134e:	ff 75 e8             	pushl  -0x18(%ebp)
  801351:	e8 96 0e 00 00       	call   8021ec <alloc_block_FF>
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
  801368:	e8 f2 0b 00 00       	call   801f5f <insert_sorted_allocList>
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
  801382:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801385:	8b 45 08             	mov    0x8(%ebp),%eax
  801388:	83 ec 08             	sub    $0x8,%esp
  80138b:	50                   	push   %eax
  80138c:	68 40 40 80 00       	push   $0x804040
  801391:	e8 71 0b 00 00       	call   801f07 <find_block>
  801396:	83 c4 10             	add    $0x10,%esp
  801399:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80139c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013a0:	0f 84 a6 00 00 00    	je     80144c <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  8013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a9:	8b 50 0c             	mov    0xc(%eax),%edx
  8013ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013af:	8b 40 08             	mov    0x8(%eax),%eax
  8013b2:	83 ec 08             	sub    $0x8,%esp
  8013b5:	52                   	push   %edx
  8013b6:	50                   	push   %eax
  8013b7:	e8 b0 03 00 00       	call   80176c <sys_free_user_mem>
  8013bc:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  8013bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013c3:	75 14                	jne    8013d9 <free+0x5a>
  8013c5:	83 ec 04             	sub    $0x4,%esp
  8013c8:	68 95 3c 80 00       	push   $0x803c95
  8013cd:	6a 74                	push   $0x74
  8013cf:	68 b3 3c 80 00       	push   $0x803cb3
  8013d4:	e8 be 1f 00 00       	call   803397 <_panic>
  8013d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013dc:	8b 00                	mov    (%eax),%eax
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	74 10                	je     8013f2 <free+0x73>
  8013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e5:	8b 00                	mov    (%eax),%eax
  8013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ea:	8b 52 04             	mov    0x4(%edx),%edx
  8013ed:	89 50 04             	mov    %edx,0x4(%eax)
  8013f0:	eb 0b                	jmp    8013fd <free+0x7e>
  8013f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f5:	8b 40 04             	mov    0x4(%eax),%eax
  8013f8:	a3 44 40 80 00       	mov    %eax,0x804044
  8013fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801400:	8b 40 04             	mov    0x4(%eax),%eax
  801403:	85 c0                	test   %eax,%eax
  801405:	74 0f                	je     801416 <free+0x97>
  801407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140a:	8b 40 04             	mov    0x4(%eax),%eax
  80140d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801410:	8b 12                	mov    (%edx),%edx
  801412:	89 10                	mov    %edx,(%eax)
  801414:	eb 0a                	jmp    801420 <free+0xa1>
  801416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801419:	8b 00                	mov    (%eax),%eax
  80141b:	a3 40 40 80 00       	mov    %eax,0x804040
  801420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801433:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801438:	48                   	dec    %eax
  801439:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(free_block);
  80143e:	83 ec 0c             	sub    $0xc,%esp
  801441:	ff 75 f4             	pushl  -0xc(%ebp)
  801444:	e8 4e 17 00 00       	call   802b97 <insert_sorted_with_merge_freeList>
  801449:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80144c:	90                   	nop
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 38             	sub    $0x38,%esp
  801455:	8b 45 10             	mov    0x10(%ebp),%eax
  801458:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80145b:	e8 a6 fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  801460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801464:	75 0a                	jne    801470 <smalloc+0x21>
  801466:	b8 00 00 00 00       	mov    $0x0,%eax
  80146b:	e9 8b 00 00 00       	jmp    8014fb <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801470:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147d:	01 d0                	add    %edx,%eax
  80147f:	48                   	dec    %eax
  801480:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801486:	ba 00 00 00 00       	mov    $0x0,%edx
  80148b:	f7 75 f0             	divl   -0x10(%ebp)
  80148e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801491:	29 d0                	sub    %edx,%eax
  801493:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801496:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80149d:	e8 d0 06 00 00       	call   801b72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	74 11                	je     8014b7 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ac:	e8 3b 0d 00 00       	call   8021ec <alloc_block_FF>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8014b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014bb:	74 39                	je     8014f6 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8014bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c0:	8b 40 08             	mov    0x8(%eax),%eax
  8014c3:	89 c2                	mov    %eax,%edx
  8014c5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8014c9:	52                   	push   %edx
  8014ca:	50                   	push   %eax
  8014cb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ce:	ff 75 08             	pushl  0x8(%ebp)
  8014d1:	e8 21 04 00 00       	call   8018f7 <sys_createSharedObject>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8014dc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8014e0:	74 14                	je     8014f6 <smalloc+0xa7>
  8014e2:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8014e6:	74 0e                	je     8014f6 <smalloc+0xa7>
  8014e8:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8014ec:	74 08                	je     8014f6 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8014ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f1:	8b 40 08             	mov    0x8(%eax),%eax
  8014f4:	eb 05                	jmp    8014fb <smalloc+0xac>
	}
	return NULL;
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801503:	e8 fe fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	ff 75 08             	pushl  0x8(%ebp)
  801511:	e8 0b 04 00 00       	call   801921 <sys_getSizeOfSharedObject>
  801516:	83 c4 10             	add    $0x10,%esp
  801519:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80151c:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801520:	74 76                	je     801598 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801522:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801529:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152f:	01 d0                	add    %edx,%eax
  801531:	48                   	dec    %eax
  801532:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801538:	ba 00 00 00 00       	mov    $0x0,%edx
  80153d:	f7 75 ec             	divl   -0x14(%ebp)
  801540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801543:	29 d0                	sub    %edx,%eax
  801545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801548:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80154f:	e8 1e 06 00 00       	call   801b72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801554:	85 c0                	test   %eax,%eax
  801556:	74 11                	je     801569 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801558:	83 ec 0c             	sub    $0xc,%esp
  80155b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80155e:	e8 89 0c 00 00       	call   8021ec <alloc_block_FF>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801569:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80156d:	74 29                	je     801598 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801572:	8b 40 08             	mov    0x8(%eax),%eax
  801575:	83 ec 04             	sub    $0x4,%esp
  801578:	50                   	push   %eax
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	ff 75 08             	pushl  0x8(%ebp)
  80157f:	e8 ba 03 00 00       	call   80193e <sys_getSharedObject>
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80158a:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80158e:	74 08                	je     801598 <sget+0x9b>
				return (void *)mem_block->sva;
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	8b 40 08             	mov    0x8(%eax),%eax
  801596:	eb 05                	jmp    80159d <sget+0xa0>
		}
	}
	return NULL;
  801598:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a5:	e8 5c fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015aa:	83 ec 04             	sub    $0x4,%esp
  8015ad:	68 e4 3c 80 00       	push   $0x803ce4
  8015b2:	68 f7 00 00 00       	push   $0xf7
  8015b7:	68 b3 3c 80 00       	push   $0x803cb3
  8015bc:	e8 d6 1d 00 00       	call   803397 <_panic>

008015c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015c7:	83 ec 04             	sub    $0x4,%esp
  8015ca:	68 0c 3d 80 00       	push   $0x803d0c
  8015cf:	68 0c 01 00 00       	push   $0x10c
  8015d4:	68 b3 3c 80 00       	push   $0x803cb3
  8015d9:	e8 b9 1d 00 00       	call   803397 <_panic>

008015de <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e4:	83 ec 04             	sub    $0x4,%esp
  8015e7:	68 30 3d 80 00       	push   $0x803d30
  8015ec:	68 44 01 00 00       	push   $0x144
  8015f1:	68 b3 3c 80 00       	push   $0x803cb3
  8015f6:	e8 9c 1d 00 00       	call   803397 <_panic>

008015fb <shrink>:

}
void shrink(uint32 newSize)
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	68 30 3d 80 00       	push   $0x803d30
  801609:	68 49 01 00 00       	push   $0x149
  80160e:	68 b3 3c 80 00       	push   $0x803cb3
  801613:	e8 7f 1d 00 00       	call   803397 <_panic>

00801618 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801618:	55                   	push   %ebp
  801619:	89 e5                	mov    %esp,%ebp
  80161b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161e:	83 ec 04             	sub    $0x4,%esp
  801621:	68 30 3d 80 00       	push   $0x803d30
  801626:	68 4e 01 00 00       	push   $0x14e
  80162b:	68 b3 3c 80 00       	push   $0x803cb3
  801630:	e8 62 1d 00 00       	call   803397 <_panic>

00801635 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	57                   	push   %edi
  801639:	56                   	push   %esi
  80163a:	53                   	push   %ebx
  80163b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8b 55 0c             	mov    0xc(%ebp),%edx
  801644:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801647:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80164d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801650:	cd 30                	int    $0x30
  801652:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	5b                   	pop    %ebx
  80165c:	5e                   	pop    %esi
  80165d:	5f                   	pop    %edi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80166c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	52                   	push   %edx
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	50                   	push   %eax
  80167c:	6a 00                	push   $0x0
  80167e:	e8 b2 ff ff ff       	call   801635 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	90                   	nop
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <sys_cgetc>:

int
sys_cgetc(void)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 00                	push   $0x0
  801696:	6a 01                	push   $0x1
  801698:	e8 98 ff ff ff       	call   801635 <syscall>
  80169d:	83 c4 18             	add    $0x18,%esp
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	6a 00                	push   $0x0
  8016b1:	52                   	push   %edx
  8016b2:	50                   	push   %eax
  8016b3:	6a 05                	push   $0x5
  8016b5:	e8 7b ff ff ff       	call   801635 <syscall>
  8016ba:	83 c4 18             	add    $0x18,%esp
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	51                   	push   %ecx
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 06                	push   $0x6
  8016da:	e8 56 ff ff ff       	call   801635 <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	52                   	push   %edx
  8016f9:	50                   	push   %eax
  8016fa:	6a 07                	push   $0x7
  8016fc:	e8 34 ff ff ff       	call   801635 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	ff 75 08             	pushl  0x8(%ebp)
  801715:	6a 08                	push   $0x8
  801717:	e8 19 ff ff ff       	call   801635 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 09                	push   $0x9
  801730:	e8 00 ff ff ff       	call   801635 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 0a                	push   $0xa
  801749:	e8 e7 fe ff ff       	call   801635 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 0b                	push   $0xb
  801762:	e8 ce fe ff ff       	call   801635 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	ff 75 0c             	pushl  0xc(%ebp)
  801778:	ff 75 08             	pushl  0x8(%ebp)
  80177b:	6a 0f                	push   $0xf
  80177d:	e8 b3 fe ff ff       	call   801635 <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
	return;
  801785:	90                   	nop
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 0c             	pushl  0xc(%ebp)
  801794:	ff 75 08             	pushl  0x8(%ebp)
  801797:	6a 10                	push   $0x10
  801799:	e8 97 fe ff ff       	call   801635 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
	return ;
  8017a1:	90                   	nop
}
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	ff 75 10             	pushl  0x10(%ebp)
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 11                	push   $0x11
  8017b6:	e8 7a fe ff ff       	call   801635 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8017be:	90                   	nop
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 0c                	push   $0xc
  8017d0:	e8 60 fe ff ff       	call   801635 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	6a 0d                	push   $0xd
  8017ea:	e8 46 fe ff ff       	call   801635 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 0e                	push   $0xe
  801803:	e8 2d fe ff ff       	call   801635 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	90                   	nop
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 13                	push   $0x13
  80181d:	e8 13 fe ff ff       	call   801635 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	90                   	nop
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 14                	push   $0x14
  801837:	e8 f9 fd ff ff       	call   801635 <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	90                   	nop
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_cputc>:


void
sys_cputc(const char c)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80184e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	50                   	push   %eax
  80185b:	6a 15                	push   $0x15
  80185d:	e8 d3 fd ff ff       	call   801635 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	90                   	nop
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 16                	push   $0x16
  801877:	e8 b9 fd ff ff       	call   801635 <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	50                   	push   %eax
  801892:	6a 17                	push   $0x17
  801894:	e8 9c fd ff ff       	call   801635 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	52                   	push   %edx
  8018ae:	50                   	push   %eax
  8018af:	6a 1a                	push   $0x1a
  8018b1:	e8 7f fd ff ff       	call   801635 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	52                   	push   %edx
  8018cb:	50                   	push   %eax
  8018cc:	6a 18                	push   $0x18
  8018ce:	e8 62 fd ff ff       	call   801635 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	90                   	nop
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	52                   	push   %edx
  8018e9:	50                   	push   %eax
  8018ea:	6a 19                	push   $0x19
  8018ec:	e8 44 fd ff ff       	call   801635 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	90                   	nop
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 04             	sub    $0x4,%esp
  8018fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801900:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801903:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801906:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	6a 00                	push   $0x0
  80190f:	51                   	push   %ecx
  801910:	52                   	push   %edx
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	50                   	push   %eax
  801915:	6a 1b                	push   $0x1b
  801917:	e8 19 fd ff ff       	call   801635 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	52                   	push   %edx
  801931:	50                   	push   %eax
  801932:	6a 1c                	push   $0x1c
  801934:	e8 fc fc ff ff       	call   801635 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801941:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801944:	8b 55 0c             	mov    0xc(%ebp),%edx
  801947:	8b 45 08             	mov    0x8(%ebp),%eax
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	51                   	push   %ecx
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 1d                	push   $0x1d
  801953:	e8 dd fc ff ff       	call   801635 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801960:	8b 55 0c             	mov    0xc(%ebp),%edx
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	52                   	push   %edx
  80196d:	50                   	push   %eax
  80196e:	6a 1e                	push   $0x1e
  801970:	e8 c0 fc ff ff       	call   801635 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 1f                	push   $0x1f
  801989:	e8 a7 fc ff ff       	call   801635 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 14             	pushl  0x14(%ebp)
  80199e:	ff 75 10             	pushl  0x10(%ebp)
  8019a1:	ff 75 0c             	pushl  0xc(%ebp)
  8019a4:	50                   	push   %eax
  8019a5:	6a 20                	push   $0x20
  8019a7:	e8 89 fc ff ff       	call   801635 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	50                   	push   %eax
  8019c0:	6a 21                	push   $0x21
  8019c2:	e8 6e fc ff ff       	call   801635 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	50                   	push   %eax
  8019dc:	6a 22                	push   $0x22
  8019de:	e8 52 fc ff ff       	call   801635 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 02                	push   $0x2
  8019f7:	e8 39 fc ff ff       	call   801635 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 03                	push   $0x3
  801a10:	e8 20 fc ff ff       	call   801635 <syscall>
  801a15:	83 c4 18             	add    $0x18,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 04                	push   $0x4
  801a29:	e8 07 fc ff ff       	call   801635 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_exit_env>:


void sys_exit_env(void)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 23                	push   $0x23
  801a42:	e8 ee fb ff ff       	call   801635 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a56:	8d 50 04             	lea    0x4(%eax),%edx
  801a59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	52                   	push   %edx
  801a63:	50                   	push   %eax
  801a64:	6a 24                	push   $0x24
  801a66:	e8 ca fb ff ff       	call   801635 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
	return result;
  801a6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a77:	89 01                	mov    %eax,(%ecx)
  801a79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	c9                   	leave  
  801a80:	c2 04 00             	ret    $0x4

00801a83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	ff 75 10             	pushl  0x10(%ebp)
  801a8d:	ff 75 0c             	pushl  0xc(%ebp)
  801a90:	ff 75 08             	pushl  0x8(%ebp)
  801a93:	6a 12                	push   $0x12
  801a95:	e8 9b fb ff ff       	call   801635 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9d:	90                   	nop
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 25                	push   $0x25
  801aaf:	e8 81 fb ff ff       	call   801635 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ac5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	50                   	push   %eax
  801ad2:	6a 26                	push   $0x26
  801ad4:	e8 5c fb ff ff       	call   801635 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
	return ;
  801adc:	90                   	nop
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <rsttst>:
void rsttst()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 28                	push   $0x28
  801aee:	e8 42 fb ff ff       	call   801635 <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
	return ;
  801af6:	90                   	nop
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	83 ec 04             	sub    $0x4,%esp
  801aff:	8b 45 14             	mov    0x14(%ebp),%eax
  801b02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b05:	8b 55 18             	mov    0x18(%ebp),%edx
  801b08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0c:	52                   	push   %edx
  801b0d:	50                   	push   %eax
  801b0e:	ff 75 10             	pushl  0x10(%ebp)
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	6a 27                	push   $0x27
  801b19:	e8 17 fb ff ff       	call   801635 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b21:	90                   	nop
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <chktst>:
void chktst(uint32 n)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	ff 75 08             	pushl  0x8(%ebp)
  801b32:	6a 29                	push   $0x29
  801b34:	e8 fc fa ff ff       	call   801635 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3c:	90                   	nop
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <inctst>:

void inctst()
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 2a                	push   $0x2a
  801b4e:	e8 e2 fa ff ff       	call   801635 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return ;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <gettst>:
uint32 gettst()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 2b                	push   $0x2b
  801b68:	e8 c8 fa ff ff       	call   801635 <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 2c                	push   $0x2c
  801b84:	e8 ac fa ff ff       	call   801635 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
  801b8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b93:	75 07                	jne    801b9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b95:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9a:	eb 05                	jmp    801ba1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 2c                	push   $0x2c
  801bb5:	e8 7b fa ff ff       	call   801635 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
  801bbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bc0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bc4:	75 07                	jne    801bcd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bcb:	eb 05                	jmp    801bd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
  801bd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 2c                	push   $0x2c
  801be6:	e8 4a fa ff ff       	call   801635 <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
  801bee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bf1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bf5:	75 07                	jne    801bfe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bf7:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfc:	eb 05                	jmp    801c03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 2c                	push   $0x2c
  801c17:	e8 19 fa ff ff       	call   801635 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
  801c1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c26:	75 07                	jne    801c2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c28:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2d:	eb 05                	jmp    801c34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	6a 2d                	push   $0x2d
  801c46:	e8 ea f9 ff ff       	call   801635 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	6a 00                	push   $0x0
  801c63:	53                   	push   %ebx
  801c64:	51                   	push   %ecx
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	6a 2e                	push   $0x2e
  801c69:	e8 c7 f9 ff ff       	call   801635 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	52                   	push   %edx
  801c86:	50                   	push   %eax
  801c87:	6a 2f                	push   $0x2f
  801c89:	e8 a7 f9 ff ff       	call   801635 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	68 40 3d 80 00       	push   $0x803d40
  801ca1:	e8 d6 e6 ff ff       	call   80037c <cprintf>
  801ca6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	68 6c 3d 80 00       	push   $0x803d6c
  801cb8:	e8 bf e6 ff ff       	call   80037c <cprintf>
  801cbd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cc0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cc4:	a1 38 41 80 00       	mov    0x804138,%eax
  801cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ccc:	eb 56                	jmp    801d24 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd2:	74 1c                	je     801cf0 <print_mem_block_lists+0x5d>
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd7:	8b 50 08             	mov    0x8(%eax),%edx
  801cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdd:	8b 48 08             	mov    0x8(%eax),%ecx
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce6:	01 c8                	add    %ecx,%eax
  801ce8:	39 c2                	cmp    %eax,%edx
  801cea:	73 04                	jae    801cf0 <print_mem_block_lists+0x5d>
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
  801d09:	68 81 3d 80 00       	push   $0x803d81
  801d0e:	e8 69 e6 ff ff       	call   80037c <cprintf>
  801d13:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d1c:	a1 40 41 80 00       	mov    0x804140,%eax
  801d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d28:	74 07                	je     801d31 <print_mem_block_lists+0x9e>
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	eb 05                	jmp    801d36 <print_mem_block_lists+0xa3>
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
  801d36:	a3 40 41 80 00       	mov    %eax,0x804140
  801d3b:	a1 40 41 80 00       	mov    0x804140,%eax
  801d40:	85 c0                	test   %eax,%eax
  801d42:	75 8a                	jne    801cce <print_mem_block_lists+0x3b>
  801d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d48:	75 84                	jne    801cce <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d4a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d4e:	75 10                	jne    801d60 <print_mem_block_lists+0xcd>
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	68 90 3d 80 00       	push   $0x803d90
  801d58:	e8 1f e6 ff ff       	call   80037c <cprintf>
  801d5d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	68 b4 3d 80 00       	push   $0x803db4
  801d6f:	e8 08 e6 ff ff       	call   80037c <cprintf>
  801d74:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d77:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d7b:	a1 40 40 80 00       	mov    0x804040,%eax
  801d80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d83:	eb 56                	jmp    801ddb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d89:	74 1c                	je     801da7 <print_mem_block_lists+0x114>
  801d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8e:	8b 50 08             	mov    0x8(%eax),%edx
  801d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d94:	8b 48 08             	mov    0x8(%eax),%ecx
  801d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9d:	01 c8                	add    %ecx,%eax
  801d9f:	39 c2                	cmp    %eax,%edx
  801da1:	73 04                	jae    801da7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801da3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 50 08             	mov    0x8(%eax),%edx
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 40 0c             	mov    0xc(%eax),%eax
  801db3:	01 c2                	add    %eax,%edx
  801db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db8:	8b 40 08             	mov    0x8(%eax),%eax
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	52                   	push   %edx
  801dbf:	50                   	push   %eax
  801dc0:	68 81 3d 80 00       	push   $0x803d81
  801dc5:	e8 b2 e5 ff ff       	call   80037c <cprintf>
  801dca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dd3:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddf:	74 07                	je     801de8 <print_mem_block_lists+0x155>
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 00                	mov    (%eax),%eax
  801de6:	eb 05                	jmp    801ded <print_mem_block_lists+0x15a>
  801de8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ded:	a3 48 40 80 00       	mov    %eax,0x804048
  801df2:	a1 48 40 80 00       	mov    0x804048,%eax
  801df7:	85 c0                	test   %eax,%eax
  801df9:	75 8a                	jne    801d85 <print_mem_block_lists+0xf2>
  801dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dff:	75 84                	jne    801d85 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e01:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e05:	75 10                	jne    801e17 <print_mem_block_lists+0x184>
  801e07:	83 ec 0c             	sub    $0xc,%esp
  801e0a:	68 cc 3d 80 00       	push   $0x803dcc
  801e0f:	e8 68 e5 ff ff       	call   80037c <cprintf>
  801e14:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e17:	83 ec 0c             	sub    $0xc,%esp
  801e1a:	68 40 3d 80 00       	push   $0x803d40
  801e1f:	e8 58 e5 ff ff       	call   80037c <cprintf>
  801e24:	83 c4 10             	add    $0x10,%esp

}
  801e27:	90                   	nop
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e30:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e37:	00 00 00 
  801e3a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e41:	00 00 00 
  801e44:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e4b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e55:	e9 9e 00 00 00       	jmp    801ef8 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e5a:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e62:	c1 e2 04             	shl    $0x4,%edx
  801e65:	01 d0                	add    %edx,%eax
  801e67:	85 c0                	test   %eax,%eax
  801e69:	75 14                	jne    801e7f <initialize_MemBlocksList+0x55>
  801e6b:	83 ec 04             	sub    $0x4,%esp
  801e6e:	68 f4 3d 80 00       	push   $0x803df4
  801e73:	6a 46                	push   $0x46
  801e75:	68 17 3e 80 00       	push   $0x803e17
  801e7a:	e8 18 15 00 00       	call   803397 <_panic>
  801e7f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e87:	c1 e2 04             	shl    $0x4,%edx
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e92:	89 10                	mov    %edx,(%eax)
  801e94:	8b 00                	mov    (%eax),%eax
  801e96:	85 c0                	test   %eax,%eax
  801e98:	74 18                	je     801eb2 <initialize_MemBlocksList+0x88>
  801e9a:	a1 48 41 80 00       	mov    0x804148,%eax
  801e9f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ea5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ea8:	c1 e1 04             	shl    $0x4,%ecx
  801eab:	01 ca                	add    %ecx,%edx
  801ead:	89 50 04             	mov    %edx,0x4(%eax)
  801eb0:	eb 12                	jmp    801ec4 <initialize_MemBlocksList+0x9a>
  801eb2:	a1 50 40 80 00       	mov    0x804050,%eax
  801eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eba:	c1 e2 04             	shl    $0x4,%edx
  801ebd:	01 d0                	add    %edx,%eax
  801ebf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ec4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ecc:	c1 e2 04             	shl    $0x4,%edx
  801ecf:	01 d0                	add    %edx,%eax
  801ed1:	a3 48 41 80 00       	mov    %eax,0x804148
  801ed6:	a1 50 40 80 00       	mov    0x804050,%eax
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	c1 e2 04             	shl    $0x4,%edx
  801ee1:	01 d0                	add    %edx,%eax
  801ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eea:	a1 54 41 80 00       	mov    0x804154,%eax
  801eef:	40                   	inc    %eax
  801ef0:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ef5:	ff 45 f4             	incl   -0xc(%ebp)
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801efe:	0f 82 56 ff ff ff    	jb     801e5a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	8b 00                	mov    (%eax),%eax
  801f12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f15:	eb 19                	jmp    801f30 <find_block+0x29>
	{
		if(va==point->sva)
  801f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f1a:	8b 40 08             	mov    0x8(%eax),%eax
  801f1d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f20:	75 05                	jne    801f27 <find_block+0x20>
		   return point;
  801f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f25:	eb 36                	jmp    801f5d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	8b 40 08             	mov    0x8(%eax),%eax
  801f2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f30:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f34:	74 07                	je     801f3d <find_block+0x36>
  801f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f39:	8b 00                	mov    (%eax),%eax
  801f3b:	eb 05                	jmp    801f42 <find_block+0x3b>
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	8b 55 08             	mov    0x8(%ebp),%edx
  801f45:	89 42 08             	mov    %eax,0x8(%edx)
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	8b 40 08             	mov    0x8(%eax),%eax
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	75 c5                	jne    801f17 <find_block+0x10>
  801f52:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f56:	75 bf                	jne    801f17 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f65:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f6d:	a1 44 40 80 00       	mov    0x804044,%eax
  801f72:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f7b:	74 24                	je     801fa1 <insert_sorted_allocList+0x42>
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	8b 50 08             	mov    0x8(%eax),%edx
  801f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f86:	8b 40 08             	mov    0x8(%eax),%eax
  801f89:	39 c2                	cmp    %eax,%edx
  801f8b:	76 14                	jbe    801fa1 <insert_sorted_allocList+0x42>
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f96:	8b 40 08             	mov    0x8(%eax),%eax
  801f99:	39 c2                	cmp    %eax,%edx
  801f9b:	0f 82 60 01 00 00    	jb     802101 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fa1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa5:	75 65                	jne    80200c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fab:	75 14                	jne    801fc1 <insert_sorted_allocList+0x62>
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	68 f4 3d 80 00       	push   $0x803df4
  801fb5:	6a 6b                	push   $0x6b
  801fb7:	68 17 3e 80 00       	push   $0x803e17
  801fbc:	e8 d6 13 00 00       	call   803397 <_panic>
  801fc1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	89 10                	mov    %edx,(%eax)
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	8b 00                	mov    (%eax),%eax
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	74 0d                	je     801fe2 <insert_sorted_allocList+0x83>
  801fd5:	a1 40 40 80 00       	mov    0x804040,%eax
  801fda:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdd:	89 50 04             	mov    %edx,0x4(%eax)
  801fe0:	eb 08                	jmp    801fea <insert_sorted_allocList+0x8b>
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	a3 44 40 80 00       	mov    %eax,0x804044
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	a3 40 40 80 00       	mov    %eax,0x804040
  801ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ffc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802001:	40                   	inc    %eax
  802002:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802007:	e9 dc 01 00 00       	jmp    8021e8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80200c:	8b 45 08             	mov    0x8(%ebp),%eax
  80200f:	8b 50 08             	mov    0x8(%eax),%edx
  802012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802015:	8b 40 08             	mov    0x8(%eax),%eax
  802018:	39 c2                	cmp    %eax,%edx
  80201a:	77 6c                	ja     802088 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80201c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802020:	74 06                	je     802028 <insert_sorted_allocList+0xc9>
  802022:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802026:	75 14                	jne    80203c <insert_sorted_allocList+0xdd>
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	68 30 3e 80 00       	push   $0x803e30
  802030:	6a 6f                	push   $0x6f
  802032:	68 17 3e 80 00       	push   $0x803e17
  802037:	e8 5b 13 00 00       	call   803397 <_panic>
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203f:	8b 50 04             	mov    0x4(%eax),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	89 50 04             	mov    %edx,0x4(%eax)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204e:	89 10                	mov    %edx,(%eax)
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	8b 40 04             	mov    0x4(%eax),%eax
  802056:	85 c0                	test   %eax,%eax
  802058:	74 0d                	je     802067 <insert_sorted_allocList+0x108>
  80205a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205d:	8b 40 04             	mov    0x4(%eax),%eax
  802060:	8b 55 08             	mov    0x8(%ebp),%edx
  802063:	89 10                	mov    %edx,(%eax)
  802065:	eb 08                	jmp    80206f <insert_sorted_allocList+0x110>
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	a3 40 40 80 00       	mov    %eax,0x804040
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	8b 55 08             	mov    0x8(%ebp),%edx
  802075:	89 50 04             	mov    %edx,0x4(%eax)
  802078:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80207d:	40                   	inc    %eax
  80207e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802083:	e9 60 01 00 00       	jmp    8021e8 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	8b 50 08             	mov    0x8(%eax),%edx
  80208e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802091:	8b 40 08             	mov    0x8(%eax),%eax
  802094:	39 c2                	cmp    %eax,%edx
  802096:	0f 82 4c 01 00 00    	jb     8021e8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80209c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a0:	75 14                	jne    8020b6 <insert_sorted_allocList+0x157>
  8020a2:	83 ec 04             	sub    $0x4,%esp
  8020a5:	68 68 3e 80 00       	push   $0x803e68
  8020aa:	6a 73                	push   $0x73
  8020ac:	68 17 3e 80 00       	push   $0x803e17
  8020b1:	e8 e1 12 00 00       	call   803397 <_panic>
  8020b6:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	89 50 04             	mov    %edx,0x4(%eax)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	8b 40 04             	mov    0x4(%eax),%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	74 0c                	je     8020d8 <insert_sorted_allocList+0x179>
  8020cc:	a1 44 40 80 00       	mov    0x804044,%eax
  8020d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d4:	89 10                	mov    %edx,(%eax)
  8020d6:	eb 08                	jmp    8020e0 <insert_sorted_allocList+0x181>
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	a3 40 40 80 00       	mov    %eax,0x804040
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	a3 44 40 80 00       	mov    %eax,0x804044
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020f1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f6:	40                   	inc    %eax
  8020f7:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020fc:	e9 e7 00 00 00       	jmp    8021e8 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802107:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80210e:	a1 40 40 80 00       	mov    0x804040,%eax
  802113:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802116:	e9 9d 00 00 00       	jmp    8021b8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	8b 50 08             	mov    0x8(%eax),%edx
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	8b 40 08             	mov    0x8(%eax),%eax
  80212f:	39 c2                	cmp    %eax,%edx
  802131:	76 7d                	jbe    8021b0 <insert_sorted_allocList+0x251>
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	8b 50 08             	mov    0x8(%eax),%edx
  802139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213c:	8b 40 08             	mov    0x8(%eax),%eax
  80213f:	39 c2                	cmp    %eax,%edx
  802141:	73 6d                	jae    8021b0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802147:	74 06                	je     80214f <insert_sorted_allocList+0x1f0>
  802149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214d:	75 14                	jne    802163 <insert_sorted_allocList+0x204>
  80214f:	83 ec 04             	sub    $0x4,%esp
  802152:	68 8c 3e 80 00       	push   $0x803e8c
  802157:	6a 7f                	push   $0x7f
  802159:	68 17 3e 80 00       	push   $0x803e17
  80215e:	e8 34 12 00 00       	call   803397 <_panic>
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	8b 10                	mov    (%eax),%edx
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	89 10                	mov    %edx,(%eax)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	85 c0                	test   %eax,%eax
  802174:	74 0b                	je     802181 <insert_sorted_allocList+0x222>
  802176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	8b 55 08             	mov    0x8(%ebp),%edx
  80217e:	89 50 04             	mov    %edx,0x4(%eax)
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 55 08             	mov    0x8(%ebp),%edx
  802187:	89 10                	mov    %edx,(%eax)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218f:	89 50 04             	mov    %edx,0x4(%eax)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	85 c0                	test   %eax,%eax
  802199:	75 08                	jne    8021a3 <insert_sorted_allocList+0x244>
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a8:	40                   	inc    %eax
  8021a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021ae:	eb 39                	jmp    8021e9 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021b0:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bc:	74 07                	je     8021c5 <insert_sorted_allocList+0x266>
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	8b 00                	mov    (%eax),%eax
  8021c3:	eb 05                	jmp    8021ca <insert_sorted_allocList+0x26b>
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ca:	a3 48 40 80 00       	mov    %eax,0x804048
  8021cf:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	0f 85 3f ff ff ff    	jne    80211b <insert_sorted_allocList+0x1bc>
  8021dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e0:	0f 85 35 ff ff ff    	jne    80211b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e6:	eb 01                	jmp    8021e9 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e8:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e9:	90                   	nop
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021f2:	a1 38 41 80 00       	mov    0x804138,%eax
  8021f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fa:	e9 85 01 00 00       	jmp    802384 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 40 0c             	mov    0xc(%eax),%eax
  802205:	3b 45 08             	cmp    0x8(%ebp),%eax
  802208:	0f 82 6e 01 00 00    	jb     80237c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 40 0c             	mov    0xc(%eax),%eax
  802214:	3b 45 08             	cmp    0x8(%ebp),%eax
  802217:	0f 85 8a 00 00 00    	jne    8022a7 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80221d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802221:	75 17                	jne    80223a <alloc_block_FF+0x4e>
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 c0 3e 80 00       	push   $0x803ec0
  80222b:	68 93 00 00 00       	push   $0x93
  802230:	68 17 3e 80 00       	push   $0x803e17
  802235:	e8 5d 11 00 00       	call   803397 <_panic>
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	85 c0                	test   %eax,%eax
  802241:	74 10                	je     802253 <alloc_block_FF+0x67>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	8b 52 04             	mov    0x4(%edx),%edx
  80224e:	89 50 04             	mov    %edx,0x4(%eax)
  802251:	eb 0b                	jmp    80225e <alloc_block_FF+0x72>
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 40 04             	mov    0x4(%eax),%eax
  802259:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 04             	mov    0x4(%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 0f                	je     802277 <alloc_block_FF+0x8b>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 40 04             	mov    0x4(%eax),%eax
  80226e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802271:	8b 12                	mov    (%edx),%edx
  802273:	89 10                	mov    %edx,(%eax)
  802275:	eb 0a                	jmp    802281 <alloc_block_FF+0x95>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	a3 38 41 80 00       	mov    %eax,0x804138
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802294:	a1 44 41 80 00       	mov    0x804144,%eax
  802299:	48                   	dec    %eax
  80229a:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	e9 10 01 00 00       	jmp    8023b7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b0:	0f 86 c6 00 00 00    	jbe    80237c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8022bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	8b 50 08             	mov    0x8(%eax),%edx
  8022c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d0:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d7:	75 17                	jne    8022f0 <alloc_block_FF+0x104>
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	68 c0 3e 80 00       	push   $0x803ec0
  8022e1:	68 9b 00 00 00       	push   $0x9b
  8022e6:	68 17 3e 80 00       	push   $0x803e17
  8022eb:	e8 a7 10 00 00       	call   803397 <_panic>
  8022f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 10                	je     802309 <alloc_block_FF+0x11d>
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802301:	8b 52 04             	mov    0x4(%edx),%edx
  802304:	89 50 04             	mov    %edx,0x4(%eax)
  802307:	eb 0b                	jmp    802314 <alloc_block_FF+0x128>
  802309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230c:	8b 40 04             	mov    0x4(%eax),%eax
  80230f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 0f                	je     80232d <alloc_block_FF+0x141>
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 40 04             	mov    0x4(%eax),%eax
  802324:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802327:	8b 12                	mov    (%edx),%edx
  802329:	89 10                	mov    %edx,(%eax)
  80232b:	eb 0a                	jmp    802337 <alloc_block_FF+0x14b>
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	a3 48 41 80 00       	mov    %eax,0x804148
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802343:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234a:	a1 54 41 80 00       	mov    0x804154,%eax
  80234f:	48                   	dec    %eax
  802350:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 50 08             	mov    0x8(%eax),%edx
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	01 c2                	add    %eax,%edx
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 40 0c             	mov    0xc(%eax),%eax
  80236c:	2b 45 08             	sub    0x8(%ebp),%eax
  80236f:	89 c2                	mov    %eax,%edx
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237a:	eb 3b                	jmp    8023b7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80237c:	a1 40 41 80 00       	mov    0x804140,%eax
  802381:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802388:	74 07                	je     802391 <alloc_block_FF+0x1a5>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	eb 05                	jmp    802396 <alloc_block_FF+0x1aa>
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
  802396:	a3 40 41 80 00       	mov    %eax,0x804140
  80239b:	a1 40 41 80 00       	mov    0x804140,%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	0f 85 57 fe ff ff    	jne    8021ff <alloc_block_FF+0x13>
  8023a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ac:	0f 85 4d fe ff ff    	jne    8021ff <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b7:	c9                   	leave  
  8023b8:	c3                   	ret    

008023b9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023b9:	55                   	push   %ebp
  8023ba:	89 e5                	mov    %esp,%ebp
  8023bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023c6:	a1 38 41 80 00       	mov    0x804138,%eax
  8023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ce:	e9 df 00 00 00       	jmp    8024b2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023dc:	0f 82 c8 00 00 00    	jb     8024aa <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023eb:	0f 85 8a 00 00 00    	jne    80247b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f5:	75 17                	jne    80240e <alloc_block_BF+0x55>
  8023f7:	83 ec 04             	sub    $0x4,%esp
  8023fa:	68 c0 3e 80 00       	push   $0x803ec0
  8023ff:	68 b7 00 00 00       	push   $0xb7
  802404:	68 17 3e 80 00       	push   $0x803e17
  802409:	e8 89 0f 00 00       	call   803397 <_panic>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 00                	mov    (%eax),%eax
  802413:	85 c0                	test   %eax,%eax
  802415:	74 10                	je     802427 <alloc_block_BF+0x6e>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241f:	8b 52 04             	mov    0x4(%edx),%edx
  802422:	89 50 04             	mov    %edx,0x4(%eax)
  802425:	eb 0b                	jmp    802432 <alloc_block_BF+0x79>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 04             	mov    0x4(%eax),%eax
  80242d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 40 04             	mov    0x4(%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	74 0f                	je     80244b <alloc_block_BF+0x92>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 40 04             	mov    0x4(%eax),%eax
  802442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802445:	8b 12                	mov    (%edx),%edx
  802447:	89 10                	mov    %edx,(%eax)
  802449:	eb 0a                	jmp    802455 <alloc_block_BF+0x9c>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	a3 38 41 80 00       	mov    %eax,0x804138
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802468:	a1 44 41 80 00       	mov    0x804144,%eax
  80246d:	48                   	dec    %eax
  80246e:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	e9 4d 01 00 00       	jmp    8025c8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 0c             	mov    0xc(%eax),%eax
  802481:	3b 45 08             	cmp    0x8(%ebp),%eax
  802484:	76 24                	jbe    8024aa <alloc_block_BF+0xf1>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 40 0c             	mov    0xc(%eax),%eax
  80248c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80248f:	73 19                	jae    8024aa <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802491:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 08             	mov    0x8(%eax),%eax
  8024a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8024af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	74 07                	je     8024bf <alloc_block_BF+0x106>
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	8b 00                	mov    (%eax),%eax
  8024bd:	eb 05                	jmp    8024c4 <alloc_block_BF+0x10b>
  8024bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c4:	a3 40 41 80 00       	mov    %eax,0x804140
  8024c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	0f 85 fd fe ff ff    	jne    8023d3 <alloc_block_BF+0x1a>
  8024d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024da:	0f 85 f3 fe ff ff    	jne    8023d3 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024e4:	0f 84 d9 00 00 00    	je     8025c3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024ea:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f8:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802501:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802504:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802508:	75 17                	jne    802521 <alloc_block_BF+0x168>
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	68 c0 3e 80 00       	push   $0x803ec0
  802512:	68 c7 00 00 00       	push   $0xc7
  802517:	68 17 3e 80 00       	push   $0x803e17
  80251c:	e8 76 0e 00 00       	call   803397 <_panic>
  802521:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	85 c0                	test   %eax,%eax
  802528:	74 10                	je     80253a <alloc_block_BF+0x181>
  80252a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802532:	8b 52 04             	mov    0x4(%edx),%edx
  802535:	89 50 04             	mov    %edx,0x4(%eax)
  802538:	eb 0b                	jmp    802545 <alloc_block_BF+0x18c>
  80253a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802548:	8b 40 04             	mov    0x4(%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 0f                	je     80255e <alloc_block_BF+0x1a5>
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	8b 40 04             	mov    0x4(%eax),%eax
  802555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802558:	8b 12                	mov    (%edx),%edx
  80255a:	89 10                	mov    %edx,(%eax)
  80255c:	eb 0a                	jmp    802568 <alloc_block_BF+0x1af>
  80255e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	a3 48 41 80 00       	mov    %eax,0x804148
  802568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802574:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257b:	a1 54 41 80 00       	mov    0x804154,%eax
  802580:	48                   	dec    %eax
  802581:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802586:	83 ec 08             	sub    $0x8,%esp
  802589:	ff 75 ec             	pushl  -0x14(%ebp)
  80258c:	68 38 41 80 00       	push   $0x804138
  802591:	e8 71 f9 ff ff       	call   801f07 <find_block>
  802596:	83 c4 10             	add    $0x10,%esp
  802599:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80259c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259f:	8b 50 08             	mov    0x8(%eax),%edx
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	01 c2                	add    %eax,%edx
  8025a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025aa:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b6:	89 c2                	mov    %eax,%edx
  8025b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025bb:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c1:	eb 05                	jmp    8025c8 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c8:	c9                   	leave  
  8025c9:	c3                   	ret    

008025ca <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025d0:	a1 28 40 80 00       	mov    0x804028,%eax
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	0f 85 de 01 00 00    	jne    8027bb <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8025e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e5:	e9 9e 01 00 00       	jmp    802788 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f3:	0f 82 87 01 00 00    	jb     802780 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802602:	0f 85 95 00 00 00    	jne    80269d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260c:	75 17                	jne    802625 <alloc_block_NF+0x5b>
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 c0 3e 80 00       	push   $0x803ec0
  802616:	68 e0 00 00 00       	push   $0xe0
  80261b:	68 17 3e 80 00       	push   $0x803e17
  802620:	e8 72 0d 00 00       	call   803397 <_panic>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 10                	je     80263e <alloc_block_NF+0x74>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802636:	8b 52 04             	mov    0x4(%edx),%edx
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	eb 0b                	jmp    802649 <alloc_block_NF+0x7f>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 0f                	je     802662 <alloc_block_NF+0x98>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265c:	8b 12                	mov    (%edx),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	eb 0a                	jmp    80266c <alloc_block_NF+0xa2>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	a3 38 41 80 00       	mov    %eax,0x804138
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267f:	a1 44 41 80 00       	mov    0x804144,%eax
  802684:	48                   	dec    %eax
  802685:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 40 08             	mov    0x8(%eax),%eax
  802690:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	e9 f8 04 00 00       	jmp    802b95 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a6:	0f 86 d4 00 00 00    	jbe    802780 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ac:	a1 48 41 80 00       	mov    0x804148,%eax
  8026b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bd:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026cd:	75 17                	jne    8026e6 <alloc_block_NF+0x11c>
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	68 c0 3e 80 00       	push   $0x803ec0
  8026d7:	68 e9 00 00 00       	push   $0xe9
  8026dc:	68 17 3e 80 00       	push   $0x803e17
  8026e1:	e8 b1 0c 00 00       	call   803397 <_panic>
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 10                	je     8026ff <alloc_block_NF+0x135>
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f7:	8b 52 04             	mov    0x4(%edx),%edx
  8026fa:	89 50 04             	mov    %edx,0x4(%eax)
  8026fd:	eb 0b                	jmp    80270a <alloc_block_NF+0x140>
  8026ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802702:	8b 40 04             	mov    0x4(%eax),%eax
  802705:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80270a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270d:	8b 40 04             	mov    0x4(%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 0f                	je     802723 <alloc_block_NF+0x159>
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	8b 40 04             	mov    0x4(%eax),%eax
  80271a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271d:	8b 12                	mov    (%edx),%edx
  80271f:	89 10                	mov    %edx,(%eax)
  802721:	eb 0a                	jmp    80272d <alloc_block_NF+0x163>
  802723:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	a3 48 41 80 00       	mov    %eax,0x804148
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802739:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802740:	a1 54 41 80 00       	mov    0x804154,%eax
  802745:	48                   	dec    %eax
  802746:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80274b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274e:	8b 40 08             	mov    0x8(%eax),%eax
  802751:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 50 08             	mov    0x8(%eax),%edx
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	01 c2                	add    %eax,%edx
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	2b 45 08             	sub    0x8(%ebp),%eax
  802770:	89 c2                	mov    %eax,%edx
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	e9 15 04 00 00       	jmp    802b95 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802780:	a1 40 41 80 00       	mov    0x804140,%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	74 07                	je     802795 <alloc_block_NF+0x1cb>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	eb 05                	jmp    80279a <alloc_block_NF+0x1d0>
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	a3 40 41 80 00       	mov    %eax,0x804140
  80279f:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	0f 85 3e fe ff ff    	jne    8025ea <alloc_block_NF+0x20>
  8027ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b0:	0f 85 34 fe ff ff    	jne    8025ea <alloc_block_NF+0x20>
  8027b6:	e9 d5 03 00 00       	jmp    802b90 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027bb:	a1 38 41 80 00       	mov    0x804138,%eax
  8027c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c3:	e9 b1 01 00 00       	jmp    802979 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 50 08             	mov    0x8(%eax),%edx
  8027ce:	a1 28 40 80 00       	mov    0x804028,%eax
  8027d3:	39 c2                	cmp    %eax,%edx
  8027d5:	0f 82 96 01 00 00    	jb     802971 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e4:	0f 82 87 01 00 00    	jb     802971 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f3:	0f 85 95 00 00 00    	jne    80288e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	75 17                	jne    802816 <alloc_block_NF+0x24c>
  8027ff:	83 ec 04             	sub    $0x4,%esp
  802802:	68 c0 3e 80 00       	push   $0x803ec0
  802807:	68 fc 00 00 00       	push   $0xfc
  80280c:	68 17 3e 80 00       	push   $0x803e17
  802811:	e8 81 0b 00 00       	call   803397 <_panic>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	74 10                	je     80282f <alloc_block_NF+0x265>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802827:	8b 52 04             	mov    0x4(%edx),%edx
  80282a:	89 50 04             	mov    %edx,0x4(%eax)
  80282d:	eb 0b                	jmp    80283a <alloc_block_NF+0x270>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 40 04             	mov    0x4(%eax),%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	74 0f                	je     802853 <alloc_block_NF+0x289>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284d:	8b 12                	mov    (%edx),%edx
  80284f:	89 10                	mov    %edx,(%eax)
  802851:	eb 0a                	jmp    80285d <alloc_block_NF+0x293>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	a3 38 41 80 00       	mov    %eax,0x804138
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802870:	a1 44 41 80 00       	mov    0x804144,%eax
  802875:	48                   	dec    %eax
  802876:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 40 08             	mov    0x8(%eax),%eax
  802881:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	e9 07 03 00 00       	jmp    802b95 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 40 0c             	mov    0xc(%eax),%eax
  802894:	3b 45 08             	cmp    0x8(%ebp),%eax
  802897:	0f 86 d4 00 00 00    	jbe    802971 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80289d:	a1 48 41 80 00       	mov    0x804148,%eax
  8028a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 50 08             	mov    0x8(%eax),%edx
  8028ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ae:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028be:	75 17                	jne    8028d7 <alloc_block_NF+0x30d>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 c0 3e 80 00       	push   $0x803ec0
  8028c8:	68 04 01 00 00       	push   $0x104
  8028cd:	68 17 3e 80 00       	push   $0x803e17
  8028d2:	e8 c0 0a 00 00       	call   803397 <_panic>
  8028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	74 10                	je     8028f0 <alloc_block_NF+0x326>
  8028e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028e8:	8b 52 04             	mov    0x4(%edx),%edx
  8028eb:	89 50 04             	mov    %edx,0x4(%eax)
  8028ee:	eb 0b                	jmp    8028fb <alloc_block_NF+0x331>
  8028f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f3:	8b 40 04             	mov    0x4(%eax),%eax
  8028f6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fe:	8b 40 04             	mov    0x4(%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	74 0f                	je     802914 <alloc_block_NF+0x34a>
  802905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802908:	8b 40 04             	mov    0x4(%eax),%eax
  80290b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290e:	8b 12                	mov    (%edx),%edx
  802910:	89 10                	mov    %edx,(%eax)
  802912:	eb 0a                	jmp    80291e <alloc_block_NF+0x354>
  802914:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	a3 48 41 80 00       	mov    %eax,0x804148
  80291e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802921:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802927:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802931:	a1 54 41 80 00       	mov    0x804154,%eax
  802936:	48                   	dec    %eax
  802937:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80293c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293f:	8b 40 08             	mov    0x8(%eax),%eax
  802942:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 50 08             	mov    0x8(%eax),%edx
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	01 c2                	add    %eax,%edx
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 0c             	mov    0xc(%eax),%eax
  80295e:	2b 45 08             	sub    0x8(%ebp),%eax
  802961:	89 c2                	mov    %eax,%edx
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296c:	e9 24 02 00 00       	jmp    802b95 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802971:	a1 40 41 80 00       	mov    0x804140,%eax
  802976:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	74 07                	je     802986 <alloc_block_NF+0x3bc>
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	eb 05                	jmp    80298b <alloc_block_NF+0x3c1>
  802986:	b8 00 00 00 00       	mov    $0x0,%eax
  80298b:	a3 40 41 80 00       	mov    %eax,0x804140
  802990:	a1 40 41 80 00       	mov    0x804140,%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	0f 85 2b fe ff ff    	jne    8027c8 <alloc_block_NF+0x1fe>
  80299d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a1:	0f 85 21 fe ff ff    	jne    8027c8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029af:	e9 ae 01 00 00       	jmp    802b62 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	a1 28 40 80 00       	mov    0x804028,%eax
  8029bf:	39 c2                	cmp    %eax,%edx
  8029c1:	0f 83 93 01 00 00    	jae    802b5a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d0:	0f 82 84 01 00 00    	jb     802b5a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029df:	0f 85 95 00 00 00    	jne    802a7a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e9:	75 17                	jne    802a02 <alloc_block_NF+0x438>
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	68 c0 3e 80 00       	push   $0x803ec0
  8029f3:	68 14 01 00 00       	push   $0x114
  8029f8:	68 17 3e 80 00       	push   $0x803e17
  8029fd:	e8 95 09 00 00       	call   803397 <_panic>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	74 10                	je     802a1b <alloc_block_NF+0x451>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a13:	8b 52 04             	mov    0x4(%edx),%edx
  802a16:	89 50 04             	mov    %edx,0x4(%eax)
  802a19:	eb 0b                	jmp    802a26 <alloc_block_NF+0x45c>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 0f                	je     802a3f <alloc_block_NF+0x475>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	8b 12                	mov    (%edx),%edx
  802a3b:	89 10                	mov    %edx,(%eax)
  802a3d:	eb 0a                	jmp    802a49 <alloc_block_NF+0x47f>
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	a3 38 41 80 00       	mov    %eax,0x804138
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5c:	a1 44 41 80 00       	mov    0x804144,%eax
  802a61:	48                   	dec    %eax
  802a62:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 08             	mov    0x8(%eax),%eax
  802a6d:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	e9 1b 01 00 00       	jmp    802b95 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a80:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a83:	0f 86 d1 00 00 00    	jbe    802b5a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a89:	a1 48 41 80 00       	mov    0x804148,%eax
  802a8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aaa:	75 17                	jne    802ac3 <alloc_block_NF+0x4f9>
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	68 c0 3e 80 00       	push   $0x803ec0
  802ab4:	68 1c 01 00 00       	push   $0x11c
  802ab9:	68 17 3e 80 00       	push   $0x803e17
  802abe:	e8 d4 08 00 00       	call   803397 <_panic>
  802ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 10                	je     802adc <alloc_block_NF+0x512>
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad4:	8b 52 04             	mov    0x4(%edx),%edx
  802ad7:	89 50 04             	mov    %edx,0x4(%eax)
  802ada:	eb 0b                	jmp    802ae7 <alloc_block_NF+0x51d>
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0f                	je     802b00 <alloc_block_NF+0x536>
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802afa:	8b 12                	mov    (%edx),%edx
  802afc:	89 10                	mov    %edx,(%eax)
  802afe:	eb 0a                	jmp    802b0a <alloc_block_NF+0x540>
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	a3 48 41 80 00       	mov    %eax,0x804148
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1d:	a1 54 41 80 00       	mov    0x804154,%eax
  802b22:	48                   	dec    %eax
  802b23:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2b:	8b 40 08             	mov    0x8(%eax),%eax
  802b2e:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	01 c2                	add    %eax,%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4d:	89 c2                	mov    %eax,%edx
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	eb 3b                	jmp    802b95 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5a:	a1 40 41 80 00       	mov    0x804140,%eax
  802b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b66:	74 07                	je     802b6f <alloc_block_NF+0x5a5>
  802b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6b:	8b 00                	mov    (%eax),%eax
  802b6d:	eb 05                	jmp    802b74 <alloc_block_NF+0x5aa>
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	a3 40 41 80 00       	mov    %eax,0x804140
  802b79:	a1 40 41 80 00       	mov    0x804140,%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	0f 85 2e fe ff ff    	jne    8029b4 <alloc_block_NF+0x3ea>
  802b86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8a:	0f 85 24 fe ff ff    	jne    8029b4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b95:	c9                   	leave  
  802b96:	c3                   	ret    

00802b97 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b97:	55                   	push   %ebp
  802b98:	89 e5                	mov    %esp,%ebp
  802b9a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b9d:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ba5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802baa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bad:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	74 14                	je     802bca <insert_sorted_with_merge_freeList+0x33>
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	0f 87 9b 01 00 00    	ja     802d65 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bce:	75 17                	jne    802be7 <insert_sorted_with_merge_freeList+0x50>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 f4 3d 80 00       	push   $0x803df4
  802bd8:	68 38 01 00 00       	push   $0x138
  802bdd:	68 17 3e 80 00       	push   $0x803e17
  802be2:	e8 b0 07 00 00       	call   803397 <_panic>
  802be7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 00                	mov    (%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0d                	je     802c08 <insert_sorted_with_merge_freeList+0x71>
  802bfb:	a1 38 41 80 00       	mov    0x804138,%eax
  802c00:	8b 55 08             	mov    0x8(%ebp),%edx
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	eb 08                	jmp    802c10 <insert_sorted_with_merge_freeList+0x79>
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	a3 38 41 80 00       	mov    %eax,0x804138
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c22:	a1 44 41 80 00       	mov    0x804144,%eax
  802c27:	40                   	inc    %eax
  802c28:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c31:	0f 84 a8 06 00 00    	je     8032df <insert_sorted_with_merge_freeList+0x748>
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	8b 50 08             	mov    0x8(%eax),%edx
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	01 c2                	add    %eax,%edx
  802c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c48:	8b 40 08             	mov    0x8(%eax),%eax
  802c4b:	39 c2                	cmp    %eax,%edx
  802c4d:	0f 85 8c 06 00 00    	jne    8032df <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 50 0c             	mov    0xc(%eax),%edx
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5f:	01 c2                	add    %eax,%edx
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6b:	75 17                	jne    802c84 <insert_sorted_with_merge_freeList+0xed>
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 c0 3e 80 00       	push   $0x803ec0
  802c75:	68 3c 01 00 00       	push   $0x13c
  802c7a:	68 17 3e 80 00       	push   $0x803e17
  802c7f:	e8 13 07 00 00       	call   803397 <_panic>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 10                	je     802c9d <insert_sorted_with_merge_freeList+0x106>
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c95:	8b 52 04             	mov    0x4(%edx),%edx
  802c98:	89 50 04             	mov    %edx,0x4(%eax)
  802c9b:	eb 0b                	jmp    802ca8 <insert_sorted_with_merge_freeList+0x111>
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	74 0f                	je     802cc1 <insert_sorted_with_merge_freeList+0x12a>
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	8b 40 04             	mov    0x4(%eax),%eax
  802cb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cbb:	8b 12                	mov    (%edx),%edx
  802cbd:	89 10                	mov    %edx,(%eax)
  802cbf:	eb 0a                	jmp    802ccb <insert_sorted_with_merge_freeList+0x134>
  802cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	a3 38 41 80 00       	mov    %eax,0x804138
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cde:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce3:	48                   	dec    %eax
  802ce4:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d01:	75 17                	jne    802d1a <insert_sorted_with_merge_freeList+0x183>
  802d03:	83 ec 04             	sub    $0x4,%esp
  802d06:	68 f4 3d 80 00       	push   $0x803df4
  802d0b:	68 3f 01 00 00       	push   $0x13f
  802d10:	68 17 3e 80 00       	push   $0x803e17
  802d15:	e8 7d 06 00 00       	call   803397 <_panic>
  802d1a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d23:	89 10                	mov    %edx,(%eax)
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	8b 00                	mov    (%eax),%eax
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	74 0d                	je     802d3b <insert_sorted_with_merge_freeList+0x1a4>
  802d2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d36:	89 50 04             	mov    %edx,0x4(%eax)
  802d39:	eb 08                	jmp    802d43 <insert_sorted_with_merge_freeList+0x1ac>
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	a3 48 41 80 00       	mov    %eax,0x804148
  802d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d55:	a1 54 41 80 00       	mov    0x804154,%eax
  802d5a:	40                   	inc    %eax
  802d5b:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d60:	e9 7a 05 00 00       	jmp    8032df <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 50 08             	mov    0x8(%eax),%edx
  802d6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6e:	8b 40 08             	mov    0x8(%eax),%eax
  802d71:	39 c2                	cmp    %eax,%edx
  802d73:	0f 82 14 01 00 00    	jb     802e8d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7c:	8b 50 08             	mov    0x8(%eax),%edx
  802d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d82:	8b 40 0c             	mov    0xc(%eax),%eax
  802d85:	01 c2                	add    %eax,%edx
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	8b 40 08             	mov    0x8(%eax),%eax
  802d8d:	39 c2                	cmp    %eax,%edx
  802d8f:	0f 85 90 00 00 00    	jne    802e25 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d98:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802da1:	01 c2                	add    %eax,%edx
  802da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da6:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc1:	75 17                	jne    802dda <insert_sorted_with_merge_freeList+0x243>
  802dc3:	83 ec 04             	sub    $0x4,%esp
  802dc6:	68 f4 3d 80 00       	push   $0x803df4
  802dcb:	68 49 01 00 00       	push   $0x149
  802dd0:	68 17 3e 80 00       	push   $0x803e17
  802dd5:	e8 bd 05 00 00       	call   803397 <_panic>
  802dda:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	89 10                	mov    %edx,(%eax)
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 0d                	je     802dfb <insert_sorted_with_merge_freeList+0x264>
  802dee:	a1 48 41 80 00       	mov    0x804148,%eax
  802df3:	8b 55 08             	mov    0x8(%ebp),%edx
  802df6:	89 50 04             	mov    %edx,0x4(%eax)
  802df9:	eb 08                	jmp    802e03 <insert_sorted_with_merge_freeList+0x26c>
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e15:	a1 54 41 80 00       	mov    0x804154,%eax
  802e1a:	40                   	inc    %eax
  802e1b:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e20:	e9 bb 04 00 00       	jmp    8032e0 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e29:	75 17                	jne    802e42 <insert_sorted_with_merge_freeList+0x2ab>
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	68 68 3e 80 00       	push   $0x803e68
  802e33:	68 4c 01 00 00       	push   $0x14c
  802e38:	68 17 3e 80 00       	push   $0x803e17
  802e3d:	e8 55 05 00 00       	call   803397 <_panic>
  802e42:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	89 50 04             	mov    %edx,0x4(%eax)
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	8b 40 04             	mov    0x4(%eax),%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	74 0c                	je     802e64 <insert_sorted_with_merge_freeList+0x2cd>
  802e58:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e60:	89 10                	mov    %edx,(%eax)
  802e62:	eb 08                	jmp    802e6c <insert_sorted_with_merge_freeList+0x2d5>
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 38 41 80 00       	mov    %eax,0x804138
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7d:	a1 44 41 80 00       	mov    0x804144,%eax
  802e82:	40                   	inc    %eax
  802e83:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e88:	e9 53 04 00 00       	jmp    8032e0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e8d:	a1 38 41 80 00       	mov    0x804138,%eax
  802e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e95:	e9 15 04 00 00       	jmp    8032af <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	8b 50 08             	mov    0x8(%eax),%edx
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	8b 40 08             	mov    0x8(%eax),%eax
  802eae:	39 c2                	cmp    %eax,%edx
  802eb0:	0f 86 f1 03 00 00    	jbe    8032a7 <insert_sorted_with_merge_freeList+0x710>
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 50 08             	mov    0x8(%eax),%edx
  802ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebf:	8b 40 08             	mov    0x8(%eax),%eax
  802ec2:	39 c2                	cmp    %eax,%edx
  802ec4:	0f 83 dd 03 00 00    	jae    8032a7 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 50 08             	mov    0x8(%eax),%edx
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed6:	01 c2                	add    %eax,%edx
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 40 08             	mov    0x8(%eax),%eax
  802ede:	39 c2                	cmp    %eax,%edx
  802ee0:	0f 85 b9 01 00 00    	jne    80309f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	8b 50 08             	mov    0x8(%eax),%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef2:	01 c2                	add    %eax,%edx
  802ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef7:	8b 40 08             	mov    0x8(%eax),%eax
  802efa:	39 c2                	cmp    %eax,%edx
  802efc:	0f 85 0d 01 00 00    	jne    80300f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 50 0c             	mov    0xc(%eax),%edx
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0e:	01 c2                	add    %eax,%edx
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f1a:	75 17                	jne    802f33 <insert_sorted_with_merge_freeList+0x39c>
  802f1c:	83 ec 04             	sub    $0x4,%esp
  802f1f:	68 c0 3e 80 00       	push   $0x803ec0
  802f24:	68 5c 01 00 00       	push   $0x15c
  802f29:	68 17 3e 80 00       	push   $0x803e17
  802f2e:	e8 64 04 00 00       	call   803397 <_panic>
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 10                	je     802f4c <insert_sorted_with_merge_freeList+0x3b5>
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f44:	8b 52 04             	mov    0x4(%edx),%edx
  802f47:	89 50 04             	mov    %edx,0x4(%eax)
  802f4a:	eb 0b                	jmp    802f57 <insert_sorted_with_merge_freeList+0x3c0>
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	8b 40 04             	mov    0x4(%eax),%eax
  802f52:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5a:	8b 40 04             	mov    0x4(%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 0f                	je     802f70 <insert_sorted_with_merge_freeList+0x3d9>
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 40 04             	mov    0x4(%eax),%eax
  802f67:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f6a:	8b 12                	mov    (%edx),%edx
  802f6c:	89 10                	mov    %edx,(%eax)
  802f6e:	eb 0a                	jmp    802f7a <insert_sorted_with_merge_freeList+0x3e3>
  802f70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	a3 38 41 80 00       	mov    %eax,0x804138
  802f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802f92:	48                   	dec    %eax
  802f93:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fb0:	75 17                	jne    802fc9 <insert_sorted_with_merge_freeList+0x432>
  802fb2:	83 ec 04             	sub    $0x4,%esp
  802fb5:	68 f4 3d 80 00       	push   $0x803df4
  802fba:	68 5f 01 00 00       	push   $0x15f
  802fbf:	68 17 3e 80 00       	push   $0x803e17
  802fc4:	e8 ce 03 00 00       	call   803397 <_panic>
  802fc9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd2:	89 10                	mov    %edx,(%eax)
  802fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	85 c0                	test   %eax,%eax
  802fdb:	74 0d                	je     802fea <insert_sorted_with_merge_freeList+0x453>
  802fdd:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe5:	89 50 04             	mov    %edx,0x4(%eax)
  802fe8:	eb 08                	jmp    802ff2 <insert_sorted_with_merge_freeList+0x45b>
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803004:	a1 54 41 80 00       	mov    0x804154,%eax
  803009:	40                   	inc    %eax
  80300a:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 50 0c             	mov    0xc(%eax),%edx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	01 c2                	add    %eax,%edx
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803037:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303b:	75 17                	jne    803054 <insert_sorted_with_merge_freeList+0x4bd>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 f4 3d 80 00       	push   $0x803df4
  803045:	68 64 01 00 00       	push   $0x164
  80304a:	68 17 3e 80 00       	push   $0x803e17
  80304f:	e8 43 03 00 00       	call   803397 <_panic>
  803054:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 0d                	je     803075 <insert_sorted_with_merge_freeList+0x4de>
  803068:	a1 48 41 80 00       	mov    0x804148,%eax
  80306d:	8b 55 08             	mov    0x8(%ebp),%edx
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	eb 08                	jmp    80307d <insert_sorted_with_merge_freeList+0x4e6>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	a3 48 41 80 00       	mov    %eax,0x804148
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308f:	a1 54 41 80 00       	mov    0x804154,%eax
  803094:	40                   	inc    %eax
  803095:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80309a:	e9 41 02 00 00       	jmp    8032e0 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 50 08             	mov    0x8(%eax),%edx
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ab:	01 c2                	add    %eax,%edx
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	8b 40 08             	mov    0x8(%eax),%eax
  8030b3:	39 c2                	cmp    %eax,%edx
  8030b5:	0f 85 7c 01 00 00    	jne    803237 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030bf:	74 06                	je     8030c7 <insert_sorted_with_merge_freeList+0x530>
  8030c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c5:	75 17                	jne    8030de <insert_sorted_with_merge_freeList+0x547>
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 30 3e 80 00       	push   $0x803e30
  8030cf:	68 69 01 00 00       	push   $0x169
  8030d4:	68 17 3e 80 00       	push   $0x803e17
  8030d9:	e8 b9 02 00 00       	call   803397 <_panic>
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	8b 50 04             	mov    0x4(%eax),%edx
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	89 50 04             	mov    %edx,0x4(%eax)
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f0:	89 10                	mov    %edx,(%eax)
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	8b 40 04             	mov    0x4(%eax),%eax
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	74 0d                	je     803109 <insert_sorted_with_merge_freeList+0x572>
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	8b 40 04             	mov    0x4(%eax),%eax
  803102:	8b 55 08             	mov    0x8(%ebp),%edx
  803105:	89 10                	mov    %edx,(%eax)
  803107:	eb 08                	jmp    803111 <insert_sorted_with_merge_freeList+0x57a>
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	a3 38 41 80 00       	mov    %eax,0x804138
  803111:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803114:	8b 55 08             	mov    0x8(%ebp),%edx
  803117:	89 50 04             	mov    %edx,0x4(%eax)
  80311a:	a1 44 41 80 00       	mov    0x804144,%eax
  80311f:	40                   	inc    %eax
  803120:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 50 0c             	mov    0xc(%eax),%edx
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 40 0c             	mov    0xc(%eax),%eax
  803131:	01 c2                	add    %eax,%edx
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803139:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313d:	75 17                	jne    803156 <insert_sorted_with_merge_freeList+0x5bf>
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	68 c0 3e 80 00       	push   $0x803ec0
  803147:	68 6b 01 00 00       	push   $0x16b
  80314c:	68 17 3e 80 00       	push   $0x803e17
  803151:	e8 41 02 00 00       	call   803397 <_panic>
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	85 c0                	test   %eax,%eax
  80315d:	74 10                	je     80316f <insert_sorted_with_merge_freeList+0x5d8>
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803167:	8b 52 04             	mov    0x4(%edx),%edx
  80316a:	89 50 04             	mov    %edx,0x4(%eax)
  80316d:	eb 0b                	jmp    80317a <insert_sorted_with_merge_freeList+0x5e3>
  80316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803172:	8b 40 04             	mov    0x4(%eax),%eax
  803175:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 0f                	je     803193 <insert_sorted_with_merge_freeList+0x5fc>
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 40 04             	mov    0x4(%eax),%eax
  80318a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318d:	8b 12                	mov    (%edx),%edx
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	eb 0a                	jmp    80319d <insert_sorted_with_merge_freeList+0x606>
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	a3 38 41 80 00       	mov    %eax,0x804138
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8031b5:	48                   	dec    %eax
  8031b6:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d3:	75 17                	jne    8031ec <insert_sorted_with_merge_freeList+0x655>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 f4 3d 80 00       	push   $0x803df4
  8031dd:	68 6e 01 00 00       	push   $0x16e
  8031e2:	68 17 3e 80 00       	push   $0x803e17
  8031e7:	e8 ab 01 00 00       	call   803397 <_panic>
  8031ec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	89 10                	mov    %edx,(%eax)
  8031f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	74 0d                	je     80320d <insert_sorted_with_merge_freeList+0x676>
  803200:	a1 48 41 80 00       	mov    0x804148,%eax
  803205:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	eb 08                	jmp    803215 <insert_sorted_with_merge_freeList+0x67e>
  80320d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803210:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	a3 48 41 80 00       	mov    %eax,0x804148
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803227:	a1 54 41 80 00       	mov    0x804154,%eax
  80322c:	40                   	inc    %eax
  80322d:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803232:	e9 a9 00 00 00       	jmp    8032e0 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323b:	74 06                	je     803243 <insert_sorted_with_merge_freeList+0x6ac>
  80323d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803241:	75 17                	jne    80325a <insert_sorted_with_merge_freeList+0x6c3>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 8c 3e 80 00       	push   $0x803e8c
  80324b:	68 73 01 00 00       	push   $0x173
  803250:	68 17 3e 80 00       	push   $0x803e17
  803255:	e8 3d 01 00 00       	call   803397 <_panic>
  80325a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325d:	8b 10                	mov    (%eax),%edx
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	89 10                	mov    %edx,(%eax)
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 00                	mov    (%eax),%eax
  803269:	85 c0                	test   %eax,%eax
  80326b:	74 0b                	je     803278 <insert_sorted_with_merge_freeList+0x6e1>
  80326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	8b 55 08             	mov    0x8(%ebp),%edx
  803275:	89 50 04             	mov    %edx,0x4(%eax)
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 55 08             	mov    0x8(%ebp),%edx
  80327e:	89 10                	mov    %edx,(%eax)
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	75 08                	jne    80329a <insert_sorted_with_merge_freeList+0x703>
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80329a:	a1 44 41 80 00       	mov    0x804144,%eax
  80329f:	40                   	inc    %eax
  8032a0:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032a5:	eb 39                	jmp    8032e0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032a7:	a1 40 41 80 00       	mov    0x804140,%eax
  8032ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b3:	74 07                	je     8032bc <insert_sorted_with_merge_freeList+0x725>
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	8b 00                	mov    (%eax),%eax
  8032ba:	eb 05                	jmp    8032c1 <insert_sorted_with_merge_freeList+0x72a>
  8032bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032c1:	a3 40 41 80 00       	mov    %eax,0x804140
  8032c6:	a1 40 41 80 00       	mov    0x804140,%eax
  8032cb:	85 c0                	test   %eax,%eax
  8032cd:	0f 85 c7 fb ff ff    	jne    802e9a <insert_sorted_with_merge_freeList+0x303>
  8032d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d7:	0f 85 bd fb ff ff    	jne    802e9a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032dd:	eb 01                	jmp    8032e0 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032df:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032e0:	90                   	nop
  8032e1:	c9                   	leave  
  8032e2:	c3                   	ret    

008032e3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032e3:	55                   	push   %ebp
  8032e4:	89 e5                	mov    %esp,%ebp
  8032e6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ec:	89 d0                	mov    %edx,%eax
  8032ee:	c1 e0 02             	shl    $0x2,%eax
  8032f1:	01 d0                	add    %edx,%eax
  8032f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032fa:	01 d0                	add    %edx,%eax
  8032fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803303:	01 d0                	add    %edx,%eax
  803305:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80330c:	01 d0                	add    %edx,%eax
  80330e:	c1 e0 04             	shl    $0x4,%eax
  803311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80331b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80331e:	83 ec 0c             	sub    $0xc,%esp
  803321:	50                   	push   %eax
  803322:	e8 26 e7 ff ff       	call   801a4d <sys_get_virtual_time>
  803327:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80332a:	eb 41                	jmp    80336d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80332c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80332f:	83 ec 0c             	sub    $0xc,%esp
  803332:	50                   	push   %eax
  803333:	e8 15 e7 ff ff       	call   801a4d <sys_get_virtual_time>
  803338:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80333b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	29 c2                	sub    %eax,%edx
  803343:	89 d0                	mov    %edx,%eax
  803345:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803348:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80334b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80334e:	89 d1                	mov    %edx,%ecx
  803350:	29 c1                	sub    %eax,%ecx
  803352:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803355:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803358:	39 c2                	cmp    %eax,%edx
  80335a:	0f 97 c0             	seta   %al
  80335d:	0f b6 c0             	movzbl %al,%eax
  803360:	29 c1                	sub    %eax,%ecx
  803362:	89 c8                	mov    %ecx,%eax
  803364:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803367:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80336a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80336d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803370:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803373:	72 b7                	jb     80332c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803375:	90                   	nop
  803376:	c9                   	leave  
  803377:	c3                   	ret    

00803378 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803378:	55                   	push   %ebp
  803379:	89 e5                	mov    %esp,%ebp
  80337b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80337e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803385:	eb 03                	jmp    80338a <busy_wait+0x12>
  803387:	ff 45 fc             	incl   -0x4(%ebp)
  80338a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80338d:	3b 45 08             	cmp    0x8(%ebp),%eax
  803390:	72 f5                	jb     803387 <busy_wait+0xf>
	return i;
  803392:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803395:	c9                   	leave  
  803396:	c3                   	ret    

00803397 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803397:	55                   	push   %ebp
  803398:	89 e5                	mov    %esp,%ebp
  80339a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80339d:	8d 45 10             	lea    0x10(%ebp),%eax
  8033a0:	83 c0 04             	add    $0x4,%eax
  8033a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8033a6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8033ab:	85 c0                	test   %eax,%eax
  8033ad:	74 16                	je     8033c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8033af:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8033b4:	83 ec 08             	sub    $0x8,%esp
  8033b7:	50                   	push   %eax
  8033b8:	68 e0 3e 80 00       	push   $0x803ee0
  8033bd:	e8 ba cf ff ff       	call   80037c <cprintf>
  8033c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033c5:	a1 00 40 80 00       	mov    0x804000,%eax
  8033ca:	ff 75 0c             	pushl  0xc(%ebp)
  8033cd:	ff 75 08             	pushl  0x8(%ebp)
  8033d0:	50                   	push   %eax
  8033d1:	68 e5 3e 80 00       	push   $0x803ee5
  8033d6:	e8 a1 cf ff ff       	call   80037c <cprintf>
  8033db:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033de:	8b 45 10             	mov    0x10(%ebp),%eax
  8033e1:	83 ec 08             	sub    $0x8,%esp
  8033e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8033e7:	50                   	push   %eax
  8033e8:	e8 24 cf ff ff       	call   800311 <vcprintf>
  8033ed:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033f0:	83 ec 08             	sub    $0x8,%esp
  8033f3:	6a 00                	push   $0x0
  8033f5:	68 01 3f 80 00       	push   $0x803f01
  8033fa:	e8 12 cf ff ff       	call   800311 <vcprintf>
  8033ff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803402:	e8 93 ce ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  803407:	eb fe                	jmp    803407 <_panic+0x70>

00803409 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803409:	55                   	push   %ebp
  80340a:	89 e5                	mov    %esp,%ebp
  80340c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80340f:	a1 20 40 80 00       	mov    0x804020,%eax
  803414:	8b 50 74             	mov    0x74(%eax),%edx
  803417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80341a:	39 c2                	cmp    %eax,%edx
  80341c:	74 14                	je     803432 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80341e:	83 ec 04             	sub    $0x4,%esp
  803421:	68 04 3f 80 00       	push   $0x803f04
  803426:	6a 26                	push   $0x26
  803428:	68 50 3f 80 00       	push   $0x803f50
  80342d:	e8 65 ff ff ff       	call   803397 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803432:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803439:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803440:	e9 c2 00 00 00       	jmp    803507 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803448:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	01 d0                	add    %edx,%eax
  803454:	8b 00                	mov    (%eax),%eax
  803456:	85 c0                	test   %eax,%eax
  803458:	75 08                	jne    803462 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80345a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80345d:	e9 a2 00 00 00       	jmp    803504 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803462:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803469:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803470:	eb 69                	jmp    8034db <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803472:	a1 20 40 80 00       	mov    0x804020,%eax
  803477:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80347d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803480:	89 d0                	mov    %edx,%eax
  803482:	01 c0                	add    %eax,%eax
  803484:	01 d0                	add    %edx,%eax
  803486:	c1 e0 03             	shl    $0x3,%eax
  803489:	01 c8                	add    %ecx,%eax
  80348b:	8a 40 04             	mov    0x4(%eax),%al
  80348e:	84 c0                	test   %al,%al
  803490:	75 46                	jne    8034d8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803492:	a1 20 40 80 00       	mov    0x804020,%eax
  803497:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80349d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a0:	89 d0                	mov    %edx,%eax
  8034a2:	01 c0                	add    %eax,%eax
  8034a4:	01 d0                	add    %edx,%eax
  8034a6:	c1 e0 03             	shl    $0x3,%eax
  8034a9:	01 c8                	add    %ecx,%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8034b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8034b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034b8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c7:	01 c8                	add    %ecx,%eax
  8034c9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034cb:	39 c2                	cmp    %eax,%edx
  8034cd:	75 09                	jne    8034d8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8034cf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034d6:	eb 12                	jmp    8034ea <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034d8:	ff 45 e8             	incl   -0x18(%ebp)
  8034db:	a1 20 40 80 00       	mov    0x804020,%eax
  8034e0:	8b 50 74             	mov    0x74(%eax),%edx
  8034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e6:	39 c2                	cmp    %eax,%edx
  8034e8:	77 88                	ja     803472 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034ee:	75 14                	jne    803504 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8034f0:	83 ec 04             	sub    $0x4,%esp
  8034f3:	68 5c 3f 80 00       	push   $0x803f5c
  8034f8:	6a 3a                	push   $0x3a
  8034fa:	68 50 3f 80 00       	push   $0x803f50
  8034ff:	e8 93 fe ff ff       	call   803397 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803504:	ff 45 f0             	incl   -0x10(%ebp)
  803507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80350a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80350d:	0f 8c 32 ff ff ff    	jl     803445 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803513:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80351a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803521:	eb 26                	jmp    803549 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803523:	a1 20 40 80 00       	mov    0x804020,%eax
  803528:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80352e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803531:	89 d0                	mov    %edx,%eax
  803533:	01 c0                	add    %eax,%eax
  803535:	01 d0                	add    %edx,%eax
  803537:	c1 e0 03             	shl    $0x3,%eax
  80353a:	01 c8                	add    %ecx,%eax
  80353c:	8a 40 04             	mov    0x4(%eax),%al
  80353f:	3c 01                	cmp    $0x1,%al
  803541:	75 03                	jne    803546 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803543:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803546:	ff 45 e0             	incl   -0x20(%ebp)
  803549:	a1 20 40 80 00       	mov    0x804020,%eax
  80354e:	8b 50 74             	mov    0x74(%eax),%edx
  803551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803554:	39 c2                	cmp    %eax,%edx
  803556:	77 cb                	ja     803523 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80355e:	74 14                	je     803574 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803560:	83 ec 04             	sub    $0x4,%esp
  803563:	68 b0 3f 80 00       	push   $0x803fb0
  803568:	6a 44                	push   $0x44
  80356a:	68 50 3f 80 00       	push   $0x803f50
  80356f:	e8 23 fe ff ff       	call   803397 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803574:	90                   	nop
  803575:	c9                   	leave  
  803576:	c3                   	ret    
  803577:	90                   	nop

00803578 <__udivdi3>:
  803578:	55                   	push   %ebp
  803579:	57                   	push   %edi
  80357a:	56                   	push   %esi
  80357b:	53                   	push   %ebx
  80357c:	83 ec 1c             	sub    $0x1c,%esp
  80357f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803583:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803587:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80358f:	89 ca                	mov    %ecx,%edx
  803591:	89 f8                	mov    %edi,%eax
  803593:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803597:	85 f6                	test   %esi,%esi
  803599:	75 2d                	jne    8035c8 <__udivdi3+0x50>
  80359b:	39 cf                	cmp    %ecx,%edi
  80359d:	77 65                	ja     803604 <__udivdi3+0x8c>
  80359f:	89 fd                	mov    %edi,%ebp
  8035a1:	85 ff                	test   %edi,%edi
  8035a3:	75 0b                	jne    8035b0 <__udivdi3+0x38>
  8035a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035aa:	31 d2                	xor    %edx,%edx
  8035ac:	f7 f7                	div    %edi
  8035ae:	89 c5                	mov    %eax,%ebp
  8035b0:	31 d2                	xor    %edx,%edx
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	f7 f5                	div    %ebp
  8035b6:	89 c1                	mov    %eax,%ecx
  8035b8:	89 d8                	mov    %ebx,%eax
  8035ba:	f7 f5                	div    %ebp
  8035bc:	89 cf                	mov    %ecx,%edi
  8035be:	89 fa                	mov    %edi,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	39 ce                	cmp    %ecx,%esi
  8035ca:	77 28                	ja     8035f4 <__udivdi3+0x7c>
  8035cc:	0f bd fe             	bsr    %esi,%edi
  8035cf:	83 f7 1f             	xor    $0x1f,%edi
  8035d2:	75 40                	jne    803614 <__udivdi3+0x9c>
  8035d4:	39 ce                	cmp    %ecx,%esi
  8035d6:	72 0a                	jb     8035e2 <__udivdi3+0x6a>
  8035d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035dc:	0f 87 9e 00 00 00    	ja     803680 <__udivdi3+0x108>
  8035e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035e7:	89 fa                	mov    %edi,%edx
  8035e9:	83 c4 1c             	add    $0x1c,%esp
  8035ec:	5b                   	pop    %ebx
  8035ed:	5e                   	pop    %esi
  8035ee:	5f                   	pop    %edi
  8035ef:	5d                   	pop    %ebp
  8035f0:	c3                   	ret    
  8035f1:	8d 76 00             	lea    0x0(%esi),%esi
  8035f4:	31 ff                	xor    %edi,%edi
  8035f6:	31 c0                	xor    %eax,%eax
  8035f8:	89 fa                	mov    %edi,%edx
  8035fa:	83 c4 1c             	add    $0x1c,%esp
  8035fd:	5b                   	pop    %ebx
  8035fe:	5e                   	pop    %esi
  8035ff:	5f                   	pop    %edi
  803600:	5d                   	pop    %ebp
  803601:	c3                   	ret    
  803602:	66 90                	xchg   %ax,%ax
  803604:	89 d8                	mov    %ebx,%eax
  803606:	f7 f7                	div    %edi
  803608:	31 ff                	xor    %edi,%edi
  80360a:	89 fa                	mov    %edi,%edx
  80360c:	83 c4 1c             	add    $0x1c,%esp
  80360f:	5b                   	pop    %ebx
  803610:	5e                   	pop    %esi
  803611:	5f                   	pop    %edi
  803612:	5d                   	pop    %ebp
  803613:	c3                   	ret    
  803614:	bd 20 00 00 00       	mov    $0x20,%ebp
  803619:	89 eb                	mov    %ebp,%ebx
  80361b:	29 fb                	sub    %edi,%ebx
  80361d:	89 f9                	mov    %edi,%ecx
  80361f:	d3 e6                	shl    %cl,%esi
  803621:	89 c5                	mov    %eax,%ebp
  803623:	88 d9                	mov    %bl,%cl
  803625:	d3 ed                	shr    %cl,%ebp
  803627:	89 e9                	mov    %ebp,%ecx
  803629:	09 f1                	or     %esi,%ecx
  80362b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80362f:	89 f9                	mov    %edi,%ecx
  803631:	d3 e0                	shl    %cl,%eax
  803633:	89 c5                	mov    %eax,%ebp
  803635:	89 d6                	mov    %edx,%esi
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 ee                	shr    %cl,%esi
  80363b:	89 f9                	mov    %edi,%ecx
  80363d:	d3 e2                	shl    %cl,%edx
  80363f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803643:	88 d9                	mov    %bl,%cl
  803645:	d3 e8                	shr    %cl,%eax
  803647:	09 c2                	or     %eax,%edx
  803649:	89 d0                	mov    %edx,%eax
  80364b:	89 f2                	mov    %esi,%edx
  80364d:	f7 74 24 0c          	divl   0xc(%esp)
  803651:	89 d6                	mov    %edx,%esi
  803653:	89 c3                	mov    %eax,%ebx
  803655:	f7 e5                	mul    %ebp
  803657:	39 d6                	cmp    %edx,%esi
  803659:	72 19                	jb     803674 <__udivdi3+0xfc>
  80365b:	74 0b                	je     803668 <__udivdi3+0xf0>
  80365d:	89 d8                	mov    %ebx,%eax
  80365f:	31 ff                	xor    %edi,%edi
  803661:	e9 58 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  803666:	66 90                	xchg   %ax,%ax
  803668:	8b 54 24 08          	mov    0x8(%esp),%edx
  80366c:	89 f9                	mov    %edi,%ecx
  80366e:	d3 e2                	shl    %cl,%edx
  803670:	39 c2                	cmp    %eax,%edx
  803672:	73 e9                	jae    80365d <__udivdi3+0xe5>
  803674:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803677:	31 ff                	xor    %edi,%edi
  803679:	e9 40 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  80367e:	66 90                	xchg   %ax,%ax
  803680:	31 c0                	xor    %eax,%eax
  803682:	e9 37 ff ff ff       	jmp    8035be <__udivdi3+0x46>
  803687:	90                   	nop

00803688 <__umoddi3>:
  803688:	55                   	push   %ebp
  803689:	57                   	push   %edi
  80368a:	56                   	push   %esi
  80368b:	53                   	push   %ebx
  80368c:	83 ec 1c             	sub    $0x1c,%esp
  80368f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803693:	8b 74 24 34          	mov    0x34(%esp),%esi
  803697:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80369b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80369f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036a7:	89 f3                	mov    %esi,%ebx
  8036a9:	89 fa                	mov    %edi,%edx
  8036ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036af:	89 34 24             	mov    %esi,(%esp)
  8036b2:	85 c0                	test   %eax,%eax
  8036b4:	75 1a                	jne    8036d0 <__umoddi3+0x48>
  8036b6:	39 f7                	cmp    %esi,%edi
  8036b8:	0f 86 a2 00 00 00    	jbe    803760 <__umoddi3+0xd8>
  8036be:	89 c8                	mov    %ecx,%eax
  8036c0:	89 f2                	mov    %esi,%edx
  8036c2:	f7 f7                	div    %edi
  8036c4:	89 d0                	mov    %edx,%eax
  8036c6:	31 d2                	xor    %edx,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	39 f0                	cmp    %esi,%eax
  8036d2:	0f 87 ac 00 00 00    	ja     803784 <__umoddi3+0xfc>
  8036d8:	0f bd e8             	bsr    %eax,%ebp
  8036db:	83 f5 1f             	xor    $0x1f,%ebp
  8036de:	0f 84 ac 00 00 00    	je     803790 <__umoddi3+0x108>
  8036e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e9:	29 ef                	sub    %ebp,%edi
  8036eb:	89 fe                	mov    %edi,%esi
  8036ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036f1:	89 e9                	mov    %ebp,%ecx
  8036f3:	d3 e0                	shl    %cl,%eax
  8036f5:	89 d7                	mov    %edx,%edi
  8036f7:	89 f1                	mov    %esi,%ecx
  8036f9:	d3 ef                	shr    %cl,%edi
  8036fb:	09 c7                	or     %eax,%edi
  8036fd:	89 e9                	mov    %ebp,%ecx
  8036ff:	d3 e2                	shl    %cl,%edx
  803701:	89 14 24             	mov    %edx,(%esp)
  803704:	89 d8                	mov    %ebx,%eax
  803706:	d3 e0                	shl    %cl,%eax
  803708:	89 c2                	mov    %eax,%edx
  80370a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80370e:	d3 e0                	shl    %cl,%eax
  803710:	89 44 24 04          	mov    %eax,0x4(%esp)
  803714:	8b 44 24 08          	mov    0x8(%esp),%eax
  803718:	89 f1                	mov    %esi,%ecx
  80371a:	d3 e8                	shr    %cl,%eax
  80371c:	09 d0                	or     %edx,%eax
  80371e:	d3 eb                	shr    %cl,%ebx
  803720:	89 da                	mov    %ebx,%edx
  803722:	f7 f7                	div    %edi
  803724:	89 d3                	mov    %edx,%ebx
  803726:	f7 24 24             	mull   (%esp)
  803729:	89 c6                	mov    %eax,%esi
  80372b:	89 d1                	mov    %edx,%ecx
  80372d:	39 d3                	cmp    %edx,%ebx
  80372f:	0f 82 87 00 00 00    	jb     8037bc <__umoddi3+0x134>
  803735:	0f 84 91 00 00 00    	je     8037cc <__umoddi3+0x144>
  80373b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80373f:	29 f2                	sub    %esi,%edx
  803741:	19 cb                	sbb    %ecx,%ebx
  803743:	89 d8                	mov    %ebx,%eax
  803745:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803749:	d3 e0                	shl    %cl,%eax
  80374b:	89 e9                	mov    %ebp,%ecx
  80374d:	d3 ea                	shr    %cl,%edx
  80374f:	09 d0                	or     %edx,%eax
  803751:	89 e9                	mov    %ebp,%ecx
  803753:	d3 eb                	shr    %cl,%ebx
  803755:	89 da                	mov    %ebx,%edx
  803757:	83 c4 1c             	add    $0x1c,%esp
  80375a:	5b                   	pop    %ebx
  80375b:	5e                   	pop    %esi
  80375c:	5f                   	pop    %edi
  80375d:	5d                   	pop    %ebp
  80375e:	c3                   	ret    
  80375f:	90                   	nop
  803760:	89 fd                	mov    %edi,%ebp
  803762:	85 ff                	test   %edi,%edi
  803764:	75 0b                	jne    803771 <__umoddi3+0xe9>
  803766:	b8 01 00 00 00       	mov    $0x1,%eax
  80376b:	31 d2                	xor    %edx,%edx
  80376d:	f7 f7                	div    %edi
  80376f:	89 c5                	mov    %eax,%ebp
  803771:	89 f0                	mov    %esi,%eax
  803773:	31 d2                	xor    %edx,%edx
  803775:	f7 f5                	div    %ebp
  803777:	89 c8                	mov    %ecx,%eax
  803779:	f7 f5                	div    %ebp
  80377b:	89 d0                	mov    %edx,%eax
  80377d:	e9 44 ff ff ff       	jmp    8036c6 <__umoddi3+0x3e>
  803782:	66 90                	xchg   %ax,%ax
  803784:	89 c8                	mov    %ecx,%eax
  803786:	89 f2                	mov    %esi,%edx
  803788:	83 c4 1c             	add    $0x1c,%esp
  80378b:	5b                   	pop    %ebx
  80378c:	5e                   	pop    %esi
  80378d:	5f                   	pop    %edi
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    
  803790:	3b 04 24             	cmp    (%esp),%eax
  803793:	72 06                	jb     80379b <__umoddi3+0x113>
  803795:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803799:	77 0f                	ja     8037aa <__umoddi3+0x122>
  80379b:	89 f2                	mov    %esi,%edx
  80379d:	29 f9                	sub    %edi,%ecx
  80379f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037a3:	89 14 24             	mov    %edx,(%esp)
  8037a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037ae:	8b 14 24             	mov    (%esp),%edx
  8037b1:	83 c4 1c             	add    $0x1c,%esp
  8037b4:	5b                   	pop    %ebx
  8037b5:	5e                   	pop    %esi
  8037b6:	5f                   	pop    %edi
  8037b7:	5d                   	pop    %ebp
  8037b8:	c3                   	ret    
  8037b9:	8d 76 00             	lea    0x0(%esi),%esi
  8037bc:	2b 04 24             	sub    (%esp),%eax
  8037bf:	19 fa                	sbb    %edi,%edx
  8037c1:	89 d1                	mov    %edx,%ecx
  8037c3:	89 c6                	mov    %eax,%esi
  8037c5:	e9 71 ff ff ff       	jmp    80373b <__umoddi3+0xb3>
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037d0:	72 ea                	jb     8037bc <__umoddi3+0x134>
  8037d2:	89 d9                	mov    %ebx,%ecx
  8037d4:	e9 62 ff ff ff       	jmp    80373b <__umoddi3+0xb3>
