
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
  80003e:	e8 41 18 00 00       	call   801884 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 60 36 80 00       	push   $0x803660
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 91 13 00 00       	call   8013e7 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 62 36 80 00       	push   $0x803662
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 7b 13 00 00       	call   8013e7 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 69 36 80 00       	push   $0x803669
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 65 13 00 00       	call   8013e7 <sget>
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
  800095:	68 77 36 80 00       	push   $0x803677
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 83 16 00 00       	call   801725 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 06 18 00 00       	call   8018b7 <sys_get_virtual_time>
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
  8000d4:	e8 74 30 00 00       	call   80314d <env_sleep>
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
  8000ec:	e8 c6 17 00 00       	call   8018b7 <sys_get_virtual_time>
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
  800114:	e8 34 30 00 00       	call   80314d <env_sleep>
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
  80012b:	e8 87 17 00 00       	call   8018b7 <sys_get_virtual_time>
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
  800153:	e8 f5 2f 00 00       	call   80314d <env_sleep>
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
  800171:	e8 f5 16 00 00       	call   80186b <sys_getenvindex>
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
  8001dc:	e8 97 14 00 00       	call   801678 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 94 36 80 00       	push   $0x803694
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
  80020c:	68 bc 36 80 00       	push   $0x8036bc
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
  80023d:	68 e4 36 80 00       	push   $0x8036e4
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 3c 37 80 00       	push   $0x80373c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 94 36 80 00       	push   $0x803694
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 17 14 00 00       	call   801692 <sys_enable_interrupt>

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
  80028e:	e8 a4 15 00 00       	call   801837 <sys_destroy_env>
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
  80029f:	e8 f9 15 00 00       	call   80189d <sys_exit_env>
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
  8002ed:	e8 d8 11 00 00       	call   8014ca <sys_cputs>
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
  800364:	e8 61 11 00 00       	call   8014ca <sys_cputs>
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
  8003ae:	e8 c5 12 00 00       	call   801678 <sys_disable_interrupt>
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
  8003ce:	e8 bf 12 00 00       	call   801692 <sys_enable_interrupt>
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
  800418:	e8 c7 2f 00 00       	call   8033e4 <__udivdi3>
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
  800468:	e8 87 30 00 00       	call   8034f4 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 74 39 80 00       	add    $0x803974,%eax
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
  8005c3:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
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
  8006a4:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 85 39 80 00       	push   $0x803985
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
  8006c9:	68 8e 39 80 00       	push   $0x80398e
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
  8006f6:	be 91 39 80 00       	mov    $0x803991,%esi
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
  80111c:	68 f0 3a 80 00       	push   $0x803af0
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8011cf:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011e3:	83 ec 04             	sub    $0x4,%esp
  8011e6:	6a 06                	push   $0x6
  8011e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8011eb:	50                   	push   %eax
  8011ec:	e8 1d 04 00 00       	call   80160e <sys_allocate_chunk>
  8011f1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	50                   	push   %eax
  8011fd:	e8 92 0a 00 00       	call   801c94 <initialize_MemBlocksList>
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
  80122a:	68 15 3b 80 00       	push   $0x803b15
  80122f:	6a 33                	push   $0x33
  801231:	68 33 3b 80 00       	push   $0x803b33
  801236:	e8 c6 1f 00 00       	call   803201 <_panic>
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
  8012a9:	68 40 3b 80 00       	push   $0x803b40
  8012ae:	6a 34                	push   $0x34
  8012b0:	68 33 3b 80 00       	push   $0x803b33
  8012b5:	e8 47 1f 00 00       	call   803201 <_panic>
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
  80131e:	68 64 3b 80 00       	push   $0x803b64
  801323:	6a 46                	push   $0x46
  801325:	68 33 3b 80 00       	push   $0x803b33
  80132a:	e8 d2 1e 00 00       	call   803201 <_panic>
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
  80133a:	68 8c 3b 80 00       	push   $0x803b8c
  80133f:	6a 61                	push   $0x61
  801341:	68 33 3b 80 00       	push   $0x803b33
  801346:	e8 b6 1e 00 00       	call   803201 <_panic>

0080134b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 38             	sub    $0x38,%esp
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801357:	e8 a9 fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80135c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801360:	75 07                	jne    801369 <smalloc+0x1e>
  801362:	b8 00 00 00 00       	mov    $0x0,%eax
  801367:	eb 7c                	jmp    8013e5 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801369:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801376:	01 d0                	add    %edx,%eax
  801378:	48                   	dec    %eax
  801379:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80137c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137f:	ba 00 00 00 00       	mov    $0x0,%edx
  801384:	f7 75 f0             	divl   -0x10(%ebp)
  801387:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138a:	29 d0                	sub    %edx,%eax
  80138c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80138f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801396:	e8 41 06 00 00       	call   8019dc <sys_isUHeapPlacementStrategyFIRSTFIT>
  80139b:	85 c0                	test   %eax,%eax
  80139d:	74 11                	je     8013b0 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a5:	e8 ac 0c 00 00       	call   802056 <alloc_block_FF>
  8013aa:	83 c4 10             	add    $0x10,%esp
  8013ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8013b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013b4:	74 2a                	je     8013e0 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8013b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b9:	8b 40 08             	mov    0x8(%eax),%eax
  8013bc:	89 c2                	mov    %eax,%edx
  8013be:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8013c2:	52                   	push   %edx
  8013c3:	50                   	push   %eax
  8013c4:	ff 75 0c             	pushl  0xc(%ebp)
  8013c7:	ff 75 08             	pushl  0x8(%ebp)
  8013ca:	e8 92 03 00 00       	call   801761 <sys_createSharedObject>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8013d5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8013d9:	74 05                	je     8013e0 <smalloc+0x95>
			return (void*)virtual_address;
  8013db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013de:	eb 05                	jmp    8013e5 <smalloc+0x9a>
	}
	return NULL;
  8013e0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8013e5:	c9                   	leave  
  8013e6:	c3                   	ret    

008013e7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013ed:	e8 13 fd ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013f2:	83 ec 04             	sub    $0x4,%esp
  8013f5:	68 b0 3b 80 00       	push   $0x803bb0
  8013fa:	68 a2 00 00 00       	push   $0xa2
  8013ff:	68 33 3b 80 00       	push   $0x803b33
  801404:	e8 f8 1d 00 00       	call   803201 <_panic>

00801409 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801409:	55                   	push   %ebp
  80140a:	89 e5                	mov    %esp,%ebp
  80140c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80140f:	e8 f1 fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	68 d4 3b 80 00       	push   $0x803bd4
  80141c:	68 e6 00 00 00       	push   $0xe6
  801421:	68 33 3b 80 00       	push   $0x803b33
  801426:	e8 d6 1d 00 00       	call   803201 <_panic>

0080142b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	68 fc 3b 80 00       	push   $0x803bfc
  801439:	68 fa 00 00 00       	push   $0xfa
  80143e:	68 33 3b 80 00       	push   $0x803b33
  801443:	e8 b9 1d 00 00       	call   803201 <_panic>

00801448 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	68 20 3c 80 00       	push   $0x803c20
  801456:	68 05 01 00 00       	push   $0x105
  80145b:	68 33 3b 80 00       	push   $0x803b33
  801460:	e8 9c 1d 00 00       	call   803201 <_panic>

00801465 <shrink>:

}
void shrink(uint32 newSize)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	68 20 3c 80 00       	push   $0x803c20
  801473:	68 0a 01 00 00       	push   $0x10a
  801478:	68 33 3b 80 00       	push   $0x803b33
  80147d:	e8 7f 1d 00 00       	call   803201 <_panic>

00801482 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801488:	83 ec 04             	sub    $0x4,%esp
  80148b:	68 20 3c 80 00       	push   $0x803c20
  801490:	68 0f 01 00 00       	push   $0x10f
  801495:	68 33 3b 80 00       	push   $0x803b33
  80149a:	e8 62 1d 00 00       	call   803201 <_panic>

0080149f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	57                   	push   %edi
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014b7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ba:	cd 30                	int    $0x30
  8014bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014d6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 00                	push   $0x0
  8014e1:	52                   	push   %edx
  8014e2:	ff 75 0c             	pushl  0xc(%ebp)
  8014e5:	50                   	push   %eax
  8014e6:	6a 00                	push   $0x0
  8014e8:	e8 b2 ff ff ff       	call   80149f <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
}
  8014f0:	90                   	nop
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    

008014f3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f3:	55                   	push   %ebp
  8014f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 01                	push   $0x1
  801502:	e8 98 ff ff ff       	call   80149f <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80150f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801512:	8b 45 08             	mov    0x8(%ebp),%eax
  801515:	6a 00                	push   $0x0
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	6a 05                	push   $0x5
  80151f:	e8 7b ff ff ff       	call   80149f <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	56                   	push   %esi
  80152d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80152e:	8b 75 18             	mov    0x18(%ebp),%esi
  801531:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801534:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	56                   	push   %esi
  80153e:	53                   	push   %ebx
  80153f:	51                   	push   %ecx
  801540:	52                   	push   %edx
  801541:	50                   	push   %eax
  801542:	6a 06                	push   $0x6
  801544:	e8 56 ff ff ff       	call   80149f <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
}
  80154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801556:	8b 55 0c             	mov    0xc(%ebp),%edx
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	52                   	push   %edx
  801563:	50                   	push   %eax
  801564:	6a 07                	push   $0x7
  801566:	e8 34 ff ff ff       	call   80149f <syscall>
  80156b:	83 c4 18             	add    $0x18,%esp
}
  80156e:	c9                   	leave  
  80156f:	c3                   	ret    

00801570 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801573:	6a 00                	push   $0x0
  801575:	6a 00                	push   $0x0
  801577:	6a 00                	push   $0x0
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	ff 75 08             	pushl  0x8(%ebp)
  80157f:	6a 08                	push   $0x8
  801581:	e8 19 ff ff ff       	call   80149f <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80158e:	6a 00                	push   $0x0
  801590:	6a 00                	push   $0x0
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 09                	push   $0x9
  80159a:	e8 00 ff ff ff       	call   80149f <syscall>
  80159f:	83 c4 18             	add    $0x18,%esp
}
  8015a2:	c9                   	leave  
  8015a3:	c3                   	ret    

