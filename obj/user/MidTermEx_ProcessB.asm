
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
  80003e:	e8 20 19 00 00       	call   801963 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 40 37 80 00       	push   $0x803740
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 f0 13 00 00       	call   801446 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 42 37 80 00       	push   $0x803742
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 da 13 00 00       	call   801446 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 49 37 80 00       	push   $0x803749
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 c4 13 00 00       	call   801446 <sget>
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
  800095:	68 57 37 80 00       	push   $0x803757
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 62 17 00 00       	call   801804 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 e5 18 00 00       	call   801996 <sys_get_virtual_time>
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
  8000d4:	e8 53 31 00 00       	call   80322c <env_sleep>
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
  8000ec:	e8 a5 18 00 00       	call   801996 <sys_get_virtual_time>
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
  800114:	e8 13 31 00 00       	call   80322c <env_sleep>
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
  80012b:	e8 66 18 00 00       	call   801996 <sys_get_virtual_time>
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
  800153:	e8 d4 30 00 00       	call   80322c <env_sleep>
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
  800171:	e8 d4 17 00 00       	call   80194a <sys_getenvindex>
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
  8001dc:	e8 76 15 00 00       	call   801757 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 74 37 80 00       	push   $0x803774
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
  80020c:	68 9c 37 80 00       	push   $0x80379c
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
  80023d:	68 c4 37 80 00       	push   $0x8037c4
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 1c 38 80 00       	push   $0x80381c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 74 37 80 00       	push   $0x803774
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 f6 14 00 00       	call   801771 <sys_enable_interrupt>

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
  80028e:	e8 83 16 00 00       	call   801916 <sys_destroy_env>
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
  80029f:	e8 d8 16 00 00       	call   80197c <sys_exit_env>
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
  8002ed:	e8 b7 12 00 00       	call   8015a9 <sys_cputs>
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
  800364:	e8 40 12 00 00       	call   8015a9 <sys_cputs>
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
  8003ae:	e8 a4 13 00 00       	call   801757 <sys_disable_interrupt>
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
  8003ce:	e8 9e 13 00 00       	call   801771 <sys_enable_interrupt>
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
  800418:	e8 a3 30 00 00       	call   8034c0 <__udivdi3>
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
  800468:	e8 63 31 00 00       	call   8035d0 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 54 3a 80 00       	add    $0x803a54,%eax
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
  8005c3:	8b 04 85 78 3a 80 00 	mov    0x803a78(,%eax,4),%eax
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
  8006a4:	8b 34 9d c0 38 80 00 	mov    0x8038c0(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 65 3a 80 00       	push   $0x803a65
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
  8006c9:	68 6e 3a 80 00       	push   $0x803a6e
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
  8006f6:	be 71 3a 80 00       	mov    $0x803a71,%esi
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
  80111c:	68 d0 3b 80 00       	push   $0x803bd0
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
  8011ec:	e8 fc 04 00 00       	call   8016ed <sys_allocate_chunk>
  8011f1:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	50                   	push   %eax
  8011fd:	e8 71 0b 00 00       	call   801d73 <initialize_MemBlocksList>
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
  80122a:	68 f5 3b 80 00       	push   $0x803bf5
  80122f:	6a 33                	push   $0x33
  801231:	68 13 3c 80 00       	push   $0x803c13
  801236:	e8 a5 20 00 00       	call   8032e0 <_panic>
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
  8012a9:	68 20 3c 80 00       	push   $0x803c20
  8012ae:	6a 34                	push   $0x34
  8012b0:	68 13 3c 80 00       	push   $0x803c13
  8012b5:	e8 26 20 00 00       	call   8032e0 <_panic>
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
  801341:	e8 75 07 00 00       	call   801abb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801346:	85 c0                	test   %eax,%eax
  801348:	74 11                	je     80135b <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  80134a:	83 ec 0c             	sub    $0xc,%esp
  80134d:	ff 75 e8             	pushl  -0x18(%ebp)
  801350:	e8 e0 0d 00 00       	call   802135 <alloc_block_FF>
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
  801367:	e8 3c 0b 00 00       	call   801ea8 <insert_sorted_allocList>
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
  801387:	68 44 3c 80 00       	push   $0x803c44
  80138c:	6a 6f                	push   $0x6f
  80138e:	68 13 3c 80 00       	push   $0x803c13
  801393:	e8 48 1f 00 00       	call   8032e0 <_panic>

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
  8013ad:	75 0a                	jne    8013b9 <smalloc+0x21>
  8013af:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b4:	e9 8b 00 00 00       	jmp    801444 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8013b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	48                   	dec    %eax
  8013c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d4:	f7 75 f0             	divl   -0x10(%ebp)
  8013d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013da:	29 d0                	sub    %edx,%eax
  8013dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8013df:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013e6:	e8 d0 06 00 00       	call   801abb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	74 11                	je     801400 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f5:	e8 3b 0d 00 00       	call   802135 <alloc_block_FF>
  8013fa:	83 c4 10             	add    $0x10,%esp
  8013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801400:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801404:	74 39                	je     80143f <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801409:	8b 40 08             	mov    0x8(%eax),%eax
  80140c:	89 c2                	mov    %eax,%edx
  80140e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801412:	52                   	push   %edx
  801413:	50                   	push   %eax
  801414:	ff 75 0c             	pushl  0xc(%ebp)
  801417:	ff 75 08             	pushl  0x8(%ebp)
  80141a:	e8 21 04 00 00       	call   801840 <sys_createSharedObject>
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801425:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801429:	74 14                	je     80143f <smalloc+0xa7>
  80142b:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80142f:	74 0e                	je     80143f <smalloc+0xa7>
  801431:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801435:	74 08                	je     80143f <smalloc+0xa7>
			return (void*) mem_block->sva;
  801437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143a:	8b 40 08             	mov    0x8(%eax),%eax
  80143d:	eb 05                	jmp    801444 <smalloc+0xac>
	}
	return NULL;
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80144c:	e8 b4 fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801451:	83 ec 08             	sub    $0x8,%esp
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	ff 75 08             	pushl  0x8(%ebp)
  80145a:	e8 0b 04 00 00       	call   80186a <sys_getSizeOfSharedObject>
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801465:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801469:	74 76                	je     8014e1 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80146b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801472:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801475:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801478:	01 d0                	add    %edx,%eax
  80147a:	48                   	dec    %eax
  80147b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80147e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801481:	ba 00 00 00 00       	mov    $0x0,%edx
  801486:	f7 75 ec             	divl   -0x14(%ebp)
  801489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80148c:	29 d0                	sub    %edx,%eax
  80148e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801491:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801498:	e8 1e 06 00 00       	call   801abb <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149d:	85 c0                	test   %eax,%eax
  80149f:	74 11                	je     8014b2 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a7:	e8 89 0c 00 00       	call   802135 <alloc_block_FF>
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8014b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014b6:	74 29                	je     8014e1 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	8b 40 08             	mov    0x8(%eax),%eax
  8014be:	83 ec 04             	sub    $0x4,%esp
  8014c1:	50                   	push   %eax
  8014c2:	ff 75 0c             	pushl  0xc(%ebp)
  8014c5:	ff 75 08             	pushl  0x8(%ebp)
  8014c8:	e8 ba 03 00 00       	call   801887 <sys_getSharedObject>
  8014cd:	83 c4 10             	add    $0x10,%esp
  8014d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8014d3:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8014d7:	74 08                	je     8014e1 <sget+0x9b>
				return (void *)mem_block->sva;
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	8b 40 08             	mov    0x8(%eax),%eax
  8014df:	eb 05                	jmp    8014e6 <sget+0xa0>
		}
	}
	return (void *)NULL;
  8014e1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ee:	e8 12 fc ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 68 3c 80 00       	push   $0x803c68
  8014fb:	68 f1 00 00 00       	push   $0xf1
  801500:	68 13 3c 80 00       	push   $0x803c13
  801505:	e8 d6 1d 00 00       	call   8032e0 <_panic>

0080150a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801510:	83 ec 04             	sub    $0x4,%esp
  801513:	68 90 3c 80 00       	push   $0x803c90
  801518:	68 05 01 00 00       	push   $0x105
  80151d:	68 13 3c 80 00       	push   $0x803c13
  801522:	e8 b9 1d 00 00       	call   8032e0 <_panic>

00801527 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80152d:	83 ec 04             	sub    $0x4,%esp
  801530:	68 b4 3c 80 00       	push   $0x803cb4
  801535:	68 10 01 00 00       	push   $0x110
  80153a:	68 13 3c 80 00       	push   $0x803c13
  80153f:	e8 9c 1d 00 00       	call   8032e0 <_panic>

00801544 <shrink>:

}
void shrink(uint32 newSize)
{
  801544:	55                   	push   %ebp
  801545:	89 e5                	mov    %esp,%ebp
  801547:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80154a:	83 ec 04             	sub    $0x4,%esp
  80154d:	68 b4 3c 80 00       	push   $0x803cb4
  801552:	68 15 01 00 00       	push   $0x115
  801557:	68 13 3c 80 00       	push   $0x803c13
  80155c:	e8 7f 1d 00 00       	call   8032e0 <_panic>

00801561 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801567:	83 ec 04             	sub    $0x4,%esp
  80156a:	68 b4 3c 80 00       	push   $0x803cb4
  80156f:	68 1a 01 00 00       	push   $0x11a
  801574:	68 13 3c 80 00       	push   $0x803c13
  801579:	e8 62 1d 00 00       	call   8032e0 <_panic>

0080157e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	57                   	push   %edi
  801582:	56                   	push   %esi
  801583:	53                   	push   %ebx
  801584:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801590:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801593:	8b 7d 18             	mov    0x18(%ebp),%edi
  801596:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801599:	cd 30                	int    $0x30
  80159b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	5f                   	pop    %edi
  8015a7:	5d                   	pop    %ebp
  8015a8:	c3                   	ret    

008015a9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8015b5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	52                   	push   %edx
  8015c1:	ff 75 0c             	pushl  0xc(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	e8 b2 ff ff ff       	call   80157e <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
}
  8015cf:	90                   	nop
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 01                	push   $0x1
  8015e1:	e8 98 ff ff ff       	call   80157e <syscall>
  8015e6:	83 c4 18             	add    $0x18,%esp
}
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	52                   	push   %edx
  8015fb:	50                   	push   %eax
  8015fc:	6a 05                	push   $0x5
  8015fe:	e8 7b ff ff ff       	call   80157e <syscall>
  801603:	83 c4 18             	add    $0x18,%esp
}
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	56                   	push   %esi
  80160c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80160d:	8b 75 18             	mov    0x18(%ebp),%esi
  801610:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801613:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801616:	8b 55 0c             	mov    0xc(%ebp),%edx
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	56                   	push   %esi
  80161d:	53                   	push   %ebx
  80161e:	51                   	push   %ecx
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	6a 06                	push   $0x6
  801623:	e8 56 ff ff ff       	call   80157e <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80162e:	5b                   	pop    %ebx
  80162f:	5e                   	pop    %esi
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    

00801632 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801635:	8b 55 0c             	mov    0xc(%ebp),%edx
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	52                   	push   %edx
  801642:	50                   	push   %eax
  801643:	6a 07                	push   $0x7
  801645:	e8 34 ff ff ff       	call   80157e <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	6a 08                	push   $0x8
  801660:	e8 19 ff ff ff       	call   80157e <syscall>
  801665:	83 c4 18             	add    $0x18,%esp
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 09                	push   $0x9
  801679:	e8 00 ff ff ff       	call   80157e <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 0a                	push   $0xa
  801692:	e8 e7 fe ff ff       	call   80157e <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 0b                	push   $0xb
  8016ab:	e8 ce fe ff ff       	call   80157e <syscall>
  8016b0:	83 c4 18             	add    $0x18,%esp
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	ff 75 08             	pushl  0x8(%ebp)
  8016c4:	6a 0f                	push   $0xf
  8016c6:	e8 b3 fe ff ff       	call   80157e <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
	return;
  8016ce:	90                   	nop
}
  8016cf:	c9                   	leave  
  8016d0:	c3                   	ret    

