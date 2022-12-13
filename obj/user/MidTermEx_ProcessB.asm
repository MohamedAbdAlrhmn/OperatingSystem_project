
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
  80003e:	e8 8e 18 00 00       	call   8018d1 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 a0 36 80 00       	push   $0x8036a0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 de 13 00 00       	call   801434 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a2 36 80 00       	push   $0x8036a2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 c8 13 00 00       	call   801434 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a9 36 80 00       	push   $0x8036a9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 b2 13 00 00       	call   801434 <sget>
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
  800095:	68 b7 36 80 00       	push   $0x8036b7
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 d0 16 00 00       	call   801772 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 53 18 00 00       	call   801904 <sys_get_virtual_time>
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
  8000d4:	e8 c1 30 00 00       	call   80319a <env_sleep>
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
  8000ec:	e8 13 18 00 00       	call   801904 <sys_get_virtual_time>
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
  800114:	e8 81 30 00 00       	call   80319a <env_sleep>
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
  80012b:	e8 d4 17 00 00       	call   801904 <sys_get_virtual_time>
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
  800153:	e8 42 30 00 00       	call   80319a <env_sleep>
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
  800171:	e8 42 17 00 00       	call   8018b8 <sys_getenvindex>
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
  8001dc:	e8 e4 14 00 00       	call   8016c5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 d4 36 80 00       	push   $0x8036d4
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
  80020c:	68 fc 36 80 00       	push   $0x8036fc
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
  80023d:	68 24 37 80 00       	push   $0x803724
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 7c 37 80 00       	push   $0x80377c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 d4 36 80 00       	push   $0x8036d4
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 64 14 00 00       	call   8016df <sys_enable_interrupt>

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
  80028e:	e8 f1 15 00 00       	call   801884 <sys_destroy_env>
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
  80029f:	e8 46 16 00 00       	call   8018ea <sys_exit_env>
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
  8002ed:	e8 25 12 00 00       	call   801517 <sys_cputs>
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
  800364:	e8 ae 11 00 00       	call   801517 <sys_cputs>
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
  8003ae:	e8 12 13 00 00       	call   8016c5 <sys_disable_interrupt>
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
  8003ce:	e8 0c 13 00 00       	call   8016df <sys_enable_interrupt>
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
  800418:	e8 13 30 00 00       	call   803430 <__udivdi3>
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
  800468:	e8 d3 30 00 00       	call   803540 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 b4 39 80 00       	add    $0x8039b4,%eax
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
  8005c3:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
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
  8006a4:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 c5 39 80 00       	push   $0x8039c5
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
  8006c9:	68 ce 39 80 00       	push   $0x8039ce
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
  8006f6:	be d1 39 80 00       	mov    $0x8039d1,%esi
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
  80111c:	68 30 3b 80 00       	push   $0x803b30
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
  8011ec:	e8 6a 04 00 00       	call   80165b <sys_allocate_chunk>
  8011f1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	50                   	push   %eax
  8011fd:	e8 df 0a 00 00       	call   801ce1 <initialize_MemBlocksList>
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
  80122a:	68 55 3b 80 00       	push   $0x803b55
  80122f:	6a 33                	push   $0x33
  801231:	68 73 3b 80 00       	push   $0x803b73
  801236:	e8 13 20 00 00       	call   80324e <_panic>
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
  8012a9:	68 80 3b 80 00       	push   $0x803b80
  8012ae:	6a 34                	push   $0x34
  8012b0:	68 73 3b 80 00       	push   $0x803b73
  8012b5:	e8 94 1f 00 00       	call   80324e <_panic>
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
  801306:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801309:	e8 f7 fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  80130e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801312:	75 07                	jne    80131b <malloc+0x18>
  801314:	b8 00 00 00 00       	mov    $0x0,%eax
  801319:	eb 61                	jmp    80137c <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  80131b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801322:	8b 55 08             	mov    0x8(%ebp),%edx
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	01 d0                	add    %edx,%eax
  80132a:	48                   	dec    %eax
  80132b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80132e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801331:	ba 00 00 00 00       	mov    $0x0,%edx
  801336:	f7 75 f0             	divl   -0x10(%ebp)
  801339:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133c:	29 d0                	sub    %edx,%eax
  80133e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801341:	e8 e3 06 00 00       	call   801a29 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801346:	85 c0                	test   %eax,%eax
  801348:	74 11                	je     80135b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80134a:	83 ec 0c             	sub    $0xc,%esp
  80134d:	ff 75 e8             	pushl  -0x18(%ebp)
  801350:	e8 4e 0d 00 00       	call   8020a3 <alloc_block_FF>
  801355:	83 c4 10             	add    $0x10,%esp
  801358:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  80135b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80135f:	74 16                	je     801377 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801361:	83 ec 0c             	sub    $0xc,%esp
  801364:	ff 75 f4             	pushl  -0xc(%ebp)
  801367:	e8 aa 0a 00 00       	call   801e16 <insert_sorted_allocList>
  80136c:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80136f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801372:	8b 40 08             	mov    0x8(%eax),%eax
  801375:	eb 05                	jmp    80137c <malloc+0x79>
	}

    return NULL;
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	68 a4 3b 80 00       	push   $0x803ba4
  80138c:	6a 6f                	push   $0x6f
  80138e:	68 73 3b 80 00       	push   $0x803b73
  801393:	e8 b6 1e 00 00       	call   80324e <_panic>

00801398 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
  80139b:	83 ec 38             	sub    $0x38,%esp
  80139e:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a1:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013a4:	e8 5c fd ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  8013a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ad:	75 07                	jne    8013b6 <smalloc+0x1e>
  8013af:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b4:	eb 7c                	jmp    801432 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8013b6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	48                   	dec    %eax
  8013c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d1:	f7 75 f0             	divl   -0x10(%ebp)
  8013d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013d7:	29 d0                	sub    %edx,%eax
  8013d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8013dc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013e3:	e8 41 06 00 00       	call   801a29 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	74 11                	je     8013fd <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f2:	e8 ac 0c 00 00       	call   8020a3 <alloc_block_FF>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8013fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801401:	74 2a                	je     80142d <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801406:	8b 40 08             	mov    0x8(%eax),%eax
  801409:	89 c2                	mov    %eax,%edx
  80140b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80140f:	52                   	push   %edx
  801410:	50                   	push   %eax
  801411:	ff 75 0c             	pushl  0xc(%ebp)
  801414:	ff 75 08             	pushl  0x8(%ebp)
  801417:	e8 92 03 00 00       	call   8017ae <sys_createSharedObject>
  80141c:	83 c4 10             	add    $0x10,%esp
  80141f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801422:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801426:	74 05                	je     80142d <smalloc+0x95>
			return (void*)virtual_address;
  801428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142b:	eb 05                	jmp    801432 <smalloc+0x9a>
	}
	return NULL;
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80143a:	e8 c6 fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80143f:	83 ec 04             	sub    $0x4,%esp
  801442:	68 c8 3b 80 00       	push   $0x803bc8
  801447:	68 b0 00 00 00       	push   $0xb0
  80144c:	68 73 3b 80 00       	push   $0x803b73
  801451:	e8 f8 1d 00 00       	call   80324e <_panic>

00801456 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80145c:	e8 a4 fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 ec 3b 80 00       	push   $0x803bec
  801469:	68 f4 00 00 00       	push   $0xf4
  80146e:	68 73 3b 80 00       	push   $0x803b73
  801473:	e8 d6 1d 00 00       	call   80324e <_panic>

00801478 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
  80147b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80147e:	83 ec 04             	sub    $0x4,%esp
  801481:	68 14 3c 80 00       	push   $0x803c14
  801486:	68 08 01 00 00       	push   $0x108
  80148b:	68 73 3b 80 00       	push   $0x803b73
  801490:	e8 b9 1d 00 00       	call   80324e <_panic>

00801495 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	68 38 3c 80 00       	push   $0x803c38
  8014a3:	68 13 01 00 00       	push   $0x113
  8014a8:	68 73 3b 80 00       	push   $0x803b73
  8014ad:	e8 9c 1d 00 00       	call   80324e <_panic>

008014b2 <shrink>:

}
void shrink(uint32 newSize)
{
  8014b2:	55                   	push   %ebp
  8014b3:	89 e5                	mov    %esp,%ebp
  8014b5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014b8:	83 ec 04             	sub    $0x4,%esp
  8014bb:	68 38 3c 80 00       	push   $0x803c38
  8014c0:	68 18 01 00 00       	push   $0x118
  8014c5:	68 73 3b 80 00       	push   $0x803b73
  8014ca:	e8 7f 1d 00 00       	call   80324e <_panic>

008014cf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	68 38 3c 80 00       	push   $0x803c38
  8014dd:	68 1d 01 00 00       	push   $0x11d
  8014e2:	68 73 3b 80 00       	push   $0x803b73
  8014e7:	e8 62 1d 00 00       	call   80324e <_panic>

008014ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	57                   	push   %edi
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801501:	8b 7d 18             	mov    0x18(%ebp),%edi
  801504:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801507:	cd 30                	int    $0x30
  801509:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80150c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	5b                   	pop    %ebx
  801513:	5e                   	pop    %esi
  801514:	5f                   	pop    %edi
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	8b 45 10             	mov    0x10(%ebp),%eax
  801520:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801523:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	52                   	push   %edx
  80152f:	ff 75 0c             	pushl  0xc(%ebp)
  801532:	50                   	push   %eax
  801533:	6a 00                	push   $0x0
  801535:	e8 b2 ff ff ff       	call   8014ec <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
}
  80153d:	90                   	nop
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_cgetc>:

int
sys_cgetc(void)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801543:	6a 00                	push   $0x0
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 01                	push   $0x1
  80154f:	e8 98 ff ff ff       	call   8014ec <syscall>
  801554:	83 c4 18             	add    $0x18,%esp
}
  801557:	c9                   	leave  
  801558:	c3                   	ret    

