
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
  80005c:	68 00 35 80 00       	push   $0x803500
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
  8000b9:	68 13 35 80 00       	push   $0x803513
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
  80010f:	68 13 35 80 00       	push   $0x803513
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
  80013e:	e8 8d 16 00 00       	call   8017d0 <sys_getenvindex>
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
  8001a9:	e8 2f 14 00 00       	call   8015dd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 38 35 80 00       	push   $0x803538
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
  8001d9:	68 60 35 80 00       	push   $0x803560
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
  80020a:	68 88 35 80 00       	push   $0x803588
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 e0 35 80 00       	push   $0x8035e0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 38 35 80 00       	push   $0x803538
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 af 13 00 00       	call   8015f7 <sys_enable_interrupt>

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
  80025b:	e8 3c 15 00 00       	call   80179c <sys_destroy_env>
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
  80026c:	e8 91 15 00 00       	call   801802 <sys_exit_env>
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
  8002ba:	e8 70 11 00 00       	call   80142f <sys_cputs>
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
  800331:	e8 f9 10 00 00       	call   80142f <sys_cputs>
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
  80037b:	e8 5d 12 00 00       	call   8015dd <sys_disable_interrupt>
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
  80039b:	e8 57 12 00 00       	call   8015f7 <sys_enable_interrupt>
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
  8003e5:	e8 aa 2e 00 00       	call   803294 <__udivdi3>
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
  800435:	e8 6a 2f 00 00       	call   8033a4 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 14 38 80 00       	add    $0x803814,%eax
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
  800590:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
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
  800671:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 25 38 80 00       	push   $0x803825
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
  800696:	68 2e 38 80 00       	push   $0x80382e
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
  8006c3:	be 31 38 80 00       	mov    $0x803831,%esi
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
  8010e9:	68 90 39 80 00       	push   $0x803990
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  80119c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8011a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ab:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011b0:	83 ec 04             	sub    $0x4,%esp
  8011b3:	6a 03                	push   $0x3
  8011b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8011b8:	50                   	push   %eax
  8011b9:	e8 b5 03 00 00       	call   801573 <sys_allocate_chunk>
  8011be:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c1:	a1 20 41 80 00       	mov    0x804120,%eax
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 2a 0a 00 00       	call   801bf9 <initialize_MemBlocksList>
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
  8011f7:	68 b5 39 80 00       	push   $0x8039b5
  8011fc:	6a 33                	push   $0x33
  8011fe:	68 d3 39 80 00       	push   $0x8039d3
  801203:	e8 aa 1e 00 00       	call   8030b2 <_panic>
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
  801276:	68 e0 39 80 00       	push   $0x8039e0
  80127b:	6a 34                	push   $0x34
  80127d:	68 d3 39 80 00       	push   $0x8039d3
  801282:	e8 2b 1e 00 00       	call   8030b2 <_panic>
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
  8012eb:	68 04 3a 80 00       	push   $0x803a04
  8012f0:	6a 46                	push   $0x46
  8012f2:	68 d3 39 80 00       	push   $0x8039d3
  8012f7:	e8 b6 1d 00 00       	call   8030b2 <_panic>
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
  801307:	68 2c 3a 80 00       	push   $0x803a2c
  80130c:	6a 61                	push   $0x61
  80130e:	68 d3 39 80 00       	push   $0x8039d3
  801313:	e8 9a 1d 00 00       	call   8030b2 <_panic>

00801318 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 18             	sub    $0x18,%esp
  80131e:	8b 45 10             	mov    0x10(%ebp),%eax
  801321:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801324:	e8 a9 fd ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  801329:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80132d:	75 07                	jne    801336 <smalloc+0x1e>
  80132f:	b8 00 00 00 00       	mov    $0x0,%eax
  801334:	eb 14                	jmp    80134a <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	68 50 3a 80 00       	push   $0x803a50
  80133e:	6a 76                	push   $0x76
  801340:	68 d3 39 80 00       	push   $0x8039d3
  801345:	e8 68 1d 00 00       	call   8030b2 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80134a:	c9                   	leave  
  80134b:	c3                   	ret    

0080134c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801352:	e8 7b fd ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801357:	83 ec 04             	sub    $0x4,%esp
  80135a:	68 78 3a 80 00       	push   $0x803a78
  80135f:	68 93 00 00 00       	push   $0x93
  801364:	68 d3 39 80 00       	push   $0x8039d3
  801369:	e8 44 1d 00 00       	call   8030b2 <_panic>

0080136e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801374:	e8 59 fd ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801379:	83 ec 04             	sub    $0x4,%esp
  80137c:	68 9c 3a 80 00       	push   $0x803a9c
  801381:	68 c5 00 00 00       	push   $0xc5
  801386:	68 d3 39 80 00       	push   $0x8039d3
  80138b:	e8 22 1d 00 00       	call   8030b2 <_panic>

00801390 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	68 c4 3a 80 00       	push   $0x803ac4
  80139e:	68 d9 00 00 00       	push   $0xd9
  8013a3:	68 d3 39 80 00       	push   $0x8039d3
  8013a8:	e8 05 1d 00 00       	call   8030b2 <_panic>

008013ad <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	68 e8 3a 80 00       	push   $0x803ae8
  8013bb:	68 e4 00 00 00       	push   $0xe4
  8013c0:	68 d3 39 80 00       	push   $0x8039d3
  8013c5:	e8 e8 1c 00 00       	call   8030b2 <_panic>

008013ca <shrink>:

}
void shrink(uint32 newSize)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013d0:	83 ec 04             	sub    $0x4,%esp
  8013d3:	68 e8 3a 80 00       	push   $0x803ae8
  8013d8:	68 e9 00 00 00       	push   $0xe9
  8013dd:	68 d3 39 80 00       	push   $0x8039d3
  8013e2:	e8 cb 1c 00 00       	call   8030b2 <_panic>

008013e7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	68 e8 3a 80 00       	push   $0x803ae8
  8013f5:	68 ee 00 00 00       	push   $0xee
  8013fa:	68 d3 39 80 00       	push   $0x8039d3
  8013ff:	e8 ae 1c 00 00       	call   8030b2 <_panic>

00801404 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	57                   	push   %edi
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
  80140a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140d:	8b 45 08             	mov    0x8(%ebp),%eax
  801410:	8b 55 0c             	mov    0xc(%ebp),%edx
  801413:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801416:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801419:	8b 7d 18             	mov    0x18(%ebp),%edi
  80141c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80141f:	cd 30                	int    $0x30
  801421:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801427:	83 c4 10             	add    $0x10,%esp
  80142a:	5b                   	pop    %ebx
  80142b:	5e                   	pop    %esi
  80142c:	5f                   	pop    %edi
  80142d:	5d                   	pop    %ebp
  80142e:	c3                   	ret    

0080142f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 04             	sub    $0x4,%esp
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80143b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	52                   	push   %edx
  801447:	ff 75 0c             	pushl  0xc(%ebp)
  80144a:	50                   	push   %eax
  80144b:	6a 00                	push   $0x0
  80144d:	e8 b2 ff ff ff       	call   801404 <syscall>
  801452:	83 c4 18             	add    $0x18,%esp
}
  801455:	90                   	nop
  801456:	c9                   	leave  
  801457:	c3                   	ret    

00801458 <sys_cgetc>:

int
sys_cgetc(void)
{
  801458:	55                   	push   %ebp
  801459:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 00                	push   $0x0
  801463:	6a 00                	push   $0x0
  801465:	6a 01                	push   $0x1
  801467:	e8 98 ff ff ff       	call   801404 <syscall>
  80146c:	83 c4 18             	add    $0x18,%esp
}
  80146f:	c9                   	leave  
  801470:	c3                   	ret    

00801471 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801471:	55                   	push   %ebp
  801472:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	52                   	push   %edx
  801481:	50                   	push   %eax
  801482:	6a 05                	push   $0x5
  801484:	e8 7b ff ff ff       	call   801404 <syscall>
  801489:	83 c4 18             	add    $0x18,%esp
}
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	56                   	push   %esi
  801492:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801493:	8b 75 18             	mov    0x18(%ebp),%esi
  801496:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801499:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80149c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
  8014a4:	51                   	push   %ecx
  8014a5:	52                   	push   %edx
  8014a6:	50                   	push   %eax
  8014a7:	6a 06                	push   $0x6
  8014a9:	e8 56 ff ff ff       	call   801404 <syscall>
  8014ae:	83 c4 18             	add    $0x18,%esp
}
  8014b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014b4:	5b                   	pop    %ebx
  8014b5:	5e                   	pop    %esi
  8014b6:	5d                   	pop    %ebp
  8014b7:	c3                   	ret    

008014b8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	52                   	push   %edx
  8014c8:	50                   	push   %eax
  8014c9:	6a 07                	push   $0x7
  8014cb:	e8 34 ff ff ff       	call   801404 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	ff 75 08             	pushl  0x8(%ebp)
  8014e4:	6a 08                	push   $0x8
  8014e6:	e8 19 ff ff ff       	call   801404 <syscall>
  8014eb:	83 c4 18             	add    $0x18,%esp
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 09                	push   $0x9
  8014ff:	e8 00 ff ff ff       	call   801404 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 0a                	push   $0xa
  801518:	e8 e7 fe ff ff       	call   801404 <syscall>
  80151d:	83 c4 18             	add    $0x18,%esp
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	6a 0b                	push   $0xb
  801531:	e8 ce fe ff ff       	call   801404 <syscall>
  801536:	83 c4 18             	add    $0x18,%esp
}
  801539:	c9                   	leave  
  80153a:	c3                   	ret    

0080153b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	ff 75 0c             	pushl  0xc(%ebp)
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	6a 0f                	push   $0xf
  80154c:	e8 b3 fe ff ff       	call   801404 <syscall>
  801551:	83 c4 18             	add    $0x18,%esp
	return;
  801554:	90                   	nop
}
  801555:	c9                   	leave  
  801556:	c3                   	ret    

00801557 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 00                	push   $0x0
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	ff 75 08             	pushl  0x8(%ebp)
  801566:	6a 10                	push   $0x10
  801568:	e8 97 fe ff ff       	call   801404 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
	return ;
  801570:	90                   	nop
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	6a 11                	push   $0x11
  801585:	e8 7a fe ff ff       	call   801404 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
	return ;
  80158d:	90                   	nop
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 0c                	push   $0xc
  80159f:	e8 60 fe ff ff       	call   801404 <syscall>
  8015a4:	83 c4 18             	add    $0x18,%esp
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015ac:	6a 00                	push   $0x0
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	ff 75 08             	pushl  0x8(%ebp)
  8015b7:	6a 0d                	push   $0xd
  8015b9:	e8 46 fe ff ff       	call   801404 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 0e                	push   $0xe
  8015d2:	e8 2d fe ff ff       	call   801404 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 13                	push   $0x13
  8015ec:	e8 13 fe ff ff       	call   801404 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	90                   	nop
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 14                	push   $0x14
  801606:	e8 f9 fd ff ff       	call   801404 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
}
  80160e:	90                   	nop
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_cputc>:


void
sys_cputc(const char c)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
  801614:	83 ec 04             	sub    $0x4,%esp
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
  80161a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80161d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	50                   	push   %eax
  80162a:	6a 15                	push   $0x15
  80162c:	e8 d3 fd ff ff       	call   801404 <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
}
  801634:	90                   	nop
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 16                	push   $0x16
  801646:	e8 b9 fd ff ff       	call   801404 <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	90                   	nop
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	50                   	push   %eax
  801661:	6a 17                	push   $0x17
  801663:	e8 9c fd ff ff       	call   801404 <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801670:	8b 55 0c             	mov    0xc(%ebp),%edx
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	52                   	push   %edx
  80167d:	50                   	push   %eax
  80167e:	6a 1a                	push   $0x1a
  801680:	e8 7f fd ff ff       	call   801404 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80168d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	52                   	push   %edx
  80169a:	50                   	push   %eax
  80169b:	6a 18                	push   $0x18
  80169d:	e8 62 fd ff ff       	call   801404 <syscall>
  8016a2:	83 c4 18             	add    $0x18,%esp
}
  8016a5:	90                   	nop
  8016a6:	c9                   	leave  
  8016a7:	c3                   	ret    

