
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
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
  80003e:	e8 d9 17 00 00       	call   80181c <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 35 80 00       	push   $0x8035e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 29 13 00 00       	call   80137f <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 35 80 00       	push   $0x8035e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 13 13 00 00       	call   80137f <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 35 80 00       	push   $0x8035e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 fd 12 00 00       	call   80137f <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 f7 35 80 00       	push   $0x8035f7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 1b 16 00 00       	call   8016bd <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 9e 17 00 00       	call   80184f <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 0c 30 00 00       	call   8030e5 <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 5e 17 00 00       	call   80184f <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 cc 2f 00 00       	call   8030e5 <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 1f 17 00 00       	call   80184f <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 8d 2f 00 00       	call   8030e5 <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 8d 16 00 00       	call   801803 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 2f 14 00 00       	call   801610 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 14 36 80 00       	push   $0x803614
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 3c 36 80 00       	push   $0x80363c
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 64 36 80 00       	push   $0x803664
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 bc 36 80 00       	push   $0x8036bc
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 14 36 80 00       	push   $0x803614
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 af 13 00 00       	call   80162a <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 3c 15 00 00       	call   8017cf <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 91 15 00 00       	call   801835 <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 70 11 00 00       	call   801462 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 f9 10 00 00       	call   801462 <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 5d 12 00 00       	call   801610 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 57 12 00 00       	call   80162a <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 5f 2f 00 00       	call   80337c <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 1f 30 00 00       	call   80348c <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 f4 38 80 00       	add    $0x8038f4,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 05 39 80 00       	push   $0x803905
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 0e 39 80 00       	push   $0x80390e
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 70 3a 80 00       	push   $0x803a70
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  80113c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801143:	00 00 00 
  801146:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114d:	00 00 00 
  801150:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801157:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801161:	00 00 00 
  801164:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116b:	00 00 00 
  80116e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801175:	00 00 00 
	uint32 arr_size = 0;
  801178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80117f:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801189:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80118e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801193:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801198:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80119f:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  8011a2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8011a9:	a1 20 41 80 00       	mov    0x804120,%eax
  8011ae:	c1 e0 04             	shl    $0x4,%eax
  8011b1:	89 c2                	mov    %eax,%edx
  8011b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	48                   	dec    %eax
  8011b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8011bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c4:	f7 75 ec             	divl   -0x14(%ebp)
  8011c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011ca:	29 d0                	sub    %edx,%eax
  8011cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  8011cf:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	6a 03                	push   $0x3
  8011e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011eb:	50                   	push   %eax
  8011ec:	e8 b5 03 00 00       	call   8015a6 <sys_allocate_chunk>
  8011f1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	50                   	push   %eax
  8011fd:	e8 2a 0a 00 00       	call   801c2c <initialize_MemBlocksList>
  801202:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801205:	a1 48 41 80 00       	mov    0x804148,%eax
  80120a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80120d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801210:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  801221:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801225:	75 14                	jne    80123b <initialize_dyn_block_system+0x105>
  801227:	83 ec 04             	sub    $0x4,%esp
  80122a:	68 95 3a 80 00       	push   $0x803a95
  80122f:	6a 33                	push   $0x33
  801231:	68 b3 3a 80 00       	push   $0x803ab3
  801236:	e8 5e 1f 00 00       	call   803199 <_panic>
  80123b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80123e:	8b 00                	mov    (%eax),%eax
  801240:	85 c0                	test   %eax,%eax
  801242:	74 10                	je     801254 <initialize_dyn_block_system+0x11e>
  801244:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80124c:	8b 52 04             	mov    0x4(%edx),%edx
  80124f:	89 50 04             	mov    %edx,0x4(%eax)
  801252:	eb 0b                	jmp    80125f <initialize_dyn_block_system+0x129>
  801254:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801257:	8b 40 04             	mov    0x4(%eax),%eax
  80125a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80125f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801262:	8b 40 04             	mov    0x4(%eax),%eax
  801265:	85 c0                	test   %eax,%eax
  801267:	74 0f                	je     801278 <initialize_dyn_block_system+0x142>
  801269:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80126c:	8b 40 04             	mov    0x4(%eax),%eax
  80126f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801272:	8b 12                	mov    (%edx),%edx
  801274:	89 10                	mov    %edx,(%eax)
  801276:	eb 0a                	jmp    801282 <initialize_dyn_block_system+0x14c>
  801278:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80127b:	8b 00                	mov    (%eax),%eax
  80127d:	a3 48 41 80 00       	mov    %eax,0x804148
  801282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80128b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80128e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801295:	a1 54 41 80 00       	mov    0x804154,%eax
  80129a:	48                   	dec    %eax
  80129b:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  8012a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012a4:	75 14                	jne    8012ba <initialize_dyn_block_system+0x184>
  8012a6:	83 ec 04             	sub    $0x4,%esp
  8012a9:	68 c0 3a 80 00       	push   $0x803ac0
  8012ae:	6a 34                	push   $0x34
  8012b0:	68 b3 3a 80 00       	push   $0x803ab3
  8012b5:	e8 df 1e 00 00       	call   803199 <_panic>
  8012ba:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c3:	89 10                	mov    %edx,(%eax)
  8012c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c8:	8b 00                	mov    (%eax),%eax
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	74 0d                	je     8012db <initialize_dyn_block_system+0x1a5>
  8012ce:	a1 38 41 80 00       	mov    0x804138,%eax
  8012d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012d6:	89 50 04             	mov    %edx,0x4(%eax)
  8012d9:	eb 08                	jmp    8012e3 <initialize_dyn_block_system+0x1ad>
  8012db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8012eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8012fa:	40                   	inc    %eax
  8012fb:	a3 44 41 80 00       	mov    %eax,0x804144
}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801309:	e8 f7 fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80130e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801312:	75 07                	jne    80131b <malloc+0x18>
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	eb 14                	jmp    80132f <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  80131b:	83 ec 04             	sub    $0x4,%esp
  80131e:	68 e4 3a 80 00       	push   $0x803ae4
  801323:	6a 46                	push   $0x46
  801325:	68 b3 3a 80 00       	push   $0x803ab3
  80132a:	e8 6a 1e 00 00       	call   803199 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80132f:	c9                   	leave  
  801330:	c3                   	ret    

00801331 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801331:	55                   	push   %ebp
  801332:	89 e5                	mov    %esp,%ebp
  801334:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801337:	83 ec 04             	sub    $0x4,%esp
  80133a:	68 0c 3b 80 00       	push   $0x803b0c
  80133f:	6a 61                	push   $0x61
  801341:	68 b3 3a 80 00       	push   $0x803ab3
  801346:	e8 4e 1e 00 00       	call   803199 <_panic>

0080134b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 18             	sub    $0x18,%esp
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801357:	e8 a9 fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80135c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801360:	75 07                	jne    801369 <smalloc+0x1e>
  801362:	b8 00 00 00 00       	mov    $0x0,%eax
  801367:	eb 14                	jmp    80137d <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801369:	83 ec 04             	sub    $0x4,%esp
  80136c:	68 30 3b 80 00       	push   $0x803b30
  801371:	6a 76                	push   $0x76
  801373:	68 b3 3a 80 00       	push   $0x803ab3
  801378:	e8 1c 1e 00 00       	call   803199 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801385:	e8 7b fd ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80138a:	83 ec 04             	sub    $0x4,%esp
  80138d:	68 58 3b 80 00       	push   $0x803b58
  801392:	68 93 00 00 00       	push   $0x93
  801397:	68 b3 3a 80 00       	push   $0x803ab3
  80139c:	e8 f8 1d 00 00       	call   803199 <_panic>

008013a1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013a7:	e8 59 fd ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	68 7c 3b 80 00       	push   $0x803b7c
  8013b4:	68 c5 00 00 00       	push   $0xc5
  8013b9:	68 b3 3a 80 00       	push   $0x803ab3
  8013be:	e8 d6 1d 00 00       	call   803199 <_panic>

008013c3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013c9:	83 ec 04             	sub    $0x4,%esp
  8013cc:	68 a4 3b 80 00       	push   $0x803ba4
  8013d1:	68 d9 00 00 00       	push   $0xd9
  8013d6:	68 b3 3a 80 00       	push   $0x803ab3
  8013db:	e8 b9 1d 00 00       	call   803199 <_panic>

008013e0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	68 c8 3b 80 00       	push   $0x803bc8
  8013ee:	68 e4 00 00 00       	push   $0xe4
  8013f3:	68 b3 3a 80 00       	push   $0x803ab3
  8013f8:	e8 9c 1d 00 00       	call   803199 <_panic>

008013fd <shrink>:

}
void shrink(uint32 newSize)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801403:	83 ec 04             	sub    $0x4,%esp
  801406:	68 c8 3b 80 00       	push   $0x803bc8
  80140b:	68 e9 00 00 00       	push   $0xe9
  801410:	68 b3 3a 80 00       	push   $0x803ab3
  801415:	e8 7f 1d 00 00       	call   803199 <_panic>

0080141a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 c8 3b 80 00       	push   $0x803bc8
  801428:	68 ee 00 00 00       	push   $0xee
  80142d:	68 b3 3a 80 00       	push   $0x803ab3
  801432:	e8 62 1d 00 00       	call   803199 <_panic>

00801437 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	57                   	push   %edi
  80143b:	56                   	push   %esi
  80143c:	53                   	push   %ebx
  80143d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801440:	8b 45 08             	mov    0x8(%ebp),%eax
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801449:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80144c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80144f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801452:	cd 30                	int    $0x30
  801454:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801457:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	5b                   	pop    %ebx
  80145e:	5e                   	pop    %esi
  80145f:	5f                   	pop    %edi
  801460:	5d                   	pop    %ebp
  801461:	c3                   	ret    

00801462 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 04             	sub    $0x4,%esp
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80146e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801472:	8b 45 08             	mov    0x8(%ebp),%eax
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	52                   	push   %edx
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	50                   	push   %eax
  80147e:	6a 00                	push   $0x0
  801480:	e8 b2 ff ff ff       	call   801437 <syscall>
  801485:	83 c4 18             	add    $0x18,%esp
}
  801488:	90                   	nop
  801489:	c9                   	leave  
  80148a:	c3                   	ret    

0080148b <sys_cgetc>:

int
sys_cgetc(void)
{
  80148b:	55                   	push   %ebp
  80148c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 01                	push   $0x1
  80149a:	e8 98 ff ff ff       	call   801437 <syscall>
  80149f:	83 c4 18             	add    $0x18,%esp
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	52                   	push   %edx
  8014b4:	50                   	push   %eax
  8014b5:	6a 05                	push   $0x5
  8014b7:	e8 7b ff ff ff       	call   801437 <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
}
  8014bf:	c9                   	leave  
  8014c0:	c3                   	ret    

