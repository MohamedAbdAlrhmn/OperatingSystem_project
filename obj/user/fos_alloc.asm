
obj/user/fos_alloc:     file format elf32-i386


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
  800031:	e8 02 01 00 00       	call   800138 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//uint32 size = 2*1024*1024 +120*4096+1;
	//uint32 size = 1*1024*1024 + 256*1024;
	//uint32 size = 1*1024*1024;
	uint32 size = 100;
  80003e:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)

	unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  800045:	83 ec 0c             	sub    $0xc,%esp
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	e8 80 12 00 00       	call   8012d0 <malloc>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	89 45 ec             	mov    %eax,-0x14(%ebp)
	atomic_cprintf("x allocated at %x\n",x);
  800056:	83 ec 08             	sub    $0x8,%esp
  800059:	ff 75 ec             	pushl  -0x14(%ebp)
  80005c:	68 c0 35 80 00       	push   $0x8035c0
  800061:	e8 0f 03 00 00       	call   800375 <atomic_cprintf>
  800066:	83 c4 10             	add    $0x10,%esp

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  800069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800070:	eb 20                	jmp    800092 <_main+0x5a>
	{
		x[i] = i%256 ;
  800072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800078:	01 c2                	add    %eax,%edx
  80007a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007d:	25 ff 00 00 80       	and    $0x800000ff,%eax
  800082:	85 c0                	test   %eax,%eax
  800084:	79 07                	jns    80008d <_main+0x55>
  800086:	48                   	dec    %eax
  800087:	0d 00 ff ff ff       	or     $0xffffff00,%eax
  80008c:	40                   	inc    %eax
  80008d:	88 02                	mov    %al,(%edx)

	//unsigned char *z = malloc(sizeof(unsigned char)*size) ;
	//cprintf("z allocated at %x\n",z);
	
	int i ;
	for (i = 0 ; i < size ; i++)
  80008f:	ff 45 f4             	incl   -0xc(%ebp)
  800092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800095:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800098:	72 d8                	jb     800072 <_main+0x3a>
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	83 e8 07             	sub    $0x7,%eax
  8000a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000a3:	eb 24                	jmp    8000c9 <_main+0x91>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
  8000a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ab:	01 d0                	add    %edx,%eax
  8000ad:	8a 00                	mov    (%eax),%al
  8000af:	0f b6 c0             	movzbl %al,%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	50                   	push   %eax
  8000b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000b9:	68 d3 35 80 00       	push   $0x8035d3
  8000be:	e8 b2 02 00 00       	call   800375 <atomic_cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp
		////z[i] = (int)(x[i]  * y[i]);
		////z[i] = i%256;
	}

	
	for (i = size-7 ; i < size ; i++)
  8000c6:	ff 45 f4             	incl   -0xc(%ebp)
  8000c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000cf:	72 d4                	jb     8000a5 <_main+0x6d>
		atomic_cprintf("x[%d] = %d\n",i, x[i]);
	
	free(x);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d7:	e8 6f 12 00 00       	call   80134b <free>
  8000dc:	83 c4 10             	add    $0x10,%esp

	x = malloc(sizeof(unsigned char)*size) ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e5:	e8 e6 11 00 00       	call   8012d0 <malloc>
  8000ea:	83 c4 10             	add    $0x10,%esp
  8000ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	for (i = size-7 ; i < size ; i++)
  8000f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f3:	83 e8 07             	sub    $0x7,%eax
  8000f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8000f9:	eb 24                	jmp    80011f <_main+0xe7>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	8a 00                	mov    (%eax),%al
  800105:	0f b6 c0             	movzbl %al,%eax
  800108:	83 ec 04             	sub    $0x4,%esp
  80010b:	50                   	push   %eax
  80010c:	ff 75 f4             	pushl  -0xc(%ebp)
  80010f:	68 d3 35 80 00       	push   $0x8035d3
  800114:	e8 5c 02 00 00       	call   800375 <atomic_cprintf>
  800119:	83 c4 10             	add    $0x10,%esp
	
	free(x);

	x = malloc(sizeof(unsigned char)*size) ;
	
	for (i = size-7 ; i < size ; i++)
  80011c:	ff 45 f4             	incl   -0xc(%ebp)
  80011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800122:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800125:	72 d4                	jb     8000fb <_main+0xc3>
	{
		atomic_cprintf("x[%d] = %d\n",i,x[i]);
	}

	free(x);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 ec             	pushl  -0x14(%ebp)
  80012d:	e8 19 12 00 00       	call   80134b <free>
  800132:	83 c4 10             	add    $0x10,%esp
	
	return;	
  800135:	90                   	nop
}
  800136:	c9                   	leave  
  800137:	c3                   	ret    

00800138 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013e:	e8 42 17 00 00       	call   801885 <sys_getenvindex>
  800143:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800149:	89 d0                	mov    %edx,%eax
  80014b:	c1 e0 03             	shl    $0x3,%eax
  80014e:	01 d0                	add    %edx,%eax
  800150:	01 c0                	add    %eax,%eax
  800152:	01 d0                	add    %edx,%eax
  800154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015b:	01 d0                	add    %edx,%eax
  80015d:	c1 e0 04             	shl    $0x4,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016a:	a1 20 40 80 00       	mov    0x804020,%eax
  80016f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800175:	84 c0                	test   %al,%al
  800177:	74 0f                	je     800188 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	05 5c 05 00 00       	add    $0x55c,%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800188:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018c:	7e 0a                	jle    800198 <libmain+0x60>
		binaryname = argv[0];
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	8b 00                	mov    (%eax),%eax
  800193:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800198:	83 ec 08             	sub    $0x8,%esp
  80019b:	ff 75 0c             	pushl  0xc(%ebp)
  80019e:	ff 75 08             	pushl  0x8(%ebp)
  8001a1:	e8 92 fe ff ff       	call   800038 <_main>
  8001a6:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a9:	e8 e4 14 00 00       	call   801692 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 f8 35 80 00       	push   $0x8035f8
  8001b6:	e8 8d 01 00 00       	call   800348 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 20 36 80 00       	push   $0x803620
  8001de:	e8 65 01 00 00       	call   800348 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 48 36 80 00       	push   $0x803648
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 a0 36 80 00       	push   $0x8036a0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 f8 35 80 00       	push   $0x8035f8
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 64 14 00 00       	call   8016ac <sys_enable_interrupt>

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 f1 15 00 00       	call   801851 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 46 16 00 00       	call   8018b7 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80027a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027d:	8b 00                	mov    (%eax),%eax
  80027f:	8d 48 01             	lea    0x1(%eax),%ecx
  800282:	8b 55 0c             	mov    0xc(%ebp),%edx
  800285:	89 0a                	mov    %ecx,(%edx)
  800287:	8b 55 08             	mov    0x8(%ebp),%edx
  80028a:	88 d1                	mov    %dl,%cl
  80028c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80028f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800293:	8b 45 0c             	mov    0xc(%ebp),%eax
  800296:	8b 00                	mov    (%eax),%eax
  800298:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029d:	75 2c                	jne    8002cb <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80029f:	a0 24 40 80 00       	mov    0x804024,%al
  8002a4:	0f b6 c0             	movzbl %al,%eax
  8002a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002aa:	8b 12                	mov    (%edx),%edx
  8002ac:	89 d1                	mov    %edx,%ecx
  8002ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b1:	83 c2 08             	add    $0x8,%edx
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	50                   	push   %eax
  8002b8:	51                   	push   %ecx
  8002b9:	52                   	push   %edx
  8002ba:	e8 25 12 00 00       	call   8014e4 <sys_cputs>
  8002bf:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ce:	8b 40 04             	mov    0x4(%eax),%eax
  8002d1:	8d 50 01             	lea    0x1(%eax),%edx
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 50 04             	mov    %edx,0x4(%eax)
}
  8002da:	90                   	nop
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002e6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ed:	00 00 00 
	b.cnt = 0;
  8002f0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002f7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800306:	50                   	push   %eax
  800307:	68 74 02 80 00       	push   $0x800274
  80030c:	e8 11 02 00 00       	call   800522 <vprintfmt>
  800311:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800314:	a0 24 40 80 00       	mov    0x804024,%al
  800319:	0f b6 c0             	movzbl %al,%eax
  80031c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800322:	83 ec 04             	sub    $0x4,%esp
  800325:	50                   	push   %eax
  800326:	52                   	push   %edx
  800327:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80032d:	83 c0 08             	add    $0x8,%eax
  800330:	50                   	push   %eax
  800331:	e8 ae 11 00 00       	call   8014e4 <sys_cputs>
  800336:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800339:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800340:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <cprintf>:

int cprintf(const char *fmt, ...) {
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80034e:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800355:	8d 45 0c             	lea    0xc(%ebp),%eax
  800358:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	83 ec 08             	sub    $0x8,%esp
  800361:	ff 75 f4             	pushl  -0xc(%ebp)
  800364:	50                   	push   %eax
  800365:	e8 73 ff ff ff       	call   8002dd <vcprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800370:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80037b:	e8 12 13 00 00       	call   801692 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800380:	8d 45 0c             	lea    0xc(%ebp),%eax
  800383:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 f4             	pushl  -0xc(%ebp)
  80038f:	50                   	push   %eax
  800390:	e8 48 ff ff ff       	call   8002dd <vcprintf>
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80039b:	e8 0c 13 00 00       	call   8016ac <sys_enable_interrupt>
	return cnt;
  8003a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 14             	sub    $0x14,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8003bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c3:	77 55                	ja     80041a <printnum+0x75>
  8003c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003c8:	72 05                	jb     8003cf <printnum+0x2a>
  8003ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8003cd:	77 4b                	ja     80041a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8003d2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dd:	52                   	push   %edx
  8003de:	50                   	push   %eax
  8003df:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e2:	ff 75 f0             	pushl  -0x10(%ebp)
  8003e5:	e8 5e 2f 00 00       	call   803348 <__udivdi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	ff 75 20             	pushl  0x20(%ebp)
  8003f3:	53                   	push   %ebx
  8003f4:	ff 75 18             	pushl  0x18(%ebp)
  8003f7:	52                   	push   %edx
  8003f8:	50                   	push   %eax
  8003f9:	ff 75 0c             	pushl  0xc(%ebp)
  8003fc:	ff 75 08             	pushl  0x8(%ebp)
  8003ff:	e8 a1 ff ff ff       	call   8003a5 <printnum>
  800404:	83 c4 20             	add    $0x20,%esp
  800407:	eb 1a                	jmp    800423 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 20             	pushl  0x20(%ebp)
  800412:	8b 45 08             	mov    0x8(%ebp),%eax
  800415:	ff d0                	call   *%eax
  800417:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80041a:	ff 4d 1c             	decl   0x1c(%ebp)
  80041d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800421:	7f e6                	jg     800409 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800423:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800426:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800431:	53                   	push   %ebx
  800432:	51                   	push   %ecx
  800433:	52                   	push   %edx
  800434:	50                   	push   %eax
  800435:	e8 1e 30 00 00       	call   803458 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 d4 38 80 00       	add    $0x8038d4,%eax
  800442:	8a 00                	mov    (%eax),%al
  800444:	0f be c0             	movsbl %al,%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	ff 75 0c             	pushl  0xc(%ebp)
  80044d:	50                   	push   %eax
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	ff d0                	call   *%eax
  800453:	83 c4 10             	add    $0x10,%esp
}
  800456:	90                   	nop
  800457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80045a:	c9                   	leave  
  80045b:	c3                   	ret    

0080045c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045c:	55                   	push   %ebp
  80045d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800463:	7e 1c                	jle    800481 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800465:	8b 45 08             	mov    0x8(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 50 08             	lea    0x8(%eax),%edx
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	89 10                	mov    %edx,(%eax)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	8b 00                	mov    (%eax),%eax
  800477:	83 e8 08             	sub    $0x8,%eax
  80047a:	8b 50 04             	mov    0x4(%eax),%edx
  80047d:	8b 00                	mov    (%eax),%eax
  80047f:	eb 40                	jmp    8004c1 <getuint+0x65>
	else if (lflag)
  800481:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800485:	74 1e                	je     8004a5 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800487:	8b 45 08             	mov    0x8(%ebp),%eax
  80048a:	8b 00                	mov    (%eax),%eax
  80048c:	8d 50 04             	lea    0x4(%eax),%edx
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 10                	mov    %edx,(%eax)
  800494:	8b 45 08             	mov    0x8(%ebp),%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 e8 04             	sub    $0x4,%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	eb 1c                	jmp    8004c1 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b0:	89 10                	mov    %edx,(%eax)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	8b 00                	mov    (%eax),%eax
  8004b7:	83 e8 04             	sub    $0x4,%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c1:	5d                   	pop    %ebp
  8004c2:	c3                   	ret    

008004c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004c3:	55                   	push   %ebp
  8004c4:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c6:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004ca:	7e 1c                	jle    8004e8 <getint+0x25>
		return va_arg(*ap, long long);
  8004cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	8d 50 08             	lea    0x8(%eax),%edx
  8004d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d7:	89 10                	mov    %edx,(%eax)
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	83 e8 08             	sub    $0x8,%eax
  8004e1:	8b 50 04             	mov    0x4(%eax),%edx
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	eb 38                	jmp    800520 <getint+0x5d>
	else if (lflag)
  8004e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004ec:	74 1a                	je     800508 <getint+0x45>
		return va_arg(*ap, long);
  8004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	8d 50 04             	lea    0x4(%eax),%edx
  8004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f9:	89 10                	mov    %edx,(%eax)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	83 e8 04             	sub    $0x4,%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	99                   	cltd   
  800506:	eb 18                	jmp    800520 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	8d 50 04             	lea    0x4(%eax),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	89 10                	mov    %edx,(%eax)
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	83 e8 04             	sub    $0x4,%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	99                   	cltd   
}
  800520:	5d                   	pop    %ebp
  800521:	c3                   	ret    

