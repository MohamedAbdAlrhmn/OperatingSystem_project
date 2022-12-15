
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
  80005c:	68 40 36 80 00       	push   $0x803640
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
  8000b9:	68 53 36 80 00       	push   $0x803653
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
  80010f:	68 53 36 80 00       	push   $0x803653
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
  80013e:	e8 d4 17 00 00       	call   801917 <sys_getenvindex>
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
  8001a9:	e8 76 15 00 00       	call   801724 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 78 36 80 00       	push   $0x803678
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
  8001d9:	68 a0 36 80 00       	push   $0x8036a0
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
  80020a:	68 c8 36 80 00       	push   $0x8036c8
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 20 37 80 00       	push   $0x803720
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 78 36 80 00       	push   $0x803678
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 f6 14 00 00       	call   80173e <sys_enable_interrupt>

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
  80025b:	e8 83 16 00 00       	call   8018e3 <sys_destroy_env>
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
  80026c:	e8 d8 16 00 00       	call   801949 <sys_exit_env>
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
  8002ba:	e8 b7 12 00 00       	call   801576 <sys_cputs>
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
  800331:	e8 40 12 00 00       	call   801576 <sys_cputs>
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
  80037b:	e8 a4 13 00 00       	call   801724 <sys_disable_interrupt>
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
  80039b:	e8 9e 13 00 00       	call   80173e <sys_enable_interrupt>
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
  8003e5:	e8 f2 2f 00 00       	call   8033dc <__udivdi3>
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
  800435:	e8 b2 30 00 00       	call   8034ec <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 54 39 80 00       	add    $0x803954,%eax
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
  800590:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
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
  800671:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 65 39 80 00       	push   $0x803965
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
  800696:	68 6e 39 80 00       	push   $0x80396e
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
  8006c3:	be 71 39 80 00       	mov    $0x803971,%esi
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
  8010e9:	68 d0 3a 80 00       	push   $0x803ad0
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
  8011b9:	e8 fc 04 00 00       	call   8016ba <sys_allocate_chunk>
  8011be:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c1:	a1 20 41 80 00       	mov    0x804120,%eax
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 71 0b 00 00       	call   801d40 <initialize_MemBlocksList>
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
  8011f7:	68 f5 3a 80 00       	push   $0x803af5
  8011fc:	6a 33                	push   $0x33
  8011fe:	68 13 3b 80 00       	push   $0x803b13
  801203:	e8 f1 1f 00 00       	call   8031f9 <_panic>
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
  801276:	68 20 3b 80 00       	push   $0x803b20
  80127b:	6a 34                	push   $0x34
  80127d:	68 13 3b 80 00       	push   $0x803b13
  801282:	e8 72 1f 00 00       	call   8031f9 <_panic>
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
  80130e:	e8 75 07 00 00       	call   801a88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801313:	85 c0                	test   %eax,%eax
  801315:	74 11                	je     801328 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	ff 75 e8             	pushl  -0x18(%ebp)
  80131d:	e8 e0 0d 00 00       	call   802102 <alloc_block_FF>
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
  801334:	e8 3c 0b 00 00       	call   801e75 <insert_sorted_allocList>
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
  801354:	68 44 3b 80 00       	push   $0x803b44
  801359:	6a 6f                	push   $0x6f
  80135b:	68 13 3b 80 00       	push   $0x803b13
  801360:	e8 94 1e 00 00       	call   8031f9 <_panic>

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
  80137a:	75 0a                	jne    801386 <smalloc+0x21>
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	e9 8b 00 00 00       	jmp    801411 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801386:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80138d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801393:	01 d0                	add    %edx,%eax
  801395:	48                   	dec    %eax
  801396:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801399:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139c:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a1:	f7 75 f0             	divl   -0x10(%ebp)
  8013a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a7:	29 d0                	sub    %edx,%eax
  8013a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8013ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8013b3:	e8 d0 06 00 00       	call   801a88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	74 11                	je     8013cd <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	e8 3b 0d 00 00       	call   802102 <alloc_block_FF>
  8013c7:	83 c4 10             	add    $0x10,%esp
  8013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8013cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013d1:	74 39                	je     80140c <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d6:	8b 40 08             	mov    0x8(%eax),%eax
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8013df:	52                   	push   %edx
  8013e0:	50                   	push   %eax
  8013e1:	ff 75 0c             	pushl  0xc(%ebp)
  8013e4:	ff 75 08             	pushl  0x8(%ebp)
  8013e7:	e8 21 04 00 00       	call   80180d <sys_createSharedObject>
  8013ec:	83 c4 10             	add    $0x10,%esp
  8013ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8013f2:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8013f6:	74 14                	je     80140c <smalloc+0xa7>
  8013f8:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8013fc:	74 0e                	je     80140c <smalloc+0xa7>
  8013fe:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801402:	74 08                	je     80140c <smalloc+0xa7>
			return (void*) mem_block->sva;
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	8b 40 08             	mov    0x8(%eax),%eax
  80140a:	eb 05                	jmp    801411 <smalloc+0xac>
	}
	return NULL;
  80140c:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801419:	e8 b4 fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80141e:	83 ec 08             	sub    $0x8,%esp
  801421:	ff 75 0c             	pushl  0xc(%ebp)
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 0b 04 00 00       	call   801837 <sys_getSizeOfSharedObject>
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801432:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801436:	74 76                	je     8014ae <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801438:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80143f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801445:	01 d0                	add    %edx,%eax
  801447:	48                   	dec    %eax
  801448:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80144b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80144e:	ba 00 00 00 00       	mov    $0x0,%edx
  801453:	f7 75 ec             	divl   -0x14(%ebp)
  801456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801459:	29 d0                	sub    %edx,%eax
  80145b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80145e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801465:	e8 1e 06 00 00       	call   801a88 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80146a:	85 c0                	test   %eax,%eax
  80146c:	74 11                	je     80147f <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	ff 75 e4             	pushl  -0x1c(%ebp)
  801474:	e8 89 0c 00 00       	call   802102 <alloc_block_FF>
  801479:	83 c4 10             	add    $0x10,%esp
  80147c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80147f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801483:	74 29                	je     8014ae <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801488:	8b 40 08             	mov    0x8(%eax),%eax
  80148b:	83 ec 04             	sub    $0x4,%esp
  80148e:	50                   	push   %eax
  80148f:	ff 75 0c             	pushl  0xc(%ebp)
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 ba 03 00 00       	call   801854 <sys_getSharedObject>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8014a0:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8014a4:	74 08                	je     8014ae <sget+0x9b>
				return (void *)mem_block->sva;
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	8b 40 08             	mov    0x8(%eax),%eax
  8014ac:	eb 05                	jmp    8014b3 <sget+0xa0>
		}
	}
	return NULL;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014bb:	e8 12 fc ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8014c0:	83 ec 04             	sub    $0x4,%esp
  8014c3:	68 68 3b 80 00       	push   $0x803b68
  8014c8:	68 f1 00 00 00       	push   $0xf1
  8014cd:	68 13 3b 80 00       	push   $0x803b13
  8014d2:	e8 22 1d 00 00       	call   8031f9 <_panic>

008014d7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8014dd:	83 ec 04             	sub    $0x4,%esp
  8014e0:	68 90 3b 80 00       	push   $0x803b90
  8014e5:	68 05 01 00 00       	push   $0x105
  8014ea:	68 13 3b 80 00       	push   $0x803b13
  8014ef:	e8 05 1d 00 00       	call   8031f9 <_panic>

008014f4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	68 b4 3b 80 00       	push   $0x803bb4
  801502:	68 10 01 00 00       	push   $0x110
  801507:	68 13 3b 80 00       	push   $0x803b13
  80150c:	e8 e8 1c 00 00       	call   8031f9 <_panic>

00801511 <shrink>:

}
void shrink(uint32 newSize)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801517:	83 ec 04             	sub    $0x4,%esp
  80151a:	68 b4 3b 80 00       	push   $0x803bb4
  80151f:	68 15 01 00 00       	push   $0x115
  801524:	68 13 3b 80 00       	push   $0x803b13
  801529:	e8 cb 1c 00 00       	call   8031f9 <_panic>

0080152e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	68 b4 3b 80 00       	push   $0x803bb4
  80153c:	68 1a 01 00 00       	push   $0x11a
  801541:	68 13 3b 80 00       	push   $0x803b13
  801546:	e8 ae 1c 00 00       	call   8031f9 <_panic>

0080154b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	57                   	push   %edi
  80154f:	56                   	push   %esi
  801550:	53                   	push   %ebx
  801551:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801560:	8b 7d 18             	mov    0x18(%ebp),%edi
  801563:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801566:	cd 30                	int    $0x30
  801568:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80156b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	5b                   	pop    %ebx
  801572:	5e                   	pop    %esi
  801573:	5f                   	pop    %edi
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	83 ec 04             	sub    $0x4,%esp
  80157c:	8b 45 10             	mov    0x10(%ebp),%eax
  80157f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801582:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801586:	8b 45 08             	mov    0x8(%ebp),%eax
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	52                   	push   %edx
  80158e:	ff 75 0c             	pushl  0xc(%ebp)
  801591:	50                   	push   %eax
  801592:	6a 00                	push   $0x0
  801594:	e8 b2 ff ff ff       	call   80154b <syscall>
  801599:	83 c4 18             	add    $0x18,%esp
}
  80159c:	90                   	nop
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_cgetc>:

int
sys_cgetc(void)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 00                	push   $0x0
  8015aa:	6a 00                	push   $0x0
  8015ac:	6a 01                	push   $0x1
  8015ae:	e8 98 ff ff ff       	call   80154b <syscall>
  8015b3:	83 c4 18             	add    $0x18,%esp
}
  8015b6:	c9                   	leave  
  8015b7:	c3                   	ret    

008015b8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	6a 00                	push   $0x0
  8015c7:	52                   	push   %edx
  8015c8:	50                   	push   %eax
  8015c9:	6a 05                	push   $0x5
  8015cb:	e8 7b ff ff ff       	call   80154b <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	56                   	push   %esi
  8015d9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015da:	8b 75 18             	mov    0x18(%ebp),%esi
  8015dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	56                   	push   %esi
  8015ea:	53                   	push   %ebx
  8015eb:	51                   	push   %ecx
  8015ec:	52                   	push   %edx
  8015ed:	50                   	push   %eax
  8015ee:	6a 06                	push   $0x6
  8015f0:	e8 56 ff ff ff       	call   80154b <syscall>
  8015f5:	83 c4 18             	add    $0x18,%esp
}
  8015f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fb:	5b                   	pop    %ebx
  8015fc:	5e                   	pop    %esi
  8015fd:	5d                   	pop    %ebp
  8015fe:	c3                   	ret    

008015ff <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801602:	8b 55 0c             	mov    0xc(%ebp),%edx
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
  801608:	6a 00                	push   $0x0
  80160a:	6a 00                	push   $0x0
  80160c:	6a 00                	push   $0x0
  80160e:	52                   	push   %edx
  80160f:	50                   	push   %eax
  801610:	6a 07                	push   $0x7
  801612:	e8 34 ff ff ff       	call   80154b <syscall>
  801617:	83 c4 18             	add    $0x18,%esp
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	ff 75 0c             	pushl  0xc(%ebp)
  801628:	ff 75 08             	pushl  0x8(%ebp)
  80162b:	6a 08                	push   $0x8
  80162d:	e8 19 ff ff ff       	call   80154b <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 09                	push   $0x9
  801646:	e8 00 ff ff ff       	call   80154b <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 0a                	push   $0xa
  80165f:	e8 e7 fe ff ff       	call   80154b <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
}
  801667:	c9                   	leave  
  801668:	c3                   	ret    

00801669 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801669:	55                   	push   %ebp
  80166a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 0b                	push   $0xb
  801678:	e8 ce fe ff ff       	call   80154b <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
}
  801680:	c9                   	leave  
  801681:	c3                   	ret    