00801559 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801559:	55                   	push   %ebp
  80155a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80155c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155f:	8b 45 08             	mov    0x8(%ebp),%eax
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	50                   	push   %eax
  80156a:	6a 05                	push   $0x5
  80156c:	e8 7b ff ff ff       	call   8014ec <syscall>
  801571:	83 c4 18             	add    $0x18,%esp
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80157b:	8b 75 18             	mov    0x18(%ebp),%esi
  80157e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801581:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	56                   	push   %esi
  80158b:	53                   	push   %ebx
  80158c:	51                   	push   %ecx
  80158d:	52                   	push   %edx
  80158e:	50                   	push   %eax
  80158f:	6a 06                	push   $0x6
  801591:	e8 56 ff ff ff       	call   8014ec <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	6a 00                	push   $0x0
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	6a 07                	push   $0x7
  8015b3:	e8 34 ff ff ff       	call   8014ec <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	6a 08                	push   $0x8
  8015ce:	e8 19 ff ff ff       	call   8014ec <syscall>
  8015d3:	83 c4 18             	add    $0x18,%esp
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 09                	push   $0x9
  8015e7:	e8 00 ff ff ff       	call   8014ec <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 0a                	push   $0xa
  801600:	e8 e7 fe ff ff       	call   8014ec <syscall>
  801605:	83 c4 18             	add    $0x18,%esp
}
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 0b                	push   $0xb
  801619:	e8 ce fe ff ff       	call   8014ec <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	ff 75 0c             	pushl  0xc(%ebp)
  80162f:	ff 75 08             	pushl  0x8(%ebp)
  801632:	6a 0f                	push   $0xf
  801634:	e8 b3 fe ff ff       	call   8014ec <syscall>
  801639:	83 c4 18             	add    $0x18,%esp
	return;
  80163c:	90                   	nop
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	ff 75 0c             	pushl  0xc(%ebp)
  80164b:	ff 75 08             	pushl  0x8(%ebp)
  80164e:	6a 10                	push   $0x10
  801650:	e8 97 fe ff ff       	call   8014ec <syscall>
  801655:	83 c4 18             	add    $0x18,%esp
	return ;
  801658:	90                   	nop
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	ff 75 10             	pushl  0x10(%ebp)
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	6a 11                	push   $0x11
  80166d:	e8 7a fe ff ff       	call   8014ec <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
	return ;
  801675:	90                   	nop
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 0c                	push   $0xc
  801687:	e8 60 fe ff ff       	call   8014ec <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    

00801691 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801691:	55                   	push   %ebp
  801692:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801694:	6a 00                	push   $0x0
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	6a 0d                	push   $0xd
  8016a1:	e8 46 fe ff ff       	call   8014ec <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 0e                	push   $0xe
  8016ba:	e8 2d fe ff ff       	call   8014ec <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
}
  8016c2:	90                   	nop
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 00                	push   $0x0
  8016cc:	6a 00                	push   $0x0
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 13                	push   $0x13
  8016d4:	e8 13 fe ff ff       	call   8014ec <syscall>
  8016d9:	83 c4 18             	add    $0x18,%esp
}
  8016dc:	90                   	nop
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 14                	push   $0x14
  8016ee:	e8 f9 fd ff ff       	call   8014ec <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	90                   	nop
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801705:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	50                   	push   %eax
  801712:	6a 15                	push   $0x15
  801714:	e8 d3 fd ff ff       	call   8014ec <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
}
  80171c:	90                   	nop
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 16                	push   $0x16
  80172e:	e8 b9 fd ff ff       	call   8014ec <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	90                   	nop
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	ff 75 0c             	pushl  0xc(%ebp)
  801748:	50                   	push   %eax
  801749:	6a 17                	push   $0x17
  80174b:	e8 9c fd ff ff       	call   8014ec <syscall>
  801750:	83 c4 18             	add    $0x18,%esp
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	52                   	push   %edx
  801765:	50                   	push   %eax
  801766:	6a 1a                	push   $0x1a
  801768:	e8 7f fd ff ff       	call   8014ec <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	c9                   	leave  
  801771:	c3                   	ret    

00801772 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801775:	8b 55 0c             	mov    0xc(%ebp),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	52                   	push   %edx
  801782:	50                   	push   %eax
  801783:	6a 18                	push   $0x18
  801785:	e8 62 fd ff ff       	call   8014ec <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801793:	8b 55 0c             	mov    0xc(%ebp),%edx
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	6a 00                	push   $0x0
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	52                   	push   %edx
  8017a0:	50                   	push   %eax
  8017a1:	6a 19                	push   $0x19
  8017a3:	e8 44 fd ff ff       	call   8014ec <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017ba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017bd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	6a 00                	push   $0x0
  8017c6:	51                   	push   %ecx
  8017c7:	52                   	push   %edx
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	50                   	push   %eax
  8017cc:	6a 1b                	push   $0x1b
  8017ce:	e8 19 fd ff ff       	call   8014ec <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	52                   	push   %edx
  8017e8:	50                   	push   %eax
  8017e9:	6a 1c                	push   $0x1c
  8017eb:	e8 fc fc ff ff       	call   8014ec <syscall>
  8017f0:	83 c4 18             	add    $0x18,%esp
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	51                   	push   %ecx
  801806:	52                   	push   %edx
  801807:	50                   	push   %eax
  801808:	6a 1d                	push   $0x1d
  80180a:	e8 dd fc ff ff       	call   8014ec <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 1e                	push   $0x1e
  801827:	e8 c0 fc ff ff       	call   8014ec <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 1f                	push   $0x1f
  801840:	e8 a7 fc ff ff       	call   8014ec <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	ff 75 14             	pushl  0x14(%ebp)
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	ff 75 0c             	pushl  0xc(%ebp)
  80185b:	50                   	push   %eax
  80185c:	6a 20                	push   $0x20
  80185e:	e8 89 fc ff ff       	call   8014ec <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	50                   	push   %eax
  801877:	6a 21                	push   $0x21
  801879:	e8 6e fc ff ff       	call   8014ec <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	90                   	nop
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	50                   	push   %eax
  801893:	6a 22                	push   $0x22
  801895:	e8 52 fc ff ff       	call   8014ec <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 02                	push   $0x2
  8018ae:	e8 39 fc ff ff       	call   8014ec <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 03                	push   $0x3
  8018c7:	e8 20 fc ff ff       	call   8014ec <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 04                	push   $0x4
  8018e0:	e8 07 fc ff ff       	call   8014ec <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_exit_env>:


void sys_exit_env(void)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 23                	push   $0x23
  8018f9:	e8 ee fb ff ff       	call   8014ec <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	90                   	nop
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80190d:	8d 50 04             	lea    0x4(%eax),%edx
  801910:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	52                   	push   %edx
  80191a:	50                   	push   %eax
  80191b:	6a 24                	push   $0x24
  80191d:	e8 ca fb ff ff       	call   8014ec <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
	return result;
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80192b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80192e:	89 01                	mov    %eax,(%ecx)
  801930:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	c9                   	leave  
  801937:	c2 04 00             	ret    $0x4

0080193a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	ff 75 10             	pushl  0x10(%ebp)
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	ff 75 08             	pushl  0x8(%ebp)
  80194a:	6a 12                	push   $0x12
  80194c:	e8 9b fb ff ff       	call   8014ec <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
	return ;
  801954:	90                   	nop
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_rcr2>:
uint32 sys_rcr2()
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 25                	push   $0x25
  801966:	e8 81 fb ff ff       	call   8014ec <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 04             	sub    $0x4,%esp
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80197c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	50                   	push   %eax
  801989:	6a 26                	push   $0x26
  80198b:	e8 5c fb ff ff       	call   8014ec <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
	return ;
  801993:	90                   	nop
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <rsttst>:
void rsttst()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 28                	push   $0x28
  8019a5:	e8 42 fb ff ff       	call   8014ec <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ad:	90                   	nop
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019bc:	8b 55 18             	mov    0x18(%ebp),%edx
  8019bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c3:	52                   	push   %edx
  8019c4:	50                   	push   %eax
  8019c5:	ff 75 10             	pushl  0x10(%ebp)
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	6a 27                	push   $0x27
  8019d0:	e8 17 fb ff ff       	call   8014ec <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d8:	90                   	nop
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <chktst>:
void chktst(uint32 n)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	6a 29                	push   $0x29
  8019eb:	e8 fc fa ff ff       	call   8014ec <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f3:	90                   	nop
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <inctst>:

void inctst()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 2a                	push   $0x2a
  801a05:	e8 e2 fa ff ff       	call   8014ec <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0d:	90                   	nop
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <gettst>:
uint32 gettst()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 2b                	push   $0x2b
  801a1f:	e8 c8 fa ff ff       	call   8014ec <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 2c                	push   $0x2c
  801a3b:	e8 ac fa ff ff       	call   8014ec <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
  801a43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a46:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a4a:	75 07                	jne    801a53 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801a51:	eb 05                	jmp    801a58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 2c                	push   $0x2c
  801a6c:	e8 7b fa ff ff       	call   8014ec <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
  801a74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a77:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a7b:	75 07                	jne    801a84 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801a82:	eb 05                	jmp    801a89 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 2c                	push   $0x2c
  801a9d:	e8 4a fa ff ff       	call   8014ec <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
  801aa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aa8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aac:	75 07                	jne    801ab5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aae:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab3:	eb 05                	jmp    801aba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801ace:	e8 19 fa ff ff       	call   8014ec <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
  801ad6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ad9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801add:	75 07                	jne    801ae6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801adf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae4:	eb 05                	jmp    801aeb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ae6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	6a 2d                	push   $0x2d
  801afd:	e8 ea f9 ff ff       	call   8014ec <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
	return ;
  801b05:	90                   	nop
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b0c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b15:	8b 45 08             	mov    0x8(%ebp),%eax
  801b18:	6a 00                	push   $0x0
  801b1a:	53                   	push   %ebx
  801b1b:	51                   	push   %ecx
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 2e                	push   $0x2e
  801b20:	e8 c7 f9 ff ff       	call   8014ec <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	52                   	push   %edx
  801b3d:	50                   	push   %eax
  801b3e:	6a 2f                	push   $0x2f
  801b40:	e8 a7 f9 ff ff       	call   8014ec <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b50:	83 ec 0c             	sub    $0xc,%esp
  801b53:	68 48 3c 80 00       	push   $0x803c48
  801b58:	e8 1e e8 ff ff       	call   80037b <cprintf>
  801b5d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b67:	83 ec 0c             	sub    $0xc,%esp
  801b6a:	68 74 3c 80 00       	push   $0x803c74
  801b6f:	e8 07 e8 ff ff       	call   80037b <cprintf>
  801b74:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b77:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b7b:	a1 38 41 80 00       	mov    0x804138,%eax
  801b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b83:	eb 56                	jmp    801bdb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b89:	74 1c                	je     801ba7 <print_mem_block_lists+0x5d>
  801b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8e:	8b 50 08             	mov    0x8(%eax),%edx
  801b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b94:	8b 48 08             	mov    0x8(%eax),%ecx
  801b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b9d:	01 c8                	add    %ecx,%eax
  801b9f:	39 c2                	cmp    %eax,%edx
  801ba1:	73 04                	jae    801ba7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ba3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801baa:	8b 50 08             	mov    0x8(%eax),%edx
  801bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb3:	01 c2                	add    %eax,%edx
  801bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb8:	8b 40 08             	mov    0x8(%eax),%eax
  801bbb:	83 ec 04             	sub    $0x4,%esp
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	68 89 3c 80 00       	push   $0x803c89
  801bc5:	e8 b1 e7 ff ff       	call   80037b <cprintf>
  801bca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801bd3:	a1 40 41 80 00       	mov    0x804140,%eax
  801bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bdf:	74 07                	je     801be8 <print_mem_block_lists+0x9e>
  801be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be4:	8b 00                	mov    (%eax),%eax
  801be6:	eb 05                	jmp    801bed <print_mem_block_lists+0xa3>
  801be8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bed:	a3 40 41 80 00       	mov    %eax,0x804140
  801bf2:	a1 40 41 80 00       	mov    0x804140,%eax
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	75 8a                	jne    801b85 <print_mem_block_lists+0x3b>
  801bfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bff:	75 84                	jne    801b85 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c01:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c05:	75 10                	jne    801c17 <print_mem_block_lists+0xcd>
  801c07:	83 ec 0c             	sub    $0xc,%esp
  801c0a:	68 98 3c 80 00       	push   $0x803c98
  801c0f:	e8 67 e7 ff ff       	call   80037b <cprintf>
  801c14:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801c17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801c1e:	83 ec 0c             	sub    $0xc,%esp
  801c21:	68 bc 3c 80 00       	push   $0x803cbc
  801c26:	e8 50 e7 ff ff       	call   80037b <cprintf>
  801c2b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801c2e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c32:	a1 40 40 80 00       	mov    0x804040,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 56                	jmp    801c92 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c40:	74 1c                	je     801c5e <print_mem_block_lists+0x114>
  801c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c45:	8b 50 08             	mov    0x8(%eax),%edx
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	8b 48 08             	mov    0x8(%eax),%ecx
  801c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c51:	8b 40 0c             	mov    0xc(%eax),%eax
  801c54:	01 c8                	add    %ecx,%eax
  801c56:	39 c2                	cmp    %eax,%edx
  801c58:	73 04                	jae    801c5e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c5a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c61:	8b 50 08             	mov    0x8(%eax),%edx
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	8b 40 0c             	mov    0xc(%eax),%eax
  801c6a:	01 c2                	add    %eax,%edx
  801c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6f:	8b 40 08             	mov    0x8(%eax),%eax
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	52                   	push   %edx
  801c76:	50                   	push   %eax
  801c77:	68 89 3c 80 00       	push   $0x803c89
  801c7c:	e8 fa e6 ff ff       	call   80037b <cprintf>
  801c81:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c8a:	a1 48 40 80 00       	mov    0x804048,%eax
  801c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c96:	74 07                	je     801c9f <print_mem_block_lists+0x155>
  801c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9b:	8b 00                	mov    (%eax),%eax
  801c9d:	eb 05                	jmp    801ca4 <print_mem_block_lists+0x15a>
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca4:	a3 48 40 80 00       	mov    %eax,0x804048
  801ca9:	a1 48 40 80 00       	mov    0x804048,%eax
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	75 8a                	jne    801c3c <print_mem_block_lists+0xf2>
  801cb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cb6:	75 84                	jne    801c3c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801cb8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801cbc:	75 10                	jne    801cce <print_mem_block_lists+0x184>
  801cbe:	83 ec 0c             	sub    $0xc,%esp
  801cc1:	68 d4 3c 80 00       	push   $0x803cd4
  801cc6:	e8 b0 e6 ff ff       	call   80037b <cprintf>
  801ccb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801cce:	83 ec 0c             	sub    $0xc,%esp
  801cd1:	68 48 3c 80 00       	push   $0x803c48
  801cd6:	e8 a0 e6 ff ff       	call   80037b <cprintf>
  801cdb:	83 c4 10             	add    $0x10,%esp

}
  801cde:	90                   	nop
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ce7:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801cee:	00 00 00 
  801cf1:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801cf8:	00 00 00 
  801cfb:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d02:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d0c:	e9 9e 00 00 00       	jmp    801daf <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801d11:	a1 50 40 80 00       	mov    0x804050,%eax
  801d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d19:	c1 e2 04             	shl    $0x4,%edx
  801d1c:	01 d0                	add    %edx,%eax
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	75 14                	jne    801d36 <initialize_MemBlocksList+0x55>
  801d22:	83 ec 04             	sub    $0x4,%esp
  801d25:	68 fc 3c 80 00       	push   $0x803cfc
  801d2a:	6a 46                	push   $0x46
  801d2c:	68 1f 3d 80 00       	push   $0x803d1f
  801d31:	e8 18 15 00 00       	call   80324e <_panic>
  801d36:	a1 50 40 80 00       	mov    0x804050,%eax
  801d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3e:	c1 e2 04             	shl    $0x4,%edx
  801d41:	01 d0                	add    %edx,%eax
  801d43:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801d49:	89 10                	mov    %edx,(%eax)
  801d4b:	8b 00                	mov    (%eax),%eax
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	74 18                	je     801d69 <initialize_MemBlocksList+0x88>
  801d51:	a1 48 41 80 00       	mov    0x804148,%eax
  801d56:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d5c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d5f:	c1 e1 04             	shl    $0x4,%ecx
  801d62:	01 ca                	add    %ecx,%edx
  801d64:	89 50 04             	mov    %edx,0x4(%eax)
  801d67:	eb 12                	jmp    801d7b <initialize_MemBlocksList+0x9a>
  801d69:	a1 50 40 80 00       	mov    0x804050,%eax
  801d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d71:	c1 e2 04             	shl    $0x4,%edx
  801d74:	01 d0                	add    %edx,%eax
  801d76:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d7b:	a1 50 40 80 00       	mov    0x804050,%eax
  801d80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d83:	c1 e2 04             	shl    $0x4,%edx
  801d86:	01 d0                	add    %edx,%eax
  801d88:	a3 48 41 80 00       	mov    %eax,0x804148
  801d8d:	a1 50 40 80 00       	mov    0x804050,%eax
  801d92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d95:	c1 e2 04             	shl    $0x4,%edx
  801d98:	01 d0                	add    %edx,%eax
  801d9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801da1:	a1 54 41 80 00       	mov    0x804154,%eax
  801da6:	40                   	inc    %eax
  801da7:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801dac:	ff 45 f4             	incl   -0xc(%ebp)
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801db5:	0f 82 56 ff ff ff    	jb     801d11 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801dbb:	90                   	nop
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	8b 00                	mov    (%eax),%eax
  801dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801dcc:	eb 19                	jmp    801de7 <find_block+0x29>
	{
		if(va==point->sva)
  801dce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dd1:	8b 40 08             	mov    0x8(%eax),%eax
  801dd4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801dd7:	75 05                	jne    801dde <find_block+0x20>
		   return point;
  801dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ddc:	eb 36                	jmp    801e14 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801dde:	8b 45 08             	mov    0x8(%ebp),%eax
  801de1:	8b 40 08             	mov    0x8(%eax),%eax
  801de4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801de7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801deb:	74 07                	je     801df4 <find_block+0x36>
  801ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801df0:	8b 00                	mov    (%eax),%eax
  801df2:	eb 05                	jmp    801df9 <find_block+0x3b>
  801df4:	b8 00 00 00 00       	mov    $0x0,%eax
  801df9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dfc:	89 42 08             	mov    %eax,0x8(%edx)
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	8b 40 08             	mov    0x8(%eax),%eax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	75 c5                	jne    801dce <find_block+0x10>
  801e09:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e0d:	75 bf                	jne    801dce <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
  801e19:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801e1c:	a1 40 40 80 00       	mov    0x804040,%eax
  801e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801e24:	a1 44 40 80 00       	mov    0x804044,%eax
  801e29:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e32:	74 24                	je     801e58 <insert_sorted_allocList+0x42>
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	8b 50 08             	mov    0x8(%eax),%edx
  801e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3d:	8b 40 08             	mov    0x8(%eax),%eax
  801e40:	39 c2                	cmp    %eax,%edx
  801e42:	76 14                	jbe    801e58 <insert_sorted_allocList+0x42>
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	8b 50 08             	mov    0x8(%eax),%edx
  801e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4d:	8b 40 08             	mov    0x8(%eax),%eax
  801e50:	39 c2                	cmp    %eax,%edx
  801e52:	0f 82 60 01 00 00    	jb     801fb8 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5c:	75 65                	jne    801ec3 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e62:	75 14                	jne    801e78 <insert_sorted_allocList+0x62>
  801e64:	83 ec 04             	sub    $0x4,%esp
  801e67:	68 fc 3c 80 00       	push   $0x803cfc
  801e6c:	6a 6b                	push   $0x6b
  801e6e:	68 1f 3d 80 00       	push   $0x803d1f
  801e73:	e8 d6 13 00 00       	call   80324e <_panic>
  801e78:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	89 10                	mov    %edx,(%eax)
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	8b 00                	mov    (%eax),%eax
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	74 0d                	je     801e99 <insert_sorted_allocList+0x83>
  801e8c:	a1 40 40 80 00       	mov    0x804040,%eax
  801e91:	8b 55 08             	mov    0x8(%ebp),%edx
  801e94:	89 50 04             	mov    %edx,0x4(%eax)
  801e97:	eb 08                	jmp    801ea1 <insert_sorted_allocList+0x8b>
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	a3 44 40 80 00       	mov    %eax,0x804044
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	a3 40 40 80 00       	mov    %eax,0x804040
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801eb8:	40                   	inc    %eax
  801eb9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ebe:	e9 dc 01 00 00       	jmp    80209f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	8b 50 08             	mov    0x8(%eax),%edx
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	8b 40 08             	mov    0x8(%eax),%eax
  801ecf:	39 c2                	cmp    %eax,%edx
  801ed1:	77 6c                	ja     801f3f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801ed3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed7:	74 06                	je     801edf <insert_sorted_allocList+0xc9>
  801ed9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801edd:	75 14                	jne    801ef3 <insert_sorted_allocList+0xdd>
  801edf:	83 ec 04             	sub    $0x4,%esp
  801ee2:	68 38 3d 80 00       	push   $0x803d38
  801ee7:	6a 6f                	push   $0x6f
  801ee9:	68 1f 3d 80 00       	push   $0x803d1f
  801eee:	e8 5b 13 00 00       	call   80324e <_panic>
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	8b 50 04             	mov    0x4(%eax),%edx
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	89 50 04             	mov    %edx,0x4(%eax)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f05:	89 10                	mov    %edx,(%eax)
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	8b 40 04             	mov    0x4(%eax),%eax
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	74 0d                	je     801f1e <insert_sorted_allocList+0x108>
  801f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f14:	8b 40 04             	mov    0x4(%eax),%eax
  801f17:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1a:	89 10                	mov    %edx,(%eax)
  801f1c:	eb 08                	jmp    801f26 <insert_sorted_allocList+0x110>
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	a3 40 40 80 00       	mov    %eax,0x804040
  801f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f29:	8b 55 08             	mov    0x8(%ebp),%edx
  801f2c:	89 50 04             	mov    %edx,0x4(%eax)
  801f2f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f34:	40                   	inc    %eax
  801f35:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f3a:	e9 60 01 00 00       	jmp    80209f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	8b 50 08             	mov    0x8(%eax),%edx
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	8b 40 08             	mov    0x8(%eax),%eax
  801f4b:	39 c2                	cmp    %eax,%edx
  801f4d:	0f 82 4c 01 00 00    	jb     80209f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f57:	75 14                	jne    801f6d <insert_sorted_allocList+0x157>
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	68 70 3d 80 00       	push   $0x803d70
  801f61:	6a 73                	push   $0x73
  801f63:	68 1f 3d 80 00       	push   $0x803d1f
  801f68:	e8 e1 12 00 00       	call   80324e <_panic>
  801f6d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	89 50 04             	mov    %edx,0x4(%eax)
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8b 40 04             	mov    0x4(%eax),%eax
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	74 0c                	je     801f8f <insert_sorted_allocList+0x179>
  801f83:	a1 44 40 80 00       	mov    0x804044,%eax
  801f88:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8b:	89 10                	mov    %edx,(%eax)
  801f8d:	eb 08                	jmp    801f97 <insert_sorted_allocList+0x181>
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	a3 40 40 80 00       	mov    %eax,0x804040
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	a3 44 40 80 00       	mov    %eax,0x804044
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fa8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fad:	40                   	inc    %eax
  801fae:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fb3:	e9 e7 00 00 00       	jmp    80209f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801fbe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801fc5:	a1 40 40 80 00       	mov    0x804040,%eax
  801fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fcd:	e9 9d 00 00 00       	jmp    80206f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 00                	mov    (%eax),%eax
  801fd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801fda:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdd:	8b 50 08             	mov    0x8(%eax),%edx
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	39 c2                	cmp    %eax,%edx
  801fe8:	76 7d                	jbe    802067 <insert_sorted_allocList+0x251>
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 50 08             	mov    0x8(%eax),%edx
  801ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ff3:	8b 40 08             	mov    0x8(%eax),%eax
  801ff6:	39 c2                	cmp    %eax,%edx
  801ff8:	73 6d                	jae    802067 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffe:	74 06                	je     802006 <insert_sorted_allocList+0x1f0>
  802000:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802004:	75 14                	jne    80201a <insert_sorted_allocList+0x204>
  802006:	83 ec 04             	sub    $0x4,%esp
  802009:	68 94 3d 80 00       	push   $0x803d94
  80200e:	6a 7f                	push   $0x7f
  802010:	68 1f 3d 80 00       	push   $0x803d1f
  802015:	e8 34 12 00 00       	call   80324e <_panic>
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 10                	mov    (%eax),%edx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	89 10                	mov    %edx,(%eax)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8b 00                	mov    (%eax),%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	74 0b                	je     802038 <insert_sorted_allocList+0x222>
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 00                	mov    (%eax),%eax
  802032:	8b 55 08             	mov    0x8(%ebp),%edx
  802035:	89 50 04             	mov    %edx,0x4(%eax)
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 55 08             	mov    0x8(%ebp),%edx
  80203e:	89 10                	mov    %edx,(%eax)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	89 50 04             	mov    %edx,0x4(%eax)
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	8b 00                	mov    (%eax),%eax
  80204e:	85 c0                	test   %eax,%eax
  802050:	75 08                	jne    80205a <insert_sorted_allocList+0x244>
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	a3 44 40 80 00       	mov    %eax,0x804044
  80205a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80205f:	40                   	inc    %eax
  802060:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802065:	eb 39                	jmp    8020a0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802067:	a1 48 40 80 00       	mov    0x804048,%eax
  80206c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802073:	74 07                	je     80207c <insert_sorted_allocList+0x266>
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	8b 00                	mov    (%eax),%eax
  80207a:	eb 05                	jmp    802081 <insert_sorted_allocList+0x26b>
  80207c:	b8 00 00 00 00       	mov    $0x0,%eax
  802081:	a3 48 40 80 00       	mov    %eax,0x804048
  802086:	a1 48 40 80 00       	mov    0x804048,%eax
  80208b:	85 c0                	test   %eax,%eax
  80208d:	0f 85 3f ff ff ff    	jne    801fd2 <insert_sorted_allocList+0x1bc>
  802093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802097:	0f 85 35 ff ff ff    	jne    801fd2 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80209d:	eb 01                	jmp    8020a0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80209f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8020a0:	90                   	nop
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
  8020a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8020a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8020ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b1:	e9 85 01 00 00       	jmp    80223b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020bf:	0f 82 6e 01 00 00    	jb     802233 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ce:	0f 85 8a 00 00 00    	jne    80215e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8020d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d8:	75 17                	jne    8020f1 <alloc_block_FF+0x4e>
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	68 c8 3d 80 00       	push   $0x803dc8
  8020e2:	68 93 00 00 00       	push   $0x93
  8020e7:	68 1f 3d 80 00       	push   $0x803d1f
  8020ec:	e8 5d 11 00 00       	call   80324e <_panic>
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 10                	je     80210a <alloc_block_FF+0x67>
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802102:	8b 52 04             	mov    0x4(%edx),%edx
  802105:	89 50 04             	mov    %edx,0x4(%eax)
  802108:	eb 0b                	jmp    802115 <alloc_block_FF+0x72>
  80210a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210d:	8b 40 04             	mov    0x4(%eax),%eax
  802110:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 40 04             	mov    0x4(%eax),%eax
  80211b:	85 c0                	test   %eax,%eax
  80211d:	74 0f                	je     80212e <alloc_block_FF+0x8b>
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 40 04             	mov    0x4(%eax),%eax
  802125:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802128:	8b 12                	mov    (%edx),%edx
  80212a:	89 10                	mov    %edx,(%eax)
  80212c:	eb 0a                	jmp    802138 <alloc_block_FF+0x95>
  80212e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802131:	8b 00                	mov    (%eax),%eax
  802133:	a3 38 41 80 00       	mov    %eax,0x804138
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214b:	a1 44 41 80 00       	mov    0x804144,%eax
  802150:	48                   	dec    %eax
  802151:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802159:	e9 10 01 00 00       	jmp    80226e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802161:	8b 40 0c             	mov    0xc(%eax),%eax
  802164:	3b 45 08             	cmp    0x8(%ebp),%eax
  802167:	0f 86 c6 00 00 00    	jbe    802233 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80216d:	a1 48 41 80 00       	mov    0x804148,%eax
  802172:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 50 08             	mov    0x8(%eax),%edx
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802181:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802184:	8b 55 08             	mov    0x8(%ebp),%edx
  802187:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80218a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218e:	75 17                	jne    8021a7 <alloc_block_FF+0x104>
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	68 c8 3d 80 00       	push   $0x803dc8
  802198:	68 9b 00 00 00       	push   $0x9b
  80219d:	68 1f 3d 80 00       	push   $0x803d1f
  8021a2:	e8 a7 10 00 00       	call   80324e <_panic>
  8021a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021aa:	8b 00                	mov    (%eax),%eax
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	74 10                	je     8021c0 <alloc_block_FF+0x11d>
  8021b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b3:	8b 00                	mov    (%eax),%eax
  8021b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b8:	8b 52 04             	mov    0x4(%edx),%edx
  8021bb:	89 50 04             	mov    %edx,0x4(%eax)
  8021be:	eb 0b                	jmp    8021cb <alloc_block_FF+0x128>
  8021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c3:	8b 40 04             	mov    0x4(%eax),%eax
  8021c6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	8b 40 04             	mov    0x4(%eax),%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 0f                	je     8021e4 <alloc_block_FF+0x141>
  8021d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d8:	8b 40 04             	mov    0x4(%eax),%eax
  8021db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021de:	8b 12                	mov    (%edx),%edx
  8021e0:	89 10                	mov    %edx,(%eax)
  8021e2:	eb 0a                	jmp    8021ee <alloc_block_FF+0x14b>
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	8b 00                	mov    (%eax),%eax
  8021e9:	a3 48 41 80 00       	mov    %eax,0x804148
  8021ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802201:	a1 54 41 80 00       	mov    0x804154,%eax
  802206:	48                   	dec    %eax
  802207:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 50 08             	mov    0x8(%eax),%edx
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	01 c2                	add    %eax,%edx
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 40 0c             	mov    0xc(%eax),%eax
  802223:	2b 45 08             	sub    0x8(%ebp),%eax
  802226:	89 c2                	mov    %eax,%edx
  802228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80222e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802231:	eb 3b                	jmp    80226e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802233:	a1 40 41 80 00       	mov    0x804140,%eax
  802238:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223f:	74 07                	je     802248 <alloc_block_FF+0x1a5>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	eb 05                	jmp    80224d <alloc_block_FF+0x1aa>
  802248:	b8 00 00 00 00       	mov    $0x0,%eax
  80224d:	a3 40 41 80 00       	mov    %eax,0x804140
  802252:	a1 40 41 80 00       	mov    0x804140,%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	0f 85 57 fe ff ff    	jne    8020b6 <alloc_block_FF+0x13>
  80225f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802263:	0f 85 4d fe ff ff    	jne    8020b6 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802276:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80227d:	a1 38 41 80 00       	mov    0x804138,%eax
  802282:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802285:	e9 df 00 00 00       	jmp    802369 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 40 0c             	mov    0xc(%eax),%eax
  802290:	3b 45 08             	cmp    0x8(%ebp),%eax
  802293:	0f 82 c8 00 00 00    	jb     802361 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 40 0c             	mov    0xc(%eax),%eax
  80229f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022a2:	0f 85 8a 00 00 00    	jne    802332 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8022a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ac:	75 17                	jne    8022c5 <alloc_block_BF+0x55>
  8022ae:	83 ec 04             	sub    $0x4,%esp
  8022b1:	68 c8 3d 80 00       	push   $0x803dc8
  8022b6:	68 b7 00 00 00       	push   $0xb7
  8022bb:	68 1f 3d 80 00       	push   $0x803d1f
  8022c0:	e8 89 0f 00 00       	call   80324e <_panic>
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	8b 00                	mov    (%eax),%eax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	74 10                	je     8022de <alloc_block_BF+0x6e>
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 00                	mov    (%eax),%eax
  8022d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d6:	8b 52 04             	mov    0x4(%edx),%edx
  8022d9:	89 50 04             	mov    %edx,0x4(%eax)
  8022dc:	eb 0b                	jmp    8022e9 <alloc_block_BF+0x79>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 40 04             	mov    0x4(%eax),%eax
  8022e4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 0f                	je     802302 <alloc_block_BF+0x92>
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 40 04             	mov    0x4(%eax),%eax
  8022f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fc:	8b 12                	mov    (%edx),%edx
  8022fe:	89 10                	mov    %edx,(%eax)
  802300:	eb 0a                	jmp    80230c <alloc_block_BF+0x9c>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	a3 38 41 80 00       	mov    %eax,0x804138
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80231f:	a1 44 41 80 00       	mov    0x804144,%eax
  802324:	48                   	dec    %eax
  802325:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	e9 4d 01 00 00       	jmp    80247f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 40 0c             	mov    0xc(%eax),%eax
  802338:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233b:	76 24                	jbe    802361 <alloc_block_BF+0xf1>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 40 0c             	mov    0xc(%eax),%eax
  802343:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802346:	73 19                	jae    802361 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802348:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 40 0c             	mov    0xc(%eax),%eax
  802355:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 08             	mov    0x8(%eax),%eax
  80235e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802361:	a1 40 41 80 00       	mov    0x804140,%eax
  802366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236d:	74 07                	je     802376 <alloc_block_BF+0x106>
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 00                	mov    (%eax),%eax
  802374:	eb 05                	jmp    80237b <alloc_block_BF+0x10b>
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
  80237b:	a3 40 41 80 00       	mov    %eax,0x804140
  802380:	a1 40 41 80 00       	mov    0x804140,%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	0f 85 fd fe ff ff    	jne    80228a <alloc_block_BF+0x1a>
  80238d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802391:	0f 85 f3 fe ff ff    	jne    80228a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802397:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80239b:	0f 84 d9 00 00 00    	je     80247a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023a1:	a1 48 41 80 00       	mov    0x804148,%eax
  8023a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8023a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023af:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8023b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b8:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8023bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8023bf:	75 17                	jne    8023d8 <alloc_block_BF+0x168>
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	68 c8 3d 80 00       	push   $0x803dc8
  8023c9:	68 c7 00 00 00       	push   $0xc7
  8023ce:	68 1f 3d 80 00       	push   $0x803d1f
  8023d3:	e8 76 0e 00 00       	call   80324e <_panic>
  8023d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	74 10                	je     8023f1 <alloc_block_BF+0x181>
  8023e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023e9:	8b 52 04             	mov    0x4(%edx),%edx
  8023ec:	89 50 04             	mov    %edx,0x4(%eax)
  8023ef:	eb 0b                	jmp    8023fc <alloc_block_BF+0x18c>
  8023f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	74 0f                	je     802415 <alloc_block_BF+0x1a5>
  802406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802409:	8b 40 04             	mov    0x4(%eax),%eax
  80240c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80240f:	8b 12                	mov    (%edx),%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	eb 0a                	jmp    80241f <alloc_block_BF+0x1af>
  802415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	a3 48 41 80 00       	mov    %eax,0x804148
  80241f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802432:	a1 54 41 80 00       	mov    0x804154,%eax
  802437:	48                   	dec    %eax
  802438:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80243d:	83 ec 08             	sub    $0x8,%esp
  802440:	ff 75 ec             	pushl  -0x14(%ebp)
  802443:	68 38 41 80 00       	push   $0x804138
  802448:	e8 71 f9 ff ff       	call   801dbe <find_block>
  80244d:	83 c4 10             	add    $0x10,%esp
  802450:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802456:	8b 50 08             	mov    0x8(%eax),%edx
  802459:	8b 45 08             	mov    0x8(%ebp),%eax
  80245c:	01 c2                	add    %eax,%edx
  80245e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802461:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802467:	8b 40 0c             	mov    0xc(%eax),%eax
  80246a:	2b 45 08             	sub    0x8(%ebp),%eax
  80246d:	89 c2                	mov    %eax,%edx
  80246f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802472:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802478:	eb 05                	jmp    80247f <alloc_block_BF+0x20f>
	}
	return NULL;
  80247a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247f:	c9                   	leave  
  802480:	c3                   	ret    