00800522 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800522:	55                   	push   %ebp
  800523:	89 e5                	mov    %esp,%ebp
  800525:	56                   	push   %esi
  800526:	53                   	push   %ebx
  800527:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80052a:	eb 17                	jmp    800543 <vprintfmt+0x21>
			if (ch == '\0')
  80052c:	85 db                	test   %ebx,%ebx
  80052e:	0f 84 af 03 00 00    	je     8008e3 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	53                   	push   %ebx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	ff d0                	call   *%eax
  800540:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800543:	8b 45 10             	mov    0x10(%ebp),%eax
  800546:	8d 50 01             	lea    0x1(%eax),%edx
  800549:	89 55 10             	mov    %edx,0x10(%ebp)
  80054c:	8a 00                	mov    (%eax),%al
  80054e:	0f b6 d8             	movzbl %al,%ebx
  800551:	83 fb 25             	cmp    $0x25,%ebx
  800554:	75 d6                	jne    80052c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800556:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80055a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800561:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80056f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800587:	83 f8 55             	cmp    $0x55,%eax
  80058a:	0f 87 2b 03 00 00    	ja     8008bb <vprintfmt+0x399>
  800590:	8b 04 85 f8 38 80 00 	mov    0x8038f8(,%eax,4),%eax
  800597:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800599:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80059d:	eb d7                	jmp    800576 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80059f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005a3:	eb d1                	jmp    800576 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005af:	89 d0                	mov    %edx,%eax
  8005b1:	c1 e0 02             	shl    $0x2,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	01 c0                	add    %eax,%eax
  8005b8:	01 d8                	add    %ebx,%eax
  8005ba:	83 e8 30             	sub    $0x30,%eax
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c3:	8a 00                	mov    (%eax),%al
  8005c5:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005c8:	83 fb 2f             	cmp    $0x2f,%ebx
  8005cb:	7e 3e                	jle    80060b <vprintfmt+0xe9>
  8005cd:	83 fb 39             	cmp    $0x39,%ebx
  8005d0:	7f 39                	jg     80060b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d2:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005d5:	eb d5                	jmp    8005ac <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	83 c0 04             	add    $0x4,%eax
  8005dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 e8 04             	sub    $0x4,%eax
  8005e6:	8b 00                	mov    (%eax),%eax
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005eb:	eb 1f                	jmp    80060c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	79 83                	jns    800576 <vprintfmt+0x54>
				width = 0;
  8005f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005fa:	e9 77 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800606:	e9 6b ff ff ff       	jmp    800576 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80060b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800610:	0f 89 60 ff ff ff    	jns    800576 <vprintfmt+0x54>
				width = precision, precision = -1;
  800616:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80061c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800623:	e9 4e ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800628:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80062b:	e9 46 ff ff ff       	jmp    800576 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800630:	8b 45 14             	mov    0x14(%ebp),%eax
  800633:	83 c0 04             	add    $0x4,%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	83 e8 04             	sub    $0x4,%eax
  80063f:	8b 00                	mov    (%eax),%eax
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	50                   	push   %eax
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	ff d0                	call   *%eax
  80064d:	83 c4 10             	add    $0x10,%esp
			break;
  800650:	e9 89 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	83 c0 04             	add    $0x4,%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 e8 04             	sub    $0x4,%eax
  800664:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800666:	85 db                	test   %ebx,%ebx
  800668:	79 02                	jns    80066c <vprintfmt+0x14a>
				err = -err;
  80066a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066c:	83 fb 64             	cmp    $0x64,%ebx
  80066f:	7f 0b                	jg     80067c <vprintfmt+0x15a>
  800671:	8b 34 9d 40 37 80 00 	mov    0x803740(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 e5 38 80 00       	push   $0x8038e5
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	ff 75 08             	pushl  0x8(%ebp)
  800688:	e8 5e 02 00 00       	call   8008eb <printfmt>
  80068d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800690:	e9 49 02 00 00       	jmp    8008de <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800695:	56                   	push   %esi
  800696:	68 ee 38 80 00       	push   $0x8038ee
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	ff 75 08             	pushl  0x8(%ebp)
  8006a1:	e8 45 02 00 00       	call   8008eb <printfmt>
  8006a6:	83 c4 10             	add    $0x10,%esp
			break;
  8006a9:	e9 30 02 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	83 c0 04             	add    $0x4,%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	83 e8 04             	sub    $0x4,%eax
  8006bd:	8b 30                	mov    (%eax),%esi
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	75 05                	jne    8006c8 <vprintfmt+0x1a6>
				p = "(null)";
  8006c3:	be f1 38 80 00       	mov    $0x8038f1,%esi
			if (width > 0 && padc != '-')
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	7e 6d                	jle    80073b <vprintfmt+0x219>
  8006ce:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8006d2:	74 67                	je     80073b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	50                   	push   %eax
  8006db:	56                   	push   %esi
  8006dc:	e8 0c 03 00 00       	call   8009ed <strnlen>
  8006e1:	83 c4 10             	add    $0x10,%esp
  8006e4:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006e7:	eb 16                	jmp    8006ff <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006e9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ed:	83 ec 08             	sub    $0x8,%esp
  8006f0:	ff 75 0c             	pushl  0xc(%ebp)
  8006f3:	50                   	push   %eax
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	ff d0                	call   *%eax
  8006f9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	7f e4                	jg     8006e9 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	eb 34                	jmp    80073b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800707:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80070b:	74 1c                	je     800729 <vprintfmt+0x207>
  80070d:	83 fb 1f             	cmp    $0x1f,%ebx
  800710:	7e 05                	jle    800717 <vprintfmt+0x1f5>
  800712:	83 fb 7e             	cmp    $0x7e,%ebx
  800715:	7e 12                	jle    800729 <vprintfmt+0x207>
					putch('?', putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	6a 3f                	push   $0x3f
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	eb 0f                	jmp    800738 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800729:	83 ec 08             	sub    $0x8,%esp
  80072c:	ff 75 0c             	pushl  0xc(%ebp)
  80072f:	53                   	push   %ebx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	ff d0                	call   *%eax
  800735:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	ff 4d e4             	decl   -0x1c(%ebp)
  80073b:	89 f0                	mov    %esi,%eax
  80073d:	8d 70 01             	lea    0x1(%eax),%esi
  800740:	8a 00                	mov    (%eax),%al
  800742:	0f be d8             	movsbl %al,%ebx
  800745:	85 db                	test   %ebx,%ebx
  800747:	74 24                	je     80076d <vprintfmt+0x24b>
  800749:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80074d:	78 b8                	js     800707 <vprintfmt+0x1e5>
  80074f:	ff 4d e0             	decl   -0x20(%ebp)
  800752:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800756:	79 af                	jns    800707 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800758:	eb 13                	jmp    80076d <vprintfmt+0x24b>
				putch(' ', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 20                	push   $0x20
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076a:	ff 4d e4             	decl   -0x1c(%ebp)
  80076d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800771:	7f e7                	jg     80075a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800773:	e9 66 01 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 e8             	pushl  -0x18(%ebp)
  80077e:	8d 45 14             	lea    0x14(%ebp),%eax
  800781:	50                   	push   %eax
  800782:	e8 3c fd ff ff       	call   8004c3 <getint>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800796:	85 d2                	test   %edx,%edx
  800798:	79 23                	jns    8007bd <vprintfmt+0x29b>
				putch('-', putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	ff 75 0c             	pushl  0xc(%ebp)
  8007a0:	6a 2d                	push   $0x2d
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
  8007a7:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b0:	f7 d8                	neg    %eax
  8007b2:	83 d2 00             	adc    $0x0,%edx
  8007b5:	f7 da                	neg    %edx
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007bd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007c4:	e9 bc 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c9:	83 ec 08             	sub    $0x8,%esp
  8007cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cf:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	e8 84 fc ff ff       	call   80045c <getuint>
  8007d8:	83 c4 10             	add    $0x10,%esp
  8007db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007de:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007e1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007e8:	e9 98 00 00 00       	jmp    800885 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	ff 75 0c             	pushl  0xc(%ebp)
  8007f3:	6a 58                	push   $0x58
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	ff d0                	call   *%eax
  8007fa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 0c             	pushl  0xc(%ebp)
  800803:	6a 58                	push   $0x58
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	ff d0                	call   *%eax
  80080a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	6a 58                	push   $0x58
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
			break;
  80081d:	e9 bc 00 00 00       	jmp    8008de <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800822:	83 ec 08             	sub    $0x8,%esp
  800825:	ff 75 0c             	pushl  0xc(%ebp)
  800828:	6a 30                	push   $0x30
  80082a:	8b 45 08             	mov    0x8(%ebp),%eax
  80082d:	ff d0                	call   *%eax
  80082f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800832:	83 ec 08             	sub    $0x8,%esp
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	6a 78                	push   $0x78
  80083a:	8b 45 08             	mov    0x8(%ebp),%eax
  80083d:	ff d0                	call   *%eax
  80083f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800853:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800856:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80085d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800864:	eb 1f                	jmp    800885 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 e8             	pushl  -0x18(%ebp)
  80086c:	8d 45 14             	lea    0x14(%ebp),%eax
  80086f:	50                   	push   %eax
  800870:	e8 e7 fb ff ff       	call   80045c <getuint>
  800875:	83 c4 10             	add    $0x10,%esp
  800878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80087b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80087e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800885:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088c:	83 ec 04             	sub    $0x4,%esp
  80088f:	52                   	push   %edx
  800890:	ff 75 e4             	pushl  -0x1c(%ebp)
  800893:	50                   	push   %eax
  800894:	ff 75 f4             	pushl  -0xc(%ebp)
  800897:	ff 75 f0             	pushl  -0x10(%ebp)
  80089a:	ff 75 0c             	pushl  0xc(%ebp)
  80089d:	ff 75 08             	pushl  0x8(%ebp)
  8008a0:	e8 00 fb ff ff       	call   8003a5 <printnum>
  8008a5:	83 c4 20             	add    $0x20,%esp
			break;
  8008a8:	eb 34                	jmp    8008de <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008aa:	83 ec 08             	sub    $0x8,%esp
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	53                   	push   %ebx
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	ff d0                	call   *%eax
  8008b6:	83 c4 10             	add    $0x10,%esp
			break;
  8008b9:	eb 23                	jmp    8008de <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	ff 75 0c             	pushl  0xc(%ebp)
  8008c1:	6a 25                	push   $0x25
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	ff d0                	call   *%eax
  8008c8:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008cb:	ff 4d 10             	decl   0x10(%ebp)
  8008ce:	eb 03                	jmp    8008d3 <vprintfmt+0x3b1>
  8008d0:	ff 4d 10             	decl   0x10(%ebp)
  8008d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d6:	48                   	dec    %eax
  8008d7:	8a 00                	mov    (%eax),%al
  8008d9:	3c 25                	cmp    $0x25,%al
  8008db:	75 f3                	jne    8008d0 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8008dd:	90                   	nop
		}
	}
  8008de:	e9 47 fc ff ff       	jmp    80052a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008e3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f4:	83 c0 04             	add    $0x4,%eax
  8008f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800900:	50                   	push   %eax
  800901:	ff 75 0c             	pushl  0xc(%ebp)
  800904:	ff 75 08             	pushl  0x8(%ebp)
  800907:	e8 16 fc ff ff       	call   800522 <vprintfmt>
  80090c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80090f:	90                   	nop
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800915:	8b 45 0c             	mov    0xc(%ebp),%eax
  800918:	8b 40 08             	mov    0x8(%eax),%eax
  80091b:	8d 50 01             	lea    0x1(%eax),%edx
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8b 10                	mov    (%eax),%edx
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	8b 40 04             	mov    0x4(%eax),%eax
  80092f:	39 c2                	cmp    %eax,%edx
  800931:	73 12                	jae    800945 <sprintputch+0x33>
		*b->buf++ = ch;
  800933:	8b 45 0c             	mov    0xc(%ebp),%eax
  800936:	8b 00                	mov    (%eax),%eax
  800938:	8d 48 01             	lea    0x1(%eax),%ecx
  80093b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093e:	89 0a                	mov    %ecx,(%edx)
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	88 10                	mov    %dl,(%eax)
}
  800945:	90                   	nop
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	8d 50 ff             	lea    -0x1(%eax),%edx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	01 d0                	add    %edx,%eax
  80095f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800962:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800969:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80096d:	74 06                	je     800975 <vsnprintf+0x2d>
  80096f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800973:	7f 07                	jg     80097c <vsnprintf+0x34>
		return -E_INVAL;
  800975:	b8 03 00 00 00       	mov    $0x3,%eax
  80097a:	eb 20                	jmp    80099c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80097c:	ff 75 14             	pushl  0x14(%ebp)
  80097f:	ff 75 10             	pushl  0x10(%ebp)
  800982:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	68 12 09 80 00       	push   $0x800912
  80098b:	e8 92 fb ff ff       	call   800522 <vprintfmt>
  800990:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800996:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800999:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    

0080099e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099e:	55                   	push   %ebp
  80099f:	89 e5                	mov    %esp,%ebp
  8009a1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009a4:	8d 45 10             	lea    0x10(%ebp),%eax
  8009a7:	83 c0 04             	add    $0x4,%eax
  8009aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b3:	50                   	push   %eax
  8009b4:	ff 75 0c             	pushl  0xc(%ebp)
  8009b7:	ff 75 08             	pushl  0x8(%ebp)
  8009ba:	e8 89 ff ff ff       	call   800948 <vsnprintf>
  8009bf:	83 c4 10             	add    $0x10,%esp
  8009c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8009d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009d7:	eb 06                	jmp    8009df <strlen+0x15>
		n++;
  8009d9:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009dc:	ff 45 08             	incl   0x8(%ebp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 f1                	jne    8009d9 <strlen+0xf>
		n++;
	return n;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009fa:	eb 09                	jmp    800a05 <strnlen+0x18>
		n++;
  8009fc:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009ff:	ff 45 08             	incl   0x8(%ebp)
  800a02:	ff 4d 0c             	decl   0xc(%ebp)
  800a05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a09:	74 09                	je     800a14 <strnlen+0x27>
  800a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0e:	8a 00                	mov    (%eax),%al
  800a10:	84 c0                	test   %al,%al
  800a12:	75 e8                	jne    8009fc <strnlen+0xf>
		n++;
	return n;
  800a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a25:	90                   	nop
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8d 50 01             	lea    0x1(%eax),%edx
  800a2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a38:	8a 12                	mov    (%edx),%dl
  800a3a:	88 10                	mov    %dl,(%eax)
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	84 c0                	test   %al,%al
  800a40:	75 e4                	jne    800a26 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a45:	c9                   	leave  
  800a46:	c3                   	ret    

00800a47 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 1f                	jmp    800a7b <strncpy+0x34>
		*dst++ = *src;
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	8d 50 01             	lea    0x1(%eax),%edx
  800a62:	89 55 08             	mov    %edx,0x8(%ebp)
  800a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a68:	8a 12                	mov    (%edx),%dl
  800a6a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 03                	je     800a78 <strncpy+0x31>
			src++;
  800a75:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a78:	ff 45 fc             	incl   -0x4(%ebp)
  800a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a7e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a81:	72 d9                	jb     800a5c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a86:	c9                   	leave  
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a98:	74 30                	je     800aca <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a9a:	eb 16                	jmp    800ab2 <strlcpy+0x2a>
			*dst++ = *src++;
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	8d 50 01             	lea    0x1(%eax),%edx
  800aa2:	89 55 08             	mov    %edx,0x8(%ebp)
  800aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aa8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800aab:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800aae:	8a 12                	mov    (%edx),%dl
  800ab0:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab2:	ff 4d 10             	decl   0x10(%ebp)
  800ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab9:	74 09                	je     800ac4 <strlcpy+0x3c>
  800abb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abe:	8a 00                	mov    (%eax),%al
  800ac0:	84 c0                	test   %al,%al
  800ac2:	75 d8                	jne    800a9c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ad0:	29 c2                	sub    %eax,%edx
  800ad2:	89 d0                	mov    %edx,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ad9:	eb 06                	jmp    800ae1 <strcmp+0xb>
		p++, q++;
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8a 00                	mov    (%eax),%al
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 0e                	je     800af8 <strcmp+0x22>
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 10                	mov    (%eax),%dl
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	38 c2                	cmp    %al,%dl
  800af6:	74 e3                	je     800adb <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	0f b6 d0             	movzbl %al,%edx
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8a 00                	mov    (%eax),%al
  800b05:	0f b6 c0             	movzbl %al,%eax
  800b08:	29 c2                	sub    %eax,%edx
  800b0a:	89 d0                	mov    %edx,%eax
}
  800b0c:	5d                   	pop    %ebp
  800b0d:	c3                   	ret    

00800b0e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b11:	eb 09                	jmp    800b1c <strncmp+0xe>
		n--, p++, q++;
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	ff 45 08             	incl   0x8(%ebp)
  800b19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b20:	74 17                	je     800b39 <strncmp+0x2b>
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	74 0e                	je     800b39 <strncmp+0x2b>
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 10                	mov    (%eax),%dl
  800b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b33:	8a 00                	mov    (%eax),%al
  800b35:	38 c2                	cmp    %al,%dl
  800b37:	74 da                	je     800b13 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b3d:	75 07                	jne    800b46 <strncmp+0x38>
		return 0;
  800b3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800b44:	eb 14                	jmp    800b5a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f b6 d0             	movzbl %al,%edx
  800b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b51:	8a 00                	mov    (%eax),%al
  800b53:	0f b6 c0             	movzbl %al,%eax
  800b56:	29 c2                	sub    %eax,%edx
  800b58:	89 d0                	mov    %edx,%eax
}
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 04             	sub    $0x4,%esp
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b68:	eb 12                	jmp    800b7c <strchr+0x20>
		if (*s == c)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8a 00                	mov    (%eax),%al
  800b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b72:	75 05                	jne    800b79 <strchr+0x1d>
			return (char *) s;
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	eb 11                	jmp    800b8a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b79:	ff 45 08             	incl   0x8(%ebp)
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	8a 00                	mov    (%eax),%al
  800b81:	84 c0                	test   %al,%al
  800b83:	75 e5                	jne    800b6a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b95:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b98:	eb 0d                	jmp    800ba7 <strfind+0x1b>
		if (*s == c)
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8a 00                	mov    (%eax),%al
  800b9f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba2:	74 0e                	je     800bb2 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ba4:	ff 45 08             	incl   0x8(%ebp)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	84 c0                	test   %al,%al
  800bae:	75 ea                	jne    800b9a <strfind+0xe>
  800bb0:	eb 01                	jmp    800bb3 <strfind+0x27>
		if (*s == c)
			break;
  800bb2:	90                   	nop
	return (char *) s;
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bca:	eb 0e                	jmp    800bda <memset+0x22>
		*p++ = c;
  800bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcf:	8d 50 01             	lea    0x1(%eax),%edx
  800bd2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd8:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800bda:	ff 4d f8             	decl   -0x8(%ebp)
  800bdd:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800be1:	79 e9                	jns    800bcc <memset+0x14>
		*p++ = c;

	return v;
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bfa:	eb 16                	jmp    800c12 <memcpy+0x2a>
		*d++ = *s++;
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8d 50 01             	lea    0x1(%eax),%edx
  800c02:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c0e:	8a 12                	mov    (%edx),%dl
  800c10:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 dd                	jne    800bfc <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c39:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c3c:	73 50                	jae    800c8e <memmove+0x6a>
  800c3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	01 d0                	add    %edx,%eax
  800c46:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c49:	76 43                	jbe    800c8e <memmove+0x6a>
		s += n;
  800c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4e:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c51:	8b 45 10             	mov    0x10(%ebp),%eax
  800c54:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c57:	eb 10                	jmp    800c69 <memmove+0x45>
			*--d = *--s;
  800c59:	ff 4d f8             	decl   -0x8(%ebp)
  800c5c:	ff 4d fc             	decl   -0x4(%ebp)
  800c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c62:	8a 10                	mov    (%eax),%dl
  800c64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c67:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c69:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6f:	89 55 10             	mov    %edx,0x10(%ebp)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	75 e3                	jne    800c59 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c76:	eb 23                	jmp    800c9b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c84:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c94:	89 55 10             	mov    %edx,0x10(%ebp)
  800c97:	85 c0                	test   %eax,%eax
  800c99:	75 dd                	jne    800c78 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800caf:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800cb2:	eb 2a                	jmp    800cde <memcmp+0x3e>
		if (*s1 != *s2)
  800cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb7:	8a 10                	mov    (%eax),%dl
  800cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	38 c2                	cmp    %al,%dl
  800cc0:	74 16                	je     800cd8 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc5:	8a 00                	mov    (%eax),%al
  800cc7:	0f b6 d0             	movzbl %al,%edx
  800cca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	0f b6 c0             	movzbl %al,%eax
  800cd2:	29 c2                	sub    %eax,%edx
  800cd4:	89 d0                	mov    %edx,%eax
  800cd6:	eb 18                	jmp    800cf0 <memcmp+0x50>
		s1++, s2++;
  800cd8:	ff 45 fc             	incl   -0x4(%ebp)
  800cdb:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800cde:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ce4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ce7:	85 c0                	test   %eax,%eax
  800ce9:	75 c9                	jne    800cb4 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ceb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800cfe:	01 d0                	add    %edx,%eax
  800d00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d03:	eb 15                	jmp    800d1a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	0f b6 d0             	movzbl %al,%edx
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	0f b6 c0             	movzbl %al,%eax
  800d13:	39 c2                	cmp    %eax,%edx
  800d15:	74 0d                	je     800d24 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d20:	72 e3                	jb     800d05 <memfind+0x13>
  800d22:	eb 01                	jmp    800d25 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d24:	90                   	nop
	return (void *) s;
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d3e:	eb 03                	jmp    800d43 <strtol+0x19>
		s++;
  800d40:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	3c 20                	cmp    $0x20,%al
  800d4a:	74 f4                	je     800d40 <strtol+0x16>
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	3c 09                	cmp    $0x9,%al
  800d53:	74 eb                	je     800d40 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3c 2b                	cmp    $0x2b,%al
  800d5c:	75 05                	jne    800d63 <strtol+0x39>
		s++;
  800d5e:	ff 45 08             	incl   0x8(%ebp)
  800d61:	eb 13                	jmp    800d76 <strtol+0x4c>
	else if (*s == '-')
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	3c 2d                	cmp    $0x2d,%al
  800d6a:	75 0a                	jne    800d76 <strtol+0x4c>
		s++, neg = 1;
  800d6c:	ff 45 08             	incl   0x8(%ebp)
  800d6f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	74 06                	je     800d82 <strtol+0x58>
  800d7c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d80:	75 20                	jne    800da2 <strtol+0x78>
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	3c 30                	cmp    $0x30,%al
  800d89:	75 17                	jne    800da2 <strtol+0x78>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	40                   	inc    %eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 78                	cmp    $0x78,%al
  800d93:	75 0d                	jne    800da2 <strtol+0x78>
		s += 2, base = 16;
  800d95:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d99:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800da0:	eb 28                	jmp    800dca <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800da2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da6:	75 15                	jne    800dbd <strtol+0x93>
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3c 30                	cmp    $0x30,%al
  800daf:	75 0c                	jne    800dbd <strtol+0x93>
		s++, base = 8;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dbb:	eb 0d                	jmp    800dca <strtol+0xa0>
	else if (base == 0)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	75 07                	jne    800dca <strtol+0xa0>
		base = 10;
  800dc3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dca:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcd:	8a 00                	mov    (%eax),%al
  800dcf:	3c 2f                	cmp    $0x2f,%al
  800dd1:	7e 19                	jle    800dec <strtol+0xc2>
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	8a 00                	mov    (%eax),%al
  800dd8:	3c 39                	cmp    $0x39,%al
  800dda:	7f 10                	jg     800dec <strtol+0xc2>
			dig = *s - '0';
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f be c0             	movsbl %al,%eax
  800de4:	83 e8 30             	sub    $0x30,%eax
  800de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dea:	eb 42                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 60                	cmp    $0x60,%al
  800df3:	7e 19                	jle    800e0e <strtol+0xe4>
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	8a 00                	mov    (%eax),%al
  800dfa:	3c 7a                	cmp    $0x7a,%al
  800dfc:	7f 10                	jg     800e0e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	0f be c0             	movsbl %al,%eax
  800e06:	83 e8 57             	sub    $0x57,%eax
  800e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e0c:	eb 20                	jmp    800e2e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	3c 40                	cmp    $0x40,%al
  800e15:	7e 39                	jle    800e50 <strtol+0x126>
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	3c 5a                	cmp    $0x5a,%al
  800e1e:	7f 30                	jg     800e50 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f be c0             	movsbl %al,%eax
  800e28:	83 e8 37             	sub    $0x37,%eax
  800e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e34:	7d 19                	jge    800e4f <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e40:	89 c2                	mov    %eax,%edx
  800e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e45:	01 d0                	add    %edx,%eax
  800e47:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e4a:	e9 7b ff ff ff       	jmp    800dca <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e4f:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e54:	74 08                	je     800e5e <strtol+0x134>
		*endptr = (char *) s;
  800e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e5e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e62:	74 07                	je     800e6b <strtol+0x141>
  800e64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e67:	f7 d8                	neg    %eax
  800e69:	eb 03                	jmp    800e6e <strtol+0x144>
  800e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e6e:	c9                   	leave  
  800e6f:	c3                   	ret    

