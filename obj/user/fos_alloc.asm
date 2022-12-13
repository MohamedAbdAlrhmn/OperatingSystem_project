
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
  80005c:	68 a0 35 80 00       	push   $0x8035a0
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
  8000b9:	68 b3 35 80 00       	push   $0x8035b3
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
  8000d7:	e8 22 12 00 00       	call   8012fe <free>
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
  80010f:	68 b3 35 80 00       	push   $0x8035b3
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
  80012d:	e8 cc 11 00 00       	call   8012fe <free>
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
  80013e:	e8 1a 17 00 00       	call   80185d <sys_getenvindex>
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
  8001a9:	e8 bc 14 00 00       	call   80166a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 d8 35 80 00       	push   $0x8035d8
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
  8001d9:	68 00 36 80 00       	push   $0x803600
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
  80020a:	68 28 36 80 00       	push   $0x803628
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 80 36 80 00       	push   $0x803680
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 d8 35 80 00       	push   $0x8035d8
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 3c 14 00 00       	call   801684 <sys_enable_interrupt>

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
  80025b:	e8 c9 15 00 00       	call   801829 <sys_destroy_env>
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
  80026c:	e8 1e 16 00 00       	call   80188f <sys_exit_env>
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
  8002ba:	e8 fd 11 00 00       	call   8014bc <sys_cputs>
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
  800331:	e8 86 11 00 00       	call   8014bc <sys_cputs>
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
  80037b:	e8 ea 12 00 00       	call   80166a <sys_disable_interrupt>
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
  80039b:	e8 e4 12 00 00       	call   801684 <sys_enable_interrupt>
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
  8003e5:	e8 36 2f 00 00       	call   803320 <__udivdi3>
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
  800435:	e8 f6 2f 00 00       	call   803430 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 b4 38 80 00       	add    $0x8038b4,%eax
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
  800590:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
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
  800671:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 c5 38 80 00       	push   $0x8038c5
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
  800696:	68 ce 38 80 00       	push   $0x8038ce
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
  8006c3:	be d1 38 80 00       	mov    $0x8038d1,%esi
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
  8010e9:	68 30 3a 80 00       	push   $0x803a30
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
  8011b9:	e8 42 04 00 00       	call   801600 <sys_allocate_chunk>
  8011be:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c1:	a1 20 41 80 00       	mov    0x804120,%eax
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 b7 0a 00 00       	call   801c86 <initialize_MemBlocksList>
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
  8011f7:	68 55 3a 80 00       	push   $0x803a55
  8011fc:	6a 33                	push   $0x33
  8011fe:	68 73 3a 80 00       	push   $0x803a73
  801203:	e8 37 1f 00 00       	call   80313f <_panic>
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
  801276:	68 80 3a 80 00       	push   $0x803a80
  80127b:	6a 34                	push   $0x34
  80127d:	68 73 3a 80 00       	push   $0x803a73
  801282:	e8 b8 1e 00 00       	call   80313f <_panic>
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
  8012d3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8012d6:	e8 f7 fd ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  8012db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012df:	75 07                	jne    8012e8 <malloc+0x18>
  8012e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e6:	eb 14                	jmp    8012fc <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8012e8:	83 ec 04             	sub    $0x4,%esp
  8012eb:	68 a4 3a 80 00       	push   $0x803aa4
  8012f0:	6a 46                	push   $0x46
  8012f2:	68 73 3a 80 00       	push   $0x803a73
  8012f7:	e8 43 1e 00 00       	call   80313f <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8012fc:	c9                   	leave  
  8012fd:	c3                   	ret    

008012fe <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8012fe:	55                   	push   %ebp
  8012ff:	89 e5                	mov    %esp,%ebp
  801301:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801304:	83 ec 04             	sub    $0x4,%esp
  801307:	68 cc 3a 80 00       	push   $0x803acc
  80130c:	6a 61                	push   $0x61
  80130e:	68 73 3a 80 00       	push   $0x803a73
  801313:	e8 27 1e 00 00       	call   80313f <_panic>

00801318 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 38             	sub    $0x38,%esp
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801324:	e8 a9 fd ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  801329:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80132d:	75 0a                	jne    801339 <smalloc+0x21>
  80132f:	b8 00 00 00 00       	mov    $0x0,%eax
  801334:	e9 9e 00 00 00       	jmp    8013d7 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801339:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801340:	8b 55 0c             	mov    0xc(%ebp),%edx
  801343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801346:	01 d0                	add    %edx,%eax
  801348:	48                   	dec    %eax
  801349:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80134c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134f:	ba 00 00 00 00       	mov    $0x0,%edx
  801354:	f7 75 f0             	divl   -0x10(%ebp)
  801357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80135a:	29 d0                	sub    %edx,%eax
  80135c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80135f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801366:	e8 63 06 00 00       	call   8019ce <sys_isUHeapPlacementStrategyFIRSTFIT>
  80136b:	85 c0                	test   %eax,%eax
  80136d:	74 11                	je     801380 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80136f:	83 ec 0c             	sub    $0xc,%esp
  801372:	ff 75 e8             	pushl  -0x18(%ebp)
  801375:	e8 ce 0c 00 00       	call   802048 <alloc_block_FF>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801384:	74 4c                	je     8013d2 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	8b 40 08             	mov    0x8(%eax),%eax
  80138c:	89 c2                	mov    %eax,%edx
  80138e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801392:	52                   	push   %edx
  801393:	50                   	push   %eax
  801394:	ff 75 0c             	pushl  0xc(%ebp)
  801397:	ff 75 08             	pushl  0x8(%ebp)
  80139a:	e8 b4 03 00 00       	call   801753 <sys_createSharedObject>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8013a5:	83 ec 08             	sub    $0x8,%esp
  8013a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8013ab:	68 ef 3a 80 00       	push   $0x803aef
  8013b0:	e8 93 ef ff ff       	call   800348 <cprintf>
  8013b5:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8013b8:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8013bc:	74 14                	je     8013d2 <smalloc+0xba>
  8013be:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8013c2:	74 0e                	je     8013d2 <smalloc+0xba>
  8013c4:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8013c8:	74 08                	je     8013d2 <smalloc+0xba>
			return (void*) mem_block->sva;
  8013ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cd:	8b 40 08             	mov    0x8(%eax),%eax
  8013d0:	eb 05                	jmp    8013d7 <smalloc+0xbf>
	}
	return NULL;
  8013d2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013df:	e8 ee fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	68 04 3b 80 00       	push   $0x803b04
  8013ec:	68 ab 00 00 00       	push   $0xab
  8013f1:	68 73 3a 80 00       	push   $0x803a73
  8013f6:	e8 44 1d 00 00       	call   80313f <_panic>

008013fb <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801401:	e8 cc fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	68 28 3b 80 00       	push   $0x803b28
  80140e:	68 ef 00 00 00       	push   $0xef
  801413:	68 73 3a 80 00       	push   $0x803a73
  801418:	e8 22 1d 00 00       	call   80313f <_panic>

0080141d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801423:	83 ec 04             	sub    $0x4,%esp
  801426:	68 50 3b 80 00       	push   $0x803b50
  80142b:	68 03 01 00 00       	push   $0x103
  801430:	68 73 3a 80 00       	push   $0x803a73
  801435:	e8 05 1d 00 00       	call   80313f <_panic>

0080143a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801440:	83 ec 04             	sub    $0x4,%esp
  801443:	68 74 3b 80 00       	push   $0x803b74
  801448:	68 0e 01 00 00       	push   $0x10e
  80144d:	68 73 3a 80 00       	push   $0x803a73
  801452:	e8 e8 1c 00 00       	call   80313f <_panic>

00801457 <shrink>:

}
void shrink(uint32 newSize)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	68 74 3b 80 00       	push   $0x803b74
  801465:	68 13 01 00 00       	push   $0x113
  80146a:	68 73 3a 80 00       	push   $0x803a73
  80146f:	e8 cb 1c 00 00       	call   80313f <_panic>

00801474 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	68 74 3b 80 00       	push   $0x803b74
  801482:	68 18 01 00 00       	push   $0x118
  801487:	68 73 3a 80 00       	push   $0x803a73
  80148c:	e8 ae 1c 00 00       	call   80313f <_panic>

00801491 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	57                   	push   %edi
  801495:	56                   	push   %esi
  801496:	53                   	push   %ebx
  801497:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014a6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014a9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014ac:	cd 30                	int    $0x30
  8014ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	5b                   	pop    %ebx
  8014b8:	5e                   	pop    %esi
  8014b9:	5f                   	pop    %edi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 04             	sub    $0x4,%esp
  8014c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014c8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	52                   	push   %edx
  8014d4:	ff 75 0c             	pushl  0xc(%ebp)
  8014d7:	50                   	push   %eax
  8014d8:	6a 00                	push   $0x0
  8014da:	e8 b2 ff ff ff       	call   801491 <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	6a 00                	push   $0x0
  8014f0:	6a 00                	push   $0x0
  8014f2:	6a 01                	push   $0x1
  8014f4:	e8 98 ff ff ff       	call   801491 <syscall>
  8014f9:	83 c4 18             	add    $0x18,%esp
}
  8014fc:	c9                   	leave  
  8014fd:	c3                   	ret    

008014fe <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801501:	8b 55 0c             	mov    0xc(%ebp),%edx
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	52                   	push   %edx
  80150e:	50                   	push   %eax
  80150f:	6a 05                	push   $0x5
  801511:	e8 7b ff ff ff       	call   801491 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	56                   	push   %esi
  80151f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801520:	8b 75 18             	mov    0x18(%ebp),%esi
  801523:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801526:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	56                   	push   %esi
  801530:	53                   	push   %ebx
  801531:	51                   	push   %ecx
  801532:	52                   	push   %edx
  801533:	50                   	push   %eax
  801534:	6a 06                	push   $0x6
  801536:	e8 56 ff ff ff       	call   801491 <syscall>
  80153b:	83 c4 18             	add    $0x18,%esp
}
  80153e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801541:	5b                   	pop    %ebx
  801542:	5e                   	pop    %esi
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    

00801545 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	52                   	push   %edx
  801555:	50                   	push   %eax
  801556:	6a 07                	push   $0x7
  801558:	e8 34 ff ff ff       	call   801491 <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	6a 08                	push   $0x8
  801573:	e8 19 ff ff ff       	call   801491 <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801580:	6a 00                	push   $0x0
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 09                	push   $0x9
  80158c:	e8 00 ff ff ff       	call   801491 <syscall>
  801591:	83 c4 18             	add    $0x18,%esp
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 0a                	push   $0xa
  8015a5:	e8 e7 fe ff ff       	call   801491 <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 0b                	push   $0xb
  8015be:	e8 ce fe ff ff       	call   801491 <syscall>
  8015c3:	83 c4 18             	add    $0x18,%esp
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	ff 75 0c             	pushl  0xc(%ebp)
  8015d4:	ff 75 08             	pushl  0x8(%ebp)
  8015d7:	6a 0f                	push   $0xf
  8015d9:	e8 b3 fe ff ff       	call   801491 <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
	return;
  8015e1:	90                   	nop
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	ff 75 0c             	pushl  0xc(%ebp)
  8015f0:	ff 75 08             	pushl  0x8(%ebp)
  8015f3:	6a 10                	push   $0x10
  8015f5:	e8 97 fe ff ff       	call   801491 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8015fd:	90                   	nop
}
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	ff 75 10             	pushl  0x10(%ebp)
  80160a:	ff 75 0c             	pushl  0xc(%ebp)
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	6a 11                	push   $0x11
  801612:	e8 7a fe ff ff       	call   801491 <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
	return ;
  80161a:	90                   	nop
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801620:	6a 00                	push   $0x0
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 0c                	push   $0xc
  80162c:	e8 60 fe ff ff       	call   801491 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	ff 75 08             	pushl  0x8(%ebp)
  801644:	6a 0d                	push   $0xd
  801646:	e8 46 fe ff ff       	call   801491 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 0e                	push   $0xe
  80165f:	e8 2d fe ff ff       	call   801491 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	90                   	nop
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 13                	push   $0x13
  801679:	e8 13 fe ff ff       	call   801491 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	6a 14                	push   $0x14
  801693:	e8 f9 fd ff ff       	call   801491 <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
}
  80169b:	90                   	nop
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_cputc>:


void
sys_cputc(const char c)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 04             	sub    $0x4,%esp
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016aa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	50                   	push   %eax
  8016b7:	6a 15                	push   $0x15
  8016b9:	e8 d3 fd ff ff       	call   801491 <syscall>
  8016be:	83 c4 18             	add    $0x18,%esp
}
  8016c1:	90                   	nop
  8016c2:	c9                   	leave  
  8016c3:	c3                   	ret    

008016c4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 16                	push   $0x16
  8016d3:	e8 b9 fd ff ff       	call   801491 <syscall>
  8016d8:	83 c4 18             	add    $0x18,%esp
}
  8016db:	90                   	nop
  8016dc:	c9                   	leave  
  8016dd:	c3                   	ret    

008016de <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	50                   	push   %eax
  8016ee:	6a 17                	push   $0x17
  8016f0:	e8 9c fd ff ff       	call   801491 <syscall>
  8016f5:	83 c4 18             	add    $0x18,%esp
}
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	6a 1a                	push   $0x1a
  80170d:	e8 7f fd ff ff       	call   801491 <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	6a 18                	push   $0x18
  80172a:	e8 62 fd ff ff       	call   801491 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	90                   	nop
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	52                   	push   %edx
  801745:	50                   	push   %eax
  801746:	6a 19                	push   $0x19
  801748:	e8 44 fd ff ff       	call   801491 <syscall>
  80174d:	83 c4 18             	add    $0x18,%esp
}
  801750:	90                   	nop
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80175f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801762:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	6a 00                	push   $0x0
  80176b:	51                   	push   %ecx
  80176c:	52                   	push   %edx
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	50                   	push   %eax
  801771:	6a 1b                	push   $0x1b
  801773:	e8 19 fd ff ff       	call   801491 <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	c9                   	leave  
  80177c:	c3                   	ret    

0080177d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801780:	8b 55 0c             	mov    0xc(%ebp),%edx
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	6a 1c                	push   $0x1c
  801790:	e8 fc fc ff ff       	call   801491 <syscall>
  801795:	83 c4 18             	add    $0x18,%esp
}
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80179d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	51                   	push   %ecx
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	6a 1d                	push   $0x1d
  8017af:	e8 dd fc ff ff       	call   801491 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	6a 1e                	push   $0x1e
  8017cc:	e8 c0 fc ff ff       	call   801491 <syscall>
  8017d1:	83 c4 18             	add    $0x18,%esp
}
  8017d4:	c9                   	leave  
  8017d5:	c3                   	ret    

008017d6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 1f                	push   $0x1f
  8017e5:	e8 a7 fc ff ff       	call   801491 <syscall>
  8017ea:	83 c4 18             	add    $0x18,%esp
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	ff 75 14             	pushl  0x14(%ebp)
  8017fa:	ff 75 10             	pushl  0x10(%ebp)
  8017fd:	ff 75 0c             	pushl  0xc(%ebp)
  801800:	50                   	push   %eax
  801801:	6a 20                	push   $0x20
  801803:	e8 89 fc ff ff       	call   801491 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	50                   	push   %eax
  80181c:	6a 21                	push   $0x21
  80181e:	e8 6e fc ff ff       	call   801491 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	50                   	push   %eax
  801838:	6a 22                	push   $0x22
  80183a:	e8 52 fc ff ff       	call   801491 <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 02                	push   $0x2
  801853:	e8 39 fc ff ff       	call   801491 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 03                	push   $0x3
  80186c:	e8 20 fc ff ff       	call   801491 <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 04                	push   $0x4
  801885:	e8 07 fc ff ff       	call   801491 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_exit_env>:


void sys_exit_env(void)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 23                	push   $0x23
  80189e:	e8 ee fb ff ff       	call   801491 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	90                   	nop
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b2:	8d 50 04             	lea    0x4(%eax),%edx
  8018b5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 24                	push   $0x24
  8018c2:	e8 ca fb ff ff       	call   801491 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return result;
  8018ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018d3:	89 01                	mov    %eax,(%ecx)
  8018d5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018db:	c9                   	leave  
  8018dc:	c2 04 00             	ret    $0x4

008018df <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 10             	pushl  0x10(%ebp)
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	ff 75 08             	pushl  0x8(%ebp)
  8018ef:	6a 12                	push   $0x12
  8018f1:	e8 9b fb ff ff       	call   801491 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f9:	90                   	nop
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_rcr2>:
uint32 sys_rcr2()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 25                	push   $0x25
  80190b:	e8 81 fb ff ff       	call   801491 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 04             	sub    $0x4,%esp
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801921:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	50                   	push   %eax
  80192e:	6a 26                	push   $0x26
  801930:	e8 5c fb ff ff       	call   801491 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
	return ;
  801938:	90                   	nop
}
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <rsttst>:
void rsttst()
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 28                	push   $0x28
  80194a:	e8 42 fb ff ff       	call   801491 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return ;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	8b 45 14             	mov    0x14(%ebp),%eax
  80195e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801961:	8b 55 18             	mov    0x18(%ebp),%edx
  801964:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801968:	52                   	push   %edx
  801969:	50                   	push   %eax
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 27                	push   $0x27
  801975:	e8 17 fb ff ff       	call   801491 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <chktst>:
void chktst(uint32 n)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 29                	push   $0x29
  801990:	e8 fc fa ff ff       	call   801491 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return ;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <inctst>:

void inctst()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 2a                	push   $0x2a
  8019aa:	e8 e2 fa ff ff       	call   801491 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <gettst>:
uint32 gettst()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 2b                	push   $0x2b
  8019c4:	e8 c8 fa ff ff       	call   801491 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
  8019d1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 2c                	push   $0x2c
  8019e0:	e8 ac fa ff ff       	call   801491 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
  8019e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019eb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019ef:	75 07                	jne    8019f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f6:	eb 05                	jmp    8019fd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 2c                	push   $0x2c
  801a11:	e8 7b fa ff ff       	call   801491 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
  801a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a1c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a20:	75 07                	jne    801a29 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a22:	b8 01 00 00 00       	mov    $0x1,%eax
  801a27:	eb 05                	jmp    801a2e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 2c                	push   $0x2c
  801a42:	e8 4a fa ff ff       	call   801491 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
  801a4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a4d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a51:	75 07                	jne    801a5a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a53:	b8 01 00 00 00       	mov    $0x1,%eax
  801a58:	eb 05                	jmp    801a5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 2c                	push   $0x2c
  801a73:	e8 19 fa ff ff       	call   801491 <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
  801a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a7e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a82:	75 07                	jne    801a8b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a84:	b8 01 00 00 00       	mov    $0x1,%eax
  801a89:	eb 05                	jmp    801a90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	ff 75 08             	pushl  0x8(%ebp)
  801aa0:	6a 2d                	push   $0x2d
  801aa2:	e8 ea f9 ff ff       	call   801491 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
	return ;
  801aaa:	90                   	nop
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
  801ab0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ab1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	53                   	push   %ebx
  801ac0:	51                   	push   %ecx
  801ac1:	52                   	push   %edx
  801ac2:	50                   	push   %eax
  801ac3:	6a 2e                	push   $0x2e
  801ac5:	e8 c7 f9 ff ff       	call   801491 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 2f                	push   $0x2f
  801ae5:	e8 a7 f9 ff ff       	call   801491 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 84 3b 80 00       	push   $0x803b84
  801afd:	e8 46 e8 ff ff       	call   800348 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801b05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	68 b0 3b 80 00       	push   $0x803bb0
  801b14:	e8 2f e8 ff ff       	call   800348 <cprintf>
  801b19:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801b1c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b20:	a1 38 41 80 00       	mov    0x804138,%eax
  801b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b28:	eb 56                	jmp    801b80 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b2e:	74 1c                	je     801b4c <print_mem_block_lists+0x5d>
  801b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b33:	8b 50 08             	mov    0x8(%eax),%edx
  801b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b39:	8b 48 08             	mov    0x8(%eax),%ecx
  801b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b42:	01 c8                	add    %ecx,%eax
  801b44:	39 c2                	cmp    %eax,%edx
  801b46:	73 04                	jae    801b4c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801b48:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4f:	8b 50 08             	mov    0x8(%eax),%edx
  801b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b55:	8b 40 0c             	mov    0xc(%eax),%eax
  801b58:	01 c2                	add    %eax,%edx
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	8b 40 08             	mov    0x8(%eax),%eax
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	52                   	push   %edx
  801b64:	50                   	push   %eax
  801b65:	68 c5 3b 80 00       	push   $0x803bc5
  801b6a:	e8 d9 e7 ff ff       	call   800348 <cprintf>
  801b6f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b78:	a1 40 41 80 00       	mov    0x804140,%eax
  801b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b84:	74 07                	je     801b8d <print_mem_block_lists+0x9e>
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	8b 00                	mov    (%eax),%eax
  801b8b:	eb 05                	jmp    801b92 <print_mem_block_lists+0xa3>
  801b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b92:	a3 40 41 80 00       	mov    %eax,0x804140
  801b97:	a1 40 41 80 00       	mov    0x804140,%eax
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	75 8a                	jne    801b2a <print_mem_block_lists+0x3b>
  801ba0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba4:	75 84                	jne    801b2a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ba6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801baa:	75 10                	jne    801bbc <print_mem_block_lists+0xcd>
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	68 d4 3b 80 00       	push   $0x803bd4
  801bb4:	e8 8f e7 ff ff       	call   800348 <cprintf>
  801bb9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801bbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801bc3:	83 ec 0c             	sub    $0xc,%esp
  801bc6:	68 f8 3b 80 00       	push   $0x803bf8
  801bcb:	e8 78 e7 ff ff       	call   800348 <cprintf>
  801bd0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801bd3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801bd7:	a1 40 40 80 00       	mov    0x804040,%eax
  801bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bdf:	eb 56                	jmp    801c37 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801be1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be5:	74 1c                	je     801c03 <print_mem_block_lists+0x114>
  801be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bea:	8b 50 08             	mov    0x8(%eax),%edx
  801bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf0:	8b 48 08             	mov    0x8(%eax),%ecx
  801bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf6:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf9:	01 c8                	add    %ecx,%eax
  801bfb:	39 c2                	cmp    %eax,%edx
  801bfd:	73 04                	jae    801c03 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801bff:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	8b 50 08             	mov    0x8(%eax),%edx
  801c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0f:	01 c2                	add    %eax,%edx
  801c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c14:	8b 40 08             	mov    0x8(%eax),%eax
  801c17:	83 ec 04             	sub    $0x4,%esp
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	68 c5 3b 80 00       	push   $0x803bc5
  801c21:	e8 22 e7 ff ff       	call   800348 <cprintf>
  801c26:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c2f:	a1 48 40 80 00       	mov    0x804048,%eax
  801c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c3b:	74 07                	je     801c44 <print_mem_block_lists+0x155>
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	eb 05                	jmp    801c49 <print_mem_block_lists+0x15a>
  801c44:	b8 00 00 00 00       	mov    $0x0,%eax
  801c49:	a3 48 40 80 00       	mov    %eax,0x804048
  801c4e:	a1 48 40 80 00       	mov    0x804048,%eax
  801c53:	85 c0                	test   %eax,%eax
  801c55:	75 8a                	jne    801be1 <print_mem_block_lists+0xf2>
  801c57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c5b:	75 84                	jne    801be1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c5d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c61:	75 10                	jne    801c73 <print_mem_block_lists+0x184>
  801c63:	83 ec 0c             	sub    $0xc,%esp
  801c66:	68 10 3c 80 00       	push   $0x803c10
  801c6b:	e8 d8 e6 ff ff       	call   800348 <cprintf>
  801c70:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c73:	83 ec 0c             	sub    $0xc,%esp
  801c76:	68 84 3b 80 00       	push   $0x803b84
  801c7b:	e8 c8 e6 ff ff       	call   800348 <cprintf>
  801c80:	83 c4 10             	add    $0x10,%esp

}
  801c83:	90                   	nop
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801c8c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801c93:	00 00 00 
  801c96:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801c9d:	00 00 00 
  801ca0:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ca7:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801cb1:	e9 9e 00 00 00       	jmp    801d54 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801cb6:	a1 50 40 80 00       	mov    0x804050,%eax
  801cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbe:	c1 e2 04             	shl    $0x4,%edx
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	75 14                	jne    801cdb <initialize_MemBlocksList+0x55>
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	68 38 3c 80 00       	push   $0x803c38
  801ccf:	6a 46                	push   $0x46
  801cd1:	68 5b 3c 80 00       	push   $0x803c5b
  801cd6:	e8 64 14 00 00       	call   80313f <_panic>
  801cdb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ce3:	c1 e2 04             	shl    $0x4,%edx
  801ce6:	01 d0                	add    %edx,%eax
  801ce8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801cee:	89 10                	mov    %edx,(%eax)
  801cf0:	8b 00                	mov    (%eax),%eax
  801cf2:	85 c0                	test   %eax,%eax
  801cf4:	74 18                	je     801d0e <initialize_MemBlocksList+0x88>
  801cf6:	a1 48 41 80 00       	mov    0x804148,%eax
  801cfb:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801d01:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d04:	c1 e1 04             	shl    $0x4,%ecx
  801d07:	01 ca                	add    %ecx,%edx
  801d09:	89 50 04             	mov    %edx,0x4(%eax)
  801d0c:	eb 12                	jmp    801d20 <initialize_MemBlocksList+0x9a>
  801d0e:	a1 50 40 80 00       	mov    0x804050,%eax
  801d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d16:	c1 e2 04             	shl    $0x4,%edx
  801d19:	01 d0                	add    %edx,%eax
  801d1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801d20:	a1 50 40 80 00       	mov    0x804050,%eax
  801d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d28:	c1 e2 04             	shl    $0x4,%edx
  801d2b:	01 d0                	add    %edx,%eax
  801d2d:	a3 48 41 80 00       	mov    %eax,0x804148
  801d32:	a1 50 40 80 00       	mov    0x804050,%eax
  801d37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3a:	c1 e2 04             	shl    $0x4,%edx
  801d3d:	01 d0                	add    %edx,%eax
  801d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d46:	a1 54 41 80 00       	mov    0x804154,%eax
  801d4b:	40                   	inc    %eax
  801d4c:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801d51:	ff 45 f4             	incl   -0xc(%ebp)
  801d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d57:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d5a:	0f 82 56 ff ff ff    	jb     801cb6 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d60:	90                   	nop
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d71:	eb 19                	jmp    801d8c <find_block+0x29>
	{
		if(va==point->sva)
  801d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d76:	8b 40 08             	mov    0x8(%eax),%eax
  801d79:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d7c:	75 05                	jne    801d83 <find_block+0x20>
		   return point;
  801d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d81:	eb 36                	jmp    801db9 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	8b 40 08             	mov    0x8(%eax),%eax
  801d89:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d90:	74 07                	je     801d99 <find_block+0x36>
  801d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	eb 05                	jmp    801d9e <find_block+0x3b>
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801da1:	89 42 08             	mov    %eax,0x8(%edx)
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	8b 40 08             	mov    0x8(%eax),%eax
  801daa:	85 c0                	test   %eax,%eax
  801dac:	75 c5                	jne    801d73 <find_block+0x10>
  801dae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801db2:	75 bf                	jne    801d73 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801dc1:	a1 40 40 80 00       	mov    0x804040,%eax
  801dc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801dc9:	a1 44 40 80 00       	mov    0x804044,%eax
  801dce:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801dd7:	74 24                	je     801dfd <insert_sorted_allocList+0x42>
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	8b 50 08             	mov    0x8(%eax),%edx
  801ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de2:	8b 40 08             	mov    0x8(%eax),%eax
  801de5:	39 c2                	cmp    %eax,%edx
  801de7:	76 14                	jbe    801dfd <insert_sorted_allocList+0x42>
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	8b 50 08             	mov    0x8(%eax),%edx
  801def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df2:	8b 40 08             	mov    0x8(%eax),%eax
  801df5:	39 c2                	cmp    %eax,%edx
  801df7:	0f 82 60 01 00 00    	jb     801f5d <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e01:	75 65                	jne    801e68 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801e03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e07:	75 14                	jne    801e1d <insert_sorted_allocList+0x62>
  801e09:	83 ec 04             	sub    $0x4,%esp
  801e0c:	68 38 3c 80 00       	push   $0x803c38
  801e11:	6a 6b                	push   $0x6b
  801e13:	68 5b 3c 80 00       	push   $0x803c5b
  801e18:	e8 22 13 00 00       	call   80313f <_panic>
  801e1d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 10                	mov    %edx,(%eax)
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	8b 00                	mov    (%eax),%eax
  801e2d:	85 c0                	test   %eax,%eax
  801e2f:	74 0d                	je     801e3e <insert_sorted_allocList+0x83>
  801e31:	a1 40 40 80 00       	mov    0x804040,%eax
  801e36:	8b 55 08             	mov    0x8(%ebp),%edx
  801e39:	89 50 04             	mov    %edx,0x4(%eax)
  801e3c:	eb 08                	jmp    801e46 <insert_sorted_allocList+0x8b>
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	a3 44 40 80 00       	mov    %eax,0x804044
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	a3 40 40 80 00       	mov    %eax,0x804040
  801e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e58:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e5d:	40                   	inc    %eax
  801e5e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e63:	e9 dc 01 00 00       	jmp    802044 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	8b 50 08             	mov    0x8(%eax),%edx
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e71:	8b 40 08             	mov    0x8(%eax),%eax
  801e74:	39 c2                	cmp    %eax,%edx
  801e76:	77 6c                	ja     801ee4 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801e78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7c:	74 06                	je     801e84 <insert_sorted_allocList+0xc9>
  801e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e82:	75 14                	jne    801e98 <insert_sorted_allocList+0xdd>
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	68 74 3c 80 00       	push   $0x803c74
  801e8c:	6a 6f                	push   $0x6f
  801e8e:	68 5b 3c 80 00       	push   $0x803c5b
  801e93:	e8 a7 12 00 00       	call   80313f <_panic>
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	8b 50 04             	mov    0x4(%eax),%edx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	89 50 04             	mov    %edx,0x4(%eax)
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eaa:	89 10                	mov    %edx,(%eax)
  801eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaf:	8b 40 04             	mov    0x4(%eax),%eax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	74 0d                	je     801ec3 <insert_sorted_allocList+0x108>
  801eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb9:	8b 40 04             	mov    0x4(%eax),%eax
  801ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  801ebf:	89 10                	mov    %edx,(%eax)
  801ec1:	eb 08                	jmp    801ecb <insert_sorted_allocList+0x110>
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	a3 40 40 80 00       	mov    %eax,0x804040
  801ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ece:	8b 55 08             	mov    0x8(%ebp),%edx
  801ed1:	89 50 04             	mov    %edx,0x4(%eax)
  801ed4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ed9:	40                   	inc    %eax
  801eda:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801edf:	e9 60 01 00 00       	jmp    802044 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	8b 50 08             	mov    0x8(%eax),%edx
  801eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eed:	8b 40 08             	mov    0x8(%eax),%eax
  801ef0:	39 c2                	cmp    %eax,%edx
  801ef2:	0f 82 4c 01 00 00    	jb     802044 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801ef8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801efc:	75 14                	jne    801f12 <insert_sorted_allocList+0x157>
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 ac 3c 80 00       	push   $0x803cac
  801f06:	6a 73                	push   $0x73
  801f08:	68 5b 3c 80 00       	push   $0x803c5b
  801f0d:	e8 2d 12 00 00       	call   80313f <_panic>
  801f12:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	89 50 04             	mov    %edx,0x4(%eax)
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	8b 40 04             	mov    0x4(%eax),%eax
  801f24:	85 c0                	test   %eax,%eax
  801f26:	74 0c                	je     801f34 <insert_sorted_allocList+0x179>
  801f28:	a1 44 40 80 00       	mov    0x804044,%eax
  801f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f30:	89 10                	mov    %edx,(%eax)
  801f32:	eb 08                	jmp    801f3c <insert_sorted_allocList+0x181>
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	a3 40 40 80 00       	mov    %eax,0x804040
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	a3 44 40 80 00       	mov    %eax,0x804044
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f4d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f52:	40                   	inc    %eax
  801f53:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f58:	e9 e7 00 00 00       	jmp    802044 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f6a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f72:	e9 9d 00 00 00       	jmp    802014 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 00                	mov    (%eax),%eax
  801f7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f82:	8b 50 08             	mov    0x8(%eax),%edx
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 40 08             	mov    0x8(%eax),%eax
  801f8b:	39 c2                	cmp    %eax,%edx
  801f8d:	76 7d                	jbe    80200c <insert_sorted_allocList+0x251>
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	8b 50 08             	mov    0x8(%eax),%edx
  801f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f98:	8b 40 08             	mov    0x8(%eax),%eax
  801f9b:	39 c2                	cmp    %eax,%edx
  801f9d:	73 6d                	jae    80200c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa3:	74 06                	je     801fab <insert_sorted_allocList+0x1f0>
  801fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fa9:	75 14                	jne    801fbf <insert_sorted_allocList+0x204>
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	68 d0 3c 80 00       	push   $0x803cd0
  801fb3:	6a 7f                	push   $0x7f
  801fb5:	68 5b 3c 80 00       	push   $0x803c5b
  801fba:	e8 80 11 00 00       	call   80313f <_panic>
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 10                	mov    (%eax),%edx
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	89 10                	mov    %edx,(%eax)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	8b 00                	mov    (%eax),%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	74 0b                	je     801fdd <insert_sorted_allocList+0x222>
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 00                	mov    (%eax),%eax
  801fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fda:	89 50 04             	mov    %edx,0x4(%eax)
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  801fe3:	89 10                	mov    %edx,(%eax)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801feb:	89 50 04             	mov    %edx,0x4(%eax)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 00                	mov    (%eax),%eax
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	75 08                	jne    801fff <insert_sorted_allocList+0x244>
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	a3 44 40 80 00       	mov    %eax,0x804044
  801fff:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802004:	40                   	inc    %eax
  802005:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80200a:	eb 39                	jmp    802045 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80200c:	a1 48 40 80 00       	mov    0x804048,%eax
  802011:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802014:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802018:	74 07                	je     802021 <insert_sorted_allocList+0x266>
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 00                	mov    (%eax),%eax
  80201f:	eb 05                	jmp    802026 <insert_sorted_allocList+0x26b>
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
  802026:	a3 48 40 80 00       	mov    %eax,0x804048
  80202b:	a1 48 40 80 00       	mov    0x804048,%eax
  802030:	85 c0                	test   %eax,%eax
  802032:	0f 85 3f ff ff ff    	jne    801f77 <insert_sorted_allocList+0x1bc>
  802038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203c:	0f 85 35 ff ff ff    	jne    801f77 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802042:	eb 01                	jmp    802045 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802044:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802045:	90                   	nop
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
  80204b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80204e:	a1 38 41 80 00       	mov    0x804138,%eax
  802053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802056:	e9 85 01 00 00       	jmp    8021e0 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80205b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205e:	8b 40 0c             	mov    0xc(%eax),%eax
  802061:	3b 45 08             	cmp    0x8(%ebp),%eax
  802064:	0f 82 6e 01 00 00    	jb     8021d8 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	8b 40 0c             	mov    0xc(%eax),%eax
  802070:	3b 45 08             	cmp    0x8(%ebp),%eax
  802073:	0f 85 8a 00 00 00    	jne    802103 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207d:	75 17                	jne    802096 <alloc_block_FF+0x4e>
  80207f:	83 ec 04             	sub    $0x4,%esp
  802082:	68 04 3d 80 00       	push   $0x803d04
  802087:	68 93 00 00 00       	push   $0x93
  80208c:	68 5b 3c 80 00       	push   $0x803c5b
  802091:	e8 a9 10 00 00       	call   80313f <_panic>
  802096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802099:	8b 00                	mov    (%eax),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	74 10                	je     8020af <alloc_block_FF+0x67>
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 00                	mov    (%eax),%eax
  8020a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a7:	8b 52 04             	mov    0x4(%edx),%edx
  8020aa:	89 50 04             	mov    %edx,0x4(%eax)
  8020ad:	eb 0b                	jmp    8020ba <alloc_block_FF+0x72>
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 40 04             	mov    0x4(%eax),%eax
  8020b5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	8b 40 04             	mov    0x4(%eax),%eax
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	74 0f                	je     8020d3 <alloc_block_FF+0x8b>
  8020c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c7:	8b 40 04             	mov    0x4(%eax),%eax
  8020ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cd:	8b 12                	mov    (%edx),%edx
  8020cf:	89 10                	mov    %edx,(%eax)
  8020d1:	eb 0a                	jmp    8020dd <alloc_block_FF+0x95>
  8020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d6:	8b 00                	mov    (%eax),%eax
  8020d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f0:	a1 44 41 80 00       	mov    0x804144,%eax
  8020f5:	48                   	dec    %eax
  8020f6:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	e9 10 01 00 00       	jmp    802213 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	8b 40 0c             	mov    0xc(%eax),%eax
  802109:	3b 45 08             	cmp    0x8(%ebp),%eax
  80210c:	0f 86 c6 00 00 00    	jbe    8021d8 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802112:	a1 48 41 80 00       	mov    0x804148,%eax
  802117:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 50 08             	mov    0x8(%eax),%edx
  802120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802123:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802129:	8b 55 08             	mov    0x8(%ebp),%edx
  80212c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80212f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802133:	75 17                	jne    80214c <alloc_block_FF+0x104>
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	68 04 3d 80 00       	push   $0x803d04
  80213d:	68 9b 00 00 00       	push   $0x9b
  802142:	68 5b 3c 80 00       	push   $0x803c5b
  802147:	e8 f3 0f 00 00       	call   80313f <_panic>
  80214c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214f:	8b 00                	mov    (%eax),%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 10                	je     802165 <alloc_block_FF+0x11d>
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	8b 00                	mov    (%eax),%eax
  80215a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80215d:	8b 52 04             	mov    0x4(%edx),%edx
  802160:	89 50 04             	mov    %edx,0x4(%eax)
  802163:	eb 0b                	jmp    802170 <alloc_block_FF+0x128>
  802165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802168:	8b 40 04             	mov    0x4(%eax),%eax
  80216b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802173:	8b 40 04             	mov    0x4(%eax),%eax
  802176:	85 c0                	test   %eax,%eax
  802178:	74 0f                	je     802189 <alloc_block_FF+0x141>
  80217a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217d:	8b 40 04             	mov    0x4(%eax),%eax
  802180:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802183:	8b 12                	mov    (%edx),%edx
  802185:	89 10                	mov    %edx,(%eax)
  802187:	eb 0a                	jmp    802193 <alloc_block_FF+0x14b>
  802189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218c:	8b 00                	mov    (%eax),%eax
  80218e:	a3 48 41 80 00       	mov    %eax,0x804148
  802193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80219c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ab:	48                   	dec    %eax
  8021ac:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 50 08             	mov    0x8(%eax),%edx
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	01 c2                	add    %eax,%edx
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8021c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8021cb:	89 c2                	mov    %eax,%edx
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	eb 3b                	jmp    802213 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8021dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e4:	74 07                	je     8021ed <alloc_block_FF+0x1a5>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	eb 05                	jmp    8021f2 <alloc_block_FF+0x1aa>
  8021ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8021f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8021fc:	85 c0                	test   %eax,%eax
  8021fe:	0f 85 57 fe ff ff    	jne    80205b <alloc_block_FF+0x13>
  802204:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802208:	0f 85 4d fe ff ff    	jne    80205b <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80221b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802222:	a1 38 41 80 00       	mov    0x804138,%eax
  802227:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80222a:	e9 df 00 00 00       	jmp    80230e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 40 0c             	mov    0xc(%eax),%eax
  802235:	3b 45 08             	cmp    0x8(%ebp),%eax
  802238:	0f 82 c8 00 00 00    	jb     802306 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802241:	8b 40 0c             	mov    0xc(%eax),%eax
  802244:	3b 45 08             	cmp    0x8(%ebp),%eax
  802247:	0f 85 8a 00 00 00    	jne    8022d7 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80224d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802251:	75 17                	jne    80226a <alloc_block_BF+0x55>
  802253:	83 ec 04             	sub    $0x4,%esp
  802256:	68 04 3d 80 00       	push   $0x803d04
  80225b:	68 b7 00 00 00       	push   $0xb7
  802260:	68 5b 3c 80 00       	push   $0x803c5b
  802265:	e8 d5 0e 00 00       	call   80313f <_panic>
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 10                	je     802283 <alloc_block_BF+0x6e>
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227b:	8b 52 04             	mov    0x4(%edx),%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	eb 0b                	jmp    80228e <alloc_block_BF+0x79>
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 40 04             	mov    0x4(%eax),%eax
  802289:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 40 04             	mov    0x4(%eax),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	74 0f                	je     8022a7 <alloc_block_BF+0x92>
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 40 04             	mov    0x4(%eax),%eax
  80229e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a1:	8b 12                	mov    (%edx),%edx
  8022a3:	89 10                	mov    %edx,(%eax)
  8022a5:	eb 0a                	jmp    8022b1 <alloc_block_BF+0x9c>
  8022a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022aa:	8b 00                	mov    (%eax),%eax
  8022ac:	a3 38 41 80 00       	mov    %eax,0x804138
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8022c9:	48                   	dec    %eax
  8022ca:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	e9 4d 01 00 00       	jmp    802424 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 0c             	mov    0xc(%eax),%eax
  8022dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e0:	76 24                	jbe    802306 <alloc_block_BF+0xf1>
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022eb:	73 19                	jae    802306 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8022ed:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802306:	a1 40 41 80 00       	mov    0x804140,%eax
  80230b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802312:	74 07                	je     80231b <alloc_block_BF+0x106>
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	eb 05                	jmp    802320 <alloc_block_BF+0x10b>
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
  802320:	a3 40 41 80 00       	mov    %eax,0x804140
  802325:	a1 40 41 80 00       	mov    0x804140,%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	0f 85 fd fe ff ff    	jne    80222f <alloc_block_BF+0x1a>
  802332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802336:	0f 85 f3 fe ff ff    	jne    80222f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80233c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802340:	0f 84 d9 00 00 00    	je     80241f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802346:	a1 48 41 80 00       	mov    0x804148,%eax
  80234b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80234e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802351:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802354:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80235a:	8b 55 08             	mov    0x8(%ebp),%edx
  80235d:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802364:	75 17                	jne    80237d <alloc_block_BF+0x168>
  802366:	83 ec 04             	sub    $0x4,%esp
  802369:	68 04 3d 80 00       	push   $0x803d04
  80236e:	68 c7 00 00 00       	push   $0xc7
  802373:	68 5b 3c 80 00       	push   $0x803c5b
  802378:	e8 c2 0d 00 00       	call   80313f <_panic>
  80237d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802380:	8b 00                	mov    (%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 10                	je     802396 <alloc_block_BF+0x181>
  802386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802389:	8b 00                	mov    (%eax),%eax
  80238b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80238e:	8b 52 04             	mov    0x4(%edx),%edx
  802391:	89 50 04             	mov    %edx,0x4(%eax)
  802394:	eb 0b                	jmp    8023a1 <alloc_block_BF+0x18c>
  802396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802399:	8b 40 04             	mov    0x4(%eax),%eax
  80239c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a4:	8b 40 04             	mov    0x4(%eax),%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	74 0f                	je     8023ba <alloc_block_BF+0x1a5>
  8023ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ae:	8b 40 04             	mov    0x4(%eax),%eax
  8023b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8023b4:	8b 12                	mov    (%edx),%edx
  8023b6:	89 10                	mov    %edx,(%eax)
  8023b8:	eb 0a                	jmp    8023c4 <alloc_block_BF+0x1af>
  8023ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	a3 48 41 80 00       	mov    %eax,0x804148
  8023c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d7:	a1 54 41 80 00       	mov    0x804154,%eax
  8023dc:	48                   	dec    %eax
  8023dd:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8023e2:	83 ec 08             	sub    $0x8,%esp
  8023e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8023e8:	68 38 41 80 00       	push   $0x804138
  8023ed:	e8 71 f9 ff ff       	call   801d63 <find_block>
  8023f2:	83 c4 10             	add    $0x10,%esp
  8023f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8023f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023fb:	8b 50 08             	mov    0x8(%eax),%edx
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	01 c2                	add    %eax,%edx
  802403:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802406:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80240c:	8b 40 0c             	mov    0xc(%eax),%eax
  80240f:	2b 45 08             	sub    0x8(%ebp),%eax
  802412:	89 c2                	mov    %eax,%edx
  802414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802417:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80241a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80241d:	eb 05                	jmp    802424 <alloc_block_BF+0x20f>
	}
	return NULL;
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80242c:	a1 28 40 80 00       	mov    0x804028,%eax
  802431:	85 c0                	test   %eax,%eax
  802433:	0f 85 de 01 00 00    	jne    802617 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802439:	a1 38 41 80 00       	mov    0x804138,%eax
  80243e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802441:	e9 9e 01 00 00       	jmp    8025e4 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 0c             	mov    0xc(%eax),%eax
  80244c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244f:	0f 82 87 01 00 00    	jb     8025dc <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245e:	0f 85 95 00 00 00    	jne    8024f9 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802468:	75 17                	jne    802481 <alloc_block_NF+0x5b>
  80246a:	83 ec 04             	sub    $0x4,%esp
  80246d:	68 04 3d 80 00       	push   $0x803d04
  802472:	68 e0 00 00 00       	push   $0xe0
  802477:	68 5b 3c 80 00       	push   $0x803c5b
  80247c:	e8 be 0c 00 00       	call   80313f <_panic>
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 00                	mov    (%eax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	74 10                	je     80249a <alloc_block_NF+0x74>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 00                	mov    (%eax),%eax
  80248f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802492:	8b 52 04             	mov    0x4(%edx),%edx
  802495:	89 50 04             	mov    %edx,0x4(%eax)
  802498:	eb 0b                	jmp    8024a5 <alloc_block_NF+0x7f>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 04             	mov    0x4(%eax),%eax
  8024a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 40 04             	mov    0x4(%eax),%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	74 0f                	je     8024be <alloc_block_NF+0x98>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 04             	mov    0x4(%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	8b 12                	mov    (%edx),%edx
  8024ba:	89 10                	mov    %edx,(%eax)
  8024bc:	eb 0a                	jmp    8024c8 <alloc_block_NF+0xa2>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024db:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e0:	48                   	dec    %eax
  8024e1:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 40 08             	mov    0x8(%eax),%eax
  8024ec:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	e9 f8 04 00 00       	jmp    8029f1 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802502:	0f 86 d4 00 00 00    	jbe    8025dc <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802508:	a1 48 41 80 00       	mov    0x804148,%eax
  80250d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	8b 50 08             	mov    0x8(%eax),%edx
  802516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802519:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	8b 55 08             	mov    0x8(%ebp),%edx
  802522:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802525:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802529:	75 17                	jne    802542 <alloc_block_NF+0x11c>
  80252b:	83 ec 04             	sub    $0x4,%esp
  80252e:	68 04 3d 80 00       	push   $0x803d04
  802533:	68 e9 00 00 00       	push   $0xe9
  802538:	68 5b 3c 80 00       	push   $0x803c5b
  80253d:	e8 fd 0b 00 00       	call   80313f <_panic>
  802542:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802545:	8b 00                	mov    (%eax),%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	74 10                	je     80255b <alloc_block_NF+0x135>
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	8b 00                	mov    (%eax),%eax
  802550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802553:	8b 52 04             	mov    0x4(%edx),%edx
  802556:	89 50 04             	mov    %edx,0x4(%eax)
  802559:	eb 0b                	jmp    802566 <alloc_block_NF+0x140>
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	8b 40 04             	mov    0x4(%eax),%eax
  80256c:	85 c0                	test   %eax,%eax
  80256e:	74 0f                	je     80257f <alloc_block_NF+0x159>
  802570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802573:	8b 40 04             	mov    0x4(%eax),%eax
  802576:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802579:	8b 12                	mov    (%edx),%edx
  80257b:	89 10                	mov    %edx,(%eax)
  80257d:	eb 0a                	jmp    802589 <alloc_block_NF+0x163>
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	8b 00                	mov    (%eax),%eax
  802584:	a3 48 41 80 00       	mov    %eax,0x804148
  802589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259c:	a1 54 41 80 00       	mov    0x804154,%eax
  8025a1:	48                   	dec    %eax
  8025a2:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	8b 40 08             	mov    0x8(%eax),%eax
  8025ad:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 50 08             	mov    0x8(%eax),%edx
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	01 c2                	add    %eax,%edx
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8025cc:	89 c2                	mov    %eax,%edx
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	e9 15 04 00 00       	jmp    8029f1 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e8:	74 07                	je     8025f1 <alloc_block_NF+0x1cb>
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	eb 05                	jmp    8025f6 <alloc_block_NF+0x1d0>
  8025f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f6:	a3 40 41 80 00       	mov    %eax,0x804140
  8025fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	0f 85 3e fe ff ff    	jne    802446 <alloc_block_NF+0x20>
  802608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260c:	0f 85 34 fe ff ff    	jne    802446 <alloc_block_NF+0x20>
  802612:	e9 d5 03 00 00       	jmp    8029ec <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802617:	a1 38 41 80 00       	mov    0x804138,%eax
  80261c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261f:	e9 b1 01 00 00       	jmp    8027d5 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 50 08             	mov    0x8(%eax),%edx
  80262a:	a1 28 40 80 00       	mov    0x804028,%eax
  80262f:	39 c2                	cmp    %eax,%edx
  802631:	0f 82 96 01 00 00    	jb     8027cd <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 40 0c             	mov    0xc(%eax),%eax
  80263d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802640:	0f 82 87 01 00 00    	jb     8027cd <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264f:	0f 85 95 00 00 00    	jne    8026ea <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802659:	75 17                	jne    802672 <alloc_block_NF+0x24c>
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 04 3d 80 00       	push   $0x803d04
  802663:	68 fc 00 00 00       	push   $0xfc
  802668:	68 5b 3c 80 00       	push   $0x803c5b
  80266d:	e8 cd 0a 00 00       	call   80313f <_panic>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	74 10                	je     80268b <alloc_block_NF+0x265>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802683:	8b 52 04             	mov    0x4(%edx),%edx
  802686:	89 50 04             	mov    %edx,0x4(%eax)
  802689:	eb 0b                	jmp    802696 <alloc_block_NF+0x270>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 04             	mov    0x4(%eax),%eax
  802691:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 0f                	je     8026af <alloc_block_NF+0x289>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a9:	8b 12                	mov    (%edx),%edx
  8026ab:	89 10                	mov    %edx,(%eax)
  8026ad:	eb 0a                	jmp    8026b9 <alloc_block_NF+0x293>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8026d1:	48                   	dec    %eax
  8026d2:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 08             	mov    0x8(%eax),%eax
  8026dd:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	e9 07 03 00 00       	jmp    8029f1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f3:	0f 86 d4 00 00 00    	jbe    8027cd <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026f9:	a1 48 41 80 00       	mov    0x804148,%eax
  8026fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 50 08             	mov    0x8(%eax),%edx
  802707:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80270d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802710:	8b 55 08             	mov    0x8(%ebp),%edx
  802713:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802716:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80271a:	75 17                	jne    802733 <alloc_block_NF+0x30d>
  80271c:	83 ec 04             	sub    $0x4,%esp
  80271f:	68 04 3d 80 00       	push   $0x803d04
  802724:	68 04 01 00 00       	push   $0x104
  802729:	68 5b 3c 80 00       	push   $0x803c5b
  80272e:	e8 0c 0a 00 00       	call   80313f <_panic>
  802733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802736:	8b 00                	mov    (%eax),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 10                	je     80274c <alloc_block_NF+0x326>
  80273c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273f:	8b 00                	mov    (%eax),%eax
  802741:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802744:	8b 52 04             	mov    0x4(%edx),%edx
  802747:	89 50 04             	mov    %edx,0x4(%eax)
  80274a:	eb 0b                	jmp    802757 <alloc_block_NF+0x331>
  80274c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274f:	8b 40 04             	mov    0x4(%eax),%eax
  802752:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802757:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275a:	8b 40 04             	mov    0x4(%eax),%eax
  80275d:	85 c0                	test   %eax,%eax
  80275f:	74 0f                	je     802770 <alloc_block_NF+0x34a>
  802761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80276a:	8b 12                	mov    (%edx),%edx
  80276c:	89 10                	mov    %edx,(%eax)
  80276e:	eb 0a                	jmp    80277a <alloc_block_NF+0x354>
  802770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	a3 48 41 80 00       	mov    %eax,0x804148
  80277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802786:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278d:	a1 54 41 80 00       	mov    0x804154,%eax
  802792:	48                   	dec    %eax
  802793:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279b:	8b 40 08             	mov    0x8(%eax),%eax
  80279e:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 50 08             	mov    0x8(%eax),%edx
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	01 c2                	add    %eax,%edx
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ba:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bd:	89 c2                	mov    %eax,%edx
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8027c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c8:	e9 24 02 00 00       	jmp    8029f1 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027cd:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d9:	74 07                	je     8027e2 <alloc_block_NF+0x3bc>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	eb 05                	jmp    8027e7 <alloc_block_NF+0x3c1>
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ec:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f1:	85 c0                	test   %eax,%eax
  8027f3:	0f 85 2b fe ff ff    	jne    802624 <alloc_block_NF+0x1fe>
  8027f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fd:	0f 85 21 fe ff ff    	jne    802624 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802803:	a1 38 41 80 00       	mov    0x804138,%eax
  802808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280b:	e9 ae 01 00 00       	jmp    8029be <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 50 08             	mov    0x8(%eax),%edx
  802816:	a1 28 40 80 00       	mov    0x804028,%eax
  80281b:	39 c2                	cmp    %eax,%edx
  80281d:	0f 83 93 01 00 00    	jae    8029b6 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 0c             	mov    0xc(%eax),%eax
  802829:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282c:	0f 82 84 01 00 00    	jb     8029b6 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	8b 40 0c             	mov    0xc(%eax),%eax
  802838:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283b:	0f 85 95 00 00 00    	jne    8028d6 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802845:	75 17                	jne    80285e <alloc_block_NF+0x438>
  802847:	83 ec 04             	sub    $0x4,%esp
  80284a:	68 04 3d 80 00       	push   $0x803d04
  80284f:	68 14 01 00 00       	push   $0x114
  802854:	68 5b 3c 80 00       	push   $0x803c5b
  802859:	e8 e1 08 00 00       	call   80313f <_panic>
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	8b 00                	mov    (%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 10                	je     802877 <alloc_block_NF+0x451>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286f:	8b 52 04             	mov    0x4(%edx),%edx
  802872:	89 50 04             	mov    %edx,0x4(%eax)
  802875:	eb 0b                	jmp    802882 <alloc_block_NF+0x45c>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 04             	mov    0x4(%eax),%eax
  80287d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 04             	mov    0x4(%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 0f                	je     80289b <alloc_block_NF+0x475>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802895:	8b 12                	mov    (%edx),%edx
  802897:	89 10                	mov    %edx,(%eax)
  802899:	eb 0a                	jmp    8028a5 <alloc_block_NF+0x47f>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b8:	a1 44 41 80 00       	mov    0x804144,%eax
  8028bd:	48                   	dec    %eax
  8028be:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 40 08             	mov    0x8(%eax),%eax
  8028c9:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	e9 1b 01 00 00       	jmp    8029f1 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028df:	0f 86 d1 00 00 00    	jbe    8029b6 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 50 08             	mov    0x8(%eax),%edx
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ff:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802902:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802906:	75 17                	jne    80291f <alloc_block_NF+0x4f9>
  802908:	83 ec 04             	sub    $0x4,%esp
  80290b:	68 04 3d 80 00       	push   $0x803d04
  802910:	68 1c 01 00 00       	push   $0x11c
  802915:	68 5b 3c 80 00       	push   $0x803c5b
  80291a:	e8 20 08 00 00       	call   80313f <_panic>
  80291f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802922:	8b 00                	mov    (%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 10                	je     802938 <alloc_block_NF+0x512>
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802930:	8b 52 04             	mov    0x4(%edx),%edx
  802933:	89 50 04             	mov    %edx,0x4(%eax)
  802936:	eb 0b                	jmp    802943 <alloc_block_NF+0x51d>
  802938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293b:	8b 40 04             	mov    0x4(%eax),%eax
  80293e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 0f                	je     80295c <alloc_block_NF+0x536>
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	8b 40 04             	mov    0x4(%eax),%eax
  802953:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802956:	8b 12                	mov    (%edx),%edx
  802958:	89 10                	mov    %edx,(%eax)
  80295a:	eb 0a                	jmp    802966 <alloc_block_NF+0x540>
  80295c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	a3 48 41 80 00       	mov    %eax,0x804148
  802966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802969:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802979:	a1 54 41 80 00       	mov    0x804154,%eax
  80297e:	48                   	dec    %eax
  80297f:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	8b 40 08             	mov    0x8(%eax),%eax
  80298a:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 50 08             	mov    0x8(%eax),%edx
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	01 c2                	add    %eax,%edx
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a9:	89 c2                	mov    %eax,%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b4:	eb 3b                	jmp    8029f1 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029b6:	a1 40 41 80 00       	mov    0x804140,%eax
  8029bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c2:	74 07                	je     8029cb <alloc_block_NF+0x5a5>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	eb 05                	jmp    8029d0 <alloc_block_NF+0x5aa>
  8029cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d0:	a3 40 41 80 00       	mov    %eax,0x804140
  8029d5:	a1 40 41 80 00       	mov    0x804140,%eax
  8029da:	85 c0                	test   %eax,%eax
  8029dc:	0f 85 2e fe ff ff    	jne    802810 <alloc_block_NF+0x3ea>
  8029e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e6:	0f 85 24 fe ff ff    	jne    802810 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8029ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f1:	c9                   	leave  
  8029f2:	c3                   	ret    

008029f3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029f3:	55                   	push   %ebp
  8029f4:	89 e5                	mov    %esp,%ebp
  8029f6:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8029f9:	a1 38 41 80 00       	mov    0x804138,%eax
  8029fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802a01:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a06:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802a09:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 14                	je     802a26 <insert_sorted_with_merge_freeList+0x33>
  802a12:	8b 45 08             	mov    0x8(%ebp),%eax
  802a15:	8b 50 08             	mov    0x8(%eax),%edx
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	8b 40 08             	mov    0x8(%eax),%eax
  802a1e:	39 c2                	cmp    %eax,%edx
  802a20:	0f 87 9b 01 00 00    	ja     802bc1 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2a:	75 17                	jne    802a43 <insert_sorted_with_merge_freeList+0x50>
  802a2c:	83 ec 04             	sub    $0x4,%esp
  802a2f:	68 38 3c 80 00       	push   $0x803c38
  802a34:	68 38 01 00 00       	push   $0x138
  802a39:	68 5b 3c 80 00       	push   $0x803c5b
  802a3e:	e8 fc 06 00 00       	call   80313f <_panic>
  802a43:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	89 10                	mov    %edx,(%eax)
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	85 c0                	test   %eax,%eax
  802a55:	74 0d                	je     802a64 <insert_sorted_with_merge_freeList+0x71>
  802a57:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5f:	89 50 04             	mov    %edx,0x4(%eax)
  802a62:	eb 08                	jmp    802a6c <insert_sorted_with_merge_freeList+0x79>
  802a64:	8b 45 08             	mov    0x8(%ebp),%eax
  802a67:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a83:	40                   	inc    %eax
  802a84:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a8d:	0f 84 a8 06 00 00    	je     80313b <insert_sorted_with_merge_freeList+0x748>
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	8b 50 08             	mov    0x8(%eax),%edx
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9f:	01 c2                	add    %eax,%edx
  802aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa4:	8b 40 08             	mov    0x8(%eax),%eax
  802aa7:	39 c2                	cmp    %eax,%edx
  802aa9:	0f 85 8c 06 00 00    	jne    80313b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab8:	8b 40 0c             	mov    0xc(%eax),%eax
  802abb:	01 c2                	add    %eax,%edx
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ac3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac7:	75 17                	jne    802ae0 <insert_sorted_with_merge_freeList+0xed>
  802ac9:	83 ec 04             	sub    $0x4,%esp
  802acc:	68 04 3d 80 00       	push   $0x803d04
  802ad1:	68 3c 01 00 00       	push   $0x13c
  802ad6:	68 5b 3c 80 00       	push   $0x803c5b
  802adb:	e8 5f 06 00 00       	call   80313f <_panic>
  802ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 10                	je     802af9 <insert_sorted_with_merge_freeList+0x106>
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af1:	8b 52 04             	mov    0x4(%edx),%edx
  802af4:	89 50 04             	mov    %edx,0x4(%eax)
  802af7:	eb 0b                	jmp    802b04 <insert_sorted_with_merge_freeList+0x111>
  802af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 0f                	je     802b1d <insert_sorted_with_merge_freeList+0x12a>
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b17:	8b 12                	mov    (%edx),%edx
  802b19:	89 10                	mov    %edx,(%eax)
  802b1b:	eb 0a                	jmp    802b27 <insert_sorted_with_merge_freeList+0x134>
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	a3 38 41 80 00       	mov    %eax,0x804138
  802b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3f:	48                   	dec    %eax
  802b40:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b48:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b5d:	75 17                	jne    802b76 <insert_sorted_with_merge_freeList+0x183>
  802b5f:	83 ec 04             	sub    $0x4,%esp
  802b62:	68 38 3c 80 00       	push   $0x803c38
  802b67:	68 3f 01 00 00       	push   $0x13f
  802b6c:	68 5b 3c 80 00       	push   $0x803c5b
  802b71:	e8 c9 05 00 00       	call   80313f <_panic>
  802b76:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7f:	89 10                	mov    %edx,(%eax)
  802b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 0d                	je     802b97 <insert_sorted_with_merge_freeList+0x1a4>
  802b8a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b92:	89 50 04             	mov    %edx,0x4(%eax)
  802b95:	eb 08                	jmp    802b9f <insert_sorted_with_merge_freeList+0x1ac>
  802b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb1:	a1 54 41 80 00       	mov    0x804154,%eax
  802bb6:	40                   	inc    %eax
  802bb7:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bbc:	e9 7a 05 00 00       	jmp    80313b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	8b 50 08             	mov    0x8(%eax),%edx
  802bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bca:	8b 40 08             	mov    0x8(%eax),%eax
  802bcd:	39 c2                	cmp    %eax,%edx
  802bcf:	0f 82 14 01 00 00    	jb     802ce9 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	01 c2                	add    %eax,%edx
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	8b 40 08             	mov    0x8(%eax),%eax
  802be9:	39 c2                	cmp    %eax,%edx
  802beb:	0f 85 90 00 00 00    	jne    802c81 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfd:	01 c2                	add    %eax,%edx
  802bff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c02:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1d:	75 17                	jne    802c36 <insert_sorted_with_merge_freeList+0x243>
  802c1f:	83 ec 04             	sub    $0x4,%esp
  802c22:	68 38 3c 80 00       	push   $0x803c38
  802c27:	68 49 01 00 00       	push   $0x149
  802c2c:	68 5b 3c 80 00       	push   $0x803c5b
  802c31:	e8 09 05 00 00       	call   80313f <_panic>
  802c36:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	89 10                	mov    %edx,(%eax)
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	8b 00                	mov    (%eax),%eax
  802c46:	85 c0                	test   %eax,%eax
  802c48:	74 0d                	je     802c57 <insert_sorted_with_merge_freeList+0x264>
  802c4a:	a1 48 41 80 00       	mov    0x804148,%eax
  802c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	eb 08                	jmp    802c5f <insert_sorted_with_merge_freeList+0x26c>
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	a3 48 41 80 00       	mov    %eax,0x804148
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c71:	a1 54 41 80 00       	mov    0x804154,%eax
  802c76:	40                   	inc    %eax
  802c77:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c7c:	e9 bb 04 00 00       	jmp    80313c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c85:	75 17                	jne    802c9e <insert_sorted_with_merge_freeList+0x2ab>
  802c87:	83 ec 04             	sub    $0x4,%esp
  802c8a:	68 ac 3c 80 00       	push   $0x803cac
  802c8f:	68 4c 01 00 00       	push   $0x14c
  802c94:	68 5b 3c 80 00       	push   $0x803c5b
  802c99:	e8 a1 04 00 00       	call   80313f <_panic>
  802c9e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	89 50 04             	mov    %edx,0x4(%eax)
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 40 04             	mov    0x4(%eax),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	74 0c                	je     802cc0 <insert_sorted_with_merge_freeList+0x2cd>
  802cb4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	eb 08                	jmp    802cc8 <insert_sorted_with_merge_freeList+0x2d5>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	a3 38 41 80 00       	mov    %eax,0x804138
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cde:	40                   	inc    %eax
  802cdf:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ce4:	e9 53 04 00 00       	jmp    80313c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ce9:	a1 38 41 80 00       	mov    0x804138,%eax
  802cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf1:	e9 15 04 00 00       	jmp    80310b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 00                	mov    (%eax),%eax
  802cfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	8b 50 08             	mov    0x8(%eax),%edx
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 08             	mov    0x8(%eax),%eax
  802d0a:	39 c2                	cmp    %eax,%edx
  802d0c:	0f 86 f1 03 00 00    	jbe    803103 <insert_sorted_with_merge_freeList+0x710>
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	8b 50 08             	mov    0x8(%eax),%edx
  802d18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	39 c2                	cmp    %eax,%edx
  802d20:	0f 83 dd 03 00 00    	jae    803103 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 50 08             	mov    0x8(%eax),%edx
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d32:	01 c2                	add    %eax,%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	8b 40 08             	mov    0x8(%eax),%eax
  802d3a:	39 c2                	cmp    %eax,%edx
  802d3c:	0f 85 b9 01 00 00    	jne    802efb <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 50 08             	mov    0x8(%eax),%edx
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4e:	01 c2                	add    %eax,%edx
  802d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d53:	8b 40 08             	mov    0x8(%eax),%eax
  802d56:	39 c2                	cmp    %eax,%edx
  802d58:	0f 85 0d 01 00 00    	jne    802e6b <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 50 0c             	mov    0xc(%eax),%edx
  802d64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d67:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6a:	01 c2                	add    %eax,%edx
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d76:	75 17                	jne    802d8f <insert_sorted_with_merge_freeList+0x39c>
  802d78:	83 ec 04             	sub    $0x4,%esp
  802d7b:	68 04 3d 80 00       	push   $0x803d04
  802d80:	68 5c 01 00 00       	push   $0x15c
  802d85:	68 5b 3c 80 00       	push   $0x803c5b
  802d8a:	e8 b0 03 00 00       	call   80313f <_panic>
  802d8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d92:	8b 00                	mov    (%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 10                	je     802da8 <insert_sorted_with_merge_freeList+0x3b5>
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da0:	8b 52 04             	mov    0x4(%edx),%edx
  802da3:	89 50 04             	mov    %edx,0x4(%eax)
  802da6:	eb 0b                	jmp    802db3 <insert_sorted_with_merge_freeList+0x3c0>
  802da8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802db3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db6:	8b 40 04             	mov    0x4(%eax),%eax
  802db9:	85 c0                	test   %eax,%eax
  802dbb:	74 0f                	je     802dcc <insert_sorted_with_merge_freeList+0x3d9>
  802dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc0:	8b 40 04             	mov    0x4(%eax),%eax
  802dc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802dc6:	8b 12                	mov    (%edx),%edx
  802dc8:	89 10                	mov    %edx,(%eax)
  802dca:	eb 0a                	jmp    802dd6 <insert_sorted_with_merge_freeList+0x3e3>
  802dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	a3 38 41 80 00       	mov    %eax,0x804138
  802dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de9:	a1 44 41 80 00       	mov    0x804144,%eax
  802dee:	48                   	dec    %eax
  802def:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802dfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802e08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e0c:	75 17                	jne    802e25 <insert_sorted_with_merge_freeList+0x432>
  802e0e:	83 ec 04             	sub    $0x4,%esp
  802e11:	68 38 3c 80 00       	push   $0x803c38
  802e16:	68 5f 01 00 00       	push   $0x15f
  802e1b:	68 5b 3c 80 00       	push   $0x803c5b
  802e20:	e8 1a 03 00 00       	call   80313f <_panic>
  802e25:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 0d                	je     802e46 <insert_sorted_with_merge_freeList+0x453>
  802e39:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e41:	89 50 04             	mov    %edx,0x4(%eax)
  802e44:	eb 08                	jmp    802e4e <insert_sorted_with_merge_freeList+0x45b>
  802e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e49:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e51:	a3 48 41 80 00       	mov    %eax,0x804148
  802e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e60:	a1 54 41 80 00       	mov    0x804154,%eax
  802e65:	40                   	inc    %eax
  802e66:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 40 0c             	mov    0xc(%eax),%eax
  802e77:	01 c2                	add    %eax,%edx
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e97:	75 17                	jne    802eb0 <insert_sorted_with_merge_freeList+0x4bd>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 38 3c 80 00       	push   $0x803c38
  802ea1:	68 64 01 00 00       	push   $0x164
  802ea6:	68 5b 3c 80 00       	push   $0x803c5b
  802eab:	e8 8f 02 00 00       	call   80313f <_panic>
  802eb0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 00                	mov    (%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0d                	je     802ed1 <insert_sorted_with_merge_freeList+0x4de>
  802ec4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	89 50 04             	mov    %edx,0x4(%eax)
  802ecf:	eb 08                	jmp    802ed9 <insert_sorted_with_merge_freeList+0x4e6>
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eeb:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef0:	40                   	inc    %eax
  802ef1:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802ef6:	e9 41 02 00 00       	jmp    80313c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	8b 50 08             	mov    0x8(%eax),%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	8b 40 0c             	mov    0xc(%eax),%eax
  802f07:	01 c2                	add    %eax,%edx
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	8b 40 08             	mov    0x8(%eax),%eax
  802f0f:	39 c2                	cmp    %eax,%edx
  802f11:	0f 85 7c 01 00 00    	jne    803093 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802f17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f1b:	74 06                	je     802f23 <insert_sorted_with_merge_freeList+0x530>
  802f1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f21:	75 17                	jne    802f3a <insert_sorted_with_merge_freeList+0x547>
  802f23:	83 ec 04             	sub    $0x4,%esp
  802f26:	68 74 3c 80 00       	push   $0x803c74
  802f2b:	68 69 01 00 00       	push   $0x169
  802f30:	68 5b 3c 80 00       	push   $0x803c5b
  802f35:	e8 05 02 00 00       	call   80313f <_panic>
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	8b 50 04             	mov    0x4(%eax),%edx
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	89 50 04             	mov    %edx,0x4(%eax)
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f4c:	89 10                	mov    %edx,(%eax)
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0d                	je     802f65 <insert_sorted_with_merge_freeList+0x572>
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f61:	89 10                	mov    %edx,(%eax)
  802f63:	eb 08                	jmp    802f6d <insert_sorted_with_merge_freeList+0x57a>
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	a3 38 41 80 00       	mov    %eax,0x804138
  802f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f70:	8b 55 08             	mov    0x8(%ebp),%edx
  802f73:	89 50 04             	mov    %edx,0x4(%eax)
  802f76:	a1 44 41 80 00       	mov    0x804144,%eax
  802f7b:	40                   	inc    %eax
  802f7c:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 50 0c             	mov    0xc(%eax),%edx
  802f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8d:	01 c2                	add    %eax,%edx
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f99:	75 17                	jne    802fb2 <insert_sorted_with_merge_freeList+0x5bf>
  802f9b:	83 ec 04             	sub    $0x4,%esp
  802f9e:	68 04 3d 80 00       	push   $0x803d04
  802fa3:	68 6b 01 00 00       	push   $0x16b
  802fa8:	68 5b 3c 80 00       	push   $0x803c5b
  802fad:	e8 8d 01 00 00       	call   80313f <_panic>
  802fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 10                	je     802fcb <insert_sorted_with_merge_freeList+0x5d8>
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc3:	8b 52 04             	mov    0x4(%edx),%edx
  802fc6:	89 50 04             	mov    %edx,0x4(%eax)
  802fc9:	eb 0b                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x5e3>
  802fcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fce:	8b 40 04             	mov    0x4(%eax),%eax
  802fd1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd9:	8b 40 04             	mov    0x4(%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0f                	je     802fef <insert_sorted_with_merge_freeList+0x5fc>
  802fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe9:	8b 12                	mov    (%edx),%edx
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	eb 0a                	jmp    802ff9 <insert_sorted_with_merge_freeList+0x606>
  802fef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803005:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300c:	a1 44 41 80 00       	mov    0x804144,%eax
  803011:	48                   	dec    %eax
  803012:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80302b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80302f:	75 17                	jne    803048 <insert_sorted_with_merge_freeList+0x655>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 38 3c 80 00       	push   $0x803c38
  803039:	68 6e 01 00 00       	push   $0x16e
  80303e:	68 5b 3c 80 00       	push   $0x803c5b
  803043:	e8 f7 00 00 00       	call   80313f <_panic>
  803048:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 0d                	je     803069 <insert_sorted_with_merge_freeList+0x676>
  80305c:	a1 48 41 80 00       	mov    0x804148,%eax
  803061:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	eb 08                	jmp    803071 <insert_sorted_with_merge_freeList+0x67e>
  803069:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	a3 48 41 80 00       	mov    %eax,0x804148
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803083:	a1 54 41 80 00       	mov    0x804154,%eax
  803088:	40                   	inc    %eax
  803089:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80308e:	e9 a9 00 00 00       	jmp    80313c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803097:	74 06                	je     80309f <insert_sorted_with_merge_freeList+0x6ac>
  803099:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309d:	75 17                	jne    8030b6 <insert_sorted_with_merge_freeList+0x6c3>
  80309f:	83 ec 04             	sub    $0x4,%esp
  8030a2:	68 d0 3c 80 00       	push   $0x803cd0
  8030a7:	68 73 01 00 00       	push   $0x173
  8030ac:	68 5b 3c 80 00       	push   $0x803c5b
  8030b1:	e8 89 00 00 00       	call   80313f <_panic>
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 10                	mov    (%eax),%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0b                	je     8030d4 <insert_sorted_with_merge_freeList+0x6e1>
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030da:	89 10                	mov    %edx,(%eax)
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	75 08                	jne    8030f6 <insert_sorted_with_merge_freeList+0x703>
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030f6:	a1 44 41 80 00       	mov    0x804144,%eax
  8030fb:	40                   	inc    %eax
  8030fc:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803101:	eb 39                	jmp    80313c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803103:	a1 40 41 80 00       	mov    0x804140,%eax
  803108:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80310b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310f:	74 07                	je     803118 <insert_sorted_with_merge_freeList+0x725>
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	eb 05                	jmp    80311d <insert_sorted_with_merge_freeList+0x72a>
  803118:	b8 00 00 00 00       	mov    $0x0,%eax
  80311d:	a3 40 41 80 00       	mov    %eax,0x804140
  803122:	a1 40 41 80 00       	mov    0x804140,%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	0f 85 c7 fb ff ff    	jne    802cf6 <insert_sorted_with_merge_freeList+0x303>
  80312f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803133:	0f 85 bd fb ff ff    	jne    802cf6 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803139:	eb 01                	jmp    80313c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80313b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80313c:	90                   	nop
  80313d:	c9                   	leave  
  80313e:	c3                   	ret    

0080313f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80313f:	55                   	push   %ebp
  803140:	89 e5                	mov    %esp,%ebp
  803142:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803145:	8d 45 10             	lea    0x10(%ebp),%eax
  803148:	83 c0 04             	add    $0x4,%eax
  80314b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80314e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	74 16                	je     80316d <_panic+0x2e>
		cprintf("%s: ", argv0);
  803157:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80315c:	83 ec 08             	sub    $0x8,%esp
  80315f:	50                   	push   %eax
  803160:	68 24 3d 80 00       	push   $0x803d24
  803165:	e8 de d1 ff ff       	call   800348 <cprintf>
  80316a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80316d:	a1 00 40 80 00       	mov    0x804000,%eax
  803172:	ff 75 0c             	pushl  0xc(%ebp)
  803175:	ff 75 08             	pushl  0x8(%ebp)
  803178:	50                   	push   %eax
  803179:	68 29 3d 80 00       	push   $0x803d29
  80317e:	e8 c5 d1 ff ff       	call   800348 <cprintf>
  803183:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803186:	8b 45 10             	mov    0x10(%ebp),%eax
  803189:	83 ec 08             	sub    $0x8,%esp
  80318c:	ff 75 f4             	pushl  -0xc(%ebp)
  80318f:	50                   	push   %eax
  803190:	e8 48 d1 ff ff       	call   8002dd <vcprintf>
  803195:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803198:	83 ec 08             	sub    $0x8,%esp
  80319b:	6a 00                	push   $0x0
  80319d:	68 45 3d 80 00       	push   $0x803d45
  8031a2:	e8 36 d1 ff ff       	call   8002dd <vcprintf>
  8031a7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8031aa:	e8 b7 d0 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  8031af:	eb fe                	jmp    8031af <_panic+0x70>

008031b1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8031b1:	55                   	push   %ebp
  8031b2:	89 e5                	mov    %esp,%ebp
  8031b4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8031b7:	a1 20 40 80 00       	mov    0x804020,%eax
  8031bc:	8b 50 74             	mov    0x74(%eax),%edx
  8031bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c2:	39 c2                	cmp    %eax,%edx
  8031c4:	74 14                	je     8031da <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8031c6:	83 ec 04             	sub    $0x4,%esp
  8031c9:	68 48 3d 80 00       	push   $0x803d48
  8031ce:	6a 26                	push   $0x26
  8031d0:	68 94 3d 80 00       	push   $0x803d94
  8031d5:	e8 65 ff ff ff       	call   80313f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8031da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8031e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031e8:	e9 c2 00 00 00       	jmp    8032af <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	01 d0                	add    %edx,%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	75 08                	jne    80320a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803202:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803205:	e9 a2 00 00 00       	jmp    8032ac <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80320a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803211:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803218:	eb 69                	jmp    803283 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80321a:	a1 20 40 80 00       	mov    0x804020,%eax
  80321f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803225:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803228:	89 d0                	mov    %edx,%eax
  80322a:	01 c0                	add    %eax,%eax
  80322c:	01 d0                	add    %edx,%eax
  80322e:	c1 e0 03             	shl    $0x3,%eax
  803231:	01 c8                	add    %ecx,%eax
  803233:	8a 40 04             	mov    0x4(%eax),%al
  803236:	84 c0                	test   %al,%al
  803238:	75 46                	jne    803280 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80323a:	a1 20 40 80 00       	mov    0x804020,%eax
  80323f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803245:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803248:	89 d0                	mov    %edx,%eax
  80324a:	01 c0                	add    %eax,%eax
  80324c:	01 d0                	add    %edx,%eax
  80324e:	c1 e0 03             	shl    $0x3,%eax
  803251:	01 c8                	add    %ecx,%eax
  803253:	8b 00                	mov    (%eax),%eax
  803255:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803258:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80325b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803260:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803265:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	01 c8                	add    %ecx,%eax
  803271:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803273:	39 c2                	cmp    %eax,%edx
  803275:	75 09                	jne    803280 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803277:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80327e:	eb 12                	jmp    803292 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803280:	ff 45 e8             	incl   -0x18(%ebp)
  803283:	a1 20 40 80 00       	mov    0x804020,%eax
  803288:	8b 50 74             	mov    0x74(%eax),%edx
  80328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328e:	39 c2                	cmp    %eax,%edx
  803290:	77 88                	ja     80321a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803292:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803296:	75 14                	jne    8032ac <CheckWSWithoutLastIndex+0xfb>
			panic(
  803298:	83 ec 04             	sub    $0x4,%esp
  80329b:	68 a0 3d 80 00       	push   $0x803da0
  8032a0:	6a 3a                	push   $0x3a
  8032a2:	68 94 3d 80 00       	push   $0x803d94
  8032a7:	e8 93 fe ff ff       	call   80313f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8032ac:	ff 45 f0             	incl   -0x10(%ebp)
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032b5:	0f 8c 32 ff ff ff    	jl     8031ed <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8032bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032c9:	eb 26                	jmp    8032f1 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8032cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8032d0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032d9:	89 d0                	mov    %edx,%eax
  8032db:	01 c0                	add    %eax,%eax
  8032dd:	01 d0                	add    %edx,%eax
  8032df:	c1 e0 03             	shl    $0x3,%eax
  8032e2:	01 c8                	add    %ecx,%eax
  8032e4:	8a 40 04             	mov    0x4(%eax),%al
  8032e7:	3c 01                	cmp    $0x1,%al
  8032e9:	75 03                	jne    8032ee <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8032eb:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032ee:	ff 45 e0             	incl   -0x20(%ebp)
  8032f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8032f6:	8b 50 74             	mov    0x74(%eax),%edx
  8032f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032fc:	39 c2                	cmp    %eax,%edx
  8032fe:	77 cb                	ja     8032cb <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803303:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803306:	74 14                	je     80331c <CheckWSWithoutLastIndex+0x16b>
		panic(
  803308:	83 ec 04             	sub    $0x4,%esp
  80330b:	68 f4 3d 80 00       	push   $0x803df4
  803310:	6a 44                	push   $0x44
  803312:	68 94 3d 80 00       	push   $0x803d94
  803317:	e8 23 fe ff ff       	call   80313f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80331c:	90                   	nop
  80331d:	c9                   	leave  
  80331e:	c3                   	ret    
  80331f:	90                   	nop

00803320 <__udivdi3>:
  803320:	55                   	push   %ebp
  803321:	57                   	push   %edi
  803322:	56                   	push   %esi
  803323:	53                   	push   %ebx
  803324:	83 ec 1c             	sub    $0x1c,%esp
  803327:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80332b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80332f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803333:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803337:	89 ca                	mov    %ecx,%edx
  803339:	89 f8                	mov    %edi,%eax
  80333b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80333f:	85 f6                	test   %esi,%esi
  803341:	75 2d                	jne    803370 <__udivdi3+0x50>
  803343:	39 cf                	cmp    %ecx,%edi
  803345:	77 65                	ja     8033ac <__udivdi3+0x8c>
  803347:	89 fd                	mov    %edi,%ebp
  803349:	85 ff                	test   %edi,%edi
  80334b:	75 0b                	jne    803358 <__udivdi3+0x38>
  80334d:	b8 01 00 00 00       	mov    $0x1,%eax
  803352:	31 d2                	xor    %edx,%edx
  803354:	f7 f7                	div    %edi
  803356:	89 c5                	mov    %eax,%ebp
  803358:	31 d2                	xor    %edx,%edx
  80335a:	89 c8                	mov    %ecx,%eax
  80335c:	f7 f5                	div    %ebp
  80335e:	89 c1                	mov    %eax,%ecx
  803360:	89 d8                	mov    %ebx,%eax
  803362:	f7 f5                	div    %ebp
  803364:	89 cf                	mov    %ecx,%edi
  803366:	89 fa                	mov    %edi,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	39 ce                	cmp    %ecx,%esi
  803372:	77 28                	ja     80339c <__udivdi3+0x7c>
  803374:	0f bd fe             	bsr    %esi,%edi
  803377:	83 f7 1f             	xor    $0x1f,%edi
  80337a:	75 40                	jne    8033bc <__udivdi3+0x9c>
  80337c:	39 ce                	cmp    %ecx,%esi
  80337e:	72 0a                	jb     80338a <__udivdi3+0x6a>
  803380:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803384:	0f 87 9e 00 00 00    	ja     803428 <__udivdi3+0x108>
  80338a:	b8 01 00 00 00       	mov    $0x1,%eax
  80338f:	89 fa                	mov    %edi,%edx
  803391:	83 c4 1c             	add    $0x1c,%esp
  803394:	5b                   	pop    %ebx
  803395:	5e                   	pop    %esi
  803396:	5f                   	pop    %edi
  803397:	5d                   	pop    %ebp
  803398:	c3                   	ret    
  803399:	8d 76 00             	lea    0x0(%esi),%esi
  80339c:	31 ff                	xor    %edi,%edi
  80339e:	31 c0                	xor    %eax,%eax
  8033a0:	89 fa                	mov    %edi,%edx
  8033a2:	83 c4 1c             	add    $0x1c,%esp
  8033a5:	5b                   	pop    %ebx
  8033a6:	5e                   	pop    %esi
  8033a7:	5f                   	pop    %edi
  8033a8:	5d                   	pop    %ebp
  8033a9:	c3                   	ret    
  8033aa:	66 90                	xchg   %ax,%ax
  8033ac:	89 d8                	mov    %ebx,%eax
  8033ae:	f7 f7                	div    %edi
  8033b0:	31 ff                	xor    %edi,%edi
  8033b2:	89 fa                	mov    %edi,%edx
  8033b4:	83 c4 1c             	add    $0x1c,%esp
  8033b7:	5b                   	pop    %ebx
  8033b8:	5e                   	pop    %esi
  8033b9:	5f                   	pop    %edi
  8033ba:	5d                   	pop    %ebp
  8033bb:	c3                   	ret    
  8033bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033c1:	89 eb                	mov    %ebp,%ebx
  8033c3:	29 fb                	sub    %edi,%ebx
  8033c5:	89 f9                	mov    %edi,%ecx
  8033c7:	d3 e6                	shl    %cl,%esi
  8033c9:	89 c5                	mov    %eax,%ebp
  8033cb:	88 d9                	mov    %bl,%cl
  8033cd:	d3 ed                	shr    %cl,%ebp
  8033cf:	89 e9                	mov    %ebp,%ecx
  8033d1:	09 f1                	or     %esi,%ecx
  8033d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033d7:	89 f9                	mov    %edi,%ecx
  8033d9:	d3 e0                	shl    %cl,%eax
  8033db:	89 c5                	mov    %eax,%ebp
  8033dd:	89 d6                	mov    %edx,%esi
  8033df:	88 d9                	mov    %bl,%cl
  8033e1:	d3 ee                	shr    %cl,%esi
  8033e3:	89 f9                	mov    %edi,%ecx
  8033e5:	d3 e2                	shl    %cl,%edx
  8033e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033eb:	88 d9                	mov    %bl,%cl
  8033ed:	d3 e8                	shr    %cl,%eax
  8033ef:	09 c2                	or     %eax,%edx
  8033f1:	89 d0                	mov    %edx,%eax
  8033f3:	89 f2                	mov    %esi,%edx
  8033f5:	f7 74 24 0c          	divl   0xc(%esp)
  8033f9:	89 d6                	mov    %edx,%esi
  8033fb:	89 c3                	mov    %eax,%ebx
  8033fd:	f7 e5                	mul    %ebp
  8033ff:	39 d6                	cmp    %edx,%esi
  803401:	72 19                	jb     80341c <__udivdi3+0xfc>
  803403:	74 0b                	je     803410 <__udivdi3+0xf0>
  803405:	89 d8                	mov    %ebx,%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 58 ff ff ff       	jmp    803366 <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	8b 54 24 08          	mov    0x8(%esp),%edx
  803414:	89 f9                	mov    %edi,%ecx
  803416:	d3 e2                	shl    %cl,%edx
  803418:	39 c2                	cmp    %eax,%edx
  80341a:	73 e9                	jae    803405 <__udivdi3+0xe5>
  80341c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80341f:	31 ff                	xor    %edi,%edi
  803421:	e9 40 ff ff ff       	jmp    803366 <__udivdi3+0x46>
  803426:	66 90                	xchg   %ax,%ax
  803428:	31 c0                	xor    %eax,%eax
  80342a:	e9 37 ff ff ff       	jmp    803366 <__udivdi3+0x46>
  80342f:	90                   	nop

00803430 <__umoddi3>:
  803430:	55                   	push   %ebp
  803431:	57                   	push   %edi
  803432:	56                   	push   %esi
  803433:	53                   	push   %ebx
  803434:	83 ec 1c             	sub    $0x1c,%esp
  803437:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80343b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80343f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803443:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80344b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80344f:	89 f3                	mov    %esi,%ebx
  803451:	89 fa                	mov    %edi,%edx
  803453:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803457:	89 34 24             	mov    %esi,(%esp)
  80345a:	85 c0                	test   %eax,%eax
  80345c:	75 1a                	jne    803478 <__umoddi3+0x48>
  80345e:	39 f7                	cmp    %esi,%edi
  803460:	0f 86 a2 00 00 00    	jbe    803508 <__umoddi3+0xd8>
  803466:	89 c8                	mov    %ecx,%eax
  803468:	89 f2                	mov    %esi,%edx
  80346a:	f7 f7                	div    %edi
  80346c:	89 d0                	mov    %edx,%eax
  80346e:	31 d2                	xor    %edx,%edx
  803470:	83 c4 1c             	add    $0x1c,%esp
  803473:	5b                   	pop    %ebx
  803474:	5e                   	pop    %esi
  803475:	5f                   	pop    %edi
  803476:	5d                   	pop    %ebp
  803477:	c3                   	ret    
  803478:	39 f0                	cmp    %esi,%eax
  80347a:	0f 87 ac 00 00 00    	ja     80352c <__umoddi3+0xfc>
  803480:	0f bd e8             	bsr    %eax,%ebp
  803483:	83 f5 1f             	xor    $0x1f,%ebp
  803486:	0f 84 ac 00 00 00    	je     803538 <__umoddi3+0x108>
  80348c:	bf 20 00 00 00       	mov    $0x20,%edi
  803491:	29 ef                	sub    %ebp,%edi
  803493:	89 fe                	mov    %edi,%esi
  803495:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803499:	89 e9                	mov    %ebp,%ecx
  80349b:	d3 e0                	shl    %cl,%eax
  80349d:	89 d7                	mov    %edx,%edi
  80349f:	89 f1                	mov    %esi,%ecx
  8034a1:	d3 ef                	shr    %cl,%edi
  8034a3:	09 c7                	or     %eax,%edi
  8034a5:	89 e9                	mov    %ebp,%ecx
  8034a7:	d3 e2                	shl    %cl,%edx
  8034a9:	89 14 24             	mov    %edx,(%esp)
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	d3 e0                	shl    %cl,%eax
  8034b0:	89 c2                	mov    %eax,%edx
  8034b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b6:	d3 e0                	shl    %cl,%eax
  8034b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c0:	89 f1                	mov    %esi,%ecx
  8034c2:	d3 e8                	shr    %cl,%eax
  8034c4:	09 d0                	or     %edx,%eax
  8034c6:	d3 eb                	shr    %cl,%ebx
  8034c8:	89 da                	mov    %ebx,%edx
  8034ca:	f7 f7                	div    %edi
  8034cc:	89 d3                	mov    %edx,%ebx
  8034ce:	f7 24 24             	mull   (%esp)
  8034d1:	89 c6                	mov    %eax,%esi
  8034d3:	89 d1                	mov    %edx,%ecx
  8034d5:	39 d3                	cmp    %edx,%ebx
  8034d7:	0f 82 87 00 00 00    	jb     803564 <__umoddi3+0x134>
  8034dd:	0f 84 91 00 00 00    	je     803574 <__umoddi3+0x144>
  8034e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034e7:	29 f2                	sub    %esi,%edx
  8034e9:	19 cb                	sbb    %ecx,%ebx
  8034eb:	89 d8                	mov    %ebx,%eax
  8034ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034f1:	d3 e0                	shl    %cl,%eax
  8034f3:	89 e9                	mov    %ebp,%ecx
  8034f5:	d3 ea                	shr    %cl,%edx
  8034f7:	09 d0                	or     %edx,%eax
  8034f9:	89 e9                	mov    %ebp,%ecx
  8034fb:	d3 eb                	shr    %cl,%ebx
  8034fd:	89 da                	mov    %ebx,%edx
  8034ff:	83 c4 1c             	add    $0x1c,%esp
  803502:	5b                   	pop    %ebx
  803503:	5e                   	pop    %esi
  803504:	5f                   	pop    %edi
  803505:	5d                   	pop    %ebp
  803506:	c3                   	ret    
  803507:	90                   	nop
  803508:	89 fd                	mov    %edi,%ebp
  80350a:	85 ff                	test   %edi,%edi
  80350c:	75 0b                	jne    803519 <__umoddi3+0xe9>
  80350e:	b8 01 00 00 00       	mov    $0x1,%eax
  803513:	31 d2                	xor    %edx,%edx
  803515:	f7 f7                	div    %edi
  803517:	89 c5                	mov    %eax,%ebp
  803519:	89 f0                	mov    %esi,%eax
  80351b:	31 d2                	xor    %edx,%edx
  80351d:	f7 f5                	div    %ebp
  80351f:	89 c8                	mov    %ecx,%eax
  803521:	f7 f5                	div    %ebp
  803523:	89 d0                	mov    %edx,%eax
  803525:	e9 44 ff ff ff       	jmp    80346e <__umoddi3+0x3e>
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	89 c8                	mov    %ecx,%eax
  80352e:	89 f2                	mov    %esi,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	3b 04 24             	cmp    (%esp),%eax
  80353b:	72 06                	jb     803543 <__umoddi3+0x113>
  80353d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803541:	77 0f                	ja     803552 <__umoddi3+0x122>
  803543:	89 f2                	mov    %esi,%edx
  803545:	29 f9                	sub    %edi,%ecx
  803547:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80354b:	89 14 24             	mov    %edx,(%esp)
  80354e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803552:	8b 44 24 04          	mov    0x4(%esp),%eax
  803556:	8b 14 24             	mov    (%esp),%edx
  803559:	83 c4 1c             	add    $0x1c,%esp
  80355c:	5b                   	pop    %ebx
  80355d:	5e                   	pop    %esi
  80355e:	5f                   	pop    %edi
  80355f:	5d                   	pop    %ebp
  803560:	c3                   	ret    
  803561:	8d 76 00             	lea    0x0(%esi),%esi
  803564:	2b 04 24             	sub    (%esp),%eax
  803567:	19 fa                	sbb    %edi,%edx
  803569:	89 d1                	mov    %edx,%ecx
  80356b:	89 c6                	mov    %eax,%esi
  80356d:	e9 71 ff ff ff       	jmp    8034e3 <__umoddi3+0xb3>
  803572:	66 90                	xchg   %ax,%ax
  803574:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803578:	72 ea                	jb     803564 <__umoddi3+0x134>
  80357a:	89 d9                	mov    %ebx,%ecx
  80357c:	e9 62 ff ff ff       	jmp    8034e3 <__umoddi3+0xb3>