008016a8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016a8:	55                   	push   %ebp
  8016a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	52                   	push   %edx
  8016b8:	50                   	push   %eax
  8016b9:	6a 19                	push   $0x19
  8016bb:	e8 44 fd ff ff       	call   801404 <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	90                   	nop
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 04             	sub    $0x4,%esp
  8016cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016d5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dc:	6a 00                	push   $0x0
  8016de:	51                   	push   %ecx
  8016df:	52                   	push   %edx
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	50                   	push   %eax
  8016e4:	6a 1b                	push   $0x1b
  8016e6:	e8 19 fd ff ff       	call   801404 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8016f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	52                   	push   %edx
  801700:	50                   	push   %eax
  801701:	6a 1c                	push   $0x1c
  801703:	e8 fc fc ff ff       	call   801404 <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801710:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	51                   	push   %ecx
  80171e:	52                   	push   %edx
  80171f:	50                   	push   %eax
  801720:	6a 1d                	push   $0x1d
  801722:	e8 dd fc ff ff       	call   801404 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	c9                   	leave  
  80172b:	c3                   	ret    

0080172c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80172f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	52                   	push   %edx
  80173c:	50                   	push   %eax
  80173d:	6a 1e                	push   $0x1e
  80173f:	e8 c0 fc ff ff       	call   801404 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80174c:	6a 00                	push   $0x0
  80174e:	6a 00                	push   $0x0
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 1f                	push   $0x1f
  801758:	e8 a7 fc ff ff       	call   801404 <syscall>
  80175d:	83 c4 18             	add    $0x18,%esp
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801765:	8b 45 08             	mov    0x8(%ebp),%eax
  801768:	6a 00                	push   $0x0
  80176a:	ff 75 14             	pushl  0x14(%ebp)
  80176d:	ff 75 10             	pushl  0x10(%ebp)
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	50                   	push   %eax
  801774:	6a 20                	push   $0x20
  801776:	e8 89 fc ff ff       	call   801404 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	6a 00                	push   $0x0
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	50                   	push   %eax
  80178f:	6a 21                	push   $0x21
  801791:	e8 6e fc ff ff       	call   801404 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	90                   	nop
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80179f:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	50                   	push   %eax
  8017ab:	6a 22                	push   $0x22
  8017ad:	e8 52 fc ff ff       	call   801404 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 02                	push   $0x2
  8017c6:	e8 39 fc ff ff       	call   801404 <syscall>
  8017cb:	83 c4 18             	add    $0x18,%esp
}
  8017ce:	c9                   	leave  
  8017cf:	c3                   	ret    

008017d0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 03                	push   $0x3
  8017df:	e8 20 fc ff ff       	call   801404 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 04                	push   $0x4
  8017f8:	e8 07 fc ff ff       	call   801404 <syscall>
  8017fd:	83 c4 18             	add    $0x18,%esp
}
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <sys_exit_env>:


void sys_exit_env(void)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 23                	push   $0x23
  801811:	e8 ee fb ff ff       	call   801404 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	90                   	nop
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801822:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801825:	8d 50 04             	lea    0x4(%eax),%edx
  801828:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	52                   	push   %edx
  801832:	50                   	push   %eax
  801833:	6a 24                	push   $0x24
  801835:	e8 ca fb ff ff       	call   801404 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
	return result;
  80183d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801840:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801843:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801846:	89 01                	mov    %eax,(%ecx)
  801848:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	c9                   	leave  
  80184f:	c2 04 00             	ret    $0x4

00801852 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	ff 75 10             	pushl  0x10(%ebp)
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	6a 12                	push   $0x12
  801864:	e8 9b fb ff ff       	call   801404 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
	return ;
  80186c:	90                   	nop
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_rcr2>:
uint32 sys_rcr2()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 25                	push   $0x25
  80187e:	e8 81 fb ff ff       	call   801404 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801894:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	50                   	push   %eax
  8018a1:	6a 26                	push   $0x26
  8018a3:	e8 5c fb ff ff       	call   801404 <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ab:	90                   	nop
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <rsttst>:
void rsttst()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 28                	push   $0x28
  8018bd:	e8 42 fb ff ff       	call   801404 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c5:	90                   	nop
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 04             	sub    $0x4,%esp
  8018ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018d4:	8b 55 18             	mov    0x18(%ebp),%edx
  8018d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018db:	52                   	push   %edx
  8018dc:	50                   	push   %eax
  8018dd:	ff 75 10             	pushl  0x10(%ebp)
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	ff 75 08             	pushl  0x8(%ebp)
  8018e6:	6a 27                	push   $0x27
  8018e8:	e8 17 fb ff ff       	call   801404 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <chktst>:
void chktst(uint32 n)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 29                	push   $0x29
  801903:	e8 fc fa ff ff       	call   801404 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
	return ;
  80190b:	90                   	nop
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <inctst>:

void inctst()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 2a                	push   $0x2a
  80191d:	e8 e2 fa ff ff       	call   801404 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
	return ;
  801925:	90                   	nop
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <gettst>:
uint32 gettst()
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 2b                	push   $0x2b
  801937:	e8 c8 fa ff ff       	call   801404 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 2c                	push   $0x2c
  801953:	e8 ac fa ff ff       	call   801404 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
  80195b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80195e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801962:	75 07                	jne    80196b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801964:	b8 01 00 00 00       	mov    $0x1,%eax
  801969:	eb 05                	jmp    801970 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
  801975:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 2c                	push   $0x2c
  801984:	e8 7b fa ff ff       	call   801404 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
  80198c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80198f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801993:	75 07                	jne    80199c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801995:	b8 01 00 00 00       	mov    $0x1,%eax
  80199a:	eb 05                	jmp    8019a1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
  8019a6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 2c                	push   $0x2c
  8019b5:	e8 4a fa ff ff       	call   801404 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
  8019bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019c0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019c4:	75 07                	jne    8019cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8019cb:	eb 05                	jmp    8019d2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 2c                	push   $0x2c
  8019e6:	e8 19 fa ff ff       	call   801404 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
  8019ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8019f1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8019f5:	75 07                	jne    8019fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8019f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fc:	eb 05                	jmp    801a03 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8019fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 2d                	push   $0x2d
  801a15:	e8 ea f9 ff ff       	call   801404 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a24:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a27:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	53                   	push   %ebx
  801a33:	51                   	push   %ecx
  801a34:	52                   	push   %edx
  801a35:	50                   	push   %eax
  801a36:	6a 2e                	push   $0x2e
  801a38:	e8 c7 f9 ff ff       	call   801404 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	6a 2f                	push   $0x2f
  801a58:	e8 a7 f9 ff ff       	call   801404 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801a68:	83 ec 0c             	sub    $0xc,%esp
  801a6b:	68 f8 3a 80 00       	push   $0x803af8
  801a70:	e8 d3 e8 ff ff       	call   800348 <cprintf>
  801a75:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801a78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801a7f:	83 ec 0c             	sub    $0xc,%esp
  801a82:	68 24 3b 80 00       	push   $0x803b24
  801a87:	e8 bc e8 ff ff       	call   800348 <cprintf>
  801a8c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801a8f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801a93:	a1 38 41 80 00       	mov    0x804138,%eax
  801a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801a9b:	eb 56                	jmp    801af3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801a9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801aa1:	74 1c                	je     801abf <print_mem_block_lists+0x5d>
  801aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa6:	8b 50 08             	mov    0x8(%eax),%edx
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	8b 48 08             	mov    0x8(%eax),%ecx
  801aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ab5:	01 c8                	add    %ecx,%eax
  801ab7:	39 c2                	cmp    %eax,%edx
  801ab9:	73 04                	jae    801abf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801abb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac2:	8b 50 08             	mov    0x8(%eax),%edx
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  801acb:	01 c2                	add    %eax,%edx
  801acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad0:	8b 40 08             	mov    0x8(%eax),%eax
  801ad3:	83 ec 04             	sub    $0x4,%esp
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	68 39 3b 80 00       	push   $0x803b39
  801add:	e8 66 e8 ff ff       	call   800348 <cprintf>
  801ae2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801aeb:	a1 40 41 80 00       	mov    0x804140,%eax
  801af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801af7:	74 07                	je     801b00 <print_mem_block_lists+0x9e>
  801af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afc:	8b 00                	mov    (%eax),%eax
  801afe:	eb 05                	jmp    801b05 <print_mem_block_lists+0xa3>
  801b00:	b8 00 00 00 00       	mov    $0x0,%eax
  801b05:	a3 40 41 80 00       	mov    %eax,0x804140
  801b0a:	a1 40 41 80 00       	mov    0x804140,%eax
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	75 8a                	jne    801a9d <print_mem_block_lists+0x3b>
  801b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b17:	75 84                	jne    801a9d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801b19:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801b1d:	75 10                	jne    801b2f <print_mem_block_lists+0xcd>
  801b1f:	83 ec 0c             	sub    $0xc,%esp
  801b22:	68 48 3b 80 00       	push   $0x803b48
  801b27:	e8 1c e8 ff ff       	call   800348 <cprintf>
  801b2c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801b2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801b36:	83 ec 0c             	sub    $0xc,%esp
  801b39:	68 6c 3b 80 00       	push   $0x803b6c
  801b3e:	e8 05 e8 ff ff       	call   800348 <cprintf>
  801b43:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801b46:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801b4a:	a1 40 40 80 00       	mov    0x804040,%eax
  801b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b52:	eb 56                	jmp    801baa <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b58:	74 1c                	je     801b76 <print_mem_block_lists+0x114>
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	8b 50 08             	mov    0x8(%eax),%edx
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	8b 48 08             	mov    0x8(%eax),%ecx
  801b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b69:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6c:	01 c8                	add    %ecx,%eax
  801b6e:	39 c2                	cmp    %eax,%edx
  801b70:	73 04                	jae    801b76 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801b72:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b79:	8b 50 08             	mov    0x8(%eax),%edx
  801b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b82:	01 c2                	add    %eax,%edx
  801b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b87:	8b 40 08             	mov    0x8(%eax),%eax
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	52                   	push   %edx
  801b8e:	50                   	push   %eax
  801b8f:	68 39 3b 80 00       	push   $0x803b39
  801b94:	e8 af e7 ff ff       	call   800348 <cprintf>
  801b99:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ba2:	a1 48 40 80 00       	mov    0x804048,%eax
  801ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801baa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bae:	74 07                	je     801bb7 <print_mem_block_lists+0x155>
  801bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb3:	8b 00                	mov    (%eax),%eax
  801bb5:	eb 05                	jmp    801bbc <print_mem_block_lists+0x15a>
  801bb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbc:	a3 48 40 80 00       	mov    %eax,0x804048
  801bc1:	a1 48 40 80 00       	mov    0x804048,%eax
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	75 8a                	jne    801b54 <print_mem_block_lists+0xf2>
  801bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bce:	75 84                	jne    801b54 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801bd0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801bd4:	75 10                	jne    801be6 <print_mem_block_lists+0x184>
  801bd6:	83 ec 0c             	sub    $0xc,%esp
  801bd9:	68 84 3b 80 00       	push   $0x803b84
  801bde:	e8 65 e7 ff ff       	call   800348 <cprintf>
  801be3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801be6:	83 ec 0c             	sub    $0xc,%esp
  801be9:	68 f8 3a 80 00       	push   $0x803af8
  801bee:	e8 55 e7 ff ff       	call   800348 <cprintf>
  801bf3:	83 c4 10             	add    $0x10,%esp

}
  801bf6:	90                   	nop
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801bff:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801c06:	00 00 00 
  801c09:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801c10:	00 00 00 
  801c13:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801c1a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801c1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c24:	e9 9e 00 00 00       	jmp    801cc7 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801c29:	a1 50 40 80 00       	mov    0x804050,%eax
  801c2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c31:	c1 e2 04             	shl    $0x4,%edx
  801c34:	01 d0                	add    %edx,%eax
  801c36:	85 c0                	test   %eax,%eax
  801c38:	75 14                	jne    801c4e <initialize_MemBlocksList+0x55>
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	68 ac 3b 80 00       	push   $0x803bac
  801c42:	6a 46                	push   $0x46
  801c44:	68 cf 3b 80 00       	push   $0x803bcf
  801c49:	e8 64 14 00 00       	call   8030b2 <_panic>
  801c4e:	a1 50 40 80 00       	mov    0x804050,%eax
  801c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c56:	c1 e2 04             	shl    $0x4,%edx
  801c59:	01 d0                	add    %edx,%eax
  801c5b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801c61:	89 10                	mov    %edx,(%eax)
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	85 c0                	test   %eax,%eax
  801c67:	74 18                	je     801c81 <initialize_MemBlocksList+0x88>
  801c69:	a1 48 41 80 00       	mov    0x804148,%eax
  801c6e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801c74:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801c77:	c1 e1 04             	shl    $0x4,%ecx
  801c7a:	01 ca                	add    %ecx,%edx
  801c7c:	89 50 04             	mov    %edx,0x4(%eax)
  801c7f:	eb 12                	jmp    801c93 <initialize_MemBlocksList+0x9a>
  801c81:	a1 50 40 80 00       	mov    0x804050,%eax
  801c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c89:	c1 e2 04             	shl    $0x4,%edx
  801c8c:	01 d0                	add    %edx,%eax
  801c8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801c93:	a1 50 40 80 00       	mov    0x804050,%eax
  801c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c9b:	c1 e2 04             	shl    $0x4,%edx
  801c9e:	01 d0                	add    %edx,%eax
  801ca0:	a3 48 41 80 00       	mov    %eax,0x804148
  801ca5:	a1 50 40 80 00       	mov    0x804050,%eax
  801caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cad:	c1 e2 04             	shl    $0x4,%edx
  801cb0:	01 d0                	add    %edx,%eax
  801cb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cb9:	a1 54 41 80 00       	mov    0x804154,%eax
  801cbe:	40                   	inc    %eax
  801cbf:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801cc4:	ff 45 f4             	incl   -0xc(%ebp)
  801cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cca:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ccd:	0f 82 56 ff ff ff    	jb     801c29 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801cd3:	90                   	nop
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	8b 00                	mov    (%eax),%eax
  801ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ce4:	eb 19                	jmp    801cff <find_block+0x29>
	{
		if(va==point->sva)
  801ce6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce9:	8b 40 08             	mov    0x8(%eax),%eax
  801cec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801cef:	75 05                	jne    801cf6 <find_block+0x20>
		   return point;
  801cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cf4:	eb 36                	jmp    801d2c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	8b 40 08             	mov    0x8(%eax),%eax
  801cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801cff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d03:	74 07                	je     801d0c <find_block+0x36>
  801d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d08:	8b 00                	mov    (%eax),%eax
  801d0a:	eb 05                	jmp    801d11 <find_block+0x3b>
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d11:	8b 55 08             	mov    0x8(%ebp),%edx
  801d14:	89 42 08             	mov    %eax,0x8(%edx)
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	8b 40 08             	mov    0x8(%eax),%eax
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	75 c5                	jne    801ce6 <find_block+0x10>
  801d21:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d25:	75 bf                	jne    801ce6 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801d34:	a1 40 40 80 00       	mov    0x804040,%eax
  801d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801d3c:	a1 44 40 80 00       	mov    0x804044,%eax
  801d41:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d47:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801d4a:	74 24                	je     801d70 <insert_sorted_allocList+0x42>
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	8b 50 08             	mov    0x8(%eax),%edx
  801d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d55:	8b 40 08             	mov    0x8(%eax),%eax
  801d58:	39 c2                	cmp    %eax,%edx
  801d5a:	76 14                	jbe    801d70 <insert_sorted_allocList+0x42>
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	8b 50 08             	mov    0x8(%eax),%edx
  801d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d65:	8b 40 08             	mov    0x8(%eax),%eax
  801d68:	39 c2                	cmp    %eax,%edx
  801d6a:	0f 82 60 01 00 00    	jb     801ed0 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801d70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d74:	75 65                	jne    801ddb <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801d76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d7a:	75 14                	jne    801d90 <insert_sorted_allocList+0x62>
  801d7c:	83 ec 04             	sub    $0x4,%esp
  801d7f:	68 ac 3b 80 00       	push   $0x803bac
  801d84:	6a 6b                	push   $0x6b
  801d86:	68 cf 3b 80 00       	push   $0x803bcf
  801d8b:	e8 22 13 00 00       	call   8030b2 <_panic>
  801d90:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	89 10                	mov    %edx,(%eax)
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	8b 00                	mov    (%eax),%eax
  801da0:	85 c0                	test   %eax,%eax
  801da2:	74 0d                	je     801db1 <insert_sorted_allocList+0x83>
  801da4:	a1 40 40 80 00       	mov    0x804040,%eax
  801da9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dac:	89 50 04             	mov    %edx,0x4(%eax)
  801daf:	eb 08                	jmp    801db9 <insert_sorted_allocList+0x8b>
  801db1:	8b 45 08             	mov    0x8(%ebp),%eax
  801db4:	a3 44 40 80 00       	mov    %eax,0x804044
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	a3 40 40 80 00       	mov    %eax,0x804040
  801dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dcb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801dd0:	40                   	inc    %eax
  801dd1:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801dd6:	e9 dc 01 00 00       	jmp    801fb7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	8b 50 08             	mov    0x8(%eax),%edx
  801de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de4:	8b 40 08             	mov    0x8(%eax),%eax
  801de7:	39 c2                	cmp    %eax,%edx
  801de9:	77 6c                	ja     801e57 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801deb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801def:	74 06                	je     801df7 <insert_sorted_allocList+0xc9>
  801df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801df5:	75 14                	jne    801e0b <insert_sorted_allocList+0xdd>
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	68 e8 3b 80 00       	push   $0x803be8
  801dff:	6a 6f                	push   $0x6f
  801e01:	68 cf 3b 80 00       	push   $0x803bcf
  801e06:	e8 a7 12 00 00       	call   8030b2 <_panic>
  801e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0e:	8b 50 04             	mov    0x4(%eax),%edx
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	89 50 04             	mov    %edx,0x4(%eax)
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e1d:	89 10                	mov    %edx,(%eax)
  801e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e22:	8b 40 04             	mov    0x4(%eax),%eax
  801e25:	85 c0                	test   %eax,%eax
  801e27:	74 0d                	je     801e36 <insert_sorted_allocList+0x108>
  801e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2c:	8b 40 04             	mov    0x4(%eax),%eax
  801e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e32:	89 10                	mov    %edx,(%eax)
  801e34:	eb 08                	jmp    801e3e <insert_sorted_allocList+0x110>
  801e36:	8b 45 08             	mov    0x8(%ebp),%eax
  801e39:	a3 40 40 80 00       	mov    %eax,0x804040
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	8b 55 08             	mov    0x8(%ebp),%edx
  801e44:	89 50 04             	mov    %edx,0x4(%eax)
  801e47:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e4c:	40                   	inc    %eax
  801e4d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e52:	e9 60 01 00 00       	jmp    801fb7 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	8b 50 08             	mov    0x8(%eax),%edx
  801e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e60:	8b 40 08             	mov    0x8(%eax),%eax
  801e63:	39 c2                	cmp    %eax,%edx
  801e65:	0f 82 4c 01 00 00    	jb     801fb7 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801e6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e6f:	75 14                	jne    801e85 <insert_sorted_allocList+0x157>
  801e71:	83 ec 04             	sub    $0x4,%esp
  801e74:	68 20 3c 80 00       	push   $0x803c20
  801e79:	6a 73                	push   $0x73
  801e7b:	68 cf 3b 80 00       	push   $0x803bcf
  801e80:	e8 2d 12 00 00       	call   8030b2 <_panic>
  801e85:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	89 50 04             	mov    %edx,0x4(%eax)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	8b 40 04             	mov    0x4(%eax),%eax
  801e97:	85 c0                	test   %eax,%eax
  801e99:	74 0c                	je     801ea7 <insert_sorted_allocList+0x179>
  801e9b:	a1 44 40 80 00       	mov    0x804044,%eax
  801ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ea3:	89 10                	mov    %edx,(%eax)
  801ea5:	eb 08                	jmp    801eaf <insert_sorted_allocList+0x181>
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	a3 40 40 80 00       	mov    %eax,0x804040
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	a3 44 40 80 00       	mov    %eax,0x804044
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ec0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801ec5:	40                   	inc    %eax
  801ec6:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801ecb:	e9 e7 00 00 00       	jmp    801fb7 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801ed6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801edd:	a1 40 40 80 00       	mov    0x804040,%eax
  801ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee5:	e9 9d 00 00 00       	jmp    801f87 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	8b 00                	mov    (%eax),%eax
  801eef:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	8b 50 08             	mov    0x8(%eax),%edx
  801ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efb:	8b 40 08             	mov    0x8(%eax),%eax
  801efe:	39 c2                	cmp    %eax,%edx
  801f00:	76 7d                	jbe    801f7f <insert_sorted_allocList+0x251>
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	8b 50 08             	mov    0x8(%eax),%edx
  801f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f0b:	8b 40 08             	mov    0x8(%eax),%eax
  801f0e:	39 c2                	cmp    %eax,%edx
  801f10:	73 6d                	jae    801f7f <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	74 06                	je     801f1e <insert_sorted_allocList+0x1f0>
  801f18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f1c:	75 14                	jne    801f32 <insert_sorted_allocList+0x204>
  801f1e:	83 ec 04             	sub    $0x4,%esp
  801f21:	68 44 3c 80 00       	push   $0x803c44
  801f26:	6a 7f                	push   $0x7f
  801f28:	68 cf 3b 80 00       	push   $0x803bcf
  801f2d:	e8 80 11 00 00       	call   8030b2 <_panic>
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 10                	mov    (%eax),%edx
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	89 10                	mov    %edx,(%eax)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8b 00                	mov    (%eax),%eax
  801f41:	85 c0                	test   %eax,%eax
  801f43:	74 0b                	je     801f50 <insert_sorted_allocList+0x222>
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 00                	mov    (%eax),%eax
  801f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  801f4d:	89 50 04             	mov    %edx,0x4(%eax)
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 55 08             	mov    0x8(%ebp),%edx
  801f56:	89 10                	mov    %edx,(%eax)
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5e:	89 50 04             	mov    %edx,0x4(%eax)
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	8b 00                	mov    (%eax),%eax
  801f66:	85 c0                	test   %eax,%eax
  801f68:	75 08                	jne    801f72 <insert_sorted_allocList+0x244>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	a3 44 40 80 00       	mov    %eax,0x804044
  801f72:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f77:	40                   	inc    %eax
  801f78:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  801f7d:	eb 39                	jmp    801fb8 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f7f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8b:	74 07                	je     801f94 <insert_sorted_allocList+0x266>
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 00                	mov    (%eax),%eax
  801f92:	eb 05                	jmp    801f99 <insert_sorted_allocList+0x26b>
  801f94:	b8 00 00 00 00       	mov    $0x0,%eax
  801f99:	a3 48 40 80 00       	mov    %eax,0x804048
  801f9e:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 85 3f ff ff ff    	jne    801eea <insert_sorted_allocList+0x1bc>
  801fab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faf:	0f 85 35 ff ff ff    	jne    801eea <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  801fb5:	eb 01                	jmp    801fb8 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fb7:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  801fb8:	90                   	nop
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  801fc1:	a1 38 41 80 00       	mov    0x804138,%eax
  801fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc9:	e9 85 01 00 00       	jmp    802153 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fd7:	0f 82 6e 01 00 00    	jb     80214b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fe6:	0f 85 8a 00 00 00    	jne    802076 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  801fec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff0:	75 17                	jne    802009 <alloc_block_FF+0x4e>
  801ff2:	83 ec 04             	sub    $0x4,%esp
  801ff5:	68 78 3c 80 00       	push   $0x803c78
  801ffa:	68 93 00 00 00       	push   $0x93
  801fff:	68 cf 3b 80 00       	push   $0x803bcf
  802004:	e8 a9 10 00 00       	call   8030b2 <_panic>
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 00                	mov    (%eax),%eax
  80200e:	85 c0                	test   %eax,%eax
  802010:	74 10                	je     802022 <alloc_block_FF+0x67>
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	8b 00                	mov    (%eax),%eax
  802017:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201a:	8b 52 04             	mov    0x4(%edx),%edx
  80201d:	89 50 04             	mov    %edx,0x4(%eax)
  802020:	eb 0b                	jmp    80202d <alloc_block_FF+0x72>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 40 04             	mov    0x4(%eax),%eax
  802028:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 40 04             	mov    0x4(%eax),%eax
  802033:	85 c0                	test   %eax,%eax
  802035:	74 0f                	je     802046 <alloc_block_FF+0x8b>
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	8b 40 04             	mov    0x4(%eax),%eax
  80203d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802040:	8b 12                	mov    (%edx),%edx
  802042:	89 10                	mov    %edx,(%eax)
  802044:	eb 0a                	jmp    802050 <alloc_block_FF+0x95>
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	8b 00                	mov    (%eax),%eax
  80204b:	a3 38 41 80 00       	mov    %eax,0x804138
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802063:	a1 44 41 80 00       	mov    0x804144,%eax
  802068:	48                   	dec    %eax
  802069:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	e9 10 01 00 00       	jmp    802186 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	8b 40 0c             	mov    0xc(%eax),%eax
  80207c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80207f:	0f 86 c6 00 00 00    	jbe    80214b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802085:	a1 48 41 80 00       	mov    0x804148,%eax
  80208a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80208d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802090:	8b 50 08             	mov    0x8(%eax),%edx
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209c:	8b 55 08             	mov    0x8(%ebp),%edx
  80209f:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8020a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a6:	75 17                	jne    8020bf <alloc_block_FF+0x104>
  8020a8:	83 ec 04             	sub    $0x4,%esp
  8020ab:	68 78 3c 80 00       	push   $0x803c78
  8020b0:	68 9b 00 00 00       	push   $0x9b
  8020b5:	68 cf 3b 80 00       	push   $0x803bcf
  8020ba:	e8 f3 0f 00 00       	call   8030b2 <_panic>
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	8b 00                	mov    (%eax),%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	74 10                	je     8020d8 <alloc_block_FF+0x11d>
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cb:	8b 00                	mov    (%eax),%eax
  8020cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020d0:	8b 52 04             	mov    0x4(%edx),%edx
  8020d3:	89 50 04             	mov    %edx,0x4(%eax)
  8020d6:	eb 0b                	jmp    8020e3 <alloc_block_FF+0x128>
  8020d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020db:	8b 40 04             	mov    0x4(%eax),%eax
  8020de:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e6:	8b 40 04             	mov    0x4(%eax),%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	74 0f                	je     8020fc <alloc_block_FF+0x141>
  8020ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f0:	8b 40 04             	mov    0x4(%eax),%eax
  8020f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f6:	8b 12                	mov    (%edx),%edx
  8020f8:	89 10                	mov    %edx,(%eax)
  8020fa:	eb 0a                	jmp    802106 <alloc_block_FF+0x14b>
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	a3 48 41 80 00       	mov    %eax,0x804148
  802106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80210f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802112:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802119:	a1 54 41 80 00       	mov    0x804154,%eax
  80211e:	48                   	dec    %eax
  80211f:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 50 08             	mov    0x8(%eax),%edx
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	01 c2                	add    %eax,%edx
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 40 0c             	mov    0xc(%eax),%eax
  80213b:	2b 45 08             	sub    0x8(%ebp),%eax
  80213e:	89 c2                	mov    %eax,%edx
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	eb 3b                	jmp    802186 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80214b:	a1 40 41 80 00       	mov    0x804140,%eax
  802150:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802157:	74 07                	je     802160 <alloc_block_FF+0x1a5>
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	eb 05                	jmp    802165 <alloc_block_FF+0x1aa>
  802160:	b8 00 00 00 00       	mov    $0x0,%eax
  802165:	a3 40 41 80 00       	mov    %eax,0x804140
  80216a:	a1 40 41 80 00       	mov    0x804140,%eax
  80216f:	85 c0                	test   %eax,%eax
  802171:	0f 85 57 fe ff ff    	jne    801fce <alloc_block_FF+0x13>
  802177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217b:	0f 85 4d fe ff ff    	jne    801fce <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802186:	c9                   	leave  
  802187:	c3                   	ret    

00802188 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802188:	55                   	push   %ebp
  802189:	89 e5                	mov    %esp,%ebp
  80218b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80218e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802195:	a1 38 41 80 00       	mov    0x804138,%eax
  80219a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219d:	e9 df 00 00 00       	jmp    802281 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ab:	0f 82 c8 00 00 00    	jb     802279 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ba:	0f 85 8a 00 00 00    	jne    80224a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8021c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c4:	75 17                	jne    8021dd <alloc_block_BF+0x55>
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	68 78 3c 80 00       	push   $0x803c78
  8021ce:	68 b7 00 00 00       	push   $0xb7
  8021d3:	68 cf 3b 80 00       	push   $0x803bcf
  8021d8:	e8 d5 0e 00 00       	call   8030b2 <_panic>
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 10                	je     8021f6 <alloc_block_BF+0x6e>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ee:	8b 52 04             	mov    0x4(%edx),%edx
  8021f1:	89 50 04             	mov    %edx,0x4(%eax)
  8021f4:	eb 0b                	jmp    802201 <alloc_block_BF+0x79>
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	8b 40 04             	mov    0x4(%eax),%eax
  8021fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 40 04             	mov    0x4(%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	74 0f                	je     80221a <alloc_block_BF+0x92>
  80220b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220e:	8b 40 04             	mov    0x4(%eax),%eax
  802211:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802214:	8b 12                	mov    (%edx),%edx
  802216:	89 10                	mov    %edx,(%eax)
  802218:	eb 0a                	jmp    802224 <alloc_block_BF+0x9c>
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	8b 00                	mov    (%eax),%eax
  80221f:	a3 38 41 80 00       	mov    %eax,0x804138
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802237:	a1 44 41 80 00       	mov    0x804144,%eax
  80223c:	48                   	dec    %eax
  80223d:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	e9 4d 01 00 00       	jmp    802397 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 0c             	mov    0xc(%eax),%eax
  802250:	3b 45 08             	cmp    0x8(%ebp),%eax
  802253:	76 24                	jbe    802279 <alloc_block_BF+0xf1>
  802255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802258:	8b 40 0c             	mov    0xc(%eax),%eax
  80225b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80225e:	73 19                	jae    802279 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802260:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 40 0c             	mov    0xc(%eax),%eax
  80226d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802273:	8b 40 08             	mov    0x8(%eax),%eax
  802276:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802279:	a1 40 41 80 00       	mov    0x804140,%eax
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	74 07                	je     80228e <alloc_block_BF+0x106>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	eb 05                	jmp    802293 <alloc_block_BF+0x10b>
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
  802293:	a3 40 41 80 00       	mov    %eax,0x804140
  802298:	a1 40 41 80 00       	mov    0x804140,%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	0f 85 fd fe ff ff    	jne    8021a2 <alloc_block_BF+0x1a>
  8022a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a9:	0f 85 f3 fe ff ff    	jne    8021a2 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8022af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8022b3:	0f 84 d9 00 00 00    	je     802392 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8022be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8022c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022c7:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8022ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d0:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8022d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022d7:	75 17                	jne    8022f0 <alloc_block_BF+0x168>
  8022d9:	83 ec 04             	sub    $0x4,%esp
  8022dc:	68 78 3c 80 00       	push   $0x803c78
  8022e1:	68 c7 00 00 00       	push   $0xc7
  8022e6:	68 cf 3b 80 00       	push   $0x803bcf
  8022eb:	e8 c2 0d 00 00       	call   8030b2 <_panic>
  8022f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 10                	je     802309 <alloc_block_BF+0x181>
  8022f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802301:	8b 52 04             	mov    0x4(%edx),%edx
  802304:	89 50 04             	mov    %edx,0x4(%eax)
  802307:	eb 0b                	jmp    802314 <alloc_block_BF+0x18c>
  802309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230c:	8b 40 04             	mov    0x4(%eax),%eax
  80230f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802314:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802317:	8b 40 04             	mov    0x4(%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 0f                	je     80232d <alloc_block_BF+0x1a5>
  80231e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802321:	8b 40 04             	mov    0x4(%eax),%eax
  802324:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802327:	8b 12                	mov    (%edx),%edx
  802329:	89 10                	mov    %edx,(%eax)
  80232b:	eb 0a                	jmp    802337 <alloc_block_BF+0x1af>
  80232d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	a3 48 41 80 00       	mov    %eax,0x804148
  802337:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802343:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234a:	a1 54 41 80 00       	mov    0x804154,%eax
  80234f:	48                   	dec    %eax
  802350:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802355:	83 ec 08             	sub    $0x8,%esp
  802358:	ff 75 ec             	pushl  -0x14(%ebp)
  80235b:	68 38 41 80 00       	push   $0x804138
  802360:	e8 71 f9 ff ff       	call   801cd6 <find_block>
  802365:	83 c4 10             	add    $0x10,%esp
  802368:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80236b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80236e:	8b 50 08             	mov    0x8(%eax),%edx
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	01 c2                	add    %eax,%edx
  802376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802379:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80237c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237f:	8b 40 0c             	mov    0xc(%eax),%eax
  802382:	2b 45 08             	sub    0x8(%ebp),%eax
  802385:	89 c2                	mov    %eax,%edx
  802387:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238a:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80238d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802390:	eb 05                	jmp    802397 <alloc_block_BF+0x20f>
	}
	return NULL;
  802392:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802397:	c9                   	leave  
  802398:	c3                   	ret    

00802399 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80239f:	a1 28 40 80 00       	mov    0x804028,%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	0f 85 de 01 00 00    	jne    80258a <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8023ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8023b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b4:	e9 9e 01 00 00       	jmp    802557 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c2:	0f 82 87 01 00 00    	jb     80254f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d1:	0f 85 95 00 00 00    	jne    80246c <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023db:	75 17                	jne    8023f4 <alloc_block_NF+0x5b>
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	68 78 3c 80 00       	push   $0x803c78
  8023e5:	68 e0 00 00 00       	push   $0xe0
  8023ea:	68 cf 3b 80 00       	push   $0x803bcf
  8023ef:	e8 be 0c 00 00       	call   8030b2 <_panic>
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 10                	je     80240d <alloc_block_NF+0x74>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802405:	8b 52 04             	mov    0x4(%edx),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	eb 0b                	jmp    802418 <alloc_block_NF+0x7f>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0f                	je     802431 <alloc_block_NF+0x98>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	8b 12                	mov    (%edx),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	eb 0a                	jmp    80243b <alloc_block_NF+0xa2>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	a3 38 41 80 00       	mov    %eax,0x804138
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244e:	a1 44 41 80 00       	mov    0x804144,%eax
  802453:	48                   	dec    %eax
  802454:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 08             	mov    0x8(%eax),%eax
  80245f:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	e9 f8 04 00 00       	jmp    802964 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 86 d4 00 00 00    	jbe    80254f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80247b:	a1 48 41 80 00       	mov    0x804148,%eax
  802480:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 50 08             	mov    0x8(%eax),%edx
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	8b 55 08             	mov    0x8(%ebp),%edx
  802495:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802498:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80249c:	75 17                	jne    8024b5 <alloc_block_NF+0x11c>
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	68 78 3c 80 00       	push   $0x803c78
  8024a6:	68 e9 00 00 00       	push   $0xe9
  8024ab:	68 cf 3b 80 00       	push   $0x803bcf
  8024b0:	e8 fd 0b 00 00       	call   8030b2 <_panic>
  8024b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b8:	8b 00                	mov    (%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 10                	je     8024ce <alloc_block_NF+0x135>
  8024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c1:	8b 00                	mov    (%eax),%eax
  8024c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024c6:	8b 52 04             	mov    0x4(%edx),%edx
  8024c9:	89 50 04             	mov    %edx,0x4(%eax)
  8024cc:	eb 0b                	jmp    8024d9 <alloc_block_NF+0x140>
  8024ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d1:	8b 40 04             	mov    0x4(%eax),%eax
  8024d4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dc:	8b 40 04             	mov    0x4(%eax),%eax
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	74 0f                	je     8024f2 <alloc_block_NF+0x159>
  8024e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e6:	8b 40 04             	mov    0x4(%eax),%eax
  8024e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ec:	8b 12                	mov    (%edx),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
  8024f0:	eb 0a                	jmp    8024fc <alloc_block_NF+0x163>
  8024f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f5:	8b 00                	mov    (%eax),%eax
  8024f7:	a3 48 41 80 00       	mov    %eax,0x804148
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802508:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80250f:	a1 54 41 80 00       	mov    0x804154,%eax
  802514:	48                   	dec    %eax
  802515:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80251a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251d:	8b 40 08             	mov    0x8(%eax),%eax
  802520:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 50 08             	mov    0x8(%eax),%edx
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	01 c2                	add    %eax,%edx
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 40 0c             	mov    0xc(%eax),%eax
  80253c:	2b 45 08             	sub    0x8(%ebp),%eax
  80253f:	89 c2                	mov    %eax,%edx
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	e9 15 04 00 00       	jmp    802964 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80254f:	a1 40 41 80 00       	mov    0x804140,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	74 07                	je     802564 <alloc_block_NF+0x1cb>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	eb 05                	jmp    802569 <alloc_block_NF+0x1d0>
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	a3 40 41 80 00       	mov    %eax,0x804140
  80256e:	a1 40 41 80 00       	mov    0x804140,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 85 3e fe ff ff    	jne    8023b9 <alloc_block_NF+0x20>
  80257b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257f:	0f 85 34 fe ff ff    	jne    8023b9 <alloc_block_NF+0x20>
  802585:	e9 d5 03 00 00       	jmp    80295f <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80258a:	a1 38 41 80 00       	mov    0x804138,%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	e9 b1 01 00 00       	jmp    802748 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 50 08             	mov    0x8(%eax),%edx
  80259d:	a1 28 40 80 00       	mov    0x804028,%eax
  8025a2:	39 c2                	cmp    %eax,%edx
  8025a4:	0f 82 96 01 00 00    	jb     802740 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b3:	0f 82 87 01 00 00    	jb     802740 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c2:	0f 85 95 00 00 00    	jne    80265d <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	75 17                	jne    8025e5 <alloc_block_NF+0x24c>
  8025ce:	83 ec 04             	sub    $0x4,%esp
  8025d1:	68 78 3c 80 00       	push   $0x803c78
  8025d6:	68 fc 00 00 00       	push   $0xfc
  8025db:	68 cf 3b 80 00       	push   $0x803bcf
  8025e0:	e8 cd 0a 00 00       	call   8030b2 <_panic>
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 00                	mov    (%eax),%eax
  8025ea:	85 c0                	test   %eax,%eax
  8025ec:	74 10                	je     8025fe <alloc_block_NF+0x265>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	8b 52 04             	mov    0x4(%edx),%edx
  8025f9:	89 50 04             	mov    %edx,0x4(%eax)
  8025fc:	eb 0b                	jmp    802609 <alloc_block_NF+0x270>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	8b 40 04             	mov    0x4(%eax),%eax
  80260f:	85 c0                	test   %eax,%eax
  802611:	74 0f                	je     802622 <alloc_block_NF+0x289>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261c:	8b 12                	mov    (%edx),%edx
  80261e:	89 10                	mov    %edx,(%eax)
  802620:	eb 0a                	jmp    80262c <alloc_block_NF+0x293>
  802622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802625:	8b 00                	mov    (%eax),%eax
  802627:	a3 38 41 80 00       	mov    %eax,0x804138
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80263f:	a1 44 41 80 00       	mov    0x804144,%eax
  802644:	48                   	dec    %eax
  802645:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 08             	mov    0x8(%eax),%eax
  802650:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	e9 07 03 00 00       	jmp    802964 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	3b 45 08             	cmp    0x8(%ebp),%eax
  802666:	0f 86 d4 00 00 00    	jbe    802740 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80266c:	a1 48 41 80 00       	mov    0x804148,%eax
  802671:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 50 08             	mov    0x8(%eax),%edx
  80267a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802683:	8b 55 08             	mov    0x8(%ebp),%edx
  802686:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802689:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80268d:	75 17                	jne    8026a6 <alloc_block_NF+0x30d>
  80268f:	83 ec 04             	sub    $0x4,%esp
  802692:	68 78 3c 80 00       	push   $0x803c78
  802697:	68 04 01 00 00       	push   $0x104
  80269c:	68 cf 3b 80 00       	push   $0x803bcf
  8026a1:	e8 0c 0a 00 00       	call   8030b2 <_panic>
  8026a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 10                	je     8026bf <alloc_block_NF+0x326>
  8026af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b7:	8b 52 04             	mov    0x4(%edx),%edx
  8026ba:	89 50 04             	mov    %edx,0x4(%eax)
  8026bd:	eb 0b                	jmp    8026ca <alloc_block_NF+0x331>
  8026bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c2:	8b 40 04             	mov    0x4(%eax),%eax
  8026c5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 0f                	je     8026e3 <alloc_block_NF+0x34a>
  8026d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d7:	8b 40 04             	mov    0x4(%eax),%eax
  8026da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026dd:	8b 12                	mov    (%edx),%edx
  8026df:	89 10                	mov    %edx,(%eax)
  8026e1:	eb 0a                	jmp    8026ed <alloc_block_NF+0x354>
  8026e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	a3 48 41 80 00       	mov    %eax,0x804148
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802700:	a1 54 41 80 00       	mov    0x804154,%eax
  802705:	48                   	dec    %eax
  802706:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80270b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270e:	8b 40 08             	mov    0x8(%eax),%eax
  802711:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 50 08             	mov    0x8(%eax),%edx
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	01 c2                	add    %eax,%edx
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 0c             	mov    0xc(%eax),%eax
  80272d:	2b 45 08             	sub    0x8(%ebp),%eax
  802730:	89 c2                	mov    %eax,%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273b:	e9 24 02 00 00       	jmp    802964 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802740:	a1 40 41 80 00       	mov    0x804140,%eax
  802745:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274c:	74 07                	je     802755 <alloc_block_NF+0x3bc>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	eb 05                	jmp    80275a <alloc_block_NF+0x3c1>
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	a3 40 41 80 00       	mov    %eax,0x804140
  80275f:	a1 40 41 80 00       	mov    0x804140,%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	0f 85 2b fe ff ff    	jne    802597 <alloc_block_NF+0x1fe>
  80276c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802770:	0f 85 21 fe ff ff    	jne    802597 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802776:	a1 38 41 80 00       	mov    0x804138,%eax
  80277b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80277e:	e9 ae 01 00 00       	jmp    802931 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 50 08             	mov    0x8(%eax),%edx
  802789:	a1 28 40 80 00       	mov    0x804028,%eax
  80278e:	39 c2                	cmp    %eax,%edx
  802790:	0f 83 93 01 00 00    	jae    802929 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 0c             	mov    0xc(%eax),%eax
  80279c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279f:	0f 82 84 01 00 00    	jb     802929 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ae:	0f 85 95 00 00 00    	jne    802849 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b8:	75 17                	jne    8027d1 <alloc_block_NF+0x438>
  8027ba:	83 ec 04             	sub    $0x4,%esp
  8027bd:	68 78 3c 80 00       	push   $0x803c78
  8027c2:	68 14 01 00 00       	push   $0x114
  8027c7:	68 cf 3b 80 00       	push   $0x803bcf
  8027cc:	e8 e1 08 00 00       	call   8030b2 <_panic>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 00                	mov    (%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 10                	je     8027ea <alloc_block_NF+0x451>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e2:	8b 52 04             	mov    0x4(%edx),%edx
  8027e5:	89 50 04             	mov    %edx,0x4(%eax)
  8027e8:	eb 0b                	jmp    8027f5 <alloc_block_NF+0x45c>
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 04             	mov    0x4(%eax),%eax
  8027f0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	74 0f                	je     80280e <alloc_block_NF+0x475>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 04             	mov    0x4(%eax),%eax
  802805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802808:	8b 12                	mov    (%edx),%edx
  80280a:	89 10                	mov    %edx,(%eax)
  80280c:	eb 0a                	jmp    802818 <alloc_block_NF+0x47f>
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 00                	mov    (%eax),%eax
  802813:	a3 38 41 80 00       	mov    %eax,0x804138
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282b:	a1 44 41 80 00       	mov    0x804144,%eax
  802830:	48                   	dec    %eax
  802831:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802839:	8b 40 08             	mov    0x8(%eax),%eax
  80283c:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	e9 1b 01 00 00       	jmp    802964 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 0c             	mov    0xc(%eax),%eax
  80284f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802852:	0f 86 d1 00 00 00    	jbe    802929 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802858:	a1 48 41 80 00       	mov    0x804148,%eax
  80285d:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 50 08             	mov    0x8(%eax),%edx
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286f:	8b 55 08             	mov    0x8(%ebp),%edx
  802872:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802875:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802879:	75 17                	jne    802892 <alloc_block_NF+0x4f9>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 78 3c 80 00       	push   $0x803c78
  802883:	68 1c 01 00 00       	push   $0x11c
  802888:	68 cf 3b 80 00       	push   $0x803bcf
  80288d:	e8 20 08 00 00       	call   8030b2 <_panic>
  802892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 10                	je     8028ab <alloc_block_NF+0x512>
  80289b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a3:	8b 52 04             	mov    0x4(%edx),%edx
  8028a6:	89 50 04             	mov    %edx,0x4(%eax)
  8028a9:	eb 0b                	jmp    8028b6 <alloc_block_NF+0x51d>
  8028ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0f                	je     8028cf <alloc_block_NF+0x536>
  8028c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c9:	8b 12                	mov    (%edx),%edx
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	eb 0a                	jmp    8028d9 <alloc_block_NF+0x540>
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ec:	a1 54 41 80 00       	mov    0x804154,%eax
  8028f1:	48                   	dec    %eax
  8028f2:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fa:	8b 40 08             	mov    0x8(%eax),%eax
  8028fd:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 50 08             	mov    0x8(%eax),%edx
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	01 c2                	add    %eax,%edx
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	2b 45 08             	sub    0x8(%ebp),%eax
  80291c:	89 c2                	mov    %eax,%edx
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802924:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802927:	eb 3b                	jmp    802964 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802929:	a1 40 41 80 00       	mov    0x804140,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	74 07                	je     80293e <alloc_block_NF+0x5a5>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	eb 05                	jmp    802943 <alloc_block_NF+0x5aa>
  80293e:	b8 00 00 00 00       	mov    $0x0,%eax
  802943:	a3 40 41 80 00       	mov    %eax,0x804140
  802948:	a1 40 41 80 00       	mov    0x804140,%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	0f 85 2e fe ff ff    	jne    802783 <alloc_block_NF+0x3ea>
  802955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802959:	0f 85 24 fe ff ff    	jne    802783 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  80295f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802964:	c9                   	leave  
  802965:	c3                   	ret    

00802966 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802966:	55                   	push   %ebp
  802967:	89 e5                	mov    %esp,%ebp
  802969:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  80296c:	a1 38 41 80 00       	mov    0x804138,%eax
  802971:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802974:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802979:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  80297c:	a1 38 41 80 00       	mov    0x804138,%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 14                	je     802999 <insert_sorted_with_merge_freeList+0x33>
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	8b 50 08             	mov    0x8(%eax),%edx
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	8b 40 08             	mov    0x8(%eax),%eax
  802991:	39 c2                	cmp    %eax,%edx
  802993:	0f 87 9b 01 00 00    	ja     802b34 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802999:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299d:	75 17                	jne    8029b6 <insert_sorted_with_merge_freeList+0x50>
  80299f:	83 ec 04             	sub    $0x4,%esp
  8029a2:	68 ac 3b 80 00       	push   $0x803bac
  8029a7:	68 38 01 00 00       	push   $0x138
  8029ac:	68 cf 3b 80 00       	push   $0x803bcf
  8029b1:	e8 fc 06 00 00       	call   8030b2 <_panic>
  8029b6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	89 10                	mov    %edx,(%eax)
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 0d                	je     8029d7 <insert_sorted_with_merge_freeList+0x71>
  8029ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8029cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
  8029d5:	eb 08                	jmp    8029df <insert_sorted_with_merge_freeList+0x79>
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	a3 38 41 80 00       	mov    %eax,0x804138
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f1:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f6:	40                   	inc    %eax
  8029f7:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8029fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a00:	0f 84 a8 06 00 00    	je     8030ae <insert_sorted_with_merge_freeList+0x748>
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	8b 50 08             	mov    0x8(%eax),%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a12:	01 c2                	add    %eax,%edx
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 40 08             	mov    0x8(%eax),%eax
  802a1a:	39 c2                	cmp    %eax,%edx
  802a1c:	0f 85 8c 06 00 00    	jne    8030ae <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802a22:	8b 45 08             	mov    0x8(%ebp),%eax
  802a25:	8b 50 0c             	mov    0xc(%eax),%edx
  802a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	01 c2                	add    %eax,%edx
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802a36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a3a:	75 17                	jne    802a53 <insert_sorted_with_merge_freeList+0xed>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 78 3c 80 00       	push   $0x803c78
  802a44:	68 3c 01 00 00       	push   $0x13c
  802a49:	68 cf 3b 80 00       	push   $0x803bcf
  802a4e:	e8 5f 06 00 00       	call   8030b2 <_panic>
  802a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 10                	je     802a6c <insert_sorted_with_merge_freeList+0x106>
  802a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a64:	8b 52 04             	mov    0x4(%edx),%edx
  802a67:	89 50 04             	mov    %edx,0x4(%eax)
  802a6a:	eb 0b                	jmp    802a77 <insert_sorted_with_merge_freeList+0x111>
  802a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0f                	je     802a90 <insert_sorted_with_merge_freeList+0x12a>
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8a:	8b 12                	mov    (%edx),%edx
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	eb 0a                	jmp    802a9a <insert_sorted_with_merge_freeList+0x134>
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	a3 38 41 80 00       	mov    %eax,0x804138
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aad:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab2:	48                   	dec    %eax
  802ab3:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802acc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ad0:	75 17                	jne    802ae9 <insert_sorted_with_merge_freeList+0x183>
  802ad2:	83 ec 04             	sub    $0x4,%esp
  802ad5:	68 ac 3b 80 00       	push   $0x803bac
  802ada:	68 3f 01 00 00       	push   $0x13f
  802adf:	68 cf 3b 80 00       	push   $0x803bcf
  802ae4:	e8 c9 05 00 00       	call   8030b2 <_panic>
  802ae9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0d                	je     802b0a <insert_sorted_with_merge_freeList+0x1a4>
  802afd:	a1 48 41 80 00       	mov    0x804148,%eax
  802b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b05:	89 50 04             	mov    %edx,0x4(%eax)
  802b08:	eb 08                	jmp    802b12 <insert_sorted_with_merge_freeList+0x1ac>
  802b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b15:	a3 48 41 80 00       	mov    %eax,0x804148
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b24:	a1 54 41 80 00       	mov    0x804154,%eax
  802b29:	40                   	inc    %eax
  802b2a:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b2f:	e9 7a 05 00 00       	jmp    8030ae <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 50 08             	mov    0x8(%eax),%edx
  802b3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3d:	8b 40 08             	mov    0x8(%eax),%eax
  802b40:	39 c2                	cmp    %eax,%edx
  802b42:	0f 82 14 01 00 00    	jb     802c5c <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b51:	8b 40 0c             	mov    0xc(%eax),%eax
  802b54:	01 c2                	add    %eax,%edx
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 40 08             	mov    0x8(%eax),%eax
  802b5c:	39 c2                	cmp    %eax,%edx
  802b5e:	0f 85 90 00 00 00    	jne    802bf4 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b67:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b70:	01 c2                	add    %eax,%edx
  802b72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b75:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802b8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b90:	75 17                	jne    802ba9 <insert_sorted_with_merge_freeList+0x243>
  802b92:	83 ec 04             	sub    $0x4,%esp
  802b95:	68 ac 3b 80 00       	push   $0x803bac
  802b9a:	68 49 01 00 00       	push   $0x149
  802b9f:	68 cf 3b 80 00       	push   $0x803bcf
  802ba4:	e8 09 05 00 00       	call   8030b2 <_panic>
  802ba9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	89 10                	mov    %edx,(%eax)
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	74 0d                	je     802bca <insert_sorted_with_merge_freeList+0x264>
  802bbd:	a1 48 41 80 00       	mov    0x804148,%eax
  802bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc5:	89 50 04             	mov    %edx,0x4(%eax)
  802bc8:	eb 08                	jmp    802bd2 <insert_sorted_with_merge_freeList+0x26c>
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	a3 48 41 80 00       	mov    %eax,0x804148
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be4:	a1 54 41 80 00       	mov    0x804154,%eax
  802be9:	40                   	inc    %eax
  802bea:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802bef:	e9 bb 04 00 00       	jmp    8030af <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802bf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf8:	75 17                	jne    802c11 <insert_sorted_with_merge_freeList+0x2ab>
  802bfa:	83 ec 04             	sub    $0x4,%esp
  802bfd:	68 20 3c 80 00       	push   $0x803c20
  802c02:	68 4c 01 00 00       	push   $0x14c
  802c07:	68 cf 3b 80 00       	push   $0x803bcf
  802c0c:	e8 a1 04 00 00       	call   8030b2 <_panic>
  802c11:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	89 50 04             	mov    %edx,0x4(%eax)
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	8b 40 04             	mov    0x4(%eax),%eax
  802c23:	85 c0                	test   %eax,%eax
  802c25:	74 0c                	je     802c33 <insert_sorted_with_merge_freeList+0x2cd>
  802c27:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2f:	89 10                	mov    %edx,(%eax)
  802c31:	eb 08                	jmp    802c3b <insert_sorted_with_merge_freeList+0x2d5>
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4c:	a1 44 41 80 00       	mov    0x804144,%eax
  802c51:	40                   	inc    %eax
  802c52:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c57:	e9 53 04 00 00       	jmp    8030af <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802c5c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c64:	e9 15 04 00 00       	jmp    80307e <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	8b 50 08             	mov    0x8(%eax),%edx
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 08             	mov    0x8(%eax),%eax
  802c7d:	39 c2                	cmp    %eax,%edx
  802c7f:	0f 86 f1 03 00 00    	jbe    803076 <insert_sorted_with_merge_freeList+0x710>
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	8b 50 08             	mov    0x8(%eax),%edx
  802c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8e:	8b 40 08             	mov    0x8(%eax),%eax
  802c91:	39 c2                	cmp    %eax,%edx
  802c93:	0f 83 dd 03 00 00    	jae    803076 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 50 08             	mov    0x8(%eax),%edx
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca5:	01 c2                	add    %eax,%edx
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	8b 40 08             	mov    0x8(%eax),%eax
  802cad:	39 c2                	cmp    %eax,%edx
  802caf:	0f 85 b9 01 00 00    	jne    802e6e <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	8b 50 08             	mov    0x8(%eax),%edx
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc1:	01 c2                	add    %eax,%edx
  802cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	39 c2                	cmp    %eax,%edx
  802ccb:	0f 85 0d 01 00 00    	jne    802dde <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	01 c2                	add    %eax,%edx
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ce5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ce9:	75 17                	jne    802d02 <insert_sorted_with_merge_freeList+0x39c>
  802ceb:	83 ec 04             	sub    $0x4,%esp
  802cee:	68 78 3c 80 00       	push   $0x803c78
  802cf3:	68 5c 01 00 00       	push   $0x15c
  802cf8:	68 cf 3b 80 00       	push   $0x803bcf
  802cfd:	e8 b0 03 00 00       	call   8030b2 <_panic>
  802d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 10                	je     802d1b <insert_sorted_with_merge_freeList+0x3b5>
  802d0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d13:	8b 52 04             	mov    0x4(%edx),%edx
  802d16:	89 50 04             	mov    %edx,0x4(%eax)
  802d19:	eb 0b                	jmp    802d26 <insert_sorted_with_merge_freeList+0x3c0>
  802d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	85 c0                	test   %eax,%eax
  802d2e:	74 0f                	je     802d3f <insert_sorted_with_merge_freeList+0x3d9>
  802d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d33:	8b 40 04             	mov    0x4(%eax),%eax
  802d36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d39:	8b 12                	mov    (%edx),%edx
  802d3b:	89 10                	mov    %edx,(%eax)
  802d3d:	eb 0a                	jmp    802d49 <insert_sorted_with_merge_freeList+0x3e3>
  802d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d42:	8b 00                	mov    (%eax),%eax
  802d44:	a3 38 41 80 00       	mov    %eax,0x804138
  802d49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5c:	a1 44 41 80 00       	mov    0x804144,%eax
  802d61:	48                   	dec    %eax
  802d62:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802d71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d74:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802d7b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d7f:	75 17                	jne    802d98 <insert_sorted_with_merge_freeList+0x432>
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	68 ac 3b 80 00       	push   $0x803bac
  802d89:	68 5f 01 00 00       	push   $0x15f
  802d8e:	68 cf 3b 80 00       	push   $0x803bcf
  802d93:	e8 1a 03 00 00       	call   8030b2 <_panic>
  802d98:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 0d                	je     802db9 <insert_sorted_with_merge_freeList+0x453>
  802dac:	a1 48 41 80 00       	mov    0x804148,%eax
  802db1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802db4:	89 50 04             	mov    %edx,0x4(%eax)
  802db7:	eb 08                	jmp    802dc1 <insert_sorted_with_merge_freeList+0x45b>
  802db9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc4:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd3:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd8:	40                   	inc    %eax
  802dd9:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 50 0c             	mov    0xc(%eax),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	01 c2                	add    %eax,%edx
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0a:	75 17                	jne    802e23 <insert_sorted_with_merge_freeList+0x4bd>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 ac 3b 80 00       	push   $0x803bac
  802e14:	68 64 01 00 00       	push   $0x164
  802e19:	68 cf 3b 80 00       	push   $0x803bcf
  802e1e:	e8 8f 02 00 00       	call   8030b2 <_panic>
  802e23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	89 10                	mov    %edx,(%eax)
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	74 0d                	je     802e44 <insert_sorted_with_merge_freeList+0x4de>
  802e37:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	eb 08                	jmp    802e4c <insert_sorted_with_merge_freeList+0x4e6>
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e63:	40                   	inc    %eax
  802e64:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802e69:	e9 41 02 00 00       	jmp    8030af <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 50 08             	mov    0x8(%eax),%edx
  802e74:	8b 45 08             	mov    0x8(%ebp),%eax
  802e77:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7a:	01 c2                	add    %eax,%edx
  802e7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7f:	8b 40 08             	mov    0x8(%eax),%eax
  802e82:	39 c2                	cmp    %eax,%edx
  802e84:	0f 85 7c 01 00 00    	jne    803006 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802e8a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e8e:	74 06                	je     802e96 <insert_sorted_with_merge_freeList+0x530>
  802e90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e94:	75 17                	jne    802ead <insert_sorted_with_merge_freeList+0x547>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 e8 3b 80 00       	push   $0x803be8
  802e9e:	68 69 01 00 00       	push   $0x169
  802ea3:	68 cf 3b 80 00       	push   $0x803bcf
  802ea8:	e8 05 02 00 00       	call   8030b2 <_panic>
  802ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb0:	8b 50 04             	mov    0x4(%eax),%edx
  802eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb6:	89 50 04             	mov    %edx,0x4(%eax)
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ebf:	89 10                	mov    %edx,(%eax)
  802ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0d                	je     802ed8 <insert_sorted_with_merge_freeList+0x572>
  802ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed4:	89 10                	mov    %edx,(%eax)
  802ed6:	eb 08                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x57a>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 38 41 80 00       	mov    %eax,0x804138
  802ee0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee6:	89 50 04             	mov    %edx,0x4(%eax)
  802ee9:	a1 44 41 80 00       	mov    0x804144,%eax
  802eee:	40                   	inc    %eax
  802eef:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 50 0c             	mov    0xc(%eax),%edx
  802efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efd:	8b 40 0c             	mov    0xc(%eax),%eax
  802f00:	01 c2                	add    %eax,%edx
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f08:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f0c:	75 17                	jne    802f25 <insert_sorted_with_merge_freeList+0x5bf>
  802f0e:	83 ec 04             	sub    $0x4,%esp
  802f11:	68 78 3c 80 00       	push   $0x803c78
  802f16:	68 6b 01 00 00       	push   $0x16b
  802f1b:	68 cf 3b 80 00       	push   $0x803bcf
  802f20:	e8 8d 01 00 00       	call   8030b2 <_panic>
  802f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 10                	je     802f3e <insert_sorted_with_merge_freeList+0x5d8>
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f36:	8b 52 04             	mov    0x4(%edx),%edx
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	eb 0b                	jmp    802f49 <insert_sorted_with_merge_freeList+0x5e3>
  802f3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f41:	8b 40 04             	mov    0x4(%eax),%eax
  802f44:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4c:	8b 40 04             	mov    0x4(%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 0f                	je     802f62 <insert_sorted_with_merge_freeList+0x5fc>
  802f53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f56:	8b 40 04             	mov    0x4(%eax),%eax
  802f59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f5c:	8b 12                	mov    (%edx),%edx
  802f5e:	89 10                	mov    %edx,(%eax)
  802f60:	eb 0a                	jmp    802f6c <insert_sorted_with_merge_freeList+0x606>
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	a3 38 41 80 00       	mov    %eax,0x804138
  802f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f84:	48                   	dec    %eax
  802f85:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  802f8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fa2:	75 17                	jne    802fbb <insert_sorted_with_merge_freeList+0x655>
  802fa4:	83 ec 04             	sub    $0x4,%esp
  802fa7:	68 ac 3b 80 00       	push   $0x803bac
  802fac:	68 6e 01 00 00       	push   $0x16e
  802fb1:	68 cf 3b 80 00       	push   $0x803bcf
  802fb6:	e8 f7 00 00 00       	call   8030b2 <_panic>
  802fbb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	74 0d                	je     802fdc <insert_sorted_with_merge_freeList+0x676>
  802fcf:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd7:	89 50 04             	mov    %edx,0x4(%eax)
  802fda:	eb 08                	jmp    802fe4 <insert_sorted_with_merge_freeList+0x67e>
  802fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	a3 48 41 80 00       	mov    %eax,0x804148
  802fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ffb:	40                   	inc    %eax
  802ffc:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803001:	e9 a9 00 00 00       	jmp    8030af <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803006:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300a:	74 06                	je     803012 <insert_sorted_with_merge_freeList+0x6ac>
  80300c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803010:	75 17                	jne    803029 <insert_sorted_with_merge_freeList+0x6c3>
  803012:	83 ec 04             	sub    $0x4,%esp
  803015:	68 44 3c 80 00       	push   $0x803c44
  80301a:	68 73 01 00 00       	push   $0x173
  80301f:	68 cf 3b 80 00       	push   $0x803bcf
  803024:	e8 89 00 00 00       	call   8030b2 <_panic>
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 10                	mov    (%eax),%edx
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	89 10                	mov    %edx,(%eax)
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	74 0b                	je     803047 <insert_sorted_with_merge_freeList+0x6e1>
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	8b 55 08             	mov    0x8(%ebp),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	8b 55 08             	mov    0x8(%ebp),%edx
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	75 08                	jne    803069 <insert_sorted_with_merge_freeList+0x703>
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803069:	a1 44 41 80 00       	mov    0x804144,%eax
  80306e:	40                   	inc    %eax
  80306f:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803074:	eb 39                	jmp    8030af <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803076:	a1 40 41 80 00       	mov    0x804140,%eax
  80307b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803082:	74 07                	je     80308b <insert_sorted_with_merge_freeList+0x725>
  803084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	eb 05                	jmp    803090 <insert_sorted_with_merge_freeList+0x72a>
  80308b:	b8 00 00 00 00       	mov    $0x0,%eax
  803090:	a3 40 41 80 00       	mov    %eax,0x804140
  803095:	a1 40 41 80 00       	mov    0x804140,%eax
  80309a:	85 c0                	test   %eax,%eax
  80309c:	0f 85 c7 fb ff ff    	jne    802c69 <insert_sorted_with_merge_freeList+0x303>
  8030a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a6:	0f 85 bd fb ff ff    	jne    802c69 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030ac:	eb 01                	jmp    8030af <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8030ae:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030af:	90                   	nop
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8030b2:	55                   	push   %ebp
  8030b3:	89 e5                	mov    %esp,%ebp
  8030b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8030b8:	8d 45 10             	lea    0x10(%ebp),%eax
  8030bb:	83 c0 04             	add    $0x4,%eax
  8030be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8030c1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 16                	je     8030e0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8030ca:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8030cf:	83 ec 08             	sub    $0x8,%esp
  8030d2:	50                   	push   %eax
  8030d3:	68 98 3c 80 00       	push   $0x803c98
  8030d8:	e8 6b d2 ff ff       	call   800348 <cprintf>
  8030dd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8030e0:	a1 00 40 80 00       	mov    0x804000,%eax
  8030e5:	ff 75 0c             	pushl  0xc(%ebp)
  8030e8:	ff 75 08             	pushl  0x8(%ebp)
  8030eb:	50                   	push   %eax
  8030ec:	68 9d 3c 80 00       	push   $0x803c9d
  8030f1:	e8 52 d2 ff ff       	call   800348 <cprintf>
  8030f6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8030f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8030fc:	83 ec 08             	sub    $0x8,%esp
  8030ff:	ff 75 f4             	pushl  -0xc(%ebp)
  803102:	50                   	push   %eax
  803103:	e8 d5 d1 ff ff       	call   8002dd <vcprintf>
  803108:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80310b:	83 ec 08             	sub    $0x8,%esp
  80310e:	6a 00                	push   $0x0
  803110:	68 b9 3c 80 00       	push   $0x803cb9
  803115:	e8 c3 d1 ff ff       	call   8002dd <vcprintf>
  80311a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80311d:	e8 44 d1 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  803122:	eb fe                	jmp    803122 <_panic+0x70>

00803124 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803124:	55                   	push   %ebp
  803125:	89 e5                	mov    %esp,%ebp
  803127:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80312a:	a1 20 40 80 00       	mov    0x804020,%eax
  80312f:	8b 50 74             	mov    0x74(%eax),%edx
  803132:	8b 45 0c             	mov    0xc(%ebp),%eax
  803135:	39 c2                	cmp    %eax,%edx
  803137:	74 14                	je     80314d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803139:	83 ec 04             	sub    $0x4,%esp
  80313c:	68 bc 3c 80 00       	push   $0x803cbc
  803141:	6a 26                	push   $0x26
  803143:	68 08 3d 80 00       	push   $0x803d08
  803148:	e8 65 ff ff ff       	call   8030b2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80314d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803154:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80315b:	e9 c2 00 00 00       	jmp    803222 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	01 d0                	add    %edx,%eax
  80316f:	8b 00                	mov    (%eax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	75 08                	jne    80317d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803175:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803178:	e9 a2 00 00 00       	jmp    80321f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80317d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803184:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80318b:	eb 69                	jmp    8031f6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80318d:	a1 20 40 80 00       	mov    0x804020,%eax
  803192:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803198:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319b:	89 d0                	mov    %edx,%eax
  80319d:	01 c0                	add    %eax,%eax
  80319f:	01 d0                	add    %edx,%eax
  8031a1:	c1 e0 03             	shl    $0x3,%eax
  8031a4:	01 c8                	add    %ecx,%eax
  8031a6:	8a 40 04             	mov    0x4(%eax),%al
  8031a9:	84 c0                	test   %al,%al
  8031ab:	75 46                	jne    8031f3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8031b2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031b8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031bb:	89 d0                	mov    %edx,%eax
  8031bd:	01 c0                	add    %eax,%eax
  8031bf:	01 d0                	add    %edx,%eax
  8031c1:	c1 e0 03             	shl    $0x3,%eax
  8031c4:	01 c8                	add    %ecx,%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8031cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8031ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8031d3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8031d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	01 c8                	add    %ecx,%eax
  8031e4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8031e6:	39 c2                	cmp    %eax,%edx
  8031e8:	75 09                	jne    8031f3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8031ea:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8031f1:	eb 12                	jmp    803205 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031f3:	ff 45 e8             	incl   -0x18(%ebp)
  8031f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8031fb:	8b 50 74             	mov    0x74(%eax),%edx
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	39 c2                	cmp    %eax,%edx
  803203:	77 88                	ja     80318d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803205:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803209:	75 14                	jne    80321f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80320b:	83 ec 04             	sub    $0x4,%esp
  80320e:	68 14 3d 80 00       	push   $0x803d14
  803213:	6a 3a                	push   $0x3a
  803215:	68 08 3d 80 00       	push   $0x803d08
  80321a:	e8 93 fe ff ff       	call   8030b2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80321f:	ff 45 f0             	incl   -0x10(%ebp)
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803228:	0f 8c 32 ff ff ff    	jl     803160 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80322e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803235:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80323c:	eb 26                	jmp    803264 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80323e:	a1 20 40 80 00       	mov    0x804020,%eax
  803243:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803249:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80324c:	89 d0                	mov    %edx,%eax
  80324e:	01 c0                	add    %eax,%eax
  803250:	01 d0                	add    %edx,%eax
  803252:	c1 e0 03             	shl    $0x3,%eax
  803255:	01 c8                	add    %ecx,%eax
  803257:	8a 40 04             	mov    0x4(%eax),%al
  80325a:	3c 01                	cmp    $0x1,%al
  80325c:	75 03                	jne    803261 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80325e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803261:	ff 45 e0             	incl   -0x20(%ebp)
  803264:	a1 20 40 80 00       	mov    0x804020,%eax
  803269:	8b 50 74             	mov    0x74(%eax),%edx
  80326c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80326f:	39 c2                	cmp    %eax,%edx
  803271:	77 cb                	ja     80323e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803276:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803279:	74 14                	je     80328f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80327b:	83 ec 04             	sub    $0x4,%esp
  80327e:	68 68 3d 80 00       	push   $0x803d68
  803283:	6a 44                	push   $0x44
  803285:	68 08 3d 80 00       	push   $0x803d08
  80328a:	e8 23 fe ff ff       	call   8030b2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80328f:	90                   	nop
  803290:	c9                   	leave  
  803291:	c3                   	ret    
  803292:	66 90                	xchg   %ax,%ax

00803294 <__udivdi3>:
  803294:	55                   	push   %ebp
  803295:	57                   	push   %edi
  803296:	56                   	push   %esi
  803297:	53                   	push   %ebx
  803298:	83 ec 1c             	sub    $0x1c,%esp
  80329b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80329f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032ab:	89 ca                	mov    %ecx,%edx
  8032ad:	89 f8                	mov    %edi,%eax
  8032af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032b3:	85 f6                	test   %esi,%esi
  8032b5:	75 2d                	jne    8032e4 <__udivdi3+0x50>
  8032b7:	39 cf                	cmp    %ecx,%edi
  8032b9:	77 65                	ja     803320 <__udivdi3+0x8c>
  8032bb:	89 fd                	mov    %edi,%ebp
  8032bd:	85 ff                	test   %edi,%edi
  8032bf:	75 0b                	jne    8032cc <__udivdi3+0x38>
  8032c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c6:	31 d2                	xor    %edx,%edx
  8032c8:	f7 f7                	div    %edi
  8032ca:	89 c5                	mov    %eax,%ebp
  8032cc:	31 d2                	xor    %edx,%edx
  8032ce:	89 c8                	mov    %ecx,%eax
  8032d0:	f7 f5                	div    %ebp
  8032d2:	89 c1                	mov    %eax,%ecx
  8032d4:	89 d8                	mov    %ebx,%eax
  8032d6:	f7 f5                	div    %ebp
  8032d8:	89 cf                	mov    %ecx,%edi
  8032da:	89 fa                	mov    %edi,%edx
  8032dc:	83 c4 1c             	add    $0x1c,%esp
  8032df:	5b                   	pop    %ebx
  8032e0:	5e                   	pop    %esi
  8032e1:	5f                   	pop    %edi
  8032e2:	5d                   	pop    %ebp
  8032e3:	c3                   	ret    
  8032e4:	39 ce                	cmp    %ecx,%esi
  8032e6:	77 28                	ja     803310 <__udivdi3+0x7c>
  8032e8:	0f bd fe             	bsr    %esi,%edi
  8032eb:	83 f7 1f             	xor    $0x1f,%edi
  8032ee:	75 40                	jne    803330 <__udivdi3+0x9c>
  8032f0:	39 ce                	cmp    %ecx,%esi
  8032f2:	72 0a                	jb     8032fe <__udivdi3+0x6a>
  8032f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032f8:	0f 87 9e 00 00 00    	ja     80339c <__udivdi3+0x108>
  8032fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803303:	89 fa                	mov    %edi,%edx
  803305:	83 c4 1c             	add    $0x1c,%esp
  803308:	5b                   	pop    %ebx
  803309:	5e                   	pop    %esi
  80330a:	5f                   	pop    %edi
  80330b:	5d                   	pop    %ebp
  80330c:	c3                   	ret    
  80330d:	8d 76 00             	lea    0x0(%esi),%esi
  803310:	31 ff                	xor    %edi,%edi
  803312:	31 c0                	xor    %eax,%eax
  803314:	89 fa                	mov    %edi,%edx
  803316:	83 c4 1c             	add    $0x1c,%esp
  803319:	5b                   	pop    %ebx
  80331a:	5e                   	pop    %esi
  80331b:	5f                   	pop    %edi
  80331c:	5d                   	pop    %ebp
  80331d:	c3                   	ret    
  80331e:	66 90                	xchg   %ax,%ax
  803320:	89 d8                	mov    %ebx,%eax
  803322:	f7 f7                	div    %edi
  803324:	31 ff                	xor    %edi,%edi
  803326:	89 fa                	mov    %edi,%edx
  803328:	83 c4 1c             	add    $0x1c,%esp
  80332b:	5b                   	pop    %ebx
  80332c:	5e                   	pop    %esi
  80332d:	5f                   	pop    %edi
  80332e:	5d                   	pop    %ebp
  80332f:	c3                   	ret    
  803330:	bd 20 00 00 00       	mov    $0x20,%ebp
  803335:	89 eb                	mov    %ebp,%ebx
  803337:	29 fb                	sub    %edi,%ebx
  803339:	89 f9                	mov    %edi,%ecx
  80333b:	d3 e6                	shl    %cl,%esi
  80333d:	89 c5                	mov    %eax,%ebp
  80333f:	88 d9                	mov    %bl,%cl
  803341:	d3 ed                	shr    %cl,%ebp
  803343:	89 e9                	mov    %ebp,%ecx
  803345:	09 f1                	or     %esi,%ecx
  803347:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80334b:	89 f9                	mov    %edi,%ecx
  80334d:	d3 e0                	shl    %cl,%eax
  80334f:	89 c5                	mov    %eax,%ebp
  803351:	89 d6                	mov    %edx,%esi
  803353:	88 d9                	mov    %bl,%cl
  803355:	d3 ee                	shr    %cl,%esi
  803357:	89 f9                	mov    %edi,%ecx
  803359:	d3 e2                	shl    %cl,%edx
  80335b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335f:	88 d9                	mov    %bl,%cl
  803361:	d3 e8                	shr    %cl,%eax
  803363:	09 c2                	or     %eax,%edx
  803365:	89 d0                	mov    %edx,%eax
  803367:	89 f2                	mov    %esi,%edx
  803369:	f7 74 24 0c          	divl   0xc(%esp)
  80336d:	89 d6                	mov    %edx,%esi
  80336f:	89 c3                	mov    %eax,%ebx
  803371:	f7 e5                	mul    %ebp
  803373:	39 d6                	cmp    %edx,%esi
  803375:	72 19                	jb     803390 <__udivdi3+0xfc>
  803377:	74 0b                	je     803384 <__udivdi3+0xf0>
  803379:	89 d8                	mov    %ebx,%eax
  80337b:	31 ff                	xor    %edi,%edi
  80337d:	e9 58 ff ff ff       	jmp    8032da <__udivdi3+0x46>
  803382:	66 90                	xchg   %ax,%ax
  803384:	8b 54 24 08          	mov    0x8(%esp),%edx
  803388:	89 f9                	mov    %edi,%ecx
  80338a:	d3 e2                	shl    %cl,%edx
  80338c:	39 c2                	cmp    %eax,%edx
  80338e:	73 e9                	jae    803379 <__udivdi3+0xe5>
  803390:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803393:	31 ff                	xor    %edi,%edi
  803395:	e9 40 ff ff ff       	jmp    8032da <__udivdi3+0x46>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	31 c0                	xor    %eax,%eax
  80339e:	e9 37 ff ff ff       	jmp    8032da <__udivdi3+0x46>
  8033a3:	90                   	nop

008033a4 <__umoddi3>:
  8033a4:	55                   	push   %ebp
  8033a5:	57                   	push   %edi
  8033a6:	56                   	push   %esi
  8033a7:	53                   	push   %ebx
  8033a8:	83 ec 1c             	sub    $0x1c,%esp
  8033ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033c3:	89 f3                	mov    %esi,%ebx
  8033c5:	89 fa                	mov    %edi,%edx
  8033c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033cb:	89 34 24             	mov    %esi,(%esp)
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	75 1a                	jne    8033ec <__umoddi3+0x48>
  8033d2:	39 f7                	cmp    %esi,%edi
  8033d4:	0f 86 a2 00 00 00    	jbe    80347c <__umoddi3+0xd8>
  8033da:	89 c8                	mov    %ecx,%eax
  8033dc:	89 f2                	mov    %esi,%edx
  8033de:	f7 f7                	div    %edi
  8033e0:	89 d0                	mov    %edx,%eax
  8033e2:	31 d2                	xor    %edx,%edx
  8033e4:	83 c4 1c             	add    $0x1c,%esp
  8033e7:	5b                   	pop    %ebx
  8033e8:	5e                   	pop    %esi
  8033e9:	5f                   	pop    %edi
  8033ea:	5d                   	pop    %ebp
  8033eb:	c3                   	ret    
  8033ec:	39 f0                	cmp    %esi,%eax
  8033ee:	0f 87 ac 00 00 00    	ja     8034a0 <__umoddi3+0xfc>
  8033f4:	0f bd e8             	bsr    %eax,%ebp
  8033f7:	83 f5 1f             	xor    $0x1f,%ebp
  8033fa:	0f 84 ac 00 00 00    	je     8034ac <__umoddi3+0x108>
  803400:	bf 20 00 00 00       	mov    $0x20,%edi
  803405:	29 ef                	sub    %ebp,%edi
  803407:	89 fe                	mov    %edi,%esi
  803409:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80340d:	89 e9                	mov    %ebp,%ecx
  80340f:	d3 e0                	shl    %cl,%eax
  803411:	89 d7                	mov    %edx,%edi
  803413:	89 f1                	mov    %esi,%ecx
  803415:	d3 ef                	shr    %cl,%edi
  803417:	09 c7                	or     %eax,%edi
  803419:	89 e9                	mov    %ebp,%ecx
  80341b:	d3 e2                	shl    %cl,%edx
  80341d:	89 14 24             	mov    %edx,(%esp)
  803420:	89 d8                	mov    %ebx,%eax
  803422:	d3 e0                	shl    %cl,%eax
  803424:	89 c2                	mov    %eax,%edx
  803426:	8b 44 24 08          	mov    0x8(%esp),%eax
  80342a:	d3 e0                	shl    %cl,%eax
  80342c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803430:	8b 44 24 08          	mov    0x8(%esp),%eax
  803434:	89 f1                	mov    %esi,%ecx
  803436:	d3 e8                	shr    %cl,%eax
  803438:	09 d0                	or     %edx,%eax
  80343a:	d3 eb                	shr    %cl,%ebx
  80343c:	89 da                	mov    %ebx,%edx
  80343e:	f7 f7                	div    %edi
  803440:	89 d3                	mov    %edx,%ebx
  803442:	f7 24 24             	mull   (%esp)
  803445:	89 c6                	mov    %eax,%esi
  803447:	89 d1                	mov    %edx,%ecx
  803449:	39 d3                	cmp    %edx,%ebx
  80344b:	0f 82 87 00 00 00    	jb     8034d8 <__umoddi3+0x134>
  803451:	0f 84 91 00 00 00    	je     8034e8 <__umoddi3+0x144>
  803457:	8b 54 24 04          	mov    0x4(%esp),%edx
  80345b:	29 f2                	sub    %esi,%edx
  80345d:	19 cb                	sbb    %ecx,%ebx
  80345f:	89 d8                	mov    %ebx,%eax
  803461:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803465:	d3 e0                	shl    %cl,%eax
  803467:	89 e9                	mov    %ebp,%ecx
  803469:	d3 ea                	shr    %cl,%edx
  80346b:	09 d0                	or     %edx,%eax
  80346d:	89 e9                	mov    %ebp,%ecx
  80346f:	d3 eb                	shr    %cl,%ebx
  803471:	89 da                	mov    %ebx,%edx
  803473:	83 c4 1c             	add    $0x1c,%esp
  803476:	5b                   	pop    %ebx
  803477:	5e                   	pop    %esi
  803478:	5f                   	pop    %edi
  803479:	5d                   	pop    %ebp
  80347a:	c3                   	ret    
  80347b:	90                   	nop
  80347c:	89 fd                	mov    %edi,%ebp
  80347e:	85 ff                	test   %edi,%edi
  803480:	75 0b                	jne    80348d <__umoddi3+0xe9>
  803482:	b8 01 00 00 00       	mov    $0x1,%eax
  803487:	31 d2                	xor    %edx,%edx
  803489:	f7 f7                	div    %edi
  80348b:	89 c5                	mov    %eax,%ebp
  80348d:	89 f0                	mov    %esi,%eax
  80348f:	31 d2                	xor    %edx,%edx
  803491:	f7 f5                	div    %ebp
  803493:	89 c8                	mov    %ecx,%eax
  803495:	f7 f5                	div    %ebp
  803497:	89 d0                	mov    %edx,%eax
  803499:	e9 44 ff ff ff       	jmp    8033e2 <__umoddi3+0x3e>
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	89 c8                	mov    %ecx,%eax
  8034a2:	89 f2                	mov    %esi,%edx
  8034a4:	83 c4 1c             	add    $0x1c,%esp
  8034a7:	5b                   	pop    %ebx
  8034a8:	5e                   	pop    %esi
  8034a9:	5f                   	pop    %edi
  8034aa:	5d                   	pop    %ebp
  8034ab:	c3                   	ret    
  8034ac:	3b 04 24             	cmp    (%esp),%eax
  8034af:	72 06                	jb     8034b7 <__umoddi3+0x113>
  8034b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034b5:	77 0f                	ja     8034c6 <__umoddi3+0x122>
  8034b7:	89 f2                	mov    %esi,%edx
  8034b9:	29 f9                	sub    %edi,%ecx
  8034bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034bf:	89 14 24             	mov    %edx,(%esp)
  8034c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034ca:	8b 14 24             	mov    (%esp),%edx
  8034cd:	83 c4 1c             	add    $0x1c,%esp
  8034d0:	5b                   	pop    %ebx
  8034d1:	5e                   	pop    %esi
  8034d2:	5f                   	pop    %edi
  8034d3:	5d                   	pop    %ebp
  8034d4:	c3                   	ret    
  8034d5:	8d 76 00             	lea    0x0(%esi),%esi
  8034d8:	2b 04 24             	sub    (%esp),%eax
  8034db:	19 fa                	sbb    %edi,%edx
  8034dd:	89 d1                	mov    %edx,%ecx
  8034df:	89 c6                	mov    %eax,%esi
  8034e1:	e9 71 ff ff ff       	jmp    803457 <__umoddi3+0xb3>
  8034e6:	66 90                	xchg   %ax,%ax
  8034e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034ec:	72 ea                	jb     8034d8 <__umoddi3+0x134>
  8034ee:	89 d9                	mov    %ebx,%ecx
  8034f0:	e9 62 ff ff ff       	jmp    803457 <__umoddi3+0xb3>