00802481 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802487:	a1 28 40 80 00       	mov    0x804028,%eax
  80248c:	85 c0                	test   %eax,%eax
  80248e:	0f 85 de 01 00 00    	jne    802672 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802494:	a1 38 41 80 00       	mov    0x804138,%eax
  802499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249c:	e9 9e 01 00 00       	jmp    80263f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024aa:	0f 82 87 01 00 00    	jb     802637 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b9:	0f 85 95 00 00 00    	jne    802554 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8024bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c3:	75 17                	jne    8024dc <alloc_block_NF+0x5b>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 c8 3d 80 00       	push   $0x803dc8
  8024cd:	68 e0 00 00 00       	push   $0xe0
  8024d2:	68 1f 3d 80 00       	push   $0x803d1f
  8024d7:	e8 72 0d 00 00       	call   80324e <_panic>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 10                	je     8024f5 <alloc_block_NF+0x74>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ed:	8b 52 04             	mov    0x4(%edx),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	eb 0b                	jmp    802500 <alloc_block_NF+0x7f>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0f                	je     802519 <alloc_block_NF+0x98>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	8b 12                	mov    (%edx),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	eb 0a                	jmp    802523 <alloc_block_NF+0xa2>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	a3 38 41 80 00       	mov    %eax,0x804138
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802536:	a1 44 41 80 00       	mov    0x804144,%eax
  80253b:	48                   	dec    %eax
  80253c:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 08             	mov    0x8(%eax),%eax
  802547:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	e9 f8 04 00 00       	jmp    802a4c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255d:	0f 86 d4 00 00 00    	jbe    802637 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802563:	a1 48 41 80 00       	mov    0x804148,%eax
  802568:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 50 08             	mov    0x8(%eax),%edx
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	8b 55 08             	mov    0x8(%ebp),%edx
  80257d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802580:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802584:	75 17                	jne    80259d <alloc_block_NF+0x11c>
  802586:	83 ec 04             	sub    $0x4,%esp
  802589:	68 c8 3d 80 00       	push   $0x803dc8
  80258e:	68 e9 00 00 00       	push   $0xe9
  802593:	68 1f 3d 80 00       	push   $0x803d1f
  802598:	e8 b1 0c 00 00       	call   80324e <_panic>
  80259d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 10                	je     8025b6 <alloc_block_NF+0x135>
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025ae:	8b 52 04             	mov    0x4(%edx),%edx
  8025b1:	89 50 04             	mov    %edx,0x4(%eax)
  8025b4:	eb 0b                	jmp    8025c1 <alloc_block_NF+0x140>
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	74 0f                	je     8025da <alloc_block_NF+0x159>
  8025cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ce:	8b 40 04             	mov    0x4(%eax),%eax
  8025d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d4:	8b 12                	mov    (%edx),%edx
  8025d6:	89 10                	mov    %edx,(%eax)
  8025d8:	eb 0a                	jmp    8025e4 <alloc_block_NF+0x163>
  8025da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	a3 48 41 80 00       	mov    %eax,0x804148
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8025fc:	48                   	dec    %eax
  8025fd:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	8b 40 08             	mov    0x8(%eax),%eax
  802608:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 50 08             	mov    0x8(%eax),%edx
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	01 c2                	add    %eax,%edx
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	2b 45 08             	sub    0x8(%ebp),%eax
  802627:	89 c2                	mov    %eax,%edx
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	e9 15 04 00 00       	jmp    802a4c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802637:	a1 40 41 80 00       	mov    0x804140,%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	74 07                	je     80264c <alloc_block_NF+0x1cb>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	eb 05                	jmp    802651 <alloc_block_NF+0x1d0>
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
  802651:	a3 40 41 80 00       	mov    %eax,0x804140
  802656:	a1 40 41 80 00       	mov    0x804140,%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	0f 85 3e fe ff ff    	jne    8024a1 <alloc_block_NF+0x20>
  802663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802667:	0f 85 34 fe ff ff    	jne    8024a1 <alloc_block_NF+0x20>
  80266d:	e9 d5 03 00 00       	jmp    802a47 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802672:	a1 38 41 80 00       	mov    0x804138,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	e9 b1 01 00 00       	jmp    802830 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 50 08             	mov    0x8(%eax),%edx
  802685:	a1 28 40 80 00       	mov    0x804028,%eax
  80268a:	39 c2                	cmp    %eax,%edx
  80268c:	0f 82 96 01 00 00    	jb     802828 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 40 0c             	mov    0xc(%eax),%eax
  802698:	3b 45 08             	cmp    0x8(%ebp),%eax
  80269b:	0f 82 87 01 00 00    	jb     802828 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026aa:	0f 85 95 00 00 00    	jne    802745 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8026b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b4:	75 17                	jne    8026cd <alloc_block_NF+0x24c>
  8026b6:	83 ec 04             	sub    $0x4,%esp
  8026b9:	68 c8 3d 80 00       	push   $0x803dc8
  8026be:	68 fc 00 00 00       	push   $0xfc
  8026c3:	68 1f 3d 80 00       	push   $0x803d1f
  8026c8:	e8 81 0b 00 00       	call   80324e <_panic>
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	8b 00                	mov    (%eax),%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	74 10                	je     8026e6 <alloc_block_NF+0x265>
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 00                	mov    (%eax),%eax
  8026db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026de:	8b 52 04             	mov    0x4(%edx),%edx
  8026e1:	89 50 04             	mov    %edx,0x4(%eax)
  8026e4:	eb 0b                	jmp    8026f1 <alloc_block_NF+0x270>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 04             	mov    0x4(%eax),%eax
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	74 0f                	je     80270a <alloc_block_NF+0x289>
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 40 04             	mov    0x4(%eax),%eax
  802701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802704:	8b 12                	mov    (%edx),%edx
  802706:	89 10                	mov    %edx,(%eax)
  802708:	eb 0a                	jmp    802714 <alloc_block_NF+0x293>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 00                	mov    (%eax),%eax
  80270f:	a3 38 41 80 00       	mov    %eax,0x804138
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802727:	a1 44 41 80 00       	mov    0x804144,%eax
  80272c:	48                   	dec    %eax
  80272d:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 08             	mov    0x8(%eax),%eax
  802738:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	e9 07 03 00 00       	jmp    802a4c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 0c             	mov    0xc(%eax),%eax
  80274b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274e:	0f 86 d4 00 00 00    	jbe    802828 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802754:	a1 48 41 80 00       	mov    0x804148,%eax
  802759:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 50 08             	mov    0x8(%eax),%edx
  802762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802765:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276b:	8b 55 08             	mov    0x8(%ebp),%edx
  80276e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802771:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802775:	75 17                	jne    80278e <alloc_block_NF+0x30d>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 c8 3d 80 00       	push   $0x803dc8
  80277f:	68 04 01 00 00       	push   $0x104
  802784:	68 1f 3d 80 00       	push   $0x803d1f
  802789:	e8 c0 0a 00 00       	call   80324e <_panic>
  80278e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 10                	je     8027a7 <alloc_block_NF+0x326>
  802797:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80279f:	8b 52 04             	mov    0x4(%edx),%edx
  8027a2:	89 50 04             	mov    %edx,0x4(%eax)
  8027a5:	eb 0b                	jmp    8027b2 <alloc_block_NF+0x331>
  8027a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	74 0f                	je     8027cb <alloc_block_NF+0x34a>
  8027bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027c5:	8b 12                	mov    (%edx),%edx
  8027c7:	89 10                	mov    %edx,(%eax)
  8027c9:	eb 0a                	jmp    8027d5 <alloc_block_NF+0x354>
  8027cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	a3 48 41 80 00       	mov    %eax,0x804148
  8027d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e8:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ed:	48                   	dec    %eax
  8027ee:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8027f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f6:	8b 40 08             	mov    0x8(%eax),%eax
  8027f9:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 50 08             	mov    0x8(%eax),%edx
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	01 c2                	add    %eax,%edx
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 0c             	mov    0xc(%eax),%eax
  802815:	2b 45 08             	sub    0x8(%ebp),%eax
  802818:	89 c2                	mov    %eax,%edx
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802823:	e9 24 02 00 00       	jmp    802a4c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802828:	a1 40 41 80 00       	mov    0x804140,%eax
  80282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802834:	74 07                	je     80283d <alloc_block_NF+0x3bc>
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	eb 05                	jmp    802842 <alloc_block_NF+0x3c1>
  80283d:	b8 00 00 00 00       	mov    $0x0,%eax
  802842:	a3 40 41 80 00       	mov    %eax,0x804140
  802847:	a1 40 41 80 00       	mov    0x804140,%eax
  80284c:	85 c0                	test   %eax,%eax
  80284e:	0f 85 2b fe ff ff    	jne    80267f <alloc_block_NF+0x1fe>
  802854:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802858:	0f 85 21 fe ff ff    	jne    80267f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80285e:	a1 38 41 80 00       	mov    0x804138,%eax
  802863:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802866:	e9 ae 01 00 00       	jmp    802a19 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 50 08             	mov    0x8(%eax),%edx
  802871:	a1 28 40 80 00       	mov    0x804028,%eax
  802876:	39 c2                	cmp    %eax,%edx
  802878:	0f 83 93 01 00 00    	jae    802a11 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 40 0c             	mov    0xc(%eax),%eax
  802884:	3b 45 08             	cmp    0x8(%ebp),%eax
  802887:	0f 82 84 01 00 00    	jb     802a11 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 0c             	mov    0xc(%eax),%eax
  802893:	3b 45 08             	cmp    0x8(%ebp),%eax
  802896:	0f 85 95 00 00 00    	jne    802931 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80289c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a0:	75 17                	jne    8028b9 <alloc_block_NF+0x438>
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	68 c8 3d 80 00       	push   $0x803dc8
  8028aa:	68 14 01 00 00       	push   $0x114
  8028af:	68 1f 3d 80 00       	push   $0x803d1f
  8028b4:	e8 95 09 00 00       	call   80324e <_panic>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 10                	je     8028d2 <alloc_block_NF+0x451>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 00                	mov    (%eax),%eax
  8028c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ca:	8b 52 04             	mov    0x4(%edx),%edx
  8028cd:	89 50 04             	mov    %edx,0x4(%eax)
  8028d0:	eb 0b                	jmp    8028dd <alloc_block_NF+0x45c>
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	8b 40 04             	mov    0x4(%eax),%eax
  8028d8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 04             	mov    0x4(%eax),%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	74 0f                	je     8028f6 <alloc_block_NF+0x475>
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 04             	mov    0x4(%eax),%eax
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	8b 12                	mov    (%edx),%edx
  8028f2:	89 10                	mov    %edx,(%eax)
  8028f4:	eb 0a                	jmp    802900 <alloc_block_NF+0x47f>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802913:	a1 44 41 80 00       	mov    0x804144,%eax
  802918:	48                   	dec    %eax
  802919:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 08             	mov    0x8(%eax),%eax
  802924:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	e9 1b 01 00 00       	jmp    802a4c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 0c             	mov    0xc(%eax),%eax
  802937:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293a:	0f 86 d1 00 00 00    	jbe    802a11 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802940:	a1 48 41 80 00       	mov    0x804148,%eax
  802945:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 50 08             	mov    0x8(%eax),%edx
  80294e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802951:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	8b 55 08             	mov    0x8(%ebp),%edx
  80295a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80295d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802961:	75 17                	jne    80297a <alloc_block_NF+0x4f9>
  802963:	83 ec 04             	sub    $0x4,%esp
  802966:	68 c8 3d 80 00       	push   $0x803dc8
  80296b:	68 1c 01 00 00       	push   $0x11c
  802970:	68 1f 3d 80 00       	push   $0x803d1f
  802975:	e8 d4 08 00 00       	call   80324e <_panic>
  80297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 10                	je     802993 <alloc_block_NF+0x512>
  802983:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80298b:	8b 52 04             	mov    0x4(%edx),%edx
  80298e:	89 50 04             	mov    %edx,0x4(%eax)
  802991:	eb 0b                	jmp    80299e <alloc_block_NF+0x51d>
  802993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802996:	8b 40 04             	mov    0x4(%eax),%eax
  802999:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	74 0f                	je     8029b7 <alloc_block_NF+0x536>
  8029a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029b1:	8b 12                	mov    (%edx),%edx
  8029b3:	89 10                	mov    %edx,(%eax)
  8029b5:	eb 0a                	jmp    8029c1 <alloc_block_NF+0x540>
  8029b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	a3 48 41 80 00       	mov    %eax,0x804148
  8029c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d4:	a1 54 41 80 00       	mov    0x804154,%eax
  8029d9:	48                   	dec    %eax
  8029da:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e2:	8b 40 08             	mov    0x8(%eax),%eax
  8029e5:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 50 08             	mov    0x8(%eax),%edx
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	01 c2                	add    %eax,%edx
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802a01:	2b 45 08             	sub    0x8(%ebp),%eax
  802a04:	89 c2                	mov    %eax,%edx
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0f:	eb 3b                	jmp    802a4c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a11:	a1 40 41 80 00       	mov    0x804140,%eax
  802a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1d:	74 07                	je     802a26 <alloc_block_NF+0x5a5>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	eb 05                	jmp    802a2b <alloc_block_NF+0x5aa>
  802a26:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2b:	a3 40 41 80 00       	mov    %eax,0x804140
  802a30:	a1 40 41 80 00       	mov    0x804140,%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	0f 85 2e fe ff ff    	jne    80286b <alloc_block_NF+0x3ea>
  802a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a41:	0f 85 24 fe ff ff    	jne    80286b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a4c:	c9                   	leave  
  802a4d:	c3                   	ret    