008015a4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 0a                	push   $0xa
  8015b3:	e8 e7 fe ff ff       	call   80149f <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 0b                	push   $0xb
  8015cc:	e8 ce fe ff ff       	call   80149f <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	ff 75 0c             	pushl  0xc(%ebp)
  8015e2:	ff 75 08             	pushl  0x8(%ebp)
  8015e5:	6a 0f                	push   $0xf
  8015e7:	e8 b3 fe ff ff       	call   80149f <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
	return;
  8015ef:	90                   	nop
}
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	6a 10                	push   $0x10
  801603:	e8 97 fe ff ff       	call   80149f <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
	return ;
  80160b:	90                   	nop
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	ff 75 10             	pushl  0x10(%ebp)
  801618:	ff 75 0c             	pushl  0xc(%ebp)
  80161b:	ff 75 08             	pushl  0x8(%ebp)
  80161e:	6a 11                	push   $0x11
  801620:	e8 7a fe ff ff       	call   80149f <syscall>
  801625:	83 c4 18             	add    $0x18,%esp
	return ;
  801628:	90                   	nop
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 0c                	push   $0xc
  80163a:	e8 60 fe ff ff       	call   80149f <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	ff 75 08             	pushl  0x8(%ebp)
  801652:	6a 0d                	push   $0xd
  801654:	e8 46 fe ff ff       	call   80149f <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 0e                	push   $0xe
  80166d:	e8 2d fe ff ff       	call   80149f <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 13                	push   $0x13
  801687:	e8 13 fe ff ff       	call   80149f <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 14                	push   $0x14
  8016a1:	e8 f9 fd ff ff       	call   80149f <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	90                   	nop
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_cputc>:


void
sys_cputc(const char c)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	50                   	push   %eax
  8016c5:	6a 15                	push   $0x15
  8016c7:	e8 d3 fd ff ff       	call   80149f <syscall>
  8016cc:	83 c4 18             	add    $0x18,%esp
}
  8016cf:	90                   	nop
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 16                	push   $0x16
  8016e1:	e8 b9 fd ff ff       	call   80149f <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	50                   	push   %eax
  8016fc:	6a 17                	push   $0x17
  8016fe:	e8 9c fd ff ff       	call   80149f <syscall>
  801703:	83 c4 18             	add    $0x18,%esp
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80170b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	52                   	push   %edx
  801718:	50                   	push   %eax
  801719:	6a 1a                	push   $0x1a
  80171b:	e8 7f fd ff ff       	call   80149f <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	52                   	push   %edx
  801735:	50                   	push   %eax
  801736:	6a 18                	push   $0x18
  801738:	e8 62 fd ff ff       	call   80149f <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
}
  801740:	90                   	nop
  801741:	c9                   	leave  
  801742:	c3                   	ret    

00801743 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801746:	8b 55 0c             	mov    0xc(%ebp),%edx
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	52                   	push   %edx
  801753:	50                   	push   %eax
  801754:	6a 19                	push   $0x19
  801756:	e8 44 fd ff ff       	call   80149f <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	8b 45 10             	mov    0x10(%ebp),%eax
  80176a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80176d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801770:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801774:	8b 45 08             	mov    0x8(%ebp),%eax
  801777:	6a 00                	push   $0x0
  801779:	51                   	push   %ecx
  80177a:	52                   	push   %edx
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	50                   	push   %eax
  80177f:	6a 1b                	push   $0x1b
  801781:	e8 19 fd ff ff       	call   80149f <syscall>
  801786:	83 c4 18             	add    $0x18,%esp
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80178e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	6a 1c                	push   $0x1c
  80179e:	e8 fc fc ff ff       	call   80149f <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	c9                   	leave  
  8017a7:	c3                   	ret    

008017a8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017a8:	55                   	push   %ebp
  8017a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	51                   	push   %ecx
  8017b9:	52                   	push   %edx
  8017ba:	50                   	push   %eax
  8017bb:	6a 1d                	push   $0x1d
  8017bd:	e8 dd fc ff ff       	call   80149f <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 1e                	push   $0x1e
  8017da:	e8 c0 fc ff ff       	call   80149f <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 1f                	push   $0x1f
  8017f3:	e8 a7 fc ff ff       	call   80149f <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	6a 00                	push   $0x0
  801805:	ff 75 14             	pushl  0x14(%ebp)
  801808:	ff 75 10             	pushl  0x10(%ebp)
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	50                   	push   %eax
  80180f:	6a 20                	push   $0x20
  801811:	e8 89 fc ff ff       	call   80149f <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	50                   	push   %eax
  80182a:	6a 21                	push   $0x21
  80182c:	e8 6e fc ff ff       	call   80149f <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	90                   	nop
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	50                   	push   %eax
  801846:	6a 22                	push   $0x22
  801848:	e8 52 fc ff ff       	call   80149f <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 02                	push   $0x2
  801861:	e8 39 fc ff ff       	call   80149f <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 03                	push   $0x3
  80187a:	e8 20 fc ff ff       	call   80149f <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 04                	push   $0x4
  801893:	e8 07 fc ff ff       	call   80149f <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_exit_env>:


void sys_exit_env(void)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 23                	push   $0x23
  8018ac:	e8 ee fb ff ff       	call   80149f <syscall>
  8018b1:	83 c4 18             	add    $0x18,%esp
}
  8018b4:	90                   	nop
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018bd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c0:	8d 50 04             	lea    0x4(%eax),%edx
  8018c3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	52                   	push   %edx
  8018cd:	50                   	push   %eax
  8018ce:	6a 24                	push   $0x24
  8018d0:	e8 ca fb ff ff       	call   80149f <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
	return result;
  8018d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018db:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e1:	89 01                	mov    %eax,(%ecx)
  8018e3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	c9                   	leave  
  8018ea:	c2 04 00             	ret    $0x4

008018ed <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	ff 75 10             	pushl  0x10(%ebp)
  8018f7:	ff 75 0c             	pushl  0xc(%ebp)
  8018fa:	ff 75 08             	pushl  0x8(%ebp)
  8018fd:	6a 12                	push   $0x12
  8018ff:	e8 9b fb ff ff       	call   80149f <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
	return ;
  801907:	90                   	nop
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_rcr2>:
uint32 sys_rcr2()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 25                	push   $0x25
  801919:	e8 81 fb ff ff       	call   80149f <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80192f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	50                   	push   %eax
  80193c:	6a 26                	push   $0x26
  80193e:	e8 5c fb ff ff       	call   80149f <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
	return ;
  801946:	90                   	nop
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <rsttst>:
void rsttst()
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 28                	push   $0x28
  801958:	e8 42 fb ff ff       	call   80149f <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return ;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	8b 45 14             	mov    0x14(%ebp),%eax
  80196c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80196f:	8b 55 18             	mov    0x18(%ebp),%edx
  801972:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801976:	52                   	push   %edx
  801977:	50                   	push   %eax
  801978:	ff 75 10             	pushl  0x10(%ebp)
  80197b:	ff 75 0c             	pushl  0xc(%ebp)
  80197e:	ff 75 08             	pushl  0x8(%ebp)
  801981:	6a 27                	push   $0x27
  801983:	e8 17 fb ff ff       	call   80149f <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
	return ;
  80198b:	90                   	nop
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <chktst>:
void chktst(uint32 n)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	ff 75 08             	pushl  0x8(%ebp)
  80199c:	6a 29                	push   $0x29
  80199e:	e8 fc fa ff ff       	call   80149f <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <inctst>:

void inctst()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 2a                	push   $0x2a
  8019b8:	e8 e2 fa ff ff       	call   80149f <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <gettst>:
uint32 gettst()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 2b                	push   $0x2b
  8019d2:	e8 c8 fa ff ff       	call   80149f <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 2c                	push   $0x2c
  8019ee:	e8 ac fa ff ff       	call   80149f <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
  8019f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019f9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019fd:	75 07                	jne    801a06 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801a04:	eb 05                	jmp    801a0b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 2c                	push   $0x2c
  801a1f:	e8 7b fa ff ff       	call   80149f <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
  801a27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a2a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a2e:	75 07                	jne    801a37 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a30:	b8 01 00 00 00       	mov    $0x1,%eax
  801a35:	eb 05                	jmp    801a3c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 2c                	push   $0x2c
  801a50:	e8 4a fa ff ff       	call   80149f <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
  801a58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a5b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a5f:	75 07                	jne    801a68 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a61:	b8 01 00 00 00       	mov    $0x1,%eax
  801a66:	eb 05                	jmp    801a6d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 2c                	push   $0x2c
  801a81:	e8 19 fa ff ff       	call   80149f <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
  801a89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a8c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a90:	75 07                	jne    801a99 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a92:	b8 01 00 00 00       	mov    $0x1,%eax
  801a97:	eb 05                	jmp    801a9e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	ff 75 08             	pushl  0x8(%ebp)
  801aae:	6a 2d                	push   $0x2d
  801ab0:	e8 ea f9 ff ff       	call   80149f <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab8:	90                   	nop
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801abf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	53                   	push   %ebx
  801ace:	51                   	push   %ecx
  801acf:	52                   	push   %edx
  801ad0:	50                   	push   %eax
  801ad1:	6a 2e                	push   $0x2e
  801ad3:	e8 c7 f9 ff ff       	call   80149f <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
}
  801adb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	52                   	push   %edx
  801af0:	50                   	push   %eax
  801af1:	6a 2f                	push   $0x2f
  801af3:	e8 a7 f9 ff ff       	call   80149f <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b03:	83 ec 0c             	sub    $0xc,%esp
  801b06:	68 30 3c 80 00       	push   $0x803c30
  801b0b:	e8 6b e8 ff ff       	call   80037b <cprintf>
  801b10:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	68 5c 3c 80 00       	push   $0x803c5c
  801b22:	e8 54 e8 ff ff       	call   80037b <cprintf>
  801b27:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b2a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b2e:	a1 38 41 80 00       	mov    0x804138,%eax
  801b33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b36:	eb 56                	jmp    801b8e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b3c:	74 1c                	je     801b5a <print_mem_block_lists+0x5d>
  801b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b41:	8b 50 08             	mov    0x8(%eax),%edx
  801b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b47:	8b 48 08             	mov    0x8(%eax),%ecx
  801b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b50:	01 c8                	add    %ecx,%eax
  801b52:	39 c2                	cmp    %eax,%edx
  801b54:	73 04                	jae    801b5a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801b56:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	8b 50 08             	mov    0x8(%eax),%edx
  801b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b63:	8b 40 0c             	mov    0xc(%eax),%eax
  801b66:	01 c2                	add    %eax,%edx
  801b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6b:	8b 40 08             	mov    0x8(%eax),%eax
  801b6e:	83 ec 04             	sub    $0x4,%esp
  801b71:	52                   	push   %edx
  801b72:	50                   	push   %eax
  801b73:	68 71 3c 80 00       	push   $0x803c71
  801b78:	e8 fe e7 ff ff       	call   80037b <cprintf>
  801b7d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b86:	a1 40 41 80 00       	mov    0x804140,%eax
  801b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b92:	74 07                	je     801b9b <print_mem_block_lists+0x9e>
  801b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b97:	8b 00                	mov    (%eax),%eax
  801b99:	eb 05                	jmp    801ba0 <print_mem_block_lists+0xa3>
  801b9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba0:	a3 40 41 80 00       	mov    %eax,0x804140
  801ba5:	a1 40 41 80 00       	mov    0x804140,%eax
  801baa:	85 c0                	test   %eax,%eax
  801bac:	75 8a                	jne    801b38 <print_mem_block_lists+0x3b>
  801bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb2:	75 84                	jne    801b38 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801bb4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801bb8:	75 10                	jne    801bca <print_mem_block_lists+0xcd>
  801bba:	83 ec 0c             	sub    $0xc,%esp
  801bbd:	68 80 3c 80 00       	push   $0x803c80
  801bc2:	e8 b4 e7 ff ff       	call   80037b <cprintf>
  801bc7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801bca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801bd1:	83 ec 0c             	sub    $0xc,%esp
  801bd4:	68 a4 3c 80 00       	push   $0x803ca4
  801bd9:	e8 9d e7 ff ff       	call   80037b <cprintf>
  801bde:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801be1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801be5:	a1 40 40 80 00       	mov    0x804040,%eax
  801bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bed:	eb 56                	jmp    801c45 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801bef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf3:	74 1c                	je     801c11 <print_mem_block_lists+0x114>
  801bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf8:	8b 50 08             	mov    0x8(%eax),%edx
  801bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bfe:	8b 48 08             	mov    0x8(%eax),%ecx
  801c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c04:	8b 40 0c             	mov    0xc(%eax),%eax
  801c07:	01 c8                	add    %ecx,%eax
  801c09:	39 c2                	cmp    %eax,%edx
  801c0b:	73 04                	jae    801c11 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c0d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c14:	8b 50 08             	mov    0x8(%eax),%edx
  801c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1d:	01 c2                	add    %eax,%edx
  801c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c22:	8b 40 08             	mov    0x8(%eax),%eax
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	52                   	push   %edx
  801c29:	50                   	push   %eax
  801c2a:	68 71 3c 80 00       	push   $0x803c71
  801c2f:	e8 47 e7 ff ff       	call   80037b <cprintf>
  801c34:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c3d:	a1 48 40 80 00       	mov    0x804048,%eax
  801c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c49:	74 07                	je     801c52 <print_mem_block_lists+0x155>
  801c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4e:	8b 00                	mov    (%eax),%eax
  801c50:	eb 05                	jmp    801c57 <print_mem_block_lists+0x15a>
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
  801c57:	a3 48 40 80 00       	mov    %eax,0x804048
  801c5c:	a1 48 40 80 00       	mov    0x804048,%eax
  801c61:	85 c0                	test   %eax,%eax
  801c63:	75 8a                	jne    801bef <print_mem_block_lists+0xf2>
  801c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c69:	75 84                	jne    801bef <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c6b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c6f:	75 10                	jne    801c81 <print_mem_block_lists+0x184>
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	68 bc 3c 80 00       	push   $0x803cbc
  801c79:	e8 fd e6 ff ff       	call   80037b <cprintf>
  801c7e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c81:	83 ec 0c             	sub    $0xc,%esp
  801c84:	68 30 3c 80 00       	push   $0x803c30
  801c89:	e8 ed e6 ff ff       	call   80037b <cprintf>
  801c8e:	83 c4 10             	add    $0x10,%esp

}
  801c91:	90                   	nop
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801c9a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ca1:	00 00 00 
  801ca4:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801cab:	00 00 00 
  801cae:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801cb5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801cb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cbf:	e9 9e 00 00 00       	jmp    801d62 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801cc4:	a1 50 40 80 00       	mov    0x804050,%eax
  801cc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ccc:	c1 e2 04             	shl    $0x4,%edx
  801ccf:	01 d0                	add    %edx,%eax
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	75 14                	jne    801ce9 <initialize_MemBlocksList+0x55>
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	68 e4 3c 80 00       	push   $0x803ce4
  801cdd:	6a 46                	push   $0x46
  801cdf:	68 07 3d 80 00       	push   $0x803d07
  801ce4:	e8 18 15 00 00       	call   803201 <_panic>
  801ce9:	a1 50 40 80 00       	mov    0x804050,%eax
  801cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf1:	c1 e2 04             	shl    $0x4,%edx
  801cf4:	01 d0                	add    %edx,%eax
  801cf6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801cfc:	89 10                	mov    %edx,(%eax)
  801cfe:	8b 00                	mov    (%eax),%eax
  801d00:	85 c0                	test   %eax,%eax
  801d02:	74 18                	je     801d1c <initialize_MemBlocksList+0x88>
  801d04:	a1 48 41 80 00       	mov    0x804148,%eax
  801d09:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d0f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d12:	c1 e1 04             	shl    $0x4,%ecx
  801d15:	01 ca                	add    %ecx,%edx
  801d17:	89 50 04             	mov    %edx,0x4(%eax)
  801d1a:	eb 12                	jmp    801d2e <initialize_MemBlocksList+0x9a>
  801d1c:	a1 50 40 80 00       	mov    0x804050,%eax
  801d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d24:	c1 e2 04             	shl    $0x4,%edx
  801d27:	01 d0                	add    %edx,%eax
  801d29:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d2e:	a1 50 40 80 00       	mov    0x804050,%eax
  801d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d36:	c1 e2 04             	shl    $0x4,%edx
  801d39:	01 d0                	add    %edx,%eax
  801d3b:	a3 48 41 80 00       	mov    %eax,0x804148
  801d40:	a1 50 40 80 00       	mov    0x804050,%eax
  801d45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d48:	c1 e2 04             	shl    $0x4,%edx
  801d4b:	01 d0                	add    %edx,%eax
  801d4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d54:	a1 54 41 80 00       	mov    0x804154,%eax
  801d59:	40                   	inc    %eax
  801d5a:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801d5f:	ff 45 f4             	incl   -0xc(%ebp)
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d68:	0f 82 56 ff ff ff    	jb     801cc4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d6e:	90                   	nop
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d7f:	eb 19                	jmp    801d9a <find_block+0x29>
	{
		if(va==point->sva)
  801d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d84:	8b 40 08             	mov    0x8(%eax),%eax
  801d87:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d8a:	75 05                	jne    801d91 <find_block+0x20>
		   return point;
  801d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d8f:	eb 36                	jmp    801dc7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 40 08             	mov    0x8(%eax),%eax
  801d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d9a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d9e:	74 07                	je     801da7 <find_block+0x36>
  801da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da3:	8b 00                	mov    (%eax),%eax
  801da5:	eb 05                	jmp    801dac <find_block+0x3b>
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
  801dac:	8b 55 08             	mov    0x8(%ebp),%edx
  801daf:	89 42 08             	mov    %eax,0x8(%edx)
  801db2:	8b 45 08             	mov    0x8(%ebp),%eax
  801db5:	8b 40 08             	mov    0x8(%eax),%eax
  801db8:	85 c0                	test   %eax,%eax
  801dba:	75 c5                	jne    801d81 <find_block+0x10>
  801dbc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dc0:	75 bf                	jne    801d81 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801dcf:	a1 40 40 80 00       	mov    0x804040,%eax
  801dd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801dd7:	a1 44 40 80 00       	mov    0x804044,%eax
  801ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801de5:	74 24                	je     801e0b <insert_sorted_allocList+0x42>
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	8b 50 08             	mov    0x8(%eax),%edx
  801ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df0:	8b 40 08             	mov    0x8(%eax),%eax
  801df3:	39 c2                	cmp    %eax,%edx
  801df5:	76 14                	jbe    801e0b <insert_sorted_allocList+0x42>
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	8b 50 08             	mov    0x8(%eax),%edx
  801dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e00:	8b 40 08             	mov    0x8(%eax),%eax
  801e03:	39 c2                	cmp    %eax,%edx
  801e05:	0f 82 60 01 00 00    	jb     801f6b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e0f:	75 65                	jne    801e76 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e15:	75 14                	jne    801e2b <insert_sorted_allocList+0x62>
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	68 e4 3c 80 00       	push   $0x803ce4
  801e1f:	6a 6b                	push   $0x6b
  801e21:	68 07 3d 80 00       	push   $0x803d07
  801e26:	e8 d6 13 00 00       	call   803201 <_panic>
  801e2b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	89 10                	mov    %edx,(%eax)
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	8b 00                	mov    (%eax),%eax
  801e3b:	85 c0                	test   %eax,%eax
  801e3d:	74 0d                	je     801e4c <insert_sorted_allocList+0x83>
  801e3f:	a1 40 40 80 00       	mov    0x804040,%eax
  801e44:	8b 55 08             	mov    0x8(%ebp),%edx
  801e47:	89 50 04             	mov    %edx,0x4(%eax)
  801e4a:	eb 08                	jmp    801e54 <insert_sorted_allocList+0x8b>
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	a3 44 40 80 00       	mov    %eax,0x804044
  801e54:	8b 45 08             	mov    0x8(%ebp),%eax
  801e57:	a3 40 40 80 00       	mov    %eax,0x804040
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e66:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e6b:	40                   	inc    %eax
  801e6c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e71:	e9 dc 01 00 00       	jmp    802052 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8b 50 08             	mov    0x8(%eax),%edx
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	8b 40 08             	mov    0x8(%eax),%eax
  801e82:	39 c2                	cmp    %eax,%edx
  801e84:	77 6c                	ja     801ef2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801e86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8a:	74 06                	je     801e92 <insert_sorted_allocList+0xc9>
  801e8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e90:	75 14                	jne    801ea6 <insert_sorted_allocList+0xdd>
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	68 20 3d 80 00       	push   $0x803d20
  801e9a:	6a 6f                	push   $0x6f
  801e9c:	68 07 3d 80 00       	push   $0x803d07
  801ea1:	e8 5b 13 00 00       	call   803201 <_panic>
  801ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea9:	8b 50 04             	mov    0x4(%eax),%edx
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	89 50 04             	mov    %edx,0x4(%eax)
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eb8:	89 10                	mov    %edx,(%eax)
  801eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebd:	8b 40 04             	mov    0x4(%eax),%eax
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	74 0d                	je     801ed1 <insert_sorted_allocList+0x108>
  801ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec7:	8b 40 04             	mov    0x4(%eax),%eax
  801eca:	8b 55 08             	mov    0x8(%ebp),%edx
  801ecd:	89 10                	mov    %edx,(%eax)
  801ecf:	eb 08                	jmp    801ed9 <insert_sorted_allocList+0x110>
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	a3 40 40 80 00       	mov    %eax,0x804040
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edc:	8b 55 08             	mov    0x8(%ebp),%edx
  801edf:	89 50 04             	mov    %edx,0x4(%eax)
  801ee2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ee7:	40                   	inc    %eax
  801ee8:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801eed:	e9 60 01 00 00       	jmp    802052 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	8b 50 08             	mov    0x8(%eax),%edx
  801ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efb:	8b 40 08             	mov    0x8(%eax),%eax
  801efe:	39 c2                	cmp    %eax,%edx
  801f00:	0f 82 4c 01 00 00    	jb     802052 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f0a:	75 14                	jne    801f20 <insert_sorted_allocList+0x157>
  801f0c:	83 ec 04             	sub    $0x4,%esp
  801f0f:	68 58 3d 80 00       	push   $0x803d58
  801f14:	6a 73                	push   $0x73
  801f16:	68 07 3d 80 00       	push   $0x803d07
  801f1b:	e8 e1 12 00 00       	call   803201 <_panic>
  801f20:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	89 50 04             	mov    %edx,0x4(%eax)
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	8b 40 04             	mov    0x4(%eax),%eax
  801f32:	85 c0                	test   %eax,%eax
  801f34:	74 0c                	je     801f42 <insert_sorted_allocList+0x179>
  801f36:	a1 44 40 80 00       	mov    0x804044,%eax
  801f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f3e:	89 10                	mov    %edx,(%eax)
  801f40:	eb 08                	jmp    801f4a <insert_sorted_allocList+0x181>
  801f42:	8b 45 08             	mov    0x8(%ebp),%eax
  801f45:	a3 40 40 80 00       	mov    %eax,0x804040
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	a3 44 40 80 00       	mov    %eax,0x804044
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f5b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f60:	40                   	inc    %eax
  801f61:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f66:	e9 e7 00 00 00       	jmp    802052 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f78:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f80:	e9 9d 00 00 00       	jmp    802022 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 40 08             	mov    0x8(%eax),%eax
  801f99:	39 c2                	cmp    %eax,%edx
  801f9b:	76 7d                	jbe    80201a <insert_sorted_allocList+0x251>
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	8b 50 08             	mov    0x8(%eax),%edx
  801fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa6:	8b 40 08             	mov    0x8(%eax),%eax
  801fa9:	39 c2                	cmp    %eax,%edx
  801fab:	73 6d                	jae    80201a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801fad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb1:	74 06                	je     801fb9 <insert_sorted_allocList+0x1f0>
  801fb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb7:	75 14                	jne    801fcd <insert_sorted_allocList+0x204>
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	68 7c 3d 80 00       	push   $0x803d7c
  801fc1:	6a 7f                	push   $0x7f
  801fc3:	68 07 3d 80 00       	push   $0x803d07
  801fc8:	e8 34 12 00 00       	call   803201 <_panic>
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 10                	mov    (%eax),%edx
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	89 10                	mov    %edx,(%eax)
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	8b 00                	mov    (%eax),%eax
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	74 0b                	je     801feb <insert_sorted_allocList+0x222>
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 00                	mov    (%eax),%eax
  801fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe8:	89 50 04             	mov    %edx,0x4(%eax)
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff1:	89 10                	mov    %edx,(%eax)
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff9:	89 50 04             	mov    %edx,0x4(%eax)
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	8b 00                	mov    (%eax),%eax
  802001:	85 c0                	test   %eax,%eax
  802003:	75 08                	jne    80200d <insert_sorted_allocList+0x244>
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	a3 44 40 80 00       	mov    %eax,0x804044
  80200d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802012:	40                   	inc    %eax
  802013:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802018:	eb 39                	jmp    802053 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80201a:	a1 48 40 80 00       	mov    0x804048,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802026:	74 07                	je     80202f <insert_sorted_allocList+0x266>
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 00                	mov    (%eax),%eax
  80202d:	eb 05                	jmp    802034 <insert_sorted_allocList+0x26b>
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	a3 48 40 80 00       	mov    %eax,0x804048
  802039:	a1 48 40 80 00       	mov    0x804048,%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	0f 85 3f ff ff ff    	jne    801f85 <insert_sorted_allocList+0x1bc>
  802046:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204a:	0f 85 35 ff ff ff    	jne    801f85 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802050:	eb 01                	jmp    802053 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802052:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802053:	90                   	nop
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80205c:	a1 38 41 80 00       	mov    0x804138,%eax
  802061:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802064:	e9 85 01 00 00       	jmp    8021ee <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	8b 40 0c             	mov    0xc(%eax),%eax
  80206f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802072:	0f 82 6e 01 00 00    	jb     8021e6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 40 0c             	mov    0xc(%eax),%eax
  80207e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802081:	0f 85 8a 00 00 00    	jne    802111 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802087:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208b:	75 17                	jne    8020a4 <alloc_block_FF+0x4e>
  80208d:	83 ec 04             	sub    $0x4,%esp
  802090:	68 b0 3d 80 00       	push   $0x803db0
  802095:	68 93 00 00 00       	push   $0x93
  80209a:	68 07 3d 80 00       	push   $0x803d07
  80209f:	e8 5d 11 00 00       	call   803201 <_panic>
  8020a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 10                	je     8020bd <alloc_block_FF+0x67>
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b5:	8b 52 04             	mov    0x4(%edx),%edx
  8020b8:	89 50 04             	mov    %edx,0x4(%eax)
  8020bb:	eb 0b                	jmp    8020c8 <alloc_block_FF+0x72>
  8020bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c0:	8b 40 04             	mov    0x4(%eax),%eax
  8020c3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8020c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cb:	8b 40 04             	mov    0x4(%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 0f                	je     8020e1 <alloc_block_FF+0x8b>
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	8b 40 04             	mov    0x4(%eax),%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	8b 12                	mov    (%edx),%edx
  8020dd:	89 10                	mov    %edx,(%eax)
  8020df:	eb 0a                	jmp    8020eb <alloc_block_FF+0x95>
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 00                	mov    (%eax),%eax
  8020e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020fe:	a1 44 41 80 00       	mov    0x804144,%eax
  802103:	48                   	dec    %eax
  802104:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	e9 10 01 00 00       	jmp    802221 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 40 0c             	mov    0xc(%eax),%eax
  802117:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211a:	0f 86 c6 00 00 00    	jbe    8021e6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802120:	a1 48 41 80 00       	mov    0x804148,%eax
  802125:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	8b 50 08             	mov    0x8(%eax),%edx
  80212e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802131:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802137:	8b 55 08             	mov    0x8(%ebp),%edx
  80213a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80213d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802141:	75 17                	jne    80215a <alloc_block_FF+0x104>
  802143:	83 ec 04             	sub    $0x4,%esp
  802146:	68 b0 3d 80 00       	push   $0x803db0
  80214b:	68 9b 00 00 00       	push   $0x9b
  802150:	68 07 3d 80 00       	push   $0x803d07
  802155:	e8 a7 10 00 00       	call   803201 <_panic>
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	74 10                	je     802173 <alloc_block_FF+0x11d>
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	8b 00                	mov    (%eax),%eax
  802168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80216b:	8b 52 04             	mov    0x4(%edx),%edx
  80216e:	89 50 04             	mov    %edx,0x4(%eax)
  802171:	eb 0b                	jmp    80217e <alloc_block_FF+0x128>
  802173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802176:	8b 40 04             	mov    0x4(%eax),%eax
  802179:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80217e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802181:	8b 40 04             	mov    0x4(%eax),%eax
  802184:	85 c0                	test   %eax,%eax
  802186:	74 0f                	je     802197 <alloc_block_FF+0x141>
  802188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218b:	8b 40 04             	mov    0x4(%eax),%eax
  80218e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802191:	8b 12                	mov    (%edx),%edx
  802193:	89 10                	mov    %edx,(%eax)
  802195:	eb 0a                	jmp    8021a1 <alloc_block_FF+0x14b>
  802197:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219a:	8b 00                	mov    (%eax),%eax
  80219c:	a3 48 41 80 00       	mov    %eax,0x804148
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b4:	a1 54 41 80 00       	mov    0x804154,%eax
  8021b9:	48                   	dec    %eax
  8021ba:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 50 08             	mov    0x8(%eax),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	01 c2                	add    %eax,%edx
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d6:	2b 45 08             	sub    0x8(%ebp),%eax
  8021d9:	89 c2                	mov    %eax,%edx
  8021db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021de:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	eb 3b                	jmp    802221 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8021eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f2:	74 07                	je     8021fb <alloc_block_FF+0x1a5>
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	eb 05                	jmp    802200 <alloc_block_FF+0x1aa>
  8021fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802200:	a3 40 41 80 00       	mov    %eax,0x804140
  802205:	a1 40 41 80 00       	mov    0x804140,%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	0f 85 57 fe ff ff    	jne    802069 <alloc_block_FF+0x13>
  802212:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802216:	0f 85 4d fe ff ff    	jne    802069 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80221c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802229:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802230:	a1 38 41 80 00       	mov    0x804138,%eax
  802235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802238:	e9 df 00 00 00       	jmp    80231c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 40 0c             	mov    0xc(%eax),%eax
  802243:	3b 45 08             	cmp    0x8(%ebp),%eax
  802246:	0f 82 c8 00 00 00    	jb     802314 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80224c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224f:	8b 40 0c             	mov    0xc(%eax),%eax
  802252:	3b 45 08             	cmp    0x8(%ebp),%eax
  802255:	0f 85 8a 00 00 00    	jne    8022e5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80225b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225f:	75 17                	jne    802278 <alloc_block_BF+0x55>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 b0 3d 80 00       	push   $0x803db0
  802269:	68 b7 00 00 00       	push   $0xb7
  80226e:	68 07 3d 80 00       	push   $0x803d07
  802273:	e8 89 0f 00 00       	call   803201 <_panic>
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 00                	mov    (%eax),%eax
  80227d:	85 c0                	test   %eax,%eax
  80227f:	74 10                	je     802291 <alloc_block_BF+0x6e>
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 00                	mov    (%eax),%eax
  802286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802289:	8b 52 04             	mov    0x4(%edx),%edx
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	eb 0b                	jmp    80229c <alloc_block_BF+0x79>
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 40 04             	mov    0x4(%eax),%eax
  802297:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 40 04             	mov    0x4(%eax),%eax
  8022a2:	85 c0                	test   %eax,%eax
  8022a4:	74 0f                	je     8022b5 <alloc_block_BF+0x92>
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022af:	8b 12                	mov    (%edx),%edx
  8022b1:	89 10                	mov    %edx,(%eax)
  8022b3:	eb 0a                	jmp    8022bf <alloc_block_BF+0x9c>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d2:	a1 44 41 80 00       	mov    0x804144,%eax
  8022d7:	48                   	dec    %eax
  8022d8:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8022dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e0:	e9 4d 01 00 00       	jmp    802432 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ee:	76 24                	jbe    802314 <alloc_block_BF+0xf1>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022f9:	73 19                	jae    802314 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8022fb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 40 0c             	mov    0xc(%eax),%eax
  802308:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 08             	mov    0x8(%eax),%eax
  802311:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802314:	a1 40 41 80 00       	mov    0x804140,%eax
  802319:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802320:	74 07                	je     802329 <alloc_block_BF+0x106>
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 00                	mov    (%eax),%eax
  802327:	eb 05                	jmp    80232e <alloc_block_BF+0x10b>
  802329:	b8 00 00 00 00       	mov    $0x0,%eax
  80232e:	a3 40 41 80 00       	mov    %eax,0x804140
  802333:	a1 40 41 80 00       	mov    0x804140,%eax
  802338:	85 c0                	test   %eax,%eax
  80233a:	0f 85 fd fe ff ff    	jne    80223d <alloc_block_BF+0x1a>
  802340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802344:	0f 85 f3 fe ff ff    	jne    80223d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80234a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80234e:	0f 84 d9 00 00 00    	je     80242d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802354:	a1 48 41 80 00       	mov    0x804148,%eax
  802359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80235c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80235f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802362:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802368:	8b 55 08             	mov    0x8(%ebp),%edx
  80236b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80236e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802372:	75 17                	jne    80238b <alloc_block_BF+0x168>
  802374:	83 ec 04             	sub    $0x4,%esp
  802377:	68 b0 3d 80 00       	push   $0x803db0
  80237c:	68 c7 00 00 00       	push   $0xc7
  802381:	68 07 3d 80 00       	push   $0x803d07
  802386:	e8 76 0e 00 00       	call   803201 <_panic>
  80238b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238e:	8b 00                	mov    (%eax),%eax
  802390:	85 c0                	test   %eax,%eax
  802392:	74 10                	je     8023a4 <alloc_block_BF+0x181>
  802394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80239c:	8b 52 04             	mov    0x4(%edx),%edx
  80239f:	89 50 04             	mov    %edx,0x4(%eax)
  8023a2:	eb 0b                	jmp    8023af <alloc_block_BF+0x18c>
  8023a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a7:	8b 40 04             	mov    0x4(%eax),%eax
  8023aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	85 c0                	test   %eax,%eax
  8023b7:	74 0f                	je     8023c8 <alloc_block_BF+0x1a5>
  8023b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bc:	8b 40 04             	mov    0x4(%eax),%eax
  8023bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023c2:	8b 12                	mov    (%edx),%edx
  8023c4:	89 10                	mov    %edx,(%eax)
  8023c6:	eb 0a                	jmp    8023d2 <alloc_block_BF+0x1af>
  8023c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	a3 48 41 80 00       	mov    %eax,0x804148
  8023d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8023ea:	48                   	dec    %eax
  8023eb:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8023f0:	83 ec 08             	sub    $0x8,%esp
  8023f3:	ff 75 ec             	pushl  -0x14(%ebp)
  8023f6:	68 38 41 80 00       	push   $0x804138
  8023fb:	e8 71 f9 ff ff       	call   801d71 <find_block>
  802400:	83 c4 10             	add    $0x10,%esp
  802403:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802409:	8b 50 08             	mov    0x8(%eax),%edx
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	01 c2                	add    %eax,%edx
  802411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802414:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241a:	8b 40 0c             	mov    0xc(%eax),%eax
  80241d:	2b 45 08             	sub    0x8(%ebp),%eax
  802420:	89 c2                	mov    %eax,%edx
  802422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802425:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242b:	eb 05                	jmp    802432 <alloc_block_BF+0x20f>
	}
	return NULL;
  80242d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80243a:	a1 28 40 80 00       	mov    0x804028,%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	0f 85 de 01 00 00    	jne    802625 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802447:	a1 38 41 80 00       	mov    0x804138,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244f:	e9 9e 01 00 00       	jmp    8025f2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 0c             	mov    0xc(%eax),%eax
  80245a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245d:	0f 82 87 01 00 00    	jb     8025ea <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 0c             	mov    0xc(%eax),%eax
  802469:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246c:	0f 85 95 00 00 00    	jne    802507 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802476:	75 17                	jne    80248f <alloc_block_NF+0x5b>
  802478:	83 ec 04             	sub    $0x4,%esp
  80247b:	68 b0 3d 80 00       	push   $0x803db0
  802480:	68 e0 00 00 00       	push   $0xe0
  802485:	68 07 3d 80 00       	push   $0x803d07
  80248a:	e8 72 0d 00 00       	call   803201 <_panic>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 10                	je     8024a8 <alloc_block_NF+0x74>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a0:	8b 52 04             	mov    0x4(%edx),%edx
  8024a3:	89 50 04             	mov    %edx,0x4(%eax)
  8024a6:	eb 0b                	jmp    8024b3 <alloc_block_NF+0x7f>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 04             	mov    0x4(%eax),%eax
  8024ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b6:	8b 40 04             	mov    0x4(%eax),%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 0f                	je     8024cc <alloc_block_NF+0x98>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c6:	8b 12                	mov    (%edx),%edx
  8024c8:	89 10                	mov    %edx,(%eax)
  8024ca:	eb 0a                	jmp    8024d6 <alloc_block_NF+0xa2>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ee:	48                   	dec    %eax
  8024ef:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 08             	mov    0x8(%eax),%eax
  8024fa:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	e9 f8 04 00 00       	jmp    8029ff <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802510:	0f 86 d4 00 00 00    	jbe    8025ea <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802516:	a1 48 41 80 00       	mov    0x804148,%eax
  80251b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80251e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802521:	8b 50 08             	mov    0x8(%eax),%edx
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80252a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252d:	8b 55 08             	mov    0x8(%ebp),%edx
  802530:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802533:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802537:	75 17                	jne    802550 <alloc_block_NF+0x11c>
  802539:	83 ec 04             	sub    $0x4,%esp
  80253c:	68 b0 3d 80 00       	push   $0x803db0
  802541:	68 e9 00 00 00       	push   $0xe9
  802546:	68 07 3d 80 00       	push   $0x803d07
  80254b:	e8 b1 0c 00 00       	call   803201 <_panic>
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	74 10                	je     802569 <alloc_block_NF+0x135>
  802559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802561:	8b 52 04             	mov    0x4(%edx),%edx
  802564:	89 50 04             	mov    %edx,0x4(%eax)
  802567:	eb 0b                	jmp    802574 <alloc_block_NF+0x140>
  802569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	8b 40 04             	mov    0x4(%eax),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	74 0f                	je     80258d <alloc_block_NF+0x159>
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	8b 40 04             	mov    0x4(%eax),%eax
  802584:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802587:	8b 12                	mov    (%edx),%edx
  802589:	89 10                	mov    %edx,(%eax)
  80258b:	eb 0a                	jmp    802597 <alloc_block_NF+0x163>
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	a3 48 41 80 00       	mov    %eax,0x804148
  802597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025aa:	a1 54 41 80 00       	mov    0x804154,%eax
  8025af:	48                   	dec    %eax
  8025b0:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8025b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b8:	8b 40 08             	mov    0x8(%eax),%eax
  8025bb:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 50 08             	mov    0x8(%eax),%edx
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	01 c2                	add    %eax,%edx
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8025da:	89 c2                	mov    %eax,%edx
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8025e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e5:	e9 15 04 00 00       	jmp    8029ff <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f6:	74 07                	je     8025ff <alloc_block_NF+0x1cb>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	eb 05                	jmp    802604 <alloc_block_NF+0x1d0>
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	a3 40 41 80 00       	mov    %eax,0x804140
  802609:	a1 40 41 80 00       	mov    0x804140,%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	0f 85 3e fe ff ff    	jne    802454 <alloc_block_NF+0x20>
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	0f 85 34 fe ff ff    	jne    802454 <alloc_block_NF+0x20>
  802620:	e9 d5 03 00 00       	jmp    8029fa <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802625:	a1 38 41 80 00       	mov    0x804138,%eax
  80262a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262d:	e9 b1 01 00 00       	jmp    8027e3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 50 08             	mov    0x8(%eax),%edx
  802638:	a1 28 40 80 00       	mov    0x804028,%eax
  80263d:	39 c2                	cmp    %eax,%edx
  80263f:	0f 82 96 01 00 00    	jb     8027db <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 0c             	mov    0xc(%eax),%eax
  80264b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264e:	0f 82 87 01 00 00    	jb     8027db <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 0c             	mov    0xc(%eax),%eax
  80265a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80265d:	0f 85 95 00 00 00    	jne    8026f8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802667:	75 17                	jne    802680 <alloc_block_NF+0x24c>
  802669:	83 ec 04             	sub    $0x4,%esp
  80266c:	68 b0 3d 80 00       	push   $0x803db0
  802671:	68 fc 00 00 00       	push   $0xfc
  802676:	68 07 3d 80 00       	push   $0x803d07
  80267b:	e8 81 0b 00 00       	call   803201 <_panic>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	74 10                	je     802699 <alloc_block_NF+0x265>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 00                	mov    (%eax),%eax
  80268e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802691:	8b 52 04             	mov    0x4(%edx),%edx
  802694:	89 50 04             	mov    %edx,0x4(%eax)
  802697:	eb 0b                	jmp    8026a4 <alloc_block_NF+0x270>
  802699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 40 04             	mov    0x4(%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 0f                	je     8026bd <alloc_block_NF+0x289>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 04             	mov    0x4(%eax),%eax
  8026b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b7:	8b 12                	mov    (%edx),%edx
  8026b9:	89 10                	mov    %edx,(%eax)
  8026bb:	eb 0a                	jmp    8026c7 <alloc_block_NF+0x293>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	a3 38 41 80 00       	mov    %eax,0x804138
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026da:	a1 44 41 80 00       	mov    0x804144,%eax
  8026df:	48                   	dec    %eax
  8026e0:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 08             	mov    0x8(%eax),%eax
  8026eb:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	e9 07 03 00 00       	jmp    8029ff <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802701:	0f 86 d4 00 00 00    	jbe    8027db <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802707:	a1 48 41 80 00       	mov    0x804148,%eax
  80270c:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 50 08             	mov    0x8(%eax),%edx
  802715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802718:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80271b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271e:	8b 55 08             	mov    0x8(%ebp),%edx
  802721:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802724:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802728:	75 17                	jne    802741 <alloc_block_NF+0x30d>
  80272a:	83 ec 04             	sub    $0x4,%esp
  80272d:	68 b0 3d 80 00       	push   $0x803db0
  802732:	68 04 01 00 00       	push   $0x104
  802737:	68 07 3d 80 00       	push   $0x803d07
  80273c:	e8 c0 0a 00 00       	call   803201 <_panic>
  802741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	85 c0                	test   %eax,%eax
  802748:	74 10                	je     80275a <alloc_block_NF+0x326>
  80274a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802752:	8b 52 04             	mov    0x4(%edx),%edx
  802755:	89 50 04             	mov    %edx,0x4(%eax)
  802758:	eb 0b                	jmp    802765 <alloc_block_NF+0x331>
  80275a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802765:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802768:	8b 40 04             	mov    0x4(%eax),%eax
  80276b:	85 c0                	test   %eax,%eax
  80276d:	74 0f                	je     80277e <alloc_block_NF+0x34a>
  80276f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802778:	8b 12                	mov    (%edx),%edx
  80277a:	89 10                	mov    %edx,(%eax)
  80277c:	eb 0a                	jmp    802788 <alloc_block_NF+0x354>
  80277e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802781:	8b 00                	mov    (%eax),%eax
  802783:	a3 48 41 80 00       	mov    %eax,0x804148
  802788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802791:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802794:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279b:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a0:	48                   	dec    %eax
  8027a1:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8027a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a9:	8b 40 08             	mov    0x8(%eax),%eax
  8027ac:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 50 08             	mov    0x8(%eax),%edx
  8027b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ba:	01 c2                	add    %eax,%edx
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cb:	89 c2                	mov    %eax,%edx
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8027d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d6:	e9 24 02 00 00       	jmp    8029ff <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027db:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e7:	74 07                	je     8027f0 <alloc_block_NF+0x3bc>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	eb 05                	jmp    8027f5 <alloc_block_NF+0x3c1>
  8027f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f5:	a3 40 41 80 00       	mov    %eax,0x804140
  8027fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ff:	85 c0                	test   %eax,%eax
  802801:	0f 85 2b fe ff ff    	jne    802632 <alloc_block_NF+0x1fe>
  802807:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280b:	0f 85 21 fe ff ff    	jne    802632 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802811:	a1 38 41 80 00       	mov    0x804138,%eax
  802816:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802819:	e9 ae 01 00 00       	jmp    8029cc <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 50 08             	mov    0x8(%eax),%edx
  802824:	a1 28 40 80 00       	mov    0x804028,%eax
  802829:	39 c2                	cmp    %eax,%edx
  80282b:	0f 83 93 01 00 00    	jae    8029c4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 40 0c             	mov    0xc(%eax),%eax
  802837:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283a:	0f 82 84 01 00 00    	jb     8029c4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	3b 45 08             	cmp    0x8(%ebp),%eax
  802849:	0f 85 95 00 00 00    	jne    8028e4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80284f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802853:	75 17                	jne    80286c <alloc_block_NF+0x438>
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	68 b0 3d 80 00       	push   $0x803db0
  80285d:	68 14 01 00 00       	push   $0x114
  802862:	68 07 3d 80 00       	push   $0x803d07
  802867:	e8 95 09 00 00       	call   803201 <_panic>
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	74 10                	je     802885 <alloc_block_NF+0x451>
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287d:	8b 52 04             	mov    0x4(%edx),%edx
  802880:	89 50 04             	mov    %edx,0x4(%eax)
  802883:	eb 0b                	jmp    802890 <alloc_block_NF+0x45c>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 04             	mov    0x4(%eax),%eax
  802896:	85 c0                	test   %eax,%eax
  802898:	74 0f                	je     8028a9 <alloc_block_NF+0x475>
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a3:	8b 12                	mov    (%edx),%edx
  8028a5:	89 10                	mov    %edx,(%eax)
  8028a7:	eb 0a                	jmp    8028b3 <alloc_block_NF+0x47f>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8028cb:	48                   	dec    %eax
  8028cc:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 40 08             	mov    0x8(%eax),%eax
  8028d7:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	e9 1b 01 00 00       	jmp    8029ff <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ea:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ed:	0f 86 d1 00 00 00    	jbe    8029c4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028f3:	a1 48 41 80 00       	mov    0x804148,%eax
  8028f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fe:	8b 50 08             	mov    0x8(%eax),%edx
  802901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802904:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290a:	8b 55 08             	mov    0x8(%ebp),%edx
  80290d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802910:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802914:	75 17                	jne    80292d <alloc_block_NF+0x4f9>
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	68 b0 3d 80 00       	push   $0x803db0
  80291e:	68 1c 01 00 00       	push   $0x11c
  802923:	68 07 3d 80 00       	push   $0x803d07
  802928:	e8 d4 08 00 00       	call   803201 <_panic>
  80292d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802930:	8b 00                	mov    (%eax),%eax
  802932:	85 c0                	test   %eax,%eax
  802934:	74 10                	je     802946 <alloc_block_NF+0x512>
  802936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80293e:	8b 52 04             	mov    0x4(%edx),%edx
  802941:	89 50 04             	mov    %edx,0x4(%eax)
  802944:	eb 0b                	jmp    802951 <alloc_block_NF+0x51d>
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 0f                	je     80296a <alloc_block_NF+0x536>
  80295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802964:	8b 12                	mov    (%edx),%edx
  802966:	89 10                	mov    %edx,(%eax)
  802968:	eb 0a                	jmp    802974 <alloc_block_NF+0x540>
  80296a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296d:	8b 00                	mov    (%eax),%eax
  80296f:	a3 48 41 80 00       	mov    %eax,0x804148
  802974:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802977:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802980:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802987:	a1 54 41 80 00       	mov    0x804154,%eax
  80298c:	48                   	dec    %eax
  80298d:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802995:	8b 40 08             	mov    0x8(%eax),%eax
  802998:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 50 08             	mov    0x8(%eax),%edx
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	01 c2                	add    %eax,%edx
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b4:	2b 45 08             	sub    0x8(%ebp),%eax
  8029b7:	89 c2                	mov    %eax,%edx
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	eb 3b                	jmp    8029ff <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d0:	74 07                	je     8029d9 <alloc_block_NF+0x5a5>
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 00                	mov    (%eax),%eax
  8029d7:	eb 05                	jmp    8029de <alloc_block_NF+0x5aa>
  8029d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029de:	a3 40 41 80 00       	mov    %eax,0x804140
  8029e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	0f 85 2e fe ff ff    	jne    80281e <alloc_block_NF+0x3ea>
  8029f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f4:	0f 85 24 fe ff ff    	jne    80281e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8029fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ff:	c9                   	leave  
  802a00:	c3                   	ret    

00802a01 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a01:	55                   	push   %ebp
  802a02:	89 e5                	mov    %esp,%ebp
  802a04:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a07:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a0f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a14:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a17:	a1 38 41 80 00       	mov    0x804138,%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 14                	je     802a34 <insert_sorted_with_merge_freeList+0x33>
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	8b 50 08             	mov    0x8(%eax),%edx
  802a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a29:	8b 40 08             	mov    0x8(%eax),%eax
  802a2c:	39 c2                	cmp    %eax,%edx
  802a2e:	0f 87 9b 01 00 00    	ja     802bcf <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a38:	75 17                	jne    802a51 <insert_sorted_with_merge_freeList+0x50>
  802a3a:	83 ec 04             	sub    $0x4,%esp
  802a3d:	68 e4 3c 80 00       	push   $0x803ce4
  802a42:	68 38 01 00 00       	push   $0x138
  802a47:	68 07 3d 80 00       	push   $0x803d07
  802a4c:	e8 b0 07 00 00       	call   803201 <_panic>
  802a51:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	89 10                	mov    %edx,(%eax)
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	85 c0                	test   %eax,%eax
  802a63:	74 0d                	je     802a72 <insert_sorted_with_merge_freeList+0x71>
  802a65:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6d:	89 50 04             	mov    %edx,0x4(%eax)
  802a70:	eb 08                	jmp    802a7a <insert_sorted_with_merge_freeList+0x79>
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	a3 38 41 80 00       	mov    %eax,0x804138
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8c:	a1 44 41 80 00       	mov    0x804144,%eax
  802a91:	40                   	inc    %eax
  802a92:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802a97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a9b:	0f 84 a8 06 00 00    	je     803149 <insert_sorted_with_merge_freeList+0x748>
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	8b 50 08             	mov    0x8(%eax),%edx
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802aad:	01 c2                	add    %eax,%edx
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	8b 40 08             	mov    0x8(%eax),%eax
  802ab5:	39 c2                	cmp    %eax,%edx
  802ab7:	0f 85 8c 06 00 00    	jne    803149 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac9:	01 c2                	add    %eax,%edx
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad5:	75 17                	jne    802aee <insert_sorted_with_merge_freeList+0xed>
  802ad7:	83 ec 04             	sub    $0x4,%esp
  802ada:	68 b0 3d 80 00       	push   $0x803db0
  802adf:	68 3c 01 00 00       	push   $0x13c
  802ae4:	68 07 3d 80 00       	push   $0x803d07
  802ae9:	e8 13 07 00 00       	call   803201 <_panic>
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	8b 00                	mov    (%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	74 10                	je     802b07 <insert_sorted_with_merge_freeList+0x106>
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aff:	8b 52 04             	mov    0x4(%edx),%edx
  802b02:	89 50 04             	mov    %edx,0x4(%eax)
  802b05:	eb 0b                	jmp    802b12 <insert_sorted_with_merge_freeList+0x111>
  802b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	8b 40 04             	mov    0x4(%eax),%eax
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	74 0f                	je     802b2b <insert_sorted_with_merge_freeList+0x12a>
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 40 04             	mov    0x4(%eax),%eax
  802b22:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b25:	8b 12                	mov    (%edx),%edx
  802b27:	89 10                	mov    %edx,(%eax)
  802b29:	eb 0a                	jmp    802b35 <insert_sorted_with_merge_freeList+0x134>
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	a3 38 41 80 00       	mov    %eax,0x804138
  802b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b48:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4d:	48                   	dec    %eax
  802b4e:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b56:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b6b:	75 17                	jne    802b84 <insert_sorted_with_merge_freeList+0x183>
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	68 e4 3c 80 00       	push   $0x803ce4
  802b75:	68 3f 01 00 00       	push   $0x13f
  802b7a:	68 07 3d 80 00       	push   $0x803d07
  802b7f:	e8 7d 06 00 00       	call   803201 <_panic>
  802b84:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0d                	je     802ba5 <insert_sorted_with_merge_freeList+0x1a4>
  802b98:	a1 48 41 80 00       	mov    0x804148,%eax
  802b9d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
  802ba3:	eb 08                	jmp    802bad <insert_sorted_with_merge_freeList+0x1ac>
  802ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb0:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbf:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc4:	40                   	inc    %eax
  802bc5:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bca:	e9 7a 05 00 00       	jmp    803149 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	8b 50 08             	mov    0x8(%eax),%edx
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 40 08             	mov    0x8(%eax),%eax
  802bdb:	39 c2                	cmp    %eax,%edx
  802bdd:	0f 82 14 01 00 00    	jb     802cf7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	01 c2                	add    %eax,%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	8b 40 08             	mov    0x8(%eax),%eax
  802bf7:	39 c2                	cmp    %eax,%edx
  802bf9:	0f 85 90 00 00 00    	jne    802c8f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c02:	8b 50 0c             	mov    0xc(%eax),%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0b:	01 c2                	add    %eax,%edx
  802c0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c10:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2b:	75 17                	jne    802c44 <insert_sorted_with_merge_freeList+0x243>
  802c2d:	83 ec 04             	sub    $0x4,%esp
  802c30:	68 e4 3c 80 00       	push   $0x803ce4
  802c35:	68 49 01 00 00       	push   $0x149
  802c3a:	68 07 3d 80 00       	push   $0x803d07
  802c3f:	e8 bd 05 00 00       	call   803201 <_panic>
  802c44:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	89 10                	mov    %edx,(%eax)
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	74 0d                	je     802c65 <insert_sorted_with_merge_freeList+0x264>
  802c58:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c60:	89 50 04             	mov    %edx,0x4(%eax)
  802c63:	eb 08                	jmp    802c6d <insert_sorted_with_merge_freeList+0x26c>
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	a3 48 41 80 00       	mov    %eax,0x804148
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7f:	a1 54 41 80 00       	mov    0x804154,%eax
  802c84:	40                   	inc    %eax
  802c85:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c8a:	e9 bb 04 00 00       	jmp    80314a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c93:	75 17                	jne    802cac <insert_sorted_with_merge_freeList+0x2ab>
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	68 58 3d 80 00       	push   $0x803d58
  802c9d:	68 4c 01 00 00       	push   $0x14c
  802ca2:	68 07 3d 80 00       	push   $0x803d07
  802ca7:	e8 55 05 00 00       	call   803201 <_panic>
  802cac:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	89 50 04             	mov    %edx,0x4(%eax)
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 40 04             	mov    0x4(%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	74 0c                	je     802cce <insert_sorted_with_merge_freeList+0x2cd>
  802cc2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cc7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cca:	89 10                	mov    %edx,(%eax)
  802ccc:	eb 08                	jmp    802cd6 <insert_sorted_with_merge_freeList+0x2d5>
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	a3 38 41 80 00       	mov    %eax,0x804138
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce7:	a1 44 41 80 00       	mov    0x804144,%eax
  802cec:	40                   	inc    %eax
  802ced:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cf2:	e9 53 04 00 00       	jmp    80314a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802cf7:	a1 38 41 80 00       	mov    0x804138,%eax
  802cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cff:	e9 15 04 00 00       	jmp    803119 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 00                	mov    (%eax),%eax
  802d09:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	8b 50 08             	mov    0x8(%eax),%edx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 08             	mov    0x8(%eax),%eax
  802d18:	39 c2                	cmp    %eax,%edx
  802d1a:	0f 86 f1 03 00 00    	jbe    803111 <insert_sorted_with_merge_freeList+0x710>
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	8b 50 08             	mov    0x8(%eax),%edx
  802d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d29:	8b 40 08             	mov    0x8(%eax),%eax
  802d2c:	39 c2                	cmp    %eax,%edx
  802d2e:	0f 83 dd 03 00 00    	jae    803111 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 50 08             	mov    0x8(%eax),%edx
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d40:	01 c2                	add    %eax,%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	0f 85 b9 01 00 00    	jne    802f09 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 50 08             	mov    0x8(%eax),%edx
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5c:	01 c2                	add    %eax,%edx
  802d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d61:	8b 40 08             	mov    0x8(%eax),%eax
  802d64:	39 c2                	cmp    %eax,%edx
  802d66:	0f 85 0d 01 00 00    	jne    802e79 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	01 c2                	add    %eax,%edx
  802d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d80:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d84:	75 17                	jne    802d9d <insert_sorted_with_merge_freeList+0x39c>
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	68 b0 3d 80 00       	push   $0x803db0
  802d8e:	68 5c 01 00 00       	push   $0x15c
  802d93:	68 07 3d 80 00       	push   $0x803d07
  802d98:	e8 64 04 00 00       	call   803201 <_panic>
  802d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 10                	je     802db6 <insert_sorted_with_merge_freeList+0x3b5>
  802da6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dae:	8b 52 04             	mov    0x4(%edx),%edx
  802db1:	89 50 04             	mov    %edx,0x4(%eax)
  802db4:	eb 0b                	jmp    802dc1 <insert_sorted_with_merge_freeList+0x3c0>
  802db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db9:	8b 40 04             	mov    0x4(%eax),%eax
  802dbc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 0f                	je     802dda <insert_sorted_with_merge_freeList+0x3d9>
  802dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dd4:	8b 12                	mov    (%edx),%edx
  802dd6:	89 10                	mov    %edx,(%eax)
  802dd8:	eb 0a                	jmp    802de4 <insert_sorted_with_merge_freeList+0x3e3>
  802dda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	a3 38 41 80 00       	mov    %eax,0x804138
  802de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ded:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dfc:	48                   	dec    %eax
  802dfd:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e05:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e1a:	75 17                	jne    802e33 <insert_sorted_with_merge_freeList+0x432>
  802e1c:	83 ec 04             	sub    $0x4,%esp
  802e1f:	68 e4 3c 80 00       	push   $0x803ce4
  802e24:	68 5f 01 00 00       	push   $0x15f
  802e29:	68 07 3d 80 00       	push   $0x803d07
  802e2e:	e8 ce 03 00 00       	call   803201 <_panic>
  802e33:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3c:	89 10                	mov    %edx,(%eax)
  802e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	85 c0                	test   %eax,%eax
  802e45:	74 0d                	je     802e54 <insert_sorted_with_merge_freeList+0x453>
  802e47:	a1 48 41 80 00       	mov    0x804148,%eax
  802e4c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4f:	89 50 04             	mov    %edx,0x4(%eax)
  802e52:	eb 08                	jmp    802e5c <insert_sorted_with_merge_freeList+0x45b>
  802e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e57:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e73:	40                   	inc    %eax
  802e74:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8b 40 0c             	mov    0xc(%eax),%eax
  802e85:	01 c2                	add    %eax,%edx
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ea1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea5:	75 17                	jne    802ebe <insert_sorted_with_merge_freeList+0x4bd>
  802ea7:	83 ec 04             	sub    $0x4,%esp
  802eaa:	68 e4 3c 80 00       	push   $0x803ce4
  802eaf:	68 64 01 00 00       	push   $0x164
  802eb4:	68 07 3d 80 00       	push   $0x803d07
  802eb9:	e8 43 03 00 00       	call   803201 <_panic>
  802ebe:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	89 10                	mov    %edx,(%eax)
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	74 0d                	je     802edf <insert_sorted_with_merge_freeList+0x4de>
  802ed2:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  802eda:	89 50 04             	mov    %edx,0x4(%eax)
  802edd:	eb 08                	jmp    802ee7 <insert_sorted_with_merge_freeList+0x4e6>
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	a3 48 41 80 00       	mov    %eax,0x804148
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef9:	a1 54 41 80 00       	mov    0x804154,%eax
  802efe:	40                   	inc    %eax
  802eff:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f04:	e9 41 02 00 00       	jmp    80314a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 50 08             	mov    0x8(%eax),%edx
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	01 c2                	add    %eax,%edx
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	8b 40 08             	mov    0x8(%eax),%eax
  802f1d:	39 c2                	cmp    %eax,%edx
  802f1f:	0f 85 7c 01 00 00    	jne    8030a1 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f29:	74 06                	je     802f31 <insert_sorted_with_merge_freeList+0x530>
  802f2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2f:	75 17                	jne    802f48 <insert_sorted_with_merge_freeList+0x547>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 20 3d 80 00       	push   $0x803d20
  802f39:	68 69 01 00 00       	push   $0x169
  802f3e:	68 07 3d 80 00       	push   $0x803d07
  802f43:	e8 b9 02 00 00       	call   803201 <_panic>
  802f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4b:	8b 50 04             	mov    0x4(%eax),%edx
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	89 50 04             	mov    %edx,0x4(%eax)
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5a:	89 10                	mov    %edx,(%eax)
  802f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 0d                	je     802f73 <insert_sorted_with_merge_freeList+0x572>
  802f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f69:	8b 40 04             	mov    0x4(%eax),%eax
  802f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6f:	89 10                	mov    %edx,(%eax)
  802f71:	eb 08                	jmp    802f7b <insert_sorted_with_merge_freeList+0x57a>
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	a3 38 41 80 00       	mov    %eax,0x804138
  802f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	a1 44 41 80 00       	mov    0x804144,%eax
  802f89:	40                   	inc    %eax
  802f8a:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 50 0c             	mov    0xc(%eax),%edx
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9b:	01 c2                	add    %eax,%edx
  802f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa0:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fa3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa7:	75 17                	jne    802fc0 <insert_sorted_with_merge_freeList+0x5bf>
  802fa9:	83 ec 04             	sub    $0x4,%esp
  802fac:	68 b0 3d 80 00       	push   $0x803db0
  802fb1:	68 6b 01 00 00       	push   $0x16b
  802fb6:	68 07 3d 80 00       	push   $0x803d07
  802fbb:	e8 41 02 00 00       	call   803201 <_panic>
  802fc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 10                	je     802fd9 <insert_sorted_with_merge_freeList+0x5d8>
  802fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd1:	8b 52 04             	mov    0x4(%edx),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 0b                	jmp    802fe4 <insert_sorted_with_merge_freeList+0x5e3>
  802fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	74 0f                	je     802ffd <insert_sorted_with_merge_freeList+0x5fc>
  802fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff1:	8b 40 04             	mov    0x4(%eax),%eax
  802ff4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff7:	8b 12                	mov    (%edx),%edx
  802ff9:	89 10                	mov    %edx,(%eax)
  802ffb:	eb 0a                	jmp    803007 <insert_sorted_with_merge_freeList+0x606>
  802ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	a3 38 41 80 00       	mov    %eax,0x804138
  803007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301a:	a1 44 41 80 00       	mov    0x804144,%eax
  80301f:	48                   	dec    %eax
  803020:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803028:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80302f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803032:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803039:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303d:	75 17                	jne    803056 <insert_sorted_with_merge_freeList+0x655>
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	68 e4 3c 80 00       	push   $0x803ce4
  803047:	68 6e 01 00 00       	push   $0x16e
  80304c:	68 07 3d 80 00       	push   $0x803d07
  803051:	e8 ab 01 00 00       	call   803201 <_panic>
  803056:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80305c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	85 c0                	test   %eax,%eax
  803068:	74 0d                	je     803077 <insert_sorted_with_merge_freeList+0x676>
  80306a:	a1 48 41 80 00       	mov    0x804148,%eax
  80306f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803072:	89 50 04             	mov    %edx,0x4(%eax)
  803075:	eb 08                	jmp    80307f <insert_sorted_with_merge_freeList+0x67e>
  803077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	a3 48 41 80 00       	mov    %eax,0x804148
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803091:	a1 54 41 80 00       	mov    0x804154,%eax
  803096:	40                   	inc    %eax
  803097:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80309c:	e9 a9 00 00 00       	jmp    80314a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a5:	74 06                	je     8030ad <insert_sorted_with_merge_freeList+0x6ac>
  8030a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ab:	75 17                	jne    8030c4 <insert_sorted_with_merge_freeList+0x6c3>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 7c 3d 80 00       	push   $0x803d7c
  8030b5:	68 73 01 00 00       	push   $0x173
  8030ba:	68 07 3d 80 00       	push   $0x803d07
  8030bf:	e8 3d 01 00 00       	call   803201 <_panic>
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 10                	mov    (%eax),%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	89 10                	mov    %edx,(%eax)
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	85 c0                	test   %eax,%eax
  8030d5:	74 0b                	je     8030e2 <insert_sorted_with_merge_freeList+0x6e1>
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	8b 00                	mov    (%eax),%eax
  8030dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030df:	89 50 04             	mov    %edx,0x4(%eax)
  8030e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e8:	89 10                	mov    %edx,(%eax)
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	85 c0                	test   %eax,%eax
  8030fa:	75 08                	jne    803104 <insert_sorted_with_merge_freeList+0x703>
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803104:	a1 44 41 80 00       	mov    0x804144,%eax
  803109:	40                   	inc    %eax
  80310a:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80310f:	eb 39                	jmp    80314a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803111:	a1 40 41 80 00       	mov    0x804140,%eax
  803116:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311d:	74 07                	je     803126 <insert_sorted_with_merge_freeList+0x725>
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	eb 05                	jmp    80312b <insert_sorted_with_merge_freeList+0x72a>
  803126:	b8 00 00 00 00       	mov    $0x0,%eax
  80312b:	a3 40 41 80 00       	mov    %eax,0x804140
  803130:	a1 40 41 80 00       	mov    0x804140,%eax
  803135:	85 c0                	test   %eax,%eax
  803137:	0f 85 c7 fb ff ff    	jne    802d04 <insert_sorted_with_merge_freeList+0x303>
  80313d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803141:	0f 85 bd fb ff ff    	jne    802d04 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803147:	eb 01                	jmp    80314a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803149:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80314a:	90                   	nop
  80314b:	c9                   	leave  
  80314c:	c3                   	ret    

0080314d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80314d:	55                   	push   %ebp
  80314e:	89 e5                	mov    %esp,%ebp
  803150:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803153:	8b 55 08             	mov    0x8(%ebp),%edx
  803156:	89 d0                	mov    %edx,%eax
  803158:	c1 e0 02             	shl    $0x2,%eax
  80315b:	01 d0                	add    %edx,%eax
  80315d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803164:	01 d0                	add    %edx,%eax
  803166:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80316d:	01 d0                	add    %edx,%eax
  80316f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803176:	01 d0                	add    %edx,%eax
  803178:	c1 e0 04             	shl    $0x4,%eax
  80317b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80317e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803185:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803188:	83 ec 0c             	sub    $0xc,%esp
  80318b:	50                   	push   %eax
  80318c:	e8 26 e7 ff ff       	call   8018b7 <sys_get_virtual_time>
  803191:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803194:	eb 41                	jmp    8031d7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803196:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803199:	83 ec 0c             	sub    $0xc,%esp
  80319c:	50                   	push   %eax
  80319d:	e8 15 e7 ff ff       	call   8018b7 <sys_get_virtual_time>
  8031a2:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8031a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	29 c2                	sub    %eax,%edx
  8031ad:	89 d0                	mov    %edx,%eax
  8031af:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8031b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b8:	89 d1                	mov    %edx,%ecx
  8031ba:	29 c1                	sub    %eax,%ecx
  8031bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031c2:	39 c2                	cmp    %eax,%edx
  8031c4:	0f 97 c0             	seta   %al
  8031c7:	0f b6 c0             	movzbl %al,%eax
  8031ca:	29 c1                	sub    %eax,%ecx
  8031cc:	89 c8                	mov    %ecx,%eax
  8031ce:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8031d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8031dd:	72 b7                	jb     803196 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8031df:	90                   	nop
  8031e0:	c9                   	leave  
  8031e1:	c3                   	ret    

008031e2 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8031e2:	55                   	push   %ebp
  8031e3:	89 e5                	mov    %esp,%ebp
  8031e5:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8031e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8031ef:	eb 03                	jmp    8031f4 <busy_wait+0x12>
  8031f1:	ff 45 fc             	incl   -0x4(%ebp)
  8031f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8031f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031fa:	72 f5                	jb     8031f1 <busy_wait+0xf>
	return i;
  8031fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8031ff:	c9                   	leave  
  803200:	c3                   	ret    

00803201 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803201:	55                   	push   %ebp
  803202:	89 e5                	mov    %esp,%ebp
  803204:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803207:	8d 45 10             	lea    0x10(%ebp),%eax
  80320a:	83 c0 04             	add    $0x4,%eax
  80320d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803210:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 16                	je     80322f <_panic+0x2e>
		cprintf("%s: ", argv0);
  803219:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80321e:	83 ec 08             	sub    $0x8,%esp
  803221:	50                   	push   %eax
  803222:	68 d0 3d 80 00       	push   $0x803dd0
  803227:	e8 4f d1 ff ff       	call   80037b <cprintf>
  80322c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80322f:	a1 00 40 80 00       	mov    0x804000,%eax
  803234:	ff 75 0c             	pushl  0xc(%ebp)
  803237:	ff 75 08             	pushl  0x8(%ebp)
  80323a:	50                   	push   %eax
  80323b:	68 d5 3d 80 00       	push   $0x803dd5
  803240:	e8 36 d1 ff ff       	call   80037b <cprintf>
  803245:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803248:	8b 45 10             	mov    0x10(%ebp),%eax
  80324b:	83 ec 08             	sub    $0x8,%esp
  80324e:	ff 75 f4             	pushl  -0xc(%ebp)
  803251:	50                   	push   %eax
  803252:	e8 b9 d0 ff ff       	call   800310 <vcprintf>
  803257:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80325a:	83 ec 08             	sub    $0x8,%esp
  80325d:	6a 00                	push   $0x0
  80325f:	68 f1 3d 80 00       	push   $0x803df1
  803264:	e8 a7 d0 ff ff       	call   800310 <vcprintf>
  803269:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80326c:	e8 28 d0 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  803271:	eb fe                	jmp    803271 <_panic+0x70>

00803273 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803273:	55                   	push   %ebp
  803274:	89 e5                	mov    %esp,%ebp
  803276:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803279:	a1 20 40 80 00       	mov    0x804020,%eax
  80327e:	8b 50 74             	mov    0x74(%eax),%edx
  803281:	8b 45 0c             	mov    0xc(%ebp),%eax
  803284:	39 c2                	cmp    %eax,%edx
  803286:	74 14                	je     80329c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803288:	83 ec 04             	sub    $0x4,%esp
  80328b:	68 f4 3d 80 00       	push   $0x803df4
  803290:	6a 26                	push   $0x26
  803292:	68 40 3e 80 00       	push   $0x803e40
  803297:	e8 65 ff ff ff       	call   803201 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80329c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032aa:	e9 c2 00 00 00       	jmp    803371 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	01 d0                	add    %edx,%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	75 08                	jne    8032cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8032c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8032c7:	e9 a2 00 00 00       	jmp    80336e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8032cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8032da:	eb 69                	jmp    803345 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8032dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8032e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ea:	89 d0                	mov    %edx,%eax
  8032ec:	01 c0                	add    %eax,%eax
  8032ee:	01 d0                	add    %edx,%eax
  8032f0:	c1 e0 03             	shl    $0x3,%eax
  8032f3:	01 c8                	add    %ecx,%eax
  8032f5:	8a 40 04             	mov    0x4(%eax),%al
  8032f8:	84 c0                	test   %al,%al
  8032fa:	75 46                	jne    803342 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032fc:	a1 20 40 80 00       	mov    0x804020,%eax
  803301:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803307:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330a:	89 d0                	mov    %edx,%eax
  80330c:	01 c0                	add    %eax,%eax
  80330e:	01 d0                	add    %edx,%eax
  803310:	c1 e0 03             	shl    $0x3,%eax
  803313:	01 c8                	add    %ecx,%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80331a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80331d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803322:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803327:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	01 c8                	add    %ecx,%eax
  803333:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803335:	39 c2                	cmp    %eax,%edx
  803337:	75 09                	jne    803342 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803339:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803340:	eb 12                	jmp    803354 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803342:	ff 45 e8             	incl   -0x18(%ebp)
  803345:	a1 20 40 80 00       	mov    0x804020,%eax
  80334a:	8b 50 74             	mov    0x74(%eax),%edx
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	77 88                	ja     8032dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803354:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803358:	75 14                	jne    80336e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80335a:	83 ec 04             	sub    $0x4,%esp
  80335d:	68 4c 3e 80 00       	push   $0x803e4c
  803362:	6a 3a                	push   $0x3a
  803364:	68 40 3e 80 00       	push   $0x803e40
  803369:	e8 93 fe ff ff       	call   803201 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80336e:	ff 45 f0             	incl   -0x10(%ebp)
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803377:	0f 8c 32 ff ff ff    	jl     8032af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80337d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803384:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80338b:	eb 26                	jmp    8033b3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80338d:	a1 20 40 80 00       	mov    0x804020,%eax
  803392:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803398:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80339b:	89 d0                	mov    %edx,%eax
  80339d:	01 c0                	add    %eax,%eax
  80339f:	01 d0                	add    %edx,%eax
  8033a1:	c1 e0 03             	shl    $0x3,%eax
  8033a4:	01 c8                	add    %ecx,%eax
  8033a6:	8a 40 04             	mov    0x4(%eax),%al
  8033a9:	3c 01                	cmp    $0x1,%al
  8033ab:	75 03                	jne    8033b0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033ad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033b0:	ff 45 e0             	incl   -0x20(%ebp)
  8033b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8033b8:	8b 50 74             	mov    0x74(%eax),%edx
  8033bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033be:	39 c2                	cmp    %eax,%edx
  8033c0:	77 cb                	ja     80338d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033c8:	74 14                	je     8033de <CheckWSWithoutLastIndex+0x16b>
		panic(
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	68 a0 3e 80 00       	push   $0x803ea0
  8033d2:	6a 44                	push   $0x44
  8033d4:	68 40 3e 80 00       	push   $0x803e40
  8033d9:	e8 23 fe ff ff       	call   803201 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8033de:	90                   	nop
  8033df:	c9                   	leave  
  8033e0:	c3                   	ret    
  8033e1:	66 90                	xchg   %ax,%ax
  8033e3:	90                   	nop

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
