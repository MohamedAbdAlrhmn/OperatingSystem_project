
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
  80005c:	68 60 35 80 00       	push   $0x803560
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
  8000b9:	68 73 35 80 00       	push   $0x803573
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
  80010f:	68 73 35 80 00       	push   $0x803573
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
  80013e:	e8 f5 16 00 00       	call   801838 <sys_getenvindex>
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
  8001a9:	e8 97 14 00 00       	call   801645 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 98 35 80 00       	push   $0x803598
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
  8001d9:	68 c0 35 80 00       	push   $0x8035c0
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
  80020a:	68 e8 35 80 00       	push   $0x8035e8
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 40 36 80 00       	push   $0x803640
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 98 35 80 00       	push   $0x803598
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 17 14 00 00       	call   80165f <sys_enable_interrupt>

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
  80025b:	e8 a4 15 00 00       	call   801804 <sys_destroy_env>
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
  80026c:	e8 f9 15 00 00       	call   80186a <sys_exit_env>
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
  8002ba:	e8 d8 11 00 00       	call   801497 <sys_cputs>
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
  800331:	e8 61 11 00 00       	call   801497 <sys_cputs>
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
  80037b:	e8 c5 12 00 00       	call   801645 <sys_disable_interrupt>
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
  80039b:	e8 bf 12 00 00       	call   80165f <sys_enable_interrupt>
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
  8003e5:	e8 12 2f 00 00       	call   8032fc <__udivdi3>
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
  800435:	e8 d2 2f 00 00       	call   80340c <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 74 38 80 00       	add    $0x803874,%eax
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
  800590:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
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
  800671:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 85 38 80 00       	push   $0x803885
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
  800696:	68 8e 38 80 00       	push   $0x80388e
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
  8006c3:	be 91 38 80 00       	mov    $0x803891,%esi
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
  8010e9:	68 f0 39 80 00       	push   $0x8039f0
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
  8011b9:	e8 1d 04 00 00       	call   8015db <sys_allocate_chunk>
  8011be:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c1:	a1 20 41 80 00       	mov    0x804120,%eax
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 92 0a 00 00       	call   801c61 <initialize_MemBlocksList>
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
  8011f7:	68 15 3a 80 00       	push   $0x803a15
  8011fc:	6a 33                	push   $0x33
  8011fe:	68 33 3a 80 00       	push   $0x803a33
  801203:	e8 12 1f 00 00       	call   80311a <_panic>
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
  801276:	68 40 3a 80 00       	push   $0x803a40
  80127b:	6a 34                	push   $0x34
  80127d:	68 33 3a 80 00       	push   $0x803a33
  801282:	e8 93 1e 00 00       	call   80311a <_panic>
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
  8012eb:	68 64 3a 80 00       	push   $0x803a64
  8012f0:	6a 46                	push   $0x46
  8012f2:	68 33 3a 80 00       	push   $0x803a33
  8012f7:	e8 1e 1e 00 00       	call   80311a <_panic>
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
  801307:	68 8c 3a 80 00       	push   $0x803a8c
  80130c:	6a 61                	push   $0x61
  80130e:	68 33 3a 80 00       	push   $0x803a33
  801313:	e8 02 1e 00 00       	call   80311a <_panic>

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
  80132d:	75 07                	jne    801336 <smalloc+0x1e>
  80132f:	b8 00 00 00 00       	mov    $0x0,%eax
  801334:	eb 7c                	jmp    8013b2 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801336:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	48                   	dec    %eax
  801346:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134c:	ba 00 00 00 00       	mov    $0x0,%edx
  801351:	f7 75 f0             	divl   -0x10(%ebp)
  801354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801357:	29 d0                	sub    %edx,%eax
  801359:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80135c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801363:	e8 41 06 00 00       	call   8019a9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801368:	85 c0                	test   %eax,%eax
  80136a:	74 11                	je     80137d <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	ff 75 e8             	pushl  -0x18(%ebp)
  801372:	e8 ac 0c 00 00       	call   802023 <alloc_block_FF>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	74 2a                	je     8013ad <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801386:	8b 40 08             	mov    0x8(%eax),%eax
  801389:	89 c2                	mov    %eax,%edx
  80138b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80138f:	52                   	push   %edx
  801390:	50                   	push   %eax
  801391:	ff 75 0c             	pushl  0xc(%ebp)
  801394:	ff 75 08             	pushl  0x8(%ebp)
  801397:	e8 92 03 00 00       	call   80172e <sys_createSharedObject>
  80139c:	83 c4 10             	add    $0x10,%esp
  80139f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8013a2:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8013a6:	74 05                	je     8013ad <smalloc+0x95>
			return (void*)virtual_address;
  8013a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ab:	eb 05                	jmp    8013b2 <smalloc+0x9a>
	}
	return NULL;
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013ba:	e8 13 fd ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8013bf:	83 ec 04             	sub    $0x4,%esp
  8013c2:	68 b0 3a 80 00       	push   $0x803ab0
  8013c7:	68 a2 00 00 00       	push   $0xa2
  8013cc:	68 33 3a 80 00       	push   $0x803a33
  8013d1:	e8 44 1d 00 00       	call   80311a <_panic>

008013d6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8013dc:	e8 f1 fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013e1:	83 ec 04             	sub    $0x4,%esp
  8013e4:	68 d4 3a 80 00       	push   $0x803ad4
  8013e9:	68 e6 00 00 00       	push   $0xe6
  8013ee:	68 33 3a 80 00       	push   $0x803a33
  8013f3:	e8 22 1d 00 00       	call   80311a <_panic>

008013f8 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8013f8:	55                   	push   %ebp
  8013f9:	89 e5                	mov    %esp,%ebp
  8013fb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	68 fc 3a 80 00       	push   $0x803afc
  801406:	68 fa 00 00 00       	push   $0xfa
  80140b:	68 33 3a 80 00       	push   $0x803a33
  801410:	e8 05 1d 00 00       	call   80311a <_panic>

00801415 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	68 20 3b 80 00       	push   $0x803b20
  801423:	68 05 01 00 00       	push   $0x105
  801428:	68 33 3a 80 00       	push   $0x803a33
  80142d:	e8 e8 1c 00 00       	call   80311a <_panic>

00801432 <shrink>:

}
void shrink(uint32 newSize)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801438:	83 ec 04             	sub    $0x4,%esp
  80143b:	68 20 3b 80 00       	push   $0x803b20
  801440:	68 0a 01 00 00       	push   $0x10a
  801445:	68 33 3a 80 00       	push   $0x803a33
  80144a:	e8 cb 1c 00 00       	call   80311a <_panic>

0080144f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	68 20 3b 80 00       	push   $0x803b20
  80145d:	68 0f 01 00 00       	push   $0x10f
  801462:	68 33 3a 80 00       	push   $0x803a33
  801467:	e8 ae 1c 00 00       	call   80311a <_panic>

0080146c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	57                   	push   %edi
  801470:	56                   	push   %esi
  801471:	53                   	push   %ebx
  801472:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80147e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801481:	8b 7d 18             	mov    0x18(%ebp),%edi
  801484:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801487:	cd 30                	int    $0x30
  801489:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80148c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80148f:	83 c4 10             	add    $0x10,%esp
  801492:	5b                   	pop    %ebx
  801493:	5e                   	pop    %esi
  801494:	5f                   	pop    %edi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014a3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	52                   	push   %edx
  8014af:	ff 75 0c             	pushl  0xc(%ebp)
  8014b2:	50                   	push   %eax
  8014b3:	6a 00                	push   $0x0
  8014b5:	e8 b2 ff ff ff       	call   80146c <syscall>
  8014ba:	83 c4 18             	add    $0x18,%esp
}
  8014bd:	90                   	nop
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	6a 00                	push   $0x0
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 01                	push   $0x1
  8014cf:	e8 98 ff ff ff       	call   80146c <syscall>
  8014d4:	83 c4 18             	add    $0x18,%esp
}
  8014d7:	c9                   	leave  
  8014d8:	c3                   	ret    

008014d9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8014dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014df:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	52                   	push   %edx
  8014e9:	50                   	push   %eax
  8014ea:	6a 05                	push   $0x5
  8014ec:	e8 7b ff ff ff       	call   80146c <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	c9                   	leave  
  8014f5:	c3                   	ret    

008014f6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	56                   	push   %esi
  8014fa:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014fb:	8b 75 18             	mov    0x18(%ebp),%esi
  8014fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801501:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	56                   	push   %esi
  80150b:	53                   	push   %ebx
  80150c:	51                   	push   %ecx
  80150d:	52                   	push   %edx
  80150e:	50                   	push   %eax
  80150f:	6a 06                	push   $0x6
  801511:	e8 56 ff ff ff       	call   80146c <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801523:	8b 55 0c             	mov    0xc(%ebp),%edx
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 00                	push   $0x0
  80152f:	52                   	push   %edx
  801530:	50                   	push   %eax
  801531:	6a 07                	push   $0x7
  801533:	e8 34 ff ff ff       	call   80146c <syscall>
  801538:	83 c4 18             	add    $0x18,%esp
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801540:	6a 00                	push   $0x0
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	ff 75 0c             	pushl  0xc(%ebp)
  801549:	ff 75 08             	pushl  0x8(%ebp)
  80154c:	6a 08                	push   $0x8
  80154e:	e8 19 ff ff ff       	call   80146c <syscall>
  801553:	83 c4 18             	add    $0x18,%esp
}
  801556:	c9                   	leave  
  801557:	c3                   	ret    

00801558 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801558:	55                   	push   %ebp
  801559:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 09                	push   $0x9
  801567:	e8 00 ff ff ff       	call   80146c <syscall>
  80156c:	83 c4 18             	add    $0x18,%esp
}
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801574:	6a 00                	push   $0x0
  801576:	6a 00                	push   $0x0
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 0a                	push   $0xa
  801580:	e8 e7 fe ff ff       	call   80146c <syscall>
  801585:	83 c4 18             	add    $0x18,%esp
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80158d:	6a 00                	push   $0x0
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 0b                	push   $0xb
  801599:	e8 ce fe ff ff       	call   80146c <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	6a 0f                	push   $0xf
  8015b4:	e8 b3 fe ff ff       	call   80146c <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
	return;
  8015bc:	90                   	nop
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	ff 75 0c             	pushl  0xc(%ebp)
  8015cb:	ff 75 08             	pushl  0x8(%ebp)
  8015ce:	6a 10                	push   $0x10
  8015d0:	e8 97 fe ff ff       	call   80146c <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8015d8:	90                   	nop
}
  8015d9:	c9                   	leave  
  8015da:	c3                   	ret    

008015db <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8015db:	55                   	push   %ebp
  8015dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	ff 75 10             	pushl  0x10(%ebp)
  8015e5:	ff 75 0c             	pushl  0xc(%ebp)
  8015e8:	ff 75 08             	pushl  0x8(%ebp)
  8015eb:	6a 11                	push   $0x11
  8015ed:	e8 7a fe ff ff       	call   80146c <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8015f5:	90                   	nop
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 0c                	push   $0xc
  801607:	e8 60 fe ff ff       	call   80146c <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	ff 75 08             	pushl  0x8(%ebp)
  80161f:	6a 0d                	push   $0xd
  801621:	e8 46 fe ff ff       	call   80146c <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 0e                	push   $0xe
  80163a:	e8 2d fe ff ff       	call   80146c <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	90                   	nop
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	6a 00                	push   $0x0
  801652:	6a 13                	push   $0x13
  801654:	e8 13 fe ff ff       	call   80146c <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
}
  80165c:	90                   	nop
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 14                	push   $0x14
  80166e:	e8 f9 fd ff ff       	call   80146c <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
}
  801676:	90                   	nop
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_cputc>:


void
sys_cputc(const char c)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801685:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	50                   	push   %eax
  801692:	6a 15                	push   $0x15
  801694:	e8 d3 fd ff ff       	call   80146c <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
}
  80169c:	90                   	nop
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 16                	push   $0x16
  8016ae:	e8 b9 fd ff ff       	call   80146c <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	50                   	push   %eax
  8016c9:	6a 17                	push   $0x17
  8016cb:	e8 9c fd ff ff       	call   80146c <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 1a                	push   $0x1a
  8016e8:	e8 7f fd ff ff       	call   80146c <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	52                   	push   %edx
  801702:	50                   	push   %eax
  801703:	6a 18                	push   $0x18
  801705:	e8 62 fd ff ff       	call   80146c <syscall>
  80170a:	83 c4 18             	add    $0x18,%esp
}
  80170d:	90                   	nop
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	52                   	push   %edx
  801720:	50                   	push   %eax
  801721:	6a 19                	push   $0x19
  801723:	e8 44 fd ff ff       	call   80146c <syscall>
  801728:	83 c4 18             	add    $0x18,%esp
}
  80172b:	90                   	nop
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 04             	sub    $0x4,%esp
  801734:	8b 45 10             	mov    0x10(%ebp),%eax
  801737:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80173a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80173d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	6a 00                	push   $0x0
  801746:	51                   	push   %ecx
  801747:	52                   	push   %edx
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	50                   	push   %eax
  80174c:	6a 1b                	push   $0x1b
  80174e:	e8 19 fd ff ff       	call   80146c <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80175b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	52                   	push   %edx
  801768:	50                   	push   %eax
  801769:	6a 1c                	push   $0x1c
  80176b:	e8 fc fc ff ff       	call   80146c <syscall>
  801770:	83 c4 18             	add    $0x18,%esp
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801778:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	51                   	push   %ecx
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 1d                	push   $0x1d
  80178a:	e8 dd fc ff ff       	call   80146c <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801797:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	52                   	push   %edx
  8017a4:	50                   	push   %eax
  8017a5:	6a 1e                	push   $0x1e
  8017a7:	e8 c0 fc ff ff       	call   80146c <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
}
  8017af:	c9                   	leave  
  8017b0:	c3                   	ret    

008017b1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017b4:	6a 00                	push   $0x0
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 1f                	push   $0x1f
  8017c0:	e8 a7 fc ff ff       	call   80146c <syscall>
  8017c5:	83 c4 18             	add    $0x18,%esp
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	ff 75 14             	pushl  0x14(%ebp)
  8017d5:	ff 75 10             	pushl  0x10(%ebp)
  8017d8:	ff 75 0c             	pushl  0xc(%ebp)
  8017db:	50                   	push   %eax
  8017dc:	6a 20                	push   $0x20
  8017de:	e8 89 fc ff ff       	call   80146c <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	50                   	push   %eax
  8017f7:	6a 21                	push   $0x21
  8017f9:	e8 6e fc ff ff       	call   80146c <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	90                   	nop
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	6a 00                	push   $0x0
  80180c:	6a 00                	push   $0x0
  80180e:	6a 00                	push   $0x0
  801810:	6a 00                	push   $0x0
  801812:	50                   	push   %eax
  801813:	6a 22                	push   $0x22
  801815:	e8 52 fc ff ff       	call   80146c <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 02                	push   $0x2
  80182e:	e8 39 fc ff ff       	call   80146c <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 03                	push   $0x3
  801847:	e8 20 fc ff ff       	call   80146c <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 04                	push   $0x4
  801860:	e8 07 fc ff ff       	call   80146c <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_exit_env>:


void sys_exit_env(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 23                	push   $0x23
  801879:	e8 ee fb ff ff       	call   80146c <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	90                   	nop
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80188a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80188d:	8d 50 04             	lea    0x4(%eax),%edx
  801890:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	52                   	push   %edx
  80189a:	50                   	push   %eax
  80189b:	6a 24                	push   $0x24
  80189d:	e8 ca fb ff ff       	call   80146c <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
	return result;
  8018a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018ae:	89 01                	mov    %eax,(%ecx)
  8018b0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	c9                   	leave  
  8018b7:	c2 04 00             	ret    $0x4

008018ba <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	ff 75 10             	pushl  0x10(%ebp)
  8018c4:	ff 75 0c             	pushl  0xc(%ebp)
  8018c7:	ff 75 08             	pushl  0x8(%ebp)
  8018ca:	6a 12                	push   $0x12
  8018cc:	e8 9b fb ff ff       	call   80146c <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d4:	90                   	nop
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 25                	push   $0x25
  8018e6:	e8 81 fb ff ff       	call   80146c <syscall>
  8018eb:	83 c4 18             	add    $0x18,%esp
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018fc:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	50                   	push   %eax
  801909:	6a 26                	push   $0x26
  80190b:	e8 5c fb ff ff       	call   80146c <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return ;
  801913:	90                   	nop
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <rsttst>:
void rsttst()
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 28                	push   $0x28
  801925:	e8 42 fb ff ff       	call   80146c <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return ;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	8b 45 14             	mov    0x14(%ebp),%eax
  801939:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80193c:	8b 55 18             	mov    0x18(%ebp),%edx
  80193f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	ff 75 10             	pushl  0x10(%ebp)
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 27                	push   $0x27
  801950:	e8 17 fb ff ff       	call   80146c <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <chktst>:
void chktst(uint32 n)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	ff 75 08             	pushl  0x8(%ebp)
  801969:	6a 29                	push   $0x29
  80196b:	e8 fc fa ff ff       	call   80146c <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return ;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <inctst>:

void inctst()
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 2a                	push   $0x2a
  801985:	e8 e2 fa ff ff       	call   80146c <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <gettst>:
uint32 gettst()
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 2b                	push   $0x2b
  80199f:	e8 c8 fa ff ff       	call   80146c <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 2c                	push   $0x2c
  8019bb:	e8 ac fa ff ff       	call   80146c <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
  8019c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019c6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019ca:	75 07                	jne    8019d3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8019cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8019d1:	eb 05                	jmp    8019d8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8019d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 2c                	push   $0x2c
  8019ec:	e8 7b fa ff ff       	call   80146c <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
  8019f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019f7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019fb:	75 07                	jne    801a04 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019fd:	b8 01 00 00 00       	mov    $0x1,%eax
  801a02:	eb 05                	jmp    801a09 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 2c                	push   $0x2c
  801a1d:	e8 4a fa ff ff       	call   80146c <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
  801a25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a28:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a2c:	75 07                	jne    801a35 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a33:	eb 05                	jmp    801a3a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 2c                	push   $0x2c
  801a4e:	e8 19 fa ff ff       	call   80146c <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
  801a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a59:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a5d:	75 07                	jne    801a66 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a5f:	b8 01 00 00 00       	mov    $0x1,%eax
  801a64:	eb 05                	jmp    801a6b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 08             	pushl  0x8(%ebp)
  801a7b:	6a 2d                	push   $0x2d
  801a7d:	e8 ea f9 ff ff       	call   80146c <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
	return ;
  801a85:	90                   	nop
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a8c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	53                   	push   %ebx
  801a9b:	51                   	push   %ecx
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 2e                	push   $0x2e
  801aa0:	e8 c7 f9 ff ff       	call   80146c <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 2f                	push   $0x2f
  801ac0:	e8 a7 f9 ff ff       	call   80146c <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ad0:	83 ec 0c             	sub    $0xc,%esp
  801ad3:	68 30 3b 80 00       	push   $0x803b30
  801ad8:	e8 6b e8 ff ff       	call   800348 <cprintf>
  801add:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ae0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	68 5c 3b 80 00       	push   $0x803b5c
  801aef:	e8 54 e8 ff ff       	call   800348 <cprintf>
  801af4:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801af7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801afb:	a1 38 41 80 00       	mov    0x804138,%eax
  801b00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b03:	eb 56                	jmp    801b5b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801b05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b09:	74 1c                	je     801b27 <print_mem_block_lists+0x5d>
  801b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0e:	8b 50 08             	mov    0x8(%eax),%edx
  801b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b14:	8b 48 08             	mov    0x8(%eax),%ecx
  801b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1d:	01 c8                	add    %ecx,%eax
  801b1f:	39 c2                	cmp    %eax,%edx
  801b21:	73 04                	jae    801b27 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801b23:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2a:	8b 50 08             	mov    0x8(%eax),%edx
  801b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b30:	8b 40 0c             	mov    0xc(%eax),%eax
  801b33:	01 c2                	add    %eax,%edx
  801b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b38:	8b 40 08             	mov    0x8(%eax),%eax
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	52                   	push   %edx
  801b3f:	50                   	push   %eax
  801b40:	68 71 3b 80 00       	push   $0x803b71
  801b45:	e8 fe e7 ff ff       	call   800348 <cprintf>
  801b4a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801b53:	a1 40 41 80 00       	mov    0x804140,%eax
  801b58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b5f:	74 07                	je     801b68 <print_mem_block_lists+0x9e>
  801b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b64:	8b 00                	mov    (%eax),%eax
  801b66:	eb 05                	jmp    801b6d <print_mem_block_lists+0xa3>
  801b68:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6d:	a3 40 41 80 00       	mov    %eax,0x804140
  801b72:	a1 40 41 80 00       	mov    0x804140,%eax
  801b77:	85 c0                	test   %eax,%eax
  801b79:	75 8a                	jne    801b05 <print_mem_block_lists+0x3b>
  801b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b7f:	75 84                	jne    801b05 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801b81:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801b85:	75 10                	jne    801b97 <print_mem_block_lists+0xcd>
  801b87:	83 ec 0c             	sub    $0xc,%esp
  801b8a:	68 80 3b 80 00       	push   $0x803b80
  801b8f:	e8 b4 e7 ff ff       	call   800348 <cprintf>
  801b94:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801b97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801b9e:	83 ec 0c             	sub    $0xc,%esp
  801ba1:	68 a4 3b 80 00       	push   $0x803ba4
  801ba6:	e8 9d e7 ff ff       	call   800348 <cprintf>
  801bab:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801bae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801bb2:	a1 40 40 80 00       	mov    0x804040,%eax
  801bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bba:	eb 56                	jmp    801c12 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801bbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bc0:	74 1c                	je     801bde <print_mem_block_lists+0x114>
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	8b 50 08             	mov    0x8(%eax),%edx
  801bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bcb:	8b 48 08             	mov    0x8(%eax),%ecx
  801bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd4:	01 c8                	add    %ecx,%eax
  801bd6:	39 c2                	cmp    %eax,%edx
  801bd8:	73 04                	jae    801bde <print_mem_block_lists+0x114>
			sorted = 0 ;
  801bda:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be1:	8b 50 08             	mov    0x8(%eax),%edx
  801be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be7:	8b 40 0c             	mov    0xc(%eax),%eax
  801bea:	01 c2                	add    %eax,%edx
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	8b 40 08             	mov    0x8(%eax),%eax
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	68 71 3b 80 00       	push   $0x803b71
  801bfc:	e8 47 e7 ff ff       	call   800348 <cprintf>
  801c01:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c0a:	a1 48 40 80 00       	mov    0x804048,%eax
  801c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c16:	74 07                	je     801c1f <print_mem_block_lists+0x155>
  801c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1b:	8b 00                	mov    (%eax),%eax
  801c1d:	eb 05                	jmp    801c24 <print_mem_block_lists+0x15a>
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c24:	a3 48 40 80 00       	mov    %eax,0x804048
  801c29:	a1 48 40 80 00       	mov    0x804048,%eax
  801c2e:	85 c0                	test   %eax,%eax
  801c30:	75 8a                	jne    801bbc <print_mem_block_lists+0xf2>
  801c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c36:	75 84                	jne    801bbc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801c38:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c3c:	75 10                	jne    801c4e <print_mem_block_lists+0x184>
  801c3e:	83 ec 0c             	sub    $0xc,%esp
  801c41:	68 bc 3b 80 00       	push   $0x803bbc
  801c46:	e8 fd e6 ff ff       	call   800348 <cprintf>
  801c4b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	68 30 3b 80 00       	push   $0x803b30
  801c56:	e8 ed e6 ff ff       	call   800348 <cprintf>
  801c5b:	83 c4 10             	add    $0x10,%esp

}
  801c5e:	90                   	nop
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801c67:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801c6e:	00 00 00 
  801c71:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801c78:	00 00 00 
  801c7b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801c82:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801c85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801c8c:	e9 9e 00 00 00       	jmp    801d2f <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801c91:	a1 50 40 80 00       	mov    0x804050,%eax
  801c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c99:	c1 e2 04             	shl    $0x4,%edx
  801c9c:	01 d0                	add    %edx,%eax
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	75 14                	jne    801cb6 <initialize_MemBlocksList+0x55>
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	68 e4 3b 80 00       	push   $0x803be4
  801caa:	6a 46                	push   $0x46
  801cac:	68 07 3c 80 00       	push   $0x803c07
  801cb1:	e8 64 14 00 00       	call   80311a <_panic>
  801cb6:	a1 50 40 80 00       	mov    0x804050,%eax
  801cbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cbe:	c1 e2 04             	shl    $0x4,%edx
  801cc1:	01 d0                	add    %edx,%eax
  801cc3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801cc9:	89 10                	mov    %edx,(%eax)
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	74 18                	je     801ce9 <initialize_MemBlocksList+0x88>
  801cd1:	a1 48 41 80 00       	mov    0x804148,%eax
  801cd6:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801cdc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801cdf:	c1 e1 04             	shl    $0x4,%ecx
  801ce2:	01 ca                	add    %ecx,%edx
  801ce4:	89 50 04             	mov    %edx,0x4(%eax)
  801ce7:	eb 12                	jmp    801cfb <initialize_MemBlocksList+0x9a>
  801ce9:	a1 50 40 80 00       	mov    0x804050,%eax
  801cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf1:	c1 e2 04             	shl    $0x4,%edx
  801cf4:	01 d0                	add    %edx,%eax
  801cf6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801cfb:	a1 50 40 80 00       	mov    0x804050,%eax
  801d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d03:	c1 e2 04             	shl    $0x4,%edx
  801d06:	01 d0                	add    %edx,%eax
  801d08:	a3 48 41 80 00       	mov    %eax,0x804148
  801d0d:	a1 50 40 80 00       	mov    0x804050,%eax
  801d12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d15:	c1 e2 04             	shl    $0x4,%edx
  801d18:	01 d0                	add    %edx,%eax
  801d1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d21:	a1 54 41 80 00       	mov    0x804154,%eax
  801d26:	40                   	inc    %eax
  801d27:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801d2c:	ff 45 f4             	incl   -0xc(%ebp)
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d35:	0f 82 56 ff ff ff    	jb     801c91 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801d3b:	90                   	nop
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
  801d41:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	8b 00                	mov    (%eax),%eax
  801d49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d4c:	eb 19                	jmp    801d67 <find_block+0x29>
	{
		if(va==point->sva)
  801d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d51:	8b 40 08             	mov    0x8(%eax),%eax
  801d54:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801d57:	75 05                	jne    801d5e <find_block+0x20>
		   return point;
  801d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d5c:	eb 36                	jmp    801d94 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	8b 40 08             	mov    0x8(%eax),%eax
  801d64:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801d67:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d6b:	74 07                	je     801d74 <find_block+0x36>
  801d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801d70:	8b 00                	mov    (%eax),%eax
  801d72:	eb 05                	jmp    801d79 <find_block+0x3b>
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
  801d79:	8b 55 08             	mov    0x8(%ebp),%edx
  801d7c:	89 42 08             	mov    %eax,0x8(%edx)
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	8b 40 08             	mov    0x8(%eax),%eax
  801d85:	85 c0                	test   %eax,%eax
  801d87:	75 c5                	jne    801d4e <find_block+0x10>
  801d89:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d8d:	75 bf                	jne    801d4e <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801d9c:	a1 40 40 80 00       	mov    0x804040,%eax
  801da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801da4:	a1 44 40 80 00       	mov    0x804044,%eax
  801da9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801db2:	74 24                	je     801dd8 <insert_sorted_allocList+0x42>
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	8b 50 08             	mov    0x8(%eax),%edx
  801dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbd:	8b 40 08             	mov    0x8(%eax),%eax
  801dc0:	39 c2                	cmp    %eax,%edx
  801dc2:	76 14                	jbe    801dd8 <insert_sorted_allocList+0x42>
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	8b 50 08             	mov    0x8(%eax),%edx
  801dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcd:	8b 40 08             	mov    0x8(%eax),%eax
  801dd0:	39 c2                	cmp    %eax,%edx
  801dd2:	0f 82 60 01 00 00    	jb     801f38 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801dd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ddc:	75 65                	jne    801e43 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801dde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801de2:	75 14                	jne    801df8 <insert_sorted_allocList+0x62>
  801de4:	83 ec 04             	sub    $0x4,%esp
  801de7:	68 e4 3b 80 00       	push   $0x803be4
  801dec:	6a 6b                	push   $0x6b
  801dee:	68 07 3c 80 00       	push   $0x803c07
  801df3:	e8 22 13 00 00       	call   80311a <_panic>
  801df8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	89 10                	mov    %edx,(%eax)
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	8b 00                	mov    (%eax),%eax
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	74 0d                	je     801e19 <insert_sorted_allocList+0x83>
  801e0c:	a1 40 40 80 00       	mov    0x804040,%eax
  801e11:	8b 55 08             	mov    0x8(%ebp),%edx
  801e14:	89 50 04             	mov    %edx,0x4(%eax)
  801e17:	eb 08                	jmp    801e21 <insert_sorted_allocList+0x8b>
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	a3 44 40 80 00       	mov    %eax,0x804044
  801e21:	8b 45 08             	mov    0x8(%ebp),%eax
  801e24:	a3 40 40 80 00       	mov    %eax,0x804040
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e33:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801e38:	40                   	inc    %eax
  801e39:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801e3e:	e9 dc 01 00 00       	jmp    80201f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	8b 50 08             	mov    0x8(%eax),%edx
  801e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4c:	8b 40 08             	mov    0x8(%eax),%eax
  801e4f:	39 c2                	cmp    %eax,%edx
  801e51:	77 6c                	ja     801ebf <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801e53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e57:	74 06                	je     801e5f <insert_sorted_allocList+0xc9>
  801e59:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e5d:	75 14                	jne    801e73 <insert_sorted_allocList+0xdd>
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	68 20 3c 80 00       	push   $0x803c20
  801e67:	6a 6f                	push   $0x6f
  801e69:	68 07 3c 80 00       	push   $0x803c07
  801e6e:	e8 a7 12 00 00       	call   80311a <_panic>
  801e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e76:	8b 50 04             	mov    0x4(%eax),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	89 50 04             	mov    %edx,0x4(%eax)
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e85:	89 10                	mov    %edx,(%eax)
  801e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8a:	8b 40 04             	mov    0x4(%eax),%eax
  801e8d:	85 c0                	test   %eax,%eax
  801e8f:	74 0d                	je     801e9e <insert_sorted_allocList+0x108>
  801e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e94:	8b 40 04             	mov    0x4(%eax),%eax
  801e97:	8b 55 08             	mov    0x8(%ebp),%edx
  801e9a:	89 10                	mov    %edx,(%eax)
  801e9c:	eb 08                	jmp    801ea6 <insert_sorted_allocList+0x110>
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	a3 40 40 80 00       	mov    %eax,0x804040
  801ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  801eac:	89 50 04             	mov    %edx,0x4(%eax)
  801eaf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801eb4:	40                   	inc    %eax
  801eb5:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801eba:	e9 60 01 00 00       	jmp    80201f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	8b 50 08             	mov    0x8(%eax),%edx
  801ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec8:	8b 40 08             	mov    0x8(%eax),%eax
  801ecb:	39 c2                	cmp    %eax,%edx
  801ecd:	0f 82 4c 01 00 00    	jb     80201f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801ed3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed7:	75 14                	jne    801eed <insert_sorted_allocList+0x157>
  801ed9:	83 ec 04             	sub    $0x4,%esp
  801edc:	68 58 3c 80 00       	push   $0x803c58
  801ee1:	6a 73                	push   $0x73
  801ee3:	68 07 3c 80 00       	push   $0x803c07
  801ee8:	e8 2d 12 00 00       	call   80311a <_panic>
  801eed:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	89 50 04             	mov    %edx,0x4(%eax)
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	8b 40 04             	mov    0x4(%eax),%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	74 0c                	je     801f0f <insert_sorted_allocList+0x179>
  801f03:	a1 44 40 80 00       	mov    0x804044,%eax
  801f08:	8b 55 08             	mov    0x8(%ebp),%edx
  801f0b:	89 10                	mov    %edx,(%eax)
  801f0d:	eb 08                	jmp    801f17 <insert_sorted_allocList+0x181>
  801f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f12:	a3 40 40 80 00       	mov    %eax,0x804040
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	a3 44 40 80 00       	mov    %eax,0x804044
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f28:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f2d:	40                   	inc    %eax
  801f2e:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f33:	e9 e7 00 00 00       	jmp    80201f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  801f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  801f3e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801f45:	a1 40 40 80 00       	mov    0x804040,%eax
  801f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4d:	e9 9d 00 00 00       	jmp    801fef <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 00                	mov    (%eax),%eax
  801f57:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  801f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5d:	8b 50 08             	mov    0x8(%eax),%edx
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	8b 40 08             	mov    0x8(%eax),%eax
  801f66:	39 c2                	cmp    %eax,%edx
  801f68:	76 7d                	jbe    801fe7 <insert_sorted_allocList+0x251>
  801f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6d:	8b 50 08             	mov    0x8(%eax),%edx
  801f70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	39 c2                	cmp    %eax,%edx
  801f78:	73 6d                	jae    801fe7 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  801f7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7e:	74 06                	je     801f86 <insert_sorted_allocList+0x1f0>
  801f80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f84:	75 14                	jne    801f9a <insert_sorted_allocList+0x204>
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 7c 3c 80 00       	push   $0x803c7c
  801f8e:	6a 7f                	push   $0x7f
  801f90:	68 07 3c 80 00       	push   $0x803c07
  801f95:	e8 80 11 00 00       	call   80311a <_panic>
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	8b 10                	mov    (%eax),%edx
  801f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa2:	89 10                	mov    %edx,(%eax)
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	8b 00                	mov    (%eax),%eax
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	74 0b                	je     801fb8 <insert_sorted_allocList+0x222>
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 00                	mov    (%eax),%eax
  801fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb5:	89 50 04             	mov    %edx,0x4(%eax)
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801fbe:	89 10                	mov    %edx,(%eax)
  801fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc6:	89 50 04             	mov    %edx,0x4(%eax)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	8b 00                	mov    (%eax),%eax
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	75 08                	jne    801fda <insert_sorted_allocList+0x244>
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	a3 44 40 80 00       	mov    %eax,0x804044
  801fda:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fdf:	40                   	inc    %eax
  801fe0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  801fe5:	eb 39                	jmp    802020 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  801fe7:	a1 48 40 80 00       	mov    0x804048,%eax
  801fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff3:	74 07                	je     801ffc <insert_sorted_allocList+0x266>
  801ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff8:	8b 00                	mov    (%eax),%eax
  801ffa:	eb 05                	jmp    802001 <insert_sorted_allocList+0x26b>
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	a3 48 40 80 00       	mov    %eax,0x804048
  802006:	a1 48 40 80 00       	mov    0x804048,%eax
  80200b:	85 c0                	test   %eax,%eax
  80200d:	0f 85 3f ff ff ff    	jne    801f52 <insert_sorted_allocList+0x1bc>
  802013:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802017:	0f 85 35 ff ff ff    	jne    801f52 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80201d:	eb 01                	jmp    802020 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80201f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802020:	90                   	nop
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802029:	a1 38 41 80 00       	mov    0x804138,%eax
  80202e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802031:	e9 85 01 00 00       	jmp    8021bb <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 40 0c             	mov    0xc(%eax),%eax
  80203c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80203f:	0f 82 6e 01 00 00    	jb     8021b3 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 40 0c             	mov    0xc(%eax),%eax
  80204b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80204e:	0f 85 8a 00 00 00    	jne    8020de <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802058:	75 17                	jne    802071 <alloc_block_FF+0x4e>
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	68 b0 3c 80 00       	push   $0x803cb0
  802062:	68 93 00 00 00       	push   $0x93
  802067:	68 07 3c 80 00       	push   $0x803c07
  80206c:	e8 a9 10 00 00       	call   80311a <_panic>
  802071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802074:	8b 00                	mov    (%eax),%eax
  802076:	85 c0                	test   %eax,%eax
  802078:	74 10                	je     80208a <alloc_block_FF+0x67>
  80207a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207d:	8b 00                	mov    (%eax),%eax
  80207f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802082:	8b 52 04             	mov    0x4(%edx),%edx
  802085:	89 50 04             	mov    %edx,0x4(%eax)
  802088:	eb 0b                	jmp    802095 <alloc_block_FF+0x72>
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	8b 40 04             	mov    0x4(%eax),%eax
  802090:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	8b 40 04             	mov    0x4(%eax),%eax
  80209b:	85 c0                	test   %eax,%eax
  80209d:	74 0f                	je     8020ae <alloc_block_FF+0x8b>
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	8b 40 04             	mov    0x4(%eax),%eax
  8020a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a8:	8b 12                	mov    (%edx),%edx
  8020aa:	89 10                	mov    %edx,(%eax)
  8020ac:	eb 0a                	jmp    8020b8 <alloc_block_FF+0x95>
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 00                	mov    (%eax),%eax
  8020b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8020b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8020d0:	48                   	dec    %eax
  8020d1:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8020d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d9:	e9 10 01 00 00       	jmp    8021ee <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e7:	0f 86 c6 00 00 00    	jbe    8021b3 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8020ed:	a1 48 41 80 00       	mov    0x804148,%eax
  8020f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 50 08             	mov    0x8(%eax),%edx
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	8b 55 08             	mov    0x8(%ebp),%edx
  802107:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80210a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210e:	75 17                	jne    802127 <alloc_block_FF+0x104>
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	68 b0 3c 80 00       	push   $0x803cb0
  802118:	68 9b 00 00 00       	push   $0x9b
  80211d:	68 07 3c 80 00       	push   $0x803c07
  802122:	e8 f3 0f 00 00       	call   80311a <_panic>
  802127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212a:	8b 00                	mov    (%eax),%eax
  80212c:	85 c0                	test   %eax,%eax
  80212e:	74 10                	je     802140 <alloc_block_FF+0x11d>
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802133:	8b 00                	mov    (%eax),%eax
  802135:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802138:	8b 52 04             	mov    0x4(%edx),%edx
  80213b:	89 50 04             	mov    %edx,0x4(%eax)
  80213e:	eb 0b                	jmp    80214b <alloc_block_FF+0x128>
  802140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802143:	8b 40 04             	mov    0x4(%eax),%eax
  802146:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80214b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214e:	8b 40 04             	mov    0x4(%eax),%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 0f                	je     802164 <alloc_block_FF+0x141>
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	8b 40 04             	mov    0x4(%eax),%eax
  80215b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80215e:	8b 12                	mov    (%edx),%edx
  802160:	89 10                	mov    %edx,(%eax)
  802162:	eb 0a                	jmp    80216e <alloc_block_FF+0x14b>
  802164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802167:	8b 00                	mov    (%eax),%eax
  802169:	a3 48 41 80 00       	mov    %eax,0x804148
  80216e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802171:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802181:	a1 54 41 80 00       	mov    0x804154,%eax
  802186:	48                   	dec    %eax
  802187:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80218c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218f:	8b 50 08             	mov    0x8(%eax),%edx
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	01 c2                	add    %eax,%edx
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8021a6:	89 c2                	mov    %eax,%edx
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	eb 3b                	jmp    8021ee <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021b3:	a1 40 41 80 00       	mov    0x804140,%eax
  8021b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021bf:	74 07                	je     8021c8 <alloc_block_FF+0x1a5>
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	eb 05                	jmp    8021cd <alloc_block_FF+0x1aa>
  8021c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021cd:	a3 40 41 80 00       	mov    %eax,0x804140
  8021d2:	a1 40 41 80 00       	mov    0x804140,%eax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	0f 85 57 fe ff ff    	jne    802036 <alloc_block_FF+0x13>
  8021df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e3:	0f 85 4d fe ff ff    	jne    802036 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8021f6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8021fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802205:	e9 df 00 00 00       	jmp    8022e9 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	8b 40 0c             	mov    0xc(%eax),%eax
  802210:	3b 45 08             	cmp    0x8(%ebp),%eax
  802213:	0f 82 c8 00 00 00    	jb     8022e1 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802222:	0f 85 8a 00 00 00    	jne    8022b2 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222c:	75 17                	jne    802245 <alloc_block_BF+0x55>
  80222e:	83 ec 04             	sub    $0x4,%esp
  802231:	68 b0 3c 80 00       	push   $0x803cb0
  802236:	68 b7 00 00 00       	push   $0xb7
  80223b:	68 07 3c 80 00       	push   $0x803c07
  802240:	e8 d5 0e 00 00       	call   80311a <_panic>
  802245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 10                	je     80225e <alloc_block_BF+0x6e>
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802256:	8b 52 04             	mov    0x4(%edx),%edx
  802259:	89 50 04             	mov    %edx,0x4(%eax)
  80225c:	eb 0b                	jmp    802269 <alloc_block_BF+0x79>
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 04             	mov    0x4(%eax),%eax
  802264:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 40 04             	mov    0x4(%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 0f                	je     802282 <alloc_block_BF+0x92>
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 40 04             	mov    0x4(%eax),%eax
  802279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227c:	8b 12                	mov    (%edx),%edx
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	eb 0a                	jmp    80228c <alloc_block_BF+0x9c>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	a3 38 41 80 00       	mov    %eax,0x804138
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229f:	a1 44 41 80 00       	mov    0x804144,%eax
  8022a4:	48                   	dec    %eax
  8022a5:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	e9 4d 01 00 00       	jmp    8023ff <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8022b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022bb:	76 24                	jbe    8022e1 <alloc_block_BF+0xf1>
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022c6:	73 19                	jae    8022e1 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8022c8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 08             	mov    0x8(%eax),%eax
  8022de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8022e1:	a1 40 41 80 00       	mov    0x804140,%eax
  8022e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ed:	74 07                	je     8022f6 <alloc_block_BF+0x106>
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 00                	mov    (%eax),%eax
  8022f4:	eb 05                	jmp    8022fb <alloc_block_BF+0x10b>
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fb:	a3 40 41 80 00       	mov    %eax,0x804140
  802300:	a1 40 41 80 00       	mov    0x804140,%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	0f 85 fd fe ff ff    	jne    80220a <alloc_block_BF+0x1a>
  80230d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802311:	0f 85 f3 fe ff ff    	jne    80220a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802317:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80231b:	0f 84 d9 00 00 00    	je     8023fa <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802321:	a1 48 41 80 00       	mov    0x804148,%eax
  802326:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80232c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80232f:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
  802338:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80233b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80233f:	75 17                	jne    802358 <alloc_block_BF+0x168>
  802341:	83 ec 04             	sub    $0x4,%esp
  802344:	68 b0 3c 80 00       	push   $0x803cb0
  802349:	68 c7 00 00 00       	push   $0xc7
  80234e:	68 07 3c 80 00       	push   $0x803c07
  802353:	e8 c2 0d 00 00       	call   80311a <_panic>
  802358:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	74 10                	je     802371 <alloc_block_BF+0x181>
  802361:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802364:	8b 00                	mov    (%eax),%eax
  802366:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802369:	8b 52 04             	mov    0x4(%edx),%edx
  80236c:	89 50 04             	mov    %edx,0x4(%eax)
  80236f:	eb 0b                	jmp    80237c <alloc_block_BF+0x18c>
  802371:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802374:	8b 40 04             	mov    0x4(%eax),%eax
  802377:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80237c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80237f:	8b 40 04             	mov    0x4(%eax),%eax
  802382:	85 c0                	test   %eax,%eax
  802384:	74 0f                	je     802395 <alloc_block_BF+0x1a5>
  802386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802389:	8b 40 04             	mov    0x4(%eax),%eax
  80238c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80238f:	8b 12                	mov    (%edx),%edx
  802391:	89 10                	mov    %edx,(%eax)
  802393:	eb 0a                	jmp    80239f <alloc_block_BF+0x1af>
  802395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	a3 48 41 80 00       	mov    %eax,0x804148
  80239f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8023b7:	48                   	dec    %eax
  8023b8:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8023bd:	83 ec 08             	sub    $0x8,%esp
  8023c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8023c3:	68 38 41 80 00       	push   $0x804138
  8023c8:	e8 71 f9 ff ff       	call   801d3e <find_block>
  8023cd:	83 c4 10             	add    $0x10,%esp
  8023d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8023d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d6:	8b 50 08             	mov    0x8(%eax),%edx
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	01 c2                	add    %eax,%edx
  8023de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e1:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8023e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f2:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8023f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f8:	eb 05                	jmp    8023ff <alloc_block_BF+0x20f>
	}
	return NULL;
  8023fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802407:	a1 28 40 80 00       	mov    0x804028,%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	0f 85 de 01 00 00    	jne    8025f2 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802414:	a1 38 41 80 00       	mov    0x804138,%eax
  802419:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241c:	e9 9e 01 00 00       	jmp    8025bf <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 40 0c             	mov    0xc(%eax),%eax
  802427:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242a:	0f 82 87 01 00 00    	jb     8025b7 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 0c             	mov    0xc(%eax),%eax
  802436:	3b 45 08             	cmp    0x8(%ebp),%eax
  802439:	0f 85 95 00 00 00    	jne    8024d4 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80243f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802443:	75 17                	jne    80245c <alloc_block_NF+0x5b>
  802445:	83 ec 04             	sub    $0x4,%esp
  802448:	68 b0 3c 80 00       	push   $0x803cb0
  80244d:	68 e0 00 00 00       	push   $0xe0
  802452:	68 07 3c 80 00       	push   $0x803c07
  802457:	e8 be 0c 00 00       	call   80311a <_panic>
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	8b 00                	mov    (%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 10                	je     802475 <alloc_block_NF+0x74>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 00                	mov    (%eax),%eax
  80246a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246d:	8b 52 04             	mov    0x4(%edx),%edx
  802470:	89 50 04             	mov    %edx,0x4(%eax)
  802473:	eb 0b                	jmp    802480 <alloc_block_NF+0x7f>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 04             	mov    0x4(%eax),%eax
  80247b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 40 04             	mov    0x4(%eax),%eax
  802486:	85 c0                	test   %eax,%eax
  802488:	74 0f                	je     802499 <alloc_block_NF+0x98>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 04             	mov    0x4(%eax),%eax
  802490:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802493:	8b 12                	mov    (%edx),%edx
  802495:	89 10                	mov    %edx,(%eax)
  802497:	eb 0a                	jmp    8024a3 <alloc_block_NF+0xa2>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	a3 38 41 80 00       	mov    %eax,0x804138
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8024bb:	48                   	dec    %eax
  8024bc:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 08             	mov    0x8(%eax),%eax
  8024c7:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	e9 f8 04 00 00       	jmp    8029cc <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 86 d4 00 00 00    	jbe    8025b7 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024e3:	a1 48 41 80 00       	mov    0x804148,%eax
  8024e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 50 08             	mov    0x8(%eax),%edx
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fd:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802500:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802504:	75 17                	jne    80251d <alloc_block_NF+0x11c>
  802506:	83 ec 04             	sub    $0x4,%esp
  802509:	68 b0 3c 80 00       	push   $0x803cb0
  80250e:	68 e9 00 00 00       	push   $0xe9
  802513:	68 07 3c 80 00       	push   $0x803c07
  802518:	e8 fd 0b 00 00       	call   80311a <_panic>
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	85 c0                	test   %eax,%eax
  802524:	74 10                	je     802536 <alloc_block_NF+0x135>
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	8b 00                	mov    (%eax),%eax
  80252b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80252e:	8b 52 04             	mov    0x4(%edx),%edx
  802531:	89 50 04             	mov    %edx,0x4(%eax)
  802534:	eb 0b                	jmp    802541 <alloc_block_NF+0x140>
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	8b 40 04             	mov    0x4(%eax),%eax
  80253c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	74 0f                	je     80255a <alloc_block_NF+0x159>
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802554:	8b 12                	mov    (%edx),%edx
  802556:	89 10                	mov    %edx,(%eax)
  802558:	eb 0a                	jmp    802564 <alloc_block_NF+0x163>
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	a3 48 41 80 00       	mov    %eax,0x804148
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802570:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802577:	a1 54 41 80 00       	mov    0x804154,%eax
  80257c:	48                   	dec    %eax
  80257d:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	8b 40 08             	mov    0x8(%eax),%eax
  802588:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 50 08             	mov    0x8(%eax),%edx
  802593:	8b 45 08             	mov    0x8(%ebp),%eax
  802596:	01 c2                	add    %eax,%edx
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a7:	89 c2                	mov    %eax,%edx
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	e9 15 04 00 00       	jmp    8029cc <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8025bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c3:	74 07                	je     8025cc <alloc_block_NF+0x1cb>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	eb 05                	jmp    8025d1 <alloc_block_NF+0x1d0>
  8025cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d1:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d6:	a1 40 41 80 00       	mov    0x804140,%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 85 3e fe ff ff    	jne    802421 <alloc_block_NF+0x20>
  8025e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e7:	0f 85 34 fe ff ff    	jne    802421 <alloc_block_NF+0x20>
  8025ed:	e9 d5 03 00 00       	jmp    8029c7 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8025f2:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fa:	e9 b1 01 00 00       	jmp    8027b0 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 50 08             	mov    0x8(%eax),%edx
  802605:	a1 28 40 80 00       	mov    0x804028,%eax
  80260a:	39 c2                	cmp    %eax,%edx
  80260c:	0f 82 96 01 00 00    	jb     8027a8 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 0c             	mov    0xc(%eax),%eax
  802618:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261b:	0f 82 87 01 00 00    	jb     8027a8 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 40 0c             	mov    0xc(%eax),%eax
  802627:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262a:	0f 85 95 00 00 00    	jne    8026c5 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	75 17                	jne    80264d <alloc_block_NF+0x24c>
  802636:	83 ec 04             	sub    $0x4,%esp
  802639:	68 b0 3c 80 00       	push   $0x803cb0
  80263e:	68 fc 00 00 00       	push   $0xfc
  802643:	68 07 3c 80 00       	push   $0x803c07
  802648:	e8 cd 0a 00 00       	call   80311a <_panic>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 00                	mov    (%eax),%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	74 10                	je     802666 <alloc_block_NF+0x265>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265e:	8b 52 04             	mov    0x4(%edx),%edx
  802661:	89 50 04             	mov    %edx,0x4(%eax)
  802664:	eb 0b                	jmp    802671 <alloc_block_NF+0x270>
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	74 0f                	je     80268a <alloc_block_NF+0x289>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802684:	8b 12                	mov    (%edx),%edx
  802686:	89 10                	mov    %edx,(%eax)
  802688:	eb 0a                	jmp    802694 <alloc_block_NF+0x293>
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	a3 38 41 80 00       	mov    %eax,0x804138
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a7:	a1 44 41 80 00       	mov    0x804144,%eax
  8026ac:	48                   	dec    %eax
  8026ad:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 08             	mov    0x8(%eax),%eax
  8026b8:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	e9 07 03 00 00       	jmp    8029cc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ce:	0f 86 d4 00 00 00    	jbe    8027a8 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d4:	a1 48 41 80 00       	mov    0x804148,%eax
  8026d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	8b 50 08             	mov    0x8(%eax),%edx
  8026e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8026e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ee:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026f1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026f5:	75 17                	jne    80270e <alloc_block_NF+0x30d>
  8026f7:	83 ec 04             	sub    $0x4,%esp
  8026fa:	68 b0 3c 80 00       	push   $0x803cb0
  8026ff:	68 04 01 00 00       	push   $0x104
  802704:	68 07 3c 80 00       	push   $0x803c07
  802709:	e8 0c 0a 00 00       	call   80311a <_panic>
  80270e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802711:	8b 00                	mov    (%eax),%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	74 10                	je     802727 <alloc_block_NF+0x326>
  802717:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271a:	8b 00                	mov    (%eax),%eax
  80271c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271f:	8b 52 04             	mov    0x4(%edx),%edx
  802722:	89 50 04             	mov    %edx,0x4(%eax)
  802725:	eb 0b                	jmp    802732 <alloc_block_NF+0x331>
  802727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802735:	8b 40 04             	mov    0x4(%eax),%eax
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 0f                	je     80274b <alloc_block_NF+0x34a>
  80273c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802745:	8b 12                	mov    (%edx),%edx
  802747:	89 10                	mov    %edx,(%eax)
  802749:	eb 0a                	jmp    802755 <alloc_block_NF+0x354>
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	a3 48 41 80 00       	mov    %eax,0x804148
  802755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802758:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802761:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802768:	a1 54 41 80 00       	mov    0x804154,%eax
  80276d:	48                   	dec    %eax
  80276e:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802773:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 50 08             	mov    0x8(%eax),%edx
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	01 c2                	add    %eax,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 40 0c             	mov    0xc(%eax),%eax
  802795:	2b 45 08             	sub    0x8(%ebp),%eax
  802798:	89 c2                	mov    %eax,%edx
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8027a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a3:	e9 24 02 00 00       	jmp    8029cc <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b4:	74 07                	je     8027bd <alloc_block_NF+0x3bc>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	eb 05                	jmp    8027c2 <alloc_block_NF+0x3c1>
  8027bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c2:	a3 40 41 80 00       	mov    %eax,0x804140
  8027c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027cc:	85 c0                	test   %eax,%eax
  8027ce:	0f 85 2b fe ff ff    	jne    8025ff <alloc_block_NF+0x1fe>
  8027d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d8:	0f 85 21 fe ff ff    	jne    8025ff <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027de:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e6:	e9 ae 01 00 00       	jmp    802999 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 50 08             	mov    0x8(%eax),%edx
  8027f1:	a1 28 40 80 00       	mov    0x804028,%eax
  8027f6:	39 c2                	cmp    %eax,%edx
  8027f8:	0f 83 93 01 00 00    	jae    802991 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 0c             	mov    0xc(%eax),%eax
  802804:	3b 45 08             	cmp    0x8(%ebp),%eax
  802807:	0f 82 84 01 00 00    	jb     802991 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 0c             	mov    0xc(%eax),%eax
  802813:	3b 45 08             	cmp    0x8(%ebp),%eax
  802816:	0f 85 95 00 00 00    	jne    8028b1 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802820:	75 17                	jne    802839 <alloc_block_NF+0x438>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 b0 3c 80 00       	push   $0x803cb0
  80282a:	68 14 01 00 00       	push   $0x114
  80282f:	68 07 3c 80 00       	push   $0x803c07
  802834:	e8 e1 08 00 00       	call   80311a <_panic>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 10                	je     802852 <alloc_block_NF+0x451>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	8b 52 04             	mov    0x4(%edx),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	eb 0b                	jmp    80285d <alloc_block_NF+0x45c>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0f                	je     802876 <alloc_block_NF+0x475>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802870:	8b 12                	mov    (%edx),%edx
  802872:	89 10                	mov    %edx,(%eax)
  802874:	eb 0a                	jmp    802880 <alloc_block_NF+0x47f>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	a3 38 41 80 00       	mov    %eax,0x804138
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802893:	a1 44 41 80 00       	mov    0x804144,%eax
  802898:	48                   	dec    %eax
  802899:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 08             	mov    0x8(%eax),%eax
  8028a4:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	e9 1b 01 00 00       	jmp    8029cc <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ba:	0f 86 d1 00 00 00    	jbe    802991 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028da:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028e1:	75 17                	jne    8028fa <alloc_block_NF+0x4f9>
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	68 b0 3c 80 00       	push   $0x803cb0
  8028eb:	68 1c 01 00 00       	push   $0x11c
  8028f0:	68 07 3c 80 00       	push   $0x803c07
  8028f5:	e8 20 08 00 00       	call   80311a <_panic>
  8028fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 10                	je     802913 <alloc_block_NF+0x512>
  802903:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80290b:	8b 52 04             	mov    0x4(%edx),%edx
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	eb 0b                	jmp    80291e <alloc_block_NF+0x51d>
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80291e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0f                	je     802937 <alloc_block_NF+0x536>
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802931:	8b 12                	mov    (%edx),%edx
  802933:	89 10                	mov    %edx,(%eax)
  802935:	eb 0a                	jmp    802941 <alloc_block_NF+0x540>
  802937:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	a3 48 41 80 00       	mov    %eax,0x804148
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802954:	a1 54 41 80 00       	mov    0x804154,%eax
  802959:	48                   	dec    %eax
  80295a:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80295f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802962:	8b 40 08             	mov    0x8(%eax),%eax
  802965:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	01 c2                	add    %eax,%edx
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 0c             	mov    0xc(%eax),%eax
  802981:	2b 45 08             	sub    0x8(%ebp),%eax
  802984:	89 c2                	mov    %eax,%edx
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80298c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298f:	eb 3b                	jmp    8029cc <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802991:	a1 40 41 80 00       	mov    0x804140,%eax
  802996:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299d:	74 07                	je     8029a6 <alloc_block_NF+0x5a5>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	eb 05                	jmp    8029ab <alloc_block_NF+0x5aa>
  8029a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ab:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b0:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	0f 85 2e fe ff ff    	jne    8027eb <alloc_block_NF+0x3ea>
  8029bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c1:	0f 85 24 fe ff ff    	jne    8027eb <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  8029c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  8029d4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  8029dc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  8029e4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 14                	je     802a01 <insert_sorted_with_merge_freeList+0x33>
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	8b 50 08             	mov    0x8(%eax),%edx
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	8b 40 08             	mov    0x8(%eax),%eax
  8029f9:	39 c2                	cmp    %eax,%edx
  8029fb:	0f 87 9b 01 00 00    	ja     802b9c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802a01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a05:	75 17                	jne    802a1e <insert_sorted_with_merge_freeList+0x50>
  802a07:	83 ec 04             	sub    $0x4,%esp
  802a0a:	68 e4 3b 80 00       	push   $0x803be4
  802a0f:	68 38 01 00 00       	push   $0x138
  802a14:	68 07 3c 80 00       	push   $0x803c07
  802a19:	e8 fc 06 00 00       	call   80311a <_panic>
  802a1e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	89 10                	mov    %edx,(%eax)
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	8b 00                	mov    (%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	74 0d                	je     802a3f <insert_sorted_with_merge_freeList+0x71>
  802a32:	a1 38 41 80 00       	mov    0x804138,%eax
  802a37:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3a:	89 50 04             	mov    %edx,0x4(%eax)
  802a3d:	eb 08                	jmp    802a47 <insert_sorted_with_merge_freeList+0x79>
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a59:	a1 44 41 80 00       	mov    0x804144,%eax
  802a5e:	40                   	inc    %eax
  802a5f:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802a64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a68:	0f 84 a8 06 00 00    	je     803116 <insert_sorted_with_merge_freeList+0x748>
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 50 08             	mov    0x8(%eax),%edx
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7a:	01 c2                	add    %eax,%edx
  802a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	39 c2                	cmp    %eax,%edx
  802a84:	0f 85 8c 06 00 00    	jne    803116 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	8b 40 0c             	mov    0xc(%eax),%eax
  802a96:	01 c2                	add    %eax,%edx
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802a9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aa2:	75 17                	jne    802abb <insert_sorted_with_merge_freeList+0xed>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 b0 3c 80 00       	push   $0x803cb0
  802aac:	68 3c 01 00 00       	push   $0x13c
  802ab1:	68 07 3c 80 00       	push   $0x803c07
  802ab6:	e8 5f 06 00 00       	call   80311a <_panic>
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 10                	je     802ad4 <insert_sorted_with_merge_freeList+0x106>
  802ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acc:	8b 52 04             	mov    0x4(%edx),%edx
  802acf:	89 50 04             	mov    %edx,0x4(%eax)
  802ad2:	eb 0b                	jmp    802adf <insert_sorted_with_merge_freeList+0x111>
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 0f                	je     802af8 <insert_sorted_with_merge_freeList+0x12a>
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802af2:	8b 12                	mov    (%edx),%edx
  802af4:	89 10                	mov    %edx,(%eax)
  802af6:	eb 0a                	jmp    802b02 <insert_sorted_with_merge_freeList+0x134>
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	a3 38 41 80 00       	mov    %eax,0x804138
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b15:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1a:	48                   	dec    %eax
  802b1b:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802b34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b38:	75 17                	jne    802b51 <insert_sorted_with_merge_freeList+0x183>
  802b3a:	83 ec 04             	sub    $0x4,%esp
  802b3d:	68 e4 3b 80 00       	push   $0x803be4
  802b42:	68 3f 01 00 00       	push   $0x13f
  802b47:	68 07 3c 80 00       	push   $0x803c07
  802b4c:	e8 c9 05 00 00       	call   80311a <_panic>
  802b51:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 0d                	je     802b72 <insert_sorted_with_merge_freeList+0x1a4>
  802b65:	a1 48 41 80 00       	mov    0x804148,%eax
  802b6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6d:	89 50 04             	mov    %edx,0x4(%eax)
  802b70:	eb 08                	jmp    802b7a <insert_sorted_with_merge_freeList+0x1ac>
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b91:	40                   	inc    %eax
  802b92:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b97:	e9 7a 05 00 00       	jmp    803116 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 50 08             	mov    0x8(%eax),%edx
  802ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba5:	8b 40 08             	mov    0x8(%eax),%eax
  802ba8:	39 c2                	cmp    %eax,%edx
  802baa:	0f 82 14 01 00 00    	jb     802cc4 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	8b 50 08             	mov    0x8(%eax),%edx
  802bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbc:	01 c2                	add    %eax,%edx
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 40 08             	mov    0x8(%eax),%eax
  802bc4:	39 c2                	cmp    %eax,%edx
  802bc6:	0f 85 90 00 00 00    	jne    802c5c <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcf:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	01 c2                	add    %eax,%edx
  802bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdd:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802bf4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf8:	75 17                	jne    802c11 <insert_sorted_with_merge_freeList+0x243>
  802bfa:	83 ec 04             	sub    $0x4,%esp
  802bfd:	68 e4 3b 80 00       	push   $0x803be4
  802c02:	68 49 01 00 00       	push   $0x149
  802c07:	68 07 3c 80 00       	push   $0x803c07
  802c0c:	e8 09 05 00 00       	call   80311a <_panic>
  802c11:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	89 10                	mov    %edx,(%eax)
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	8b 00                	mov    (%eax),%eax
  802c21:	85 c0                	test   %eax,%eax
  802c23:	74 0d                	je     802c32 <insert_sorted_with_merge_freeList+0x264>
  802c25:	a1 48 41 80 00       	mov    0x804148,%eax
  802c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2d:	89 50 04             	mov    %edx,0x4(%eax)
  802c30:	eb 08                	jmp    802c3a <insert_sorted_with_merge_freeList+0x26c>
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	a3 48 41 80 00       	mov    %eax,0x804148
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c51:	40                   	inc    %eax
  802c52:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802c57:	e9 bb 04 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c60:	75 17                	jne    802c79 <insert_sorted_with_merge_freeList+0x2ab>
  802c62:	83 ec 04             	sub    $0x4,%esp
  802c65:	68 58 3c 80 00       	push   $0x803c58
  802c6a:	68 4c 01 00 00       	push   $0x14c
  802c6f:	68 07 3c 80 00       	push   $0x803c07
  802c74:	e8 a1 04 00 00       	call   80311a <_panic>
  802c79:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	89 50 04             	mov    %edx,0x4(%eax)
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	74 0c                	je     802c9b <insert_sorted_with_merge_freeList+0x2cd>
  802c8f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c94:	8b 55 08             	mov    0x8(%ebp),%edx
  802c97:	89 10                	mov    %edx,(%eax)
  802c99:	eb 08                	jmp    802ca3 <insert_sorted_with_merge_freeList+0x2d5>
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	a3 38 41 80 00       	mov    %eax,0x804138
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb4:	a1 44 41 80 00       	mov    0x804144,%eax
  802cb9:	40                   	inc    %eax
  802cba:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802cbf:	e9 53 04 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802cc4:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccc:	e9 15 04 00 00       	jmp    8030e6 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 50 08             	mov    0x8(%eax),%edx
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 08             	mov    0x8(%eax),%eax
  802ce5:	39 c2                	cmp    %eax,%edx
  802ce7:	0f 86 f1 03 00 00    	jbe    8030de <insert_sorted_with_merge_freeList+0x710>
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 50 08             	mov    0x8(%eax),%edx
  802cf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf6:	8b 40 08             	mov    0x8(%eax),%eax
  802cf9:	39 c2                	cmp    %eax,%edx
  802cfb:	0f 83 dd 03 00 00    	jae    8030de <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 50 08             	mov    0x8(%eax),%edx
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0d:	01 c2                	add    %eax,%edx
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	8b 40 08             	mov    0x8(%eax),%eax
  802d15:	39 c2                	cmp    %eax,%edx
  802d17:	0f 85 b9 01 00 00    	jne    802ed6 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	8b 50 08             	mov    0x8(%eax),%edx
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	8b 40 0c             	mov    0xc(%eax),%eax
  802d29:	01 c2                	add    %eax,%edx
  802d2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2e:	8b 40 08             	mov    0x8(%eax),%eax
  802d31:	39 c2                	cmp    %eax,%edx
  802d33:	0f 85 0d 01 00 00    	jne    802e46 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d42:	8b 40 0c             	mov    0xc(%eax),%eax
  802d45:	01 c2                	add    %eax,%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802d4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d51:	75 17                	jne    802d6a <insert_sorted_with_merge_freeList+0x39c>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 b0 3c 80 00       	push   $0x803cb0
  802d5b:	68 5c 01 00 00       	push   $0x15c
  802d60:	68 07 3c 80 00       	push   $0x803c07
  802d65:	e8 b0 03 00 00       	call   80311a <_panic>
  802d6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 10                	je     802d83 <insert_sorted_with_merge_freeList+0x3b5>
  802d73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d7b:	8b 52 04             	mov    0x4(%edx),%edx
  802d7e:	89 50 04             	mov    %edx,0x4(%eax)
  802d81:	eb 0b                	jmp    802d8e <insert_sorted_with_merge_freeList+0x3c0>
  802d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 0f                	je     802da7 <insert_sorted_with_merge_freeList+0x3d9>
  802d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802da1:	8b 12                	mov    (%edx),%edx
  802da3:	89 10                	mov    %edx,(%eax)
  802da5:	eb 0a                	jmp    802db1 <insert_sorted_with_merge_freeList+0x3e3>
  802da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	a3 38 41 80 00       	mov    %eax,0x804138
  802db1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc4:	a1 44 41 80 00       	mov    0x804144,%eax
  802dc9:	48                   	dec    %eax
  802dca:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802dd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802de3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802de7:	75 17                	jne    802e00 <insert_sorted_with_merge_freeList+0x432>
  802de9:	83 ec 04             	sub    $0x4,%esp
  802dec:	68 e4 3b 80 00       	push   $0x803be4
  802df1:	68 5f 01 00 00       	push   $0x15f
  802df6:	68 07 3c 80 00       	push   $0x803c07
  802dfb:	e8 1a 03 00 00       	call   80311a <_panic>
  802e00:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0e:	8b 00                	mov    (%eax),%eax
  802e10:	85 c0                	test   %eax,%eax
  802e12:	74 0d                	je     802e21 <insert_sorted_with_merge_freeList+0x453>
  802e14:	a1 48 41 80 00       	mov    0x804148,%eax
  802e19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e1c:	89 50 04             	mov    %edx,0x4(%eax)
  802e1f:	eb 08                	jmp    802e29 <insert_sorted_with_merge_freeList+0x45b>
  802e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e24:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2c:	a3 48 41 80 00       	mov    %eax,0x804148
  802e31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3b:	a1 54 41 80 00       	mov    0x804154,%eax
  802e40:	40                   	inc    %eax
  802e41:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e52:	01 c2                	add    %eax,%edx
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e72:	75 17                	jne    802e8b <insert_sorted_with_merge_freeList+0x4bd>
  802e74:	83 ec 04             	sub    $0x4,%esp
  802e77:	68 e4 3b 80 00       	push   $0x803be4
  802e7c:	68 64 01 00 00       	push   $0x164
  802e81:	68 07 3c 80 00       	push   $0x803c07
  802e86:	e8 8f 02 00 00       	call   80311a <_panic>
  802e8b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0d                	je     802eac <insert_sorted_with_merge_freeList+0x4de>
  802e9f:	a1 48 41 80 00       	mov    0x804148,%eax
  802ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea7:	89 50 04             	mov    %edx,0x4(%eax)
  802eaa:	eb 08                	jmp    802eb4 <insert_sorted_with_merge_freeList+0x4e6>
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 48 41 80 00       	mov    %eax,0x804148
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ecb:	40                   	inc    %eax
  802ecc:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802ed1:	e9 41 02 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee2:	01 c2                	add    %eax,%edx
  802ee4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee7:	8b 40 08             	mov    0x8(%eax),%eax
  802eea:	39 c2                	cmp    %eax,%edx
  802eec:	0f 85 7c 01 00 00    	jne    80306e <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802ef2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ef6:	74 06                	je     802efe <insert_sorted_with_merge_freeList+0x530>
  802ef8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efc:	75 17                	jne    802f15 <insert_sorted_with_merge_freeList+0x547>
  802efe:	83 ec 04             	sub    $0x4,%esp
  802f01:	68 20 3c 80 00       	push   $0x803c20
  802f06:	68 69 01 00 00       	push   $0x169
  802f0b:	68 07 3c 80 00       	push   $0x803c07
  802f10:	e8 05 02 00 00       	call   80311a <_panic>
  802f15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f18:	8b 50 04             	mov    0x4(%eax),%edx
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	89 50 04             	mov    %edx,0x4(%eax)
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 0d                	je     802f40 <insert_sorted_with_merge_freeList+0x572>
  802f33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f36:	8b 40 04             	mov    0x4(%eax),%eax
  802f39:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3c:	89 10                	mov    %edx,(%eax)
  802f3e:	eb 08                	jmp    802f48 <insert_sorted_with_merge_freeList+0x57a>
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	a3 38 41 80 00       	mov    %eax,0x804138
  802f48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	a1 44 41 80 00       	mov    0x804144,%eax
  802f56:	40                   	inc    %eax
  802f57:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	01 c2                	add    %eax,%edx
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f74:	75 17                	jne    802f8d <insert_sorted_with_merge_freeList+0x5bf>
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	68 b0 3c 80 00       	push   $0x803cb0
  802f7e:	68 6b 01 00 00       	push   $0x16b
  802f83:	68 07 3c 80 00       	push   $0x803c07
  802f88:	e8 8d 01 00 00       	call   80311a <_panic>
  802f8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 10                	je     802fa6 <insert_sorted_with_merge_freeList+0x5d8>
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f9e:	8b 52 04             	mov    0x4(%edx),%edx
  802fa1:	89 50 04             	mov    %edx,0x4(%eax)
  802fa4:	eb 0b                	jmp    802fb1 <insert_sorted_with_merge_freeList+0x5e3>
  802fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa9:	8b 40 04             	mov    0x4(%eax),%eax
  802fac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb4:	8b 40 04             	mov    0x4(%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 0f                	je     802fca <insert_sorted_with_merge_freeList+0x5fc>
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	8b 40 04             	mov    0x4(%eax),%eax
  802fc1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fc4:	8b 12                	mov    (%edx),%edx
  802fc6:	89 10                	mov    %edx,(%eax)
  802fc8:	eb 0a                	jmp    802fd4 <insert_sorted_with_merge_freeList+0x606>
  802fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcd:	8b 00                	mov    (%eax),%eax
  802fcf:	a3 38 41 80 00       	mov    %eax,0x804138
  802fd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe7:	a1 44 41 80 00       	mov    0x804144,%eax
  802fec:	48                   	dec    %eax
  802fed:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803006:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80300a:	75 17                	jne    803023 <insert_sorted_with_merge_freeList+0x655>
  80300c:	83 ec 04             	sub    $0x4,%esp
  80300f:	68 e4 3b 80 00       	push   $0x803be4
  803014:	68 6e 01 00 00       	push   $0x16e
  803019:	68 07 3c 80 00       	push   $0x803c07
  80301e:	e8 f7 00 00 00       	call   80311a <_panic>
  803023:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	89 10                	mov    %edx,(%eax)
  80302e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803031:	8b 00                	mov    (%eax),%eax
  803033:	85 c0                	test   %eax,%eax
  803035:	74 0d                	je     803044 <insert_sorted_with_merge_freeList+0x676>
  803037:	a1 48 41 80 00       	mov    0x804148,%eax
  80303c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	eb 08                	jmp    80304c <insert_sorted_with_merge_freeList+0x67e>
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	a3 48 41 80 00       	mov    %eax,0x804148
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305e:	a1 54 41 80 00       	mov    0x804154,%eax
  803063:	40                   	inc    %eax
  803064:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803069:	e9 a9 00 00 00       	jmp    803117 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	74 06                	je     80307a <insert_sorted_with_merge_freeList+0x6ac>
  803074:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803078:	75 17                	jne    803091 <insert_sorted_with_merge_freeList+0x6c3>
  80307a:	83 ec 04             	sub    $0x4,%esp
  80307d:	68 7c 3c 80 00       	push   $0x803c7c
  803082:	68 73 01 00 00       	push   $0x173
  803087:	68 07 3c 80 00       	push   $0x803c07
  80308c:	e8 89 00 00 00       	call   80311a <_panic>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 10                	mov    (%eax),%edx
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	89 10                	mov    %edx,(%eax)
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	8b 00                	mov    (%eax),%eax
  8030a0:	85 c0                	test   %eax,%eax
  8030a2:	74 0b                	je     8030af <insert_sorted_with_merge_freeList+0x6e1>
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ac:	89 50 04             	mov    %edx,0x4(%eax)
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b5:	89 10                	mov    %edx,(%eax)
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bd:	89 50 04             	mov    %edx,0x4(%eax)
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	75 08                	jne    8030d1 <insert_sorted_with_merge_freeList+0x703>
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8030d6:	40                   	inc    %eax
  8030d7:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8030dc:	eb 39                	jmp    803117 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030de:	a1 40 41 80 00       	mov    0x804140,%eax
  8030e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ea:	74 07                	je     8030f3 <insert_sorted_with_merge_freeList+0x725>
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	eb 05                	jmp    8030f8 <insert_sorted_with_merge_freeList+0x72a>
  8030f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030f8:	a3 40 41 80 00       	mov    %eax,0x804140
  8030fd:	a1 40 41 80 00       	mov    0x804140,%eax
  803102:	85 c0                	test   %eax,%eax
  803104:	0f 85 c7 fb ff ff    	jne    802cd1 <insert_sorted_with_merge_freeList+0x303>
  80310a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310e:	0f 85 bd fb ff ff    	jne    802cd1 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803114:	eb 01                	jmp    803117 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803116:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803117:	90                   	nop
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
  80311d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803120:	8d 45 10             	lea    0x10(%ebp),%eax
  803123:	83 c0 04             	add    $0x4,%eax
  803126:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803129:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80312e:	85 c0                	test   %eax,%eax
  803130:	74 16                	je     803148 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803132:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803137:	83 ec 08             	sub    $0x8,%esp
  80313a:	50                   	push   %eax
  80313b:	68 d0 3c 80 00       	push   $0x803cd0
  803140:	e8 03 d2 ff ff       	call   800348 <cprintf>
  803145:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803148:	a1 00 40 80 00       	mov    0x804000,%eax
  80314d:	ff 75 0c             	pushl  0xc(%ebp)
  803150:	ff 75 08             	pushl  0x8(%ebp)
  803153:	50                   	push   %eax
  803154:	68 d5 3c 80 00       	push   $0x803cd5
  803159:	e8 ea d1 ff ff       	call   800348 <cprintf>
  80315e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803161:	8b 45 10             	mov    0x10(%ebp),%eax
  803164:	83 ec 08             	sub    $0x8,%esp
  803167:	ff 75 f4             	pushl  -0xc(%ebp)
  80316a:	50                   	push   %eax
  80316b:	e8 6d d1 ff ff       	call   8002dd <vcprintf>
  803170:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803173:	83 ec 08             	sub    $0x8,%esp
  803176:	6a 00                	push   $0x0
  803178:	68 f1 3c 80 00       	push   $0x803cf1
  80317d:	e8 5b d1 ff ff       	call   8002dd <vcprintf>
  803182:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803185:	e8 dc d0 ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  80318a:	eb fe                	jmp    80318a <_panic+0x70>

0080318c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
  80318f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803192:	a1 20 40 80 00       	mov    0x804020,%eax
  803197:	8b 50 74             	mov    0x74(%eax),%edx
  80319a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80319d:	39 c2                	cmp    %eax,%edx
  80319f:	74 14                	je     8031b5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8031a1:	83 ec 04             	sub    $0x4,%esp
  8031a4:	68 f4 3c 80 00       	push   $0x803cf4
  8031a9:	6a 26                	push   $0x26
  8031ab:	68 40 3d 80 00       	push   $0x803d40
  8031b0:	e8 65 ff ff ff       	call   80311a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8031b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8031bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031c3:	e9 c2 00 00 00       	jmp    80328a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8031c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	01 d0                	add    %edx,%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	75 08                	jne    8031e5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8031dd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8031e0:	e9 a2 00 00 00       	jmp    803287 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8031e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031f3:	eb 69                	jmp    80325e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8031f5:	a1 20 40 80 00       	mov    0x804020,%eax
  8031fa:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803200:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803203:	89 d0                	mov    %edx,%eax
  803205:	01 c0                	add    %eax,%eax
  803207:	01 d0                	add    %edx,%eax
  803209:	c1 e0 03             	shl    $0x3,%eax
  80320c:	01 c8                	add    %ecx,%eax
  80320e:	8a 40 04             	mov    0x4(%eax),%al
  803211:	84 c0                	test   %al,%al
  803213:	75 46                	jne    80325b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803215:	a1 20 40 80 00       	mov    0x804020,%eax
  80321a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803220:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803223:	89 d0                	mov    %edx,%eax
  803225:	01 c0                	add    %eax,%eax
  803227:	01 d0                	add    %edx,%eax
  803229:	c1 e0 03             	shl    $0x3,%eax
  80322c:	01 c8                	add    %ecx,%eax
  80322e:	8b 00                	mov    (%eax),%eax
  803230:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803233:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803236:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80323b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	01 c8                	add    %ecx,%eax
  80324c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80324e:	39 c2                	cmp    %eax,%edx
  803250:	75 09                	jne    80325b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803252:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803259:	eb 12                	jmp    80326d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80325b:	ff 45 e8             	incl   -0x18(%ebp)
  80325e:	a1 20 40 80 00       	mov    0x804020,%eax
  803263:	8b 50 74             	mov    0x74(%eax),%edx
  803266:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803269:	39 c2                	cmp    %eax,%edx
  80326b:	77 88                	ja     8031f5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80326d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803271:	75 14                	jne    803287 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803273:	83 ec 04             	sub    $0x4,%esp
  803276:	68 4c 3d 80 00       	push   $0x803d4c
  80327b:	6a 3a                	push   $0x3a
  80327d:	68 40 3d 80 00       	push   $0x803d40
  803282:	e8 93 fe ff ff       	call   80311a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803287:	ff 45 f0             	incl   -0x10(%ebp)
  80328a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803290:	0f 8c 32 ff ff ff    	jl     8031c8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803296:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80329d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032a4:	eb 26                	jmp    8032cc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8032a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8032ab:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032b4:	89 d0                	mov    %edx,%eax
  8032b6:	01 c0                	add    %eax,%eax
  8032b8:	01 d0                	add    %edx,%eax
  8032ba:	c1 e0 03             	shl    $0x3,%eax
  8032bd:	01 c8                	add    %ecx,%eax
  8032bf:	8a 40 04             	mov    0x4(%eax),%al
  8032c2:	3c 01                	cmp    $0x1,%al
  8032c4:	75 03                	jne    8032c9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8032c6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032c9:	ff 45 e0             	incl   -0x20(%ebp)
  8032cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8032d1:	8b 50 74             	mov    0x74(%eax),%edx
  8032d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032d7:	39 c2                	cmp    %eax,%edx
  8032d9:	77 cb                	ja     8032a6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032de:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032e1:	74 14                	je     8032f7 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8032e3:	83 ec 04             	sub    $0x4,%esp
  8032e6:	68 a0 3d 80 00       	push   $0x803da0
  8032eb:	6a 44                	push   $0x44
  8032ed:	68 40 3d 80 00       	push   $0x803d40
  8032f2:	e8 23 fe ff ff       	call   80311a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8032f7:	90                   	nop
  8032f8:	c9                   	leave  
  8032f9:	c3                   	ret    
  8032fa:	66 90                	xchg   %ax,%ax

008032fc <__udivdi3>:
  8032fc:	55                   	push   %ebp
  8032fd:	57                   	push   %edi
  8032fe:	56                   	push   %esi
  8032ff:	53                   	push   %ebx
  803300:	83 ec 1c             	sub    $0x1c,%esp
  803303:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803307:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80330b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80330f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803313:	89 ca                	mov    %ecx,%edx
  803315:	89 f8                	mov    %edi,%eax
  803317:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80331b:	85 f6                	test   %esi,%esi
  80331d:	75 2d                	jne    80334c <__udivdi3+0x50>
  80331f:	39 cf                	cmp    %ecx,%edi
  803321:	77 65                	ja     803388 <__udivdi3+0x8c>
  803323:	89 fd                	mov    %edi,%ebp
  803325:	85 ff                	test   %edi,%edi
  803327:	75 0b                	jne    803334 <__udivdi3+0x38>
  803329:	b8 01 00 00 00       	mov    $0x1,%eax
  80332e:	31 d2                	xor    %edx,%edx
  803330:	f7 f7                	div    %edi
  803332:	89 c5                	mov    %eax,%ebp
  803334:	31 d2                	xor    %edx,%edx
  803336:	89 c8                	mov    %ecx,%eax
  803338:	f7 f5                	div    %ebp
  80333a:	89 c1                	mov    %eax,%ecx
  80333c:	89 d8                	mov    %ebx,%eax
  80333e:	f7 f5                	div    %ebp
  803340:	89 cf                	mov    %ecx,%edi
  803342:	89 fa                	mov    %edi,%edx
  803344:	83 c4 1c             	add    $0x1c,%esp
  803347:	5b                   	pop    %ebx
  803348:	5e                   	pop    %esi
  803349:	5f                   	pop    %edi
  80334a:	5d                   	pop    %ebp
  80334b:	c3                   	ret    
  80334c:	39 ce                	cmp    %ecx,%esi
  80334e:	77 28                	ja     803378 <__udivdi3+0x7c>
  803350:	0f bd fe             	bsr    %esi,%edi
  803353:	83 f7 1f             	xor    $0x1f,%edi
  803356:	75 40                	jne    803398 <__udivdi3+0x9c>
  803358:	39 ce                	cmp    %ecx,%esi
  80335a:	72 0a                	jb     803366 <__udivdi3+0x6a>
  80335c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803360:	0f 87 9e 00 00 00    	ja     803404 <__udivdi3+0x108>
  803366:	b8 01 00 00 00       	mov    $0x1,%eax
  80336b:	89 fa                	mov    %edi,%edx
  80336d:	83 c4 1c             	add    $0x1c,%esp
  803370:	5b                   	pop    %ebx
  803371:	5e                   	pop    %esi
  803372:	5f                   	pop    %edi
  803373:	5d                   	pop    %ebp
  803374:	c3                   	ret    
  803375:	8d 76 00             	lea    0x0(%esi),%esi
  803378:	31 ff                	xor    %edi,%edi
  80337a:	31 c0                	xor    %eax,%eax
  80337c:	89 fa                	mov    %edi,%edx
  80337e:	83 c4 1c             	add    $0x1c,%esp
  803381:	5b                   	pop    %ebx
  803382:	5e                   	pop    %esi
  803383:	5f                   	pop    %edi
  803384:	5d                   	pop    %ebp
  803385:	c3                   	ret    
  803386:	66 90                	xchg   %ax,%ax
  803388:	89 d8                	mov    %ebx,%eax
  80338a:	f7 f7                	div    %edi
  80338c:	31 ff                	xor    %edi,%edi
  80338e:	89 fa                	mov    %edi,%edx
  803390:	83 c4 1c             	add    $0x1c,%esp
  803393:	5b                   	pop    %ebx
  803394:	5e                   	pop    %esi
  803395:	5f                   	pop    %edi
  803396:	5d                   	pop    %ebp
  803397:	c3                   	ret    
  803398:	bd 20 00 00 00       	mov    $0x20,%ebp
  80339d:	89 eb                	mov    %ebp,%ebx
  80339f:	29 fb                	sub    %edi,%ebx
  8033a1:	89 f9                	mov    %edi,%ecx
  8033a3:	d3 e6                	shl    %cl,%esi
  8033a5:	89 c5                	mov    %eax,%ebp
  8033a7:	88 d9                	mov    %bl,%cl
  8033a9:	d3 ed                	shr    %cl,%ebp
  8033ab:	89 e9                	mov    %ebp,%ecx
  8033ad:	09 f1                	or     %esi,%ecx
  8033af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033b3:	89 f9                	mov    %edi,%ecx
  8033b5:	d3 e0                	shl    %cl,%eax
  8033b7:	89 c5                	mov    %eax,%ebp
  8033b9:	89 d6                	mov    %edx,%esi
  8033bb:	88 d9                	mov    %bl,%cl
  8033bd:	d3 ee                	shr    %cl,%esi
  8033bf:	89 f9                	mov    %edi,%ecx
  8033c1:	d3 e2                	shl    %cl,%edx
  8033c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 e8                	shr    %cl,%eax
  8033cb:	09 c2                	or     %eax,%edx
  8033cd:	89 d0                	mov    %edx,%eax
  8033cf:	89 f2                	mov    %esi,%edx
  8033d1:	f7 74 24 0c          	divl   0xc(%esp)
  8033d5:	89 d6                	mov    %edx,%esi
  8033d7:	89 c3                	mov    %eax,%ebx
  8033d9:	f7 e5                	mul    %ebp
  8033db:	39 d6                	cmp    %edx,%esi
  8033dd:	72 19                	jb     8033f8 <__udivdi3+0xfc>
  8033df:	74 0b                	je     8033ec <__udivdi3+0xf0>
  8033e1:	89 d8                	mov    %ebx,%eax
  8033e3:	31 ff                	xor    %edi,%edi
  8033e5:	e9 58 ff ff ff       	jmp    803342 <__udivdi3+0x46>
  8033ea:	66 90                	xchg   %ax,%ax
  8033ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033f0:	89 f9                	mov    %edi,%ecx
  8033f2:	d3 e2                	shl    %cl,%edx
  8033f4:	39 c2                	cmp    %eax,%edx
  8033f6:	73 e9                	jae    8033e1 <__udivdi3+0xe5>
  8033f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033fb:	31 ff                	xor    %edi,%edi
  8033fd:	e9 40 ff ff ff       	jmp    803342 <__udivdi3+0x46>
  803402:	66 90                	xchg   %ax,%ax
  803404:	31 c0                	xor    %eax,%eax
  803406:	e9 37 ff ff ff       	jmp    803342 <__udivdi3+0x46>
  80340b:	90                   	nop

0080340c <__umoddi3>:
  80340c:	55                   	push   %ebp
  80340d:	57                   	push   %edi
  80340e:	56                   	push   %esi
  80340f:	53                   	push   %ebx
  803410:	83 ec 1c             	sub    $0x1c,%esp
  803413:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803417:	8b 74 24 34          	mov    0x34(%esp),%esi
  80341b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803423:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803427:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80342b:	89 f3                	mov    %esi,%ebx
  80342d:	89 fa                	mov    %edi,%edx
  80342f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803433:	89 34 24             	mov    %esi,(%esp)
  803436:	85 c0                	test   %eax,%eax
  803438:	75 1a                	jne    803454 <__umoddi3+0x48>
  80343a:	39 f7                	cmp    %esi,%edi
  80343c:	0f 86 a2 00 00 00    	jbe    8034e4 <__umoddi3+0xd8>
  803442:	89 c8                	mov    %ecx,%eax
  803444:	89 f2                	mov    %esi,%edx
  803446:	f7 f7                	div    %edi
  803448:	89 d0                	mov    %edx,%eax
  80344a:	31 d2                	xor    %edx,%edx
  80344c:	83 c4 1c             	add    $0x1c,%esp
  80344f:	5b                   	pop    %ebx
  803450:	5e                   	pop    %esi
  803451:	5f                   	pop    %edi
  803452:	5d                   	pop    %ebp
  803453:	c3                   	ret    
  803454:	39 f0                	cmp    %esi,%eax
  803456:	0f 87 ac 00 00 00    	ja     803508 <__umoddi3+0xfc>
  80345c:	0f bd e8             	bsr    %eax,%ebp
  80345f:	83 f5 1f             	xor    $0x1f,%ebp
  803462:	0f 84 ac 00 00 00    	je     803514 <__umoddi3+0x108>
  803468:	bf 20 00 00 00       	mov    $0x20,%edi
  80346d:	29 ef                	sub    %ebp,%edi
  80346f:	89 fe                	mov    %edi,%esi
  803471:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803475:	89 e9                	mov    %ebp,%ecx
  803477:	d3 e0                	shl    %cl,%eax
  803479:	89 d7                	mov    %edx,%edi
  80347b:	89 f1                	mov    %esi,%ecx
  80347d:	d3 ef                	shr    %cl,%edi
  80347f:	09 c7                	or     %eax,%edi
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 e2                	shl    %cl,%edx
  803485:	89 14 24             	mov    %edx,(%esp)
  803488:	89 d8                	mov    %ebx,%eax
  80348a:	d3 e0                	shl    %cl,%eax
  80348c:	89 c2                	mov    %eax,%edx
  80348e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803492:	d3 e0                	shl    %cl,%eax
  803494:	89 44 24 04          	mov    %eax,0x4(%esp)
  803498:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349c:	89 f1                	mov    %esi,%ecx
  80349e:	d3 e8                	shr    %cl,%eax
  8034a0:	09 d0                	or     %edx,%eax
  8034a2:	d3 eb                	shr    %cl,%ebx
  8034a4:	89 da                	mov    %ebx,%edx
  8034a6:	f7 f7                	div    %edi
  8034a8:	89 d3                	mov    %edx,%ebx
  8034aa:	f7 24 24             	mull   (%esp)
  8034ad:	89 c6                	mov    %eax,%esi
  8034af:	89 d1                	mov    %edx,%ecx
  8034b1:	39 d3                	cmp    %edx,%ebx
  8034b3:	0f 82 87 00 00 00    	jb     803540 <__umoddi3+0x134>
  8034b9:	0f 84 91 00 00 00    	je     803550 <__umoddi3+0x144>
  8034bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034c3:	29 f2                	sub    %esi,%edx
  8034c5:	19 cb                	sbb    %ecx,%ebx
  8034c7:	89 d8                	mov    %ebx,%eax
  8034c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034cd:	d3 e0                	shl    %cl,%eax
  8034cf:	89 e9                	mov    %ebp,%ecx
  8034d1:	d3 ea                	shr    %cl,%edx
  8034d3:	09 d0                	or     %edx,%eax
  8034d5:	89 e9                	mov    %ebp,%ecx
  8034d7:	d3 eb                	shr    %cl,%ebx
  8034d9:	89 da                	mov    %ebx,%edx
  8034db:	83 c4 1c             	add    $0x1c,%esp
  8034de:	5b                   	pop    %ebx
  8034df:	5e                   	pop    %esi
  8034e0:	5f                   	pop    %edi
  8034e1:	5d                   	pop    %ebp
  8034e2:	c3                   	ret    
  8034e3:	90                   	nop
  8034e4:	89 fd                	mov    %edi,%ebp
  8034e6:	85 ff                	test   %edi,%edi
  8034e8:	75 0b                	jne    8034f5 <__umoddi3+0xe9>
  8034ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ef:	31 d2                	xor    %edx,%edx
  8034f1:	f7 f7                	div    %edi
  8034f3:	89 c5                	mov    %eax,%ebp
  8034f5:	89 f0                	mov    %esi,%eax
  8034f7:	31 d2                	xor    %edx,%edx
  8034f9:	f7 f5                	div    %ebp
  8034fb:	89 c8                	mov    %ecx,%eax
  8034fd:	f7 f5                	div    %ebp
  8034ff:	89 d0                	mov    %edx,%eax
  803501:	e9 44 ff ff ff       	jmp    80344a <__umoddi3+0x3e>
  803506:	66 90                	xchg   %ax,%ax
  803508:	89 c8                	mov    %ecx,%eax
  80350a:	89 f2                	mov    %esi,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	3b 04 24             	cmp    (%esp),%eax
  803517:	72 06                	jb     80351f <__umoddi3+0x113>
  803519:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80351d:	77 0f                	ja     80352e <__umoddi3+0x122>
  80351f:	89 f2                	mov    %esi,%edx
  803521:	29 f9                	sub    %edi,%ecx
  803523:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803527:	89 14 24             	mov    %edx,(%esp)
  80352a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80352e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803532:	8b 14 24             	mov    (%esp),%edx
  803535:	83 c4 1c             	add    $0x1c,%esp
  803538:	5b                   	pop    %ebx
  803539:	5e                   	pop    %esi
  80353a:	5f                   	pop    %edi
  80353b:	5d                   	pop    %ebp
  80353c:	c3                   	ret    
  80353d:	8d 76 00             	lea    0x0(%esi),%esi
  803540:	2b 04 24             	sub    (%esp),%eax
  803543:	19 fa                	sbb    %edi,%edx
  803545:	89 d1                	mov    %edx,%ecx
  803547:	89 c6                	mov    %eax,%esi
  803549:	e9 71 ff ff ff       	jmp    8034bf <__umoddi3+0xb3>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803554:	72 ea                	jb     803540 <__umoddi3+0x134>
  803556:	89 d9                	mov    %ebx,%ecx
  803558:	e9 62 ff ff ff       	jmp    8034bf <__umoddi3+0xb3>