00800e70 <ltostr>:

void
ltostr(long value, char *str)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e7d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	79 13                	jns    800e9d <ltostr+0x2d>
	{
		neg = 1;
  800e8a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e97:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e9a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ea5:	99                   	cltd   
  800ea6:	f7 f9                	idiv   %ecx
  800ea8:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	8d 50 01             	lea    0x1(%eax),%edx
  800eb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eb4:	89 c2                	mov    %eax,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	01 d0                	add    %edx,%eax
  800ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ebe:	83 c2 30             	add    $0x30,%edx
  800ec1:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ec6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ecb:	f7 e9                	imul   %ecx
  800ecd:	c1 fa 02             	sar    $0x2,%edx
  800ed0:	89 c8                	mov    %ecx,%eax
  800ed2:	c1 f8 1f             	sar    $0x1f,%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
  800ed9:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800edc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800edf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ee4:	f7 e9                	imul   %ecx
  800ee6:	c1 fa 02             	sar    $0x2,%edx
  800ee9:	89 c8                	mov    %ecx,%eax
  800eeb:	c1 f8 1f             	sar    $0x1f,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	c1 e0 02             	shl    $0x2,%eax
  800ef5:	01 d0                	add    %edx,%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	29 c1                	sub    %eax,%ecx
  800efb:	89 ca                	mov    %ecx,%edx
  800efd:	85 d2                	test   %edx,%edx
  800eff:	75 9c                	jne    800e9d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0b:	48                   	dec    %eax
  800f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f13:	74 3d                	je     800f52 <ltostr+0xe2>
		start = 1 ;
  800f15:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f1c:	eb 34                	jmp    800f52 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f24:	01 d0                	add    %edx,%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f31:	01 c2                	add    %eax,%edx
  800f33:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	01 c8                	add    %ecx,%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	01 c2                	add    %eax,%edx
  800f47:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f4a:	88 02                	mov    %al,(%edx)
		start++ ;
  800f4c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f4f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f55:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f58:	7c c4                	jl     800f1e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f5a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f60:	01 d0                	add    %edx,%eax
  800f62:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f65:	90                   	nop
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f6e:	ff 75 08             	pushl  0x8(%ebp)
  800f71:	e8 54 fa ff ff       	call   8009ca <strlen>
  800f76:	83 c4 04             	add    $0x4,%esp
  800f79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f7c:	ff 75 0c             	pushl  0xc(%ebp)
  800f7f:	e8 46 fa ff ff       	call   8009ca <strlen>
  800f84:	83 c4 04             	add    $0x4,%esp
  800f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f98:	eb 17                	jmp    800fb1 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 c2                	add    %eax,%edx
  800fa2:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	01 c8                	add    %ecx,%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fb7:	7c e1                	jl     800f9a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fb9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800fc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800fc7:	eb 1f                	jmp    800fe8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fcc:	8d 50 01             	lea    0x1(%eax),%edx
  800fcf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd7:	01 c2                	add    %eax,%edx
  800fd9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdf:	01 c8                	add    %ecx,%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800fe5:	ff 45 f8             	incl   -0x8(%ebp)
  800fe8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800feb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fee:	7c d9                	jl     800fc9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800ff0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff6:	01 d0                	add    %edx,%eax
  800ff8:	c6 00 00             	movb   $0x0,(%eax)
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801001:	8b 45 14             	mov    0x14(%ebp),%eax
  801004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80100a:	8b 45 14             	mov    0x14(%ebp),%eax
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 d0                	add    %edx,%eax
  80101b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801021:	eb 0c                	jmp    80102f <strsplit+0x31>
			*string++ = 0;
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8d 50 01             	lea    0x1(%eax),%edx
  801029:	89 55 08             	mov    %edx,0x8(%ebp)
  80102c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	74 18                	je     801050 <strsplit+0x52>
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	e8 13 fb ff ff       	call   800b5c <strchr>
  801049:	83 c4 08             	add    $0x8,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	75 d3                	jne    801023 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	84 c0                	test   %al,%al
  801057:	74 5a                	je     8010b3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	8b 00                	mov    (%eax),%eax
  80105e:	83 f8 0f             	cmp    $0xf,%eax
  801061:	75 07                	jne    80106a <strsplit+0x6c>
		{
			return 0;
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	eb 66                	jmp    8010d0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80106a:	8b 45 14             	mov    0x14(%ebp),%eax
  80106d:	8b 00                	mov    (%eax),%eax
  80106f:	8d 48 01             	lea    0x1(%eax),%ecx
  801072:	8b 55 14             	mov    0x14(%ebp),%edx
  801075:	89 0a                	mov    %ecx,(%edx)
  801077:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80107e:	8b 45 10             	mov    0x10(%ebp),%eax
  801081:	01 c2                	add    %eax,%edx
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801088:	eb 03                	jmp    80108d <strsplit+0x8f>
			string++;
  80108a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	84 c0                	test   %al,%al
  801094:	74 8b                	je     801021 <strsplit+0x23>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	0f be c0             	movsbl %al,%eax
  80109e:	50                   	push   %eax
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	e8 b5 fa ff ff       	call   800b5c <strchr>
  8010a7:	83 c4 08             	add    $0x8,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	74 dc                	je     80108a <strsplit+0x8c>
			string++;
	}
  8010ae:	e9 6e ff ff ff       	jmp    801021 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010b3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b7:	8b 00                	mov    (%eax),%eax
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 d0                	add    %edx,%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010cb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8010d0:	c9                   	leave  
  8010d1:	c3                   	ret    

008010d2 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8010d8:	a1 04 40 80 00       	mov    0x804004,%eax
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 1f                	je     801100 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8010e1:	e8 1d 00 00 00       	call   801103 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8010e6:	83 ec 0c             	sub    $0xc,%esp
  8010e9:	68 50 3a 80 00       	push   $0x803a50
  8010ee:	e8 55 f2 ff ff       	call   800348 <cprintf>
  8010f3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8010f6:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8010fd:	00 00 00 
	}
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801109:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801110:	00 00 00 
  801113:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80111a:	00 00 00 
  80111d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801124:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801127:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80112e:	00 00 00 
  801131:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801138:	00 00 00 
  80113b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801142:	00 00 00 
	uint32 arr_size = 0;
  801145:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80114c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801156:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80115b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801160:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801165:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80116c:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80116f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801176:	a1 20 41 80 00       	mov    0x804120,%eax
  80117b:	c1 e0 04             	shl    $0x4,%eax
  80117e:	89 c2                	mov    %eax,%edx
  801180:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801183:	01 d0                	add    %edx,%eax
  801185:	48                   	dec    %eax
  801186:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801189:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80118c:	ba 00 00 00 00       	mov    $0x0,%edx
  801191:	f7 75 ec             	divl   -0x14(%ebp)
  801194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801197:	29 d0                	sub    %edx,%eax
  801199:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80119c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	6a 06                	push   $0x6
  8011b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b8:	50                   	push   %eax
  8011b9:	e8 6a 04 00 00       	call   801628 <sys_allocate_chunk>
  8011be:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c1:	a1 20 41 80 00       	mov    0x804120,%eax
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 df 0a 00 00       	call   801cae <initialize_MemBlocksList>
  8011cf:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8011d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8011d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8011da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011dd:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8011e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8011ee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8011f2:	75 14                	jne    801208 <initialize_dyn_block_system+0x105>
  8011f4:	83 ec 04             	sub    $0x4,%esp
  8011f7:	68 75 3a 80 00       	push   $0x803a75
  8011fc:	6a 33                	push   $0x33
  8011fe:	68 93 3a 80 00       	push   $0x803a93
  801203:	e8 5f 1f 00 00       	call   803167 <_panic>
  801208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120b:	8b 00                	mov    (%eax),%eax
  80120d:	85 c0                	test   %eax,%eax
  80120f:	74 10                	je     801221 <initialize_dyn_block_system+0x11e>
  801211:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801219:	8b 52 04             	mov    0x4(%edx),%edx
  80121c:	89 50 04             	mov    %edx,0x4(%eax)
  80121f:	eb 0b                	jmp    80122c <initialize_dyn_block_system+0x129>
  801221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801224:	8b 40 04             	mov    0x4(%eax),%eax
  801227:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80122c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80122f:	8b 40 04             	mov    0x4(%eax),%eax
  801232:	85 c0                	test   %eax,%eax
  801234:	74 0f                	je     801245 <initialize_dyn_block_system+0x142>
  801236:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801239:	8b 40 04             	mov    0x4(%eax),%eax
  80123c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80123f:	8b 12                	mov    (%edx),%edx
  801241:	89 10                	mov    %edx,(%eax)
  801243:	eb 0a                	jmp    80124f <initialize_dyn_block_system+0x14c>
  801245:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801248:	8b 00                	mov    (%eax),%eax
  80124a:	a3 48 41 80 00       	mov    %eax,0x804148
  80124f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801258:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80125b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801262:	a1 54 41 80 00       	mov    0x804154,%eax
  801267:	48                   	dec    %eax
  801268:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80126d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801271:	75 14                	jne    801287 <initialize_dyn_block_system+0x184>
  801273:	83 ec 04             	sub    $0x4,%esp
  801276:	68 a0 3a 80 00       	push   $0x803aa0
  80127b:	6a 34                	push   $0x34
  80127d:	68 93 3a 80 00       	push   $0x803a93
  801282:	e8 e0 1e 00 00       	call   803167 <_panic>
  801287:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80128d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801290:	89 10                	mov    %edx,(%eax)
  801292:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801295:	8b 00                	mov    (%eax),%eax
  801297:	85 c0                	test   %eax,%eax
  801299:	74 0d                	je     8012a8 <initialize_dyn_block_system+0x1a5>
  80129b:	a1 38 41 80 00       	mov    0x804138,%eax
  8012a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8012a3:	89 50 04             	mov    %edx,0x4(%eax)
  8012a6:	eb 08                	jmp    8012b0 <initialize_dyn_block_system+0x1ad>
  8012a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8012b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8012c2:	a1 44 41 80 00       	mov    0x804144,%eax
  8012c7:	40                   	inc    %eax
  8012c8:	a3 44 41 80 00       	mov    %eax,0x804144
}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012d6:	e8 f7 fd ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012df:	75 07                	jne    8012e8 <malloc+0x18>
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e6:	eb 61                	jmp    801349 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8012e8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8012ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f5:	01 d0                	add    %edx,%eax
  8012f7:	48                   	dec    %eax
  8012f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801303:	f7 75 f0             	divl   -0x10(%ebp)
  801306:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801309:	29 d0                	sub    %edx,%eax
  80130b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80130e:	e8 e3 06 00 00       	call   8019f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801313:	85 c0                	test   %eax,%eax
  801315:	74 11                	je     801328 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	ff 75 e8             	pushl  -0x18(%ebp)
  80131d:	e8 4e 0d 00 00       	call   802070 <alloc_block_FF>
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80132c:	74 16                	je     801344 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80132e:	83 ec 0c             	sub    $0xc,%esp
  801331:	ff 75 f4             	pushl  -0xc(%ebp)
  801334:	e8 aa 0a 00 00       	call   801de3 <insert_sorted_allocList>
  801339:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	8b 40 08             	mov    0x8(%eax),%eax
  801342:	eb 05                	jmp    801349 <malloc+0x79>
	}

    return NULL;
  801344:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801351:	83 ec 04             	sub    $0x4,%esp
  801354:	68 c4 3a 80 00       	push   $0x803ac4
  801359:	6a 6f                	push   $0x6f
  80135b:	68 93 3a 80 00       	push   $0x803a93
  801360:	e8 02 1e 00 00       	call   803167 <_panic>

00801365 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 38             	sub    $0x38,%esp
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801371:	e8 5c fd ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  801376:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137a:	75 07                	jne    801383 <smalloc+0x1e>
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	eb 7c                	jmp    8013ff <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801383:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80138a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	01 d0                	add    %edx,%eax
  801392:	48                   	dec    %eax
  801393:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801399:	ba 00 00 00 00       	mov    $0x0,%edx
  80139e:	f7 75 f0             	divl   -0x10(%ebp)
  8013a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a4:	29 d0                	sub    %edx,%eax
  8013a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8013a9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013b0:	e8 41 06 00 00       	call   8019f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	74 11                	je     8013ca <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8013b9:	83 ec 0c             	sub    $0xc,%esp
  8013bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8013bf:	e8 ac 0c 00 00       	call   802070 <alloc_block_FF>
  8013c4:	83 c4 10             	add    $0x10,%esp
  8013c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8013ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013ce:	74 2a                	je     8013fa <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8013d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d3:	8b 40 08             	mov    0x8(%eax),%eax
  8013d6:	89 c2                	mov    %eax,%edx
  8013d8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8013dc:	52                   	push   %edx
  8013dd:	50                   	push   %eax
  8013de:	ff 75 0c             	pushl  0xc(%ebp)
  8013e1:	ff 75 08             	pushl  0x8(%ebp)
  8013e4:	e8 92 03 00 00       	call   80177b <sys_createSharedObject>
  8013e9:	83 c4 10             	add    $0x10,%esp
  8013ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8013ef:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8013f3:	74 05                	je     8013fa <smalloc+0x95>
			return (void*)virtual_address;
  8013f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f8:	eb 05                	jmp    8013ff <smalloc+0x9a>
	}
	return NULL;
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
  801404:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801407:	e8 c6 fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80140c:	83 ec 04             	sub    $0x4,%esp
  80140f:	68 e8 3a 80 00       	push   $0x803ae8
  801414:	68 b0 00 00 00       	push   $0xb0
  801419:	68 93 3a 80 00       	push   $0x803a93
  80141e:	e8 44 1d 00 00       	call   803167 <_panic>

00801423 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801429:	e8 a4 fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 0c 3b 80 00       	push   $0x803b0c
  801436:	68 f4 00 00 00       	push   $0xf4
  80143b:	68 93 3a 80 00       	push   $0x803a93
  801440:	e8 22 1d 00 00       	call   803167 <_panic>

00801445 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80144b:	83 ec 04             	sub    $0x4,%esp
  80144e:	68 34 3b 80 00       	push   $0x803b34
  801453:	68 08 01 00 00       	push   $0x108
  801458:	68 93 3a 80 00       	push   $0x803a93
  80145d:	e8 05 1d 00 00       	call   803167 <_panic>