008016d1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	ff 75 08             	pushl  0x8(%ebp)
  8016e0:	6a 10                	push   $0x10
  8016e2:	e8 97 fe ff ff       	call   80157e <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8016ea:	90                   	nop
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	ff 75 10             	pushl  0x10(%ebp)
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	ff 75 08             	pushl  0x8(%ebp)
  8016fd:	6a 11                	push   $0x11
  8016ff:	e8 7a fe ff ff       	call   80157e <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
	return ;
  801707:	90                   	nop
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 0c                	push   $0xc
  801719:	e8 60 fe ff ff       	call   80157e <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	6a 0d                	push   $0xd
  801733:	e8 46 fe ff ff       	call   80157e <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	c9                   	leave  
  80173c:	c3                   	ret    

0080173d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 0e                	push   $0xe
  80174c:	e8 2d fe ff ff       	call   80157e <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	90                   	nop
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 13                	push   $0x13
  801766:	e8 13 fe ff ff       	call   80157e <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	90                   	nop
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 14                	push   $0x14
  801780:	e8 f9 fd ff ff       	call   80157e <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	90                   	nop
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <sys_cputc>:


void
sys_cputc(const char c)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801797:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	50                   	push   %eax
  8017a4:	6a 15                	push   $0x15
  8017a6:	e8 d3 fd ff ff       	call   80157e <syscall>
  8017ab:	83 c4 18             	add    $0x18,%esp
}
  8017ae:	90                   	nop
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 16                	push   $0x16
  8017c0:	e8 b9 fd ff ff       	call   80157e <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	90                   	nop
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	50                   	push   %eax
  8017db:	6a 17                	push   $0x17
  8017dd:	e8 9c fd ff ff       	call   80157e <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	52                   	push   %edx
  8017f7:	50                   	push   %eax
  8017f8:	6a 1a                	push   $0x1a
  8017fa:	e8 7f fd ff ff       	call   80157e <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	52                   	push   %edx
  801814:	50                   	push   %eax
  801815:	6a 18                	push   $0x18
  801817:	e8 62 fd ff ff       	call   80157e <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 19                	push   $0x19
  801835:	e8 44 fd ff ff       	call   80157e <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	8b 45 10             	mov    0x10(%ebp),%eax
  801849:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80184c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80184f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	51                   	push   %ecx
  801859:	52                   	push   %edx
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	6a 1b                	push   $0x1b
  801860:	e8 19 fd ff ff       	call   80157e <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	6a 1c                	push   $0x1c
  80187d:	e8 fc fc ff ff       	call   80157e <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80188a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	51                   	push   %ecx
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 1d                	push   $0x1d
  80189c:	e8 dd fc ff ff       	call   80157e <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	52                   	push   %edx
  8018b6:	50                   	push   %eax
  8018b7:	6a 1e                	push   $0x1e
  8018b9:	e8 c0 fc ff ff       	call   80157e <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 1f                	push   $0x1f
  8018d2:	e8 a7 fc ff ff       	call   80157e <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	6a 00                	push   $0x0
  8018e4:	ff 75 14             	pushl  0x14(%ebp)
  8018e7:	ff 75 10             	pushl  0x10(%ebp)
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	50                   	push   %eax
  8018ee:	6a 20                	push   $0x20
  8018f0:	e8 89 fc ff ff       	call   80157e <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	50                   	push   %eax
  801909:	6a 21                	push   $0x21
  80190b:	e8 6e fc ff ff       	call   80157e <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	50                   	push   %eax
  801925:	6a 22                	push   $0x22
  801927:	e8 52 fc ff ff       	call   80157e <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 02                	push   $0x2
  801940:	e8 39 fc ff ff       	call   80157e <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 03                	push   $0x3
  801959:	e8 20 fc ff ff       	call   80157e <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 04                	push   $0x4
  801972:	e8 07 fc ff ff       	call   80157e <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_exit_env>:


void sys_exit_env(void)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 23                	push   $0x23
  80198b:	e8 ee fb ff ff       	call   80157e <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80199c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80199f:	8d 50 04             	lea    0x4(%eax),%edx
  8019a2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	52                   	push   %edx
  8019ac:	50                   	push   %eax
  8019ad:	6a 24                	push   $0x24
  8019af:	e8 ca fb ff ff       	call   80157e <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
	return result;
  8019b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019c0:	89 01                	mov    %eax,(%ecx)
  8019c2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	c9                   	leave  
  8019c9:	c2 04 00             	ret    $0x4

008019cc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	ff 75 10             	pushl  0x10(%ebp)
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	ff 75 08             	pushl  0x8(%ebp)
  8019dc:	6a 12                	push   $0x12
  8019de:	e8 9b fb ff ff       	call   80157e <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e6:	90                   	nop
}
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 25                	push   $0x25
  8019f8:	e8 81 fb ff ff       	call   80157e <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a0e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	50                   	push   %eax
  801a1b:	6a 26                	push   $0x26
  801a1d:	e8 5c fb ff ff       	call   80157e <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
	return ;
  801a25:	90                   	nop
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <rsttst>:
void rsttst()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 28                	push   $0x28
  801a37:	e8 42 fb ff ff       	call   80157e <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a4e:	8b 55 18             	mov    0x18(%ebp),%edx
  801a51:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	ff 75 10             	pushl  0x10(%ebp)
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	6a 27                	push   $0x27
  801a62:	e8 17 fb ff ff       	call   80157e <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6a:	90                   	nop
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <chktst>:
void chktst(uint32 n)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 29                	push   $0x29
  801a7d:	e8 fc fa ff ff       	call   80157e <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return ;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <inctst>:

void inctst()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 2a                	push   $0x2a
  801a97:	e8 e2 fa ff ff       	call   80157e <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <gettst>:
uint32 gettst()
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 2b                	push   $0x2b
  801ab1:	e8 c8 fa ff ff       	call   80157e <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 2c                	push   $0x2c
  801acd:	e8 ac fa ff ff       	call   80157e <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
  801ad5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ad8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801adc:	75 07                	jne    801ae5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ade:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae3:	eb 05                	jmp    801aea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 2c                	push   $0x2c
  801afe:	e8 7b fa ff ff       	call   80157e <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
  801b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b09:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b0d:	75 07                	jne    801b16 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b14:	eb 05                	jmp    801b1b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
  801b20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 2c                	push   $0x2c
  801b2f:	e8 4a fa ff ff       	call   80157e <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
  801b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b3a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b3e:	75 07                	jne    801b47 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b40:	b8 01 00 00 00       	mov    $0x1,%eax
  801b45:	eb 05                	jmp    801b4c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 2c                	push   $0x2c
  801b60:	e8 19 fa ff ff       	call   80157e <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
  801b68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b6b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b6f:	75 07                	jne    801b78 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b71:	b8 01 00 00 00       	mov    $0x1,%eax
  801b76:	eb 05                	jmp    801b7d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	ff 75 08             	pushl  0x8(%ebp)
  801b8d:	6a 2d                	push   $0x2d
  801b8f:	e8 ea f9 ff ff       	call   80157e <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
	return ;
  801b97:	90                   	nop
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b9e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	53                   	push   %ebx
  801bad:	51                   	push   %ecx
  801bae:	52                   	push   %edx
  801baf:	50                   	push   %eax
  801bb0:	6a 2e                	push   $0x2e
  801bb2:	e8 c7 f9 ff ff       	call   80157e <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 2f                	push   $0x2f
  801bd2:	e8 a7 f9 ff ff       	call   80157e <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	68 c4 3c 80 00       	push   $0x803cc4
  801bea:	e8 8c e7 ff ff       	call   80037b <cprintf>
  801bef:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	68 f0 3c 80 00       	push   $0x803cf0
  801c01:	e8 75 e7 ff ff       	call   80037b <cprintf>
  801c06:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c09:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c0d:	a1 38 41 80 00       	mov    0x804138,%eax
  801c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c15:	eb 56                	jmp    801c6d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c1b:	74 1c                	je     801c39 <print_mem_block_lists+0x5d>
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	8b 50 08             	mov    0x8(%eax),%edx
  801c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c26:	8b 48 08             	mov    0x8(%eax),%ecx
  801c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2f:	01 c8                	add    %ecx,%eax
  801c31:	39 c2                	cmp    %eax,%edx
  801c33:	73 04                	jae    801c39 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c35:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	8b 50 08             	mov    0x8(%eax),%edx
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	8b 40 0c             	mov    0xc(%eax),%eax
  801c45:	01 c2                	add    %eax,%edx
  801c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4a:	8b 40 08             	mov    0x8(%eax),%eax
  801c4d:	83 ec 04             	sub    $0x4,%esp
  801c50:	52                   	push   %edx
  801c51:	50                   	push   %eax
  801c52:	68 05 3d 80 00       	push   $0x803d05
  801c57:	e8 1f e7 ff ff       	call   80037b <cprintf>
  801c5c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c65:	a1 40 41 80 00       	mov    0x804140,%eax
  801c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c71:	74 07                	je     801c7a <print_mem_block_lists+0x9e>
  801c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c76:	8b 00                	mov    (%eax),%eax
  801c78:	eb 05                	jmp    801c7f <print_mem_block_lists+0xa3>
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	a3 40 41 80 00       	mov    %eax,0x804140
  801c84:	a1 40 41 80 00       	mov    0x804140,%eax
  801c89:	85 c0                	test   %eax,%eax
  801c8b:	75 8a                	jne    801c17 <print_mem_block_lists+0x3b>
  801c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c91:	75 84                	jne    801c17 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c93:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c97:	75 10                	jne    801ca9 <print_mem_block_lists+0xcd>
  801c99:	83 ec 0c             	sub    $0xc,%esp
  801c9c:	68 14 3d 80 00       	push   $0x803d14
  801ca1:	e8 d5 e6 ff ff       	call   80037b <cprintf>
  801ca6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ca9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801cb0:	83 ec 0c             	sub    $0xc,%esp
  801cb3:	68 38 3d 80 00       	push   $0x803d38
  801cb8:	e8 be e6 ff ff       	call   80037b <cprintf>
  801cbd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801cc0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801cc4:	a1 40 40 80 00       	mov    0x804040,%eax
  801cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ccc:	eb 56                	jmp    801d24 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd2:	74 1c                	je     801cf0 <print_mem_block_lists+0x114>
  801cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd7:	8b 50 08             	mov    0x8(%eax),%edx
  801cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdd:	8b 48 08             	mov    0x8(%eax),%ecx
  801ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce6:	01 c8                	add    %ecx,%eax
  801ce8:	39 c2                	cmp    %eax,%edx
  801cea:	73 04                	jae    801cf0 <print_mem_block_lists+0x114>
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
  801d09:	68 05 3d 80 00       	push   $0x803d05
  801d0e:	e8 68 e6 ff ff       	call   80037b <cprintf>
  801d13:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d1c:	a1 48 40 80 00       	mov    0x804048,%eax
  801d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d28:	74 07                	je     801d31 <print_mem_block_lists+0x155>
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	8b 00                	mov    (%eax),%eax
  801d2f:	eb 05                	jmp    801d36 <print_mem_block_lists+0x15a>
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
  801d36:	a3 48 40 80 00       	mov    %eax,0x804048
  801d3b:	a1 48 40 80 00       	mov    0x804048,%eax
  801d40:	85 c0                	test   %eax,%eax
  801d42:	75 8a                	jne    801cce <print_mem_block_lists+0xf2>
  801d44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d48:	75 84                	jne    801cce <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d4a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d4e:	75 10                	jne    801d60 <print_mem_block_lists+0x184>
  801d50:	83 ec 0c             	sub    $0xc,%esp
  801d53:	68 50 3d 80 00       	push   $0x803d50
  801d58:	e8 1e e6 ff ff       	call   80037b <cprintf>
  801d5d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801d60:	83 ec 0c             	sub    $0xc,%esp
  801d63:	68 c4 3c 80 00       	push   $0x803cc4
  801d68:	e8 0e e6 ff ff       	call   80037b <cprintf>
  801d6d:	83 c4 10             	add    $0x10,%esp

}
  801d70:	90                   	nop
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801d79:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801d80:	00 00 00 
  801d83:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801d8a:	00 00 00 
  801d8d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d94:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d9e:	e9 9e 00 00 00       	jmp    801e41 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801da3:	a1 50 40 80 00       	mov    0x804050,%eax
  801da8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dab:	c1 e2 04             	shl    $0x4,%edx
  801dae:	01 d0                	add    %edx,%eax
  801db0:	85 c0                	test   %eax,%eax
  801db2:	75 14                	jne    801dc8 <initialize_MemBlocksList+0x55>
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	68 78 3d 80 00       	push   $0x803d78
  801dbc:	6a 46                	push   $0x46
  801dbe:	68 9b 3d 80 00       	push   $0x803d9b
  801dc3:	e8 18 15 00 00       	call   8032e0 <_panic>
  801dc8:	a1 50 40 80 00       	mov    0x804050,%eax
  801dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd0:	c1 e2 04             	shl    $0x4,%edx
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ddb:	89 10                	mov    %edx,(%eax)
  801ddd:	8b 00                	mov    (%eax),%eax
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	74 18                	je     801dfb <initialize_MemBlocksList+0x88>
  801de3:	a1 48 41 80 00       	mov    0x804148,%eax
  801de8:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801dee:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801df1:	c1 e1 04             	shl    $0x4,%ecx
  801df4:	01 ca                	add    %ecx,%edx
  801df6:	89 50 04             	mov    %edx,0x4(%eax)
  801df9:	eb 12                	jmp    801e0d <initialize_MemBlocksList+0x9a>
  801dfb:	a1 50 40 80 00       	mov    0x804050,%eax
  801e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e03:	c1 e2 04             	shl    $0x4,%edx
  801e06:	01 d0                	add    %edx,%eax
  801e08:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e0d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e15:	c1 e2 04             	shl    $0x4,%edx
  801e18:	01 d0                	add    %edx,%eax
  801e1a:	a3 48 41 80 00       	mov    %eax,0x804148
  801e1f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e27:	c1 e2 04             	shl    $0x4,%edx
  801e2a:	01 d0                	add    %edx,%eax
  801e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e33:	a1 54 41 80 00       	mov    0x804154,%eax
  801e38:	40                   	inc    %eax
  801e39:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801e3e:	ff 45 f4             	incl   -0xc(%ebp)
  801e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e44:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e47:	0f 82 56 ff ff ff    	jb     801da3 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801e4d:	90                   	nop
  801e4e:	c9                   	leave  
  801e4f:	c3                   	ret    