00801682 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801682:	55                   	push   %ebp
  801683:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	ff 75 0c             	pushl  0xc(%ebp)
  80168e:	ff 75 08             	pushl  0x8(%ebp)
  801691:	6a 0f                	push   $0xf
  801693:	e8 b3 fe ff ff       	call   80154b <syscall>
  801698:	83 c4 18             	add    $0x18,%esp
	return;
  80169b:	90                   	nop
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	6a 00                	push   $0x0
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	6a 10                	push   $0x10
  8016af:	e8 97 fe ff ff       	call   80154b <syscall>
  8016b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8016b7:	90                   	nop
}
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 00                	push   $0x0
  8016c1:	ff 75 10             	pushl  0x10(%ebp)
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	6a 11                	push   $0x11
  8016cc:	e8 7a fe ff ff       	call   80154b <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return ;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 0c                	push   $0xc
  8016e6:	e8 60 fe ff ff       	call   80154b <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	ff 75 08             	pushl  0x8(%ebp)
  8016fe:	6a 0d                	push   $0xd
  801700:	e8 46 fe ff ff       	call   80154b <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 0e                	push   $0xe
  801719:	e8 2d fe ff ff       	call   80154b <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	90                   	nop
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 13                	push   $0x13
  801733:	e8 13 fe ff ff       	call   80154b <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 14                	push   $0x14
  80174d:	e8 f9 fd ff ff       	call   80154b <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	90                   	nop
  801756:	c9                   	leave  
  801757:	c3                   	ret    

00801758 <sys_cputc>:


void
sys_cputc(const char c)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	8b 45 08             	mov    0x8(%ebp),%eax
  801761:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801764:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	50                   	push   %eax
  801771:	6a 15                	push   $0x15
  801773:	e8 d3 fd ff ff       	call   80154b <syscall>
  801778:	83 c4 18             	add    $0x18,%esp
}
  80177b:	90                   	nop
  80177c:	c9                   	leave  
  80177d:	c3                   	ret    

0080177e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 16                	push   $0x16
  80178d:	e8 b9 fd ff ff       	call   80154b <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	90                   	nop
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	50                   	push   %eax
  8017a8:	6a 17                	push   $0x17
  8017aa:	e8 9c fd ff ff       	call   80154b <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	52                   	push   %edx
  8017c4:	50                   	push   %eax
  8017c5:	6a 1a                	push   $0x1a
  8017c7:	e8 7f fd ff ff       	call   80154b <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	52                   	push   %edx
  8017e1:	50                   	push   %eax
  8017e2:	6a 18                	push   $0x18
  8017e4:	e8 62 fd ff ff       	call   80154b <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	90                   	nop
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	52                   	push   %edx
  8017ff:	50                   	push   %eax
  801800:	6a 19                	push   $0x19
  801802:	e8 44 fd ff ff       	call   80154b <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	90                   	nop
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	8b 45 10             	mov    0x10(%ebp),%eax
  801816:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801819:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801820:	8b 45 08             	mov    0x8(%ebp),%eax
  801823:	6a 00                	push   $0x0
  801825:	51                   	push   %ecx
  801826:	52                   	push   %edx
  801827:	ff 75 0c             	pushl  0xc(%ebp)
  80182a:	50                   	push   %eax
  80182b:	6a 1b                	push   $0x1b
  80182d:	e8 19 fd ff ff       	call   80154b <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	52                   	push   %edx
  801847:	50                   	push   %eax
  801848:	6a 1c                	push   $0x1c
  80184a:	e8 fc fc ff ff       	call   80154b <syscall>
  80184f:	83 c4 18             	add    $0x18,%esp
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801857:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	51                   	push   %ecx
  801865:	52                   	push   %edx
  801866:	50                   	push   %eax
  801867:	6a 1d                	push   $0x1d
  801869:	e8 dd fc ff ff       	call   80154b <syscall>
  80186e:	83 c4 18             	add    $0x18,%esp
}
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 1e                	push   $0x1e
  801886:	e8 c0 fc ff ff       	call   80154b <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 1f                	push   $0x1f
  80189f:	e8 a7 fc ff ff       	call   80154b <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 14             	pushl  0x14(%ebp)
  8018b4:	ff 75 10             	pushl  0x10(%ebp)
  8018b7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ba:	50                   	push   %eax
  8018bb:	6a 20                	push   $0x20
  8018bd:	e8 89 fc ff ff       	call   80154b <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	50                   	push   %eax
  8018d6:	6a 21                	push   $0x21
  8018d8:	e8 6e fc ff ff       	call   80154b <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	50                   	push   %eax
  8018f2:	6a 22                	push   $0x22
  8018f4:	e8 52 fc ff ff       	call   80154b <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 02                	push   $0x2
  80190d:	e8 39 fc ff ff       	call   80154b <syscall>
  801912:	83 c4 18             	add    $0x18,%esp
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 03                	push   $0x3
  801926:	e8 20 fc ff ff       	call   80154b <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 04                	push   $0x4
  80193f:	e8 07 fc ff ff       	call   80154b <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_exit_env>:


void sys_exit_env(void)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 23                	push   $0x23
  801958:	e8 ee fb ff ff       	call   80154b <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	90                   	nop
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801969:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80196c:	8d 50 04             	lea    0x4(%eax),%edx
  80196f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 24                	push   $0x24
  80197c:	e8 ca fb ff ff       	call   80154b <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
	return result;
  801984:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801987:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80198a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80198d:	89 01                	mov    %eax,(%ecx)
  80198f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	c9                   	leave  
  801996:	c2 04 00             	ret    $0x4

00801999 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	ff 75 10             	pushl  0x10(%ebp)
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	ff 75 08             	pushl  0x8(%ebp)
  8019a9:	6a 12                	push   $0x12
  8019ab:	e8 9b fb ff ff       	call   80154b <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b3:	90                   	nop
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 25                	push   $0x25
  8019c5:	e8 81 fb ff ff       	call   80154b <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019db:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	50                   	push   %eax
  8019e8:	6a 26                	push   $0x26
  8019ea:	e8 5c fb ff ff       	call   80154b <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f2:	90                   	nop
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <rsttst>:
void rsttst()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 28                	push   $0x28
  801a04:	e8 42 fb ff ff       	call   80154b <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0c:	90                   	nop
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	8b 45 14             	mov    0x14(%ebp),%eax
  801a18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a1b:	8b 55 18             	mov    0x18(%ebp),%edx
  801a1e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a22:	52                   	push   %edx
  801a23:	50                   	push   %eax
  801a24:	ff 75 10             	pushl  0x10(%ebp)
  801a27:	ff 75 0c             	pushl  0xc(%ebp)
  801a2a:	ff 75 08             	pushl  0x8(%ebp)
  801a2d:	6a 27                	push   $0x27
  801a2f:	e8 17 fb ff ff       	call   80154b <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
	return ;
  801a37:	90                   	nop
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <chktst>:
void chktst(uint32 n)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 29                	push   $0x29
  801a4a:	e8 fc fa ff ff       	call   80154b <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a52:	90                   	nop
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <inctst>:

void inctst()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 2a                	push   $0x2a
  801a64:	e8 e2 fa ff ff       	call   80154b <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6c:	90                   	nop
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <gettst>:
uint32 gettst()
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 2b                	push   $0x2b
  801a7e:	e8 c8 fa ff ff       	call   80154b <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 2c                	push   $0x2c
  801a9a:	e8 ac fa ff ff       	call   80154b <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
  801aa2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801aa5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aa9:	75 07                	jne    801ab2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801aab:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab0:	eb 05                	jmp    801ab7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 2c                	push   $0x2c
  801acb:	e8 7b fa ff ff       	call   80154b <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
  801ad3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ad6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ada:	75 07                	jne    801ae3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801adc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae1:	eb 05                	jmp    801ae8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ae3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
  801aed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 2c                	push   $0x2c
  801afc:	e8 4a fa ff ff       	call   80154b <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
  801b04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b07:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b0b:	75 07                	jne    801b14 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b12:	eb 05                	jmp    801b19 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 2c                	push   $0x2c
  801b2d:	e8 19 fa ff ff       	call   80154b <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
  801b35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b38:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b3c:	75 07                	jne    801b45 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b43:	eb 05                	jmp    801b4a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	ff 75 08             	pushl  0x8(%ebp)
  801b5a:	6a 2d                	push   $0x2d
  801b5c:	e8 ea f9 ff ff       	call   80154b <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
	return ;
  801b64:	90                   	nop
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b6b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	6a 00                	push   $0x0
  801b79:	53                   	push   %ebx
  801b7a:	51                   	push   %ecx
  801b7b:	52                   	push   %edx
  801b7c:	50                   	push   %eax
  801b7d:	6a 2e                	push   $0x2e
  801b7f:	e8 c7 f9 ff ff       	call   80154b <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	52                   	push   %edx
  801b9c:	50                   	push   %eax
  801b9d:	6a 2f                	push   $0x2f
  801b9f:	e8 a7 f9 ff ff       	call   80154b <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	68 c4 3b 80 00       	push   $0x803bc4
  801bb7:	e8 8c e7 ff ff       	call   800348 <cprintf>
  801bbc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801bbf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801bc6:	83 ec 0c             	sub    $0xc,%esp
  801bc9:	68 f0 3b 80 00       	push   $0x803bf0
  801bce:	e8 75 e7 ff ff       	call   800348 <cprintf>
  801bd3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801bd6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801bda:	a1 38 41 80 00       	mov    0x804138,%eax
  801bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801be2:	eb 56                	jmp    801c3a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801be4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be8:	74 1c                	je     801c06 <print_mem_block_lists+0x5d>
  801bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bed:	8b 50 08             	mov    0x8(%eax),%edx
  801bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf3:	8b 48 08             	mov    0x8(%eax),%ecx
  801bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bfc:	01 c8                	add    %ecx,%eax
  801bfe:	39 c2                	cmp    %eax,%edx
  801c00:	73 04                	jae    801c06 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c02:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c09:	8b 50 08             	mov    0x8(%eax),%edx
  801c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c12:	01 c2                	add    %eax,%edx
  801c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c17:	8b 40 08             	mov    0x8(%eax),%eax
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	68 05 3c 80 00       	push   $0x803c05
  801c24:	e8 1f e7 ff ff       	call   800348 <cprintf>
  801c29:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c32:	a1 40 41 80 00       	mov    0x804140,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c3e:	74 07                	je     801c47 <print_mem_block_lists+0x9e>
  801c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c43:	8b 00                	mov    (%eax),%eax
  801c45:	eb 05                	jmp    801c4c <print_mem_block_lists+0xa3>
  801c47:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4c:	a3 40 41 80 00       	mov    %eax,0x804140
  801c51:	a1 40 41 80 00       	mov    0x804140,%eax
  801c56:	85 c0                	test   %eax,%eax
  801c58:	75 8a                	jne    801be4 <print_mem_block_lists+0x3b>
  801c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c5e:	75 84                	jne    801be4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801c60:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801c64:	75 10                	jne    801c76 <print_mem_block_lists+0xcd>
  801c66:	83 ec 0c             	sub    $0xc,%esp
  801c69:	68 14 3c 80 00       	push   $0x803c14
  801c6e:	e8 d5 e6 ff ff       	call   800348 <cprintf>
  801c73:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801c76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801c7d:	83 ec 0c             	sub    $0xc,%esp
  801c80:	68 38 3c 80 00       	push   $0x803c38
  801c85:	e8 be e6 ff ff       	call   800348 <cprintf>
  801c8a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801c8d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801c91:	a1 40 40 80 00       	mov    0x804040,%eax
  801c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c99:	eb 56                	jmp    801cf1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c9f:	74 1c                	je     801cbd <print_mem_block_lists+0x114>
  801ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca4:	8b 50 08             	mov    0x8(%eax),%edx
  801ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801caa:	8b 48 08             	mov    0x8(%eax),%ecx
  801cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb3:	01 c8                	add    %ecx,%eax
  801cb5:	39 c2                	cmp    %eax,%edx
  801cb7:	73 04                	jae    801cbd <print_mem_block_lists+0x114>
			sorted = 0 ;
  801cb9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc0:	8b 50 08             	mov    0x8(%eax),%edx
  801cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc6:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc9:	01 c2                	add    %eax,%edx
  801ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cce:	8b 40 08             	mov    0x8(%eax),%eax
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	52                   	push   %edx
  801cd5:	50                   	push   %eax
  801cd6:	68 05 3c 80 00       	push   $0x803c05
  801cdb:	e8 68 e6 ff ff       	call   800348 <cprintf>
  801ce0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ce9:	a1 48 40 80 00       	mov    0x804048,%eax
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf5:	74 07                	je     801cfe <print_mem_block_lists+0x155>
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfa:	8b 00                	mov    (%eax),%eax
  801cfc:	eb 05                	jmp    801d03 <print_mem_block_lists+0x15a>
  801cfe:	b8 00 00 00 00       	mov    $0x0,%eax
  801d03:	a3 48 40 80 00       	mov    %eax,0x804048
  801d08:	a1 48 40 80 00       	mov    0x804048,%eax
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	75 8a                	jne    801c9b <print_mem_block_lists+0xf2>
  801d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d15:	75 84                	jne    801c9b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d17:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d1b:	75 10                	jne    801d2d <print_mem_block_lists+0x184>
  801d1d:	83 ec 0c             	sub    $0xc,%esp
  801d20:	68 50 3c 80 00       	push   $0x803c50
  801d25:	e8 1e e6 ff ff       	call   800348 <cprintf>
  801d2a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801d2d:	83 ec 0c             	sub    $0xc,%esp
  801d30:	68 c4 3b 80 00       	push   $0x803bc4
  801d35:	e8 0e e6 ff ff       	call   800348 <cprintf>
  801d3a:	83 c4 10             	add    $0x10,%esp

}
  801d3d:	90                   	nop
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801d46:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801d4d:	00 00 00 
  801d50:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801d57:	00 00 00 
  801d5a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801d61:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801d64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d6b:	e9 9e 00 00 00       	jmp    801e0e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801d70:	a1 50 40 80 00       	mov    0x804050,%eax
  801d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d78:	c1 e2 04             	shl    $0x4,%edx
  801d7b:	01 d0                	add    %edx,%eax
  801d7d:	85 c0                	test   %eax,%eax
  801d7f:	75 14                	jne    801d95 <initialize_MemBlocksList+0x55>
  801d81:	83 ec 04             	sub    $0x4,%esp
  801d84:	68 78 3c 80 00       	push   $0x803c78
  801d89:	6a 46                	push   $0x46
  801d8b:	68 9b 3c 80 00       	push   $0x803c9b
  801d90:	e8 64 14 00 00       	call   8031f9 <_panic>
  801d95:	a1 50 40 80 00       	mov    0x804050,%eax
  801d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9d:	c1 e2 04             	shl    $0x4,%edx
  801da0:	01 d0                	add    %edx,%eax
  801da2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801da8:	89 10                	mov    %edx,(%eax)
  801daa:	8b 00                	mov    (%eax),%eax
  801dac:	85 c0                	test   %eax,%eax
  801dae:	74 18                	je     801dc8 <initialize_MemBlocksList+0x88>
  801db0:	a1 48 41 80 00       	mov    0x804148,%eax
  801db5:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801dbb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801dbe:	c1 e1 04             	shl    $0x4,%ecx
  801dc1:	01 ca                	add    %ecx,%edx
  801dc3:	89 50 04             	mov    %edx,0x4(%eax)
  801dc6:	eb 12                	jmp    801dda <initialize_MemBlocksList+0x9a>
  801dc8:	a1 50 40 80 00       	mov    0x804050,%eax
  801dcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd0:	c1 e2 04             	shl    $0x4,%edx
  801dd3:	01 d0                	add    %edx,%eax
  801dd5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801dda:	a1 50 40 80 00       	mov    0x804050,%eax
  801ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de2:	c1 e2 04             	shl    $0x4,%edx
  801de5:	01 d0                	add    %edx,%eax
  801de7:	a3 48 41 80 00       	mov    %eax,0x804148
  801dec:	a1 50 40 80 00       	mov    0x804050,%eax
  801df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df4:	c1 e2 04             	shl    $0x4,%edx
  801df7:	01 d0                	add    %edx,%eax
  801df9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e00:	a1 54 41 80 00       	mov    0x804154,%eax
  801e05:	40                   	inc    %eax
  801e06:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801e0b:	ff 45 f4             	incl   -0xc(%ebp)
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e14:	0f 82 56 ff ff ff    	jb     801d70 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801e1a:	90                   	nop
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	8b 00                	mov    (%eax),%eax
  801e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e2b:	eb 19                	jmp    801e46 <find_block+0x29>
	{
		if(va==point->sva)
  801e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e30:	8b 40 08             	mov    0x8(%eax),%eax
  801e33:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801e36:	75 05                	jne    801e3d <find_block+0x20>
		   return point;
  801e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e3b:	eb 36                	jmp    801e73 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	8b 40 08             	mov    0x8(%eax),%eax
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801e46:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e4a:	74 07                	je     801e53 <find_block+0x36>
  801e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e4f:	8b 00                	mov    (%eax),%eax
  801e51:	eb 05                	jmp    801e58 <find_block+0x3b>
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
  801e58:	8b 55 08             	mov    0x8(%ebp),%edx
  801e5b:	89 42 08             	mov    %eax,0x8(%edx)
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	8b 40 08             	mov    0x8(%eax),%eax
  801e64:	85 c0                	test   %eax,%eax
  801e66:	75 c5                	jne    801e2d <find_block+0x10>
  801e68:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e6c:	75 bf                	jne    801e2d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801e7b:	a1 40 40 80 00       	mov    0x804040,%eax
  801e80:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801e83:	a1 44 40 80 00       	mov    0x804044,%eax
  801e88:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801e91:	74 24                	je     801eb7 <insert_sorted_allocList+0x42>
  801e93:	8b 45 08             	mov    0x8(%ebp),%eax
  801e96:	8b 50 08             	mov    0x8(%eax),%edx
  801e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9c:	8b 40 08             	mov    0x8(%eax),%eax
  801e9f:	39 c2                	cmp    %eax,%edx
  801ea1:	76 14                	jbe    801eb7 <insert_sorted_allocList+0x42>
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	8b 50 08             	mov    0x8(%eax),%edx
  801ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eac:	8b 40 08             	mov    0x8(%eax),%eax
  801eaf:	39 c2                	cmp    %eax,%edx
  801eb1:	0f 82 60 01 00 00    	jb     802017 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebb:	75 65                	jne    801f22 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ebd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ec1:	75 14                	jne    801ed7 <insert_sorted_allocList+0x62>
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 78 3c 80 00       	push   $0x803c78
  801ecb:	6a 6b                	push   $0x6b
  801ecd:	68 9b 3c 80 00       	push   $0x803c9b
  801ed2:	e8 22 13 00 00       	call   8031f9 <_panic>
  801ed7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	89 10                	mov    %edx,(%eax)
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	74 0d                	je     801ef8 <insert_sorted_allocList+0x83>
  801eeb:	a1 40 40 80 00       	mov    0x804040,%eax
  801ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef3:	89 50 04             	mov    %edx,0x4(%eax)
  801ef6:	eb 08                	jmp    801f00 <insert_sorted_allocList+0x8b>
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	a3 44 40 80 00       	mov    %eax,0x804044
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	a3 40 40 80 00       	mov    %eax,0x804040
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f12:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f17:	40                   	inc    %eax
  801f18:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f1d:	e9 dc 01 00 00       	jmp    8020fe <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	8b 50 08             	mov    0x8(%eax),%edx
  801f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2b:	8b 40 08             	mov    0x8(%eax),%eax
  801f2e:	39 c2                	cmp    %eax,%edx
  801f30:	77 6c                	ja     801f9e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801f32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f36:	74 06                	je     801f3e <insert_sorted_allocList+0xc9>
  801f38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f3c:	75 14                	jne    801f52 <insert_sorted_allocList+0xdd>
  801f3e:	83 ec 04             	sub    $0x4,%esp
  801f41:	68 b4 3c 80 00       	push   $0x803cb4
  801f46:	6a 6f                	push   $0x6f
  801f48:	68 9b 3c 80 00       	push   $0x803c9b
  801f4d:	e8 a7 12 00 00       	call   8031f9 <_panic>
  801f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f55:	8b 50 04             	mov    0x4(%eax),%edx
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	89 50 04             	mov    %edx,0x4(%eax)
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f64:	89 10                	mov    %edx,(%eax)
  801f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f69:	8b 40 04             	mov    0x4(%eax),%eax
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	74 0d                	je     801f7d <insert_sorted_allocList+0x108>
  801f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f73:	8b 40 04             	mov    0x4(%eax),%eax
  801f76:	8b 55 08             	mov    0x8(%ebp),%edx
  801f79:	89 10                	mov    %edx,(%eax)
  801f7b:	eb 08                	jmp    801f85 <insert_sorted_allocList+0x110>
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	a3 40 40 80 00       	mov    %eax,0x804040
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	8b 55 08             	mov    0x8(%ebp),%edx
  801f8b:	89 50 04             	mov    %edx,0x4(%eax)
  801f8e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f93:	40                   	inc    %eax
  801f94:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f99:	e9 60 01 00 00       	jmp    8020fe <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	8b 50 08             	mov    0x8(%eax),%edx
  801fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa7:	8b 40 08             	mov    0x8(%eax),%eax
  801faa:	39 c2                	cmp    %eax,%edx
  801fac:	0f 82 4c 01 00 00    	jb     8020fe <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  801fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fb6:	75 14                	jne    801fcc <insert_sorted_allocList+0x157>
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	68 ec 3c 80 00       	push   $0x803cec
  801fc0:	6a 73                	push   $0x73
  801fc2:	68 9b 3c 80 00       	push   $0x803c9b
  801fc7:	e8 2d 12 00 00       	call   8031f9 <_panic>
  801fcc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  801fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd5:	89 50 04             	mov    %edx,0x4(%eax)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 40 04             	mov    0x4(%eax),%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	74 0c                	je     801fee <insert_sorted_allocList+0x179>
  801fe2:	a1 44 40 80 00       	mov    0x804044,%eax
  801fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  801fea:	89 10                	mov    %edx,(%eax)
  801fec:	eb 08                	jmp    801ff6 <insert_sorted_allocList+0x181>
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	a3 40 40 80 00       	mov    %eax,0x804040
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	a3 44 40 80 00       	mov    %eax,0x804044
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802007:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80200c:	40                   	inc    %eax
  80200d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802012:	e9 e7 00 00 00       	jmp    8020fe <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80201d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802024:	a1 40 40 80 00       	mov    0x804040,%eax
  802029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202c:	e9 9d 00 00 00       	jmp    8020ce <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	8b 00                	mov    (%eax),%eax
  802036:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 50 08             	mov    0x8(%eax),%edx
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	8b 40 08             	mov    0x8(%eax),%eax
  802045:	39 c2                	cmp    %eax,%edx
  802047:	76 7d                	jbe    8020c6 <insert_sorted_allocList+0x251>
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	8b 50 08             	mov    0x8(%eax),%edx
  80204f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802052:	8b 40 08             	mov    0x8(%eax),%eax
  802055:	39 c2                	cmp    %eax,%edx
  802057:	73 6d                	jae    8020c6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802059:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205d:	74 06                	je     802065 <insert_sorted_allocList+0x1f0>
  80205f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802063:	75 14                	jne    802079 <insert_sorted_allocList+0x204>
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	68 10 3d 80 00       	push   $0x803d10
  80206d:	6a 7f                	push   $0x7f
  80206f:	68 9b 3c 80 00       	push   $0x803c9b
  802074:	e8 80 11 00 00       	call   8031f9 <_panic>
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 10                	mov    (%eax),%edx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	89 10                	mov    %edx,(%eax)
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	8b 00                	mov    (%eax),%eax
  802088:	85 c0                	test   %eax,%eax
  80208a:	74 0b                	je     802097 <insert_sorted_allocList+0x222>
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 00                	mov    (%eax),%eax
  802091:	8b 55 08             	mov    0x8(%ebp),%edx
  802094:	89 50 04             	mov    %edx,0x4(%eax)
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 55 08             	mov    0x8(%ebp),%edx
  80209d:	89 10                	mov    %edx,(%eax)
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a5:	89 50 04             	mov    %edx,0x4(%eax)
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	8b 00                	mov    (%eax),%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	75 08                	jne    8020b9 <insert_sorted_allocList+0x244>
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020be:	40                   	inc    %eax
  8020bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8020c4:	eb 39                	jmp    8020ff <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020c6:	a1 48 40 80 00       	mov    0x804048,%eax
  8020cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d2:	74 07                	je     8020db <insert_sorted_allocList+0x266>
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	8b 00                	mov    (%eax),%eax
  8020d9:	eb 05                	jmp    8020e0 <insert_sorted_allocList+0x26b>
  8020db:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e0:	a3 48 40 80 00       	mov    %eax,0x804048
  8020e5:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ea:	85 c0                	test   %eax,%eax
  8020ec:	0f 85 3f ff ff ff    	jne    802031 <insert_sorted_allocList+0x1bc>
  8020f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f6:	0f 85 35 ff ff ff    	jne    802031 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8020fc:	eb 01                	jmp    8020ff <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020fe:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8020ff:	90                   	nop
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802108:	a1 38 41 80 00       	mov    0x804138,%eax
  80210d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802110:	e9 85 01 00 00       	jmp    80229a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 40 0c             	mov    0xc(%eax),%eax
  80211b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211e:	0f 82 6e 01 00 00    	jb     802292 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 0c             	mov    0xc(%eax),%eax
  80212a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80212d:	0f 85 8a 00 00 00    	jne    8021bd <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802133:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802137:	75 17                	jne    802150 <alloc_block_FF+0x4e>
  802139:	83 ec 04             	sub    $0x4,%esp
  80213c:	68 44 3d 80 00       	push   $0x803d44
  802141:	68 93 00 00 00       	push   $0x93
  802146:	68 9b 3c 80 00       	push   $0x803c9b
  80214b:	e8 a9 10 00 00       	call   8031f9 <_panic>
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	74 10                	je     802169 <alloc_block_FF+0x67>
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802161:	8b 52 04             	mov    0x4(%edx),%edx
  802164:	89 50 04             	mov    %edx,0x4(%eax)
  802167:	eb 0b                	jmp    802174 <alloc_block_FF+0x72>
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 40 04             	mov    0x4(%eax),%eax
  80216f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 40 04             	mov    0x4(%eax),%eax
  80217a:	85 c0                	test   %eax,%eax
  80217c:	74 0f                	je     80218d <alloc_block_FF+0x8b>
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	8b 40 04             	mov    0x4(%eax),%eax
  802184:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802187:	8b 12                	mov    (%edx),%edx
  802189:	89 10                	mov    %edx,(%eax)
  80218b:	eb 0a                	jmp    802197 <alloc_block_FF+0x95>
  80218d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	a3 38 41 80 00       	mov    %eax,0x804138
  802197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021aa:	a1 44 41 80 00       	mov    0x804144,%eax
  8021af:	48                   	dec    %eax
  8021b0:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	e9 10 01 00 00       	jmp    8022cd <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c6:	0f 86 c6 00 00 00    	jbe    802292 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8021cc:	a1 48 41 80 00       	mov    0x804148,%eax
  8021d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 50 08             	mov    0x8(%eax),%edx
  8021da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dd:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e6:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8021e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ed:	75 17                	jne    802206 <alloc_block_FF+0x104>
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	68 44 3d 80 00       	push   $0x803d44
  8021f7:	68 9b 00 00 00       	push   $0x9b
  8021fc:	68 9b 3c 80 00       	push   $0x803c9b
  802201:	e8 f3 0f 00 00       	call   8031f9 <_panic>
  802206:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 10                	je     80221f <alloc_block_FF+0x11d>
  80220f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802217:	8b 52 04             	mov    0x4(%edx),%edx
  80221a:	89 50 04             	mov    %edx,0x4(%eax)
  80221d:	eb 0b                	jmp    80222a <alloc_block_FF+0x128>
  80221f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802222:	8b 40 04             	mov    0x4(%eax),%eax
  802225:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80222a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222d:	8b 40 04             	mov    0x4(%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	74 0f                	je     802243 <alloc_block_FF+0x141>
  802234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223d:	8b 12                	mov    (%edx),%edx
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	eb 0a                	jmp    80224d <alloc_block_FF+0x14b>
  802243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	a3 48 41 80 00       	mov    %eax,0x804148
  80224d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802260:	a1 54 41 80 00       	mov    0x804154,%eax
  802265:	48                   	dec    %eax
  802266:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	8b 50 08             	mov    0x8(%eax),%edx
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	01 c2                	add    %eax,%edx
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 40 0c             	mov    0xc(%eax),%eax
  802282:	2b 45 08             	sub    0x8(%ebp),%eax
  802285:	89 c2                	mov    %eax,%edx
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80228d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802290:	eb 3b                	jmp    8022cd <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802292:	a1 40 41 80 00       	mov    0x804140,%eax
  802297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229e:	74 07                	je     8022a7 <alloc_block_FF+0x1a5>
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 00                	mov    (%eax),%eax
  8022a5:	eb 05                	jmp    8022ac <alloc_block_FF+0x1aa>
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8022b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8022b6:	85 c0                	test   %eax,%eax
  8022b8:	0f 85 57 fe ff ff    	jne    802115 <alloc_block_FF+0x13>
  8022be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c2:	0f 85 4d fe ff ff    	jne    802115 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
  8022d2:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8022d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8022dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e4:	e9 df 00 00 00       	jmp    8023c8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f2:	0f 82 c8 00 00 00    	jb     8023c0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802301:	0f 85 8a 00 00 00    	jne    802391 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230b:	75 17                	jne    802324 <alloc_block_BF+0x55>
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 44 3d 80 00       	push   $0x803d44
  802315:	68 b7 00 00 00       	push   $0xb7
  80231a:	68 9b 3c 80 00       	push   $0x803c9b
  80231f:	e8 d5 0e 00 00       	call   8031f9 <_panic>
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 10                	je     80233d <alloc_block_BF+0x6e>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802335:	8b 52 04             	mov    0x4(%edx),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	eb 0b                	jmp    802348 <alloc_block_BF+0x79>
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 40 04             	mov    0x4(%eax),%eax
  802343:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 40 04             	mov    0x4(%eax),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	74 0f                	je     802361 <alloc_block_BF+0x92>
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 40 04             	mov    0x4(%eax),%eax
  802358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235b:	8b 12                	mov    (%edx),%edx
  80235d:	89 10                	mov    %edx,(%eax)
  80235f:	eb 0a                	jmp    80236b <alloc_block_BF+0x9c>
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	8b 00                	mov    (%eax),%eax
  802366:	a3 38 41 80 00       	mov    %eax,0x804138
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80237e:	a1 44 41 80 00       	mov    0x804144,%eax
  802383:	48                   	dec    %eax
  802384:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	e9 4d 01 00 00       	jmp    8024de <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 40 0c             	mov    0xc(%eax),%eax
  802397:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239a:	76 24                	jbe    8023c0 <alloc_block_BF+0xf1>
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023a5:	73 19                	jae    8023c0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8023a7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 08             	mov    0x8(%eax),%eax
  8023bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	74 07                	je     8023d5 <alloc_block_BF+0x106>
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 00                	mov    (%eax),%eax
  8023d3:	eb 05                	jmp    8023da <alloc_block_BF+0x10b>
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023da:	a3 40 41 80 00       	mov    %eax,0x804140
  8023df:	a1 40 41 80 00       	mov    0x804140,%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	0f 85 fd fe ff ff    	jne    8022e9 <alloc_block_BF+0x1a>
  8023ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f0:	0f 85 f3 fe ff ff    	jne    8022e9 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8023f6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8023fa:	0f 84 d9 00 00 00    	je     8024d9 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802400:	a1 48 41 80 00       	mov    0x804148,%eax
  802405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802408:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80240b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80240e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802414:	8b 55 08             	mov    0x8(%ebp),%edx
  802417:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80241a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80241e:	75 17                	jne    802437 <alloc_block_BF+0x168>
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	68 44 3d 80 00       	push   $0x803d44
  802428:	68 c7 00 00 00       	push   $0xc7
  80242d:	68 9b 3c 80 00       	push   $0x803c9b
  802432:	e8 c2 0d 00 00       	call   8031f9 <_panic>
  802437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 10                	je     802450 <alloc_block_BF+0x181>
  802440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802448:	8b 52 04             	mov    0x4(%edx),%edx
  80244b:	89 50 04             	mov    %edx,0x4(%eax)
  80244e:	eb 0b                	jmp    80245b <alloc_block_BF+0x18c>
  802450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80245b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80245e:	8b 40 04             	mov    0x4(%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 0f                	je     802474 <alloc_block_BF+0x1a5>
  802465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80246e:	8b 12                	mov    (%edx),%edx
  802470:	89 10                	mov    %edx,(%eax)
  802472:	eb 0a                	jmp    80247e <alloc_block_BF+0x1af>
  802474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	a3 48 41 80 00       	mov    %eax,0x804148
  80247e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80248a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802491:	a1 54 41 80 00       	mov    0x804154,%eax
  802496:	48                   	dec    %eax
  802497:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80249c:	83 ec 08             	sub    $0x8,%esp
  80249f:	ff 75 ec             	pushl  -0x14(%ebp)
  8024a2:	68 38 41 80 00       	push   $0x804138
  8024a7:	e8 71 f9 ff ff       	call   801e1d <find_block>
  8024ac:	83 c4 10             	add    $0x10,%esp
  8024af:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8024b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b5:	8b 50 08             	mov    0x8(%eax),%edx
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	01 c2                	add    %eax,%edx
  8024bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8024c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8024cc:	89 c2                	mov    %eax,%edx
  8024ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d1:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8024d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d7:	eb 05                	jmp    8024de <alloc_block_BF+0x20f>
	}
	return NULL;
  8024d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8024e6:	a1 28 40 80 00       	mov    0x804028,%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	0f 85 de 01 00 00    	jne    8026d1 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8024f3:	a1 38 41 80 00       	mov    0x804138,%eax
  8024f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fb:	e9 9e 01 00 00       	jmp    80269e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 0c             	mov    0xc(%eax),%eax
  802506:	3b 45 08             	cmp    0x8(%ebp),%eax
  802509:	0f 82 87 01 00 00    	jb     802696 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 0c             	mov    0xc(%eax),%eax
  802515:	3b 45 08             	cmp    0x8(%ebp),%eax
  802518:	0f 85 95 00 00 00    	jne    8025b3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80251e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802522:	75 17                	jne    80253b <alloc_block_NF+0x5b>
  802524:	83 ec 04             	sub    $0x4,%esp
  802527:	68 44 3d 80 00       	push   $0x803d44
  80252c:	68 e0 00 00 00       	push   $0xe0
  802531:	68 9b 3c 80 00       	push   $0x803c9b
  802536:	e8 be 0c 00 00       	call   8031f9 <_panic>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	85 c0                	test   %eax,%eax
  802542:	74 10                	je     802554 <alloc_block_NF+0x74>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254c:	8b 52 04             	mov    0x4(%edx),%edx
  80254f:	89 50 04             	mov    %edx,0x4(%eax)
  802552:	eb 0b                	jmp    80255f <alloc_block_NF+0x7f>
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 04             	mov    0x4(%eax),%eax
  80255a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	85 c0                	test   %eax,%eax
  802567:	74 0f                	je     802578 <alloc_block_NF+0x98>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802572:	8b 12                	mov    (%edx),%edx
  802574:	89 10                	mov    %edx,(%eax)
  802576:	eb 0a                	jmp    802582 <alloc_block_NF+0xa2>
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 00                	mov    (%eax),%eax
  80257d:	a3 38 41 80 00       	mov    %eax,0x804138
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802595:	a1 44 41 80 00       	mov    0x804144,%eax
  80259a:	48                   	dec    %eax
  80259b:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 08             	mov    0x8(%eax),%eax
  8025a6:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	e9 f8 04 00 00       	jmp    802aab <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bc:	0f 86 d4 00 00 00    	jbe    802696 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c2:	a1 48 41 80 00       	mov    0x804148,%eax
  8025c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 50 08             	mov    0x8(%eax),%edx
  8025d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d3:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025dc:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e3:	75 17                	jne    8025fc <alloc_block_NF+0x11c>
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	68 44 3d 80 00       	push   $0x803d44
  8025ed:	68 e9 00 00 00       	push   $0xe9
  8025f2:	68 9b 3c 80 00       	push   $0x803c9b
  8025f7:	e8 fd 0b 00 00       	call   8031f9 <_panic>
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	74 10                	je     802615 <alloc_block_NF+0x135>
  802605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80260d:	8b 52 04             	mov    0x4(%edx),%edx
  802610:	89 50 04             	mov    %edx,0x4(%eax)
  802613:	eb 0b                	jmp    802620 <alloc_block_NF+0x140>
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	74 0f                	je     802639 <alloc_block_NF+0x159>
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802633:	8b 12                	mov    (%edx),%edx
  802635:	89 10                	mov    %edx,(%eax)
  802637:	eb 0a                	jmp    802643 <alloc_block_NF+0x163>
  802639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	a3 48 41 80 00       	mov    %eax,0x804148
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802656:	a1 54 41 80 00       	mov    0x804154,%eax
  80265b:	48                   	dec    %eax
  80265c:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	8b 40 08             	mov    0x8(%eax),%eax
  802667:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 50 08             	mov    0x8(%eax),%edx
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	01 c2                	add    %eax,%edx
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 0c             	mov    0xc(%eax),%eax
  802683:	2b 45 08             	sub    0x8(%ebp),%eax
  802686:	89 c2                	mov    %eax,%edx
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	e9 15 04 00 00       	jmp    802aab <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802696:	a1 40 41 80 00       	mov    0x804140,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	74 07                	je     8026ab <alloc_block_NF+0x1cb>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <alloc_block_NF+0x1d0>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 40 41 80 00       	mov    %eax,0x804140
  8026b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	0f 85 3e fe ff ff    	jne    802500 <alloc_block_NF+0x20>
  8026c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c6:	0f 85 34 fe ff ff    	jne    802500 <alloc_block_NF+0x20>
  8026cc:	e9 d5 03 00 00       	jmp    802aa6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8026d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	e9 b1 01 00 00       	jmp    80288f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 50 08             	mov    0x8(%eax),%edx
  8026e4:	a1 28 40 80 00       	mov    0x804028,%eax
  8026e9:	39 c2                	cmp    %eax,%edx
  8026eb:	0f 82 96 01 00 00    	jb     802887 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fa:	0f 82 87 01 00 00    	jb     802887 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	3b 45 08             	cmp    0x8(%ebp),%eax
  802709:	0f 85 95 00 00 00    	jne    8027a4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	75 17                	jne    80272c <alloc_block_NF+0x24c>
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	68 44 3d 80 00       	push   $0x803d44
  80271d:	68 fc 00 00 00       	push   $0xfc
  802722:	68 9b 3c 80 00       	push   $0x803c9b
  802727:	e8 cd 0a 00 00       	call   8031f9 <_panic>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	74 10                	je     802745 <alloc_block_NF+0x265>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273d:	8b 52 04             	mov    0x4(%edx),%edx
  802740:	89 50 04             	mov    %edx,0x4(%eax)
  802743:	eb 0b                	jmp    802750 <alloc_block_NF+0x270>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0f                	je     802769 <alloc_block_NF+0x289>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802763:	8b 12                	mov    (%edx),%edx
  802765:	89 10                	mov    %edx,(%eax)
  802767:	eb 0a                	jmp    802773 <alloc_block_NF+0x293>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	a3 38 41 80 00       	mov    %eax,0x804138
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802786:	a1 44 41 80 00       	mov    0x804144,%eax
  80278b:	48                   	dec    %eax
  80278c:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 08             	mov    0x8(%eax),%eax
  802797:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	e9 07 03 00 00       	jmp    802aab <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ad:	0f 86 d4 00 00 00    	jbe    802887 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8027b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 50 08             	mov    0x8(%eax),%edx
  8027c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8027c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027d4:	75 17                	jne    8027ed <alloc_block_NF+0x30d>
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	68 44 3d 80 00       	push   $0x803d44
  8027de:	68 04 01 00 00       	push   $0x104
  8027e3:	68 9b 3c 80 00       	push   $0x803c9b
  8027e8:	e8 0c 0a 00 00       	call   8031f9 <_panic>
  8027ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	74 10                	je     802806 <alloc_block_NF+0x326>
  8027f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fe:	8b 52 04             	mov    0x4(%edx),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	eb 0b                	jmp    802811 <alloc_block_NF+0x331>
  802806:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0f                	je     80282a <alloc_block_NF+0x34a>
  80281b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802824:	8b 12                	mov    (%edx),%edx
  802826:	89 10                	mov    %edx,(%eax)
  802828:	eb 0a                	jmp    802834 <alloc_block_NF+0x354>
  80282a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	a3 48 41 80 00       	mov    %eax,0x804148
  802834:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802840:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802847:	a1 54 41 80 00       	mov    0x804154,%eax
  80284c:	48                   	dec    %eax
  80284d:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802855:	8b 40 08             	mov    0x8(%eax),%eax
  802858:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 50 08             	mov    0x8(%eax),%edx
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	01 c2                	add    %eax,%edx
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	2b 45 08             	sub    0x8(%ebp),%eax
  802877:	89 c2                	mov    %eax,%edx
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80287f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802882:	e9 24 02 00 00       	jmp    802aab <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802887:	a1 40 41 80 00       	mov    0x804140,%eax
  80288c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802893:	74 07                	je     80289c <alloc_block_NF+0x3bc>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	eb 05                	jmp    8028a1 <alloc_block_NF+0x3c1>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	a3 40 41 80 00       	mov    %eax,0x804140
  8028a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	0f 85 2b fe ff ff    	jne    8026de <alloc_block_NF+0x1fe>
  8028b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b7:	0f 85 21 fe ff ff    	jne    8026de <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c5:	e9 ae 01 00 00       	jmp    802a78 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 50 08             	mov    0x8(%eax),%edx
  8028d0:	a1 28 40 80 00       	mov    0x804028,%eax
  8028d5:	39 c2                	cmp    %eax,%edx
  8028d7:	0f 83 93 01 00 00    	jae    802a70 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e6:	0f 82 84 01 00 00    	jb     802a70 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f5:	0f 85 95 00 00 00    	jne    802990 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ff:	75 17                	jne    802918 <alloc_block_NF+0x438>
  802901:	83 ec 04             	sub    $0x4,%esp
  802904:	68 44 3d 80 00       	push   $0x803d44
  802909:	68 14 01 00 00       	push   $0x114
  80290e:	68 9b 3c 80 00       	push   $0x803c9b
  802913:	e8 e1 08 00 00       	call   8031f9 <_panic>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 10                	je     802931 <alloc_block_NF+0x451>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802929:	8b 52 04             	mov    0x4(%edx),%edx
  80292c:	89 50 04             	mov    %edx,0x4(%eax)
  80292f:	eb 0b                	jmp    80293c <alloc_block_NF+0x45c>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 0f                	je     802955 <alloc_block_NF+0x475>
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294f:	8b 12                	mov    (%edx),%edx
  802951:	89 10                	mov    %edx,(%eax)
  802953:	eb 0a                	jmp    80295f <alloc_block_NF+0x47f>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	a3 38 41 80 00       	mov    %eax,0x804138
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802972:	a1 44 41 80 00       	mov    0x804144,%eax
  802977:	48                   	dec    %eax
  802978:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 08             	mov    0x8(%eax),%eax
  802983:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	e9 1b 01 00 00       	jmp    802aab <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 40 0c             	mov    0xc(%eax),%eax
  802996:	3b 45 08             	cmp    0x8(%ebp),%eax
  802999:	0f 86 d1 00 00 00    	jbe    802a70 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80299f:	a1 48 41 80 00       	mov    0x804148,%eax
  8029a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 50 08             	mov    0x8(%eax),%edx
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c0:	75 17                	jne    8029d9 <alloc_block_NF+0x4f9>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 44 3d 80 00       	push   $0x803d44
  8029ca:	68 1c 01 00 00       	push   $0x11c
  8029cf:	68 9b 3c 80 00       	push   $0x803c9b
  8029d4:	e8 20 08 00 00       	call   8031f9 <_panic>
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 10                	je     8029f2 <alloc_block_NF+0x512>
  8029e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ea:	8b 52 04             	mov    0x4(%edx),%edx
  8029ed:	89 50 04             	mov    %edx,0x4(%eax)
  8029f0:	eb 0b                	jmp    8029fd <alloc_block_NF+0x51d>
  8029f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0f                	je     802a16 <alloc_block_NF+0x536>
  802a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a10:	8b 12                	mov    (%edx),%edx
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	eb 0a                	jmp    802a20 <alloc_block_NF+0x540>
  802a16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	a3 48 41 80 00       	mov    %eax,0x804148
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a33:	a1 54 41 80 00       	mov    0x804154,%eax
  802a38:	48                   	dec    %eax
  802a39:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a41:	8b 40 08             	mov    0x8(%eax),%eax
  802a44:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 50 08             	mov    0x8(%eax),%edx
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	01 c2                	add    %eax,%edx
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a60:	2b 45 08             	sub    0x8(%ebp),%eax
  802a63:	89 c2                	mov    %eax,%edx
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6e:	eb 3b                	jmp    802aab <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a70:	a1 40 41 80 00       	mov    0x804140,%eax
  802a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7c:	74 07                	je     802a85 <alloc_block_NF+0x5a5>
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 00                	mov    (%eax),%eax
  802a83:	eb 05                	jmp    802a8a <alloc_block_NF+0x5aa>
  802a85:	b8 00 00 00 00       	mov    $0x0,%eax
  802a8a:	a3 40 41 80 00       	mov    %eax,0x804140
  802a8f:	a1 40 41 80 00       	mov    0x804140,%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	0f 85 2e fe ff ff    	jne    8028ca <alloc_block_NF+0x3ea>
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	0f 85 24 fe ff ff    	jne    8028ca <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aab:	c9                   	leave  
  802aac:	c3                   	ret    

00802aad <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802aad:	55                   	push   %ebp
  802aae:	89 e5                	mov    %esp,%ebp
  802ab0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ab3:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802abb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ac0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ac3:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 14                	je     802ae0 <insert_sorted_with_merge_freeList+0x33>
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	8b 50 08             	mov    0x8(%eax),%edx
  802ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad5:	8b 40 08             	mov    0x8(%eax),%eax
  802ad8:	39 c2                	cmp    %eax,%edx
  802ada:	0f 87 9b 01 00 00    	ja     802c7b <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ae0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae4:	75 17                	jne    802afd <insert_sorted_with_merge_freeList+0x50>
  802ae6:	83 ec 04             	sub    $0x4,%esp
  802ae9:	68 78 3c 80 00       	push   $0x803c78
  802aee:	68 38 01 00 00       	push   $0x138
  802af3:	68 9b 3c 80 00       	push   $0x803c9b
  802af8:	e8 fc 06 00 00       	call   8031f9 <_panic>
  802afd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	89 10                	mov    %edx,(%eax)
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	74 0d                	je     802b1e <insert_sorted_with_merge_freeList+0x71>
  802b11:	a1 38 41 80 00       	mov    0x804138,%eax
  802b16:	8b 55 08             	mov    0x8(%ebp),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	eb 08                	jmp    802b26 <insert_sorted_with_merge_freeList+0x79>
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	a3 38 41 80 00       	mov    %eax,0x804138
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b38:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3d:	40                   	inc    %eax
  802b3e:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802b43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b47:	0f 84 a8 06 00 00    	je     8031f5 <insert_sorted_with_merge_freeList+0x748>
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 50 08             	mov    0x8(%eax),%edx
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	8b 40 0c             	mov    0xc(%eax),%eax
  802b59:	01 c2                	add    %eax,%edx
  802b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5e:	8b 40 08             	mov    0x8(%eax),%eax
  802b61:	39 c2                	cmp    %eax,%edx
  802b63:	0f 85 8c 06 00 00    	jne    8031f5 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	8b 40 0c             	mov    0xc(%eax),%eax
  802b75:	01 c2                	add    %eax,%edx
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802b7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b81:	75 17                	jne    802b9a <insert_sorted_with_merge_freeList+0xed>
  802b83:	83 ec 04             	sub    $0x4,%esp
  802b86:	68 44 3d 80 00       	push   $0x803d44
  802b8b:	68 3c 01 00 00       	push   $0x13c
  802b90:	68 9b 3c 80 00       	push   $0x803c9b
  802b95:	e8 5f 06 00 00       	call   8031f9 <_panic>
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	74 10                	je     802bb3 <insert_sorted_with_merge_freeList+0x106>
  802ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bab:	8b 52 04             	mov    0x4(%edx),%edx
  802bae:	89 50 04             	mov    %edx,0x4(%eax)
  802bb1:	eb 0b                	jmp    802bbe <insert_sorted_with_merge_freeList+0x111>
  802bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0f                	je     802bd7 <insert_sorted_with_merge_freeList+0x12a>
  802bc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcb:	8b 40 04             	mov    0x4(%eax),%eax
  802bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bd1:	8b 12                	mov    (%edx),%edx
  802bd3:	89 10                	mov    %edx,(%eax)
  802bd5:	eb 0a                	jmp    802be1 <insert_sorted_with_merge_freeList+0x134>
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	8b 00                	mov    (%eax),%eax
  802bdc:	a3 38 41 80 00       	mov    %eax,0x804138
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf4:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf9:	48                   	dec    %eax
  802bfa:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c17:	75 17                	jne    802c30 <insert_sorted_with_merge_freeList+0x183>
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	68 78 3c 80 00       	push   $0x803c78
  802c21:	68 3f 01 00 00       	push   $0x13f
  802c26:	68 9b 3c 80 00       	push   $0x803c9b
  802c2b:	e8 c9 05 00 00       	call   8031f9 <_panic>
  802c30:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	89 10                	mov    %edx,(%eax)
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	85 c0                	test   %eax,%eax
  802c42:	74 0d                	je     802c51 <insert_sorted_with_merge_freeList+0x1a4>
  802c44:	a1 48 41 80 00       	mov    0x804148,%eax
  802c49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4c:	89 50 04             	mov    %edx,0x4(%eax)
  802c4f:	eb 08                	jmp    802c59 <insert_sorted_with_merge_freeList+0x1ac>
  802c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c54:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	a3 48 41 80 00       	mov    %eax,0x804148
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c70:	40                   	inc    %eax
  802c71:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c76:	e9 7a 05 00 00       	jmp    8031f5 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 50 08             	mov    0x8(%eax),%edx
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	8b 40 08             	mov    0x8(%eax),%eax
  802c87:	39 c2                	cmp    %eax,%edx
  802c89:	0f 82 14 01 00 00    	jb     802da3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c92:	8b 50 08             	mov    0x8(%eax),%edx
  802c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c98:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9b:	01 c2                	add    %eax,%edx
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 40 08             	mov    0x8(%eax),%eax
  802ca3:	39 c2                	cmp    %eax,%edx
  802ca5:	0f 85 90 00 00 00    	jne    802d3b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cae:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb7:	01 c2                	add    %eax,%edx
  802cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbc:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd7:	75 17                	jne    802cf0 <insert_sorted_with_merge_freeList+0x243>
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	68 78 3c 80 00       	push   $0x803c78
  802ce1:	68 49 01 00 00       	push   $0x149
  802ce6:	68 9b 3c 80 00       	push   $0x803c9b
  802ceb:	e8 09 05 00 00       	call   8031f9 <_panic>
  802cf0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	89 10                	mov    %edx,(%eax)
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 0d                	je     802d11 <insert_sorted_with_merge_freeList+0x264>
  802d04:	a1 48 41 80 00       	mov    0x804148,%eax
  802d09:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 08                	jmp    802d19 <insert_sorted_with_merge_freeList+0x26c>
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d30:	40                   	inc    %eax
  802d31:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d36:	e9 bb 04 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802d3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3f:	75 17                	jne    802d58 <insert_sorted_with_merge_freeList+0x2ab>
  802d41:	83 ec 04             	sub    $0x4,%esp
  802d44:	68 ec 3c 80 00       	push   $0x803cec
  802d49:	68 4c 01 00 00       	push   $0x14c
  802d4e:	68 9b 3c 80 00       	push   $0x803c9b
  802d53:	e8 a1 04 00 00       	call   8031f9 <_panic>
  802d58:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	89 50 04             	mov    %edx,0x4(%eax)
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 40 04             	mov    0x4(%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 0c                	je     802d7a <insert_sorted_with_merge_freeList+0x2cd>
  802d6e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d73:	8b 55 08             	mov    0x8(%ebp),%edx
  802d76:	89 10                	mov    %edx,(%eax)
  802d78:	eb 08                	jmp    802d82 <insert_sorted_with_merge_freeList+0x2d5>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	a3 38 41 80 00       	mov    %eax,0x804138
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d93:	a1 44 41 80 00       	mov    0x804144,%eax
  802d98:	40                   	inc    %eax
  802d99:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802d9e:	e9 53 04 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802da3:	a1 38 41 80 00       	mov    0x804138,%eax
  802da8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dab:	e9 15 04 00 00       	jmp    8031c5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 50 08             	mov    0x8(%eax),%edx
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 08             	mov    0x8(%eax),%eax
  802dc4:	39 c2                	cmp    %eax,%edx
  802dc6:	0f 86 f1 03 00 00    	jbe    8031bd <insert_sorted_with_merge_freeList+0x710>
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	8b 50 08             	mov    0x8(%eax),%edx
  802dd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd5:	8b 40 08             	mov    0x8(%eax),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	0f 83 dd 03 00 00    	jae    8031bd <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 50 08             	mov    0x8(%eax),%edx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dec:	01 c2                	add    %eax,%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 40 08             	mov    0x8(%eax),%eax
  802df4:	39 c2                	cmp    %eax,%edx
  802df6:	0f 85 b9 01 00 00    	jne    802fb5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 50 08             	mov    0x8(%eax),%edx
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	01 c2                	add    %eax,%edx
  802e0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0d:	8b 40 08             	mov    0x8(%eax),%eax
  802e10:	39 c2                	cmp    %eax,%edx
  802e12:	0f 85 0d 01 00 00    	jne    802f25 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e21:	8b 40 0c             	mov    0xc(%eax),%eax
  802e24:	01 c2                	add    %eax,%edx
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802e2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e30:	75 17                	jne    802e49 <insert_sorted_with_merge_freeList+0x39c>
  802e32:	83 ec 04             	sub    $0x4,%esp
  802e35:	68 44 3d 80 00       	push   $0x803d44
  802e3a:	68 5c 01 00 00       	push   $0x15c
  802e3f:	68 9b 3c 80 00       	push   $0x803c9b
  802e44:	e8 b0 03 00 00       	call   8031f9 <_panic>
  802e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	74 10                	je     802e62 <insert_sorted_with_merge_freeList+0x3b5>
  802e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e5a:	8b 52 04             	mov    0x4(%edx),%edx
  802e5d:	89 50 04             	mov    %edx,0x4(%eax)
  802e60:	eb 0b                	jmp    802e6d <insert_sorted_with_merge_freeList+0x3c0>
  802e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e70:	8b 40 04             	mov    0x4(%eax),%eax
  802e73:	85 c0                	test   %eax,%eax
  802e75:	74 0f                	je     802e86 <insert_sorted_with_merge_freeList+0x3d9>
  802e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7a:	8b 40 04             	mov    0x4(%eax),%eax
  802e7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e80:	8b 12                	mov    (%edx),%edx
  802e82:	89 10                	mov    %edx,(%eax)
  802e84:	eb 0a                	jmp    802e90 <insert_sorted_with_merge_freeList+0x3e3>
  802e86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e89:	8b 00                	mov    (%eax),%eax
  802e8b:	a3 38 41 80 00       	mov    %eax,0x804138
  802e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ea8:	48                   	dec    %eax
  802ea9:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ec2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec6:	75 17                	jne    802edf <insert_sorted_with_merge_freeList+0x432>
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 78 3c 80 00       	push   $0x803c78
  802ed0:	68 5f 01 00 00       	push   $0x15f
  802ed5:	68 9b 3c 80 00       	push   $0x803c9b
  802eda:	e8 1a 03 00 00       	call   8031f9 <_panic>
  802edf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 0d                	je     802f00 <insert_sorted_with_merge_freeList+0x453>
  802ef3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	eb 08                	jmp    802f08 <insert_sorted_with_merge_freeList+0x45b>
  802f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f03:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f1f:	40                   	inc    %eax
  802f20:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f31:	01 c2                	add    %eax,%edx
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f51:	75 17                	jne    802f6a <insert_sorted_with_merge_freeList+0x4bd>
  802f53:	83 ec 04             	sub    $0x4,%esp
  802f56:	68 78 3c 80 00       	push   $0x803c78
  802f5b:	68 64 01 00 00       	push   $0x164
  802f60:	68 9b 3c 80 00       	push   $0x803c9b
  802f65:	e8 8f 02 00 00       	call   8031f9 <_panic>
  802f6a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	89 10                	mov    %edx,(%eax)
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	74 0d                	je     802f8b <insert_sorted_with_merge_freeList+0x4de>
  802f7e:	a1 48 41 80 00       	mov    0x804148,%eax
  802f83:	8b 55 08             	mov    0x8(%ebp),%edx
  802f86:	89 50 04             	mov    %edx,0x4(%eax)
  802f89:	eb 08                	jmp    802f93 <insert_sorted_with_merge_freeList+0x4e6>
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	a3 48 41 80 00       	mov    %eax,0x804148
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 54 41 80 00       	mov    0x804154,%eax
  802faa:	40                   	inc    %eax
  802fab:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  802fb0:	e9 41 02 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 50 08             	mov    0x8(%eax),%edx
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc1:	01 c2                	add    %eax,%edx
  802fc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc6:	8b 40 08             	mov    0x8(%eax),%eax
  802fc9:	39 c2                	cmp    %eax,%edx
  802fcb:	0f 85 7c 01 00 00    	jne    80314d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  802fd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd5:	74 06                	je     802fdd <insert_sorted_with_merge_freeList+0x530>
  802fd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdb:	75 17                	jne    802ff4 <insert_sorted_with_merge_freeList+0x547>
  802fdd:	83 ec 04             	sub    $0x4,%esp
  802fe0:	68 b4 3c 80 00       	push   $0x803cb4
  802fe5:	68 69 01 00 00       	push   $0x169
  802fea:	68 9b 3c 80 00       	push   $0x803c9b
  802fef:	e8 05 02 00 00       	call   8031f9 <_panic>
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	8b 50 04             	mov    0x4(%eax),%edx
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	89 50 04             	mov    %edx,0x4(%eax)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803006:	89 10                	mov    %edx,(%eax)
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	85 c0                	test   %eax,%eax
  803010:	74 0d                	je     80301f <insert_sorted_with_merge_freeList+0x572>
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	8b 40 04             	mov    0x4(%eax),%eax
  803018:	8b 55 08             	mov    0x8(%ebp),%edx
  80301b:	89 10                	mov    %edx,(%eax)
  80301d:	eb 08                	jmp    803027 <insert_sorted_with_merge_freeList+0x57a>
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	a3 38 41 80 00       	mov    %eax,0x804138
  803027:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	a1 44 41 80 00       	mov    0x804144,%eax
  803035:	40                   	inc    %eax
  803036:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 50 0c             	mov    0xc(%eax),%edx
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	8b 40 0c             	mov    0xc(%eax),%eax
  803047:	01 c2                	add    %eax,%edx
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80304f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803053:	75 17                	jne    80306c <insert_sorted_with_merge_freeList+0x5bf>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 44 3d 80 00       	push   $0x803d44
  80305d:	68 6b 01 00 00       	push   $0x16b
  803062:	68 9b 3c 80 00       	push   $0x803c9b
  803067:	e8 8d 01 00 00       	call   8031f9 <_panic>
  80306c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 10                	je     803085 <insert_sorted_with_merge_freeList+0x5d8>
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80307d:	8b 52 04             	mov    0x4(%edx),%edx
  803080:	89 50 04             	mov    %edx,0x4(%eax)
  803083:	eb 0b                	jmp    803090 <insert_sorted_with_merge_freeList+0x5e3>
  803085:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803088:	8b 40 04             	mov    0x4(%eax),%eax
  80308b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803090:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	85 c0                	test   %eax,%eax
  803098:	74 0f                	je     8030a9 <insert_sorted_with_merge_freeList+0x5fc>
  80309a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a3:	8b 12                	mov    (%edx),%edx
  8030a5:	89 10                	mov    %edx,(%eax)
  8030a7:	eb 0a                	jmp    8030b3 <insert_sorted_with_merge_freeList+0x606>
  8030a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	a3 38 41 80 00       	mov    %eax,0x804138
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8030cb:	48                   	dec    %eax
  8030cc:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e9:	75 17                	jne    803102 <insert_sorted_with_merge_freeList+0x655>
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	68 78 3c 80 00       	push   $0x803c78
  8030f3:	68 6e 01 00 00       	push   $0x16e
  8030f8:	68 9b 3c 80 00       	push   $0x803c9b
  8030fd:	e8 f7 00 00 00       	call   8031f9 <_panic>
  803102:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	89 10                	mov    %edx,(%eax)
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	8b 00                	mov    (%eax),%eax
  803112:	85 c0                	test   %eax,%eax
  803114:	74 0d                	je     803123 <insert_sorted_with_merge_freeList+0x676>
  803116:	a1 48 41 80 00       	mov    0x804148,%eax
  80311b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80311e:	89 50 04             	mov    %edx,0x4(%eax)
  803121:	eb 08                	jmp    80312b <insert_sorted_with_merge_freeList+0x67e>
  803123:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803126:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	a3 48 41 80 00       	mov    %eax,0x804148
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313d:	a1 54 41 80 00       	mov    0x804154,%eax
  803142:	40                   	inc    %eax
  803143:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803148:	e9 a9 00 00 00       	jmp    8031f6 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80314d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803151:	74 06                	je     803159 <insert_sorted_with_merge_freeList+0x6ac>
  803153:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803157:	75 17                	jne    803170 <insert_sorted_with_merge_freeList+0x6c3>
  803159:	83 ec 04             	sub    $0x4,%esp
  80315c:	68 10 3d 80 00       	push   $0x803d10
  803161:	68 73 01 00 00       	push   $0x173
  803166:	68 9b 3c 80 00       	push   $0x803c9b
  80316b:	e8 89 00 00 00       	call   8031f9 <_panic>
  803170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803173:	8b 10                	mov    (%eax),%edx
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	89 10                	mov    %edx,(%eax)
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 00                	mov    (%eax),%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 0b                	je     80318e <insert_sorted_with_merge_freeList+0x6e1>
  803183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803186:	8b 00                	mov    (%eax),%eax
  803188:	8b 55 08             	mov    0x8(%ebp),%edx
  80318b:	89 50 04             	mov    %edx,0x4(%eax)
  80318e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803191:	8b 55 08             	mov    0x8(%ebp),%edx
  803194:	89 10                	mov    %edx,(%eax)
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319c:	89 50 04             	mov    %edx,0x4(%eax)
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	75 08                	jne    8031b0 <insert_sorted_with_merge_freeList+0x703>
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8031b5:	40                   	inc    %eax
  8031b6:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8031bb:	eb 39                	jmp    8031f6 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8031bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8031c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c9:	74 07                	je     8031d2 <insert_sorted_with_merge_freeList+0x725>
  8031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ce:	8b 00                	mov    (%eax),%eax
  8031d0:	eb 05                	jmp    8031d7 <insert_sorted_with_merge_freeList+0x72a>
  8031d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8031d7:	a3 40 41 80 00       	mov    %eax,0x804140
  8031dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	0f 85 c7 fb ff ff    	jne    802db0 <insert_sorted_with_merge_freeList+0x303>
  8031e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031ed:	0f 85 bd fb ff ff    	jne    802db0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031f3:	eb 01                	jmp    8031f6 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8031f5:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8031f6:	90                   	nop
  8031f7:	c9                   	leave  
  8031f8:	c3                   	ret    

008031f9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8031ff:	8d 45 10             	lea    0x10(%ebp),%eax
  803202:	83 c0 04             	add    $0x4,%eax
  803205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803208:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 16                	je     803227 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803211:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803216:	83 ec 08             	sub    $0x8,%esp
  803219:	50                   	push   %eax
  80321a:	68 64 3d 80 00       	push   $0x803d64
  80321f:	e8 24 d1 ff ff       	call   800348 <cprintf>
  803224:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803227:	a1 00 40 80 00       	mov    0x804000,%eax
  80322c:	ff 75 0c             	pushl  0xc(%ebp)
  80322f:	ff 75 08             	pushl  0x8(%ebp)
  803232:	50                   	push   %eax
  803233:	68 69 3d 80 00       	push   $0x803d69
  803238:	e8 0b d1 ff ff       	call   800348 <cprintf>
  80323d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803240:	8b 45 10             	mov    0x10(%ebp),%eax
  803243:	83 ec 08             	sub    $0x8,%esp
  803246:	ff 75 f4             	pushl  -0xc(%ebp)
  803249:	50                   	push   %eax
  80324a:	e8 8e d0 ff ff       	call   8002dd <vcprintf>
  80324f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803252:	83 ec 08             	sub    $0x8,%esp
  803255:	6a 00                	push   $0x0
  803257:	68 85 3d 80 00       	push   $0x803d85
  80325c:	e8 7c d0 ff ff       	call   8002dd <vcprintf>
  803261:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803264:	e8 fd cf ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  803269:	eb fe                	jmp    803269 <_panic+0x70>

0080326b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80326b:	55                   	push   %ebp
  80326c:	89 e5                	mov    %esp,%ebp
  80326e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803271:	a1 20 40 80 00       	mov    0x804020,%eax
  803276:	8b 50 74             	mov    0x74(%eax),%edx
  803279:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327c:	39 c2                	cmp    %eax,%edx
  80327e:	74 14                	je     803294 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803280:	83 ec 04             	sub    $0x4,%esp
  803283:	68 88 3d 80 00       	push   $0x803d88
  803288:	6a 26                	push   $0x26
  80328a:	68 d4 3d 80 00       	push   $0x803dd4
  80328f:	e8 65 ff ff ff       	call   8031f9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803294:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80329b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032a2:	e9 c2 00 00 00       	jmp    803369 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	01 d0                	add    %edx,%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	75 08                	jne    8032c4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8032bc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8032bf:	e9 a2 00 00 00       	jmp    803366 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8032c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032cb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8032d2:	eb 69                	jmp    80333d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8032d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8032d9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e2:	89 d0                	mov    %edx,%eax
  8032e4:	01 c0                	add    %eax,%eax
  8032e6:	01 d0                	add    %edx,%eax
  8032e8:	c1 e0 03             	shl    $0x3,%eax
  8032eb:	01 c8                	add    %ecx,%eax
  8032ed:	8a 40 04             	mov    0x4(%eax),%al
  8032f0:	84 c0                	test   %al,%al
  8032f2:	75 46                	jne    80333a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8032f9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803302:	89 d0                	mov    %edx,%eax
  803304:	01 c0                	add    %eax,%eax
  803306:	01 d0                	add    %edx,%eax
  803308:	c1 e0 03             	shl    $0x3,%eax
  80330b:	01 c8                	add    %ecx,%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803312:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803315:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80331a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80331c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	01 c8                	add    %ecx,%eax
  80332b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80332d:	39 c2                	cmp    %eax,%edx
  80332f:	75 09                	jne    80333a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803331:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803338:	eb 12                	jmp    80334c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80333a:	ff 45 e8             	incl   -0x18(%ebp)
  80333d:	a1 20 40 80 00       	mov    0x804020,%eax
  803342:	8b 50 74             	mov    0x74(%eax),%edx
  803345:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803348:	39 c2                	cmp    %eax,%edx
  80334a:	77 88                	ja     8032d4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80334c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803350:	75 14                	jne    803366 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	68 e0 3d 80 00       	push   $0x803de0
  80335a:	6a 3a                	push   $0x3a
  80335c:	68 d4 3d 80 00       	push   $0x803dd4
  803361:	e8 93 fe ff ff       	call   8031f9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803366:	ff 45 f0             	incl   -0x10(%ebp)
  803369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80336c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80336f:	0f 8c 32 ff ff ff    	jl     8032a7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803375:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80337c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803383:	eb 26                	jmp    8033ab <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803385:	a1 20 40 80 00       	mov    0x804020,%eax
  80338a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803390:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803393:	89 d0                	mov    %edx,%eax
  803395:	01 c0                	add    %eax,%eax
  803397:	01 d0                	add    %edx,%eax
  803399:	c1 e0 03             	shl    $0x3,%eax
  80339c:	01 c8                	add    %ecx,%eax
  80339e:	8a 40 04             	mov    0x4(%eax),%al
  8033a1:	3c 01                	cmp    $0x1,%al
  8033a3:	75 03                	jne    8033a8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033a5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033a8:	ff 45 e0             	incl   -0x20(%ebp)
  8033ab:	a1 20 40 80 00       	mov    0x804020,%eax
  8033b0:	8b 50 74             	mov    0x74(%eax),%edx
  8033b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033b6:	39 c2                	cmp    %eax,%edx
  8033b8:	77 cb                	ja     803385 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033c0:	74 14                	je     8033d6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8033c2:	83 ec 04             	sub    $0x4,%esp
  8033c5:	68 34 3e 80 00       	push   $0x803e34
  8033ca:	6a 44                	push   $0x44
  8033cc:	68 d4 3d 80 00       	push   $0x803dd4
  8033d1:	e8 23 fe ff ff       	call   8031f9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8033d6:	90                   	nop
  8033d7:	c9                   	leave  
  8033d8:	c3                   	ret    
  8033d9:	66 90                	xchg   %ax,%ax
  8033db:	90                   	nop

008033dc <__udivdi3>:
  8033dc:	55                   	push   %ebp
  8033dd:	57                   	push   %edi
  8033de:	56                   	push   %esi
  8033df:	53                   	push   %ebx
  8033e0:	83 ec 1c             	sub    $0x1c,%esp
  8033e3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033e7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033f3:	89 ca                	mov    %ecx,%edx
  8033f5:	89 f8                	mov    %edi,%eax
  8033f7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033fb:	85 f6                	test   %esi,%esi
  8033fd:	75 2d                	jne    80342c <__udivdi3+0x50>
  8033ff:	39 cf                	cmp    %ecx,%edi
  803401:	77 65                	ja     803468 <__udivdi3+0x8c>
  803403:	89 fd                	mov    %edi,%ebp
  803405:	85 ff                	test   %edi,%edi
  803407:	75 0b                	jne    803414 <__udivdi3+0x38>
  803409:	b8 01 00 00 00       	mov    $0x1,%eax
  80340e:	31 d2                	xor    %edx,%edx
  803410:	f7 f7                	div    %edi
  803412:	89 c5                	mov    %eax,%ebp
  803414:	31 d2                	xor    %edx,%edx
  803416:	89 c8                	mov    %ecx,%eax
  803418:	f7 f5                	div    %ebp
  80341a:	89 c1                	mov    %eax,%ecx
  80341c:	89 d8                	mov    %ebx,%eax
  80341e:	f7 f5                	div    %ebp
  803420:	89 cf                	mov    %ecx,%edi
  803422:	89 fa                	mov    %edi,%edx
  803424:	83 c4 1c             	add    $0x1c,%esp
  803427:	5b                   	pop    %ebx
  803428:	5e                   	pop    %esi
  803429:	5f                   	pop    %edi
  80342a:	5d                   	pop    %ebp
  80342b:	c3                   	ret    
  80342c:	39 ce                	cmp    %ecx,%esi
  80342e:	77 28                	ja     803458 <__udivdi3+0x7c>
  803430:	0f bd fe             	bsr    %esi,%edi
  803433:	83 f7 1f             	xor    $0x1f,%edi
  803436:	75 40                	jne    803478 <__udivdi3+0x9c>
  803438:	39 ce                	cmp    %ecx,%esi
  80343a:	72 0a                	jb     803446 <__udivdi3+0x6a>
  80343c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803440:	0f 87 9e 00 00 00    	ja     8034e4 <__udivdi3+0x108>
  803446:	b8 01 00 00 00       	mov    $0x1,%eax
  80344b:	89 fa                	mov    %edi,%edx
  80344d:	83 c4 1c             	add    $0x1c,%esp
  803450:	5b                   	pop    %ebx
  803451:	5e                   	pop    %esi
  803452:	5f                   	pop    %edi
  803453:	5d                   	pop    %ebp
  803454:	c3                   	ret    
  803455:	8d 76 00             	lea    0x0(%esi),%esi
  803458:	31 ff                	xor    %edi,%edi
  80345a:	31 c0                	xor    %eax,%eax
  80345c:	89 fa                	mov    %edi,%edx
  80345e:	83 c4 1c             	add    $0x1c,%esp
  803461:	5b                   	pop    %ebx
  803462:	5e                   	pop    %esi
  803463:	5f                   	pop    %edi
  803464:	5d                   	pop    %ebp
  803465:	c3                   	ret    
  803466:	66 90                	xchg   %ax,%ax
  803468:	89 d8                	mov    %ebx,%eax
  80346a:	f7 f7                	div    %edi
  80346c:	31 ff                	xor    %edi,%edi
  80346e:	89 fa                	mov    %edi,%edx
  803470:	83 c4 1c             	add    $0x1c,%esp
  803473:	5b                   	pop    %ebx
  803474:	5e                   	pop    %esi
  803475:	5f                   	pop    %edi
  803476:	5d                   	pop    %ebp
  803477:	c3                   	ret    
  803478:	bd 20 00 00 00       	mov    $0x20,%ebp
  80347d:	89 eb                	mov    %ebp,%ebx
  80347f:	29 fb                	sub    %edi,%ebx
  803481:	89 f9                	mov    %edi,%ecx
  803483:	d3 e6                	shl    %cl,%esi
  803485:	89 c5                	mov    %eax,%ebp
  803487:	88 d9                	mov    %bl,%cl
  803489:	d3 ed                	shr    %cl,%ebp
  80348b:	89 e9                	mov    %ebp,%ecx
  80348d:	09 f1                	or     %esi,%ecx
  80348f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803493:	89 f9                	mov    %edi,%ecx
  803495:	d3 e0                	shl    %cl,%eax
  803497:	89 c5                	mov    %eax,%ebp
  803499:	89 d6                	mov    %edx,%esi
  80349b:	88 d9                	mov    %bl,%cl
  80349d:	d3 ee                	shr    %cl,%esi
  80349f:	89 f9                	mov    %edi,%ecx
  8034a1:	d3 e2                	shl    %cl,%edx
  8034a3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a7:	88 d9                	mov    %bl,%cl
  8034a9:	d3 e8                	shr    %cl,%eax
  8034ab:	09 c2                	or     %eax,%edx
  8034ad:	89 d0                	mov    %edx,%eax
  8034af:	89 f2                	mov    %esi,%edx
  8034b1:	f7 74 24 0c          	divl   0xc(%esp)
  8034b5:	89 d6                	mov    %edx,%esi
  8034b7:	89 c3                	mov    %eax,%ebx
  8034b9:	f7 e5                	mul    %ebp
  8034bb:	39 d6                	cmp    %edx,%esi
  8034bd:	72 19                	jb     8034d8 <__udivdi3+0xfc>
  8034bf:	74 0b                	je     8034cc <__udivdi3+0xf0>
  8034c1:	89 d8                	mov    %ebx,%eax
  8034c3:	31 ff                	xor    %edi,%edi
  8034c5:	e9 58 ff ff ff       	jmp    803422 <__udivdi3+0x46>
  8034ca:	66 90                	xchg   %ax,%ax
  8034cc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034d0:	89 f9                	mov    %edi,%ecx
  8034d2:	d3 e2                	shl    %cl,%edx
  8034d4:	39 c2                	cmp    %eax,%edx
  8034d6:	73 e9                	jae    8034c1 <__udivdi3+0xe5>
  8034d8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034db:	31 ff                	xor    %edi,%edi
  8034dd:	e9 40 ff ff ff       	jmp    803422 <__udivdi3+0x46>
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	31 c0                	xor    %eax,%eax
  8034e6:	e9 37 ff ff ff       	jmp    803422 <__udivdi3+0x46>
  8034eb:	90                   	nop

008034ec <__umoddi3>:
  8034ec:	55                   	push   %ebp
  8034ed:	57                   	push   %edi
  8034ee:	56                   	push   %esi
  8034ef:	53                   	push   %ebx
  8034f0:	83 ec 1c             	sub    $0x1c,%esp
  8034f3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034f7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ff:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803503:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803507:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80350b:	89 f3                	mov    %esi,%ebx
  80350d:	89 fa                	mov    %edi,%edx
  80350f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803513:	89 34 24             	mov    %esi,(%esp)
  803516:	85 c0                	test   %eax,%eax
  803518:	75 1a                	jne    803534 <__umoddi3+0x48>
  80351a:	39 f7                	cmp    %esi,%edi
  80351c:	0f 86 a2 00 00 00    	jbe    8035c4 <__umoddi3+0xd8>
  803522:	89 c8                	mov    %ecx,%eax
  803524:	89 f2                	mov    %esi,%edx
  803526:	f7 f7                	div    %edi
  803528:	89 d0                	mov    %edx,%eax
  80352a:	31 d2                	xor    %edx,%edx
  80352c:	83 c4 1c             	add    $0x1c,%esp
  80352f:	5b                   	pop    %ebx
  803530:	5e                   	pop    %esi
  803531:	5f                   	pop    %edi
  803532:	5d                   	pop    %ebp
  803533:	c3                   	ret    
  803534:	39 f0                	cmp    %esi,%eax
  803536:	0f 87 ac 00 00 00    	ja     8035e8 <__umoddi3+0xfc>
  80353c:	0f bd e8             	bsr    %eax,%ebp
  80353f:	83 f5 1f             	xor    $0x1f,%ebp
  803542:	0f 84 ac 00 00 00    	je     8035f4 <__umoddi3+0x108>
  803548:	bf 20 00 00 00       	mov    $0x20,%edi
  80354d:	29 ef                	sub    %ebp,%edi
  80354f:	89 fe                	mov    %edi,%esi
  803551:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803555:	89 e9                	mov    %ebp,%ecx
  803557:	d3 e0                	shl    %cl,%eax
  803559:	89 d7                	mov    %edx,%edi
  80355b:	89 f1                	mov    %esi,%ecx
  80355d:	d3 ef                	shr    %cl,%edi
  80355f:	09 c7                	or     %eax,%edi
  803561:	89 e9                	mov    %ebp,%ecx
  803563:	d3 e2                	shl    %cl,%edx
  803565:	89 14 24             	mov    %edx,(%esp)
  803568:	89 d8                	mov    %ebx,%eax
  80356a:	d3 e0                	shl    %cl,%eax
  80356c:	89 c2                	mov    %eax,%edx
  80356e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803572:	d3 e0                	shl    %cl,%eax
  803574:	89 44 24 04          	mov    %eax,0x4(%esp)
  803578:	8b 44 24 08          	mov    0x8(%esp),%eax
  80357c:	89 f1                	mov    %esi,%ecx
  80357e:	d3 e8                	shr    %cl,%eax
  803580:	09 d0                	or     %edx,%eax
  803582:	d3 eb                	shr    %cl,%ebx
  803584:	89 da                	mov    %ebx,%edx
  803586:	f7 f7                	div    %edi
  803588:	89 d3                	mov    %edx,%ebx
  80358a:	f7 24 24             	mull   (%esp)
  80358d:	89 c6                	mov    %eax,%esi
  80358f:	89 d1                	mov    %edx,%ecx
  803591:	39 d3                	cmp    %edx,%ebx
  803593:	0f 82 87 00 00 00    	jb     803620 <__umoddi3+0x134>
  803599:	0f 84 91 00 00 00    	je     803630 <__umoddi3+0x144>
  80359f:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035a3:	29 f2                	sub    %esi,%edx
  8035a5:	19 cb                	sbb    %ecx,%ebx
  8035a7:	89 d8                	mov    %ebx,%eax
  8035a9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035ad:	d3 e0                	shl    %cl,%eax
  8035af:	89 e9                	mov    %ebp,%ecx
  8035b1:	d3 ea                	shr    %cl,%edx
  8035b3:	09 d0                	or     %edx,%eax
  8035b5:	89 e9                	mov    %ebp,%ecx
  8035b7:	d3 eb                	shr    %cl,%ebx
  8035b9:	89 da                	mov    %ebx,%edx
  8035bb:	83 c4 1c             	add    $0x1c,%esp
  8035be:	5b                   	pop    %ebx
  8035bf:	5e                   	pop    %esi
  8035c0:	5f                   	pop    %edi
  8035c1:	5d                   	pop    %ebp
  8035c2:	c3                   	ret    
  8035c3:	90                   	nop
  8035c4:	89 fd                	mov    %edi,%ebp
  8035c6:	85 ff                	test   %edi,%edi
  8035c8:	75 0b                	jne    8035d5 <__umoddi3+0xe9>
  8035ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cf:	31 d2                	xor    %edx,%edx
  8035d1:	f7 f7                	div    %edi
  8035d3:	89 c5                	mov    %eax,%ebp
  8035d5:	89 f0                	mov    %esi,%eax
  8035d7:	31 d2                	xor    %edx,%edx
  8035d9:	f7 f5                	div    %ebp
  8035db:	89 c8                	mov    %ecx,%eax
  8035dd:	f7 f5                	div    %ebp
  8035df:	89 d0                	mov    %edx,%eax
  8035e1:	e9 44 ff ff ff       	jmp    80352a <__umoddi3+0x3e>
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	89 c8                	mov    %ecx,%eax
  8035ea:	89 f2                	mov    %esi,%edx
  8035ec:	83 c4 1c             	add    $0x1c,%esp
  8035ef:	5b                   	pop    %ebx
  8035f0:	5e                   	pop    %esi
  8035f1:	5f                   	pop    %edi
  8035f2:	5d                   	pop    %ebp
  8035f3:	c3                   	ret    
  8035f4:	3b 04 24             	cmp    (%esp),%eax
  8035f7:	72 06                	jb     8035ff <__umoddi3+0x113>
  8035f9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035fd:	77 0f                	ja     80360e <__umoddi3+0x122>
  8035ff:	89 f2                	mov    %esi,%edx
  803601:	29 f9                	sub    %edi,%ecx
  803603:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803607:	89 14 24             	mov    %edx,(%esp)
  80360a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80360e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803612:	8b 14 24             	mov    (%esp),%edx
  803615:	83 c4 1c             	add    $0x1c,%esp
  803618:	5b                   	pop    %ebx
  803619:	5e                   	pop    %esi
  80361a:	5f                   	pop    %edi
  80361b:	5d                   	pop    %ebp
  80361c:	c3                   	ret    
  80361d:	8d 76 00             	lea    0x0(%esi),%esi
  803620:	2b 04 24             	sub    (%esp),%eax
  803623:	19 fa                	sbb    %edi,%edx
  803625:	89 d1                	mov    %edx,%ecx
  803627:	89 c6                	mov    %eax,%esi
  803629:	e9 71 ff ff ff       	jmp    80359f <__umoddi3+0xb3>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803634:	72 ea                	jb     803620 <__umoddi3+0x134>
  803636:	89 d9                	mov    %ebx,%ecx
  803638:	e9 62 ff ff ff       	jmp    80359f <__umoddi3+0xb3>