00802a4e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a4e:	55                   	push   %ebp
  802a4f:	89 e5                	mov    %esp,%ebp
  802a51:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a54:	a1 38 41 80 00       	mov    0x804138,%eax
  802a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a5c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a61:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a64:	a1 38 41 80 00       	mov    0x804138,%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 14                	je     802a81 <insert_sorted_with_merge_freeList+0x33>
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	0f 87 9b 01 00 00    	ja     802c1c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a85:	75 17                	jne    802a9e <insert_sorted_with_merge_freeList+0x50>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 fc 3c 80 00       	push   $0x803cfc
  802a8f:	68 38 01 00 00       	push   $0x138
  802a94:	68 1f 3d 80 00       	push   $0x803d1f
  802a99:	e8 b0 07 00 00       	call   80324e <_panic>
  802a9e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	89 10                	mov    %edx,(%eax)
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	8b 00                	mov    (%eax),%eax
  802aae:	85 c0                	test   %eax,%eax
  802ab0:	74 0d                	je     802abf <insert_sorted_with_merge_freeList+0x71>
  802ab2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aba:	89 50 04             	mov    %edx,0x4(%eax)
  802abd:	eb 08                	jmp    802ac7 <insert_sorted_with_merge_freeList+0x79>
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	a3 38 41 80 00       	mov    %eax,0x804138
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad9:	a1 44 41 80 00       	mov    0x804144,%eax
  802ade:	40                   	inc    %eax
  802adf:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ae8:	0f 84 a8 06 00 00    	je     803196 <insert_sorted_with_merge_freeList+0x748>
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	8b 50 08             	mov    0x8(%eax),%edx
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 40 0c             	mov    0xc(%eax),%eax
  802afa:	01 c2                	add    %eax,%edx
  802afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aff:	8b 40 08             	mov    0x8(%eax),%eax
  802b02:	39 c2                	cmp    %eax,%edx
  802b04:	0f 85 8c 06 00 00    	jne    803196 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b13:	8b 40 0c             	mov    0xc(%eax),%eax
  802b16:	01 c2                	add    %eax,%edx
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802b1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b22:	75 17                	jne    802b3b <insert_sorted_with_merge_freeList+0xed>
  802b24:	83 ec 04             	sub    $0x4,%esp
  802b27:	68 c8 3d 80 00       	push   $0x803dc8
  802b2c:	68 3c 01 00 00       	push   $0x13c
  802b31:	68 1f 3d 80 00       	push   $0x803d1f
  802b36:	e8 13 07 00 00       	call   80324e <_panic>
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	74 10                	je     802b54 <insert_sorted_with_merge_freeList+0x106>
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4c:	8b 52 04             	mov    0x4(%edx),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	eb 0b                	jmp    802b5f <insert_sorted_with_merge_freeList+0x111>
  802b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b57:	8b 40 04             	mov    0x4(%eax),%eax
  802b5a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 0f                	je     802b78 <insert_sorted_with_merge_freeList+0x12a>
  802b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b72:	8b 12                	mov    (%edx),%edx
  802b74:	89 10                	mov    %edx,(%eax)
  802b76:	eb 0a                	jmp    802b82 <insert_sorted_with_merge_freeList+0x134>
  802b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b95:	a1 44 41 80 00       	mov    0x804144,%eax
  802b9a:	48                   	dec    %eax
  802b9b:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802bb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb8:	75 17                	jne    802bd1 <insert_sorted_with_merge_freeList+0x183>
  802bba:	83 ec 04             	sub    $0x4,%esp
  802bbd:	68 fc 3c 80 00       	push   $0x803cfc
  802bc2:	68 3f 01 00 00       	push   $0x13f
  802bc7:	68 1f 3d 80 00       	push   $0x803d1f
  802bcc:	e8 7d 06 00 00       	call   80324e <_panic>
  802bd1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	89 10                	mov    %edx,(%eax)
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 0d                	je     802bf2 <insert_sorted_with_merge_freeList+0x1a4>
  802be5:	a1 48 41 80 00       	mov    0x804148,%eax
  802bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bed:	89 50 04             	mov    %edx,0x4(%eax)
  802bf0:	eb 08                	jmp    802bfa <insert_sorted_with_merge_freeList+0x1ac>
  802bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfd:	a3 48 41 80 00       	mov    %eax,0x804148
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c11:	40                   	inc    %eax
  802c12:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c17:	e9 7a 05 00 00       	jmp    803196 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	8b 50 08             	mov    0x8(%eax),%edx
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	8b 40 08             	mov    0x8(%eax),%eax
  802c28:	39 c2                	cmp    %eax,%edx
  802c2a:	0f 82 14 01 00 00    	jb     802d44 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	01 c2                	add    %eax,%edx
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	8b 40 08             	mov    0x8(%eax),%eax
  802c44:	39 c2                	cmp    %eax,%edx
  802c46:	0f 85 90 00 00 00    	jne    802cdc <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 40 0c             	mov    0xc(%eax),%eax
  802c58:	01 c2                	add    %eax,%edx
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c78:	75 17                	jne    802c91 <insert_sorted_with_merge_freeList+0x243>
  802c7a:	83 ec 04             	sub    $0x4,%esp
  802c7d:	68 fc 3c 80 00       	push   $0x803cfc
  802c82:	68 49 01 00 00       	push   $0x149
  802c87:	68 1f 3d 80 00       	push   $0x803d1f
  802c8c:	e8 bd 05 00 00       	call   80324e <_panic>
  802c91:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	89 10                	mov    %edx,(%eax)
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 0d                	je     802cb2 <insert_sorted_with_merge_freeList+0x264>
  802ca5:	a1 48 41 80 00       	mov    0x804148,%eax
  802caa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cad:	89 50 04             	mov    %edx,0x4(%eax)
  802cb0:	eb 08                	jmp    802cba <insert_sorted_with_merge_freeList+0x26c>
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	a3 48 41 80 00       	mov    %eax,0x804148
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccc:	a1 54 41 80 00       	mov    0x804154,%eax
  802cd1:	40                   	inc    %eax
  802cd2:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cd7:	e9 bb 04 00 00       	jmp    803197 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802cdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce0:	75 17                	jne    802cf9 <insert_sorted_with_merge_freeList+0x2ab>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 70 3d 80 00       	push   $0x803d70
  802cea:	68 4c 01 00 00       	push   $0x14c
  802cef:	68 1f 3d 80 00       	push   $0x803d1f
  802cf4:	e8 55 05 00 00       	call   80324e <_panic>
  802cf9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	74 0c                	je     802d1b <insert_sorted_with_merge_freeList+0x2cd>
  802d0f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d14:	8b 55 08             	mov    0x8(%ebp),%edx
  802d17:	89 10                	mov    %edx,(%eax)
  802d19:	eb 08                	jmp    802d23 <insert_sorted_with_merge_freeList+0x2d5>
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 38 41 80 00       	mov    %eax,0x804138
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d34:	a1 44 41 80 00       	mov    0x804144,%eax
  802d39:	40                   	inc    %eax
  802d3a:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d3f:	e9 53 04 00 00       	jmp    803197 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802d44:	a1 38 41 80 00       	mov    0x804138,%eax
  802d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4c:	e9 15 04 00 00       	jmp    803166 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	8b 50 08             	mov    0x8(%eax),%edx
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 08             	mov    0x8(%eax),%eax
  802d65:	39 c2                	cmp    %eax,%edx
  802d67:	0f 86 f1 03 00 00    	jbe    80315e <insert_sorted_with_merge_freeList+0x710>
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 50 08             	mov    0x8(%eax),%edx
  802d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d76:	8b 40 08             	mov    0x8(%eax),%eax
  802d79:	39 c2                	cmp    %eax,%edx
  802d7b:	0f 83 dd 03 00 00    	jae    80315e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 50 08             	mov    0x8(%eax),%edx
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8d:	01 c2                	add    %eax,%edx
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	8b 40 08             	mov    0x8(%eax),%eax
  802d95:	39 c2                	cmp    %eax,%edx
  802d97:	0f 85 b9 01 00 00    	jne    802f56 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	8b 50 08             	mov    0x8(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	01 c2                	add    %eax,%edx
  802dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dae:	8b 40 08             	mov    0x8(%eax),%eax
  802db1:	39 c2                	cmp    %eax,%edx
  802db3:	0f 85 0d 01 00 00    	jne    802ec6 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802dcd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dd1:	75 17                	jne    802dea <insert_sorted_with_merge_freeList+0x39c>
  802dd3:	83 ec 04             	sub    $0x4,%esp
  802dd6:	68 c8 3d 80 00       	push   $0x803dc8
  802ddb:	68 5c 01 00 00       	push   $0x15c
  802de0:	68 1f 3d 80 00       	push   $0x803d1f
  802de5:	e8 64 04 00 00       	call   80324e <_panic>
  802dea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	85 c0                	test   %eax,%eax
  802df1:	74 10                	je     802e03 <insert_sorted_with_merge_freeList+0x3b5>
  802df3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dfb:	8b 52 04             	mov    0x4(%edx),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	eb 0b                	jmp    802e0e <insert_sorted_with_merge_freeList+0x3c0>
  802e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e06:	8b 40 04             	mov    0x4(%eax),%eax
  802e09:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0f                	je     802e27 <insert_sorted_with_merge_freeList+0x3d9>
  802e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e21:	8b 12                	mov    (%edx),%edx
  802e23:	89 10                	mov    %edx,(%eax)
  802e25:	eb 0a                	jmp    802e31 <insert_sorted_with_merge_freeList+0x3e3>
  802e27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2a:	8b 00                	mov    (%eax),%eax
  802e2c:	a3 38 41 80 00       	mov    %eax,0x804138
  802e31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 44 41 80 00       	mov    0x804144,%eax
  802e49:	48                   	dec    %eax
  802e4a:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e67:	75 17                	jne    802e80 <insert_sorted_with_merge_freeList+0x432>
  802e69:	83 ec 04             	sub    $0x4,%esp
  802e6c:	68 fc 3c 80 00       	push   $0x803cfc
  802e71:	68 5f 01 00 00       	push   $0x15f
  802e76:	68 1f 3d 80 00       	push   $0x803d1f
  802e7b:	e8 ce 03 00 00       	call   80324e <_panic>
  802e80:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e89:	89 10                	mov    %edx,(%eax)
  802e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8e:	8b 00                	mov    (%eax),%eax
  802e90:	85 c0                	test   %eax,%eax
  802e92:	74 0d                	je     802ea1 <insert_sorted_with_merge_freeList+0x453>
  802e94:	a1 48 41 80 00       	mov    0x804148,%eax
  802e99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9c:	89 50 04             	mov    %edx,0x4(%eax)
  802e9f:	eb 08                	jmp    802ea9 <insert_sorted_with_merge_freeList+0x45b>
  802ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eac:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebb:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec0:	40                   	inc    %eax
  802ec1:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed2:	01 c2                	add    %eax,%edx
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef2:	75 17                	jne    802f0b <insert_sorted_with_merge_freeList+0x4bd>
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 fc 3c 80 00       	push   $0x803cfc
  802efc:	68 64 01 00 00       	push   $0x164
  802f01:	68 1f 3d 80 00       	push   $0x803d1f
  802f06:	e8 43 03 00 00       	call   80324e <_panic>
  802f0b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	89 10                	mov    %edx,(%eax)
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 00                	mov    (%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0d                	je     802f2c <insert_sorted_with_merge_freeList+0x4de>
  802f1f:	a1 48 41 80 00       	mov    0x804148,%eax
  802f24:	8b 55 08             	mov    0x8(%ebp),%edx
  802f27:	89 50 04             	mov    %edx,0x4(%eax)
  802f2a:	eb 08                	jmp    802f34 <insert_sorted_with_merge_freeList+0x4e6>
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	a3 48 41 80 00       	mov    %eax,0x804148
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f46:	a1 54 41 80 00       	mov    0x804154,%eax
  802f4b:	40                   	inc    %eax
  802f4c:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f51:	e9 41 02 00 00       	jmp    803197 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f62:	01 c2                	add    %eax,%edx
  802f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	39 c2                	cmp    %eax,%edx
  802f6c:	0f 85 7c 01 00 00    	jne    8030ee <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f76:	74 06                	je     802f7e <insert_sorted_with_merge_freeList+0x530>
  802f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7c:	75 17                	jne    802f95 <insert_sorted_with_merge_freeList+0x547>
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 38 3d 80 00       	push   $0x803d38
  802f86:	68 69 01 00 00       	push   $0x169
  802f8b:	68 1f 3d 80 00       	push   $0x803d1f
  802f90:	e8 b9 02 00 00       	call   80324e <_panic>
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 50 04             	mov    0x4(%eax),%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fac:	8b 40 04             	mov    0x4(%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 0d                	je     802fc0 <insert_sorted_with_merge_freeList+0x572>
  802fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbc:	89 10                	mov    %edx,(%eax)
  802fbe:	eb 08                	jmp    802fc8 <insert_sorted_with_merge_freeList+0x57a>
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	a3 38 41 80 00       	mov    %eax,0x804138
  802fc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fce:	89 50 04             	mov    %edx,0x4(%eax)
  802fd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802fd6:	40                   	inc    %eax
  802fd7:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe8:	01 c2                	add    %eax,%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ff0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff4:	75 17                	jne    80300d <insert_sorted_with_merge_freeList+0x5bf>
  802ff6:	83 ec 04             	sub    $0x4,%esp
  802ff9:	68 c8 3d 80 00       	push   $0x803dc8
  802ffe:	68 6b 01 00 00       	push   $0x16b
  803003:	68 1f 3d 80 00       	push   $0x803d1f
  803008:	e8 41 02 00 00       	call   80324e <_panic>
  80300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 10                	je     803026 <insert_sorted_with_merge_freeList+0x5d8>
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301e:	8b 52 04             	mov    0x4(%edx),%edx
  803021:	89 50 04             	mov    %edx,0x4(%eax)
  803024:	eb 0b                	jmp    803031 <insert_sorted_with_merge_freeList+0x5e3>
  803026:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803029:	8b 40 04             	mov    0x4(%eax),%eax
  80302c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	8b 40 04             	mov    0x4(%eax),%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	74 0f                	je     80304a <insert_sorted_with_merge_freeList+0x5fc>
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803044:	8b 12                	mov    (%edx),%edx
  803046:	89 10                	mov    %edx,(%eax)
  803048:	eb 0a                	jmp    803054 <insert_sorted_with_merge_freeList+0x606>
  80304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304d:	8b 00                	mov    (%eax),%eax
  80304f:	a3 38 41 80 00       	mov    %eax,0x804138
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803067:	a1 44 41 80 00       	mov    0x804144,%eax
  80306c:	48                   	dec    %eax
  80306d:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803072:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803075:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80307c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803086:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308a:	75 17                	jne    8030a3 <insert_sorted_with_merge_freeList+0x655>
  80308c:	83 ec 04             	sub    $0x4,%esp
  80308f:	68 fc 3c 80 00       	push   $0x803cfc
  803094:	68 6e 01 00 00       	push   $0x16e
  803099:	68 1f 3d 80 00       	push   $0x803d1f
  80309e:	e8 ab 01 00 00       	call   80324e <_panic>
  8030a3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ac:	89 10                	mov    %edx,(%eax)
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 0d                	je     8030c4 <insert_sorted_with_merge_freeList+0x676>
  8030b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8030bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bf:	89 50 04             	mov    %edx,0x4(%eax)
  8030c2:	eb 08                	jmp    8030cc <insert_sorted_with_merge_freeList+0x67e>
  8030c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030de:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e3:	40                   	inc    %eax
  8030e4:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030e9:	e9 a9 00 00 00       	jmp    803197 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8030ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f2:	74 06                	je     8030fa <insert_sorted_with_merge_freeList+0x6ac>
  8030f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f8:	75 17                	jne    803111 <insert_sorted_with_merge_freeList+0x6c3>
  8030fa:	83 ec 04             	sub    $0x4,%esp
  8030fd:	68 94 3d 80 00       	push   $0x803d94
  803102:	68 73 01 00 00       	push   $0x173
  803107:	68 1f 3d 80 00       	push   $0x803d1f
  80310c:	e8 3d 01 00 00       	call   80324e <_panic>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 10                	mov    (%eax),%edx
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0b                	je     80312f <insert_sorted_with_merge_freeList+0x6e1>
  803124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	8b 55 08             	mov    0x8(%ebp),%edx
  80312c:	89 50 04             	mov    %edx,0x4(%eax)
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 55 08             	mov    0x8(%ebp),%edx
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	75 08                	jne    803151 <insert_sorted_with_merge_freeList+0x703>
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803151:	a1 44 41 80 00       	mov    0x804144,%eax
  803156:	40                   	inc    %eax
  803157:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80315c:	eb 39                	jmp    803197 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80315e:	a1 40 41 80 00       	mov    0x804140,%eax
  803163:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316a:	74 07                	je     803173 <insert_sorted_with_merge_freeList+0x725>
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	eb 05                	jmp    803178 <insert_sorted_with_merge_freeList+0x72a>
  803173:	b8 00 00 00 00       	mov    $0x0,%eax
  803178:	a3 40 41 80 00       	mov    %eax,0x804140
  80317d:	a1 40 41 80 00       	mov    0x804140,%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	0f 85 c7 fb ff ff    	jne    802d51 <insert_sorted_with_merge_freeList+0x303>
  80318a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318e:	0f 85 bd fb ff ff    	jne    802d51 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803194:	eb 01                	jmp    803197 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803196:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803197:	90                   	nop
  803198:	c9                   	leave  
  803199:	c3                   	ret    

0080319a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80319a:	55                   	push   %ebp
  80319b:	89 e5                	mov    %esp,%ebp
  80319d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8031a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a3:	89 d0                	mov    %edx,%eax
  8031a5:	c1 e0 02             	shl    $0x2,%eax
  8031a8:	01 d0                	add    %edx,%eax
  8031aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031b1:	01 d0                	add    %edx,%eax
  8031b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031ba:	01 d0                	add    %edx,%eax
  8031bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031c3:	01 d0                	add    %edx,%eax
  8031c5:	c1 e0 04             	shl    $0x4,%eax
  8031c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8031cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8031d2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8031d5:	83 ec 0c             	sub    $0xc,%esp
  8031d8:	50                   	push   %eax
  8031d9:	e8 26 e7 ff ff       	call   801904 <sys_get_virtual_time>
  8031de:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8031e1:	eb 41                	jmp    803224 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8031e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8031e6:	83 ec 0c             	sub    $0xc,%esp
  8031e9:	50                   	push   %eax
  8031ea:	e8 15 e7 ff ff       	call   801904 <sys_get_virtual_time>
  8031ef:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8031f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	29 c2                	sub    %eax,%edx
  8031fa:	89 d0                	mov    %edx,%eax
  8031fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8031ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803205:	89 d1                	mov    %edx,%ecx
  803207:	29 c1                	sub    %eax,%ecx
  803209:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80320c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320f:	39 c2                	cmp    %eax,%edx
  803211:	0f 97 c0             	seta   %al
  803214:	0f b6 c0             	movzbl %al,%eax
  803217:	29 c1                	sub    %eax,%ecx
  803219:	89 c8                	mov    %ecx,%eax
  80321b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80321e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803221:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80322a:	72 b7                	jb     8031e3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80322c:	90                   	nop
  80322d:	c9                   	leave  
  80322e:	c3                   	ret    

0080322f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80322f:	55                   	push   %ebp
  803230:	89 e5                	mov    %esp,%ebp
  803232:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80323c:	eb 03                	jmp    803241 <busy_wait+0x12>
  80323e:	ff 45 fc             	incl   -0x4(%ebp)
  803241:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803244:	3b 45 08             	cmp    0x8(%ebp),%eax
  803247:	72 f5                	jb     80323e <busy_wait+0xf>
	return i;
  803249:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80324c:	c9                   	leave  
  80324d:	c3                   	ret    

0080324e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80324e:	55                   	push   %ebp
  80324f:	89 e5                	mov    %esp,%ebp
  803251:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803254:	8d 45 10             	lea    0x10(%ebp),%eax
  803257:	83 c0 04             	add    $0x4,%eax
  80325a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80325d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803262:	85 c0                	test   %eax,%eax
  803264:	74 16                	je     80327c <_panic+0x2e>
		cprintf("%s: ", argv0);
  803266:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80326b:	83 ec 08             	sub    $0x8,%esp
  80326e:	50                   	push   %eax
  80326f:	68 e8 3d 80 00       	push   $0x803de8
  803274:	e8 02 d1 ff ff       	call   80037b <cprintf>
  803279:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80327c:	a1 00 40 80 00       	mov    0x804000,%eax
  803281:	ff 75 0c             	pushl  0xc(%ebp)
  803284:	ff 75 08             	pushl  0x8(%ebp)
  803287:	50                   	push   %eax
  803288:	68 ed 3d 80 00       	push   $0x803ded
  80328d:	e8 e9 d0 ff ff       	call   80037b <cprintf>
  803292:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803295:	8b 45 10             	mov    0x10(%ebp),%eax
  803298:	83 ec 08             	sub    $0x8,%esp
  80329b:	ff 75 f4             	pushl  -0xc(%ebp)
  80329e:	50                   	push   %eax
  80329f:	e8 6c d0 ff ff       	call   800310 <vcprintf>
  8032a4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8032a7:	83 ec 08             	sub    $0x8,%esp
  8032aa:	6a 00                	push   $0x0
  8032ac:	68 09 3e 80 00       	push   $0x803e09
  8032b1:	e8 5a d0 ff ff       	call   800310 <vcprintf>
  8032b6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8032b9:	e8 db cf ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  8032be:	eb fe                	jmp    8032be <_panic+0x70>

008032c0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8032cb:	8b 50 74             	mov    0x74(%eax),%edx
  8032ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032d1:	39 c2                	cmp    %eax,%edx
  8032d3:	74 14                	je     8032e9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032d5:	83 ec 04             	sub    $0x4,%esp
  8032d8:	68 0c 3e 80 00       	push   $0x803e0c
  8032dd:	6a 26                	push   $0x26
  8032df:	68 58 3e 80 00       	push   $0x803e58
  8032e4:	e8 65 ff ff ff       	call   80324e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032f7:	e9 c2 00 00 00       	jmp    8033be <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	01 d0                	add    %edx,%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	75 08                	jne    803319 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803311:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803314:	e9 a2 00 00 00       	jmp    8033bb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803319:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803320:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803327:	eb 69                	jmp    803392 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803329:	a1 20 40 80 00       	mov    0x804020,%eax
  80332e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803334:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803337:	89 d0                	mov    %edx,%eax
  803339:	01 c0                	add    %eax,%eax
  80333b:	01 d0                	add    %edx,%eax
  80333d:	c1 e0 03             	shl    $0x3,%eax
  803340:	01 c8                	add    %ecx,%eax
  803342:	8a 40 04             	mov    0x4(%eax),%al
  803345:	84 c0                	test   %al,%al
  803347:	75 46                	jne    80338f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803349:	a1 20 40 80 00       	mov    0x804020,%eax
  80334e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803354:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803357:	89 d0                	mov    %edx,%eax
  803359:	01 c0                	add    %eax,%eax
  80335b:	01 d0                	add    %edx,%eax
  80335d:	c1 e0 03             	shl    $0x3,%eax
  803360:	01 c8                	add    %ecx,%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803367:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80336a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80336f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803374:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	01 c8                	add    %ecx,%eax
  803380:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803382:	39 c2                	cmp    %eax,%edx
  803384:	75 09                	jne    80338f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803386:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80338d:	eb 12                	jmp    8033a1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80338f:	ff 45 e8             	incl   -0x18(%ebp)
  803392:	a1 20 40 80 00       	mov    0x804020,%eax
  803397:	8b 50 74             	mov    0x74(%eax),%edx
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	39 c2                	cmp    %eax,%edx
  80339f:	77 88                	ja     803329 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8033a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033a5:	75 14                	jne    8033bb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8033a7:	83 ec 04             	sub    $0x4,%esp
  8033aa:	68 64 3e 80 00       	push   $0x803e64
  8033af:	6a 3a                	push   $0x3a
  8033b1:	68 58 3e 80 00       	push   $0x803e58
  8033b6:	e8 93 fe ff ff       	call   80324e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8033bb:	ff 45 f0             	incl   -0x10(%ebp)
  8033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033c4:	0f 8c 32 ff ff ff    	jl     8032fc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033d8:	eb 26                	jmp    803400 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033da:	a1 20 40 80 00       	mov    0x804020,%eax
  8033df:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033e8:	89 d0                	mov    %edx,%eax
  8033ea:	01 c0                	add    %eax,%eax
  8033ec:	01 d0                	add    %edx,%eax
  8033ee:	c1 e0 03             	shl    $0x3,%eax
  8033f1:	01 c8                	add    %ecx,%eax
  8033f3:	8a 40 04             	mov    0x4(%eax),%al
  8033f6:	3c 01                	cmp    $0x1,%al
  8033f8:	75 03                	jne    8033fd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033fa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033fd:	ff 45 e0             	incl   -0x20(%ebp)
  803400:	a1 20 40 80 00       	mov    0x804020,%eax
  803405:	8b 50 74             	mov    0x74(%eax),%edx
  803408:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80340b:	39 c2                	cmp    %eax,%edx
  80340d:	77 cb                	ja     8033da <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803415:	74 14                	je     80342b <CheckWSWithoutLastIndex+0x16b>
		panic(
  803417:	83 ec 04             	sub    $0x4,%esp
  80341a:	68 b8 3e 80 00       	push   $0x803eb8
  80341f:	6a 44                	push   $0x44
  803421:	68 58 3e 80 00       	push   $0x803e58
  803426:	e8 23 fe ff ff       	call   80324e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80342b:	90                   	nop
  80342c:	c9                   	leave  
  80342d:	c3                   	ret    
  80342e:	66 90                	xchg   %ax,%ax

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