00801e50 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	8b 00                	mov    (%eax),%eax
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e5e:	eb 19                	jmp    801e79 <find_block+0x29>
	{
		if(va==point->sva)
  801e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e63:	8b 40 08             	mov    0x8(%eax),%eax
  801e66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e69:	75 05                	jne    801e70 <find_block+0x20>
		   return point;
  801e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6e:	eb 36                	jmp    801ea6 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e70:	8b 45 08             	mov    0x8(%ebp),%eax
  801e73:	8b 40 08             	mov    0x8(%eax),%eax
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e7d:	74 07                	je     801e86 <find_block+0x36>
  801e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e82:	8b 00                	mov    (%eax),%eax
  801e84:	eb 05                	jmp    801e8b <find_block+0x3b>
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8e:	89 42 08             	mov    %eax,0x8(%edx)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	8b 40 08             	mov    0x8(%eax),%eax
  801e97:	85 c0                	test   %eax,%eax
  801e99:	75 c5                	jne    801e60 <find_block+0x10>
  801e9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e9f:	75 bf                	jne    801e60 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801eae:	a1 40 40 80 00       	mov    0x804040,%eax
  801eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801eb6:	a1 44 40 80 00       	mov    0x804044,%eax
  801ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801ec4:	74 24                	je     801eea <insert_sorted_allocList+0x42>
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	8b 50 08             	mov    0x8(%eax),%edx
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 40 08             	mov    0x8(%eax),%eax
  801ed2:	39 c2                	cmp    %eax,%edx
  801ed4:	76 14                	jbe    801eea <insert_sorted_allocList+0x42>
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	8b 50 08             	mov    0x8(%eax),%edx
  801edc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801edf:	8b 40 08             	mov    0x8(%eax),%eax
  801ee2:	39 c2                	cmp    %eax,%edx
  801ee4:	0f 82 60 01 00 00    	jb     80204a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eee:	75 65                	jne    801f55 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ef0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ef4:	75 14                	jne    801f0a <insert_sorted_allocList+0x62>
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	68 78 3d 80 00       	push   $0x803d78
  801efe:	6a 6b                	push   $0x6b
  801f00:	68 9b 3d 80 00       	push   $0x803d9b
  801f05:	e8 d6 13 00 00       	call   8032e0 <_panic>
  801f0a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	89 10                	mov    %edx,(%eax)
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	8b 00                	mov    (%eax),%eax
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	74 0d                	je     801f2b <insert_sorted_allocList+0x83>
  801f1e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f23:	8b 55 08             	mov    0x8(%ebp),%edx
  801f26:	89 50 04             	mov    %edx,0x4(%eax)
  801f29:	eb 08                	jmp    801f33 <insert_sorted_allocList+0x8b>
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	a3 44 40 80 00       	mov    %eax,0x804044
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	a3 40 40 80 00       	mov    %eax,0x804040
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f45:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f4a:	40                   	inc    %eax
  801f4b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f50:	e9 dc 01 00 00       	jmp    802131 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8b 50 08             	mov    0x8(%eax),%edx
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 40 08             	mov    0x8(%eax),%eax
  801f61:	39 c2                	cmp    %eax,%edx
  801f63:	77 6c                	ja     801fd1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801f65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f69:	74 06                	je     801f71 <insert_sorted_allocList+0xc9>
  801f6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f6f:	75 14                	jne    801f85 <insert_sorted_allocList+0xdd>
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	68 b4 3d 80 00       	push   $0x803db4
  801f79:	6a 6f                	push   $0x6f
  801f7b:	68 9b 3d 80 00       	push   $0x803d9b
  801f80:	e8 5b 13 00 00       	call   8032e0 <_panic>
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	8b 50 04             	mov    0x4(%eax),%edx
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	89 50 04             	mov    %edx,0x4(%eax)
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f97:	89 10                	mov    %edx,(%eax)
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 40 04             	mov    0x4(%eax),%eax
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	74 0d                	je     801fb0 <insert_sorted_allocList+0x108>
  801fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa6:	8b 40 04             	mov    0x4(%eax),%eax
  801fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  801fac:	89 10                	mov    %edx,(%eax)
  801fae:	eb 08                	jmp    801fb8 <insert_sorted_allocList+0x110>
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	a3 40 40 80 00       	mov    %eax,0x804040
  801fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbe:	89 50 04             	mov    %edx,0x4(%eax)
  801fc1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fc6:	40                   	inc    %eax
  801fc7:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fcc:	e9 60 01 00 00       	jmp    802131 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	8b 50 08             	mov    0x8(%eax),%edx
  801fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fda:	8b 40 08             	mov    0x8(%eax),%eax
  801fdd:	39 c2                	cmp    %eax,%edx
  801fdf:	0f 82 4c 01 00 00    	jb     802131 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801fe5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe9:	75 14                	jne    801fff <insert_sorted_allocList+0x157>
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	68 ec 3d 80 00       	push   $0x803dec
  801ff3:	6a 73                	push   $0x73
  801ff5:	68 9b 3d 80 00       	push   $0x803d9b
  801ffa:	e8 e1 12 00 00       	call   8032e0 <_panic>
  801fff:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	89 50 04             	mov    %edx,0x4(%eax)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	8b 40 04             	mov    0x4(%eax),%eax
  802011:	85 c0                	test   %eax,%eax
  802013:	74 0c                	je     802021 <insert_sorted_allocList+0x179>
  802015:	a1 44 40 80 00       	mov    0x804044,%eax
  80201a:	8b 55 08             	mov    0x8(%ebp),%edx
  80201d:	89 10                	mov    %edx,(%eax)
  80201f:	eb 08                	jmp    802029 <insert_sorted_allocList+0x181>
  802021:	8b 45 08             	mov    0x8(%ebp),%eax
  802024:	a3 40 40 80 00       	mov    %eax,0x804040
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	a3 44 40 80 00       	mov    %eax,0x804044
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80203a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203f:	40                   	inc    %eax
  802040:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802045:	e9 e7 00 00 00       	jmp    802131 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802050:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802057:	a1 40 40 80 00       	mov    0x804040,%eax
  80205c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205f:	e9 9d 00 00 00       	jmp    802101 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	8b 50 08             	mov    0x8(%eax),%edx
  802072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802075:	8b 40 08             	mov    0x8(%eax),%eax
  802078:	39 c2                	cmp    %eax,%edx
  80207a:	76 7d                	jbe    8020f9 <insert_sorted_allocList+0x251>
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8b 50 08             	mov    0x8(%eax),%edx
  802082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802085:	8b 40 08             	mov    0x8(%eax),%eax
  802088:	39 c2                	cmp    %eax,%edx
  80208a:	73 6d                	jae    8020f9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80208c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802090:	74 06                	je     802098 <insert_sorted_allocList+0x1f0>
  802092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802096:	75 14                	jne    8020ac <insert_sorted_allocList+0x204>
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 10 3e 80 00       	push   $0x803e10
  8020a0:	6a 7f                	push   $0x7f
  8020a2:	68 9b 3d 80 00       	push   $0x803d9b
  8020a7:	e8 34 12 00 00       	call   8032e0 <_panic>
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 10                	mov    (%eax),%edx
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	89 10                	mov    %edx,(%eax)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	85 c0                	test   %eax,%eax
  8020bd:	74 0b                	je     8020ca <insert_sorted_allocList+0x222>
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 00                	mov    (%eax),%eax
  8020c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c7:	89 50 04             	mov    %edx,0x4(%eax)
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d0:	89 10                	mov    %edx,(%eax)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d8:	89 50 04             	mov    %edx,0x4(%eax)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	85 c0                	test   %eax,%eax
  8020e2:	75 08                	jne    8020ec <insert_sorted_allocList+0x244>
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8020ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f1:	40                   	inc    %eax
  8020f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020f7:	eb 39                	jmp    802132 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020f9:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802101:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802105:	74 07                	je     80210e <insert_sorted_allocList+0x266>
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 00                	mov    (%eax),%eax
  80210c:	eb 05                	jmp    802113 <insert_sorted_allocList+0x26b>
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
  802113:	a3 48 40 80 00       	mov    %eax,0x804048
  802118:	a1 48 40 80 00       	mov    0x804048,%eax
  80211d:	85 c0                	test   %eax,%eax
  80211f:	0f 85 3f ff ff ff    	jne    802064 <insert_sorted_allocList+0x1bc>
  802125:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802129:	0f 85 35 ff ff ff    	jne    802064 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80212f:	eb 01                	jmp    802132 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802131:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802132:	90                   	nop
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80213b:	a1 38 41 80 00       	mov    0x804138,%eax
  802140:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802143:	e9 85 01 00 00       	jmp    8022cd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 40 0c             	mov    0xc(%eax),%eax
  80214e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802151:	0f 82 6e 01 00 00    	jb     8022c5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 40 0c             	mov    0xc(%eax),%eax
  80215d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802160:	0f 85 8a 00 00 00    	jne    8021f0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216a:	75 17                	jne    802183 <alloc_block_FF+0x4e>
  80216c:	83 ec 04             	sub    $0x4,%esp
  80216f:	68 44 3e 80 00       	push   $0x803e44
  802174:	68 93 00 00 00       	push   $0x93
  802179:	68 9b 3d 80 00       	push   $0x803d9b
  80217e:	e8 5d 11 00 00       	call   8032e0 <_panic>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 10                	je     80219c <alloc_block_FF+0x67>
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 00                	mov    (%eax),%eax
  802191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802194:	8b 52 04             	mov    0x4(%edx),%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 0b                	jmp    8021a7 <alloc_block_FF+0x72>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 40 04             	mov    0x4(%eax),%eax
  8021a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021aa:	8b 40 04             	mov    0x4(%eax),%eax
  8021ad:	85 c0                	test   %eax,%eax
  8021af:	74 0f                	je     8021c0 <alloc_block_FF+0x8b>
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 04             	mov    0x4(%eax),%eax
  8021b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ba:	8b 12                	mov    (%edx),%edx
  8021bc:	89 10                	mov    %edx,(%eax)
  8021be:	eb 0a                	jmp    8021ca <alloc_block_FF+0x95>
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8021e2:	48                   	dec    %eax
  8021e3:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	e9 10 01 00 00       	jmp    802300 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8021f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f9:	0f 86 c6 00 00 00    	jbe    8022c5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8021ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802204:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802207:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220a:	8b 50 08             	mov    0x8(%eax),%edx
  80220d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802210:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	8b 55 08             	mov    0x8(%ebp),%edx
  802219:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80221c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802220:	75 17                	jne    802239 <alloc_block_FF+0x104>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 44 3e 80 00       	push   $0x803e44
  80222a:	68 9b 00 00 00       	push   $0x9b
  80222f:	68 9b 3d 80 00       	push   $0x803d9b
  802234:	e8 a7 10 00 00       	call   8032e0 <_panic>
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	74 10                	je     802252 <alloc_block_FF+0x11d>
  802242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802245:	8b 00                	mov    (%eax),%eax
  802247:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224a:	8b 52 04             	mov    0x4(%edx),%edx
  80224d:	89 50 04             	mov    %edx,0x4(%eax)
  802250:	eb 0b                	jmp    80225d <alloc_block_FF+0x128>
  802252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802255:	8b 40 04             	mov    0x4(%eax),%eax
  802258:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	8b 40 04             	mov    0x4(%eax),%eax
  802263:	85 c0                	test   %eax,%eax
  802265:	74 0f                	je     802276 <alloc_block_FF+0x141>
  802267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80226a:	8b 40 04             	mov    0x4(%eax),%eax
  80226d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802270:	8b 12                	mov    (%edx),%edx
  802272:	89 10                	mov    %edx,(%eax)
  802274:	eb 0a                	jmp    802280 <alloc_block_FF+0x14b>
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	8b 00                	mov    (%eax),%eax
  80227b:	a3 48 41 80 00       	mov    %eax,0x804148
  802280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80228c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802293:	a1 54 41 80 00       	mov    0x804154,%eax
  802298:	48                   	dec    %eax
  802299:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	01 c2                	add    %eax,%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8022b8:	89 c2                	mov    %eax,%edx
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	eb 3b                	jmp    802300 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8022ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d1:	74 07                	je     8022da <alloc_block_FF+0x1a5>
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 00                	mov    (%eax),%eax
  8022d8:	eb 05                	jmp    8022df <alloc_block_FF+0x1aa>
  8022da:	b8 00 00 00 00       	mov    $0x0,%eax
  8022df:	a3 40 41 80 00       	mov    %eax,0x804140
  8022e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	0f 85 57 fe ff ff    	jne    802148 <alloc_block_FF+0x13>
  8022f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f5:	0f 85 4d fe ff ff    	jne    802148 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802308:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80230f:	a1 38 41 80 00       	mov    0x804138,%eax
  802314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802317:	e9 df 00 00 00       	jmp    8023fb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 0c             	mov    0xc(%eax),%eax
  802322:	3b 45 08             	cmp    0x8(%ebp),%eax
  802325:	0f 82 c8 00 00 00    	jb     8023f3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 40 0c             	mov    0xc(%eax),%eax
  802331:	3b 45 08             	cmp    0x8(%ebp),%eax
  802334:	0f 85 8a 00 00 00    	jne    8023c4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80233a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233e:	75 17                	jne    802357 <alloc_block_BF+0x55>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 44 3e 80 00       	push   $0x803e44
  802348:	68 b7 00 00 00       	push   $0xb7
  80234d:	68 9b 3d 80 00       	push   $0x803d9b
  802352:	e8 89 0f 00 00       	call   8032e0 <_panic>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	85 c0                	test   %eax,%eax
  80235e:	74 10                	je     802370 <alloc_block_BF+0x6e>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802368:	8b 52 04             	mov    0x4(%edx),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	eb 0b                	jmp    80237b <alloc_block_BF+0x79>
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 40 04             	mov    0x4(%eax),%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	74 0f                	je     802394 <alloc_block_BF+0x92>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238e:	8b 12                	mov    (%edx),%edx
  802390:	89 10                	mov    %edx,(%eax)
  802392:	eb 0a                	jmp    80239e <alloc_block_BF+0x9c>
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	a3 38 41 80 00       	mov    %eax,0x804138
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b1:	a1 44 41 80 00       	mov    0x804144,%eax
  8023b6:	48                   	dec    %eax
  8023b7:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	e9 4d 01 00 00       	jmp    802511 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023cd:	76 24                	jbe    8023f3 <alloc_block_BF+0xf1>
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023d8:	73 19                	jae    8023f3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8023da:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 08             	mov    0x8(%eax),%eax
  8023f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023f3:	a1 40 41 80 00       	mov    0x804140,%eax
  8023f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ff:	74 07                	je     802408 <alloc_block_BF+0x106>
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 00                	mov    (%eax),%eax
  802406:	eb 05                	jmp    80240d <alloc_block_BF+0x10b>
  802408:	b8 00 00 00 00       	mov    $0x0,%eax
  80240d:	a3 40 41 80 00       	mov    %eax,0x804140
  802412:	a1 40 41 80 00       	mov    0x804140,%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	0f 85 fd fe ff ff    	jne    80231c <alloc_block_BF+0x1a>
  80241f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802423:	0f 85 f3 fe ff ff    	jne    80231c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802429:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80242d:	0f 84 d9 00 00 00    	je     80250c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802433:	a1 48 41 80 00       	mov    0x804148,%eax
  802438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80243b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802441:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802447:	8b 55 08             	mov    0x8(%ebp),%edx
  80244a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80244d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802451:	75 17                	jne    80246a <alloc_block_BF+0x168>
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 44 3e 80 00       	push   $0x803e44
  80245b:	68 c7 00 00 00       	push   $0xc7
  802460:	68 9b 3d 80 00       	push   $0x803d9b
  802465:	e8 76 0e 00 00       	call   8032e0 <_panic>
  80246a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 10                	je     802483 <alloc_block_BF+0x181>
  802473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80247b:	8b 52 04             	mov    0x4(%edx),%edx
  80247e:	89 50 04             	mov    %edx,0x4(%eax)
  802481:	eb 0b                	jmp    80248e <alloc_block_BF+0x18c>
  802483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80248e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 0f                	je     8024a7 <alloc_block_BF+0x1a5>
  802498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a1:	8b 12                	mov    (%edx),%edx
  8024a3:	89 10                	mov    %edx,(%eax)
  8024a5:	eb 0a                	jmp    8024b1 <alloc_block_BF+0x1af>
  8024a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8024b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c4:	a1 54 41 80 00       	mov    0x804154,%eax
  8024c9:	48                   	dec    %eax
  8024ca:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8024cf:	83 ec 08             	sub    $0x8,%esp
  8024d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8024d5:	68 38 41 80 00       	push   $0x804138
  8024da:	e8 71 f9 ff ff       	call   801e50 <find_block>
  8024df:	83 c4 10             	add    $0x10,%esp
  8024e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8024e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024e8:	8b 50 08             	mov    0x8(%eax),%edx
  8024eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ee:	01 c2                	add    %eax,%edx
  8024f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8024f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ff:	89 c2                	mov    %eax,%edx
  802501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802504:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250a:	eb 05                	jmp    802511 <alloc_block_BF+0x20f>
	}
	return NULL;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802519:	a1 28 40 80 00       	mov    0x804028,%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	0f 85 de 01 00 00    	jne    802704 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802526:	a1 38 41 80 00       	mov    0x804138,%eax
  80252b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252e:	e9 9e 01 00 00       	jmp    8026d1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 0c             	mov    0xc(%eax),%eax
  802539:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253c:	0f 82 87 01 00 00    	jb     8026c9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 0c             	mov    0xc(%eax),%eax
  802548:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254b:	0f 85 95 00 00 00    	jne    8025e6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	75 17                	jne    80256e <alloc_block_NF+0x5b>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 44 3e 80 00       	push   $0x803e44
  80255f:	68 e0 00 00 00       	push   $0xe0
  802564:	68 9b 3d 80 00       	push   $0x803d9b
  802569:	e8 72 0d 00 00       	call   8032e0 <_panic>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 00                	mov    (%eax),%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	74 10                	je     802587 <alloc_block_NF+0x74>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257f:	8b 52 04             	mov    0x4(%edx),%edx
  802582:	89 50 04             	mov    %edx,0x4(%eax)
  802585:	eb 0b                	jmp    802592 <alloc_block_NF+0x7f>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 04             	mov    0x4(%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 0f                	je     8025ab <alloc_block_NF+0x98>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a5:	8b 12                	mov    (%edx),%edx
  8025a7:	89 10                	mov    %edx,(%eax)
  8025a9:	eb 0a                	jmp    8025b5 <alloc_block_NF+0xa2>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	a3 38 41 80 00       	mov    %eax,0x804138
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c8:	a1 44 41 80 00       	mov    0x804144,%eax
  8025cd:	48                   	dec    %eax
  8025ce:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 08             	mov    0x8(%eax),%eax
  8025d9:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	e9 f8 04 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ef:	0f 86 d4 00 00 00    	jbe    8026c9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025f5:	a1 48 41 80 00       	mov    0x804148,%eax
  8025fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 50 08             	mov    0x8(%eax),%edx
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260c:	8b 55 08             	mov    0x8(%ebp),%edx
  80260f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802616:	75 17                	jne    80262f <alloc_block_NF+0x11c>
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	68 44 3e 80 00       	push   $0x803e44
  802620:	68 e9 00 00 00       	push   $0xe9
  802625:	68 9b 3d 80 00       	push   $0x803d9b
  80262a:	e8 b1 0c 00 00       	call   8032e0 <_panic>
  80262f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 10                	je     802648 <alloc_block_NF+0x135>
  802638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802640:	8b 52 04             	mov    0x4(%edx),%edx
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	eb 0b                	jmp    802653 <alloc_block_NF+0x140>
  802648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 0f                	je     80266c <alloc_block_NF+0x159>
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802666:	8b 12                	mov    (%edx),%edx
  802668:	89 10                	mov    %edx,(%eax)
  80266a:	eb 0a                	jmp    802676 <alloc_block_NF+0x163>
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	a3 48 41 80 00       	mov    %eax,0x804148
  802676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802689:	a1 54 41 80 00       	mov    0x804154,%eax
  80268e:	48                   	dec    %eax
  80268f:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802694:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802697:	8b 40 08             	mov    0x8(%eax),%eax
  80269a:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 50 08             	mov    0x8(%eax),%edx
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	01 c2                	add    %eax,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b9:	89 c2                	mov    %eax,%edx
  8026bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026be:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	e9 15 04 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	74 07                	je     8026de <alloc_block_NF+0x1cb>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	eb 05                	jmp    8026e3 <alloc_block_NF+0x1d0>
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e3:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 85 3e fe ff ff    	jne    802533 <alloc_block_NF+0x20>
  8026f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f9:	0f 85 34 fe ff ff    	jne    802533 <alloc_block_NF+0x20>
  8026ff:	e9 d5 03 00 00       	jmp    802ad9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802704:	a1 38 41 80 00       	mov    0x804138,%eax
  802709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270c:	e9 b1 01 00 00       	jmp    8028c2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 50 08             	mov    0x8(%eax),%edx
  802717:	a1 28 40 80 00       	mov    0x804028,%eax
  80271c:	39 c2                	cmp    %eax,%edx
  80271e:	0f 82 96 01 00 00    	jb     8028ba <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272d:	0f 82 87 01 00 00    	jb     8028ba <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 0c             	mov    0xc(%eax),%eax
  802739:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273c:	0f 85 95 00 00 00    	jne    8027d7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	75 17                	jne    80275f <alloc_block_NF+0x24c>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 44 3e 80 00       	push   $0x803e44
  802750:	68 fc 00 00 00       	push   $0xfc
  802755:	68 9b 3d 80 00       	push   $0x803d9b
  80275a:	e8 81 0b 00 00       	call   8032e0 <_panic>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 10                	je     802778 <alloc_block_NF+0x265>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 52 04             	mov    0x4(%edx),%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	eb 0b                	jmp    802783 <alloc_block_NF+0x270>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0f                	je     80279c <alloc_block_NF+0x289>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	8b 12                	mov    (%edx),%edx
  802798:	89 10                	mov    %edx,(%eax)
  80279a:	eb 0a                	jmp    8027a6 <alloc_block_NF+0x293>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8027be:	48                   	dec    %eax
  8027bf:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ca:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	e9 07 03 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e0:	0f 86 d4 00 00 00    	jbe    8028ba <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8027eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 50 08             	mov    0x8(%eax),%edx
  8027f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8027fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802800:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802803:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802807:	75 17                	jne    802820 <alloc_block_NF+0x30d>
  802809:	83 ec 04             	sub    $0x4,%esp
  80280c:	68 44 3e 80 00       	push   $0x803e44
  802811:	68 04 01 00 00       	push   $0x104
  802816:	68 9b 3d 80 00       	push   $0x803d9b
  80281b:	e8 c0 0a 00 00       	call   8032e0 <_panic>
  802820:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	85 c0                	test   %eax,%eax
  802827:	74 10                	je     802839 <alloc_block_NF+0x326>
  802829:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282c:	8b 00                	mov    (%eax),%eax
  80282e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802831:	8b 52 04             	mov    0x4(%edx),%edx
  802834:	89 50 04             	mov    %edx,0x4(%eax)
  802837:	eb 0b                	jmp    802844 <alloc_block_NF+0x331>
  802839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802844:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	85 c0                	test   %eax,%eax
  80284c:	74 0f                	je     80285d <alloc_block_NF+0x34a>
  80284e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802851:	8b 40 04             	mov    0x4(%eax),%eax
  802854:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802857:	8b 12                	mov    (%edx),%edx
  802859:	89 10                	mov    %edx,(%eax)
  80285b:	eb 0a                	jmp    802867 <alloc_block_NF+0x354>
  80285d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	a3 48 41 80 00       	mov    %eax,0x804148
  802867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802870:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287a:	a1 54 41 80 00       	mov    0x804154,%eax
  80287f:	48                   	dec    %eax
  802880:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802885:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802888:	8b 40 08             	mov    0x8(%eax),%eax
  80288b:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 50 08             	mov    0x8(%eax),%edx
  802896:	8b 45 08             	mov    0x8(%ebp),%eax
  802899:	01 c2                	add    %eax,%edx
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8028aa:	89 c2                	mov    %eax,%edx
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8028b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b5:	e9 24 02 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ba:	a1 40 41 80 00       	mov    0x804140,%eax
  8028bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c6:	74 07                	je     8028cf <alloc_block_NF+0x3bc>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	eb 05                	jmp    8028d4 <alloc_block_NF+0x3c1>
  8028cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d4:	a3 40 41 80 00       	mov    %eax,0x804140
  8028d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	0f 85 2b fe ff ff    	jne    802711 <alloc_block_NF+0x1fe>
  8028e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ea:	0f 85 21 fe ff ff    	jne    802711 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f8:	e9 ae 01 00 00       	jmp    802aab <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 50 08             	mov    0x8(%eax),%edx
  802903:	a1 28 40 80 00       	mov    0x804028,%eax
  802908:	39 c2                	cmp    %eax,%edx
  80290a:	0f 83 93 01 00 00    	jae    802aa3 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 40 0c             	mov    0xc(%eax),%eax
  802916:	3b 45 08             	cmp    0x8(%ebp),%eax
  802919:	0f 82 84 01 00 00    	jb     802aa3 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 40 0c             	mov    0xc(%eax),%eax
  802925:	3b 45 08             	cmp    0x8(%ebp),%eax
  802928:	0f 85 95 00 00 00    	jne    8029c3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802932:	75 17                	jne    80294b <alloc_block_NF+0x438>
  802934:	83 ec 04             	sub    $0x4,%esp
  802937:	68 44 3e 80 00       	push   $0x803e44
  80293c:	68 14 01 00 00       	push   $0x114
  802941:	68 9b 3d 80 00       	push   $0x803d9b
  802946:	e8 95 09 00 00       	call   8032e0 <_panic>
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	74 10                	je     802964 <alloc_block_NF+0x451>
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 00                	mov    (%eax),%eax
  802959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295c:	8b 52 04             	mov    0x4(%edx),%edx
  80295f:	89 50 04             	mov    %edx,0x4(%eax)
  802962:	eb 0b                	jmp    80296f <alloc_block_NF+0x45c>
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 04             	mov    0x4(%eax),%eax
  80296a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 0f                	je     802988 <alloc_block_NF+0x475>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802982:	8b 12                	mov    (%edx),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	eb 0a                	jmp    802992 <alloc_block_NF+0x47f>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	a3 38 41 80 00       	mov    %eax,0x804138
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a5:	a1 44 41 80 00       	mov    0x804144,%eax
  8029aa:	48                   	dec    %eax
  8029ab:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8029b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b3:	8b 40 08             	mov    0x8(%eax),%eax
  8029b6:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	e9 1b 01 00 00       	jmp    802ade <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cc:	0f 86 d1 00 00 00    	jbe    802aa3 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8029d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ec:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f3:	75 17                	jne    802a0c <alloc_block_NF+0x4f9>
  8029f5:	83 ec 04             	sub    $0x4,%esp
  8029f8:	68 44 3e 80 00       	push   $0x803e44
  8029fd:	68 1c 01 00 00       	push   $0x11c
  802a02:	68 9b 3d 80 00       	push   $0x803d9b
  802a07:	e8 d4 08 00 00       	call   8032e0 <_panic>
  802a0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0f:	8b 00                	mov    (%eax),%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	74 10                	je     802a25 <alloc_block_NF+0x512>
  802a15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a18:	8b 00                	mov    (%eax),%eax
  802a1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1d:	8b 52 04             	mov    0x4(%edx),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	eb 0b                	jmp    802a30 <alloc_block_NF+0x51d>
  802a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a28:	8b 40 04             	mov    0x4(%eax),%eax
  802a2b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 0f                	je     802a49 <alloc_block_NF+0x536>
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a43:	8b 12                	mov    (%edx),%edx
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	eb 0a                	jmp    802a53 <alloc_block_NF+0x540>
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	8b 00                	mov    (%eax),%eax
  802a4e:	a3 48 41 80 00       	mov    %eax,0x804148
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a66:	a1 54 41 80 00       	mov    0x804154,%eax
  802a6b:	48                   	dec    %eax
  802a6c:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a74:	8b 40 08             	mov    0x8(%eax),%eax
  802a77:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 50 08             	mov    0x8(%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	01 c2                	add    %eax,%edx
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 40 0c             	mov    0xc(%eax),%eax
  802a93:	2b 45 08             	sub    0x8(%ebp),%eax
  802a96:	89 c2                	mov    %eax,%edx
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa1:	eb 3b                	jmp    802ade <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa3:	a1 40 41 80 00       	mov    0x804140,%eax
  802aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	74 07                	je     802ab8 <alloc_block_NF+0x5a5>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	eb 05                	jmp    802abd <alloc_block_NF+0x5aa>
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  802abd:	a3 40 41 80 00       	mov    %eax,0x804140
  802ac2:	a1 40 41 80 00       	mov    0x804140,%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	0f 85 2e fe ff ff    	jne    8028fd <alloc_block_NF+0x3ea>
  802acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad3:	0f 85 24 fe ff ff    	jne    8028fd <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ae6:	a1 38 41 80 00       	mov    0x804138,%eax
  802aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802aee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802af6:	a1 38 41 80 00       	mov    0x804138,%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 14                	je     802b13 <insert_sorted_with_merge_freeList+0x33>
  802aff:	8b 45 08             	mov    0x8(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	0f 87 9b 01 00 00    	ja     802cae <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b17:	75 17                	jne    802b30 <insert_sorted_with_merge_freeList+0x50>
  802b19:	83 ec 04             	sub    $0x4,%esp
  802b1c:	68 78 3d 80 00       	push   $0x803d78
  802b21:	68 38 01 00 00       	push   $0x138
  802b26:	68 9b 3d 80 00       	push   $0x803d9b
  802b2b:	e8 b0 07 00 00       	call   8032e0 <_panic>
  802b30:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	89 10                	mov    %edx,(%eax)
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	74 0d                	je     802b51 <insert_sorted_with_merge_freeList+0x71>
  802b44:	a1 38 41 80 00       	mov    0x804138,%eax
  802b49:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4c:	89 50 04             	mov    %edx,0x4(%eax)
  802b4f:	eb 08                	jmp    802b59 <insert_sorted_with_merge_freeList+0x79>
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	a3 38 41 80 00       	mov    %eax,0x804138
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802b70:	40                   	inc    %eax
  802b71:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b7a:	0f 84 a8 06 00 00    	je     803228 <insert_sorted_with_merge_freeList+0x748>
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 50 08             	mov    0x8(%eax),%edx
  802b86:	8b 45 08             	mov    0x8(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	01 c2                	add    %eax,%edx
  802b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b91:	8b 40 08             	mov    0x8(%eax),%eax
  802b94:	39 c2                	cmp    %eax,%edx
  802b96:	0f 85 8c 06 00 00    	jne    803228 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba8:	01 c2                	add    %eax,%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802bb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bb4:	75 17                	jne    802bcd <insert_sorted_with_merge_freeList+0xed>
  802bb6:	83 ec 04             	sub    $0x4,%esp
  802bb9:	68 44 3e 80 00       	push   $0x803e44
  802bbe:	68 3c 01 00 00       	push   $0x13c
  802bc3:	68 9b 3d 80 00       	push   $0x803d9b
  802bc8:	e8 13 07 00 00       	call   8032e0 <_panic>
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	74 10                	je     802be6 <insert_sorted_with_merge_freeList+0x106>
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 00                	mov    (%eax),%eax
  802bdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bde:	8b 52 04             	mov    0x4(%edx),%edx
  802be1:	89 50 04             	mov    %edx,0x4(%eax)
  802be4:	eb 0b                	jmp    802bf1 <insert_sorted_with_merge_freeList+0x111>
  802be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 40 04             	mov    0x4(%eax),%eax
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	74 0f                	je     802c0a <insert_sorted_with_merge_freeList+0x12a>
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c04:	8b 12                	mov    (%edx),%edx
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	eb 0a                	jmp    802c14 <insert_sorted_with_merge_freeList+0x134>
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2c:	48                   	dec    %eax
  802c2d:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802c46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c4a:	75 17                	jne    802c63 <insert_sorted_with_merge_freeList+0x183>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 78 3d 80 00       	push   $0x803d78
  802c54:	68 3f 01 00 00       	push   $0x13f
  802c59:	68 9b 3d 80 00       	push   $0x803d9b
  802c5e:	e8 7d 06 00 00       	call   8032e0 <_panic>
  802c63:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0d                	je     802c84 <insert_sorted_with_merge_freeList+0x1a4>
  802c77:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 08                	jmp    802c8c <insert_sorted_with_merge_freeList+0x1ac>
  802c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c87:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ca9:	e9 7a 05 00 00       	jmp    803228 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 50 08             	mov    0x8(%eax),%edx
  802cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	39 c2                	cmp    %eax,%edx
  802cbc:	0f 82 14 01 00 00    	jb     802dd6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802cc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc5:	8b 50 08             	mov    0x8(%eax),%edx
  802cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cce:	01 c2                	add    %eax,%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	39 c2                	cmp    %eax,%edx
  802cd8:	0f 85 90 00 00 00    	jne    802d6e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cea:	01 c2                	add    %eax,%edx
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0a:	75 17                	jne    802d23 <insert_sorted_with_merge_freeList+0x243>
  802d0c:	83 ec 04             	sub    $0x4,%esp
  802d0f:	68 78 3d 80 00       	push   $0x803d78
  802d14:	68 49 01 00 00       	push   $0x149
  802d19:	68 9b 3d 80 00       	push   $0x803d9b
  802d1e:	e8 bd 05 00 00       	call   8032e0 <_panic>
  802d23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	89 10                	mov    %edx,(%eax)
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 00                	mov    (%eax),%eax
  802d33:	85 c0                	test   %eax,%eax
  802d35:	74 0d                	je     802d44 <insert_sorted_with_merge_freeList+0x264>
  802d37:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 08                	jmp    802d4c <insert_sorted_with_merge_freeList+0x26c>
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d63:	40                   	inc    %eax
  802d64:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d69:	e9 bb 04 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d72:	75 17                	jne    802d8b <insert_sorted_with_merge_freeList+0x2ab>
  802d74:	83 ec 04             	sub    $0x4,%esp
  802d77:	68 ec 3d 80 00       	push   $0x803dec
  802d7c:	68 4c 01 00 00       	push   $0x14c
  802d81:	68 9b 3d 80 00       	push   $0x803d9b
  802d86:	e8 55 05 00 00       	call   8032e0 <_panic>
  802d8b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	89 50 04             	mov    %edx,0x4(%eax)
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 0c                	je     802dad <insert_sorted_with_merge_freeList+0x2cd>
  802da1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802da6:	8b 55 08             	mov    0x8(%ebp),%edx
  802da9:	89 10                	mov    %edx,(%eax)
  802dab:	eb 08                	jmp    802db5 <insert_sorted_with_merge_freeList+0x2d5>
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	a3 38 41 80 00       	mov    %eax,0x804138
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc6:	a1 44 41 80 00       	mov    0x804144,%eax
  802dcb:	40                   	inc    %eax
  802dcc:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dd1:	e9 53 04 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802dd6:	a1 38 41 80 00       	mov    0x804138,%eax
  802ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dde:	e9 15 04 00 00       	jmp    8031f8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 50 08             	mov    0x8(%eax),%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 40 08             	mov    0x8(%eax),%eax
  802df7:	39 c2                	cmp    %eax,%edx
  802df9:	0f 86 f1 03 00 00    	jbe    8031f0 <insert_sorted_with_merge_freeList+0x710>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	8b 50 08             	mov    0x8(%eax),%edx
  802e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e08:	8b 40 08             	mov    0x8(%eax),%eax
  802e0b:	39 c2                	cmp    %eax,%edx
  802e0d:	0f 83 dd 03 00 00    	jae    8031f0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 50 08             	mov    0x8(%eax),%edx
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	01 c2                	add    %eax,%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	8b 40 08             	mov    0x8(%eax),%eax
  802e27:	39 c2                	cmp    %eax,%edx
  802e29:	0f 85 b9 01 00 00    	jne    802fe8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3b:	01 c2                	add    %eax,%edx
  802e3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e40:	8b 40 08             	mov    0x8(%eax),%eax
  802e43:	39 c2                	cmp    %eax,%edx
  802e45:	0f 85 0d 01 00 00    	jne    802f58 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	01 c2                	add    %eax,%edx
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802e5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e63:	75 17                	jne    802e7c <insert_sorted_with_merge_freeList+0x39c>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 44 3e 80 00       	push   $0x803e44
  802e6d:	68 5c 01 00 00       	push   $0x15c
  802e72:	68 9b 3d 80 00       	push   $0x803d9b
  802e77:	e8 64 04 00 00       	call   8032e0 <_panic>
  802e7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 10                	je     802e95 <insert_sorted_with_merge_freeList+0x3b5>
  802e85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e8d:	8b 52 04             	mov    0x4(%edx),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	eb 0b                	jmp    802ea0 <insert_sorted_with_merge_freeList+0x3c0>
  802e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ea0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	74 0f                	je     802eb9 <insert_sorted_with_merge_freeList+0x3d9>
  802eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ead:	8b 40 04             	mov    0x4(%eax),%eax
  802eb0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb3:	8b 12                	mov    (%edx),%edx
  802eb5:	89 10                	mov    %edx,(%eax)
  802eb7:	eb 0a                	jmp    802ec3 <insert_sorted_with_merge_freeList+0x3e3>
  802eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	a3 38 41 80 00       	mov    %eax,0x804138
  802ec3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed6:	a1 44 41 80 00       	mov    0x804144,%eax
  802edb:	48                   	dec    %eax
  802edc:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eee:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ef5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef9:	75 17                	jne    802f12 <insert_sorted_with_merge_freeList+0x432>
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	68 78 3d 80 00       	push   $0x803d78
  802f03:	68 5f 01 00 00       	push   $0x15f
  802f08:	68 9b 3d 80 00       	push   $0x803d9b
  802f0d:	e8 ce 03 00 00       	call   8032e0 <_panic>
  802f12:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	74 0d                	je     802f33 <insert_sorted_with_merge_freeList+0x453>
  802f26:	a1 48 41 80 00       	mov    0x804148,%eax
  802f2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	eb 08                	jmp    802f3b <insert_sorted_with_merge_freeList+0x45b>
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f52:	40                   	inc    %eax
  802f53:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	8b 40 0c             	mov    0xc(%eax),%eax
  802f64:	01 c2                	add    %eax,%edx
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f84:	75 17                	jne    802f9d <insert_sorted_with_merge_freeList+0x4bd>
  802f86:	83 ec 04             	sub    $0x4,%esp
  802f89:	68 78 3d 80 00       	push   $0x803d78
  802f8e:	68 64 01 00 00       	push   $0x164
  802f93:	68 9b 3d 80 00       	push   $0x803d9b
  802f98:	e8 43 03 00 00       	call   8032e0 <_panic>
  802f9d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	74 0d                	je     802fbe <insert_sorted_with_merge_freeList+0x4de>
  802fb1:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb9:	89 50 04             	mov    %edx,0x4(%eax)
  802fbc:	eb 08                	jmp    802fc6 <insert_sorted_with_merge_freeList+0x4e6>
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	a3 48 41 80 00       	mov    %eax,0x804148
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 54 41 80 00       	mov    0x804154,%eax
  802fdd:	40                   	inc    %eax
  802fde:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802fe3:	e9 41 02 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 50 08             	mov    0x8(%eax),%edx
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff4:	01 c2                	add    %eax,%edx
  802ff6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff9:	8b 40 08             	mov    0x8(%eax),%eax
  802ffc:	39 c2                	cmp    %eax,%edx
  802ffe:	0f 85 7c 01 00 00    	jne    803180 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803004:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803008:	74 06                	je     803010 <insert_sorted_with_merge_freeList+0x530>
  80300a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300e:	75 17                	jne    803027 <insert_sorted_with_merge_freeList+0x547>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 b4 3d 80 00       	push   $0x803db4
  803018:	68 69 01 00 00       	push   $0x169
  80301d:	68 9b 3d 80 00       	push   $0x803d9b
  803022:	e8 b9 02 00 00       	call   8032e0 <_panic>
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 50 04             	mov    0x4(%eax),%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	89 50 04             	mov    %edx,0x4(%eax)
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	8b 40 04             	mov    0x4(%eax),%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	74 0d                	je     803052 <insert_sorted_with_merge_freeList+0x572>
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	8b 55 08             	mov    0x8(%ebp),%edx
  80304e:	89 10                	mov    %edx,(%eax)
  803050:	eb 08                	jmp    80305a <insert_sorted_with_merge_freeList+0x57a>
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	a3 38 41 80 00       	mov    %eax,0x804138
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	a1 44 41 80 00       	mov    0x804144,%eax
  803068:	40                   	inc    %eax
  803069:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	8b 50 0c             	mov    0xc(%eax),%edx
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803082:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803086:	75 17                	jne    80309f <insert_sorted_with_merge_freeList+0x5bf>
  803088:	83 ec 04             	sub    $0x4,%esp
  80308b:	68 44 3e 80 00       	push   $0x803e44
  803090:	68 6b 01 00 00       	push   $0x16b
  803095:	68 9b 3d 80 00       	push   $0x803d9b
  80309a:	e8 41 02 00 00       	call   8032e0 <_panic>
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	8b 00                	mov    (%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 10                	je     8030b8 <insert_sorted_with_merge_freeList+0x5d8>
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	8b 00                	mov    (%eax),%eax
  8030ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b0:	8b 52 04             	mov    0x4(%edx),%edx
  8030b3:	89 50 04             	mov    %edx,0x4(%eax)
  8030b6:	eb 0b                	jmp    8030c3 <insert_sorted_with_merge_freeList+0x5e3>
  8030b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bb:	8b 40 04             	mov    0x4(%eax),%eax
  8030be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	8b 40 04             	mov    0x4(%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0f                	je     8030dc <insert_sorted_with_merge_freeList+0x5fc>
  8030cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d0:	8b 40 04             	mov    0x4(%eax),%eax
  8030d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d6:	8b 12                	mov    (%edx),%edx
  8030d8:	89 10                	mov    %edx,(%eax)
  8030da:	eb 0a                	jmp    8030e6 <insert_sorted_with_merge_freeList+0x606>
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	a3 38 41 80 00       	mov    %eax,0x804138
  8030e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f9:	a1 44 41 80 00       	mov    0x804144,%eax
  8030fe:	48                   	dec    %eax
  8030ff:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803104:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803107:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803118:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311c:	75 17                	jne    803135 <insert_sorted_with_merge_freeList+0x655>
  80311e:	83 ec 04             	sub    $0x4,%esp
  803121:	68 78 3d 80 00       	push   $0x803d78
  803126:	68 6e 01 00 00       	push   $0x16e
  80312b:	68 9b 3d 80 00       	push   $0x803d9b
  803130:	e8 ab 01 00 00       	call   8032e0 <_panic>
  803135:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	85 c0                	test   %eax,%eax
  803147:	74 0d                	je     803156 <insert_sorted_with_merge_freeList+0x676>
  803149:	a1 48 41 80 00       	mov    0x804148,%eax
  80314e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803151:	89 50 04             	mov    %edx,0x4(%eax)
  803154:	eb 08                	jmp    80315e <insert_sorted_with_merge_freeList+0x67e>
  803156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803159:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	a3 48 41 80 00       	mov    %eax,0x804148
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803170:	a1 54 41 80 00       	mov    0x804154,%eax
  803175:	40                   	inc    %eax
  803176:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80317b:	e9 a9 00 00 00       	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803180:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803184:	74 06                	je     80318c <insert_sorted_with_merge_freeList+0x6ac>
  803186:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80318a:	75 17                	jne    8031a3 <insert_sorted_with_merge_freeList+0x6c3>
  80318c:	83 ec 04             	sub    $0x4,%esp
  80318f:	68 10 3e 80 00       	push   $0x803e10
  803194:	68 73 01 00 00       	push   $0x173
  803199:	68 9b 3d 80 00       	push   $0x803d9b
  80319e:	e8 3d 01 00 00       	call   8032e0 <_panic>
  8031a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a6:	8b 10                	mov    (%eax),%edx
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 00                	mov    (%eax),%eax
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	74 0b                	je     8031c1 <insert_sorted_with_merge_freeList+0x6e1>
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031be:	89 50 04             	mov    %edx,0x4(%eax)
  8031c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c7:	89 10                	mov    %edx,(%eax)
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031cf:	89 50 04             	mov    %edx,0x4(%eax)
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	85 c0                	test   %eax,%eax
  8031d9:	75 08                	jne    8031e3 <insert_sorted_with_merge_freeList+0x703>
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031e3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031e8:	40                   	inc    %eax
  8031e9:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8031ee:	eb 39                	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031fc:	74 07                	je     803205 <insert_sorted_with_merge_freeList+0x725>
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	8b 00                	mov    (%eax),%eax
  803203:	eb 05                	jmp    80320a <insert_sorted_with_merge_freeList+0x72a>
  803205:	b8 00 00 00 00       	mov    $0x0,%eax
  80320a:	a3 40 41 80 00       	mov    %eax,0x804140
  80320f:	a1 40 41 80 00       	mov    0x804140,%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	0f 85 c7 fb ff ff    	jne    802de3 <insert_sorted_with_merge_freeList+0x303>
  80321c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803220:	0f 85 bd fb ff ff    	jne    802de3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803226:	eb 01                	jmp    803229 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803228:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803229:	90                   	nop
  80322a:	c9                   	leave  
  80322b:	c3                   	ret    

0080322c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80322c:	55                   	push   %ebp
  80322d:	89 e5                	mov    %esp,%ebp
  80322f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803232:	8b 55 08             	mov    0x8(%ebp),%edx
  803235:	89 d0                	mov    %edx,%eax
  803237:	c1 e0 02             	shl    $0x2,%eax
  80323a:	01 d0                	add    %edx,%eax
  80323c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803243:	01 d0                	add    %edx,%eax
  803245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80324c:	01 d0                	add    %edx,%eax
  80324e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803255:	01 d0                	add    %edx,%eax
  803257:	c1 e0 04             	shl    $0x4,%eax
  80325a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80325d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803264:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803267:	83 ec 0c             	sub    $0xc,%esp
  80326a:	50                   	push   %eax
  80326b:	e8 26 e7 ff ff       	call   801996 <sys_get_virtual_time>
  803270:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803273:	eb 41                	jmp    8032b6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803275:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803278:	83 ec 0c             	sub    $0xc,%esp
  80327b:	50                   	push   %eax
  80327c:	e8 15 e7 ff ff       	call   801996 <sys_get_virtual_time>
  803281:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803284:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328a:	29 c2                	sub    %eax,%edx
  80328c:	89 d0                	mov    %edx,%eax
  80328e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803297:	89 d1                	mov    %edx,%ecx
  803299:	29 c1                	sub    %eax,%ecx
  80329b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80329e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a1:	39 c2                	cmp    %eax,%edx
  8032a3:	0f 97 c0             	seta   %al
  8032a6:	0f b6 c0             	movzbl %al,%eax
  8032a9:	29 c1                	sub    %eax,%ecx
  8032ab:	89 c8                	mov    %ecx,%eax
  8032ad:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032bc:	72 b7                	jb     803275 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032be:	90                   	nop
  8032bf:	c9                   	leave  
  8032c0:	c3                   	ret    

008032c1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8032c1:	55                   	push   %ebp
  8032c2:	89 e5                	mov    %esp,%ebp
  8032c4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8032c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8032ce:	eb 03                	jmp    8032d3 <busy_wait+0x12>
  8032d0:	ff 45 fc             	incl   -0x4(%ebp)
  8032d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032d9:	72 f5                	jb     8032d0 <busy_wait+0xf>
	return i;
  8032db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8032de:	c9                   	leave  
  8032df:	c3                   	ret    

008032e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8032e6:	8d 45 10             	lea    0x10(%ebp),%eax
  8032e9:	83 c0 04             	add    $0x4,%eax
  8032ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8032ef:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8032f4:	85 c0                	test   %eax,%eax
  8032f6:	74 16                	je     80330e <_panic+0x2e>
		cprintf("%s: ", argv0);
  8032f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8032fd:	83 ec 08             	sub    $0x8,%esp
  803300:	50                   	push   %eax
  803301:	68 64 3e 80 00       	push   $0x803e64
  803306:	e8 70 d0 ff ff       	call   80037b <cprintf>
  80330b:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80330e:	a1 00 40 80 00       	mov    0x804000,%eax
  803313:	ff 75 0c             	pushl  0xc(%ebp)
  803316:	ff 75 08             	pushl  0x8(%ebp)
  803319:	50                   	push   %eax
  80331a:	68 69 3e 80 00       	push   $0x803e69
  80331f:	e8 57 d0 ff ff       	call   80037b <cprintf>
  803324:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803327:	8b 45 10             	mov    0x10(%ebp),%eax
  80332a:	83 ec 08             	sub    $0x8,%esp
  80332d:	ff 75 f4             	pushl  -0xc(%ebp)
  803330:	50                   	push   %eax
  803331:	e8 da cf ff ff       	call   800310 <vcprintf>
  803336:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803339:	83 ec 08             	sub    $0x8,%esp
  80333c:	6a 00                	push   $0x0
  80333e:	68 85 3e 80 00       	push   $0x803e85
  803343:	e8 c8 cf ff ff       	call   800310 <vcprintf>
  803348:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80334b:	e8 49 cf ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  803350:	eb fe                	jmp    803350 <_panic+0x70>

00803352 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803352:	55                   	push   %ebp
  803353:	89 e5                	mov    %esp,%ebp
  803355:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803358:	a1 20 40 80 00       	mov    0x804020,%eax
  80335d:	8b 50 74             	mov    0x74(%eax),%edx
  803360:	8b 45 0c             	mov    0xc(%ebp),%eax
  803363:	39 c2                	cmp    %eax,%edx
  803365:	74 14                	je     80337b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803367:	83 ec 04             	sub    $0x4,%esp
  80336a:	68 88 3e 80 00       	push   $0x803e88
  80336f:	6a 26                	push   $0x26
  803371:	68 d4 3e 80 00       	push   $0x803ed4
  803376:	e8 65 ff ff ff       	call   8032e0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80337b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803382:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803389:	e9 c2 00 00 00       	jmp    803450 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80338e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803391:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803398:	8b 45 08             	mov    0x8(%ebp),%eax
  80339b:	01 d0                	add    %edx,%eax
  80339d:	8b 00                	mov    (%eax),%eax
  80339f:	85 c0                	test   %eax,%eax
  8033a1:	75 08                	jne    8033ab <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8033a3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8033a6:	e9 a2 00 00 00       	jmp    80344d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8033ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8033b9:	eb 69                	jmp    803424 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8033bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8033c0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c9:	89 d0                	mov    %edx,%eax
  8033cb:	01 c0                	add    %eax,%eax
  8033cd:	01 d0                	add    %edx,%eax
  8033cf:	c1 e0 03             	shl    $0x3,%eax
  8033d2:	01 c8                	add    %ecx,%eax
  8033d4:	8a 40 04             	mov    0x4(%eax),%al
  8033d7:	84 c0                	test   %al,%al
  8033d9:	75 46                	jne    803421 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8033db:	a1 20 40 80 00       	mov    0x804020,%eax
  8033e0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033e9:	89 d0                	mov    %edx,%eax
  8033eb:	01 c0                	add    %eax,%eax
  8033ed:	01 d0                	add    %edx,%eax
  8033ef:	c1 e0 03             	shl    $0x3,%eax
  8033f2:	01 c8                	add    %ecx,%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803401:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803406:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	01 c8                	add    %ecx,%eax
  803412:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803414:	39 c2                	cmp    %eax,%edx
  803416:	75 09                	jne    803421 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803418:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80341f:	eb 12                	jmp    803433 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803421:	ff 45 e8             	incl   -0x18(%ebp)
  803424:	a1 20 40 80 00       	mov    0x804020,%eax
  803429:	8b 50 74             	mov    0x74(%eax),%edx
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	39 c2                	cmp    %eax,%edx
  803431:	77 88                	ja     8033bb <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803433:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803437:	75 14                	jne    80344d <CheckWSWithoutLastIndex+0xfb>
			panic(
  803439:	83 ec 04             	sub    $0x4,%esp
  80343c:	68 e0 3e 80 00       	push   $0x803ee0
  803441:	6a 3a                	push   $0x3a
  803443:	68 d4 3e 80 00       	push   $0x803ed4
  803448:	e8 93 fe ff ff       	call   8032e0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80344d:	ff 45 f0             	incl   -0x10(%ebp)
  803450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803453:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803456:	0f 8c 32 ff ff ff    	jl     80338e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80345c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803463:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80346a:	eb 26                	jmp    803492 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80346c:	a1 20 40 80 00       	mov    0x804020,%eax
  803471:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803477:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80347a:	89 d0                	mov    %edx,%eax
  80347c:	01 c0                	add    %eax,%eax
  80347e:	01 d0                	add    %edx,%eax
  803480:	c1 e0 03             	shl    $0x3,%eax
  803483:	01 c8                	add    %ecx,%eax
  803485:	8a 40 04             	mov    0x4(%eax),%al
  803488:	3c 01                	cmp    $0x1,%al
  80348a:	75 03                	jne    80348f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80348c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80348f:	ff 45 e0             	incl   -0x20(%ebp)
  803492:	a1 20 40 80 00       	mov    0x804020,%eax
  803497:	8b 50 74             	mov    0x74(%eax),%edx
  80349a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349d:	39 c2                	cmp    %eax,%edx
  80349f:	77 cb                	ja     80346c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034a7:	74 14                	je     8034bd <CheckWSWithoutLastIndex+0x16b>
		panic(
  8034a9:	83 ec 04             	sub    $0x4,%esp
  8034ac:	68 34 3f 80 00       	push   $0x803f34
  8034b1:	6a 44                	push   $0x44
  8034b3:	68 d4 3e 80 00       	push   $0x803ed4
  8034b8:	e8 23 fe ff ff       	call   8032e0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8034bd:	90                   	nop
  8034be:	c9                   	leave  
  8034bf:	c3                   	ret    

008034c0 <__udivdi3>:
  8034c0:	55                   	push   %ebp
  8034c1:	57                   	push   %edi
  8034c2:	56                   	push   %esi
  8034c3:	53                   	push   %ebx
  8034c4:	83 ec 1c             	sub    $0x1c,%esp
  8034c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034d7:	89 ca                	mov    %ecx,%edx
  8034d9:	89 f8                	mov    %edi,%eax
  8034db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034df:	85 f6                	test   %esi,%esi
  8034e1:	75 2d                	jne    803510 <__udivdi3+0x50>
  8034e3:	39 cf                	cmp    %ecx,%edi
  8034e5:	77 65                	ja     80354c <__udivdi3+0x8c>
  8034e7:	89 fd                	mov    %edi,%ebp
  8034e9:	85 ff                	test   %edi,%edi
  8034eb:	75 0b                	jne    8034f8 <__udivdi3+0x38>
  8034ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f2:	31 d2                	xor    %edx,%edx
  8034f4:	f7 f7                	div    %edi
  8034f6:	89 c5                	mov    %eax,%ebp
  8034f8:	31 d2                	xor    %edx,%edx
  8034fa:	89 c8                	mov    %ecx,%eax
  8034fc:	f7 f5                	div    %ebp
  8034fe:	89 c1                	mov    %eax,%ecx
  803500:	89 d8                	mov    %ebx,%eax
  803502:	f7 f5                	div    %ebp
  803504:	89 cf                	mov    %ecx,%edi
  803506:	89 fa                	mov    %edi,%edx
  803508:	83 c4 1c             	add    $0x1c,%esp
  80350b:	5b                   	pop    %ebx
  80350c:	5e                   	pop    %esi
  80350d:	5f                   	pop    %edi
  80350e:	5d                   	pop    %ebp
  80350f:	c3                   	ret    
  803510:	39 ce                	cmp    %ecx,%esi
  803512:	77 28                	ja     80353c <__udivdi3+0x7c>
  803514:	0f bd fe             	bsr    %esi,%edi
  803517:	83 f7 1f             	xor    $0x1f,%edi
  80351a:	75 40                	jne    80355c <__udivdi3+0x9c>
  80351c:	39 ce                	cmp    %ecx,%esi
  80351e:	72 0a                	jb     80352a <__udivdi3+0x6a>
  803520:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803524:	0f 87 9e 00 00 00    	ja     8035c8 <__udivdi3+0x108>
  80352a:	b8 01 00 00 00       	mov    $0x1,%eax
  80352f:	89 fa                	mov    %edi,%edx
  803531:	83 c4 1c             	add    $0x1c,%esp
  803534:	5b                   	pop    %ebx
  803535:	5e                   	pop    %esi
  803536:	5f                   	pop    %edi
  803537:	5d                   	pop    %ebp
  803538:	c3                   	ret    
  803539:	8d 76 00             	lea    0x0(%esi),%esi
  80353c:	31 ff                	xor    %edi,%edi
  80353e:	31 c0                	xor    %eax,%eax
  803540:	89 fa                	mov    %edi,%edx
  803542:	83 c4 1c             	add    $0x1c,%esp
  803545:	5b                   	pop    %ebx
  803546:	5e                   	pop    %esi
  803547:	5f                   	pop    %edi
  803548:	5d                   	pop    %ebp
  803549:	c3                   	ret    
  80354a:	66 90                	xchg   %ax,%ax
  80354c:	89 d8                	mov    %ebx,%eax
  80354e:	f7 f7                	div    %edi
  803550:	31 ff                	xor    %edi,%edi
  803552:	89 fa                	mov    %edi,%edx
  803554:	83 c4 1c             	add    $0x1c,%esp
  803557:	5b                   	pop    %ebx
  803558:	5e                   	pop    %esi
  803559:	5f                   	pop    %edi
  80355a:	5d                   	pop    %ebp
  80355b:	c3                   	ret    
  80355c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803561:	89 eb                	mov    %ebp,%ebx
  803563:	29 fb                	sub    %edi,%ebx
  803565:	89 f9                	mov    %edi,%ecx
  803567:	d3 e6                	shl    %cl,%esi
  803569:	89 c5                	mov    %eax,%ebp
  80356b:	88 d9                	mov    %bl,%cl
  80356d:	d3 ed                	shr    %cl,%ebp
  80356f:	89 e9                	mov    %ebp,%ecx
  803571:	09 f1                	or     %esi,%ecx
  803573:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803577:	89 f9                	mov    %edi,%ecx
  803579:	d3 e0                	shl    %cl,%eax
  80357b:	89 c5                	mov    %eax,%ebp
  80357d:	89 d6                	mov    %edx,%esi
  80357f:	88 d9                	mov    %bl,%cl
  803581:	d3 ee                	shr    %cl,%esi
  803583:	89 f9                	mov    %edi,%ecx
  803585:	d3 e2                	shl    %cl,%edx
  803587:	8b 44 24 08          	mov    0x8(%esp),%eax
  80358b:	88 d9                	mov    %bl,%cl
  80358d:	d3 e8                	shr    %cl,%eax
  80358f:	09 c2                	or     %eax,%edx
  803591:	89 d0                	mov    %edx,%eax
  803593:	89 f2                	mov    %esi,%edx
  803595:	f7 74 24 0c          	divl   0xc(%esp)
  803599:	89 d6                	mov    %edx,%esi
  80359b:	89 c3                	mov    %eax,%ebx
  80359d:	f7 e5                	mul    %ebp
  80359f:	39 d6                	cmp    %edx,%esi
  8035a1:	72 19                	jb     8035bc <__udivdi3+0xfc>
  8035a3:	74 0b                	je     8035b0 <__udivdi3+0xf0>
  8035a5:	89 d8                	mov    %ebx,%eax
  8035a7:	31 ff                	xor    %edi,%edi
  8035a9:	e9 58 ff ff ff       	jmp    803506 <__udivdi3+0x46>
  8035ae:	66 90                	xchg   %ax,%ax
  8035b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035b4:	89 f9                	mov    %edi,%ecx
  8035b6:	d3 e2                	shl    %cl,%edx
  8035b8:	39 c2                	cmp    %eax,%edx
  8035ba:	73 e9                	jae    8035a5 <__udivdi3+0xe5>
  8035bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035bf:	31 ff                	xor    %edi,%edi
  8035c1:	e9 40 ff ff ff       	jmp    803506 <__udivdi3+0x46>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	31 c0                	xor    %eax,%eax
  8035ca:	e9 37 ff ff ff       	jmp    803506 <__udivdi3+0x46>
  8035cf:	90                   	nop

008035d0 <__umoddi3>:
  8035d0:	55                   	push   %ebp
  8035d1:	57                   	push   %edi
  8035d2:	56                   	push   %esi
  8035d3:	53                   	push   %ebx
  8035d4:	83 ec 1c             	sub    $0x1c,%esp
  8035d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ef:	89 f3                	mov    %esi,%ebx
  8035f1:	89 fa                	mov    %edi,%edx
  8035f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035f7:	89 34 24             	mov    %esi,(%esp)
  8035fa:	85 c0                	test   %eax,%eax
  8035fc:	75 1a                	jne    803618 <__umoddi3+0x48>
  8035fe:	39 f7                	cmp    %esi,%edi
  803600:	0f 86 a2 00 00 00    	jbe    8036a8 <__umoddi3+0xd8>
  803606:	89 c8                	mov    %ecx,%eax
  803608:	89 f2                	mov    %esi,%edx
  80360a:	f7 f7                	div    %edi
  80360c:	89 d0                	mov    %edx,%eax
  80360e:	31 d2                	xor    %edx,%edx
  803610:	83 c4 1c             	add    $0x1c,%esp
  803613:	5b                   	pop    %ebx
  803614:	5e                   	pop    %esi
  803615:	5f                   	pop    %edi
  803616:	5d                   	pop    %ebp
  803617:	c3                   	ret    
  803618:	39 f0                	cmp    %esi,%eax
  80361a:	0f 87 ac 00 00 00    	ja     8036cc <__umoddi3+0xfc>
  803620:	0f bd e8             	bsr    %eax,%ebp
  803623:	83 f5 1f             	xor    $0x1f,%ebp
  803626:	0f 84 ac 00 00 00    	je     8036d8 <__umoddi3+0x108>
  80362c:	bf 20 00 00 00       	mov    $0x20,%edi
  803631:	29 ef                	sub    %ebp,%edi
  803633:	89 fe                	mov    %edi,%esi
  803635:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803639:	89 e9                	mov    %ebp,%ecx
  80363b:	d3 e0                	shl    %cl,%eax
  80363d:	89 d7                	mov    %edx,%edi
  80363f:	89 f1                	mov    %esi,%ecx
  803641:	d3 ef                	shr    %cl,%edi
  803643:	09 c7                	or     %eax,%edi
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 e2                	shl    %cl,%edx
  803649:	89 14 24             	mov    %edx,(%esp)
  80364c:	89 d8                	mov    %ebx,%eax
  80364e:	d3 e0                	shl    %cl,%eax
  803650:	89 c2                	mov    %eax,%edx
  803652:	8b 44 24 08          	mov    0x8(%esp),%eax
  803656:	d3 e0                	shl    %cl,%eax
  803658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80365c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803660:	89 f1                	mov    %esi,%ecx
  803662:	d3 e8                	shr    %cl,%eax
  803664:	09 d0                	or     %edx,%eax
  803666:	d3 eb                	shr    %cl,%ebx
  803668:	89 da                	mov    %ebx,%edx
  80366a:	f7 f7                	div    %edi
  80366c:	89 d3                	mov    %edx,%ebx
  80366e:	f7 24 24             	mull   (%esp)
  803671:	89 c6                	mov    %eax,%esi
  803673:	89 d1                	mov    %edx,%ecx
  803675:	39 d3                	cmp    %edx,%ebx
  803677:	0f 82 87 00 00 00    	jb     803704 <__umoddi3+0x134>
  80367d:	0f 84 91 00 00 00    	je     803714 <__umoddi3+0x144>
  803683:	8b 54 24 04          	mov    0x4(%esp),%edx
  803687:	29 f2                	sub    %esi,%edx
  803689:	19 cb                	sbb    %ecx,%ebx
  80368b:	89 d8                	mov    %ebx,%eax
  80368d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803691:	d3 e0                	shl    %cl,%eax
  803693:	89 e9                	mov    %ebp,%ecx
  803695:	d3 ea                	shr    %cl,%edx
  803697:	09 d0                	or     %edx,%eax
  803699:	89 e9                	mov    %ebp,%ecx
  80369b:	d3 eb                	shr    %cl,%ebx
  80369d:	89 da                	mov    %ebx,%edx
  80369f:	83 c4 1c             	add    $0x1c,%esp
  8036a2:	5b                   	pop    %ebx
  8036a3:	5e                   	pop    %esi
  8036a4:	5f                   	pop    %edi
  8036a5:	5d                   	pop    %ebp
  8036a6:	c3                   	ret    
  8036a7:	90                   	nop
  8036a8:	89 fd                	mov    %edi,%ebp
  8036aa:	85 ff                	test   %edi,%edi
  8036ac:	75 0b                	jne    8036b9 <__umoddi3+0xe9>
  8036ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b3:	31 d2                	xor    %edx,%edx
  8036b5:	f7 f7                	div    %edi
  8036b7:	89 c5                	mov    %eax,%ebp
  8036b9:	89 f0                	mov    %esi,%eax
  8036bb:	31 d2                	xor    %edx,%edx
  8036bd:	f7 f5                	div    %ebp
  8036bf:	89 c8                	mov    %ecx,%eax
  8036c1:	f7 f5                	div    %ebp
  8036c3:	89 d0                	mov    %edx,%eax
  8036c5:	e9 44 ff ff ff       	jmp    80360e <__umoddi3+0x3e>
  8036ca:	66 90                	xchg   %ax,%ax
  8036cc:	89 c8                	mov    %ecx,%eax
  8036ce:	89 f2                	mov    %esi,%edx
  8036d0:	83 c4 1c             	add    $0x1c,%esp
  8036d3:	5b                   	pop    %ebx
  8036d4:	5e                   	pop    %esi
  8036d5:	5f                   	pop    %edi
  8036d6:	5d                   	pop    %ebp
  8036d7:	c3                   	ret    
  8036d8:	3b 04 24             	cmp    (%esp),%eax
  8036db:	72 06                	jb     8036e3 <__umoddi3+0x113>
  8036dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036e1:	77 0f                	ja     8036f2 <__umoddi3+0x122>
  8036e3:	89 f2                	mov    %esi,%edx
  8036e5:	29 f9                	sub    %edi,%ecx
  8036e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036eb:	89 14 24             	mov    %edx,(%esp)
  8036ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036f6:	8b 14 24             	mov    (%esp),%edx
  8036f9:	83 c4 1c             	add    $0x1c,%esp
  8036fc:	5b                   	pop    %ebx
  8036fd:	5e                   	pop    %esi
  8036fe:	5f                   	pop    %edi
  8036ff:	5d                   	pop    %ebp
  803700:	c3                   	ret    
  803701:	8d 76 00             	lea    0x0(%esi),%esi
  803704:	2b 04 24             	sub    (%esp),%eax
  803707:	19 fa                	sbb    %edi,%edx
  803709:	89 d1                	mov    %edx,%ecx
  80370b:	89 c6                	mov    %eax,%esi
  80370d:	e9 71 ff ff ff       	jmp    803683 <__umoddi3+0xb3>
  803712:	66 90                	xchg   %ax,%ax
  803714:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803718:	72 ea                	jb     803704 <__umoddi3+0x134>
  80371a:	89 d9                	mov    %ebx,%ecx
  80371c:	e9 62 ff ff ff       	jmp    803683 <__umoddi3+0xb3>