00801462 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	68 58 3b 80 00       	push   $0x803b58
  801470:	68 13 01 00 00       	push   $0x113
  801475:	68 93 3a 80 00       	push   $0x803a93
  80147a:	e8 e8 1c 00 00       	call   803167 <_panic>

0080147f <shrink>:

}
void shrink(uint32 newSize)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801485:	83 ec 04             	sub    $0x4,%esp
  801488:	68 58 3b 80 00       	push   $0x803b58
  80148d:	68 18 01 00 00       	push   $0x118
  801492:	68 93 3a 80 00       	push   $0x803a93
  801497:	e8 cb 1c 00 00       	call   803167 <_panic>

0080149c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014a2:	83 ec 04             	sub    $0x4,%esp
  8014a5:	68 58 3b 80 00       	push   $0x803b58
  8014aa:	68 1d 01 00 00       	push   $0x11d
  8014af:	68 93 3a 80 00       	push   $0x803a93
  8014b4:	e8 ae 1c 00 00       	call   803167 <_panic>

008014b9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	57                   	push   %edi
  8014bd:	56                   	push   %esi
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014d4:	cd 30                	int    $0x30
  8014d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5f                   	pop    %edi
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	52                   	push   %edx
  8014fc:	ff 75 0c             	pushl  0xc(%ebp)
  8014ff:	50                   	push   %eax
  801500:	6a 00                	push   $0x0
  801502:	e8 b2 ff ff ff       	call   8014b9 <syscall>
  801507:	83 c4 18             	add    $0x18,%esp
}
  80150a:	90                   	nop
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_cgetc>:

int
sys_cgetc(void)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 01                	push   $0x1
  80151c:	e8 98 ff ff ff       	call   8014b9 <syscall>
  801521:	83 c4 18             	add    $0x18,%esp
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	52                   	push   %edx
  801536:	50                   	push   %eax
  801537:	6a 05                	push   $0x5
  801539:	e8 7b ff ff ff       	call   8014b9 <syscall>
  80153e:	83 c4 18             	add    $0x18,%esp
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	56                   	push   %esi
  801547:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801548:	8b 75 18             	mov    0x18(%ebp),%esi
  80154b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80154e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	56                   	push   %esi
  801558:	53                   	push   %ebx
  801559:	51                   	push   %ecx
  80155a:	52                   	push   %edx
  80155b:	50                   	push   %eax
  80155c:	6a 06                	push   $0x6
  80155e:	e8 56 ff ff ff       	call   8014b9 <syscall>
  801563:	83 c4 18             	add    $0x18,%esp
}
  801566:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801569:	5b                   	pop    %ebx
  80156a:	5e                   	pop    %esi
  80156b:	5d                   	pop    %ebp
  80156c:	c3                   	ret    

0080156d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	52                   	push   %edx
  80157d:	50                   	push   %eax
  80157e:	6a 07                	push   $0x7
  801580:	e8 34 ff ff ff       	call   8014b9 <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	ff 75 0c             	pushl  0xc(%ebp)
  801596:	ff 75 08             	pushl  0x8(%ebp)
  801599:	6a 08                	push   $0x8
  80159b:	e8 19 ff ff ff       	call   8014b9 <syscall>
  8015a0:	83 c4 18             	add    $0x18,%esp
}
  8015a3:	c9                   	leave  
  8015a4:	c3                   	ret    

008015a5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 09                	push   $0x9
  8015b4:	e8 00 ff ff ff       	call   8014b9 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
}
  8015bc:	c9                   	leave  
  8015bd:	c3                   	ret    

008015be <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 0a                	push   $0xa
  8015cd:	e8 e7 fe ff ff       	call   8014b9 <syscall>
  8015d2:	83 c4 18             	add    $0x18,%esp
}
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 0b                	push   $0xb
  8015e6:	e8 ce fe ff ff       	call   8014b9 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	ff 75 08             	pushl  0x8(%ebp)
  8015ff:	6a 0f                	push   $0xf
  801601:	e8 b3 fe ff ff       	call   8014b9 <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
	return;
  801609:	90                   	nop
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	ff 75 0c             	pushl  0xc(%ebp)
  801618:	ff 75 08             	pushl  0x8(%ebp)
  80161b:	6a 10                	push   $0x10
  80161d:	e8 97 fe ff ff       	call   8014b9 <syscall>
  801622:	83 c4 18             	add    $0x18,%esp
	return ;
  801625:	90                   	nop
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	ff 75 10             	pushl  0x10(%ebp)
  801632:	ff 75 0c             	pushl  0xc(%ebp)
  801635:	ff 75 08             	pushl  0x8(%ebp)
  801638:	6a 11                	push   $0x11
  80163a:	e8 7a fe ff ff       	call   8014b9 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
	return ;
  801642:	90                   	nop
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 0c                	push   $0xc
  801654:	e8 60 fe ff ff       	call   8014b9 <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	6a 0d                	push   $0xd
  80166e:	e8 46 fe ff ff       	call   8014b9 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 0e                	push   $0xe
  801687:	e8 2d fe ff ff       	call   8014b9 <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
}
  80168f:	90                   	nop
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 13                	push   $0x13
  8016a1:	e8 13 fe ff ff       	call   8014b9 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	90                   	nop
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 14                	push   $0x14
  8016bb:	e8 f9 fd ff ff       	call   8014b9 <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	90                   	nop
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	50                   	push   %eax
  8016df:	6a 15                	push   $0x15
  8016e1:	e8 d3 fd ff ff       	call   8014b9 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 16                	push   $0x16
  8016fb:	e8 b9 fd ff ff       	call   8014b9 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	50                   	push   %eax
  801716:	6a 17                	push   $0x17
  801718:	e8 9c fd ff ff       	call   8014b9 <syscall>
  80171d:	83 c4 18             	add    $0x18,%esp
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	6a 1a                	push   $0x1a
  801735:	e8 7f fd ff ff       	call   8014b9 <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801742:	8b 55 0c             	mov    0xc(%ebp),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	6a 00                	push   $0x0
  80174e:	52                   	push   %edx
  80174f:	50                   	push   %eax
  801750:	6a 18                	push   $0x18
  801752:	e8 62 fd ff ff       	call   8014b9 <syscall>
  801757:	83 c4 18             	add    $0x18,%esp
}
  80175a:	90                   	nop
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	52                   	push   %edx
  80176d:	50                   	push   %eax
  80176e:	6a 19                	push   $0x19
  801770:	e8 44 fd ff ff       	call   8014b9 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801787:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	6a 00                	push   $0x0
  801793:	51                   	push   %ecx
  801794:	52                   	push   %edx
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	50                   	push   %eax
  801799:	6a 1b                	push   $0x1b
  80179b:	e8 19 fd ff ff       	call   8014b9 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	52                   	push   %edx
  8017b5:	50                   	push   %eax
  8017b6:	6a 1c                	push   $0x1c
  8017b8:	e8 fc fc ff ff       	call   8014b9 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	51                   	push   %ecx
  8017d3:	52                   	push   %edx
  8017d4:	50                   	push   %eax
  8017d5:	6a 1d                	push   $0x1d
  8017d7:	e8 dd fc ff ff       	call   8014b9 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 1e                	push   $0x1e
  8017f4:	e8 c0 fc ff ff       	call   8014b9 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 1f                	push   $0x1f
  80180d:	e8 a7 fc ff ff       	call   8014b9 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	ff 75 14             	pushl  0x14(%ebp)
  801822:	ff 75 10             	pushl  0x10(%ebp)
  801825:	ff 75 0c             	pushl  0xc(%ebp)
  801828:	50                   	push   %eax
  801829:	6a 20                	push   $0x20
  80182b:	e8 89 fc ff ff       	call   8014b9 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	50                   	push   %eax
  801844:	6a 21                	push   $0x21
  801846:	e8 6e fc ff ff       	call   8014b9 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	90                   	nop
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	50                   	push   %eax
  801860:	6a 22                	push   $0x22
  801862:	e8 52 fc ff ff       	call   8014b9 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 02                	push   $0x2
  80187b:	e8 39 fc ff ff       	call   8014b9 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 03                	push   $0x3
  801894:	e8 20 fc ff ff       	call   8014b9 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 04                	push   $0x4
  8018ad:	e8 07 fc ff ff       	call   8014b9 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_exit_env>:


void sys_exit_env(void)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 23                	push   $0x23
  8018c6:	e8 ee fb ff ff       	call   8014b9 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	90                   	nop
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018da:	8d 50 04             	lea    0x4(%eax),%edx
  8018dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 24                	push   $0x24
  8018ea:	e8 ca fb ff ff       	call   8014b9 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
	return result;
  8018f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018fb:	89 01                	mov    %eax,(%ecx)
  8018fd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	c9                   	leave  
  801904:	c2 04 00             	ret    $0x4

00801907 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 10             	pushl  0x10(%ebp)
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	6a 12                	push   $0x12
  801919:	e8 9b fb ff ff       	call   8014b9 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
	return ;
  801921:	90                   	nop
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_rcr2>:
uint32 sys_rcr2()
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 25                	push   $0x25
  801933:	e8 81 fb ff ff       	call   8014b9 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801949:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	50                   	push   %eax
  801956:	6a 26                	push   $0x26
  801958:	e8 5c fb ff ff       	call   8014b9 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return ;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <rsttst>:
void rsttst()
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 28                	push   $0x28
  801972:	e8 42 fb ff ff       	call   8014b9 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
	return ;
  80197a:	90                   	nop
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	8b 45 14             	mov    0x14(%ebp),%eax
  801986:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801989:	8b 55 18             	mov    0x18(%ebp),%edx
  80198c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801990:	52                   	push   %edx
  801991:	50                   	push   %eax
  801992:	ff 75 10             	pushl  0x10(%ebp)
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	6a 27                	push   $0x27
  80199d:	e8 17 fb ff ff       	call   8014b9 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a5:	90                   	nop
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <chktst>:
void chktst(uint32 n)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 29                	push   $0x29
  8019b8:	e8 fc fa ff ff       	call   8014b9 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <inctst>:

void inctst()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 2a                	push   $0x2a
  8019d2:	e8 e2 fa ff ff       	call   8014b9 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019da:	90                   	nop
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <gettst>:
uint32 gettst()
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 2b                	push   $0x2b
  8019ec:	e8 c8 fa ff ff       	call   8014b9 <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 2c                	push   $0x2c
  801a08:	e8 ac fa ff ff       	call   8014b9 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
  801a10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a13:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a17:	75 07                	jne    801a20 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a19:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1e:	eb 05                	jmp    801a25 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 2c                	push   $0x2c
  801a39:	e8 7b fa ff ff       	call   8014b9 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
  801a41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a44:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a48:	75 07                	jne    801a51 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4f:	eb 05                	jmp    801a56 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
  801a5b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 2c                	push   $0x2c
  801a6a:	e8 4a fa ff ff       	call   8014b9 <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
  801a72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a75:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a79:	75 07                	jne    801a82 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a7b:	b8 01 00 00 00       	mov    $0x1,%eax
  801a80:	eb 05                	jmp    801a87 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 2c                	push   $0x2c
  801a9b:	e8 19 fa ff ff       	call   8014b9 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
  801aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801aa6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801aaa:	75 07                	jne    801ab3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801aac:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab1:	eb 05                	jmp    801ab8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	6a 2d                	push   $0x2d
  801aca:	e8 ea f9 ff ff       	call   8014b9 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad2:	90                   	nop
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ad9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801adc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	53                   	push   %ebx
  801ae8:	51                   	push   %ecx
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 2e                	push   $0x2e
  801aed:	e8 c7 f9 ff ff       	call   8014b9 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801af8:	c9                   	leave  
  801af9:	c3                   	ret    