008014c1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014c1:	55                   	push   %ebp
  8014c2:	89 e5                	mov    %esp,%ebp
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014c6:	8b 75 18             	mov    0x18(%ebp),%esi
  8014c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	56                   	push   %esi
  8014d6:	53                   	push   %ebx
  8014d7:	51                   	push   %ecx
  8014d8:	52                   	push   %edx
  8014d9:	50                   	push   %eax
  8014da:	6a 06                	push   $0x6
  8014dc:	e8 56 ff ff ff       	call   801437 <syscall>
  8014e1:	83 c4 18             	add    $0x18,%esp
}
  8014e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014e7:	5b                   	pop    %ebx
  8014e8:	5e                   	pop    %esi
  8014e9:	5d                   	pop    %ebp
  8014ea:	c3                   	ret    

008014eb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	52                   	push   %edx
  8014fb:	50                   	push   %eax
  8014fc:	6a 07                	push   $0x7
  8014fe:	e8 34 ff ff ff       	call   801437 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
}
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	ff 75 0c             	pushl  0xc(%ebp)
  801514:	ff 75 08             	pushl  0x8(%ebp)
  801517:	6a 08                	push   $0x8
  801519:	e8 19 ff ff ff       	call   801437 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 09                	push   $0x9
  801532:	e8 00 ff ff ff       	call   801437 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
}
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 0a                	push   $0xa
  80154b:	e8 e7 fe ff ff       	call   801437 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 0b                	push   $0xb
  801564:	e8 ce fe ff ff       	call   801437 <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801571:	6a 00                	push   $0x0
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	ff 75 08             	pushl  0x8(%ebp)
  80157d:	6a 0f                	push   $0xf
  80157f:	e8 b3 fe ff ff       	call   801437 <syscall>
  801584:	83 c4 18             	add    $0x18,%esp
	return;
  801587:	90                   	nop
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	ff 75 0c             	pushl  0xc(%ebp)
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	6a 10                	push   $0x10
  80159b:	e8 97 fe ff ff       	call   801437 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8015a3:	90                   	nop
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	ff 75 10             	pushl  0x10(%ebp)
  8015b0:	ff 75 0c             	pushl  0xc(%ebp)
  8015b3:	ff 75 08             	pushl  0x8(%ebp)
  8015b6:	6a 11                	push   $0x11
  8015b8:	e8 7a fe ff ff       	call   801437 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8015c0:	90                   	nop
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 0c                	push   $0xc
  8015d2:	e8 60 fe ff ff       	call   801437 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	c9                   	leave  
  8015db:	c3                   	ret    

008015dc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	ff 75 08             	pushl  0x8(%ebp)
  8015ea:	6a 0d                	push   $0xd
  8015ec:	e8 46 fe ff ff       	call   801437 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 0e                	push   $0xe
  801605:	e8 2d fe ff ff       	call   801437 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	90                   	nop
  80160e:	c9                   	leave  
  80160f:	c3                   	ret    

00801610 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 13                	push   $0x13
  80161f:	e8 13 fe ff ff       	call   801437 <syscall>
  801624:	83 c4 18             	add    $0x18,%esp
}
  801627:	90                   	nop
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 14                	push   $0x14
  801639:	e8 f9 fd ff ff       	call   801437 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
}
  801641:	90                   	nop
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_cputc>:


void
sys_cputc(const char c)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801650:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	50                   	push   %eax
  80165d:	6a 15                	push   $0x15
  80165f:	e8 d3 fd ff ff       	call   801437 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 16                	push   $0x16
  801679:	e8 b9 fd ff ff       	call   801437 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	50                   	push   %eax
  801694:	6a 17                	push   $0x17
  801696:	e8 9c fd ff ff       	call   801437 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 1a                	push   $0x1a
  8016b3:	e8 7f fd ff ff       	call   801437 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	52                   	push   %edx
  8016cd:	50                   	push   %eax
  8016ce:	6a 18                	push   $0x18
  8016d0:	e8 62 fd ff ff       	call   801437 <syscall>
  8016d5:	83 c4 18             	add    $0x18,%esp
}
  8016d8:	90                   	nop
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 19                	push   $0x19
  8016ee:	e8 44 fd ff ff       	call   801437 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	90                   	nop
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801705:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801708:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	6a 00                	push   $0x0
  801711:	51                   	push   %ecx
  801712:	52                   	push   %edx
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	50                   	push   %eax
  801717:	6a 1b                	push   $0x1b
  801719:	e8 19 fd ff ff       	call   801437 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801726:	8b 55 0c             	mov    0xc(%ebp),%edx
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	52                   	push   %edx
  801733:	50                   	push   %eax
  801734:	6a 1c                	push   $0x1c
  801736:	e8 fc fc ff ff       	call   801437 <syscall>
  80173b:	83 c4 18             	add    $0x18,%esp
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801743:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	51                   	push   %ecx
  801751:	52                   	push   %edx
  801752:	50                   	push   %eax
  801753:	6a 1d                	push   $0x1d
  801755:	e8 dd fc ff ff       	call   801437 <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	52                   	push   %edx
  80176f:	50                   	push   %eax
  801770:	6a 1e                	push   $0x1e
  801772:	e8 c0 fc ff ff       	call   801437 <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
}
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 1f                	push   $0x1f
  80178b:	e8 a7 fc ff ff       	call   801437 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	ff 75 14             	pushl  0x14(%ebp)
  8017a0:	ff 75 10             	pushl  0x10(%ebp)
  8017a3:	ff 75 0c             	pushl  0xc(%ebp)
  8017a6:	50                   	push   %eax
  8017a7:	6a 20                	push   $0x20
  8017a9:	e8 89 fc ff ff       	call   801437 <syscall>
  8017ae:	83 c4 18             	add    $0x18,%esp
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	50                   	push   %eax
  8017c2:	6a 21                	push   $0x21
  8017c4:	e8 6e fc ff ff       	call   801437 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	50                   	push   %eax
  8017de:	6a 22                	push   $0x22
  8017e0:	e8 52 fc ff ff       	call   801437 <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 02                	push   $0x2
  8017f9:	e8 39 fc ff ff       	call   801437 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 03                	push   $0x3
  801812:	e8 20 fc ff ff       	call   801437 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 04                	push   $0x4
  80182b:	e8 07 fc ff ff       	call   801437 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_exit_env>:


void sys_exit_env(void)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 23                	push   $0x23
  801844:	e8 ee fb ff ff       	call   801437 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	90                   	nop
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801855:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801858:	8d 50 04             	lea    0x4(%eax),%edx
  80185b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	52                   	push   %edx
  801865:	50                   	push   %eax
  801866:	6a 24                	push   $0x24
  801868:	e8 ca fb ff ff       	call   801437 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
	return result;
  801870:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801879:	89 01                	mov    %eax,(%ecx)
  80187b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	c9                   	leave  
  801882:	c2 04 00             	ret    $0x4

00801885 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 10             	pushl  0x10(%ebp)
  80188f:	ff 75 0c             	pushl  0xc(%ebp)
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	6a 12                	push   $0x12
  801897:	e8 9b fb ff ff       	call   801437 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
	return ;
  80189f:	90                   	nop
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 25                	push   $0x25
  8018b1:	e8 81 fb ff ff       	call   801437 <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 04             	sub    $0x4,%esp
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018c7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	50                   	push   %eax
  8018d4:	6a 26                	push   $0x26
  8018d6:	e8 5c fb ff ff       	call   801437 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
	return ;
  8018de:	90                   	nop
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <rsttst>:
void rsttst()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 28                	push   $0x28
  8018f0:	e8 42 fb ff ff       	call   801437 <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f8:	90                   	nop
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	8b 45 14             	mov    0x14(%ebp),%eax
  801904:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801907:	8b 55 18             	mov    0x18(%ebp),%edx
  80190a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80190e:	52                   	push   %edx
  80190f:	50                   	push   %eax
  801910:	ff 75 10             	pushl  0x10(%ebp)
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	6a 27                	push   $0x27
  80191b:	e8 17 fb ff ff       	call   801437 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
	return ;
  801923:	90                   	nop
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <chktst>:
void chktst(uint32 n)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	6a 29                	push   $0x29
  801936:	e8 fc fa ff ff       	call   801437 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
	return ;
  80193e:	90                   	nop
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <inctst>:

void inctst()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 2a                	push   $0x2a
  801950:	e8 e2 fa ff ff       	call   801437 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <gettst>:
uint32 gettst()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 2b                	push   $0x2b
  80196a:	e8 c8 fa ff ff       	call   801437 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 2c                	push   $0x2c
  801986:	e8 ac fa ff ff       	call   801437 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
  80198e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801991:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801995:	75 07                	jne    80199e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801997:	b8 01 00 00 00       	mov    $0x1,%eax
  80199c:	eb 05                	jmp    8019a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80199e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 2c                	push   $0x2c
  8019b7:	e8 7b fa ff ff       	call   801437 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
  8019bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019c6:	75 07                	jne    8019cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cd:	eb 05                	jmp    8019d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 2c                	push   $0x2c
  8019e8:	e8 4a fa ff ff       	call   801437 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
  8019f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019f7:	75 07                	jne    801a00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fe:	eb 05                	jmp    801a05 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 2c                	push   $0x2c
  801a19:	e8 19 fa ff ff       	call   801437 <syscall>
  801a1e:	83 c4 18             	add    $0x18,%esp
  801a21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a24:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a28:	75 07                	jne    801a31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a2f:	eb 05                	jmp    801a36 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	6a 2d                	push   $0x2d
  801a48:	e8 ea f9 ff ff       	call   801437 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a50:	90                   	nop
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a57:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	53                   	push   %ebx
  801a66:	51                   	push   %ecx
  801a67:	52                   	push   %edx
  801a68:	50                   	push   %eax
  801a69:	6a 2e                	push   $0x2e
  801a6b:	e8 c7 f9 ff ff       	call   801437 <syscall>
  801a70:	83 c4 18             	add    $0x18,%esp
}
  801a73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 2f                	push   $0x2f
  801a8b:	e8 a7 f9 ff ff       	call   801437 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801a9b:	83 ec 0c             	sub    $0xc,%esp
  801a9e:	68 d8 3b 80 00       	push   $0x803bd8
  801aa3:	e8 d3 e8 ff ff       	call   80037b <cprintf>
  801aa8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ab2:	83 ec 0c             	sub    $0xc,%esp
  801ab5:	68 04 3c 80 00       	push   $0x803c04
  801aba:	e8 bc e8 ff ff       	call   80037b <cprintf>
  801abf:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ac2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ac6:	a1 38 41 80 00       	mov    0x804138,%eax
  801acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ace:	eb 56                	jmp    801b26 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ad0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ad4:	74 1c                	je     801af2 <print_mem_block_lists+0x5d>
  801ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad9:	8b 50 08             	mov    0x8(%eax),%edx
  801adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801adf:	8b 48 08             	mov    0x8(%eax),%ecx
  801ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae8:	01 c8                	add    %ecx,%eax
  801aea:	39 c2                	cmp    %eax,%edx
  801aec:	73 04                	jae    801af2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801aee:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af5:	8b 50 08             	mov    0x8(%eax),%edx
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	8b 40 0c             	mov    0xc(%eax),%eax
  801afe:	01 c2                	add    %eax,%edx
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	8b 40 08             	mov    0x8(%eax),%eax
  801b06:	83 ec 04             	sub    $0x4,%esp
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	68 19 3c 80 00       	push   $0x803c19
  801b10:	e8 66 e8 ff ff       	call   80037b <cprintf>
  801b15:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b1e:	a1 40 41 80 00       	mov    0x804140,%eax
  801b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b2a:	74 07                	je     801b33 <print_mem_block_lists+0x9e>
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	8b 00                	mov    (%eax),%eax
  801b31:	eb 05                	jmp    801b38 <print_mem_block_lists+0xa3>
  801b33:	b8 00 00 00 00       	mov    $0x0,%eax
  801b38:	a3 40 41 80 00       	mov    %eax,0x804140
  801b3d:	a1 40 41 80 00       	mov    0x804140,%eax
  801b42:	85 c0                	test   %eax,%eax
  801b44:	75 8a                	jne    801ad0 <print_mem_block_lists+0x3b>
  801b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b4a:	75 84                	jne    801ad0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801b4c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801b50:	75 10                	jne    801b62 <print_mem_block_lists+0xcd>
  801b52:	83 ec 0c             	sub    $0xc,%esp
  801b55:	68 28 3c 80 00       	push   $0x803c28
  801b5a:	e8 1c e8 ff ff       	call   80037b <cprintf>
  801b5f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801b62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801b69:	83 ec 0c             	sub    $0xc,%esp
  801b6c:	68 4c 3c 80 00       	push   $0x803c4c
  801b71:	e8 05 e8 ff ff       	call   80037b <cprintf>
  801b76:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801b79:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801b7d:	a1 40 40 80 00       	mov    0x804040,%eax
  801b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b85:	eb 56                	jmp    801bdd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b8b:	74 1c                	je     801ba9 <print_mem_block_lists+0x114>
  801b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b90:	8b 50 08             	mov    0x8(%eax),%edx
  801b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b96:	8b 48 08             	mov    0x8(%eax),%ecx
  801b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9f:	01 c8                	add    %ecx,%eax
  801ba1:	39 c2                	cmp    %eax,%edx
  801ba3:	73 04                	jae    801ba9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ba5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bac:	8b 50 08             	mov    0x8(%eax),%edx
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	01 c2                	add    %eax,%edx
  801bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bba:	8b 40 08             	mov    0x8(%eax),%eax
  801bbd:	83 ec 04             	sub    $0x4,%esp
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	68 19 3c 80 00       	push   $0x803c19
  801bc7:	e8 af e7 ff ff       	call   80037b <cprintf>
  801bcc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801bd5:	a1 48 40 80 00       	mov    0x804048,%eax
  801bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801be1:	74 07                	je     801bea <print_mem_block_lists+0x155>
  801be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be6:	8b 00                	mov    (%eax),%eax
  801be8:	eb 05                	jmp    801bef <print_mem_block_lists+0x15a>
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	a3 48 40 80 00       	mov    %eax,0x804048
  801bf4:	a1 48 40 80 00       	mov    0x804048,%eax
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	75 8a                	jne    801b87 <print_mem_block_lists+0xf2>
  801bfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c01:	75 84                	jne    801b87 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c03:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c07:	75 10                	jne    801c19 <print_mem_block_lists+0x184>
  801c09:	83 ec 0c             	sub    $0xc,%esp
  801c0c:	68 64 3c 80 00       	push   $0x803c64
  801c11:	e8 65 e7 ff ff       	call   80037b <cprintf>
  801c16:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	68 d8 3b 80 00       	push   $0x803bd8
  801c21:	e8 55 e7 ff ff       	call   80037b <cprintf>
  801c26:	83 c4 10             	add    $0x10,%esp

}
  801c29:	90                   	nop
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801c32:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801c39:	00 00 00 
  801c3c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801c43:	00 00 00 
  801c46:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801c4d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c57:	e9 9e 00 00 00       	jmp    801cfa <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801c5c:	a1 50 40 80 00       	mov    0x804050,%eax
  801c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c64:	c1 e2 04             	shl    $0x4,%edx
  801c67:	01 d0                	add    %edx,%eax
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	75 14                	jne    801c81 <initialize_MemBlocksList+0x55>
  801c6d:	83 ec 04             	sub    $0x4,%esp
  801c70:	68 8c 3c 80 00       	push   $0x803c8c
  801c75:	6a 46                	push   $0x46
  801c77:	68 af 3c 80 00       	push   $0x803caf
  801c7c:	e8 18 15 00 00       	call   803199 <_panic>
  801c81:	a1 50 40 80 00       	mov    0x804050,%eax
  801c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c89:	c1 e2 04             	shl    $0x4,%edx
  801c8c:	01 d0                	add    %edx,%eax
  801c8e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801c94:	89 10                	mov    %edx,(%eax)
  801c96:	8b 00                	mov    (%eax),%eax
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	74 18                	je     801cb4 <initialize_MemBlocksList+0x88>
  801c9c:	a1 48 41 80 00       	mov    0x804148,%eax
  801ca1:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ca7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801caa:	c1 e1 04             	shl    $0x4,%ecx
  801cad:	01 ca                	add    %ecx,%edx
  801caf:	89 50 04             	mov    %edx,0x4(%eax)
  801cb2:	eb 12                	jmp    801cc6 <initialize_MemBlocksList+0x9a>
  801cb4:	a1 50 40 80 00       	mov    0x804050,%eax
  801cb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbc:	c1 e2 04             	shl    $0x4,%edx
  801cbf:	01 d0                	add    %edx,%eax
  801cc1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801cc6:	a1 50 40 80 00       	mov    0x804050,%eax
  801ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cce:	c1 e2 04             	shl    $0x4,%edx
  801cd1:	01 d0                	add    %edx,%eax
  801cd3:	a3 48 41 80 00       	mov    %eax,0x804148
  801cd8:	a1 50 40 80 00       	mov    0x804050,%eax
  801cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce0:	c1 e2 04             	shl    $0x4,%edx
  801ce3:	01 d0                	add    %edx,%eax
  801ce5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cec:	a1 54 41 80 00       	mov    0x804154,%eax
  801cf1:	40                   	inc    %eax
  801cf2:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801cf7:	ff 45 f4             	incl   -0xc(%ebp)
  801cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfd:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d00:	0f 82 56 ff ff ff    	jb     801c5c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d06:	90                   	nop
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	8b 00                	mov    (%eax),%eax
  801d14:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d17:	eb 19                	jmp    801d32 <find_block+0x29>
	{
		if(va==point->sva)
  801d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d1c:	8b 40 08             	mov    0x8(%eax),%eax
  801d1f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d22:	75 05                	jne    801d29 <find_block+0x20>
		   return point;
  801d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d27:	eb 36                	jmp    801d5f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d29:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2c:	8b 40 08             	mov    0x8(%eax),%eax
  801d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d32:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d36:	74 07                	je     801d3f <find_block+0x36>
  801d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d3b:	8b 00                	mov    (%eax),%eax
  801d3d:	eb 05                	jmp    801d44 <find_block+0x3b>
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d44:	8b 55 08             	mov    0x8(%ebp),%edx
  801d47:	89 42 08             	mov    %eax,0x8(%edx)
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	8b 40 08             	mov    0x8(%eax),%eax
  801d50:	85 c0                	test   %eax,%eax
  801d52:	75 c5                	jne    801d19 <find_block+0x10>
  801d54:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d58:	75 bf                	jne    801d19 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801d67:	a1 40 40 80 00       	mov    0x804040,%eax
  801d6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801d6f:	a1 44 40 80 00       	mov    0x804044,%eax
  801d74:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d7d:	74 24                	je     801da3 <insert_sorted_allocList+0x42>
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	8b 50 08             	mov    0x8(%eax),%edx
  801d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d88:	8b 40 08             	mov    0x8(%eax),%eax
  801d8b:	39 c2                	cmp    %eax,%edx
  801d8d:	76 14                	jbe    801da3 <insert_sorted_allocList+0x42>
  801d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d92:	8b 50 08             	mov    0x8(%eax),%edx
  801d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d98:	8b 40 08             	mov    0x8(%eax),%eax
  801d9b:	39 c2                	cmp    %eax,%edx
  801d9d:	0f 82 60 01 00 00    	jb     801f03 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da7:	75 65                	jne    801e0e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801da9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801dad:	75 14                	jne    801dc3 <insert_sorted_allocList+0x62>
  801daf:	83 ec 04             	sub    $0x4,%esp
  801db2:	68 8c 3c 80 00       	push   $0x803c8c
  801db7:	6a 6b                	push   $0x6b
  801db9:	68 af 3c 80 00       	push   $0x803caf
  801dbe:	e8 d6 13 00 00       	call   803199 <_panic>
  801dc3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	89 10                	mov    %edx,(%eax)
  801dce:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd1:	8b 00                	mov    (%eax),%eax
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	74 0d                	je     801de4 <insert_sorted_allocList+0x83>
  801dd7:	a1 40 40 80 00       	mov    0x804040,%eax
  801ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  801ddf:	89 50 04             	mov    %edx,0x4(%eax)
  801de2:	eb 08                	jmp    801dec <insert_sorted_allocList+0x8b>
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	a3 44 40 80 00       	mov    %eax,0x804044
  801dec:	8b 45 08             	mov    0x8(%ebp),%eax
  801def:	a3 40 40 80 00       	mov    %eax,0x804040
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dfe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e03:	40                   	inc    %eax
  801e04:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e09:	e9 dc 01 00 00       	jmp    801fea <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	8b 50 08             	mov    0x8(%eax),%edx
  801e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e17:	8b 40 08             	mov    0x8(%eax),%eax
  801e1a:	39 c2                	cmp    %eax,%edx
  801e1c:	77 6c                	ja     801e8a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e22:	74 06                	je     801e2a <insert_sorted_allocList+0xc9>
  801e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e28:	75 14                	jne    801e3e <insert_sorted_allocList+0xdd>
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	68 c8 3c 80 00       	push   $0x803cc8
  801e32:	6a 6f                	push   $0x6f
  801e34:	68 af 3c 80 00       	push   $0x803caf
  801e39:	e8 5b 13 00 00       	call   803199 <_panic>
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	8b 50 04             	mov    0x4(%eax),%edx
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	89 50 04             	mov    %edx,0x4(%eax)
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e50:	89 10                	mov    %edx,(%eax)
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e55:	8b 40 04             	mov    0x4(%eax),%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 0d                	je     801e69 <insert_sorted_allocList+0x108>
  801e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5f:	8b 40 04             	mov    0x4(%eax),%eax
  801e62:	8b 55 08             	mov    0x8(%ebp),%edx
  801e65:	89 10                	mov    %edx,(%eax)
  801e67:	eb 08                	jmp    801e71 <insert_sorted_allocList+0x110>
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	a3 40 40 80 00       	mov    %eax,0x804040
  801e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e74:	8b 55 08             	mov    0x8(%ebp),%edx
  801e77:	89 50 04             	mov    %edx,0x4(%eax)
  801e7a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e7f:	40                   	inc    %eax
  801e80:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e85:	e9 60 01 00 00       	jmp    801fea <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	8b 50 08             	mov    0x8(%eax),%edx
  801e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e93:	8b 40 08             	mov    0x8(%eax),%eax
  801e96:	39 c2                	cmp    %eax,%edx
  801e98:	0f 82 4c 01 00 00    	jb     801fea <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea2:	75 14                	jne    801eb8 <insert_sorted_allocList+0x157>
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	68 00 3d 80 00       	push   $0x803d00
  801eac:	6a 73                	push   $0x73
  801eae:	68 af 3c 80 00       	push   $0x803caf
  801eb3:	e8 e1 12 00 00       	call   803199 <_panic>
  801eb8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	89 50 04             	mov    %edx,0x4(%eax)
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8b 40 04             	mov    0x4(%eax),%eax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	74 0c                	je     801eda <insert_sorted_allocList+0x179>
  801ece:	a1 44 40 80 00       	mov    0x804044,%eax
  801ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed6:	89 10                	mov    %edx,(%eax)
  801ed8:	eb 08                	jmp    801ee2 <insert_sorted_allocList+0x181>
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	a3 40 40 80 00       	mov    %eax,0x804040
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	a3 44 40 80 00       	mov    %eax,0x804044
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ef3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ef8:	40                   	inc    %eax
  801ef9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801efe:	e9 e7 00 00 00       	jmp    801fea <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f10:	a1 40 40 80 00       	mov    0x804040,%eax
  801f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f18:	e9 9d 00 00 00       	jmp    801fba <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	8b 00                	mov    (%eax),%eax
  801f22:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	8b 50 08             	mov    0x8(%eax),%edx
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 40 08             	mov    0x8(%eax),%eax
  801f31:	39 c2                	cmp    %eax,%edx
  801f33:	76 7d                	jbe    801fb2 <insert_sorted_allocList+0x251>
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	8b 50 08             	mov    0x8(%eax),%edx
  801f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3e:	8b 40 08             	mov    0x8(%eax),%eax
  801f41:	39 c2                	cmp    %eax,%edx
  801f43:	73 6d                	jae    801fb2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f49:	74 06                	je     801f51 <insert_sorted_allocList+0x1f0>
  801f4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f4f:	75 14                	jne    801f65 <insert_sorted_allocList+0x204>
  801f51:	83 ec 04             	sub    $0x4,%esp
  801f54:	68 24 3d 80 00       	push   $0x803d24
  801f59:	6a 7f                	push   $0x7f
  801f5b:	68 af 3c 80 00       	push   $0x803caf
  801f60:	e8 34 12 00 00       	call   803199 <_panic>
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 10                	mov    (%eax),%edx
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	89 10                	mov    %edx,(%eax)
  801f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f72:	8b 00                	mov    (%eax),%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	74 0b                	je     801f83 <insert_sorted_allocList+0x222>
  801f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7b:	8b 00                	mov    (%eax),%eax
  801f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f80:	89 50 04             	mov    %edx,0x4(%eax)
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 55 08             	mov    0x8(%ebp),%edx
  801f89:	89 10                	mov    %edx,(%eax)
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f91:	89 50 04             	mov    %edx,0x4(%eax)
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	8b 00                	mov    (%eax),%eax
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	75 08                	jne    801fa5 <insert_sorted_allocList+0x244>
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	a3 44 40 80 00       	mov    %eax,0x804044
  801fa5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801faa:	40                   	inc    %eax
  801fab:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  801fb0:	eb 39                	jmp    801feb <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801fb2:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbe:	74 07                	je     801fc7 <insert_sorted_allocList+0x266>
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	8b 00                	mov    (%eax),%eax
  801fc5:	eb 05                	jmp    801fcc <insert_sorted_allocList+0x26b>
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcc:	a3 48 40 80 00       	mov    %eax,0x804048
  801fd1:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	0f 85 3f ff ff ff    	jne    801f1d <insert_sorted_allocList+0x1bc>
  801fde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe2:	0f 85 35 ff ff ff    	jne    801f1d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  801fe8:	eb 01                	jmp    801feb <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fea:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  801feb:	90                   	nop
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  801ff4:	a1 38 41 80 00       	mov    0x804138,%eax
  801ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffc:	e9 85 01 00 00       	jmp    802186 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	8b 40 0c             	mov    0xc(%eax),%eax
  802007:	3b 45 08             	cmp    0x8(%ebp),%eax
  80200a:	0f 82 6e 01 00 00    	jb     80217e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 40 0c             	mov    0xc(%eax),%eax
  802016:	3b 45 08             	cmp    0x8(%ebp),%eax
  802019:	0f 85 8a 00 00 00    	jne    8020a9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80201f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802023:	75 17                	jne    80203c <alloc_block_FF+0x4e>
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	68 58 3d 80 00       	push   $0x803d58
  80202d:	68 93 00 00 00       	push   $0x93
  802032:	68 af 3c 80 00       	push   $0x803caf
  802037:	e8 5d 11 00 00       	call   803199 <_panic>
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	8b 00                	mov    (%eax),%eax
  802041:	85 c0                	test   %eax,%eax
  802043:	74 10                	je     802055 <alloc_block_FF+0x67>
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204d:	8b 52 04             	mov    0x4(%edx),%edx
  802050:	89 50 04             	mov    %edx,0x4(%eax)
  802053:	eb 0b                	jmp    802060 <alloc_block_FF+0x72>
  802055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802058:	8b 40 04             	mov    0x4(%eax),%eax
  80205b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802063:	8b 40 04             	mov    0x4(%eax),%eax
  802066:	85 c0                	test   %eax,%eax
  802068:	74 0f                	je     802079 <alloc_block_FF+0x8b>
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 04             	mov    0x4(%eax),%eax
  802070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802073:	8b 12                	mov    (%edx),%edx
  802075:	89 10                	mov    %edx,(%eax)
  802077:	eb 0a                	jmp    802083 <alloc_block_FF+0x95>
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 00                	mov    (%eax),%eax
  80207e:	a3 38 41 80 00       	mov    %eax,0x804138
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802096:	a1 44 41 80 00       	mov    0x804144,%eax
  80209b:	48                   	dec    %eax
  80209c:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	e9 10 01 00 00       	jmp    8021b9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8020af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020b2:	0f 86 c6 00 00 00    	jbe    80217e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8020b8:	a1 48 41 80 00       	mov    0x804148,%eax
  8020bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	8b 50 08             	mov    0x8(%eax),%edx
  8020c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8020cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d2:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8020d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d9:	75 17                	jne    8020f2 <alloc_block_FF+0x104>
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 58 3d 80 00       	push   $0x803d58
  8020e3:	68 9b 00 00 00       	push   $0x9b
  8020e8:	68 af 3c 80 00       	push   $0x803caf
  8020ed:	e8 a7 10 00 00       	call   803199 <_panic>
  8020f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	74 10                	je     80210b <alloc_block_FF+0x11d>
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802103:	8b 52 04             	mov    0x4(%edx),%edx
  802106:	89 50 04             	mov    %edx,0x4(%eax)
  802109:	eb 0b                	jmp    802116 <alloc_block_FF+0x128>
  80210b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210e:	8b 40 04             	mov    0x4(%eax),%eax
  802111:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802119:	8b 40 04             	mov    0x4(%eax),%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	74 0f                	je     80212f <alloc_block_FF+0x141>
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	8b 40 04             	mov    0x4(%eax),%eax
  802126:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802129:	8b 12                	mov    (%edx),%edx
  80212b:	89 10                	mov    %edx,(%eax)
  80212d:	eb 0a                	jmp    802139 <alloc_block_FF+0x14b>
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	a3 48 41 80 00       	mov    %eax,0x804148
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802145:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214c:	a1 54 41 80 00       	mov    0x804154,%eax
  802151:	48                   	dec    %eax
  802152:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 50 08             	mov    0x8(%eax),%edx
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	01 c2                	add    %eax,%edx
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 40 0c             	mov    0xc(%eax),%eax
  80216e:	2b 45 08             	sub    0x8(%ebp),%eax
  802171:	89 c2                	mov    %eax,%edx
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	eb 3b                	jmp    8021b9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80217e:	a1 40 41 80 00       	mov    0x804140,%eax
  802183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218a:	74 07                	je     802193 <alloc_block_FF+0x1a5>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	eb 05                	jmp    802198 <alloc_block_FF+0x1aa>
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	a3 40 41 80 00       	mov    %eax,0x804140
  80219d:	a1 40 41 80 00       	mov    0x804140,%eax
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 85 57 fe ff ff    	jne    802001 <alloc_block_FF+0x13>
  8021aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ae:	0f 85 4d fe ff ff    	jne    802001 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8021c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8021c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8021cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021d0:	e9 df 00 00 00       	jmp    8022b4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8021d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8021db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021de:	0f 82 c8 00 00 00    	jb     8022ac <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ed:	0f 85 8a 00 00 00    	jne    80227d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8021f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f7:	75 17                	jne    802210 <alloc_block_BF+0x55>
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	68 58 3d 80 00       	push   $0x803d58
  802201:	68 b7 00 00 00       	push   $0xb7
  802206:	68 af 3c 80 00       	push   $0x803caf
  80220b:	e8 89 0f 00 00       	call   803199 <_panic>
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 00                	mov    (%eax),%eax
  802215:	85 c0                	test   %eax,%eax
  802217:	74 10                	je     802229 <alloc_block_BF+0x6e>
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	8b 00                	mov    (%eax),%eax
  80221e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802221:	8b 52 04             	mov    0x4(%edx),%edx
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	eb 0b                	jmp    802234 <alloc_block_BF+0x79>
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	8b 40 04             	mov    0x4(%eax),%eax
  80222f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 0f                	je     80224d <alloc_block_BF+0x92>
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 40 04             	mov    0x4(%eax),%eax
  802244:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802247:	8b 12                	mov    (%edx),%edx
  802249:	89 10                	mov    %edx,(%eax)
  80224b:	eb 0a                	jmp    802257 <alloc_block_BF+0x9c>
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 00                	mov    (%eax),%eax
  802252:	a3 38 41 80 00       	mov    %eax,0x804138
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226a:	a1 44 41 80 00       	mov    0x804144,%eax
  80226f:	48                   	dec    %eax
  802270:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	e9 4d 01 00 00       	jmp    8023ca <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 0c             	mov    0xc(%eax),%eax
  802283:	3b 45 08             	cmp    0x8(%ebp),%eax
  802286:	76 24                	jbe    8022ac <alloc_block_BF+0xf1>
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 40 0c             	mov    0xc(%eax),%eax
  80228e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802291:	73 19                	jae    8022ac <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802293:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 40 08             	mov    0x8(%eax),%eax
  8022a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8022ac:	a1 40 41 80 00       	mov    0x804140,%eax
  8022b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b8:	74 07                	je     8022c1 <alloc_block_BF+0x106>
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	8b 00                	mov    (%eax),%eax
  8022bf:	eb 05                	jmp    8022c6 <alloc_block_BF+0x10b>
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	a3 40 41 80 00       	mov    %eax,0x804140
  8022cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	0f 85 fd fe ff ff    	jne    8021d5 <alloc_block_BF+0x1a>
  8022d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dc:	0f 85 f3 fe ff ff    	jne    8021d5 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8022e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022e6:	0f 84 d9 00 00 00    	je     8023c5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022ec:	a1 48 41 80 00       	mov    0x804148,%eax
  8022f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8022f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022fa:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8022fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802300:	8b 55 08             	mov    0x8(%ebp),%edx
  802303:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802306:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80230a:	75 17                	jne    802323 <alloc_block_BF+0x168>
  80230c:	83 ec 04             	sub    $0x4,%esp
  80230f:	68 58 3d 80 00       	push   $0x803d58
  802314:	68 c7 00 00 00       	push   $0xc7
  802319:	68 af 3c 80 00       	push   $0x803caf
  80231e:	e8 76 0e 00 00       	call   803199 <_panic>
  802323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	85 c0                	test   %eax,%eax
  80232a:	74 10                	je     80233c <alloc_block_BF+0x181>
  80232c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802334:	8b 52 04             	mov    0x4(%edx),%edx
  802337:	89 50 04             	mov    %edx,0x4(%eax)
  80233a:	eb 0b                	jmp    802347 <alloc_block_BF+0x18c>
  80233c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233f:	8b 40 04             	mov    0x4(%eax),%eax
  802342:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80234a:	8b 40 04             	mov    0x4(%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0f                	je     802360 <alloc_block_BF+0x1a5>
  802351:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802354:	8b 40 04             	mov    0x4(%eax),%eax
  802357:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80235a:	8b 12                	mov    (%edx),%edx
  80235c:	89 10                	mov    %edx,(%eax)
  80235e:	eb 0a                	jmp    80236a <alloc_block_BF+0x1af>
  802360:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	a3 48 41 80 00       	mov    %eax,0x804148
  80236a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802373:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802376:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237d:	a1 54 41 80 00       	mov    0x804154,%eax
  802382:	48                   	dec    %eax
  802383:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802388:	83 ec 08             	sub    $0x8,%esp
  80238b:	ff 75 ec             	pushl  -0x14(%ebp)
  80238e:	68 38 41 80 00       	push   $0x804138
  802393:	e8 71 f9 ff ff       	call   801d09 <find_block>
  802398:	83 c4 10             	add    $0x10,%esp
  80239b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80239e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023a1:	8b 50 08             	mov    0x8(%eax),%edx
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	01 c2                	add    %eax,%edx
  8023a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ac:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8023af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023b8:	89 c2                	mov    %eax,%edx
  8023ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bd:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8023c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c3:	eb 05                	jmp    8023ca <alloc_block_BF+0x20f>
	}
	return NULL;
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8023d2:	a1 28 40 80 00       	mov    0x804028,%eax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	0f 85 de 01 00 00    	jne    8025bd <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8023df:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e7:	e9 9e 01 00 00       	jmp    80258a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f5:	0f 82 87 01 00 00    	jb     802582 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802401:	3b 45 08             	cmp    0x8(%ebp),%eax
  802404:	0f 85 95 00 00 00    	jne    80249f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80240a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240e:	75 17                	jne    802427 <alloc_block_NF+0x5b>
  802410:	83 ec 04             	sub    $0x4,%esp
  802413:	68 58 3d 80 00       	push   $0x803d58
  802418:	68 e0 00 00 00       	push   $0xe0
  80241d:	68 af 3c 80 00       	push   $0x803caf
  802422:	e8 72 0d 00 00       	call   803199 <_panic>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 10                	je     802440 <alloc_block_NF+0x74>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802438:	8b 52 04             	mov    0x4(%edx),%edx
  80243b:	89 50 04             	mov    %edx,0x4(%eax)
  80243e:	eb 0b                	jmp    80244b <alloc_block_NF+0x7f>
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 40 04             	mov    0x4(%eax),%eax
  802446:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 40 04             	mov    0x4(%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	74 0f                	je     802464 <alloc_block_NF+0x98>
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 04             	mov    0x4(%eax),%eax
  80245b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245e:	8b 12                	mov    (%edx),%edx
  802460:	89 10                	mov    %edx,(%eax)
  802462:	eb 0a                	jmp    80246e <alloc_block_NF+0xa2>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	a3 38 41 80 00       	mov    %eax,0x804138
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802481:	a1 44 41 80 00       	mov    0x804144,%eax
  802486:	48                   	dec    %eax
  802487:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 40 08             	mov    0x8(%eax),%eax
  802492:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	e9 f8 04 00 00       	jmp    802997 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a8:	0f 86 d4 00 00 00    	jbe    802582 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024ae:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 50 08             	mov    0x8(%eax),%edx
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8024c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024cf:	75 17                	jne    8024e8 <alloc_block_NF+0x11c>
  8024d1:	83 ec 04             	sub    $0x4,%esp
  8024d4:	68 58 3d 80 00       	push   $0x803d58
  8024d9:	68 e9 00 00 00       	push   $0xe9
  8024de:	68 af 3c 80 00       	push   $0x803caf
  8024e3:	e8 b1 0c 00 00       	call   803199 <_panic>
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	8b 00                	mov    (%eax),%eax
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	74 10                	je     802501 <alloc_block_NF+0x135>
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f9:	8b 52 04             	mov    0x4(%edx),%edx
  8024fc:	89 50 04             	mov    %edx,0x4(%eax)
  8024ff:	eb 0b                	jmp    80250c <alloc_block_NF+0x140>
  802501:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802504:	8b 40 04             	mov    0x4(%eax),%eax
  802507:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250f:	8b 40 04             	mov    0x4(%eax),%eax
  802512:	85 c0                	test   %eax,%eax
  802514:	74 0f                	je     802525 <alloc_block_NF+0x159>
  802516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802519:	8b 40 04             	mov    0x4(%eax),%eax
  80251c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251f:	8b 12                	mov    (%edx),%edx
  802521:	89 10                	mov    %edx,(%eax)
  802523:	eb 0a                	jmp    80252f <alloc_block_NF+0x163>
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	a3 48 41 80 00       	mov    %eax,0x804148
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802542:	a1 54 41 80 00       	mov    0x804154,%eax
  802547:	48                   	dec    %eax
  802548:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	8b 40 08             	mov    0x8(%eax),%eax
  802553:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 50 08             	mov    0x8(%eax),%edx
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	01 c2                	add    %eax,%edx
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 0c             	mov    0xc(%eax),%eax
  80256f:	2b 45 08             	sub    0x8(%ebp),%eax
  802572:	89 c2                	mov    %eax,%edx
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80257a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257d:	e9 15 04 00 00       	jmp    802997 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802582:	a1 40 41 80 00       	mov    0x804140,%eax
  802587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258e:	74 07                	je     802597 <alloc_block_NF+0x1cb>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	eb 05                	jmp    80259c <alloc_block_NF+0x1d0>
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	a3 40 41 80 00       	mov    %eax,0x804140
  8025a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	0f 85 3e fe ff ff    	jne    8023ec <alloc_block_NF+0x20>
  8025ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b2:	0f 85 34 fe ff ff    	jne    8023ec <alloc_block_NF+0x20>
  8025b8:	e9 d5 03 00 00       	jmp    802992 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8025bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8025c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c5:	e9 b1 01 00 00       	jmp    80277b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 50 08             	mov    0x8(%eax),%edx
  8025d0:	a1 28 40 80 00       	mov    0x804028,%eax
  8025d5:	39 c2                	cmp    %eax,%edx
  8025d7:	0f 82 96 01 00 00    	jb     802773 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e6:	0f 82 87 01 00 00    	jb     802773 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f5:	0f 85 95 00 00 00    	jne    802690 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8025fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ff:	75 17                	jne    802618 <alloc_block_NF+0x24c>
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	68 58 3d 80 00       	push   $0x803d58
  802609:	68 fc 00 00 00       	push   $0xfc
  80260e:	68 af 3c 80 00       	push   $0x803caf
  802613:	e8 81 0b 00 00       	call   803199 <_panic>
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 10                	je     802631 <alloc_block_NF+0x265>
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802629:	8b 52 04             	mov    0x4(%edx),%edx
  80262c:	89 50 04             	mov    %edx,0x4(%eax)
  80262f:	eb 0b                	jmp    80263c <alloc_block_NF+0x270>
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 04             	mov    0x4(%eax),%eax
  802637:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	74 0f                	je     802655 <alloc_block_NF+0x289>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264f:	8b 12                	mov    (%edx),%edx
  802651:	89 10                	mov    %edx,(%eax)
  802653:	eb 0a                	jmp    80265f <alloc_block_NF+0x293>
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	a3 38 41 80 00       	mov    %eax,0x804138
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802672:	a1 44 41 80 00       	mov    0x804144,%eax
  802677:	48                   	dec    %eax
  802678:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 08             	mov    0x8(%eax),%eax
  802683:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	e9 07 03 00 00       	jmp    802997 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 0c             	mov    0xc(%eax),%eax
  802696:	3b 45 08             	cmp    0x8(%ebp),%eax
  802699:	0f 86 d4 00 00 00    	jbe    802773 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80269f:	a1 48 41 80 00       	mov    0x804148,%eax
  8026a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 50 08             	mov    0x8(%eax),%edx
  8026ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8026b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026c0:	75 17                	jne    8026d9 <alloc_block_NF+0x30d>
  8026c2:	83 ec 04             	sub    $0x4,%esp
  8026c5:	68 58 3d 80 00       	push   $0x803d58
  8026ca:	68 04 01 00 00       	push   $0x104
  8026cf:	68 af 3c 80 00       	push   $0x803caf
  8026d4:	e8 c0 0a 00 00       	call   803199 <_panic>
  8026d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 10                	je     8026f2 <alloc_block_NF+0x326>
  8026e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ea:	8b 52 04             	mov    0x4(%edx),%edx
  8026ed:	89 50 04             	mov    %edx,0x4(%eax)
  8026f0:	eb 0b                	jmp    8026fd <alloc_block_NF+0x331>
  8026f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f5:	8b 40 04             	mov    0x4(%eax),%eax
  8026f8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	85 c0                	test   %eax,%eax
  802705:	74 0f                	je     802716 <alloc_block_NF+0x34a>
  802707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802710:	8b 12                	mov    (%edx),%edx
  802712:	89 10                	mov    %edx,(%eax)
  802714:	eb 0a                	jmp    802720 <alloc_block_NF+0x354>
  802716:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	a3 48 41 80 00       	mov    %eax,0x804148
  802720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802729:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802733:	a1 54 41 80 00       	mov    0x804154,%eax
  802738:	48                   	dec    %eax
  802739:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80273e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802741:	8b 40 08             	mov    0x8(%eax),%eax
  802744:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	8b 50 08             	mov    0x8(%eax),%edx
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	01 c2                	add    %eax,%edx
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 0c             	mov    0xc(%eax),%eax
  802760:	2b 45 08             	sub    0x8(%ebp),%eax
  802763:	89 c2                	mov    %eax,%edx
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80276b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276e:	e9 24 02 00 00       	jmp    802997 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802773:	a1 40 41 80 00       	mov    0x804140,%eax
  802778:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277f:	74 07                	je     802788 <alloc_block_NF+0x3bc>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	eb 05                	jmp    80278d <alloc_block_NF+0x3c1>
  802788:	b8 00 00 00 00       	mov    $0x0,%eax
  80278d:	a3 40 41 80 00       	mov    %eax,0x804140
  802792:	a1 40 41 80 00       	mov    0x804140,%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	0f 85 2b fe ff ff    	jne    8025ca <alloc_block_NF+0x1fe>
  80279f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a3:	0f 85 21 fe ff ff    	jne    8025ca <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8027ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b1:	e9 ae 01 00 00       	jmp    802964 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 50 08             	mov    0x8(%eax),%edx
  8027bc:	a1 28 40 80 00       	mov    0x804028,%eax
  8027c1:	39 c2                	cmp    %eax,%edx
  8027c3:	0f 83 93 01 00 00    	jae    80295c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d2:	0f 82 84 01 00 00    	jb     80295c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 40 0c             	mov    0xc(%eax),%eax
  8027de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e1:	0f 85 95 00 00 00    	jne    80287c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	75 17                	jne    802804 <alloc_block_NF+0x438>
  8027ed:	83 ec 04             	sub    $0x4,%esp
  8027f0:	68 58 3d 80 00       	push   $0x803d58
  8027f5:	68 14 01 00 00       	push   $0x114
  8027fa:	68 af 3c 80 00       	push   $0x803caf
  8027ff:	e8 95 09 00 00       	call   803199 <_panic>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 00                	mov    (%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 10                	je     80281d <alloc_block_NF+0x451>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 00                	mov    (%eax),%eax
  802812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802815:	8b 52 04             	mov    0x4(%edx),%edx
  802818:	89 50 04             	mov    %edx,0x4(%eax)
  80281b:	eb 0b                	jmp    802828 <alloc_block_NF+0x45c>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	85 c0                	test   %eax,%eax
  802830:	74 0f                	je     802841 <alloc_block_NF+0x475>
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 04             	mov    0x4(%eax),%eax
  802838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283b:	8b 12                	mov    (%edx),%edx
  80283d:	89 10                	mov    %edx,(%eax)
  80283f:	eb 0a                	jmp    80284b <alloc_block_NF+0x47f>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 00                	mov    (%eax),%eax
  802846:	a3 38 41 80 00       	mov    %eax,0x804138
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285e:	a1 44 41 80 00       	mov    0x804144,%eax
  802863:	48                   	dec    %eax
  802864:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 08             	mov    0x8(%eax),%eax
  80286f:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	e9 1b 01 00 00       	jmp    802997 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 40 0c             	mov    0xc(%eax),%eax
  802882:	3b 45 08             	cmp    0x8(%ebp),%eax
  802885:	0f 86 d1 00 00 00    	jbe    80295c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80288b:	a1 48 41 80 00       	mov    0x804148,%eax
  802890:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 50 08             	mov    0x8(%eax),%edx
  802899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028ac:	75 17                	jne    8028c5 <alloc_block_NF+0x4f9>
  8028ae:	83 ec 04             	sub    $0x4,%esp
  8028b1:	68 58 3d 80 00       	push   $0x803d58
  8028b6:	68 1c 01 00 00       	push   $0x11c
  8028bb:	68 af 3c 80 00       	push   $0x803caf
  8028c0:	e8 d4 08 00 00       	call   803199 <_panic>
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	74 10                	je     8028de <alloc_block_NF+0x512>
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d6:	8b 52 04             	mov    0x4(%edx),%edx
  8028d9:	89 50 04             	mov    %edx,0x4(%eax)
  8028dc:	eb 0b                	jmp    8028e9 <alloc_block_NF+0x51d>
  8028de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e1:	8b 40 04             	mov    0x4(%eax),%eax
  8028e4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	8b 40 04             	mov    0x4(%eax),%eax
  8028ef:	85 c0                	test   %eax,%eax
  8028f1:	74 0f                	je     802902 <alloc_block_NF+0x536>
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028fc:	8b 12                	mov    (%edx),%edx
  8028fe:	89 10                	mov    %edx,(%eax)
  802900:	eb 0a                	jmp    80290c <alloc_block_NF+0x540>
  802902:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802905:	8b 00                	mov    (%eax),%eax
  802907:	a3 48 41 80 00       	mov    %eax,0x804148
  80290c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802915:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802918:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291f:	a1 54 41 80 00       	mov    0x804154,%eax
  802924:	48                   	dec    %eax
  802925:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80292a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 50 08             	mov    0x8(%eax),%edx
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	01 c2                	add    %eax,%edx
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 0c             	mov    0xc(%eax),%eax
  80294c:	2b 45 08             	sub    0x8(%ebp),%eax
  80294f:	89 c2                	mov    %eax,%edx
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	eb 3b                	jmp    802997 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80295c:	a1 40 41 80 00       	mov    0x804140,%eax
  802961:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802968:	74 07                	je     802971 <alloc_block_NF+0x5a5>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	eb 05                	jmp    802976 <alloc_block_NF+0x5aa>
  802971:	b8 00 00 00 00       	mov    $0x0,%eax
  802976:	a3 40 41 80 00       	mov    %eax,0x804140
  80297b:	a1 40 41 80 00       	mov    0x804140,%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	0f 85 2e fe ff ff    	jne    8027b6 <alloc_block_NF+0x3ea>
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298c:	0f 85 24 fe ff ff    	jne    8027b6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802997:	c9                   	leave  
  802998:	c3                   	ret    

00802999 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80299f:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8029a7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029ac:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8029af:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 14                	je     8029cc <insert_sorted_with_merge_freeList+0x33>
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	8b 40 08             	mov    0x8(%eax),%eax
  8029c4:	39 c2                	cmp    %eax,%edx
  8029c6:	0f 87 9b 01 00 00    	ja     802b67 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  8029cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d0:	75 17                	jne    8029e9 <insert_sorted_with_merge_freeList+0x50>
  8029d2:	83 ec 04             	sub    $0x4,%esp
  8029d5:	68 8c 3c 80 00       	push   $0x803c8c
  8029da:	68 38 01 00 00       	push   $0x138
  8029df:	68 af 3c 80 00       	push   $0x803caf
  8029e4:	e8 b0 07 00 00       	call   803199 <_panic>
  8029e9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	89 10                	mov    %edx,(%eax)
  8029f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	85 c0                	test   %eax,%eax
  8029fb:	74 0d                	je     802a0a <insert_sorted_with_merge_freeList+0x71>
  8029fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802a02:	8b 55 08             	mov    0x8(%ebp),%edx
  802a05:	89 50 04             	mov    %edx,0x4(%eax)
  802a08:	eb 08                	jmp    802a12 <insert_sorted_with_merge_freeList+0x79>
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	a3 38 41 80 00       	mov    %eax,0x804138
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a24:	a1 44 41 80 00       	mov    0x804144,%eax
  802a29:	40                   	inc    %eax
  802a2a:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802a2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a33:	0f 84 a8 06 00 00    	je     8030e1 <insert_sorted_with_merge_freeList+0x748>
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	8b 50 08             	mov    0x8(%eax),%edx
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	8b 40 0c             	mov    0xc(%eax),%eax
  802a45:	01 c2                	add    %eax,%edx
  802a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4a:	8b 40 08             	mov    0x8(%eax),%eax
  802a4d:	39 c2                	cmp    %eax,%edx
  802a4f:	0f 85 8c 06 00 00    	jne    8030e1 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	8b 50 0c             	mov    0xc(%eax),%edx
  802a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a61:	01 c2                	add    %eax,%edx
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802a69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a6d:	75 17                	jne    802a86 <insert_sorted_with_merge_freeList+0xed>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 58 3d 80 00       	push   $0x803d58
  802a77:	68 3c 01 00 00       	push   $0x13c
  802a7c:	68 af 3c 80 00       	push   $0x803caf
  802a81:	e8 13 07 00 00       	call   803199 <_panic>
  802a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 10                	je     802a9f <insert_sorted_with_merge_freeList+0x106>
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a97:	8b 52 04             	mov    0x4(%edx),%edx
  802a9a:	89 50 04             	mov    %edx,0x4(%eax)
  802a9d:	eb 0b                	jmp    802aaa <insert_sorted_with_merge_freeList+0x111>
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 40 04             	mov    0x4(%eax),%eax
  802aa5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aad:	8b 40 04             	mov    0x4(%eax),%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	74 0f                	je     802ac3 <insert_sorted_with_merge_freeList+0x12a>
  802ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab7:	8b 40 04             	mov    0x4(%eax),%eax
  802aba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802abd:	8b 12                	mov    (%edx),%edx
  802abf:	89 10                	mov    %edx,(%eax)
  802ac1:	eb 0a                	jmp    802acd <insert_sorted_with_merge_freeList+0x134>
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	a3 38 41 80 00       	mov    %eax,0x804138
  802acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae5:	48                   	dec    %eax
  802ae6:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802aff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b03:	75 17                	jne    802b1c <insert_sorted_with_merge_freeList+0x183>
  802b05:	83 ec 04             	sub    $0x4,%esp
  802b08:	68 8c 3c 80 00       	push   $0x803c8c
  802b0d:	68 3f 01 00 00       	push   $0x13f
  802b12:	68 af 3c 80 00       	push   $0x803caf
  802b17:	e8 7d 06 00 00       	call   803199 <_panic>
  802b1c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	89 10                	mov    %edx,(%eax)
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 0d                	je     802b3d <insert_sorted_with_merge_freeList+0x1a4>
  802b30:	a1 48 41 80 00       	mov    0x804148,%eax
  802b35:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b38:	89 50 04             	mov    %edx,0x4(%eax)
  802b3b:	eb 08                	jmp    802b45 <insert_sorted_with_merge_freeList+0x1ac>
  802b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b40:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	a3 48 41 80 00       	mov    %eax,0x804148
  802b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b57:	a1 54 41 80 00       	mov    0x804154,%eax
  802b5c:	40                   	inc    %eax
  802b5d:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b62:	e9 7a 05 00 00       	jmp    8030e1 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	8b 50 08             	mov    0x8(%eax),%edx
  802b6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b70:	8b 40 08             	mov    0x8(%eax),%eax
  802b73:	39 c2                	cmp    %eax,%edx
  802b75:	0f 82 14 01 00 00    	jb     802c8f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7e:	8b 50 08             	mov    0x8(%eax),%edx
  802b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b84:	8b 40 0c             	mov    0xc(%eax),%eax
  802b87:	01 c2                	add    %eax,%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	39 c2                	cmp    %eax,%edx
  802b91:	0f 85 90 00 00 00    	jne    802c27 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba3:	01 c2                	add    %eax,%edx
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc3:	75 17                	jne    802bdc <insert_sorted_with_merge_freeList+0x243>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 8c 3c 80 00       	push   $0x803c8c
  802bcd:	68 49 01 00 00       	push   $0x149
  802bd2:	68 af 3c 80 00       	push   $0x803caf
  802bd7:	e8 bd 05 00 00       	call   803199 <_panic>
  802bdc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	89 10                	mov    %edx,(%eax)
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	85 c0                	test   %eax,%eax
  802bee:	74 0d                	je     802bfd <insert_sorted_with_merge_freeList+0x264>
  802bf0:	a1 48 41 80 00       	mov    0x804148,%eax
  802bf5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf8:	89 50 04             	mov    %edx,0x4(%eax)
  802bfb:	eb 08                	jmp    802c05 <insert_sorted_with_merge_freeList+0x26c>
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	a3 48 41 80 00       	mov    %eax,0x804148
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c17:	a1 54 41 80 00       	mov    0x804154,%eax
  802c1c:	40                   	inc    %eax
  802c1d:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c22:	e9 bb 04 00 00       	jmp    8030e2 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2b:	75 17                	jne    802c44 <insert_sorted_with_merge_freeList+0x2ab>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 00 3d 80 00       	push   $0x803d00
  802c35:	68 4c 01 00 00       	push   $0x14c
  802c3a:	68 af 3c 80 00       	push   $0x803caf
  802c3f:	e8 55 05 00 00       	call   803199 <_panic>
  802c44:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 0c                	je     802c66 <insert_sorted_with_merge_freeList+0x2cd>
  802c5a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 08                	jmp    802c6e <insert_sorted_with_merge_freeList+0x2d5>
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 38 41 80 00       	mov    %eax,0x804138
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7f:	a1 44 41 80 00       	mov    0x804144,%eax
  802c84:	40                   	inc    %eax
  802c85:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c8a:	e9 53 04 00 00       	jmp    8030e2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802c8f:	a1 38 41 80 00       	mov    0x804138,%eax
  802c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c97:	e9 15 04 00 00       	jmp    8030b1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	0f 86 f1 03 00 00    	jbe    8030a9 <insert_sorted_with_merge_freeList+0x710>
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc1:	8b 40 08             	mov    0x8(%eax),%eax
  802cc4:	39 c2                	cmp    %eax,%edx
  802cc6:	0f 83 dd 03 00 00    	jae    8030a9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 50 08             	mov    0x8(%eax),%edx
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd8:	01 c2                	add    %eax,%edx
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	8b 40 08             	mov    0x8(%eax),%eax
  802ce0:	39 c2                	cmp    %eax,%edx
  802ce2:	0f 85 b9 01 00 00    	jne    802ea1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf4:	01 c2                	add    %eax,%edx
  802cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf9:	8b 40 08             	mov    0x8(%eax),%eax
  802cfc:	39 c2                	cmp    %eax,%edx
  802cfe:	0f 85 0d 01 00 00    	jne    802e11 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 50 0c             	mov    0xc(%eax),%edx
  802d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d10:	01 c2                	add    %eax,%edx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d1c:	75 17                	jne    802d35 <insert_sorted_with_merge_freeList+0x39c>
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 58 3d 80 00       	push   $0x803d58
  802d26:	68 5c 01 00 00       	push   $0x15c
  802d2b:	68 af 3c 80 00       	push   $0x803caf
  802d30:	e8 64 04 00 00       	call   803199 <_panic>
  802d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 10                	je     802d4e <insert_sorted_with_merge_freeList+0x3b5>
  802d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d46:	8b 52 04             	mov    0x4(%edx),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	eb 0b                	jmp    802d59 <insert_sorted_with_merge_freeList+0x3c0>
  802d4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d5c:	8b 40 04             	mov    0x4(%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 0f                	je     802d72 <insert_sorted_with_merge_freeList+0x3d9>
  802d63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d6c:	8b 12                	mov    (%edx),%edx
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	eb 0a                	jmp    802d7c <insert_sorted_with_merge_freeList+0x3e3>
  802d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	a3 38 41 80 00       	mov    %eax,0x804138
  802d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d94:	48                   	dec    %eax
  802d95:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802d9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802dae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802db2:	75 17                	jne    802dcb <insert_sorted_with_merge_freeList+0x432>
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	68 8c 3c 80 00       	push   $0x803c8c
  802dbc:	68 5f 01 00 00       	push   $0x15f
  802dc1:	68 af 3c 80 00       	push   $0x803caf
  802dc6:	e8 ce 03 00 00       	call   803199 <_panic>
  802dcb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd9:	8b 00                	mov    (%eax),%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	74 0d                	je     802dec <insert_sorted_with_merge_freeList+0x453>
  802ddf:	a1 48 41 80 00       	mov    0x804148,%eax
  802de4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de7:	89 50 04             	mov    %edx,0x4(%eax)
  802dea:	eb 08                	jmp    802df4 <insert_sorted_with_merge_freeList+0x45b>
  802dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802def:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e06:	a1 54 41 80 00       	mov    0x804154,%eax
  802e0b:	40                   	inc    %eax
  802e0c:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	8b 50 0c             	mov    0xc(%eax),%edx
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1d:	01 c2                	add    %eax,%edx
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3d:	75 17                	jne    802e56 <insert_sorted_with_merge_freeList+0x4bd>
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 8c 3c 80 00       	push   $0x803c8c
  802e47:	68 64 01 00 00       	push   $0x164
  802e4c:	68 af 3c 80 00       	push   $0x803caf
  802e51:	e8 43 03 00 00       	call   803199 <_panic>
  802e56:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	89 10                	mov    %edx,(%eax)
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 0d                	je     802e77 <insert_sorted_with_merge_freeList+0x4de>
  802e6a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e72:	89 50 04             	mov    %edx,0x4(%eax)
  802e75:	eb 08                	jmp    802e7f <insert_sorted_with_merge_freeList+0x4e6>
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	a3 48 41 80 00       	mov    %eax,0x804148
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e91:	a1 54 41 80 00       	mov    0x804154,%eax
  802e96:	40                   	inc    %eax
  802e97:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802e9c:	e9 41 02 00 00       	jmp    8030e2 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	8b 50 08             	mov    0x8(%eax),%edx
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	01 c2                	add    %eax,%edx
  802eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb2:	8b 40 08             	mov    0x8(%eax),%eax
  802eb5:	39 c2                	cmp    %eax,%edx
  802eb7:	0f 85 7c 01 00 00    	jne    803039 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802ebd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec1:	74 06                	je     802ec9 <insert_sorted_with_merge_freeList+0x530>
  802ec3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec7:	75 17                	jne    802ee0 <insert_sorted_with_merge_freeList+0x547>
  802ec9:	83 ec 04             	sub    $0x4,%esp
  802ecc:	68 c8 3c 80 00       	push   $0x803cc8
  802ed1:	68 69 01 00 00       	push   $0x169
  802ed6:	68 af 3c 80 00       	push   $0x803caf
  802edb:	e8 b9 02 00 00       	call   803199 <_panic>
  802ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee3:	8b 50 04             	mov    0x4(%eax),%edx
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef2:	89 10                	mov    %edx,(%eax)
  802ef4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	74 0d                	je     802f0b <insert_sorted_with_merge_freeList+0x572>
  802efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f01:	8b 40 04             	mov    0x4(%eax),%eax
  802f04:	8b 55 08             	mov    0x8(%ebp),%edx
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	eb 08                	jmp    802f13 <insert_sorted_with_merge_freeList+0x57a>
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	a3 38 41 80 00       	mov    %eax,0x804138
  802f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f16:	8b 55 08             	mov    0x8(%ebp),%edx
  802f19:	89 50 04             	mov    %edx,0x4(%eax)
  802f1c:	a1 44 41 80 00       	mov    0x804144,%eax
  802f21:	40                   	inc    %eax
  802f22:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 0c             	mov    0xc(%eax),%eax
  802f33:	01 c2                	add    %eax,%edx
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3f:	75 17                	jne    802f58 <insert_sorted_with_merge_freeList+0x5bf>
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	68 58 3d 80 00       	push   $0x803d58
  802f49:	68 6b 01 00 00       	push   $0x16b
  802f4e:	68 af 3c 80 00       	push   $0x803caf
  802f53:	e8 41 02 00 00       	call   803199 <_panic>
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 10                	je     802f71 <insert_sorted_with_merge_freeList+0x5d8>
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f69:	8b 52 04             	mov    0x4(%edx),%edx
  802f6c:	89 50 04             	mov    %edx,0x4(%eax)
  802f6f:	eb 0b                	jmp    802f7c <insert_sorted_with_merge_freeList+0x5e3>
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 0f                	je     802f95 <insert_sorted_with_merge_freeList+0x5fc>
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8f:	8b 12                	mov    (%edx),%edx
  802f91:	89 10                	mov    %edx,(%eax)
  802f93:	eb 0a                	jmp    802f9f <insert_sorted_with_merge_freeList+0x606>
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb2:	a1 44 41 80 00       	mov    0x804144,%eax
  802fb7:	48                   	dec    %eax
  802fb8:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd5:	75 17                	jne    802fee <insert_sorted_with_merge_freeList+0x655>
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 8c 3c 80 00       	push   $0x803c8c
  802fdf:	68 6e 01 00 00       	push   $0x16e
  802fe4:	68 af 3c 80 00       	push   $0x803caf
  802fe9:	e8 ab 01 00 00       	call   803199 <_panic>
  802fee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	74 0d                	je     80300f <insert_sorted_with_merge_freeList+0x676>
  803002:	a1 48 41 80 00       	mov    0x804148,%eax
  803007:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 08                	jmp    803017 <insert_sorted_with_merge_freeList+0x67e>
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	a3 48 41 80 00       	mov    %eax,0x804148
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803029:	a1 54 41 80 00       	mov    0x804154,%eax
  80302e:	40                   	inc    %eax
  80302f:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803034:	e9 a9 00 00 00       	jmp    8030e2 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303d:	74 06                	je     803045 <insert_sorted_with_merge_freeList+0x6ac>
  80303f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803043:	75 17                	jne    80305c <insert_sorted_with_merge_freeList+0x6c3>
  803045:	83 ec 04             	sub    $0x4,%esp
  803048:	68 24 3d 80 00       	push   $0x803d24
  80304d:	68 73 01 00 00       	push   $0x173
  803052:	68 af 3c 80 00       	push   $0x803caf
  803057:	e8 3d 01 00 00       	call   803199 <_panic>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 10                	mov    (%eax),%edx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	89 10                	mov    %edx,(%eax)
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	74 0b                	je     80307a <insert_sorted_with_merge_freeList+0x6e1>
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	8b 55 08             	mov    0x8(%ebp),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 55 08             	mov    0x8(%ebp),%edx
  803080:	89 10                	mov    %edx,(%eax)
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803088:	89 50 04             	mov    %edx,0x4(%eax)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	75 08                	jne    80309c <insert_sorted_with_merge_freeList+0x703>
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80309c:	a1 44 41 80 00       	mov    0x804144,%eax
  8030a1:	40                   	inc    %eax
  8030a2:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8030a7:	eb 39                	jmp    8030e2 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030a9:	a1 40 41 80 00       	mov    0x804140,%eax
  8030ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b5:	74 07                	je     8030be <insert_sorted_with_merge_freeList+0x725>
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 00                	mov    (%eax),%eax
  8030bc:	eb 05                	jmp    8030c3 <insert_sorted_with_merge_freeList+0x72a>
  8030be:	b8 00 00 00 00       	mov    $0x0,%eax
  8030c3:	a3 40 41 80 00       	mov    %eax,0x804140
  8030c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8030cd:	85 c0                	test   %eax,%eax
  8030cf:	0f 85 c7 fb ff ff    	jne    802c9c <insert_sorted_with_merge_freeList+0x303>
  8030d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d9:	0f 85 bd fb ff ff    	jne    802c9c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030df:	eb 01                	jmp    8030e2 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030e1:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030e2:	90                   	nop
  8030e3:	c9                   	leave  
  8030e4:	c3                   	ret    

008030e5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030e5:	55                   	push   %ebp
  8030e6:	89 e5                	mov    %esp,%ebp
  8030e8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ee:	89 d0                	mov    %edx,%eax
  8030f0:	c1 e0 02             	shl    $0x2,%eax
  8030f3:	01 d0                	add    %edx,%eax
  8030f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030fc:	01 d0                	add    %edx,%eax
  8030fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803105:	01 d0                	add    %edx,%eax
  803107:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80310e:	01 d0                	add    %edx,%eax
  803110:	c1 e0 04             	shl    $0x4,%eax
  803113:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803116:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80311d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803120:	83 ec 0c             	sub    $0xc,%esp
  803123:	50                   	push   %eax
  803124:	e8 26 e7 ff ff       	call   80184f <sys_get_virtual_time>
  803129:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80312c:	eb 41                	jmp    80316f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80312e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803131:	83 ec 0c             	sub    $0xc,%esp
  803134:	50                   	push   %eax
  803135:	e8 15 e7 ff ff       	call   80184f <sys_get_virtual_time>
  80313a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80313d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	29 c2                	sub    %eax,%edx
  803145:	89 d0                	mov    %edx,%eax
  803147:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80314a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80314d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803150:	89 d1                	mov    %edx,%ecx
  803152:	29 c1                	sub    %eax,%ecx
  803154:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803157:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80315a:	39 c2                	cmp    %eax,%edx
  80315c:	0f 97 c0             	seta   %al
  80315f:	0f b6 c0             	movzbl %al,%eax
  803162:	29 c1                	sub    %eax,%ecx
  803164:	89 c8                	mov    %ecx,%eax
  803166:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803169:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80316c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803175:	72 b7                	jb     80312e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803177:	90                   	nop
  803178:	c9                   	leave  
  803179:	c3                   	ret    

0080317a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80317a:	55                   	push   %ebp
  80317b:	89 e5                	mov    %esp,%ebp
  80317d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803187:	eb 03                	jmp    80318c <busy_wait+0x12>
  803189:	ff 45 fc             	incl   -0x4(%ebp)
  80318c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80318f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803192:	72 f5                	jb     803189 <busy_wait+0xf>
	return i;
  803194:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803197:	c9                   	leave  
  803198:	c3                   	ret    

00803199 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803199:	55                   	push   %ebp
  80319a:	89 e5                	mov    %esp,%ebp
  80319c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80319f:	8d 45 10             	lea    0x10(%ebp),%eax
  8031a2:	83 c0 04             	add    $0x4,%eax
  8031a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8031a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031ad:	85 c0                	test   %eax,%eax
  8031af:	74 16                	je     8031c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8031b1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031b6:	83 ec 08             	sub    $0x8,%esp
  8031b9:	50                   	push   %eax
  8031ba:	68 78 3d 80 00       	push   $0x803d78
  8031bf:	e8 b7 d1 ff ff       	call   80037b <cprintf>
  8031c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8031cc:	ff 75 0c             	pushl  0xc(%ebp)
  8031cf:	ff 75 08             	pushl  0x8(%ebp)
  8031d2:	50                   	push   %eax
  8031d3:	68 7d 3d 80 00       	push   $0x803d7d
  8031d8:	e8 9e d1 ff ff       	call   80037b <cprintf>
  8031dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e3:	83 ec 08             	sub    $0x8,%esp
  8031e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8031e9:	50                   	push   %eax
  8031ea:	e8 21 d1 ff ff       	call   800310 <vcprintf>
  8031ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031f2:	83 ec 08             	sub    $0x8,%esp
  8031f5:	6a 00                	push   $0x0
  8031f7:	68 99 3d 80 00       	push   $0x803d99
  8031fc:	e8 0f d1 ff ff       	call   800310 <vcprintf>
  803201:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803204:	e8 90 d0 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  803209:	eb fe                	jmp    803209 <_panic+0x70>

0080320b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80320b:	55                   	push   %ebp
  80320c:	89 e5                	mov    %esp,%ebp
  80320e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803211:	a1 20 40 80 00       	mov    0x804020,%eax
  803216:	8b 50 74             	mov    0x74(%eax),%edx
  803219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80321c:	39 c2                	cmp    %eax,%edx
  80321e:	74 14                	je     803234 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803220:	83 ec 04             	sub    $0x4,%esp
  803223:	68 9c 3d 80 00       	push   $0x803d9c
  803228:	6a 26                	push   $0x26
  80322a:	68 e8 3d 80 00       	push   $0x803de8
  80322f:	e8 65 ff ff ff       	call   803199 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80323b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803242:	e9 c2 00 00 00       	jmp    803309 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	01 d0                	add    %edx,%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	75 08                	jne    803264 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80325c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80325f:	e9 a2 00 00 00       	jmp    803306 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803264:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80326b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803272:	eb 69                	jmp    8032dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803274:	a1 20 40 80 00       	mov    0x804020,%eax
  803279:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80327f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803282:	89 d0                	mov    %edx,%eax
  803284:	01 c0                	add    %eax,%eax
  803286:	01 d0                	add    %edx,%eax
  803288:	c1 e0 03             	shl    $0x3,%eax
  80328b:	01 c8                	add    %ecx,%eax
  80328d:	8a 40 04             	mov    0x4(%eax),%al
  803290:	84 c0                	test   %al,%al
  803292:	75 46                	jne    8032da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803294:	a1 20 40 80 00       	mov    0x804020,%eax
  803299:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80329f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a2:	89 d0                	mov    %edx,%eax
  8032a4:	01 c0                	add    %eax,%eax
  8032a6:	01 d0                	add    %edx,%eax
  8032a8:	c1 e0 03             	shl    $0x3,%eax
  8032ab:	01 c8                	add    %ecx,%eax
  8032ad:	8b 00                	mov    (%eax),%eax
  8032af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	01 c8                	add    %ecx,%eax
  8032cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032cd:	39 c2                	cmp    %eax,%edx
  8032cf:	75 09                	jne    8032da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032d8:	eb 12                	jmp    8032ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032da:	ff 45 e8             	incl   -0x18(%ebp)
  8032dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8032e2:	8b 50 74             	mov    0x74(%eax),%edx
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	39 c2                	cmp    %eax,%edx
  8032ea:	77 88                	ja     803274 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032f0:	75 14                	jne    803306 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032f2:	83 ec 04             	sub    $0x4,%esp
  8032f5:	68 f4 3d 80 00       	push   $0x803df4
  8032fa:	6a 3a                	push   $0x3a
  8032fc:	68 e8 3d 80 00       	push   $0x803de8
  803301:	e8 93 fe ff ff       	call   803199 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803306:	ff 45 f0             	incl   -0x10(%ebp)
  803309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80330f:	0f 8c 32 ff ff ff    	jl     803247 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803315:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80331c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803323:	eb 26                	jmp    80334b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803325:	a1 20 40 80 00       	mov    0x804020,%eax
  80332a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803330:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803333:	89 d0                	mov    %edx,%eax
  803335:	01 c0                	add    %eax,%eax
  803337:	01 d0                	add    %edx,%eax
  803339:	c1 e0 03             	shl    $0x3,%eax
  80333c:	01 c8                	add    %ecx,%eax
  80333e:	8a 40 04             	mov    0x4(%eax),%al
  803341:	3c 01                	cmp    $0x1,%al
  803343:	75 03                	jne    803348 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803345:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803348:	ff 45 e0             	incl   -0x20(%ebp)
  80334b:	a1 20 40 80 00       	mov    0x804020,%eax
  803350:	8b 50 74             	mov    0x74(%eax),%edx
  803353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803356:	39 c2                	cmp    %eax,%edx
  803358:	77 cb                	ja     803325 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80335a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803360:	74 14                	je     803376 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803362:	83 ec 04             	sub    $0x4,%esp
  803365:	68 48 3e 80 00       	push   $0x803e48
  80336a:	6a 44                	push   $0x44
  80336c:	68 e8 3d 80 00       	push   $0x803de8
  803371:	e8 23 fe ff ff       	call   803199 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803376:	90                   	nop
  803377:	c9                   	leave  
  803378:	c3                   	ret    
  803379:	66 90                	xchg   %ax,%ax
  80337b:	90                   	nop

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