00801afa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	52                   	push   %edx
  801b0a:	50                   	push   %eax
  801b0b:	6a 2f                	push   $0x2f
  801b0d:	e8 a7 f9 ff ff       	call   8014b9 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	68 68 3b 80 00       	push   $0x803b68
  801b25:	e8 1e e8 ff ff       	call   800348 <cprintf>
  801b2a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b34:	83 ec 0c             	sub    $0xc,%esp
  801b37:	68 94 3b 80 00       	push   $0x803b94
  801b3c:	e8 07 e8 ff ff       	call   800348 <cprintf>
  801b41:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b44:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b48:	a1 38 41 80 00       	mov    0x804138,%eax
  801b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b50:	eb 56                	jmp    801ba8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b56:	74 1c                	je     801b74 <print_mem_block_lists+0x5d>
  801b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5b:	8b 50 08             	mov    0x8(%eax),%edx
  801b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b61:	8b 48 08             	mov    0x8(%eax),%ecx
  801b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b67:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6a:	01 c8                	add    %ecx,%eax
  801b6c:	39 c2                	cmp    %eax,%edx
  801b6e:	73 04                	jae    801b74 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801b70:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b77:	8b 50 08             	mov    0x8(%eax),%edx
  801b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b80:	01 c2                	add    %eax,%edx
  801b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b85:	8b 40 08             	mov    0x8(%eax),%eax
  801b88:	83 ec 04             	sub    $0x4,%esp
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	68 a9 3b 80 00       	push   $0x803ba9
  801b92:	e8 b1 e7 ff ff       	call   800348 <cprintf>
  801b97:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ba0:	a1 40 41 80 00       	mov    0x804140,%eax
  801ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bac:	74 07                	je     801bb5 <print_mem_block_lists+0x9e>
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	8b 00                	mov    (%eax),%eax
  801bb3:	eb 05                	jmp    801bba <print_mem_block_lists+0xa3>
  801bb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bba:	a3 40 41 80 00       	mov    %eax,0x804140
  801bbf:	a1 40 41 80 00       	mov    0x804140,%eax
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	75 8a                	jne    801b52 <print_mem_block_lists+0x3b>
  801bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bcc:	75 84                	jne    801b52 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801bce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801bd2:	75 10                	jne    801be4 <print_mem_block_lists+0xcd>
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	68 b8 3b 80 00       	push   $0x803bb8
  801bdc:	e8 67 e7 ff ff       	call   800348 <cprintf>
  801be1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801be4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801beb:	83 ec 0c             	sub    $0xc,%esp
  801bee:	68 dc 3b 80 00       	push   $0x803bdc
  801bf3:	e8 50 e7 ff ff       	call   800348 <cprintf>
  801bf8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801bfb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801bff:	a1 40 40 80 00       	mov    0x804040,%eax
  801c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c07:	eb 56                	jmp    801c5f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c0d:	74 1c                	je     801c2b <print_mem_block_lists+0x114>
  801c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c12:	8b 50 08             	mov    0x8(%eax),%edx
  801c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c18:	8b 48 08             	mov    0x8(%eax),%ecx
  801c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c21:	01 c8                	add    %ecx,%eax
  801c23:	39 c2                	cmp    %eax,%edx
  801c25:	73 04                	jae    801c2b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801c27:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2e:	8b 50 08             	mov    0x8(%eax),%edx
  801c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c34:	8b 40 0c             	mov    0xc(%eax),%eax
  801c37:	01 c2                	add    %eax,%edx
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	8b 40 08             	mov    0x8(%eax),%eax
  801c3f:	83 ec 04             	sub    $0x4,%esp
  801c42:	52                   	push   %edx
  801c43:	50                   	push   %eax
  801c44:	68 a9 3b 80 00       	push   $0x803ba9
  801c49:	e8 fa e6 ff ff       	call   800348 <cprintf>
  801c4e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c57:	a1 48 40 80 00       	mov    0x804048,%eax
  801c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c63:	74 07                	je     801c6c <print_mem_block_lists+0x155>
  801c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c68:	8b 00                	mov    (%eax),%eax
  801c6a:	eb 05                	jmp    801c71 <print_mem_block_lists+0x15a>
  801c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c71:	a3 48 40 80 00       	mov    %eax,0x804048
  801c76:	a1 48 40 80 00       	mov    0x804048,%eax
  801c7b:	85 c0                	test   %eax,%eax
  801c7d:	75 8a                	jne    801c09 <print_mem_block_lists+0xf2>
  801c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c83:	75 84                	jne    801c09 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c85:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c89:	75 10                	jne    801c9b <print_mem_block_lists+0x184>
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	68 f4 3b 80 00       	push   $0x803bf4
  801c93:	e8 b0 e6 ff ff       	call   800348 <cprintf>
  801c98:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c9b:	83 ec 0c             	sub    $0xc,%esp
  801c9e:	68 68 3b 80 00       	push   $0x803b68
  801ca3:	e8 a0 e6 ff ff       	call   800348 <cprintf>
  801ca8:	83 c4 10             	add    $0x10,%esp

}
  801cab:	90                   	nop
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801cb4:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801cbb:	00 00 00 
  801cbe:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801cc5:	00 00 00 
  801cc8:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ccf:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cd9:	e9 9e 00 00 00       	jmp    801d7c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801cde:	a1 50 40 80 00       	mov    0x804050,%eax
  801ce3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce6:	c1 e2 04             	shl    $0x4,%edx
  801ce9:	01 d0                	add    %edx,%eax
  801ceb:	85 c0                	test   %eax,%eax
  801ced:	75 14                	jne    801d03 <initialize_MemBlocksList+0x55>
  801cef:	83 ec 04             	sub    $0x4,%esp
  801cf2:	68 1c 3c 80 00       	push   $0x803c1c
  801cf7:	6a 46                	push   $0x46
  801cf9:	68 3f 3c 80 00       	push   $0x803c3f
  801cfe:	e8 64 14 00 00       	call   803167 <_panic>
  801d03:	a1 50 40 80 00       	mov    0x804050,%eax
  801d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0b:	c1 e2 04             	shl    $0x4,%edx
  801d0e:	01 d0                	add    %edx,%eax
  801d10:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801d16:	89 10                	mov    %edx,(%eax)
  801d18:	8b 00                	mov    (%eax),%eax
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	74 18                	je     801d36 <initialize_MemBlocksList+0x88>
  801d1e:	a1 48 41 80 00       	mov    0x804148,%eax
  801d23:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d29:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d2c:	c1 e1 04             	shl    $0x4,%ecx
  801d2f:	01 ca                	add    %ecx,%edx
  801d31:	89 50 04             	mov    %edx,0x4(%eax)
  801d34:	eb 12                	jmp    801d48 <initialize_MemBlocksList+0x9a>
  801d36:	a1 50 40 80 00       	mov    0x804050,%eax
  801d3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3e:	c1 e2 04             	shl    $0x4,%edx
  801d41:	01 d0                	add    %edx,%eax
  801d43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d48:	a1 50 40 80 00       	mov    0x804050,%eax
  801d4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d50:	c1 e2 04             	shl    $0x4,%edx
  801d53:	01 d0                	add    %edx,%eax
  801d55:	a3 48 41 80 00       	mov    %eax,0x804148
  801d5a:	a1 50 40 80 00       	mov    0x804050,%eax
  801d5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d62:	c1 e2 04             	shl    $0x4,%edx
  801d65:	01 d0                	add    %edx,%eax
  801d67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d6e:	a1 54 41 80 00       	mov    0x804154,%eax
  801d73:	40                   	inc    %eax
  801d74:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801d79:	ff 45 f4             	incl   -0xc(%ebp)
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d82:	0f 82 56 ff ff ff    	jb     801cde <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	8b 00                	mov    (%eax),%eax
  801d96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d99:	eb 19                	jmp    801db4 <find_block+0x29>
	{
		if(va==point->sva)
  801d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d9e:	8b 40 08             	mov    0x8(%eax),%eax
  801da1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801da4:	75 05                	jne    801dab <find_block+0x20>
		   return point;
  801da6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da9:	eb 36                	jmp    801de1 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8b 40 08             	mov    0x8(%eax),%eax
  801db1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801db8:	74 07                	je     801dc1 <find_block+0x36>
  801dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dbd:	8b 00                	mov    (%eax),%eax
  801dbf:	eb 05                	jmp    801dc6 <find_block+0x3b>
  801dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  801dc9:	89 42 08             	mov    %eax,0x8(%edx)
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	8b 40 08             	mov    0x8(%eax),%eax
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	75 c5                	jne    801d9b <find_block+0x10>
  801dd6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801dda:	75 bf                	jne    801d9b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801ddc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801de9:	a1 40 40 80 00       	mov    0x804040,%eax
  801dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801df1:	a1 44 40 80 00       	mov    0x804044,%eax
  801df6:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801dff:	74 24                	je     801e25 <insert_sorted_allocList+0x42>
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	8b 50 08             	mov    0x8(%eax),%edx
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	8b 40 08             	mov    0x8(%eax),%eax
  801e0d:	39 c2                	cmp    %eax,%edx
  801e0f:	76 14                	jbe    801e25 <insert_sorted_allocList+0x42>
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	8b 50 08             	mov    0x8(%eax),%edx
  801e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1a:	8b 40 08             	mov    0x8(%eax),%eax
  801e1d:	39 c2                	cmp    %eax,%edx
  801e1f:	0f 82 60 01 00 00    	jb     801f85 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e29:	75 65                	jne    801e90 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e2f:	75 14                	jne    801e45 <insert_sorted_allocList+0x62>
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	68 1c 3c 80 00       	push   $0x803c1c
  801e39:	6a 6b                	push   $0x6b
  801e3b:	68 3f 3c 80 00       	push   $0x803c3f
  801e40:	e8 22 13 00 00       	call   803167 <_panic>
  801e45:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	89 10                	mov    %edx,(%eax)
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	8b 00                	mov    (%eax),%eax
  801e55:	85 c0                	test   %eax,%eax
  801e57:	74 0d                	je     801e66 <insert_sorted_allocList+0x83>
  801e59:	a1 40 40 80 00       	mov    0x804040,%eax
  801e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e61:	89 50 04             	mov    %edx,0x4(%eax)
  801e64:	eb 08                	jmp    801e6e <insert_sorted_allocList+0x8b>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	a3 44 40 80 00       	mov    %eax,0x804044
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e71:	a3 40 40 80 00       	mov    %eax,0x804040
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e80:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e85:	40                   	inc    %eax
  801e86:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e8b:	e9 dc 01 00 00       	jmp    80206c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e90:	8b 45 08             	mov    0x8(%ebp),%eax
  801e93:	8b 50 08             	mov    0x8(%eax),%edx
  801e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e99:	8b 40 08             	mov    0x8(%eax),%eax
  801e9c:	39 c2                	cmp    %eax,%edx
  801e9e:	77 6c                	ja     801f0c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801ea0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ea4:	74 06                	je     801eac <insert_sorted_allocList+0xc9>
  801ea6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801eaa:	75 14                	jne    801ec0 <insert_sorted_allocList+0xdd>
  801eac:	83 ec 04             	sub    $0x4,%esp
  801eaf:	68 58 3c 80 00       	push   $0x803c58
  801eb4:	6a 6f                	push   $0x6f
  801eb6:	68 3f 3c 80 00       	push   $0x803c3f
  801ebb:	e8 a7 12 00 00       	call   803167 <_panic>
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec3:	8b 50 04             	mov    0x4(%eax),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	89 50 04             	mov    %edx,0x4(%eax)
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ed2:	89 10                	mov    %edx,(%eax)
  801ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed7:	8b 40 04             	mov    0x4(%eax),%eax
  801eda:	85 c0                	test   %eax,%eax
  801edc:	74 0d                	je     801eeb <insert_sorted_allocList+0x108>
  801ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee1:	8b 40 04             	mov    0x4(%eax),%eax
  801ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ee7:	89 10                	mov    %edx,(%eax)
  801ee9:	eb 08                	jmp    801ef3 <insert_sorted_allocList+0x110>
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	a3 40 40 80 00       	mov    %eax,0x804040
  801ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef9:	89 50 04             	mov    %edx,0x4(%eax)
  801efc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f01:	40                   	inc    %eax
  801f02:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f07:	e9 60 01 00 00       	jmp    80206c <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0f:	8b 50 08             	mov    0x8(%eax),%edx
  801f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f15:	8b 40 08             	mov    0x8(%eax),%eax
  801f18:	39 c2                	cmp    %eax,%edx
  801f1a:	0f 82 4c 01 00 00    	jb     80206c <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801f20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f24:	75 14                	jne    801f3a <insert_sorted_allocList+0x157>
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	68 90 3c 80 00       	push   $0x803c90
  801f2e:	6a 73                	push   $0x73
  801f30:	68 3f 3c 80 00       	push   $0x803c3f
  801f35:	e8 2d 12 00 00       	call   803167 <_panic>
  801f3a:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	89 50 04             	mov    %edx,0x4(%eax)
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 40 04             	mov    0x4(%eax),%eax
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	74 0c                	je     801f5c <insert_sorted_allocList+0x179>
  801f50:	a1 44 40 80 00       	mov    0x804044,%eax
  801f55:	8b 55 08             	mov    0x8(%ebp),%edx
  801f58:	89 10                	mov    %edx,(%eax)
  801f5a:	eb 08                	jmp    801f64 <insert_sorted_allocList+0x181>
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	a3 40 40 80 00       	mov    %eax,0x804040
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 44 40 80 00       	mov    %eax,0x804044
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f75:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f7a:	40                   	inc    %eax
  801f7b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f80:	e9 e7 00 00 00       	jmp    80206c <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f8b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f92:	a1 40 40 80 00       	mov    0x804040,%eax
  801f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9a:	e9 9d 00 00 00       	jmp    80203c <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 00                	mov    (%eax),%eax
  801fa4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	8b 50 08             	mov    0x8(%eax),%edx
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 40 08             	mov    0x8(%eax),%eax
  801fb3:	39 c2                	cmp    %eax,%edx
  801fb5:	76 7d                	jbe    802034 <insert_sorted_allocList+0x251>
  801fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fba:	8b 50 08             	mov    0x8(%eax),%edx
  801fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc0:	8b 40 08             	mov    0x8(%eax),%eax
  801fc3:	39 c2                	cmp    %eax,%edx
  801fc5:	73 6d                	jae    802034 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	74 06                	je     801fd3 <insert_sorted_allocList+0x1f0>
  801fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fd1:	75 14                	jne    801fe7 <insert_sorted_allocList+0x204>
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	68 b4 3c 80 00       	push   $0x803cb4
  801fdb:	6a 7f                	push   $0x7f
  801fdd:	68 3f 3c 80 00       	push   $0x803c3f
  801fe2:	e8 80 11 00 00       	call   803167 <_panic>
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fea:	8b 10                	mov    (%eax),%edx
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	89 10                	mov    %edx,(%eax)
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	8b 00                	mov    (%eax),%eax
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	74 0b                	je     802005 <insert_sorted_allocList+0x222>
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	8b 00                	mov    (%eax),%eax
  801fff:	8b 55 08             	mov    0x8(%ebp),%edx
  802002:	89 50 04             	mov    %edx,0x4(%eax)
  802005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802008:	8b 55 08             	mov    0x8(%ebp),%edx
  80200b:	89 10                	mov    %edx,(%eax)
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802013:	89 50 04             	mov    %edx,0x4(%eax)
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	8b 00                	mov    (%eax),%eax
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 08                	jne    802027 <insert_sorted_allocList+0x244>
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	a3 44 40 80 00       	mov    %eax,0x804044
  802027:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80202c:	40                   	inc    %eax
  80202d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802032:	eb 39                	jmp    80206d <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802034:	a1 48 40 80 00       	mov    0x804048,%eax
  802039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802040:	74 07                	je     802049 <insert_sorted_allocList+0x266>
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 00                	mov    (%eax),%eax
  802047:	eb 05                	jmp    80204e <insert_sorted_allocList+0x26b>
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	a3 48 40 80 00       	mov    %eax,0x804048
  802053:	a1 48 40 80 00       	mov    0x804048,%eax
  802058:	85 c0                	test   %eax,%eax
  80205a:	0f 85 3f ff ff ff    	jne    801f9f <insert_sorted_allocList+0x1bc>
  802060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802064:	0f 85 35 ff ff ff    	jne    801f9f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80206a:	eb 01                	jmp    80206d <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80206c:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80206d:	90                   	nop
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802076:	a1 38 41 80 00       	mov    0x804138,%eax
  80207b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207e:	e9 85 01 00 00       	jmp    802208 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 40 0c             	mov    0xc(%eax),%eax
  802089:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208c:	0f 82 6e 01 00 00    	jb     802200 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 40 0c             	mov    0xc(%eax),%eax
  802098:	3b 45 08             	cmp    0x8(%ebp),%eax
  80209b:	0f 85 8a 00 00 00    	jne    80212b <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8020a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a5:	75 17                	jne    8020be <alloc_block_FF+0x4e>
  8020a7:	83 ec 04             	sub    $0x4,%esp
  8020aa:	68 e8 3c 80 00       	push   $0x803ce8
  8020af:	68 93 00 00 00       	push   $0x93
  8020b4:	68 3f 3c 80 00       	push   $0x803c3f
  8020b9:	e8 a9 10 00 00       	call   803167 <_panic>
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	74 10                	je     8020d7 <alloc_block_FF+0x67>
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cf:	8b 52 04             	mov    0x4(%edx),%edx
  8020d2:	89 50 04             	mov    %edx,0x4(%eax)
  8020d5:	eb 0b                	jmp    8020e2 <alloc_block_FF+0x72>
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 40 04             	mov    0x4(%eax),%eax
  8020dd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 40 04             	mov    0x4(%eax),%eax
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	74 0f                	je     8020fb <alloc_block_FF+0x8b>
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	8b 40 04             	mov    0x4(%eax),%eax
  8020f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f5:	8b 12                	mov    (%edx),%edx
  8020f7:	89 10                	mov    %edx,(%eax)
  8020f9:	eb 0a                	jmp    802105 <alloc_block_FF+0x95>
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 00                	mov    (%eax),%eax
  802100:	a3 38 41 80 00       	mov    %eax,0x804138
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802111:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802118:	a1 44 41 80 00       	mov    0x804144,%eax
  80211d:	48                   	dec    %eax
  80211e:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	e9 10 01 00 00       	jmp    80223b <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80212b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212e:	8b 40 0c             	mov    0xc(%eax),%eax
  802131:	3b 45 08             	cmp    0x8(%ebp),%eax
  802134:	0f 86 c6 00 00 00    	jbe    802200 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80213a:	a1 48 41 80 00       	mov    0x804148,%eax
  80213f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	8b 50 08             	mov    0x8(%eax),%edx
  802148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214b:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80214e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802151:	8b 55 08             	mov    0x8(%ebp),%edx
  802154:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802157:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215b:	75 17                	jne    802174 <alloc_block_FF+0x104>
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 e8 3c 80 00       	push   $0x803ce8
  802165:	68 9b 00 00 00       	push   $0x9b
  80216a:	68 3f 3c 80 00       	push   $0x803c3f
  80216f:	e8 f3 0f 00 00       	call   803167 <_panic>
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	85 c0                	test   %eax,%eax
  80217b:	74 10                	je     80218d <alloc_block_FF+0x11d>
  80217d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802180:	8b 00                	mov    (%eax),%eax
  802182:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802185:	8b 52 04             	mov    0x4(%edx),%edx
  802188:	89 50 04             	mov    %edx,0x4(%eax)
  80218b:	eb 0b                	jmp    802198 <alloc_block_FF+0x128>
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	8b 40 04             	mov    0x4(%eax),%eax
  802193:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802198:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219b:	8b 40 04             	mov    0x4(%eax),%eax
  80219e:	85 c0                	test   %eax,%eax
  8021a0:	74 0f                	je     8021b1 <alloc_block_FF+0x141>
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	8b 40 04             	mov    0x4(%eax),%eax
  8021a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021ab:	8b 12                	mov    (%edx),%edx
  8021ad:	89 10                	mov    %edx,(%eax)
  8021af:	eb 0a                	jmp    8021bb <alloc_block_FF+0x14b>
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b4:	8b 00                	mov    (%eax),%eax
  8021b6:	a3 48 41 80 00       	mov    %eax,0x804148
  8021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ce:	a1 54 41 80 00       	mov    0x804154,%eax
  8021d3:	48                   	dec    %eax
  8021d4:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 50 08             	mov    0x8(%eax),%edx
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	01 c2                	add    %eax,%edx
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8021f3:	89 c2                	mov    %eax,%edx
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fe:	eb 3b                	jmp    80223b <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802200:	a1 40 41 80 00       	mov    0x804140,%eax
  802205:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802208:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220c:	74 07                	je     802215 <alloc_block_FF+0x1a5>
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	eb 05                	jmp    80221a <alloc_block_FF+0x1aa>
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	a3 40 41 80 00       	mov    %eax,0x804140
  80221f:	a1 40 41 80 00       	mov    0x804140,%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	0f 85 57 fe ff ff    	jne    802083 <alloc_block_FF+0x13>
  80222c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802230:	0f 85 4d fe ff ff    	jne    802083 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802236:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
  802240:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802243:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80224a:	a1 38 41 80 00       	mov    0x804138,%eax
  80224f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802252:	e9 df 00 00 00       	jmp    802336 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 40 0c             	mov    0xc(%eax),%eax
  80225d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802260:	0f 82 c8 00 00 00    	jb     80232e <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 40 0c             	mov    0xc(%eax),%eax
  80226c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226f:	0f 85 8a 00 00 00    	jne    8022ff <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802279:	75 17                	jne    802292 <alloc_block_BF+0x55>
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	68 e8 3c 80 00       	push   $0x803ce8
  802283:	68 b7 00 00 00       	push   $0xb7
  802288:	68 3f 3c 80 00       	push   $0x803c3f
  80228d:	e8 d5 0e 00 00       	call   803167 <_panic>
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 10                	je     8022ab <alloc_block_BF+0x6e>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a3:	8b 52 04             	mov    0x4(%edx),%edx
  8022a6:	89 50 04             	mov    %edx,0x4(%eax)
  8022a9:	eb 0b                	jmp    8022b6 <alloc_block_BF+0x79>
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 40 04             	mov    0x4(%eax),%eax
  8022b1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 40 04             	mov    0x4(%eax),%eax
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	74 0f                	je     8022cf <alloc_block_BF+0x92>
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 40 04             	mov    0x4(%eax),%eax
  8022c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c9:	8b 12                	mov    (%edx),%edx
  8022cb:	89 10                	mov    %edx,(%eax)
  8022cd:	eb 0a                	jmp    8022d9 <alloc_block_BF+0x9c>
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 00                	mov    (%eax),%eax
  8022d4:	a3 38 41 80 00       	mov    %eax,0x804138
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8022f1:	48                   	dec    %eax
  8022f2:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	e9 4d 01 00 00       	jmp    80244c <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 40 0c             	mov    0xc(%eax),%eax
  802305:	3b 45 08             	cmp    0x8(%ebp),%eax
  802308:	76 24                	jbe    80232e <alloc_block_BF+0xf1>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 40 0c             	mov    0xc(%eax),%eax
  802310:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802313:	73 19                	jae    80232e <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802315:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231f:	8b 40 0c             	mov    0xc(%eax),%eax
  802322:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802328:	8b 40 08             	mov    0x8(%eax),%eax
  80232b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80232e:	a1 40 41 80 00       	mov    0x804140,%eax
  802333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233a:	74 07                	je     802343 <alloc_block_BF+0x106>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	eb 05                	jmp    802348 <alloc_block_BF+0x10b>
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	a3 40 41 80 00       	mov    %eax,0x804140
  80234d:	a1 40 41 80 00       	mov    0x804140,%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	0f 85 fd fe ff ff    	jne    802257 <alloc_block_BF+0x1a>
  80235a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235e:	0f 85 f3 fe ff ff    	jne    802257 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802364:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802368:	0f 84 d9 00 00 00    	je     802447 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80236e:	a1 48 41 80 00       	mov    0x804148,%eax
  802373:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802379:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80237c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80237f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
  802385:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802388:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80238c:	75 17                	jne    8023a5 <alloc_block_BF+0x168>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 e8 3c 80 00       	push   $0x803ce8
  802396:	68 c7 00 00 00       	push   $0xc7
  80239b:	68 3f 3c 80 00       	push   $0x803c3f
  8023a0:	e8 c2 0d 00 00       	call   803167 <_panic>
  8023a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	74 10                	je     8023be <alloc_block_BF+0x181>
  8023ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023b6:	8b 52 04             	mov    0x4(%edx),%edx
  8023b9:	89 50 04             	mov    %edx,0x4(%eax)
  8023bc:	eb 0b                	jmp    8023c9 <alloc_block_BF+0x18c>
  8023be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c1:	8b 40 04             	mov    0x4(%eax),%eax
  8023c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0f                	je     8023e2 <alloc_block_BF+0x1a5>
  8023d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d6:	8b 40 04             	mov    0x4(%eax),%eax
  8023d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023dc:	8b 12                	mov    (%edx),%edx
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	eb 0a                	jmp    8023ec <alloc_block_BF+0x1af>
  8023e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	a3 48 41 80 00       	mov    %eax,0x804148
  8023ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ff:	a1 54 41 80 00       	mov    0x804154,%eax
  802404:	48                   	dec    %eax
  802405:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80240a:	83 ec 08             	sub    $0x8,%esp
  80240d:	ff 75 ec             	pushl  -0x14(%ebp)
  802410:	68 38 41 80 00       	push   $0x804138
  802415:	e8 71 f9 ff ff       	call   801d8b <find_block>
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802423:	8b 50 08             	mov    0x8(%eax),%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	01 c2                	add    %eax,%edx
  80242b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80242e:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802434:	8b 40 0c             	mov    0xc(%eax),%eax
  802437:	2b 45 08             	sub    0x8(%ebp),%eax
  80243a:	89 c2                	mov    %eax,%edx
  80243c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243f:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802445:	eb 05                	jmp    80244c <alloc_block_BF+0x20f>
	}
	return NULL;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802454:	a1 28 40 80 00       	mov    0x804028,%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	0f 85 de 01 00 00    	jne    80263f <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802461:	a1 38 41 80 00       	mov    0x804138,%eax
  802466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802469:	e9 9e 01 00 00       	jmp    80260c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 40 0c             	mov    0xc(%eax),%eax
  802474:	3b 45 08             	cmp    0x8(%ebp),%eax
  802477:	0f 82 87 01 00 00    	jb     802604 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 0c             	mov    0xc(%eax),%eax
  802483:	3b 45 08             	cmp    0x8(%ebp),%eax
  802486:	0f 85 95 00 00 00    	jne    802521 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80248c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802490:	75 17                	jne    8024a9 <alloc_block_NF+0x5b>
  802492:	83 ec 04             	sub    $0x4,%esp
  802495:	68 e8 3c 80 00       	push   $0x803ce8
  80249a:	68 e0 00 00 00       	push   $0xe0
  80249f:	68 3f 3c 80 00       	push   $0x803c3f
  8024a4:	e8 be 0c 00 00       	call   803167 <_panic>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 00                	mov    (%eax),%eax
  8024ae:	85 c0                	test   %eax,%eax
  8024b0:	74 10                	je     8024c2 <alloc_block_NF+0x74>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ba:	8b 52 04             	mov    0x4(%edx),%edx
  8024bd:	89 50 04             	mov    %edx,0x4(%eax)
  8024c0:	eb 0b                	jmp    8024cd <alloc_block_NF+0x7f>
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	8b 40 04             	mov    0x4(%eax),%eax
  8024c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 40 04             	mov    0x4(%eax),%eax
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	74 0f                	je     8024e6 <alloc_block_NF+0x98>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 04             	mov    0x4(%eax),%eax
  8024dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e0:	8b 12                	mov    (%edx),%edx
  8024e2:	89 10                	mov    %edx,(%eax)
  8024e4:	eb 0a                	jmp    8024f0 <alloc_block_NF+0xa2>
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802503:	a1 44 41 80 00       	mov    0x804144,%eax
  802508:	48                   	dec    %eax
  802509:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 08             	mov    0x8(%eax),%eax
  802514:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	e9 f8 04 00 00       	jmp    802a19 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 0c             	mov    0xc(%eax),%eax
  802527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252a:	0f 86 d4 00 00 00    	jbe    802604 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802530:	a1 48 41 80 00       	mov    0x804148,%eax
  802535:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 50 08             	mov    0x8(%eax),%edx
  80253e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802541:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802547:	8b 55 08             	mov    0x8(%ebp),%edx
  80254a:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80254d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802551:	75 17                	jne    80256a <alloc_block_NF+0x11c>
  802553:	83 ec 04             	sub    $0x4,%esp
  802556:	68 e8 3c 80 00       	push   $0x803ce8
  80255b:	68 e9 00 00 00       	push   $0xe9
  802560:	68 3f 3c 80 00       	push   $0x803c3f
  802565:	e8 fd 0b 00 00       	call   803167 <_panic>
  80256a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 10                	je     802583 <alloc_block_NF+0x135>
  802573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80257b:	8b 52 04             	mov    0x4(%edx),%edx
  80257e:	89 50 04             	mov    %edx,0x4(%eax)
  802581:	eb 0b                	jmp    80258e <alloc_block_NF+0x140>
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80258e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	85 c0                	test   %eax,%eax
  802596:	74 0f                	je     8025a7 <alloc_block_NF+0x159>
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a1:	8b 12                	mov    (%edx),%edx
  8025a3:	89 10                	mov    %edx,(%eax)
  8025a5:	eb 0a                	jmp    8025b1 <alloc_block_NF+0x163>
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c4:	a1 54 41 80 00       	mov    0x804154,%eax
  8025c9:	48                   	dec    %eax
  8025ca:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	8b 40 08             	mov    0x8(%eax),%eax
  8025d5:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 50 08             	mov    0x8(%eax),%edx
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	01 c2                	add    %eax,%edx
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f4:	89 c2                	mov    %eax,%edx
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	e9 15 04 00 00       	jmp    802a19 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802604:	a1 40 41 80 00       	mov    0x804140,%eax
  802609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	74 07                	je     802619 <alloc_block_NF+0x1cb>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	eb 05                	jmp    80261e <alloc_block_NF+0x1d0>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	a3 40 41 80 00       	mov    %eax,0x804140
  802623:	a1 40 41 80 00       	mov    0x804140,%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	0f 85 3e fe ff ff    	jne    80246e <alloc_block_NF+0x20>
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	0f 85 34 fe ff ff    	jne    80246e <alloc_block_NF+0x20>
  80263a:	e9 d5 03 00 00       	jmp    802a14 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80263f:	a1 38 41 80 00       	mov    0x804138,%eax
  802644:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802647:	e9 b1 01 00 00       	jmp    8027fd <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 50 08             	mov    0x8(%eax),%edx
  802652:	a1 28 40 80 00       	mov    0x804028,%eax
  802657:	39 c2                	cmp    %eax,%edx
  802659:	0f 82 96 01 00 00    	jb     8027f5 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 0c             	mov    0xc(%eax),%eax
  802665:	3b 45 08             	cmp    0x8(%ebp),%eax
  802668:	0f 82 87 01 00 00    	jb     8027f5 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 40 0c             	mov    0xc(%eax),%eax
  802674:	3b 45 08             	cmp    0x8(%ebp),%eax
  802677:	0f 85 95 00 00 00    	jne    802712 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80267d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802681:	75 17                	jne    80269a <alloc_block_NF+0x24c>
  802683:	83 ec 04             	sub    $0x4,%esp
  802686:	68 e8 3c 80 00       	push   $0x803ce8
  80268b:	68 fc 00 00 00       	push   $0xfc
  802690:	68 3f 3c 80 00       	push   $0x803c3f
  802695:	e8 cd 0a 00 00       	call   803167 <_panic>
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 00                	mov    (%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 10                	je     8026b3 <alloc_block_NF+0x265>
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 00                	mov    (%eax),%eax
  8026a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ab:	8b 52 04             	mov    0x4(%edx),%edx
  8026ae:	89 50 04             	mov    %edx,0x4(%eax)
  8026b1:	eb 0b                	jmp    8026be <alloc_block_NF+0x270>
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	8b 40 04             	mov    0x4(%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	74 0f                	je     8026d7 <alloc_block_NF+0x289>
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d1:	8b 12                	mov    (%edx),%edx
  8026d3:	89 10                	mov    %edx,(%eax)
  8026d5:	eb 0a                	jmp    8026e1 <alloc_block_NF+0x293>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	a3 38 41 80 00       	mov    %eax,0x804138
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f4:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f9:	48                   	dec    %eax
  8026fa:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	e9 07 03 00 00       	jmp    802a19 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	3b 45 08             	cmp    0x8(%ebp),%eax
  80271b:	0f 86 d4 00 00 00    	jbe    8027f5 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802721:	a1 48 41 80 00       	mov    0x804148,%eax
  802726:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 50 08             	mov    0x8(%eax),%edx
  80272f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802732:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802738:	8b 55 08             	mov    0x8(%ebp),%edx
  80273b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80273e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802742:	75 17                	jne    80275b <alloc_block_NF+0x30d>
  802744:	83 ec 04             	sub    $0x4,%esp
  802747:	68 e8 3c 80 00       	push   $0x803ce8
  80274c:	68 04 01 00 00       	push   $0x104
  802751:	68 3f 3c 80 00       	push   $0x803c3f
  802756:	e8 0c 0a 00 00       	call   803167 <_panic>
  80275b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275e:	8b 00                	mov    (%eax),%eax
  802760:	85 c0                	test   %eax,%eax
  802762:	74 10                	je     802774 <alloc_block_NF+0x326>
  802764:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802767:	8b 00                	mov    (%eax),%eax
  802769:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80276c:	8b 52 04             	mov    0x4(%edx),%edx
  80276f:	89 50 04             	mov    %edx,0x4(%eax)
  802772:	eb 0b                	jmp    80277f <alloc_block_NF+0x331>
  802774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80277f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802782:	8b 40 04             	mov    0x4(%eax),%eax
  802785:	85 c0                	test   %eax,%eax
  802787:	74 0f                	je     802798 <alloc_block_NF+0x34a>
  802789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278c:	8b 40 04             	mov    0x4(%eax),%eax
  80278f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802792:	8b 12                	mov    (%edx),%edx
  802794:	89 10                	mov    %edx,(%eax)
  802796:	eb 0a                	jmp    8027a2 <alloc_block_NF+0x354>
  802798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	a3 48 41 80 00       	mov    %eax,0x804148
  8027a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b5:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ba:	48                   	dec    %eax
  8027bb:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8027c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c3:	8b 40 08             	mov    0x8(%eax),%eax
  8027c6:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 50 08             	mov    0x8(%eax),%edx
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	01 c2                	add    %eax,%edx
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e5:	89 c2                	mov    %eax,%edx
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8027ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f0:	e9 24 02 00 00       	jmp    802a19 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027f5:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	74 07                	je     80280a <alloc_block_NF+0x3bc>
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	eb 05                	jmp    80280f <alloc_block_NF+0x3c1>
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
  80280f:	a3 40 41 80 00       	mov    %eax,0x804140
  802814:	a1 40 41 80 00       	mov    0x804140,%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	0f 85 2b fe ff ff    	jne    80264c <alloc_block_NF+0x1fe>
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	0f 85 21 fe ff ff    	jne    80264c <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80282b:	a1 38 41 80 00       	mov    0x804138,%eax
  802830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802833:	e9 ae 01 00 00       	jmp    8029e6 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 50 08             	mov    0x8(%eax),%edx
  80283e:	a1 28 40 80 00       	mov    0x804028,%eax
  802843:	39 c2                	cmp    %eax,%edx
  802845:	0f 83 93 01 00 00    	jae    8029de <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 82 84 01 00 00    	jb     8029de <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 0c             	mov    0xc(%eax),%eax
  802860:	3b 45 08             	cmp    0x8(%ebp),%eax
  802863:	0f 85 95 00 00 00    	jne    8028fe <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286d:	75 17                	jne    802886 <alloc_block_NF+0x438>
  80286f:	83 ec 04             	sub    $0x4,%esp
  802872:	68 e8 3c 80 00       	push   $0x803ce8
  802877:	68 14 01 00 00       	push   $0x114
  80287c:	68 3f 3c 80 00       	push   $0x803c3f
  802881:	e8 e1 08 00 00       	call   803167 <_panic>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 10                	je     80289f <alloc_block_NF+0x451>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802897:	8b 52 04             	mov    0x4(%edx),%edx
  80289a:	89 50 04             	mov    %edx,0x4(%eax)
  80289d:	eb 0b                	jmp    8028aa <alloc_block_NF+0x45c>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 04             	mov    0x4(%eax),%eax
  8028a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 40 04             	mov    0x4(%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 0f                	je     8028c3 <alloc_block_NF+0x475>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bd:	8b 12                	mov    (%edx),%edx
  8028bf:	89 10                	mov    %edx,(%eax)
  8028c1:	eb 0a                	jmp    8028cd <alloc_block_NF+0x47f>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e5:	48                   	dec    %eax
  8028e6:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 08             	mov    0x8(%eax),%eax
  8028f1:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	e9 1b 01 00 00       	jmp    802a19 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 0c             	mov    0xc(%eax),%eax
  802904:	3b 45 08             	cmp    0x8(%ebp),%eax
  802907:	0f 86 d1 00 00 00    	jbe    8029de <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290d:	a1 48 41 80 00       	mov    0x804148,%eax
  802912:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 50 08             	mov    0x8(%eax),%edx
  80291b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802924:	8b 55 08             	mov    0x8(%ebp),%edx
  802927:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80292a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80292e:	75 17                	jne    802947 <alloc_block_NF+0x4f9>
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	68 e8 3c 80 00       	push   $0x803ce8
  802938:	68 1c 01 00 00       	push   $0x11c
  80293d:	68 3f 3c 80 00       	push   $0x803c3f
  802942:	e8 20 08 00 00       	call   803167 <_panic>
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	74 10                	je     802960 <alloc_block_NF+0x512>
  802950:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802958:	8b 52 04             	mov    0x4(%edx),%edx
  80295b:	89 50 04             	mov    %edx,0x4(%eax)
  80295e:	eb 0b                	jmp    80296b <alloc_block_NF+0x51d>
  802960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802963:	8b 40 04             	mov    0x4(%eax),%eax
  802966:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80296b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	74 0f                	je     802984 <alloc_block_NF+0x536>
  802975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80297e:	8b 12                	mov    (%edx),%edx
  802980:	89 10                	mov    %edx,(%eax)
  802982:	eb 0a                	jmp    80298e <alloc_block_NF+0x540>
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	a3 48 41 80 00       	mov    %eax,0x804148
  80298e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802997:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a1:	a1 54 41 80 00       	mov    0x804154,%eax
  8029a6:	48                   	dec    %eax
  8029a7:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029af:	8b 40 08             	mov    0x8(%eax),%eax
  8029b2:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 50 08             	mov    0x8(%eax),%edx
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	01 c2                	add    %eax,%edx
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d1:	89 c2                	mov    %eax,%edx
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	eb 3b                	jmp    802a19 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029de:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ea:	74 07                	je     8029f3 <alloc_block_NF+0x5a5>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	eb 05                	jmp    8029f8 <alloc_block_NF+0x5aa>
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	a3 40 41 80 00       	mov    %eax,0x804140
  8029fd:	a1 40 41 80 00       	mov    0x804140,%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	0f 85 2e fe ff ff    	jne    802838 <alloc_block_NF+0x3ea>
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	0f 85 24 fe ff ff    	jne    802838 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a19:	c9                   	leave  
  802a1a:	c3                   	ret    

00802a1b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a1b:	55                   	push   %ebp
  802a1c:	89 e5                	mov    %esp,%ebp
  802a1e:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802a21:	a1 38 41 80 00       	mov    0x804138,%eax
  802a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a29:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a2e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a31:	a1 38 41 80 00       	mov    0x804138,%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 14                	je     802a4e <insert_sorted_with_merge_freeList+0x33>
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a43:	8b 40 08             	mov    0x8(%eax),%eax
  802a46:	39 c2                	cmp    %eax,%edx
  802a48:	0f 87 9b 01 00 00    	ja     802be9 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a52:	75 17                	jne    802a6b <insert_sorted_with_merge_freeList+0x50>
  802a54:	83 ec 04             	sub    $0x4,%esp
  802a57:	68 1c 3c 80 00       	push   $0x803c1c
  802a5c:	68 38 01 00 00       	push   $0x138
  802a61:	68 3f 3c 80 00       	push   $0x803c3f
  802a66:	e8 fc 06 00 00       	call   803167 <_panic>
  802a6b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	89 10                	mov    %edx,(%eax)
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 00                	mov    (%eax),%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	74 0d                	je     802a8c <insert_sorted_with_merge_freeList+0x71>
  802a7f:	a1 38 41 80 00       	mov    0x804138,%eax
  802a84:	8b 55 08             	mov    0x8(%ebp),%edx
  802a87:	89 50 04             	mov    %edx,0x4(%eax)
  802a8a:	eb 08                	jmp    802a94 <insert_sorted_with_merge_freeList+0x79>
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	a3 38 41 80 00       	mov    %eax,0x804138
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa6:	a1 44 41 80 00       	mov    0x804144,%eax
  802aab:	40                   	inc    %eax
  802aac:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ab1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab5:	0f 84 a8 06 00 00    	je     803163 <insert_sorted_with_merge_freeList+0x748>
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	8b 50 08             	mov    0x8(%eax),%edx
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac7:	01 c2                	add    %eax,%edx
  802ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acc:	8b 40 08             	mov    0x8(%eax),%eax
  802acf:	39 c2                	cmp    %eax,%edx
  802ad1:	0f 85 8c 06 00 00    	jne    803163 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 50 0c             	mov    0xc(%eax),%edx
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae3:	01 c2                	add    %eax,%edx
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802aeb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aef:	75 17                	jne    802b08 <insert_sorted_with_merge_freeList+0xed>
  802af1:	83 ec 04             	sub    $0x4,%esp
  802af4:	68 e8 3c 80 00       	push   $0x803ce8
  802af9:	68 3c 01 00 00       	push   $0x13c
  802afe:	68 3f 3c 80 00       	push   $0x803c3f
  802b03:	e8 5f 06 00 00       	call   803167 <_panic>
  802b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 10                	je     802b21 <insert_sorted_with_merge_freeList+0x106>
  802b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b19:	8b 52 04             	mov    0x4(%edx),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
  802b1f:	eb 0b                	jmp    802b2c <insert_sorted_with_merge_freeList+0x111>
  802b21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b24:	8b 40 04             	mov    0x4(%eax),%eax
  802b27:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0f                	je     802b45 <insert_sorted_with_merge_freeList+0x12a>
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	8b 40 04             	mov    0x4(%eax),%eax
  802b3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3f:	8b 12                	mov    (%edx),%edx
  802b41:	89 10                	mov    %edx,(%eax)
  802b43:	eb 0a                	jmp    802b4f <insert_sorted_with_merge_freeList+0x134>
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	a3 38 41 80 00       	mov    %eax,0x804138
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b62:	a1 44 41 80 00       	mov    0x804144,%eax
  802b67:	48                   	dec    %eax
  802b68:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b85:	75 17                	jne    802b9e <insert_sorted_with_merge_freeList+0x183>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 1c 3c 80 00       	push   $0x803c1c
  802b8f:	68 3f 01 00 00       	push   $0x13f
  802b94:	68 3f 3c 80 00       	push   $0x803c3f
  802b99:	e8 c9 05 00 00       	call   803167 <_panic>
  802b9e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba7:	89 10                	mov    %edx,(%eax)
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	85 c0                	test   %eax,%eax
  802bb0:	74 0d                	je     802bbf <insert_sorted_with_merge_freeList+0x1a4>
  802bb2:	a1 48 41 80 00       	mov    0x804148,%eax
  802bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bba:	89 50 04             	mov    %edx,0x4(%eax)
  802bbd:	eb 08                	jmp    802bc7 <insert_sorted_with_merge_freeList+0x1ac>
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bca:	a3 48 41 80 00       	mov    %eax,0x804148
  802bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd9:	a1 54 41 80 00       	mov    0x804154,%eax
  802bde:	40                   	inc    %eax
  802bdf:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802be4:	e9 7a 05 00 00       	jmp    803163 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 50 08             	mov    0x8(%eax),%edx
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	8b 40 08             	mov    0x8(%eax),%eax
  802bf5:	39 c2                	cmp    %eax,%edx
  802bf7:	0f 82 14 01 00 00    	jb     802d11 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 50 08             	mov    0x8(%eax),%edx
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	01 c2                	add    %eax,%edx
  802c0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0e:	8b 40 08             	mov    0x8(%eax),%eax
  802c11:	39 c2                	cmp    %eax,%edx
  802c13:	0f 85 90 00 00 00    	jne    802ca9 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	8b 50 0c             	mov    0xc(%eax),%edx
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	01 c2                	add    %eax,%edx
  802c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2a:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c45:	75 17                	jne    802c5e <insert_sorted_with_merge_freeList+0x243>
  802c47:	83 ec 04             	sub    $0x4,%esp
  802c4a:	68 1c 3c 80 00       	push   $0x803c1c
  802c4f:	68 49 01 00 00       	push   $0x149
  802c54:	68 3f 3c 80 00       	push   $0x803c3f
  802c59:	e8 09 05 00 00       	call   803167 <_panic>
  802c5e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0d                	je     802c7f <insert_sorted_with_merge_freeList+0x264>
  802c72:	a1 48 41 80 00       	mov    0x804148,%eax
  802c77:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7a:	89 50 04             	mov    %edx,0x4(%eax)
  802c7d:	eb 08                	jmp    802c87 <insert_sorted_with_merge_freeList+0x26c>
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 54 41 80 00       	mov    0x804154,%eax
  802c9e:	40                   	inc    %eax
  802c9f:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ca4:	e9 bb 04 00 00       	jmp    803164 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ca9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cad:	75 17                	jne    802cc6 <insert_sorted_with_merge_freeList+0x2ab>
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 90 3c 80 00       	push   $0x803c90
  802cb7:	68 4c 01 00 00       	push   $0x14c
  802cbc:	68 3f 3c 80 00       	push   $0x803c3f
  802cc1:	e8 a1 04 00 00       	call   803167 <_panic>
  802cc6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	74 0c                	je     802ce8 <insert_sorted_with_merge_freeList+0x2cd>
  802cdc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ce1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce4:	89 10                	mov    %edx,(%eax)
  802ce6:	eb 08                	jmp    802cf0 <insert_sorted_with_merge_freeList+0x2d5>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d01:	a1 44 41 80 00       	mov    0x804144,%eax
  802d06:	40                   	inc    %eax
  802d07:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d0c:	e9 53 04 00 00       	jmp    803164 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802d11:	a1 38 41 80 00       	mov    0x804138,%eax
  802d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d19:	e9 15 04 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 00                	mov    (%eax),%eax
  802d23:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	8b 50 08             	mov    0x8(%eax),%edx
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 08             	mov    0x8(%eax),%eax
  802d32:	39 c2                	cmp    %eax,%edx
  802d34:	0f 86 f1 03 00 00    	jbe    80312b <insert_sorted_with_merge_freeList+0x710>
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 50 08             	mov    0x8(%eax),%edx
  802d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d43:	8b 40 08             	mov    0x8(%eax),%eax
  802d46:	39 c2                	cmp    %eax,%edx
  802d48:	0f 83 dd 03 00 00    	jae    80312b <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	8b 50 08             	mov    0x8(%eax),%edx
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5a:	01 c2                	add    %eax,%edx
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 40 08             	mov    0x8(%eax),%eax
  802d62:	39 c2                	cmp    %eax,%edx
  802d64:	0f 85 b9 01 00 00    	jne    802f23 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 50 08             	mov    0x8(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 0c             	mov    0xc(%eax),%eax
  802d76:	01 c2                	add    %eax,%edx
  802d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	0f 85 0d 01 00 00    	jne    802e93 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d92:	01 c2                	add    %eax,%edx
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d9e:	75 17                	jne    802db7 <insert_sorted_with_merge_freeList+0x39c>
  802da0:	83 ec 04             	sub    $0x4,%esp
  802da3:	68 e8 3c 80 00       	push   $0x803ce8
  802da8:	68 5c 01 00 00       	push   $0x15c
  802dad:	68 3f 3c 80 00       	push   $0x803c3f
  802db2:	e8 b0 03 00 00       	call   803167 <_panic>
  802db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 10                	je     802dd0 <insert_sorted_with_merge_freeList+0x3b5>
  802dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc8:	8b 52 04             	mov    0x4(%edx),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	eb 0b                	jmp    802ddb <insert_sorted_with_merge_freeList+0x3c0>
  802dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd3:	8b 40 04             	mov    0x4(%eax),%eax
  802dd6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0f                	je     802df4 <insert_sorted_with_merge_freeList+0x3d9>
  802de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dee:	8b 12                	mov    (%edx),%edx
  802df0:	89 10                	mov    %edx,(%eax)
  802df2:	eb 0a                	jmp    802dfe <insert_sorted_with_merge_freeList+0x3e3>
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	a3 38 41 80 00       	mov    %eax,0x804138
  802dfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e11:	a1 44 41 80 00       	mov    0x804144,%eax
  802e16:	48                   	dec    %eax
  802e17:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802e1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802e26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e29:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e34:	75 17                	jne    802e4d <insert_sorted_with_merge_freeList+0x432>
  802e36:	83 ec 04             	sub    $0x4,%esp
  802e39:	68 1c 3c 80 00       	push   $0x803c1c
  802e3e:	68 5f 01 00 00       	push   $0x15f
  802e43:	68 3f 3c 80 00       	push   $0x803c3f
  802e48:	e8 1a 03 00 00       	call   803167 <_panic>
  802e4d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e56:	89 10                	mov    %edx,(%eax)
  802e58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0d                	je     802e6e <insert_sorted_with_merge_freeList+0x453>
  802e61:	a1 48 41 80 00       	mov    0x804148,%eax
  802e66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e69:	89 50 04             	mov    %edx,0x4(%eax)
  802e6c:	eb 08                	jmp    802e76 <insert_sorted_with_merge_freeList+0x45b>
  802e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e71:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e79:	a3 48 41 80 00       	mov    %eax,0x804148
  802e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e88:	a1 54 41 80 00       	mov    0x804154,%eax
  802e8d:	40                   	inc    %eax
  802e8e:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 50 0c             	mov    0xc(%eax),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	01 c2                	add    %eax,%edx
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ebb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebf:	75 17                	jne    802ed8 <insert_sorted_with_merge_freeList+0x4bd>
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 1c 3c 80 00       	push   $0x803c1c
  802ec9:	68 64 01 00 00       	push   $0x164
  802ece:	68 3f 3c 80 00       	push   $0x803c3f
  802ed3:	e8 8f 02 00 00       	call   803167 <_panic>
  802ed8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	89 10                	mov    %edx,(%eax)
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	74 0d                	je     802ef9 <insert_sorted_with_merge_freeList+0x4de>
  802eec:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef4:	89 50 04             	mov    %edx,0x4(%eax)
  802ef7:	eb 08                	jmp    802f01 <insert_sorted_with_merge_freeList+0x4e6>
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	a3 48 41 80 00       	mov    %eax,0x804148
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f13:	a1 54 41 80 00       	mov    0x804154,%eax
  802f18:	40                   	inc    %eax
  802f19:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802f1e:	e9 41 02 00 00       	jmp    803164 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 50 08             	mov    0x8(%eax),%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2f:	01 c2                	add    %eax,%edx
  802f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f34:	8b 40 08             	mov    0x8(%eax),%eax
  802f37:	39 c2                	cmp    %eax,%edx
  802f39:	0f 85 7c 01 00 00    	jne    8030bb <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f43:	74 06                	je     802f4b <insert_sorted_with_merge_freeList+0x530>
  802f45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f49:	75 17                	jne    802f62 <insert_sorted_with_merge_freeList+0x547>
  802f4b:	83 ec 04             	sub    $0x4,%esp
  802f4e:	68 58 3c 80 00       	push   $0x803c58
  802f53:	68 69 01 00 00       	push   $0x169
  802f58:	68 3f 3c 80 00       	push   $0x803c3f
  802f5d:	e8 05 02 00 00       	call   803167 <_panic>
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 50 04             	mov    0x4(%eax),%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	89 50 04             	mov    %edx,0x4(%eax)
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f74:	89 10                	mov    %edx,(%eax)
  802f76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f79:	8b 40 04             	mov    0x4(%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	74 0d                	je     802f8d <insert_sorted_with_merge_freeList+0x572>
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	89 10                	mov    %edx,(%eax)
  802f8b:	eb 08                	jmp    802f95 <insert_sorted_with_merge_freeList+0x57a>
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	a3 38 41 80 00       	mov    %eax,0x804138
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9b:	89 50 04             	mov    %edx,0x4(%eax)
  802f9e:	a1 44 41 80 00       	mov    0x804144,%eax
  802fa3:	40                   	inc    %eax
  802fa4:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 50 0c             	mov    0xc(%eax),%edx
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb5:	01 c2                	add    %eax,%edx
  802fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fba:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fbd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc1:	75 17                	jne    802fda <insert_sorted_with_merge_freeList+0x5bf>
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	68 e8 3c 80 00       	push   $0x803ce8
  802fcb:	68 6b 01 00 00       	push   $0x16b
  802fd0:	68 3f 3c 80 00       	push   $0x803c3f
  802fd5:	e8 8d 01 00 00       	call   803167 <_panic>
  802fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 10                	je     802ff3 <insert_sorted_with_merge_freeList+0x5d8>
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802feb:	8b 52 04             	mov    0x4(%edx),%edx
  802fee:	89 50 04             	mov    %edx,0x4(%eax)
  802ff1:	eb 0b                	jmp    802ffe <insert_sorted_with_merge_freeList+0x5e3>
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	8b 40 04             	mov    0x4(%eax),%eax
  802ff9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803001:	8b 40 04             	mov    0x4(%eax),%eax
  803004:	85 c0                	test   %eax,%eax
  803006:	74 0f                	je     803017 <insert_sorted_with_merge_freeList+0x5fc>
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803011:	8b 12                	mov    (%edx),%edx
  803013:	89 10                	mov    %edx,(%eax)
  803015:	eb 0a                	jmp    803021 <insert_sorted_with_merge_freeList+0x606>
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	8b 00                	mov    (%eax),%eax
  80301c:	a3 38 41 80 00       	mov    %eax,0x804138
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803034:	a1 44 41 80 00       	mov    0x804144,%eax
  803039:	48                   	dec    %eax
  80303a:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803053:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803057:	75 17                	jne    803070 <insert_sorted_with_merge_freeList+0x655>
  803059:	83 ec 04             	sub    $0x4,%esp
  80305c:	68 1c 3c 80 00       	push   $0x803c1c
  803061:	68 6e 01 00 00       	push   $0x16e
  803066:	68 3f 3c 80 00       	push   $0x803c3f
  80306b:	e8 f7 00 00 00       	call   803167 <_panic>
  803070:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	89 10                	mov    %edx,(%eax)
  80307b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 0d                	je     803091 <insert_sorted_with_merge_freeList+0x676>
  803084:	a1 48 41 80 00       	mov    0x804148,%eax
  803089:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308c:	89 50 04             	mov    %edx,0x4(%eax)
  80308f:	eb 08                	jmp    803099 <insert_sorted_with_merge_freeList+0x67e>
  803091:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803094:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803099:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309c:	a3 48 41 80 00       	mov    %eax,0x804148
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8030b0:	40                   	inc    %eax
  8030b1:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030b6:	e9 a9 00 00 00       	jmp    803164 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8030bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bf:	74 06                	je     8030c7 <insert_sorted_with_merge_freeList+0x6ac>
  8030c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c5:	75 17                	jne    8030de <insert_sorted_with_merge_freeList+0x6c3>
  8030c7:	83 ec 04             	sub    $0x4,%esp
  8030ca:	68 b4 3c 80 00       	push   $0x803cb4
  8030cf:	68 73 01 00 00       	push   $0x173
  8030d4:	68 3f 3c 80 00       	push   $0x803c3f
  8030d9:	e8 89 00 00 00       	call   803167 <_panic>
  8030de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e1:	8b 10                	mov    (%eax),%edx
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	89 10                	mov    %edx,(%eax)
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	8b 00                	mov    (%eax),%eax
  8030ed:	85 c0                	test   %eax,%eax
  8030ef:	74 0b                	je     8030fc <insert_sorted_with_merge_freeList+0x6e1>
  8030f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f4:	8b 00                	mov    (%eax),%eax
  8030f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f9:	89 50 04             	mov    %edx,0x4(%eax)
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803102:	89 10                	mov    %edx,(%eax)
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	85 c0                	test   %eax,%eax
  803114:	75 08                	jne    80311e <insert_sorted_with_merge_freeList+0x703>
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80311e:	a1 44 41 80 00       	mov    0x804144,%eax
  803123:	40                   	inc    %eax
  803124:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803129:	eb 39                	jmp    803164 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80312b:	a1 40 41 80 00       	mov    0x804140,%eax
  803130:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803137:	74 07                	je     803140 <insert_sorted_with_merge_freeList+0x725>
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	eb 05                	jmp    803145 <insert_sorted_with_merge_freeList+0x72a>
  803140:	b8 00 00 00 00       	mov    $0x0,%eax
  803145:	a3 40 41 80 00       	mov    %eax,0x804140
  80314a:	a1 40 41 80 00       	mov    0x804140,%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	0f 85 c7 fb ff ff    	jne    802d1e <insert_sorted_with_merge_freeList+0x303>
  803157:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315b:	0f 85 bd fb ff ff    	jne    802d1e <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803161:	eb 01                	jmp    803164 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803163:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803164:	90                   	nop
  803165:	c9                   	leave  
  803166:	c3                   	ret    

00803167 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803167:	55                   	push   %ebp
  803168:	89 e5                	mov    %esp,%ebp
  80316a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80316d:	8d 45 10             	lea    0x10(%ebp),%eax
  803170:	83 c0 04             	add    $0x4,%eax
  803173:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803176:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 16                	je     803195 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80317f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803184:	83 ec 08             	sub    $0x8,%esp
  803187:	50                   	push   %eax
  803188:	68 08 3d 80 00       	push   $0x803d08
  80318d:	e8 b6 d1 ff ff       	call   800348 <cprintf>
  803192:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803195:	a1 00 40 80 00       	mov    0x804000,%eax
  80319a:	ff 75 0c             	pushl  0xc(%ebp)
  80319d:	ff 75 08             	pushl  0x8(%ebp)
  8031a0:	50                   	push   %eax
  8031a1:	68 0d 3d 80 00       	push   $0x803d0d
  8031a6:	e8 9d d1 ff ff       	call   800348 <cprintf>
  8031ab:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8031b1:	83 ec 08             	sub    $0x8,%esp
  8031b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8031b7:	50                   	push   %eax
  8031b8:	e8 20 d1 ff ff       	call   8002dd <vcprintf>
  8031bd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031c0:	83 ec 08             	sub    $0x8,%esp
  8031c3:	6a 00                	push   $0x0
  8031c5:	68 29 3d 80 00       	push   $0x803d29
  8031ca:	e8 0e d1 ff ff       	call   8002dd <vcprintf>
  8031cf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8031d2:	e8 8f d0 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  8031d7:	eb fe                	jmp    8031d7 <_panic+0x70>

008031d9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8031d9:	55                   	push   %ebp
  8031da:	89 e5                	mov    %esp,%ebp
  8031dc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8031df:	a1 20 40 80 00       	mov    0x804020,%eax
  8031e4:	8b 50 74             	mov    0x74(%eax),%edx
  8031e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ea:	39 c2                	cmp    %eax,%edx
  8031ec:	74 14                	je     803202 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 2c 3d 80 00       	push   $0x803d2c
  8031f6:	6a 26                	push   $0x26
  8031f8:	68 78 3d 80 00       	push   $0x803d78
  8031fd:	e8 65 ff ff ff       	call   803167 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803202:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803209:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803210:	e9 c2 00 00 00       	jmp    8032d7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803218:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	01 d0                	add    %edx,%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	85 c0                	test   %eax,%eax
  803228:	75 08                	jne    803232 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80322a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80322d:	e9 a2 00 00 00       	jmp    8032d4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803232:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803239:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803240:	eb 69                	jmp    8032ab <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803242:	a1 20 40 80 00       	mov    0x804020,%eax
  803247:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80324d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803250:	89 d0                	mov    %edx,%eax
  803252:	01 c0                	add    %eax,%eax
  803254:	01 d0                	add    %edx,%eax
  803256:	c1 e0 03             	shl    $0x3,%eax
  803259:	01 c8                	add    %ecx,%eax
  80325b:	8a 40 04             	mov    0x4(%eax),%al
  80325e:	84 c0                	test   %al,%al
  803260:	75 46                	jne    8032a8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803262:	a1 20 40 80 00       	mov    0x804020,%eax
  803267:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803270:	89 d0                	mov    %edx,%eax
  803272:	01 c0                	add    %eax,%eax
  803274:	01 d0                	add    %edx,%eax
  803276:	c1 e0 03             	shl    $0x3,%eax
  803279:	01 c8                	add    %ecx,%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803280:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803283:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803288:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80328a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	01 c8                	add    %ecx,%eax
  803299:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80329b:	39 c2                	cmp    %eax,%edx
  80329d:	75 09                	jne    8032a8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80329f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032a6:	eb 12                	jmp    8032ba <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032a8:	ff 45 e8             	incl   -0x18(%ebp)
  8032ab:	a1 20 40 80 00       	mov    0x804020,%eax
  8032b0:	8b 50 74             	mov    0x74(%eax),%edx
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	39 c2                	cmp    %eax,%edx
  8032b8:	77 88                	ja     803242 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032be:	75 14                	jne    8032d4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032c0:	83 ec 04             	sub    $0x4,%esp
  8032c3:	68 84 3d 80 00       	push   $0x803d84
  8032c8:	6a 3a                	push   $0x3a
  8032ca:	68 78 3d 80 00       	push   $0x803d78
  8032cf:	e8 93 fe ff ff       	call   803167 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8032d4:	ff 45 f0             	incl   -0x10(%ebp)
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032dd:	0f 8c 32 ff ff ff    	jl     803215 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8032e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032f1:	eb 26                	jmp    803319 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8032f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8032f8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803301:	89 d0                	mov    %edx,%eax
  803303:	01 c0                	add    %eax,%eax
  803305:	01 d0                	add    %edx,%eax
  803307:	c1 e0 03             	shl    $0x3,%eax
  80330a:	01 c8                	add    %ecx,%eax
  80330c:	8a 40 04             	mov    0x4(%eax),%al
  80330f:	3c 01                	cmp    $0x1,%al
  803311:	75 03                	jne    803316 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803313:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803316:	ff 45 e0             	incl   -0x20(%ebp)
  803319:	a1 20 40 80 00       	mov    0x804020,%eax
  80331e:	8b 50 74             	mov    0x74(%eax),%edx
  803321:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803324:	39 c2                	cmp    %eax,%edx
  803326:	77 cb                	ja     8032f3 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80332e:	74 14                	je     803344 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803330:	83 ec 04             	sub    $0x4,%esp
  803333:	68 d8 3d 80 00       	push   $0x803dd8
  803338:	6a 44                	push   $0x44
  80333a:	68 78 3d 80 00       	push   $0x803d78
  80333f:	e8 23 fe ff ff       	call   803167 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803344:	90                   	nop
  803345:	c9                   	leave  
  803346:	c3                   	ret    
  803347:	90                   	nop

00803348 <__udivdi3>:
  803348:	55                   	push   %ebp
  803349:	57                   	push   %edi
  80334a:	56                   	push   %esi
  80334b:	53                   	push   %ebx
  80334c:	83 ec 1c             	sub    $0x1c,%esp
  80334f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803353:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80335b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80335f:	89 ca                	mov    %ecx,%edx
  803361:	89 f8                	mov    %edi,%eax
  803363:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803367:	85 f6                	test   %esi,%esi
  803369:	75 2d                	jne    803398 <__udivdi3+0x50>
  80336b:	39 cf                	cmp    %ecx,%edi
  80336d:	77 65                	ja     8033d4 <__udivdi3+0x8c>
  80336f:	89 fd                	mov    %edi,%ebp
  803371:	85 ff                	test   %edi,%edi
  803373:	75 0b                	jne    803380 <__udivdi3+0x38>
  803375:	b8 01 00 00 00       	mov    $0x1,%eax
  80337a:	31 d2                	xor    %edx,%edx
  80337c:	f7 f7                	div    %edi
  80337e:	89 c5                	mov    %eax,%ebp
  803380:	31 d2                	xor    %edx,%edx
  803382:	89 c8                	mov    %ecx,%eax
  803384:	f7 f5                	div    %ebp
  803386:	89 c1                	mov    %eax,%ecx
  803388:	89 d8                	mov    %ebx,%eax
  80338a:	f7 f5                	div    %ebp
  80338c:	89 cf                	mov    %ecx,%edi
  80338e:	89 fa                	mov    %edi,%edx
  803390:	83 c4 1c             	add    $0x1c,%esp
  803393:	5b                   	pop    %ebx
  803394:	5e                   	pop    %esi
  803395:	5f                   	pop    %edi
  803396:	5d                   	pop    %ebp
  803397:	c3                   	ret    
  803398:	39 ce                	cmp    %ecx,%esi
  80339a:	77 28                	ja     8033c4 <__udivdi3+0x7c>
  80339c:	0f bd fe             	bsr    %esi,%edi
  80339f:	83 f7 1f             	xor    $0x1f,%edi
  8033a2:	75 40                	jne    8033e4 <__udivdi3+0x9c>
  8033a4:	39 ce                	cmp    %ecx,%esi
  8033a6:	72 0a                	jb     8033b2 <__udivdi3+0x6a>
  8033a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033ac:	0f 87 9e 00 00 00    	ja     803450 <__udivdi3+0x108>
  8033b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b7:	89 fa                	mov    %edi,%edx
  8033b9:	83 c4 1c             	add    $0x1c,%esp
  8033bc:	5b                   	pop    %ebx
  8033bd:	5e                   	pop    %esi
  8033be:	5f                   	pop    %edi
  8033bf:	5d                   	pop    %ebp
  8033c0:	c3                   	ret    
  8033c1:	8d 76 00             	lea    0x0(%esi),%esi
  8033c4:	31 ff                	xor    %edi,%edi
  8033c6:	31 c0                	xor    %eax,%eax
  8033c8:	89 fa                	mov    %edi,%edx
  8033ca:	83 c4 1c             	add    $0x1c,%esp
  8033cd:	5b                   	pop    %ebx
  8033ce:	5e                   	pop    %esi
  8033cf:	5f                   	pop    %edi
  8033d0:	5d                   	pop    %ebp
  8033d1:	c3                   	ret    
  8033d2:	66 90                	xchg   %ax,%ax
  8033d4:	89 d8                	mov    %ebx,%eax
  8033d6:	f7 f7                	div    %edi
  8033d8:	31 ff                	xor    %edi,%edi
  8033da:	89 fa                	mov    %edi,%edx
  8033dc:	83 c4 1c             	add    $0x1c,%esp
  8033df:	5b                   	pop    %ebx
  8033e0:	5e                   	pop    %esi
  8033e1:	5f                   	pop    %edi
  8033e2:	5d                   	pop    %ebp
  8033e3:	c3                   	ret    
  8033e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033e9:	89 eb                	mov    %ebp,%ebx
  8033eb:	29 fb                	sub    %edi,%ebx
  8033ed:	89 f9                	mov    %edi,%ecx
  8033ef:	d3 e6                	shl    %cl,%esi
  8033f1:	89 c5                	mov    %eax,%ebp
  8033f3:	88 d9                	mov    %bl,%cl
  8033f5:	d3 ed                	shr    %cl,%ebp
  8033f7:	89 e9                	mov    %ebp,%ecx
  8033f9:	09 f1                	or     %esi,%ecx
  8033fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033ff:	89 f9                	mov    %edi,%ecx
  803401:	d3 e0                	shl    %cl,%eax
  803403:	89 c5                	mov    %eax,%ebp
  803405:	89 d6                	mov    %edx,%esi
  803407:	88 d9                	mov    %bl,%cl
  803409:	d3 ee                	shr    %cl,%esi
  80340b:	89 f9                	mov    %edi,%ecx
  80340d:	d3 e2                	shl    %cl,%edx
  80340f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803413:	88 d9                	mov    %bl,%cl
  803415:	d3 e8                	shr    %cl,%eax
  803417:	09 c2                	or     %eax,%edx
  803419:	89 d0                	mov    %edx,%eax
  80341b:	89 f2                	mov    %esi,%edx
  80341d:	f7 74 24 0c          	divl   0xc(%esp)
  803421:	89 d6                	mov    %edx,%esi
  803423:	89 c3                	mov    %eax,%ebx
  803425:	f7 e5                	mul    %ebp
  803427:	39 d6                	cmp    %edx,%esi
  803429:	72 19                	jb     803444 <__udivdi3+0xfc>
  80342b:	74 0b                	je     803438 <__udivdi3+0xf0>
  80342d:	89 d8                	mov    %ebx,%eax
  80342f:	31 ff                	xor    %edi,%edi
  803431:	e9 58 ff ff ff       	jmp    80338e <__udivdi3+0x46>
  803436:	66 90                	xchg   %ax,%ax
  803438:	8b 54 24 08          	mov    0x8(%esp),%edx
  80343c:	89 f9                	mov    %edi,%ecx
  80343e:	d3 e2                	shl    %cl,%edx
  803440:	39 c2                	cmp    %eax,%edx
  803442:	73 e9                	jae    80342d <__udivdi3+0xe5>
  803444:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803447:	31 ff                	xor    %edi,%edi
  803449:	e9 40 ff ff ff       	jmp    80338e <__udivdi3+0x46>
  80344e:	66 90                	xchg   %ax,%ax
  803450:	31 c0                	xor    %eax,%eax
  803452:	e9 37 ff ff ff       	jmp    80338e <__udivdi3+0x46>
  803457:	90                   	nop

00803458 <__umoddi3>:
  803458:	55                   	push   %ebp
  803459:	57                   	push   %edi
  80345a:	56                   	push   %esi
  80345b:	53                   	push   %ebx
  80345c:	83 ec 1c             	sub    $0x1c,%esp
  80345f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803463:	8b 74 24 34          	mov    0x34(%esp),%esi
  803467:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80346b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80346f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803473:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803477:	89 f3                	mov    %esi,%ebx
  803479:	89 fa                	mov    %edi,%edx
  80347b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80347f:	89 34 24             	mov    %esi,(%esp)
  803482:	85 c0                	test   %eax,%eax
  803484:	75 1a                	jne    8034a0 <__umoddi3+0x48>
  803486:	39 f7                	cmp    %esi,%edi
  803488:	0f 86 a2 00 00 00    	jbe    803530 <__umoddi3+0xd8>
  80348e:	89 c8                	mov    %ecx,%eax
  803490:	89 f2                	mov    %esi,%edx
  803492:	f7 f7                	div    %edi
  803494:	89 d0                	mov    %edx,%eax
  803496:	31 d2                	xor    %edx,%edx
  803498:	83 c4 1c             	add    $0x1c,%esp
  80349b:	5b                   	pop    %ebx
  80349c:	5e                   	pop    %esi
  80349d:	5f                   	pop    %edi
  80349e:	5d                   	pop    %ebp
  80349f:	c3                   	ret    
  8034a0:	39 f0                	cmp    %esi,%eax
  8034a2:	0f 87 ac 00 00 00    	ja     803554 <__umoddi3+0xfc>
  8034a8:	0f bd e8             	bsr    %eax,%ebp
  8034ab:	83 f5 1f             	xor    $0x1f,%ebp
  8034ae:	0f 84 ac 00 00 00    	je     803560 <__umoddi3+0x108>
  8034b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8034b9:	29 ef                	sub    %ebp,%edi
  8034bb:	89 fe                	mov    %edi,%esi
  8034bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034c1:	89 e9                	mov    %ebp,%ecx
  8034c3:	d3 e0                	shl    %cl,%eax
  8034c5:	89 d7                	mov    %edx,%edi
  8034c7:	89 f1                	mov    %esi,%ecx
  8034c9:	d3 ef                	shr    %cl,%edi
  8034cb:	09 c7                	or     %eax,%edi
  8034cd:	89 e9                	mov    %ebp,%ecx
  8034cf:	d3 e2                	shl    %cl,%edx
  8034d1:	89 14 24             	mov    %edx,(%esp)
  8034d4:	89 d8                	mov    %ebx,%eax
  8034d6:	d3 e0                	shl    %cl,%eax
  8034d8:	89 c2                	mov    %eax,%edx
  8034da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034de:	d3 e0                	shl    %cl,%eax
  8034e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e8:	89 f1                	mov    %esi,%ecx
  8034ea:	d3 e8                	shr    %cl,%eax
  8034ec:	09 d0                	or     %edx,%eax
  8034ee:	d3 eb                	shr    %cl,%ebx
  8034f0:	89 da                	mov    %ebx,%edx
  8034f2:	f7 f7                	div    %edi
  8034f4:	89 d3                	mov    %edx,%ebx
  8034f6:	f7 24 24             	mull   (%esp)
  8034f9:	89 c6                	mov    %eax,%esi
  8034fb:	89 d1                	mov    %edx,%ecx
  8034fd:	39 d3                	cmp    %edx,%ebx
  8034ff:	0f 82 87 00 00 00    	jb     80358c <__umoddi3+0x134>
  803505:	0f 84 91 00 00 00    	je     80359c <__umoddi3+0x144>
  80350b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80350f:	29 f2                	sub    %esi,%edx
  803511:	19 cb                	sbb    %ecx,%ebx
  803513:	89 d8                	mov    %ebx,%eax
  803515:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803519:	d3 e0                	shl    %cl,%eax
  80351b:	89 e9                	mov    %ebp,%ecx
  80351d:	d3 ea                	shr    %cl,%edx
  80351f:	09 d0                	or     %edx,%eax
  803521:	89 e9                	mov    %ebp,%ecx
  803523:	d3 eb                	shr    %cl,%ebx
  803525:	89 da                	mov    %ebx,%edx
  803527:	83 c4 1c             	add    $0x1c,%esp
  80352a:	5b                   	pop    %ebx
  80352b:	5e                   	pop    %esi
  80352c:	5f                   	pop    %edi
  80352d:	5d                   	pop    %ebp
  80352e:	c3                   	ret    
  80352f:	90                   	nop
  803530:	89 fd                	mov    %edi,%ebp
  803532:	85 ff                	test   %edi,%edi
  803534:	75 0b                	jne    803541 <__umoddi3+0xe9>
  803536:	b8 01 00 00 00       	mov    $0x1,%eax
  80353b:	31 d2                	xor    %edx,%edx
  80353d:	f7 f7                	div    %edi
  80353f:	89 c5                	mov    %eax,%ebp
  803541:	89 f0                	mov    %esi,%eax
  803543:	31 d2                	xor    %edx,%edx
  803545:	f7 f5                	div    %ebp
  803547:	89 c8                	mov    %ecx,%eax
  803549:	f7 f5                	div    %ebp
  80354b:	89 d0                	mov    %edx,%eax
  80354d:	e9 44 ff ff ff       	jmp    803496 <__umoddi3+0x3e>
  803552:	66 90                	xchg   %ax,%ax
  803554:	89 c8                	mov    %ecx,%eax
  803556:	89 f2                	mov    %esi,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	3b 04 24             	cmp    (%esp),%eax
  803563:	72 06                	jb     80356b <__umoddi3+0x113>
  803565:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803569:	77 0f                	ja     80357a <__umoddi3+0x122>
  80356b:	89 f2                	mov    %esi,%edx
  80356d:	29 f9                	sub    %edi,%ecx
  80356f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803573:	89 14 24             	mov    %edx,(%esp)
  803576:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80357e:	8b 14 24             	mov    (%esp),%edx
  803581:	83 c4 1c             	add    $0x1c,%esp
  803584:	5b                   	pop    %ebx
  803585:	5e                   	pop    %esi
  803586:	5f                   	pop    %edi
  803587:	5d                   	pop    %ebp
  803588:	c3                   	ret    
  803589:	8d 76 00             	lea    0x0(%esi),%esi
  80358c:	2b 04 24             	sub    (%esp),%eax
  80358f:	19 fa                	sbb    %edi,%edx
  803591:	89 d1                	mov    %edx,%ecx
  803593:	89 c6                	mov    %eax,%esi
  803595:	e9 71 ff ff ff       	jmp    80350b <__umoddi3+0xb3>
  80359a:	66 90                	xchg   %ax,%ax
  80359c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035a0:	72 ea                	jb     80358c <__umoddi3+0x134>
  8035a2:	89 d9                	mov    %ebx,%ecx
  8035a4:	e9 62 ff ff ff       	jmp    80350b <__umoddi3+0xb3>
