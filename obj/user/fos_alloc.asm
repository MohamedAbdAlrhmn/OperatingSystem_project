
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
  80005c:	68 00 37 80 00       	push   $0x803700
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
  8000b9:	68 13 37 80 00       	push   $0x803713
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
  80010f:	68 13 37 80 00       	push   $0x803713
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
  80013e:	e8 8a 18 00 00       	call   8019cd <sys_getenvindex>
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
  8001a9:	e8 2c 16 00 00       	call   8017da <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 38 37 80 00       	push   $0x803738
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
  8001d9:	68 60 37 80 00       	push   $0x803760
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
  80020a:	68 88 37 80 00       	push   $0x803788
  80020f:	e8 34 01 00 00       	call   800348 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 e0 37 80 00       	push   $0x8037e0
  80022b:	e8 18 01 00 00       	call   800348 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 38 37 80 00       	push   $0x803738
  80023b:	e8 08 01 00 00       	call   800348 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800243:	e8 ac 15 00 00       	call   8017f4 <sys_enable_interrupt>

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
  80025b:	e8 39 17 00 00       	call   801999 <sys_destroy_env>
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
  80026c:	e8 8e 17 00 00       	call   8019ff <sys_exit_env>
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
  8002ba:	e8 6d 13 00 00       	call   80162c <sys_cputs>
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
  800331:	e8 f6 12 00 00       	call   80162c <sys_cputs>
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
  80037b:	e8 5a 14 00 00       	call   8017da <sys_disable_interrupt>
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
  80039b:	e8 54 14 00 00       	call   8017f4 <sys_enable_interrupt>
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
  8003e5:	e8 a6 30 00 00       	call   803490 <__udivdi3>
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
  800435:	e8 66 31 00 00       	call   8035a0 <__umoddi3>
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	05 14 3a 80 00       	add    $0x803a14,%eax
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
  800590:	8b 04 85 38 3a 80 00 	mov    0x803a38(,%eax,4),%eax
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
  800671:	8b 34 9d 80 38 80 00 	mov    0x803880(,%ebx,4),%esi
  800678:	85 f6                	test   %esi,%esi
  80067a:	75 19                	jne    800695 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80067c:	53                   	push   %ebx
  80067d:	68 25 3a 80 00       	push   $0x803a25
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
  800696:	68 2e 3a 80 00       	push   $0x803a2e
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
  8006c3:	be 31 3a 80 00       	mov    $0x803a31,%esi
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
  8010e9:	68 90 3b 80 00       	push   $0x803b90
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
  8011b9:	e8 b2 05 00 00       	call   801770 <sys_allocate_chunk>
  8011be:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8011c1:	a1 20 41 80 00       	mov    0x804120,%eax
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	50                   	push   %eax
  8011ca:	e8 27 0c 00 00       	call   801df6 <initialize_MemBlocksList>
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
  8011f7:	68 b5 3b 80 00       	push   $0x803bb5
  8011fc:	6a 33                	push   $0x33
  8011fe:	68 d3 3b 80 00       	push   $0x803bd3
  801203:	e8 a7 20 00 00       	call   8032af <_panic>
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
  801276:	68 e0 3b 80 00       	push   $0x803be0
  80127b:	6a 34                	push   $0x34
  80127d:	68 d3 3b 80 00       	push   $0x803bd3
  801282:	e8 28 20 00 00       	call   8032af <_panic>
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
  80130e:	e8 2b 08 00 00       	call   801b3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801313:	85 c0                	test   %eax,%eax
  801315:	74 11                	je     801328 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801317:	83 ec 0c             	sub    $0xc,%esp
  80131a:	ff 75 e8             	pushl  -0x18(%ebp)
  80131d:	e8 96 0e 00 00       	call   8021b8 <alloc_block_FF>
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
  801334:	e8 f2 0b 00 00       	call   801f2b <insert_sorted_allocList>
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
  80134e:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	50                   	push   %eax
  801358:	68 40 40 80 00       	push   $0x804040
  80135d:	e8 71 0b 00 00       	call   801ed3 <find_block>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80136c:	0f 84 a6 00 00 00    	je     801418 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	8b 50 0c             	mov    0xc(%eax),%edx
  801378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137b:	8b 40 08             	mov    0x8(%eax),%eax
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	52                   	push   %edx
  801382:	50                   	push   %eax
  801383:	e8 b0 03 00 00       	call   801738 <sys_free_user_mem>
  801388:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80138b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80138f:	75 14                	jne    8013a5 <free+0x5a>
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	68 b5 3b 80 00       	push   $0x803bb5
  801399:	6a 74                	push   $0x74
  80139b:	68 d3 3b 80 00       	push   $0x803bd3
  8013a0:	e8 0a 1f 00 00       	call   8032af <_panic>
  8013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	74 10                	je     8013be <free+0x73>
  8013ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	8b 52 04             	mov    0x4(%edx),%edx
  8013b9:	89 50 04             	mov    %edx,0x4(%eax)
  8013bc:	eb 0b                	jmp    8013c9 <free+0x7e>
  8013be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c1:	8b 40 04             	mov    0x4(%eax),%eax
  8013c4:	a3 44 40 80 00       	mov    %eax,0x804044
  8013c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cc:	8b 40 04             	mov    0x4(%eax),%eax
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	74 0f                	je     8013e2 <free+0x97>
  8013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d6:	8b 40 04             	mov    0x4(%eax),%eax
  8013d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dc:	8b 12                	mov    (%edx),%edx
  8013de:	89 10                	mov    %edx,(%eax)
  8013e0:	eb 0a                	jmp    8013ec <free+0xa1>
  8013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e5:	8b 00                	mov    (%eax),%eax
  8013e7:	a3 40 40 80 00       	mov    %eax,0x804040
  8013ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013ff:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801404:	48                   	dec    %eax
  801405:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(free_block);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	ff 75 f4             	pushl  -0xc(%ebp)
  801410:	e8 4e 17 00 00       	call   802b63 <insert_sorted_with_merge_freeList>
  801415:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801351:	8b 45 08             	mov    0x8(%ebp),%eax
  801354:	83 ec 08             	sub    $0x8,%esp
  801357:	50                   	push   %eax
  801358:	68 40 40 80 00       	push   $0x804040
  80135d:	e8 71 0b 00 00       	call   801ed3 <find_block>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80136c:	0f 84 a6 00 00 00    	je     801418 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801375:	8b 50 0c             	mov    0xc(%eax),%edx
  801378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137b:	8b 40 08             	mov    0x8(%eax),%eax
  80137e:	83 ec 08             	sub    $0x8,%esp
  801381:	52                   	push   %edx
  801382:	50                   	push   %eax
  801383:	e8 b0 03 00 00       	call   801738 <sys_free_user_mem>
  801388:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  80138b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80138f:	75 14                	jne    8013a5 <free+0x5a>
  801391:	83 ec 04             	sub    $0x4,%esp
  801394:	68 b5 3b 80 00       	push   $0x803bb5
  801399:	6a 7a                	push   $0x7a
  80139b:	68 d3 3b 80 00       	push   $0x803bd3
  8013a0:	e8 0a 1f 00 00       	call   8032af <_panic>
  8013a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	74 10                	je     8013be <free+0x73>
  8013ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b6:	8b 52 04             	mov    0x4(%edx),%edx
  8013b9:	89 50 04             	mov    %edx,0x4(%eax)
  8013bc:	eb 0b                	jmp    8013c9 <free+0x7e>
  8013be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c1:	8b 40 04             	mov    0x4(%eax),%eax
  8013c4:	a3 44 40 80 00       	mov    %eax,0x804044
  8013c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cc:	8b 40 04             	mov    0x4(%eax),%eax
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	74 0f                	je     8013e2 <free+0x97>
  8013d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d6:	8b 40 04             	mov    0x4(%eax),%eax
  8013d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013dc:	8b 12                	mov    (%edx),%edx
  8013de:	89 10                	mov    %edx,(%eax)
  8013e0:	eb 0a                	jmp    8013ec <free+0xa1>
  8013e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e5:	8b 00                	mov    (%eax),%eax
  8013e7:	a3 40 40 80 00       	mov    %eax,0x804040
  8013ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013ff:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801404:	48                   	dec    %eax
  801405:	a3 4c 40 80 00       	mov    %eax,0x80404c
	        insert_sorted_with_merge_freeList(free_block);
  80140a:	83 ec 0c             	sub    $0xc,%esp
  80140d:	ff 75 f4             	pushl  -0xc(%ebp)
  801410:	e8 4e 17 00 00       	call   802b63 <insert_sorted_with_merge_freeList>
  801415:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 38             	sub    $0x38,%esp
  801421:	8b 45 10             	mov    0x10(%ebp),%eax
  801424:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801427:	e8 a6 fc ff ff       	call   8010d2 <InitializeUHeap>
	if (size == 0) return NULL ;
  80142c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801430:	75 0a                	jne    80143c <smalloc+0x21>
  801432:	b8 00 00 00 00       	mov    $0x0,%eax
  801437:	e9 8b 00 00 00       	jmp    8014c7 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80143c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801449:	01 d0                	add    %edx,%eax
  80144b:	48                   	dec    %eax
  80144c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80144f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801452:	ba 00 00 00 00       	mov    $0x0,%edx
  801457:	f7 75 f0             	divl   -0x10(%ebp)
  80145a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145d:	29 d0                	sub    %edx,%eax
  80145f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801462:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801469:	e8 d0 06 00 00       	call   801b3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80146e:	85 c0                	test   %eax,%eax
  801470:	74 11                	je     801483 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801472:	83 ec 0c             	sub    $0xc,%esp
  801475:	ff 75 e8             	pushl  -0x18(%ebp)
  801478:	e8 3b 0d 00 00       	call   8021b8 <alloc_block_FF>
  80147d:	83 c4 10             	add    $0x10,%esp
  801480:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801487:	74 39                	je     8014c2 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148c:	8b 40 08             	mov    0x8(%eax),%eax
  80148f:	89 c2                	mov    %eax,%edx
  801491:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801495:	52                   	push   %edx
  801496:	50                   	push   %eax
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	e8 21 04 00 00       	call   8018c3 <sys_createSharedObject>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8014a8:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8014ac:	74 14                	je     8014c2 <smalloc+0xa7>
  8014ae:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8014b2:	74 0e                	je     8014c2 <smalloc+0xa7>
  8014b4:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8014b8:	74 08                	je     8014c2 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8014ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bd:	8b 40 08             	mov    0x8(%eax),%eax
  8014c0:	eb 05                	jmp    8014c7 <smalloc+0xac>
	}
	return NULL;
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    

008014c9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8014c9:	55                   	push   %ebp
  8014ca:	89 e5                	mov    %esp,%ebp
  8014cc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014cf:	e8 fe fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8014d4:	83 ec 08             	sub    $0x8,%esp
  8014d7:	ff 75 0c             	pushl  0xc(%ebp)
  8014da:	ff 75 08             	pushl  0x8(%ebp)
  8014dd:	e8 0b 04 00 00       	call   8018ed <sys_getSizeOfSharedObject>
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8014e8:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8014ec:	74 76                	je     801564 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8014ee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8014f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014fb:	01 d0                	add    %edx,%eax
  8014fd:	48                   	dec    %eax
  8014fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801501:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801504:	ba 00 00 00 00       	mov    $0x0,%edx
  801509:	f7 75 ec             	divl   -0x14(%ebp)
  80150c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150f:	29 d0                	sub    %edx,%eax
  801511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801514:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80151b:	e8 1e 06 00 00       	call   801b3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801520:	85 c0                	test   %eax,%eax
  801522:	74 11                	je     801535 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801524:	83 ec 0c             	sub    $0xc,%esp
  801527:	ff 75 e4             	pushl  -0x1c(%ebp)
  80152a:	e8 89 0c 00 00       	call   8021b8 <alloc_block_FF>
  80152f:	83 c4 10             	add    $0x10,%esp
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801539:	74 29                	je     801564 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153e:	8b 40 08             	mov    0x8(%eax),%eax
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	50                   	push   %eax
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	e8 ba 03 00 00       	call   80190a <sys_getSharedObject>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801556:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80155a:	74 08                	je     801564 <sget+0x9b>
				return (void *)mem_block->sva;
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155f:	8b 40 08             	mov    0x8(%eax),%eax
  801562:	eb 05                	jmp    801569 <sget+0xa0>
		}
	}
	return NULL;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801571:	e8 5c fb ff ff       	call   8010d2 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 04 3c 80 00       	push   $0x803c04
<<<<<<< HEAD
  80157e:	68 fc 00 00 00       	push   $0xfc
=======
  80157e:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801583:	68 d3 3b 80 00       	push   $0x803bd3
  801588:	e8 22 1d 00 00       	call   8032af <_panic>

0080158d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
  801590:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	68 2c 3c 80 00       	push   $0x803c2c
<<<<<<< HEAD
  80159b:	68 10 01 00 00       	push   $0x110
=======
  80159b:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8015a0:	68 d3 3b 80 00       	push   $0x803bd3
  8015a5:	e8 05 1d 00 00       	call   8032af <_panic>

008015aa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b0:	83 ec 04             	sub    $0x4,%esp
  8015b3:	68 50 3c 80 00       	push   $0x803c50
<<<<<<< HEAD
  8015b8:	68 1b 01 00 00       	push   $0x11b
=======
  8015b8:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8015bd:	68 d3 3b 80 00       	push   $0x803bd3
  8015c2:	e8 e8 1c 00 00       	call   8032af <_panic>

008015c7 <shrink>:

}
void shrink(uint32 newSize)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	68 50 3c 80 00       	push   $0x803c50
<<<<<<< HEAD
  8015d5:	68 20 01 00 00       	push   $0x120
=======
  8015d5:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8015da:	68 d3 3b 80 00       	push   $0x803bd3
  8015df:	e8 cb 1c 00 00       	call   8032af <_panic>

008015e4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	68 50 3c 80 00       	push   $0x803c50
<<<<<<< HEAD
  8015f2:	68 25 01 00 00       	push   $0x125
=======
  8015f2:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  8015f7:	68 d3 3b 80 00       	push   $0x803bd3
  8015fc:	e8 ae 1c 00 00       	call   8032af <_panic>

00801601 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	57                   	push   %edi
  801605:	56                   	push   %esi
  801606:	53                   	push   %ebx
  801607:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80160a:	8b 45 08             	mov    0x8(%ebp),%eax
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801613:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801616:	8b 7d 18             	mov    0x18(%ebp),%edi
  801619:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80161c:	cd 30                	int    $0x30
  80161e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	5b                   	pop    %ebx
  801628:	5e                   	pop    %esi
  801629:	5f                   	pop    %edi
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	8b 45 10             	mov    0x10(%ebp),%eax
  801635:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801638:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	6a 00                	push   $0x0
  801641:	6a 00                	push   $0x0
  801643:	52                   	push   %edx
  801644:	ff 75 0c             	pushl  0xc(%ebp)
  801647:	50                   	push   %eax
  801648:	6a 00                	push   $0x0
  80164a:	e8 b2 ff ff ff       	call   801601 <syscall>
  80164f:	83 c4 18             	add    $0x18,%esp
}
  801652:	90                   	nop
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sys_cgetc>:

int
sys_cgetc(void)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 00                	push   $0x0
  801662:	6a 01                	push   $0x1
  801664:	e8 98 ff ff ff       	call   801601 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
}
  80166c:	c9                   	leave  
  80166d:	c3                   	ret    

0080166e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801671:	8b 55 0c             	mov    0xc(%ebp),%edx
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	6a 00                	push   $0x0
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	52                   	push   %edx
  80167e:	50                   	push   %eax
  80167f:	6a 05                	push   $0x5
  801681:	e8 7b ff ff ff       	call   801601 <syscall>
  801686:	83 c4 18             	add    $0x18,%esp
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801690:	8b 75 18             	mov    0x18(%ebp),%esi
  801693:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801696:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801699:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	56                   	push   %esi
  8016a0:	53                   	push   %ebx
  8016a1:	51                   	push   %ecx
  8016a2:	52                   	push   %edx
  8016a3:	50                   	push   %eax
  8016a4:	6a 06                	push   $0x6
  8016a6:	e8 56 ff ff ff       	call   801601 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b1:	5b                   	pop    %ebx
  8016b2:	5e                   	pop    %esi
  8016b3:	5d                   	pop    %ebp
  8016b4:	c3                   	ret    

008016b5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	52                   	push   %edx
  8016c5:	50                   	push   %eax
  8016c6:	6a 07                	push   $0x7
  8016c8:	e8 34 ff ff ff       	call   801601 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	c9                   	leave  
  8016d1:	c3                   	ret    

008016d2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016d2:	55                   	push   %ebp
  8016d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	ff 75 08             	pushl  0x8(%ebp)
  8016e1:	6a 08                	push   $0x8
  8016e3:	e8 19 ff ff ff       	call   801601 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 09                	push   $0x9
  8016fc:	e8 00 ff ff ff       	call   801601 <syscall>
  801701:	83 c4 18             	add    $0x18,%esp
}
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 0a                	push   $0xa
  801715:	e8 e7 fe ff ff       	call   801601 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 0b                	push   $0xb
  80172e:	e8 ce fe ff ff       	call   801601 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	ff 75 0c             	pushl  0xc(%ebp)
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	6a 0f                	push   $0xf
  801749:	e8 b3 fe ff ff       	call   801601 <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	ff 75 0c             	pushl  0xc(%ebp)
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	6a 10                	push   $0x10
  801765:	e8 97 fe ff ff       	call   801601 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
	return ;
  80176d:	90                   	nop
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	ff 75 10             	pushl  0x10(%ebp)
  80177a:	ff 75 0c             	pushl  0xc(%ebp)
  80177d:	ff 75 08             	pushl  0x8(%ebp)
  801780:	6a 11                	push   $0x11
  801782:	e8 7a fe ff ff       	call   801601 <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
	return ;
  80178a:	90                   	nop
}
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 0c                	push   $0xc
  80179c:	e8 60 fe ff ff       	call   801601 <syscall>
  8017a1:	83 c4 18             	add    $0x18,%esp
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 0d                	push   $0xd
  8017b6:	e8 46 fe ff ff       	call   801601 <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
}
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 0e                	push   $0xe
  8017cf:	e8 2d fe ff ff       	call   801601 <syscall>
  8017d4:	83 c4 18             	add    $0x18,%esp
}
  8017d7:	90                   	nop
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 13                	push   $0x13
  8017e9:	e8 13 fe ff ff       	call   801601 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	90                   	nop
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 14                	push   $0x14
  801803:	e8 f9 fd ff ff       	call   801601 <syscall>
  801808:	83 c4 18             	add    $0x18,%esp
}
  80180b:	90                   	nop
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <sys_cputc>:


void
sys_cputc(const char c)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80181a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	50                   	push   %eax
  801827:	6a 15                	push   $0x15
  801829:	e8 d3 fd ff ff       	call   801601 <syscall>
  80182e:	83 c4 18             	add    $0x18,%esp
}
  801831:	90                   	nop
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 16                	push   $0x16
  801843:	e8 b9 fd ff ff       	call   801601 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
}
  80184b:	90                   	nop
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	ff 75 0c             	pushl  0xc(%ebp)
  80185d:	50                   	push   %eax
  80185e:	6a 17                	push   $0x17
  801860:	e8 9c fd ff ff       	call   801601 <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	6a 1a                	push   $0x1a
  80187d:	e8 7f fd ff ff       	call   801601 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 18                	push   $0x18
  80189a:	e8 62 fd ff ff       	call   801601 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	52                   	push   %edx
  8018b5:	50                   	push   %eax
  8018b6:	6a 19                	push   $0x19
  8018b8:	e8 44 fd ff ff       	call   801601 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	90                   	nop
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 04             	sub    $0x4,%esp
  8018c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d9:	6a 00                	push   $0x0
  8018db:	51                   	push   %ecx
  8018dc:	52                   	push   %edx
  8018dd:	ff 75 0c             	pushl  0xc(%ebp)
  8018e0:	50                   	push   %eax
  8018e1:	6a 1b                	push   $0x1b
  8018e3:	e8 19 fd ff ff       	call   801601 <syscall>
  8018e8:	83 c4 18             	add    $0x18,%esp
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 1c                	push   $0x1c
  801900:	e8 fc fc ff ff       	call   801601 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80190d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801910:	8b 55 0c             	mov    0xc(%ebp),%edx
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	51                   	push   %ecx
  80191b:	52                   	push   %edx
  80191c:	50                   	push   %eax
  80191d:	6a 1d                	push   $0x1d
  80191f:	e8 dd fc ff ff       	call   801601 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80192c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	52                   	push   %edx
  801939:	50                   	push   %eax
  80193a:	6a 1e                	push   $0x1e
  80193c:	e8 c0 fc ff ff       	call   801601 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 1f                	push   $0x1f
  801955:	e8 a7 fc ff ff       	call   801601 <syscall>
  80195a:	83 c4 18             	add    $0x18,%esp
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	ff 75 14             	pushl  0x14(%ebp)
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	50                   	push   %eax
  801971:	6a 20                	push   $0x20
  801973:	e8 89 fc ff ff       	call   801601 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	50                   	push   %eax
  80198c:	6a 21                	push   $0x21
  80198e:	e8 6e fc ff ff       	call   801601 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	90                   	nop
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	50                   	push   %eax
  8019a8:	6a 22                	push   $0x22
  8019aa:	e8 52 fc ff ff       	call   801601 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 02                	push   $0x2
  8019c3:	e8 39 fc ff ff       	call   801601 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 03                	push   $0x3
  8019dc:	e8 20 fc ff ff       	call   801601 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 04                	push   $0x4
  8019f5:	e8 07 fc ff ff       	call   801601 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_exit_env>:


void sys_exit_env(void)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 23                	push   $0x23
  801a0e:	e8 ee fb ff ff       	call   801601 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a1f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a22:	8d 50 04             	lea    0x4(%eax),%edx
  801a25:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	52                   	push   %edx
  801a2f:	50                   	push   %eax
  801a30:	6a 24                	push   $0x24
  801a32:	e8 ca fb ff ff       	call   801601 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
	return result;
  801a3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a43:	89 01                	mov    %eax,(%ecx)
  801a45:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	c9                   	leave  
  801a4c:	c2 04 00             	ret    $0x4

00801a4f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 10             	pushl  0x10(%ebp)
  801a59:	ff 75 0c             	pushl  0xc(%ebp)
  801a5c:	ff 75 08             	pushl  0x8(%ebp)
  801a5f:	6a 12                	push   $0x12
  801a61:	e8 9b fb ff ff       	call   801601 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
	return ;
  801a69:	90                   	nop
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_rcr2>:
uint32 sys_rcr2()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 25                	push   $0x25
  801a7b:	e8 81 fb ff ff       	call   801601 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a91:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	50                   	push   %eax
  801a9e:	6a 26                	push   $0x26
  801aa0:	e8 5c fb ff ff       	call   801601 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa8:	90                   	nop
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <rsttst>:
void rsttst()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 28                	push   $0x28
  801aba:	e8 42 fb ff ff       	call   801601 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac2:	90                   	nop
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ace:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ad1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ad4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	ff 75 10             	pushl  0x10(%ebp)
  801add:	ff 75 0c             	pushl  0xc(%ebp)
  801ae0:	ff 75 08             	pushl  0x8(%ebp)
  801ae3:	6a 27                	push   $0x27
  801ae5:	e8 17 fb ff ff       	call   801601 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
	return ;
  801aed:	90                   	nop
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <chktst>:
void chktst(uint32 n)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 08             	pushl  0x8(%ebp)
  801afe:	6a 29                	push   $0x29
  801b00:	e8 fc fa ff ff       	call   801601 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
	return ;
  801b08:	90                   	nop
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <inctst>:

void inctst()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 2a                	push   $0x2a
  801b1a:	e8 e2 fa ff ff       	call   801601 <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b22:	90                   	nop
}
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <gettst>:
uint32 gettst()
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 2b                	push   $0x2b
  801b34:	e8 c8 fa ff ff       	call   801601 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 2c                	push   $0x2c
  801b50:	e8 ac fa ff ff       	call   801601 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
  801b58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b5b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b5f:	75 07                	jne    801b68 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b61:	b8 01 00 00 00       	mov    $0x1,%eax
  801b66:	eb 05                	jmp    801b6d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 2c                	push   $0x2c
  801b81:	e8 7b fa ff ff       	call   801601 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
  801b89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b8c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b90:	75 07                	jne    801b99 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b92:	b8 01 00 00 00       	mov    $0x1,%eax
  801b97:	eb 05                	jmp    801b9e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 2c                	push   $0x2c
  801bb2:	e8 4a fa ff ff       	call   801601 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
  801bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bbd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bc1:	75 07                	jne    801bca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc8:	eb 05                	jmp    801bcf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 2c                	push   $0x2c
  801be3:	e8 19 fa ff ff       	call   801601 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
  801beb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bf2:	75 07                	jne    801bfb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bf4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf9:	eb 05                	jmp    801c00 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	6a 2d                	push   $0x2d
  801c12:	e8 ea f9 ff ff       	call   801601 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	53                   	push   %ebx
  801c30:	51                   	push   %ecx
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	6a 2e                	push   $0x2e
  801c35:	e8 c7 f9 ff ff       	call   801601 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	6a 2f                	push   $0x2f
  801c55:	e8 a7 f9 ff ff       	call   801601 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	68 60 3c 80 00       	push   $0x803c60
  801c6d:	e8 d6 e6 ff ff       	call   800348 <cprintf>
  801c72:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c75:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c7c:	83 ec 0c             	sub    $0xc,%esp
  801c7f:	68 8c 3c 80 00       	push   $0x803c8c
  801c84:	e8 bf e6 ff ff       	call   800348 <cprintf>
  801c89:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c8c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c90:	a1 38 41 80 00       	mov    0x804138,%eax
  801c95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c98:	eb 56                	jmp    801cf0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c9e:	74 1c                	je     801cbc <print_mem_block_lists+0x5d>
  801ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca3:	8b 50 08             	mov    0x8(%eax),%edx
  801ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca9:	8b 48 08             	mov    0x8(%eax),%ecx
  801cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801caf:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb2:	01 c8                	add    %ecx,%eax
  801cb4:	39 c2                	cmp    %eax,%edx
  801cb6:	73 04                	jae    801cbc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cb8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbf:	8b 50 08             	mov    0x8(%eax),%edx
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc8:	01 c2                	add    %eax,%edx
  801cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccd:	8b 40 08             	mov    0x8(%eax),%eax
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	52                   	push   %edx
  801cd4:	50                   	push   %eax
  801cd5:	68 a1 3c 80 00       	push   $0x803ca1
  801cda:	e8 69 e6 ff ff       	call   800348 <cprintf>
  801cdf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce8:	a1 40 41 80 00       	mov    0x804140,%eax
  801ced:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf4:	74 07                	je     801cfd <print_mem_block_lists+0x9e>
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
  801cfb:	eb 05                	jmp    801d02 <print_mem_block_lists+0xa3>
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801d02:	a3 40 41 80 00       	mov    %eax,0x804140
  801d07:	a1 40 41 80 00       	mov    0x804140,%eax
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	75 8a                	jne    801c9a <print_mem_block_lists+0x3b>
  801d10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d14:	75 84                	jne    801c9a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d16:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d1a:	75 10                	jne    801d2c <print_mem_block_lists+0xcd>
  801d1c:	83 ec 0c             	sub    $0xc,%esp
  801d1f:	68 b0 3c 80 00       	push   $0x803cb0
  801d24:	e8 1f e6 ff ff       	call   800348 <cprintf>
  801d29:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d2c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	68 d4 3c 80 00       	push   $0x803cd4
  801d3b:	e8 08 e6 ff ff       	call   800348 <cprintf>
  801d40:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d43:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d47:	a1 40 40 80 00       	mov    0x804040,%eax
  801d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d4f:	eb 56                	jmp    801da7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d55:	74 1c                	je     801d73 <print_mem_block_lists+0x114>
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	8b 50 08             	mov    0x8(%eax),%edx
  801d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d60:	8b 48 08             	mov    0x8(%eax),%ecx
  801d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d66:	8b 40 0c             	mov    0xc(%eax),%eax
  801d69:	01 c8                	add    %ecx,%eax
  801d6b:	39 c2                	cmp    %eax,%edx
  801d6d:	73 04                	jae    801d73 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d6f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d76:	8b 50 08             	mov    0x8(%eax),%edx
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7f:	01 c2                	add    %eax,%edx
  801d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d84:	8b 40 08             	mov    0x8(%eax),%eax
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	68 a1 3c 80 00       	push   $0x803ca1
  801d91:	e8 b2 e5 ff ff       	call   800348 <cprintf>
  801d96:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d9f:	a1 48 40 80 00       	mov    0x804048,%eax
  801da4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dab:	74 07                	je     801db4 <print_mem_block_lists+0x155>
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	8b 00                	mov    (%eax),%eax
  801db2:	eb 05                	jmp    801db9 <print_mem_block_lists+0x15a>
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	a3 48 40 80 00       	mov    %eax,0x804048
  801dbe:	a1 48 40 80 00       	mov    0x804048,%eax
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	75 8a                	jne    801d51 <print_mem_block_lists+0xf2>
  801dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dcb:	75 84                	jne    801d51 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dcd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dd1:	75 10                	jne    801de3 <print_mem_block_lists+0x184>
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	68 ec 3c 80 00       	push   $0x803cec
  801ddb:	e8 68 e5 ff ff       	call   800348 <cprintf>
  801de0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801de3:	83 ec 0c             	sub    $0xc,%esp
  801de6:	68 60 3c 80 00       	push   $0x803c60
  801deb:	e8 58 e5 ff ff       	call   800348 <cprintf>
  801df0:	83 c4 10             	add    $0x10,%esp

}
  801df3:	90                   	nop
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
  801df9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801dfc:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e03:	00 00 00 
  801e06:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e0d:	00 00 00 
  801e10:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e17:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e21:	e9 9e 00 00 00       	jmp    801ec4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e26:	a1 50 40 80 00       	mov    0x804050,%eax
  801e2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e2e:	c1 e2 04             	shl    $0x4,%edx
  801e31:	01 d0                	add    %edx,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	75 14                	jne    801e4b <initialize_MemBlocksList+0x55>
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 14 3d 80 00       	push   $0x803d14
  801e3f:	6a 46                	push   $0x46
  801e41:	68 37 3d 80 00       	push   $0x803d37
  801e46:	e8 64 14 00 00       	call   8032af <_panic>
  801e4b:	a1 50 40 80 00       	mov    0x804050,%eax
  801e50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e53:	c1 e2 04             	shl    $0x4,%edx
  801e56:	01 d0                	add    %edx,%eax
  801e58:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e5e:	89 10                	mov    %edx,(%eax)
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	85 c0                	test   %eax,%eax
  801e64:	74 18                	je     801e7e <initialize_MemBlocksList+0x88>
  801e66:	a1 48 41 80 00       	mov    0x804148,%eax
  801e6b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e71:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e74:	c1 e1 04             	shl    $0x4,%ecx
  801e77:	01 ca                	add    %ecx,%edx
  801e79:	89 50 04             	mov    %edx,0x4(%eax)
  801e7c:	eb 12                	jmp    801e90 <initialize_MemBlocksList+0x9a>
  801e7e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e86:	c1 e2 04             	shl    $0x4,%edx
  801e89:	01 d0                	add    %edx,%eax
  801e8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e90:	a1 50 40 80 00       	mov    0x804050,%eax
  801e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e98:	c1 e2 04             	shl    $0x4,%edx
  801e9b:	01 d0                	add    %edx,%eax
  801e9d:	a3 48 41 80 00       	mov    %eax,0x804148
  801ea2:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eaa:	c1 e2 04             	shl    $0x4,%edx
  801ead:	01 d0                	add    %edx,%eax
  801eaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801eb6:	a1 54 41 80 00       	mov    0x804154,%eax
  801ebb:	40                   	inc    %eax
  801ebc:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ec1:	ff 45 f4             	incl   -0xc(%ebp)
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eca:	0f 82 56 ff ff ff    	jb     801e26 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ed0:	90                   	nop
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	8b 00                	mov    (%eax),%eax
  801ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ee1:	eb 19                	jmp    801efc <find_block+0x29>
	{
		if(va==point->sva)
  801ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee6:	8b 40 08             	mov    0x8(%eax),%eax
  801ee9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eec:	75 05                	jne    801ef3 <find_block+0x20>
		   return point;
  801eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ef1:	eb 36                	jmp    801f29 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8b 40 08             	mov    0x8(%eax),%eax
  801ef9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801efc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f00:	74 07                	je     801f09 <find_block+0x36>
  801f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f05:	8b 00                	mov    (%eax),%eax
  801f07:	eb 05                	jmp    801f0e <find_block+0x3b>
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f11:	89 42 08             	mov    %eax,0x8(%edx)
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	8b 40 08             	mov    0x8(%eax),%eax
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	75 c5                	jne    801ee3 <find_block+0x10>
  801f1e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f22:	75 bf                	jne    801ee3 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f31:	a1 40 40 80 00       	mov    0x804040,%eax
  801f36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f39:	a1 44 40 80 00       	mov    0x804044,%eax
  801f3e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f44:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f47:	74 24                	je     801f6d <insert_sorted_allocList+0x42>
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	8b 50 08             	mov    0x8(%eax),%edx
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	8b 40 08             	mov    0x8(%eax),%eax
  801f55:	39 c2                	cmp    %eax,%edx
  801f57:	76 14                	jbe    801f6d <insert_sorted_allocList+0x42>
  801f59:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5c:	8b 50 08             	mov    0x8(%eax),%edx
  801f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f62:	8b 40 08             	mov    0x8(%eax),%eax
  801f65:	39 c2                	cmp    %eax,%edx
  801f67:	0f 82 60 01 00 00    	jb     8020cd <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f71:	75 65                	jne    801fd8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f77:	75 14                	jne    801f8d <insert_sorted_allocList+0x62>
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	68 14 3d 80 00       	push   $0x803d14
  801f81:	6a 6b                	push   $0x6b
  801f83:	68 37 3d 80 00       	push   $0x803d37
  801f88:	e8 22 13 00 00       	call   8032af <_panic>
  801f8d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	89 10                	mov    %edx,(%eax)
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	8b 00                	mov    (%eax),%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	74 0d                	je     801fae <insert_sorted_allocList+0x83>
  801fa1:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa9:	89 50 04             	mov    %edx,0x4(%eax)
  801fac:	eb 08                	jmp    801fb6 <insert_sorted_allocList+0x8b>
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	a3 44 40 80 00       	mov    %eax,0x804044
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	a3 40 40 80 00       	mov    %eax,0x804040
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fcd:	40                   	inc    %eax
  801fce:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fd3:	e9 dc 01 00 00       	jmp    8021b4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 50 08             	mov    0x8(%eax),%edx
  801fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe1:	8b 40 08             	mov    0x8(%eax),%eax
  801fe4:	39 c2                	cmp    %eax,%edx
  801fe6:	77 6c                	ja     802054 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fec:	74 06                	je     801ff4 <insert_sorted_allocList+0xc9>
  801fee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff2:	75 14                	jne    802008 <insert_sorted_allocList+0xdd>
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 50 3d 80 00       	push   $0x803d50
  801ffc:	6a 6f                	push   $0x6f
  801ffe:	68 37 3d 80 00       	push   $0x803d37
  802003:	e8 a7 12 00 00       	call   8032af <_panic>
  802008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200b:	8b 50 04             	mov    0x4(%eax),%edx
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 50 04             	mov    %edx,0x4(%eax)
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80201a:	89 10                	mov    %edx,(%eax)
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201f:	8b 40 04             	mov    0x4(%eax),%eax
  802022:	85 c0                	test   %eax,%eax
  802024:	74 0d                	je     802033 <insert_sorted_allocList+0x108>
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 40 04             	mov    0x4(%eax),%eax
  80202c:	8b 55 08             	mov    0x8(%ebp),%edx
  80202f:	89 10                	mov    %edx,(%eax)
  802031:	eb 08                	jmp    80203b <insert_sorted_allocList+0x110>
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	a3 40 40 80 00       	mov    %eax,0x804040
  80203b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203e:	8b 55 08             	mov    0x8(%ebp),%edx
  802041:	89 50 04             	mov    %edx,0x4(%eax)
  802044:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802049:	40                   	inc    %eax
  80204a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80204f:	e9 60 01 00 00       	jmp    8021b4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	8b 50 08             	mov    0x8(%eax),%edx
  80205a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80205d:	8b 40 08             	mov    0x8(%eax),%eax
  802060:	39 c2                	cmp    %eax,%edx
  802062:	0f 82 4c 01 00 00    	jb     8021b4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80206c:	75 14                	jne    802082 <insert_sorted_allocList+0x157>
  80206e:	83 ec 04             	sub    $0x4,%esp
  802071:	68 88 3d 80 00       	push   $0x803d88
  802076:	6a 73                	push   $0x73
  802078:	68 37 3d 80 00       	push   $0x803d37
  80207d:	e8 2d 12 00 00       	call   8032af <_panic>
  802082:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	89 50 04             	mov    %edx,0x4(%eax)
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	8b 40 04             	mov    0x4(%eax),%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	74 0c                	je     8020a4 <insert_sorted_allocList+0x179>
  802098:	a1 44 40 80 00       	mov    0x804044,%eax
  80209d:	8b 55 08             	mov    0x8(%ebp),%edx
  8020a0:	89 10                	mov    %edx,(%eax)
  8020a2:	eb 08                	jmp    8020ac <insert_sorted_allocList+0x181>
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020bd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c2:	40                   	inc    %eax
  8020c3:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c8:	e9 e7 00 00 00       	jmp    8021b4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020da:	a1 40 40 80 00       	mov    0x804040,%eax
  8020df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e2:	e9 9d 00 00 00       	jmp    802184 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	8b 00                	mov    (%eax),%eax
  8020ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	8b 50 08             	mov    0x8(%eax),%edx
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 40 08             	mov    0x8(%eax),%eax
  8020fb:	39 c2                	cmp    %eax,%edx
  8020fd:	76 7d                	jbe    80217c <insert_sorted_allocList+0x251>
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	8b 50 08             	mov    0x8(%eax),%edx
  802105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802108:	8b 40 08             	mov    0x8(%eax),%eax
  80210b:	39 c2                	cmp    %eax,%edx
  80210d:	73 6d                	jae    80217c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80210f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802113:	74 06                	je     80211b <insert_sorted_allocList+0x1f0>
  802115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802119:	75 14                	jne    80212f <insert_sorted_allocList+0x204>
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	68 ac 3d 80 00       	push   $0x803dac
  802123:	6a 7f                	push   $0x7f
  802125:	68 37 3d 80 00       	push   $0x803d37
  80212a:	e8 80 11 00 00       	call   8032af <_panic>
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 10                	mov    (%eax),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	89 10                	mov    %edx,(%eax)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	8b 00                	mov    (%eax),%eax
  80213e:	85 c0                	test   %eax,%eax
  802140:	74 0b                	je     80214d <insert_sorted_allocList+0x222>
  802142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	8b 55 08             	mov    0x8(%ebp),%edx
  80214a:	89 50 04             	mov    %edx,0x4(%eax)
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	8b 55 08             	mov    0x8(%ebp),%edx
  802153:	89 10                	mov    %edx,(%eax)
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215b:	89 50 04             	mov    %edx,0x4(%eax)
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	8b 00                	mov    (%eax),%eax
  802163:	85 c0                	test   %eax,%eax
  802165:	75 08                	jne    80216f <insert_sorted_allocList+0x244>
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	a3 44 40 80 00       	mov    %eax,0x804044
  80216f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802174:	40                   	inc    %eax
  802175:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80217a:	eb 39                	jmp    8021b5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80217c:	a1 48 40 80 00       	mov    0x804048,%eax
  802181:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802184:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802188:	74 07                	je     802191 <insert_sorted_allocList+0x266>
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	eb 05                	jmp    802196 <insert_sorted_allocList+0x26b>
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
  802196:	a3 48 40 80 00       	mov    %eax,0x804048
  80219b:	a1 48 40 80 00       	mov    0x804048,%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	0f 85 3f ff ff ff    	jne    8020e7 <insert_sorted_allocList+0x1bc>
  8021a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ac:	0f 85 35 ff ff ff    	jne    8020e7 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021b2:	eb 01                	jmp    8021b5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021b5:	90                   	nop
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021be:	a1 38 41 80 00       	mov    0x804138,%eax
  8021c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021c6:	e9 85 01 00 00       	jmp    802350 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d4:	0f 82 6e 01 00 00    	jb     802348 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8021e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e3:	0f 85 8a 00 00 00    	jne    802273 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ed:	75 17                	jne    802206 <alloc_block_FF+0x4e>
  8021ef:	83 ec 04             	sub    $0x4,%esp
  8021f2:	68 e0 3d 80 00       	push   $0x803de0
  8021f7:	68 93 00 00 00       	push   $0x93
  8021fc:	68 37 3d 80 00       	push   $0x803d37
  802201:	e8 a9 10 00 00       	call   8032af <_panic>
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 00                	mov    (%eax),%eax
  80220b:	85 c0                	test   %eax,%eax
  80220d:	74 10                	je     80221f <alloc_block_FF+0x67>
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802217:	8b 52 04             	mov    0x4(%edx),%edx
  80221a:	89 50 04             	mov    %edx,0x4(%eax)
  80221d:	eb 0b                	jmp    80222a <alloc_block_FF+0x72>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 40 04             	mov    0x4(%eax),%eax
  802225:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	8b 40 04             	mov    0x4(%eax),%eax
  802230:	85 c0                	test   %eax,%eax
  802232:	74 0f                	je     802243 <alloc_block_FF+0x8b>
  802234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223d:	8b 12                	mov    (%edx),%edx
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	eb 0a                	jmp    80224d <alloc_block_FF+0x95>
  802243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802246:	8b 00                	mov    (%eax),%eax
  802248:	a3 38 41 80 00       	mov    %eax,0x804138
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802260:	a1 44 41 80 00       	mov    0x804144,%eax
  802265:	48                   	dec    %eax
  802266:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80226b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226e:	e9 10 01 00 00       	jmp    802383 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 40 0c             	mov    0xc(%eax),%eax
  802279:	3b 45 08             	cmp    0x8(%ebp),%eax
  80227c:	0f 86 c6 00 00 00    	jbe    802348 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802282:	a1 48 41 80 00       	mov    0x804148,%eax
  802287:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80228a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228d:	8b 50 08             	mov    0x8(%eax),%edx
  802290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802293:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802299:	8b 55 08             	mov    0x8(%ebp),%edx
  80229c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80229f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a3:	75 17                	jne    8022bc <alloc_block_FF+0x104>
  8022a5:	83 ec 04             	sub    $0x4,%esp
  8022a8:	68 e0 3d 80 00       	push   $0x803de0
  8022ad:	68 9b 00 00 00       	push   $0x9b
  8022b2:	68 37 3d 80 00       	push   $0x803d37
  8022b7:	e8 f3 0f 00 00       	call   8032af <_panic>
  8022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	85 c0                	test   %eax,%eax
  8022c3:	74 10                	je     8022d5 <alloc_block_FF+0x11d>
  8022c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c8:	8b 00                	mov    (%eax),%eax
  8022ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022cd:	8b 52 04             	mov    0x4(%edx),%edx
  8022d0:	89 50 04             	mov    %edx,0x4(%eax)
  8022d3:	eb 0b                	jmp    8022e0 <alloc_block_FF+0x128>
  8022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d8:	8b 40 04             	mov    0x4(%eax),%eax
  8022db:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e3:	8b 40 04             	mov    0x4(%eax),%eax
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	74 0f                	je     8022f9 <alloc_block_FF+0x141>
  8022ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ed:	8b 40 04             	mov    0x4(%eax),%eax
  8022f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f3:	8b 12                	mov    (%edx),%edx
  8022f5:	89 10                	mov    %edx,(%eax)
  8022f7:	eb 0a                	jmp    802303 <alloc_block_FF+0x14b>
  8022f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	a3 48 41 80 00       	mov    %eax,0x804148
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80230c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802316:	a1 54 41 80 00       	mov    0x804154,%eax
  80231b:	48                   	dec    %eax
  80231c:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 50 08             	mov    0x8(%eax),%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	01 c2                	add    %eax,%edx
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 40 0c             	mov    0xc(%eax),%eax
  802338:	2b 45 08             	sub    0x8(%ebp),%eax
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	eb 3b                	jmp    802383 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802348:	a1 40 41 80 00       	mov    0x804140,%eax
  80234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802350:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802354:	74 07                	je     80235d <alloc_block_FF+0x1a5>
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	eb 05                	jmp    802362 <alloc_block_FF+0x1aa>
  80235d:	b8 00 00 00 00       	mov    $0x0,%eax
  802362:	a3 40 41 80 00       	mov    %eax,0x804140
  802367:	a1 40 41 80 00       	mov    0x804140,%eax
  80236c:	85 c0                	test   %eax,%eax
  80236e:	0f 85 57 fe ff ff    	jne    8021cb <alloc_block_FF+0x13>
  802374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802378:	0f 85 4d fe ff ff    	jne    8021cb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80237e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802383:	c9                   	leave  
  802384:	c3                   	ret    

00802385 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80238b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802392:	a1 38 41 80 00       	mov    0x804138,%eax
  802397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239a:	e9 df 00 00 00       	jmp    80247e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a8:	0f 82 c8 00 00 00    	jb     802476 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b7:	0f 85 8a 00 00 00    	jne    802447 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	75 17                	jne    8023da <alloc_block_BF+0x55>
  8023c3:	83 ec 04             	sub    $0x4,%esp
  8023c6:	68 e0 3d 80 00       	push   $0x803de0
  8023cb:	68 b7 00 00 00       	push   $0xb7
  8023d0:	68 37 3d 80 00       	push   $0x803d37
  8023d5:	e8 d5 0e 00 00       	call   8032af <_panic>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 10                	je     8023f3 <alloc_block_BF+0x6e>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023eb:	8b 52 04             	mov    0x4(%edx),%edx
  8023ee:	89 50 04             	mov    %edx,0x4(%eax)
  8023f1:	eb 0b                	jmp    8023fe <alloc_block_BF+0x79>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 04             	mov    0x4(%eax),%eax
  8023f9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	85 c0                	test   %eax,%eax
  802406:	74 0f                	je     802417 <alloc_block_BF+0x92>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 04             	mov    0x4(%eax),%eax
  80240e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802411:	8b 12                	mov    (%edx),%edx
  802413:	89 10                	mov    %edx,(%eax)
  802415:	eb 0a                	jmp    802421 <alloc_block_BF+0x9c>
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 00                	mov    (%eax),%eax
  80241c:	a3 38 41 80 00       	mov    %eax,0x804138
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802434:	a1 44 41 80 00       	mov    0x804144,%eax
  802439:	48                   	dec    %eax
  80243a:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	e9 4d 01 00 00       	jmp    802594 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 40 0c             	mov    0xc(%eax),%eax
  80244d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802450:	76 24                	jbe    802476 <alloc_block_BF+0xf1>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80245b:	73 19                	jae    802476 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80245d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 0c             	mov    0xc(%eax),%eax
  80246a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 40 08             	mov    0x8(%eax),%eax
  802473:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802476:	a1 40 41 80 00       	mov    0x804140,%eax
  80247b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	74 07                	je     80248b <alloc_block_BF+0x106>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	eb 05                	jmp    802490 <alloc_block_BF+0x10b>
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
  802490:	a3 40 41 80 00       	mov    %eax,0x804140
  802495:	a1 40 41 80 00       	mov    0x804140,%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	0f 85 fd fe ff ff    	jne    80239f <alloc_block_BF+0x1a>
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	0f 85 f3 fe ff ff    	jne    80239f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024b0:	0f 84 d9 00 00 00    	je     80258f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8024bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cd:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024d4:	75 17                	jne    8024ed <alloc_block_BF+0x168>
  8024d6:	83 ec 04             	sub    $0x4,%esp
  8024d9:	68 e0 3d 80 00       	push   $0x803de0
  8024de:	68 c7 00 00 00       	push   $0xc7
  8024e3:	68 37 3d 80 00       	push   $0x803d37
  8024e8:	e8 c2 0d 00 00       	call   8032af <_panic>
  8024ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	74 10                	je     802506 <alloc_block_BF+0x181>
  8024f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f9:	8b 00                	mov    (%eax),%eax
  8024fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024fe:	8b 52 04             	mov    0x4(%edx),%edx
  802501:	89 50 04             	mov    %edx,0x4(%eax)
  802504:	eb 0b                	jmp    802511 <alloc_block_BF+0x18c>
  802506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802514:	8b 40 04             	mov    0x4(%eax),%eax
  802517:	85 c0                	test   %eax,%eax
  802519:	74 0f                	je     80252a <alloc_block_BF+0x1a5>
  80251b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251e:	8b 40 04             	mov    0x4(%eax),%eax
  802521:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802524:	8b 12                	mov    (%edx),%edx
  802526:	89 10                	mov    %edx,(%eax)
  802528:	eb 0a                	jmp    802534 <alloc_block_BF+0x1af>
  80252a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252d:	8b 00                	mov    (%eax),%eax
  80252f:	a3 48 41 80 00       	mov    %eax,0x804148
  802534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802547:	a1 54 41 80 00       	mov    0x804154,%eax
  80254c:	48                   	dec    %eax
  80254d:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802552:	83 ec 08             	sub    $0x8,%esp
  802555:	ff 75 ec             	pushl  -0x14(%ebp)
  802558:	68 38 41 80 00       	push   $0x804138
  80255d:	e8 71 f9 ff ff       	call   801ed3 <find_block>
  802562:	83 c4 10             	add    $0x10,%esp
  802565:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80256b:	8b 50 08             	mov    0x8(%eax),%edx
  80256e:	8b 45 08             	mov    0x8(%ebp),%eax
  802571:	01 c2                	add    %eax,%edx
  802573:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802576:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257c:	8b 40 0c             	mov    0xc(%eax),%eax
  80257f:	2b 45 08             	sub    0x8(%ebp),%eax
  802582:	89 c2                	mov    %eax,%edx
  802584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802587:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80258a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258d:	eb 05                	jmp    802594 <alloc_block_BF+0x20f>
	}
	return NULL;
  80258f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802594:	c9                   	leave  
  802595:	c3                   	ret    

00802596 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80259c:	a1 28 40 80 00       	mov    0x804028,%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	0f 85 de 01 00 00    	jne    802787 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b1:	e9 9e 01 00 00       	jmp    802754 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025bf:	0f 82 87 01 00 00    	jb     80274c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ce:	0f 85 95 00 00 00    	jne    802669 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d8:	75 17                	jne    8025f1 <alloc_block_NF+0x5b>
  8025da:	83 ec 04             	sub    $0x4,%esp
  8025dd:	68 e0 3d 80 00       	push   $0x803de0
  8025e2:	68 e0 00 00 00       	push   $0xe0
  8025e7:	68 37 3d 80 00       	push   $0x803d37
  8025ec:	e8 be 0c 00 00       	call   8032af <_panic>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 00                	mov    (%eax),%eax
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	74 10                	je     80260a <alloc_block_NF+0x74>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802602:	8b 52 04             	mov    0x4(%edx),%edx
  802605:	89 50 04             	mov    %edx,0x4(%eax)
  802608:	eb 0b                	jmp    802615 <alloc_block_NF+0x7f>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 40 04             	mov    0x4(%eax),%eax
  802610:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	85 c0                	test   %eax,%eax
  80261d:	74 0f                	je     80262e <alloc_block_NF+0x98>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 40 04             	mov    0x4(%eax),%eax
  802625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802628:	8b 12                	mov    (%edx),%edx
  80262a:	89 10                	mov    %edx,(%eax)
  80262c:	eb 0a                	jmp    802638 <alloc_block_NF+0xa2>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	a3 38 41 80 00       	mov    %eax,0x804138
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264b:	a1 44 41 80 00       	mov    0x804144,%eax
  802650:	48                   	dec    %eax
  802651:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 40 08             	mov    0x8(%eax),%eax
  80265c:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	e9 f8 04 00 00       	jmp    802b61 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 0c             	mov    0xc(%eax),%eax
  80266f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802672:	0f 86 d4 00 00 00    	jbe    80274c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802678:	a1 48 41 80 00       	mov    0x804148,%eax
  80267d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 50 08             	mov    0x8(%eax),%edx
  802686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802689:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80268c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268f:	8b 55 08             	mov    0x8(%ebp),%edx
  802692:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802695:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802699:	75 17                	jne    8026b2 <alloc_block_NF+0x11c>
  80269b:	83 ec 04             	sub    $0x4,%esp
  80269e:	68 e0 3d 80 00       	push   $0x803de0
  8026a3:	68 e9 00 00 00       	push   $0xe9
  8026a8:	68 37 3d 80 00       	push   $0x803d37
  8026ad:	e8 fd 0b 00 00       	call   8032af <_panic>
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	85 c0                	test   %eax,%eax
  8026b9:	74 10                	je     8026cb <alloc_block_NF+0x135>
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	8b 00                	mov    (%eax),%eax
  8026c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c3:	8b 52 04             	mov    0x4(%edx),%edx
  8026c6:	89 50 04             	mov    %edx,0x4(%eax)
  8026c9:	eb 0b                	jmp    8026d6 <alloc_block_NF+0x140>
  8026cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ce:	8b 40 04             	mov    0x4(%eax),%eax
  8026d1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d9:	8b 40 04             	mov    0x4(%eax),%eax
  8026dc:	85 c0                	test   %eax,%eax
  8026de:	74 0f                	je     8026ef <alloc_block_NF+0x159>
  8026e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026e9:	8b 12                	mov    (%edx),%edx
  8026eb:	89 10                	mov    %edx,(%eax)
  8026ed:	eb 0a                	jmp    8026f9 <alloc_block_NF+0x163>
  8026ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f2:	8b 00                	mov    (%eax),%eax
  8026f4:	a3 48 41 80 00       	mov    %eax,0x804148
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802705:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270c:	a1 54 41 80 00       	mov    0x804154,%eax
  802711:	48                   	dec    %eax
  802712:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802717:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271a:	8b 40 08             	mov    0x8(%eax),%eax
  80271d:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 50 08             	mov    0x8(%eax),%edx
  802728:	8b 45 08             	mov    0x8(%ebp),%eax
  80272b:	01 c2                	add    %eax,%edx
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 0c             	mov    0xc(%eax),%eax
  802739:	2b 45 08             	sub    0x8(%ebp),%eax
  80273c:	89 c2                	mov    %eax,%edx
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802747:	e9 15 04 00 00       	jmp    802b61 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80274c:	a1 40 41 80 00       	mov    0x804140,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	74 07                	je     802761 <alloc_block_NF+0x1cb>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	eb 05                	jmp    802766 <alloc_block_NF+0x1d0>
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
  802766:	a3 40 41 80 00       	mov    %eax,0x804140
  80276b:	a1 40 41 80 00       	mov    0x804140,%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	0f 85 3e fe ff ff    	jne    8025b6 <alloc_block_NF+0x20>
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	0f 85 34 fe ff ff    	jne    8025b6 <alloc_block_NF+0x20>
  802782:	e9 d5 03 00 00       	jmp    802b5c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802787:	a1 38 41 80 00       	mov    0x804138,%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	e9 b1 01 00 00       	jmp    802945 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 50 08             	mov    0x8(%eax),%edx
  80279a:	a1 28 40 80 00       	mov    0x804028,%eax
  80279f:	39 c2                	cmp    %eax,%edx
  8027a1:	0f 82 96 01 00 00    	jb     80293d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b0:	0f 82 87 01 00 00    	jb     80293d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bf:	0f 85 95 00 00 00    	jne    80285a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	75 17                	jne    8027e2 <alloc_block_NF+0x24c>
  8027cb:	83 ec 04             	sub    $0x4,%esp
  8027ce:	68 e0 3d 80 00       	push   $0x803de0
  8027d3:	68 fc 00 00 00       	push   $0xfc
  8027d8:	68 37 3d 80 00       	push   $0x803d37
  8027dd:	e8 cd 0a 00 00       	call   8032af <_panic>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	74 10                	je     8027fb <alloc_block_NF+0x265>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f3:	8b 52 04             	mov    0x4(%edx),%edx
  8027f6:	89 50 04             	mov    %edx,0x4(%eax)
  8027f9:	eb 0b                	jmp    802806 <alloc_block_NF+0x270>
  8027fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fe:	8b 40 04             	mov    0x4(%eax),%eax
  802801:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 0f                	je     80281f <alloc_block_NF+0x289>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 04             	mov    0x4(%eax),%eax
  802816:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802819:	8b 12                	mov    (%edx),%edx
  80281b:	89 10                	mov    %edx,(%eax)
  80281d:	eb 0a                	jmp    802829 <alloc_block_NF+0x293>
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	a3 38 41 80 00       	mov    %eax,0x804138
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283c:	a1 44 41 80 00       	mov    0x804144,%eax
  802841:	48                   	dec    %eax
  802842:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 08             	mov    0x8(%eax),%eax
  80284d:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	e9 07 03 00 00       	jmp    802b61 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 0c             	mov    0xc(%eax),%eax
  802860:	3b 45 08             	cmp    0x8(%ebp),%eax
  802863:	0f 86 d4 00 00 00    	jbe    80293d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802869:	a1 48 41 80 00       	mov    0x804148,%eax
  80286e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 50 08             	mov    0x8(%eax),%edx
  802877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80287d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802880:	8b 55 08             	mov    0x8(%ebp),%edx
  802883:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802886:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80288a:	75 17                	jne    8028a3 <alloc_block_NF+0x30d>
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	68 e0 3d 80 00       	push   $0x803de0
  802894:	68 04 01 00 00       	push   $0x104
  802899:	68 37 3d 80 00       	push   $0x803d37
  80289e:	e8 0c 0a 00 00       	call   8032af <_panic>
  8028a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 10                	je     8028bc <alloc_block_NF+0x326>
  8028ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028b4:	8b 52 04             	mov    0x4(%edx),%edx
  8028b7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ba:	eb 0b                	jmp    8028c7 <alloc_block_NF+0x331>
  8028bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 0f                	je     8028e0 <alloc_block_NF+0x34a>
  8028d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028da:	8b 12                	mov    (%edx),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 0a                	jmp    8028ea <alloc_block_NF+0x354>
  8028e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802902:	48                   	dec    %eax
  802903:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290b:	8b 40 08             	mov    0x8(%eax),%eax
  80290e:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 50 08             	mov    0x8(%eax),%edx
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	01 c2                	add    %eax,%edx
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	2b 45 08             	sub    0x8(%ebp),%eax
  80292d:	89 c2                	mov    %eax,%edx
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802938:	e9 24 02 00 00       	jmp    802b61 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80293d:	a1 40 41 80 00       	mov    0x804140,%eax
  802942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802949:	74 07                	je     802952 <alloc_block_NF+0x3bc>
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	8b 00                	mov    (%eax),%eax
  802950:	eb 05                	jmp    802957 <alloc_block_NF+0x3c1>
  802952:	b8 00 00 00 00       	mov    $0x0,%eax
  802957:	a3 40 41 80 00       	mov    %eax,0x804140
  80295c:	a1 40 41 80 00       	mov    0x804140,%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	0f 85 2b fe ff ff    	jne    802794 <alloc_block_NF+0x1fe>
  802969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296d:	0f 85 21 fe ff ff    	jne    802794 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802973:	a1 38 41 80 00       	mov    0x804138,%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297b:	e9 ae 01 00 00       	jmp    802b2e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 50 08             	mov    0x8(%eax),%edx
  802986:	a1 28 40 80 00       	mov    0x804028,%eax
  80298b:	39 c2                	cmp    %eax,%edx
  80298d:	0f 83 93 01 00 00    	jae    802b26 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299c:	0f 82 84 01 00 00    	jb     802b26 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ab:	0f 85 95 00 00 00    	jne    802a46 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b5:	75 17                	jne    8029ce <alloc_block_NF+0x438>
  8029b7:	83 ec 04             	sub    $0x4,%esp
  8029ba:	68 e0 3d 80 00       	push   $0x803de0
  8029bf:	68 14 01 00 00       	push   $0x114
  8029c4:	68 37 3d 80 00       	push   $0x803d37
  8029c9:	e8 e1 08 00 00       	call   8032af <_panic>
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 00                	mov    (%eax),%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	74 10                	je     8029e7 <alloc_block_NF+0x451>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029df:	8b 52 04             	mov    0x4(%edx),%edx
  8029e2:	89 50 04             	mov    %edx,0x4(%eax)
  8029e5:	eb 0b                	jmp    8029f2 <alloc_block_NF+0x45c>
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 40 04             	mov    0x4(%eax),%eax
  8029ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	74 0f                	je     802a0b <alloc_block_NF+0x475>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a05:	8b 12                	mov    (%edx),%edx
  802a07:	89 10                	mov    %edx,(%eax)
  802a09:	eb 0a                	jmp    802a15 <alloc_block_NF+0x47f>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	a3 38 41 80 00       	mov    %eax,0x804138
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a28:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2d:	48                   	dec    %eax
  802a2e:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 40 08             	mov    0x8(%eax),%eax
  802a39:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	e9 1b 01 00 00       	jmp    802b61 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4f:	0f 86 d1 00 00 00    	jbe    802b26 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a55:	a1 48 41 80 00       	mov    0x804148,%eax
  802a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	8b 50 08             	mov    0x8(%eax),%edx
  802a63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a66:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a76:	75 17                	jne    802a8f <alloc_block_NF+0x4f9>
  802a78:	83 ec 04             	sub    $0x4,%esp
  802a7b:	68 e0 3d 80 00       	push   $0x803de0
  802a80:	68 1c 01 00 00       	push   $0x11c
  802a85:	68 37 3d 80 00       	push   $0x803d37
  802a8a:	e8 20 08 00 00       	call   8032af <_panic>
  802a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 10                	je     802aa8 <alloc_block_NF+0x512>
  802a98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9b:	8b 00                	mov    (%eax),%eax
  802a9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa0:	8b 52 04             	mov    0x4(%edx),%edx
  802aa3:	89 50 04             	mov    %edx,0x4(%eax)
  802aa6:	eb 0b                	jmp    802ab3 <alloc_block_NF+0x51d>
  802aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ab3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	85 c0                	test   %eax,%eax
  802abb:	74 0f                	je     802acc <alloc_block_NF+0x536>
  802abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac0:	8b 40 04             	mov    0x4(%eax),%eax
  802ac3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ac6:	8b 12                	mov    (%edx),%edx
  802ac8:	89 10                	mov    %edx,(%eax)
  802aca:	eb 0a                	jmp    802ad6 <alloc_block_NF+0x540>
  802acc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802adf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae9:	a1 54 41 80 00       	mov    0x804154,%eax
  802aee:	48                   	dec    %eax
  802aef:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af7:	8b 40 08             	mov    0x8(%eax),%eax
  802afa:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 50 08             	mov    0x8(%eax),%edx
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	01 c2                	add    %eax,%edx
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 40 0c             	mov    0xc(%eax),%eax
  802b16:	2b 45 08             	sub    0x8(%ebp),%eax
  802b19:	89 c2                	mov    %eax,%edx
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b24:	eb 3b                	jmp    802b61 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b26:	a1 40 41 80 00       	mov    0x804140,%eax
  802b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b32:	74 07                	je     802b3b <alloc_block_NF+0x5a5>
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	eb 05                	jmp    802b40 <alloc_block_NF+0x5aa>
  802b3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b40:	a3 40 41 80 00       	mov    %eax,0x804140
  802b45:	a1 40 41 80 00       	mov    0x804140,%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	0f 85 2e fe ff ff    	jne    802980 <alloc_block_NF+0x3ea>
  802b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b56:	0f 85 24 fe ff ff    	jne    802980 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b61:	c9                   	leave  
  802b62:	c3                   	ret    

00802b63 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
  802b66:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b69:	a1 38 41 80 00       	mov    0x804138,%eax
  802b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b71:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b76:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b79:	a1 38 41 80 00       	mov    0x804138,%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 14                	je     802b96 <insert_sorted_with_merge_freeList+0x33>
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	8b 50 08             	mov    0x8(%eax),%edx
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	8b 40 08             	mov    0x8(%eax),%eax
  802b8e:	39 c2                	cmp    %eax,%edx
  802b90:	0f 87 9b 01 00 00    	ja     802d31 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9a:	75 17                	jne    802bb3 <insert_sorted_with_merge_freeList+0x50>
  802b9c:	83 ec 04             	sub    $0x4,%esp
  802b9f:	68 14 3d 80 00       	push   $0x803d14
  802ba4:	68 38 01 00 00       	push   $0x138
  802ba9:	68 37 3d 80 00       	push   $0x803d37
  802bae:	e8 fc 06 00 00       	call   8032af <_panic>
  802bb3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	89 10                	mov    %edx,(%eax)
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	8b 00                	mov    (%eax),%eax
  802bc3:	85 c0                	test   %eax,%eax
  802bc5:	74 0d                	je     802bd4 <insert_sorted_with_merge_freeList+0x71>
  802bc7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcf:	89 50 04             	mov    %edx,0x4(%eax)
  802bd2:	eb 08                	jmp    802bdc <insert_sorted_with_merge_freeList+0x79>
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	a3 38 41 80 00       	mov    %eax,0x804138
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bee:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf3:	40                   	inc    %eax
  802bf4:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bfd:	0f 84 a8 06 00 00    	je     8032ab <insert_sorted_with_merge_freeList+0x748>
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	8b 50 08             	mov    0x8(%eax),%edx
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0f:	01 c2                	add    %eax,%edx
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 40 08             	mov    0x8(%eax),%eax
  802c17:	39 c2                	cmp    %eax,%edx
  802c19:	0f 85 8c 06 00 00    	jne    8032ab <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 50 0c             	mov    0xc(%eax),%edx
  802c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c28:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2b:	01 c2                	add    %eax,%edx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c37:	75 17                	jne    802c50 <insert_sorted_with_merge_freeList+0xed>
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	68 e0 3d 80 00       	push   $0x803de0
  802c41:	68 3c 01 00 00       	push   $0x13c
  802c46:	68 37 3d 80 00       	push   $0x803d37
  802c4b:	e8 5f 06 00 00       	call   8032af <_panic>
  802c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 10                	je     802c69 <insert_sorted_with_merge_freeList+0x106>
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c61:	8b 52 04             	mov    0x4(%edx),%edx
  802c64:	89 50 04             	mov    %edx,0x4(%eax)
  802c67:	eb 0b                	jmp    802c74 <insert_sorted_with_merge_freeList+0x111>
  802c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 0f                	je     802c8d <insert_sorted_with_merge_freeList+0x12a>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c87:	8b 12                	mov    (%edx),%edx
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	eb 0a                	jmp    802c97 <insert_sorted_with_merge_freeList+0x134>
  802c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	a3 38 41 80 00       	mov    %eax,0x804138
  802c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802caa:	a1 44 41 80 00       	mov    0x804144,%eax
  802caf:	48                   	dec    %eax
  802cb0:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccd:	75 17                	jne    802ce6 <insert_sorted_with_merge_freeList+0x183>
  802ccf:	83 ec 04             	sub    $0x4,%esp
  802cd2:	68 14 3d 80 00       	push   $0x803d14
  802cd7:	68 3f 01 00 00       	push   $0x13f
  802cdc:	68 37 3d 80 00       	push   $0x803d37
  802ce1:	e8 c9 05 00 00       	call   8032af <_panic>
  802ce6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf4:	8b 00                	mov    (%eax),%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	74 0d                	je     802d07 <insert_sorted_with_merge_freeList+0x1a4>
  802cfa:	a1 48 41 80 00       	mov    0x804148,%eax
  802cff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d02:	89 50 04             	mov    %edx,0x4(%eax)
  802d05:	eb 08                	jmp    802d0f <insert_sorted_with_merge_freeList+0x1ac>
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d12:	a3 48 41 80 00       	mov    %eax,0x804148
  802d17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d21:	a1 54 41 80 00       	mov    0x804154,%eax
  802d26:	40                   	inc    %eax
  802d27:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d2c:	e9 7a 05 00 00       	jmp    8032ab <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 50 08             	mov    0x8(%eax),%edx
  802d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3a:	8b 40 08             	mov    0x8(%eax),%eax
  802d3d:	39 c2                	cmp    %eax,%edx
  802d3f:	0f 82 14 01 00 00    	jb     802e59 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	01 c2                	add    %eax,%edx
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 40 08             	mov    0x8(%eax),%eax
  802d59:	39 c2                	cmp    %eax,%edx
  802d5b:	0f 85 90 00 00 00    	jne    802df1 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d64:	8b 50 0c             	mov    0xc(%eax),%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d6d:	01 c2                	add    %eax,%edx
  802d6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d72:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d8d:	75 17                	jne    802da6 <insert_sorted_with_merge_freeList+0x243>
  802d8f:	83 ec 04             	sub    $0x4,%esp
  802d92:	68 14 3d 80 00       	push   $0x803d14
  802d97:	68 49 01 00 00       	push   $0x149
  802d9c:	68 37 3d 80 00       	push   $0x803d37
  802da1:	e8 09 05 00 00       	call   8032af <_panic>
  802da6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	8b 00                	mov    (%eax),%eax
  802db6:	85 c0                	test   %eax,%eax
  802db8:	74 0d                	je     802dc7 <insert_sorted_with_merge_freeList+0x264>
  802dba:	a1 48 41 80 00       	mov    0x804148,%eax
  802dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc2:	89 50 04             	mov    %edx,0x4(%eax)
  802dc5:	eb 08                	jmp    802dcf <insert_sorted_with_merge_freeList+0x26c>
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	a3 48 41 80 00       	mov    %eax,0x804148
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de1:	a1 54 41 80 00       	mov    0x804154,%eax
  802de6:	40                   	inc    %eax
  802de7:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dec:	e9 bb 04 00 00       	jmp    8032ac <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df5:	75 17                	jne    802e0e <insert_sorted_with_merge_freeList+0x2ab>
  802df7:	83 ec 04             	sub    $0x4,%esp
  802dfa:	68 88 3d 80 00       	push   $0x803d88
  802dff:	68 4c 01 00 00       	push   $0x14c
  802e04:	68 37 3d 80 00       	push   $0x803d37
  802e09:	e8 a1 04 00 00       	call   8032af <_panic>
  802e0e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	89 50 04             	mov    %edx,0x4(%eax)
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 40 04             	mov    0x4(%eax),%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	74 0c                	je     802e30 <insert_sorted_with_merge_freeList+0x2cd>
  802e24:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e29:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2c:	89 10                	mov    %edx,(%eax)
  802e2e:	eb 08                	jmp    802e38 <insert_sorted_with_merge_freeList+0x2d5>
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	a3 38 41 80 00       	mov    %eax,0x804138
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e49:	a1 44 41 80 00       	mov    0x804144,%eax
  802e4e:	40                   	inc    %eax
  802e4f:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e54:	e9 53 04 00 00       	jmp    8032ac <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e59:	a1 38 41 80 00       	mov    0x804138,%eax
  802e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e61:	e9 15 04 00 00       	jmp    80327b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 50 08             	mov    0x8(%eax),%edx
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 08             	mov    0x8(%eax),%eax
  802e7a:	39 c2                	cmp    %eax,%edx
  802e7c:	0f 86 f1 03 00 00    	jbe    803273 <insert_sorted_with_merge_freeList+0x710>
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	8b 50 08             	mov    0x8(%eax),%edx
  802e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8b:	8b 40 08             	mov    0x8(%eax),%eax
  802e8e:	39 c2                	cmp    %eax,%edx
  802e90:	0f 83 dd 03 00 00    	jae    803273 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 50 08             	mov    0x8(%eax),%edx
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea2:	01 c2                	add    %eax,%edx
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 40 08             	mov    0x8(%eax),%eax
  802eaa:	39 c2                	cmp    %eax,%edx
  802eac:	0f 85 b9 01 00 00    	jne    80306b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	8b 50 08             	mov    0x8(%eax),%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	01 c2                	add    %eax,%edx
  802ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	39 c2                	cmp    %eax,%edx
  802ec8:	0f 85 0d 01 00 00    	jne    802fdb <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eda:	01 c2                	add    %eax,%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ee2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ee6:	75 17                	jne    802eff <insert_sorted_with_merge_freeList+0x39c>
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	68 e0 3d 80 00       	push   $0x803de0
  802ef0:	68 5c 01 00 00       	push   $0x15c
  802ef5:	68 37 3d 80 00       	push   $0x803d37
  802efa:	e8 b0 03 00 00       	call   8032af <_panic>
  802eff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 10                	je     802f18 <insert_sorted_with_merge_freeList+0x3b5>
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	8b 00                	mov    (%eax),%eax
  802f0d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f10:	8b 52 04             	mov    0x4(%edx),%edx
  802f13:	89 50 04             	mov    %edx,0x4(%eax)
  802f16:	eb 0b                	jmp    802f23 <insert_sorted_with_merge_freeList+0x3c0>
  802f18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0f                	je     802f3c <insert_sorted_with_merge_freeList+0x3d9>
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f36:	8b 12                	mov    (%edx),%edx
  802f38:	89 10                	mov    %edx,(%eax)
  802f3a:	eb 0a                	jmp    802f46 <insert_sorted_with_merge_freeList+0x3e3>
  802f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3f:	8b 00                	mov    (%eax),%eax
  802f41:	a3 38 41 80 00       	mov    %eax,0x804138
  802f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f59:	a1 44 41 80 00       	mov    0x804144,%eax
  802f5e:	48                   	dec    %eax
  802f5f:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7c:	75 17                	jne    802f95 <insert_sorted_with_merge_freeList+0x432>
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 14 3d 80 00       	push   $0x803d14
  802f86:	68 5f 01 00 00       	push   $0x15f
  802f8b:	68 37 3d 80 00       	push   $0x803d37
  802f90:	e8 1a 03 00 00       	call   8032af <_panic>
  802f95:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 0d                	je     802fb6 <insert_sorted_with_merge_freeList+0x453>
  802fa9:	a1 48 41 80 00       	mov    0x804148,%eax
  802fae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	eb 08                	jmp    802fbe <insert_sorted_with_merge_freeList+0x45b>
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc1:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd0:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd5:	40                   	inc    %eax
  802fd6:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe7:	01 c2                	add    %eax,%edx
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803003:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803007:	75 17                	jne    803020 <insert_sorted_with_merge_freeList+0x4bd>
  803009:	83 ec 04             	sub    $0x4,%esp
  80300c:	68 14 3d 80 00       	push   $0x803d14
  803011:	68 64 01 00 00       	push   $0x164
  803016:	68 37 3d 80 00       	push   $0x803d37
  80301b:	e8 8f 02 00 00       	call   8032af <_panic>
  803020:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	89 10                	mov    %edx,(%eax)
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0d                	je     803041 <insert_sorted_with_merge_freeList+0x4de>
  803034:	a1 48 41 80 00       	mov    0x804148,%eax
  803039:	8b 55 08             	mov    0x8(%ebp),%edx
  80303c:	89 50 04             	mov    %edx,0x4(%eax)
  80303f:	eb 08                	jmp    803049 <insert_sorted_with_merge_freeList+0x4e6>
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	a3 48 41 80 00       	mov    %eax,0x804148
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305b:	a1 54 41 80 00       	mov    0x804154,%eax
  803060:	40                   	inc    %eax
  803061:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803066:	e9 41 02 00 00       	jmp    8032ac <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 50 08             	mov    0x8(%eax),%edx
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	8b 40 0c             	mov    0xc(%eax),%eax
  803077:	01 c2                	add    %eax,%edx
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	8b 40 08             	mov    0x8(%eax),%eax
  80307f:	39 c2                	cmp    %eax,%edx
  803081:	0f 85 7c 01 00 00    	jne    803203 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803087:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308b:	74 06                	je     803093 <insert_sorted_with_merge_freeList+0x530>
  80308d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803091:	75 17                	jne    8030aa <insert_sorted_with_merge_freeList+0x547>
  803093:	83 ec 04             	sub    $0x4,%esp
  803096:	68 50 3d 80 00       	push   $0x803d50
  80309b:	68 69 01 00 00       	push   $0x169
  8030a0:	68 37 3d 80 00       	push   $0x803d37
  8030a5:	e8 05 02 00 00       	call   8032af <_panic>
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	8b 50 04             	mov    0x4(%eax),%edx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	89 50 04             	mov    %edx,0x4(%eax)
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	85 c0                	test   %eax,%eax
  8030c6:	74 0d                	je     8030d5 <insert_sorted_with_merge_freeList+0x572>
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	eb 08                	jmp    8030dd <insert_sorted_with_merge_freeList+0x57a>
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e3:	89 50 04             	mov    %edx,0x4(%eax)
  8030e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8030eb:	40                   	inc    %eax
  8030ec:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fd:	01 c2                	add    %eax,%edx
  8030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803102:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803105:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803109:	75 17                	jne    803122 <insert_sorted_with_merge_freeList+0x5bf>
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	68 e0 3d 80 00       	push   $0x803de0
  803113:	68 6b 01 00 00       	push   $0x16b
  803118:	68 37 3d 80 00       	push   $0x803d37
  80311d:	e8 8d 01 00 00       	call   8032af <_panic>
  803122:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803125:	8b 00                	mov    (%eax),%eax
  803127:	85 c0                	test   %eax,%eax
  803129:	74 10                	je     80313b <insert_sorted_with_merge_freeList+0x5d8>
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 00                	mov    (%eax),%eax
  803130:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803133:	8b 52 04             	mov    0x4(%edx),%edx
  803136:	89 50 04             	mov    %edx,0x4(%eax)
  803139:	eb 0b                	jmp    803146 <insert_sorted_with_merge_freeList+0x5e3>
  80313b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313e:	8b 40 04             	mov    0x4(%eax),%eax
  803141:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803146:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803149:	8b 40 04             	mov    0x4(%eax),%eax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	74 0f                	je     80315f <insert_sorted_with_merge_freeList+0x5fc>
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	8b 40 04             	mov    0x4(%eax),%eax
  803156:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803159:	8b 12                	mov    (%edx),%edx
  80315b:	89 10                	mov    %edx,(%eax)
  80315d:	eb 0a                	jmp    803169 <insert_sorted_with_merge_freeList+0x606>
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	a3 38 41 80 00       	mov    %eax,0x804138
  803169:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80317c:	a1 44 41 80 00       	mov    0x804144,%eax
  803181:	48                   	dec    %eax
  803182:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80319b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319f:	75 17                	jne    8031b8 <insert_sorted_with_merge_freeList+0x655>
  8031a1:	83 ec 04             	sub    $0x4,%esp
  8031a4:	68 14 3d 80 00       	push   $0x803d14
  8031a9:	68 6e 01 00 00       	push   $0x16e
  8031ae:	68 37 3d 80 00       	push   $0x803d37
  8031b3:	e8 f7 00 00 00       	call   8032af <_panic>
  8031b8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c1:	89 10                	mov    %edx,(%eax)
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	8b 00                	mov    (%eax),%eax
  8031c8:	85 c0                	test   %eax,%eax
  8031ca:	74 0d                	je     8031d9 <insert_sorted_with_merge_freeList+0x676>
  8031cc:	a1 48 41 80 00       	mov    0x804148,%eax
  8031d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d4:	89 50 04             	mov    %edx,0x4(%eax)
  8031d7:	eb 08                	jmp    8031e1 <insert_sorted_with_merge_freeList+0x67e>
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e4:	a3 48 41 80 00       	mov    %eax,0x804148
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f3:	a1 54 41 80 00       	mov    0x804154,%eax
  8031f8:	40                   	inc    %eax
  8031f9:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031fe:	e9 a9 00 00 00       	jmp    8032ac <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803207:	74 06                	je     80320f <insert_sorted_with_merge_freeList+0x6ac>
  803209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320d:	75 17                	jne    803226 <insert_sorted_with_merge_freeList+0x6c3>
  80320f:	83 ec 04             	sub    $0x4,%esp
  803212:	68 ac 3d 80 00       	push   $0x803dac
  803217:	68 73 01 00 00       	push   $0x173
  80321c:	68 37 3d 80 00       	push   $0x803d37
  803221:	e8 89 00 00 00       	call   8032af <_panic>
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	8b 10                	mov    (%eax),%edx
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	89 10                	mov    %edx,(%eax)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 0b                	je     803244 <insert_sorted_with_merge_freeList+0x6e1>
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	8b 55 08             	mov    0x8(%ebp),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803247:	8b 55 08             	mov    0x8(%ebp),%edx
  80324a:	89 10                	mov    %edx,(%eax)
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803252:	89 50 04             	mov    %edx,0x4(%eax)
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8b 00                	mov    (%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	75 08                	jne    803266 <insert_sorted_with_merge_freeList+0x703>
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803266:	a1 44 41 80 00       	mov    0x804144,%eax
  80326b:	40                   	inc    %eax
  80326c:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803271:	eb 39                	jmp    8032ac <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803273:	a1 40 41 80 00       	mov    0x804140,%eax
  803278:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80327b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327f:	74 07                	je     803288 <insert_sorted_with_merge_freeList+0x725>
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	eb 05                	jmp    80328d <insert_sorted_with_merge_freeList+0x72a>
  803288:	b8 00 00 00 00       	mov    $0x0,%eax
  80328d:	a3 40 41 80 00       	mov    %eax,0x804140
  803292:	a1 40 41 80 00       	mov    0x804140,%eax
  803297:	85 c0                	test   %eax,%eax
  803299:	0f 85 c7 fb ff ff    	jne    802e66 <insert_sorted_with_merge_freeList+0x303>
  80329f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a3:	0f 85 bd fb ff ff    	jne    802e66 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032a9:	eb 01                	jmp    8032ac <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032ab:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032ac:	90                   	nop
  8032ad:	c9                   	leave  
  8032ae:	c3                   	ret    

008032af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8032af:	55                   	push   %ebp
  8032b0:	89 e5                	mov    %esp,%ebp
  8032b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8032b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8032b8:	83 c0 04             	add    $0x4,%eax
  8032bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8032be:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8032c3:	85 c0                	test   %eax,%eax
  8032c5:	74 16                	je     8032dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8032c7:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8032cc:	83 ec 08             	sub    $0x8,%esp
  8032cf:	50                   	push   %eax
  8032d0:	68 00 3e 80 00       	push   $0x803e00
  8032d5:	e8 6e d0 ff ff       	call   800348 <cprintf>
  8032da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8032dd:	a1 00 40 80 00       	mov    0x804000,%eax
  8032e2:	ff 75 0c             	pushl  0xc(%ebp)
  8032e5:	ff 75 08             	pushl  0x8(%ebp)
  8032e8:	50                   	push   %eax
  8032e9:	68 05 3e 80 00       	push   $0x803e05
  8032ee:	e8 55 d0 ff ff       	call   800348 <cprintf>
  8032f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8032f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8032f9:	83 ec 08             	sub    $0x8,%esp
  8032fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ff:	50                   	push   %eax
  803300:	e8 d8 cf ff ff       	call   8002dd <vcprintf>
  803305:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803308:	83 ec 08             	sub    $0x8,%esp
  80330b:	6a 00                	push   $0x0
  80330d:	68 21 3e 80 00       	push   $0x803e21
  803312:	e8 c6 cf ff ff       	call   8002dd <vcprintf>
  803317:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80331a:	e8 47 cf ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  80331f:	eb fe                	jmp    80331f <_panic+0x70>

00803321 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803321:	55                   	push   %ebp
  803322:	89 e5                	mov    %esp,%ebp
  803324:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803327:	a1 20 40 80 00       	mov    0x804020,%eax
  80332c:	8b 50 74             	mov    0x74(%eax),%edx
  80332f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803332:	39 c2                	cmp    %eax,%edx
  803334:	74 14                	je     80334a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803336:	83 ec 04             	sub    $0x4,%esp
  803339:	68 24 3e 80 00       	push   $0x803e24
  80333e:	6a 26                	push   $0x26
  803340:	68 70 3e 80 00       	push   $0x803e70
  803345:	e8 65 ff ff ff       	call   8032af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80334a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803358:	e9 c2 00 00 00       	jmp    80341f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80335d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803360:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	01 d0                	add    %edx,%eax
  80336c:	8b 00                	mov    (%eax),%eax
  80336e:	85 c0                	test   %eax,%eax
  803370:	75 08                	jne    80337a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803372:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803375:	e9 a2 00 00 00       	jmp    80341c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80337a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803381:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803388:	eb 69                	jmp    8033f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80338a:	a1 20 40 80 00       	mov    0x804020,%eax
  80338f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803395:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803398:	89 d0                	mov    %edx,%eax
  80339a:	01 c0                	add    %eax,%eax
  80339c:	01 d0                	add    %edx,%eax
  80339e:	c1 e0 03             	shl    $0x3,%eax
  8033a1:	01 c8                	add    %ecx,%eax
  8033a3:	8a 40 04             	mov    0x4(%eax),%al
  8033a6:	84 c0                	test   %al,%al
  8033a8:	75 46                	jne    8033f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8033aa:	a1 20 40 80 00       	mov    0x804020,%eax
  8033af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b8:	89 d0                	mov    %edx,%eax
  8033ba:	01 c0                	add    %eax,%eax
  8033bc:	01 d0                	add    %edx,%eax
  8033be:	c1 e0 03             	shl    $0x3,%eax
  8033c1:	01 c8                	add    %ecx,%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8033c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8033d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8033d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	01 c8                	add    %ecx,%eax
  8033e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8033e3:	39 c2                	cmp    %eax,%edx
  8033e5:	75 09                	jne    8033f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8033e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8033ee:	eb 12                	jmp    803402 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033f0:	ff 45 e8             	incl   -0x18(%ebp)
  8033f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8033f8:	8b 50 74             	mov    0x74(%eax),%edx
  8033fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fe:	39 c2                	cmp    %eax,%edx
  803400:	77 88                	ja     80338a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803402:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803406:	75 14                	jne    80341c <CheckWSWithoutLastIndex+0xfb>
			panic(
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 7c 3e 80 00       	push   $0x803e7c
  803410:	6a 3a                	push   $0x3a
  803412:	68 70 3e 80 00       	push   $0x803e70
  803417:	e8 93 fe ff ff       	call   8032af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80341c:	ff 45 f0             	incl   -0x10(%ebp)
  80341f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803422:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803425:	0f 8c 32 ff ff ff    	jl     80335d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80342b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803432:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803439:	eb 26                	jmp    803461 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80343b:	a1 20 40 80 00       	mov    0x804020,%eax
  803440:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803446:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803449:	89 d0                	mov    %edx,%eax
  80344b:	01 c0                	add    %eax,%eax
  80344d:	01 d0                	add    %edx,%eax
  80344f:	c1 e0 03             	shl    $0x3,%eax
  803452:	01 c8                	add    %ecx,%eax
  803454:	8a 40 04             	mov    0x4(%eax),%al
  803457:	3c 01                	cmp    $0x1,%al
  803459:	75 03                	jne    80345e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80345b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80345e:	ff 45 e0             	incl   -0x20(%ebp)
  803461:	a1 20 40 80 00       	mov    0x804020,%eax
  803466:	8b 50 74             	mov    0x74(%eax),%edx
  803469:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346c:	39 c2                	cmp    %eax,%edx
  80346e:	77 cb                	ja     80343b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803473:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803476:	74 14                	je     80348c <CheckWSWithoutLastIndex+0x16b>
		panic(
  803478:	83 ec 04             	sub    $0x4,%esp
  80347b:	68 d0 3e 80 00       	push   $0x803ed0
  803480:	6a 44                	push   $0x44
  803482:	68 70 3e 80 00       	push   $0x803e70
  803487:	e8 23 fe ff ff       	call   8032af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80348c:	90                   	nop
  80348d:	c9                   	leave  
  80348e:	c3                   	ret    
  80348f:	90                   	nop

00803490 <__udivdi3>:
  803490:	55                   	push   %ebp
  803491:	57                   	push   %edi
  803492:	56                   	push   %esi
  803493:	53                   	push   %ebx
  803494:	83 ec 1c             	sub    $0x1c,%esp
  803497:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80349b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80349f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a7:	89 ca                	mov    %ecx,%edx
  8034a9:	89 f8                	mov    %edi,%eax
  8034ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034af:	85 f6                	test   %esi,%esi
  8034b1:	75 2d                	jne    8034e0 <__udivdi3+0x50>
  8034b3:	39 cf                	cmp    %ecx,%edi
  8034b5:	77 65                	ja     80351c <__udivdi3+0x8c>
  8034b7:	89 fd                	mov    %edi,%ebp
  8034b9:	85 ff                	test   %edi,%edi
  8034bb:	75 0b                	jne    8034c8 <__udivdi3+0x38>
  8034bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c2:	31 d2                	xor    %edx,%edx
  8034c4:	f7 f7                	div    %edi
  8034c6:	89 c5                	mov    %eax,%ebp
  8034c8:	31 d2                	xor    %edx,%edx
  8034ca:	89 c8                	mov    %ecx,%eax
  8034cc:	f7 f5                	div    %ebp
  8034ce:	89 c1                	mov    %eax,%ecx
  8034d0:	89 d8                	mov    %ebx,%eax
  8034d2:	f7 f5                	div    %ebp
  8034d4:	89 cf                	mov    %ecx,%edi
  8034d6:	89 fa                	mov    %edi,%edx
  8034d8:	83 c4 1c             	add    $0x1c,%esp
  8034db:	5b                   	pop    %ebx
  8034dc:	5e                   	pop    %esi
  8034dd:	5f                   	pop    %edi
  8034de:	5d                   	pop    %ebp
  8034df:	c3                   	ret    
  8034e0:	39 ce                	cmp    %ecx,%esi
  8034e2:	77 28                	ja     80350c <__udivdi3+0x7c>
  8034e4:	0f bd fe             	bsr    %esi,%edi
  8034e7:	83 f7 1f             	xor    $0x1f,%edi
  8034ea:	75 40                	jne    80352c <__udivdi3+0x9c>
  8034ec:	39 ce                	cmp    %ecx,%esi
  8034ee:	72 0a                	jb     8034fa <__udivdi3+0x6a>
  8034f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034f4:	0f 87 9e 00 00 00    	ja     803598 <__udivdi3+0x108>
  8034fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ff:	89 fa                	mov    %edi,%edx
  803501:	83 c4 1c             	add    $0x1c,%esp
  803504:	5b                   	pop    %ebx
  803505:	5e                   	pop    %esi
  803506:	5f                   	pop    %edi
  803507:	5d                   	pop    %ebp
  803508:	c3                   	ret    
  803509:	8d 76 00             	lea    0x0(%esi),%esi
  80350c:	31 ff                	xor    %edi,%edi
  80350e:	31 c0                	xor    %eax,%eax
  803510:	89 fa                	mov    %edi,%edx
  803512:	83 c4 1c             	add    $0x1c,%esp
  803515:	5b                   	pop    %ebx
  803516:	5e                   	pop    %esi
  803517:	5f                   	pop    %edi
  803518:	5d                   	pop    %ebp
  803519:	c3                   	ret    
  80351a:	66 90                	xchg   %ax,%ax
  80351c:	89 d8                	mov    %ebx,%eax
  80351e:	f7 f7                	div    %edi
  803520:	31 ff                	xor    %edi,%edi
  803522:	89 fa                	mov    %edi,%edx
  803524:	83 c4 1c             	add    $0x1c,%esp
  803527:	5b                   	pop    %ebx
  803528:	5e                   	pop    %esi
  803529:	5f                   	pop    %edi
  80352a:	5d                   	pop    %ebp
  80352b:	c3                   	ret    
  80352c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803531:	89 eb                	mov    %ebp,%ebx
  803533:	29 fb                	sub    %edi,%ebx
  803535:	89 f9                	mov    %edi,%ecx
  803537:	d3 e6                	shl    %cl,%esi
  803539:	89 c5                	mov    %eax,%ebp
  80353b:	88 d9                	mov    %bl,%cl
  80353d:	d3 ed                	shr    %cl,%ebp
  80353f:	89 e9                	mov    %ebp,%ecx
  803541:	09 f1                	or     %esi,%ecx
  803543:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803547:	89 f9                	mov    %edi,%ecx
  803549:	d3 e0                	shl    %cl,%eax
  80354b:	89 c5                	mov    %eax,%ebp
  80354d:	89 d6                	mov    %edx,%esi
  80354f:	88 d9                	mov    %bl,%cl
  803551:	d3 ee                	shr    %cl,%esi
  803553:	89 f9                	mov    %edi,%ecx
  803555:	d3 e2                	shl    %cl,%edx
  803557:	8b 44 24 08          	mov    0x8(%esp),%eax
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 e8                	shr    %cl,%eax
  80355f:	09 c2                	or     %eax,%edx
  803561:	89 d0                	mov    %edx,%eax
  803563:	89 f2                	mov    %esi,%edx
  803565:	f7 74 24 0c          	divl   0xc(%esp)
  803569:	89 d6                	mov    %edx,%esi
  80356b:	89 c3                	mov    %eax,%ebx
  80356d:	f7 e5                	mul    %ebp
  80356f:	39 d6                	cmp    %edx,%esi
  803571:	72 19                	jb     80358c <__udivdi3+0xfc>
  803573:	74 0b                	je     803580 <__udivdi3+0xf0>
  803575:	89 d8                	mov    %ebx,%eax
  803577:	31 ff                	xor    %edi,%edi
  803579:	e9 58 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	8b 54 24 08          	mov    0x8(%esp),%edx
  803584:	89 f9                	mov    %edi,%ecx
  803586:	d3 e2                	shl    %cl,%edx
  803588:	39 c2                	cmp    %eax,%edx
  80358a:	73 e9                	jae    803575 <__udivdi3+0xe5>
  80358c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80358f:	31 ff                	xor    %edi,%edi
  803591:	e9 40 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  803596:	66 90                	xchg   %ax,%ax
  803598:	31 c0                	xor    %eax,%eax
  80359a:	e9 37 ff ff ff       	jmp    8034d6 <__udivdi3+0x46>
  80359f:	90                   	nop

008035a0 <__umoddi3>:
  8035a0:	55                   	push   %ebp
  8035a1:	57                   	push   %edi
  8035a2:	56                   	push   %esi
  8035a3:	53                   	push   %ebx
  8035a4:	83 ec 1c             	sub    $0x1c,%esp
  8035a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035bf:	89 f3                	mov    %esi,%ebx
  8035c1:	89 fa                	mov    %edi,%edx
  8035c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035c7:	89 34 24             	mov    %esi,(%esp)
  8035ca:	85 c0                	test   %eax,%eax
  8035cc:	75 1a                	jne    8035e8 <__umoddi3+0x48>
  8035ce:	39 f7                	cmp    %esi,%edi
  8035d0:	0f 86 a2 00 00 00    	jbe    803678 <__umoddi3+0xd8>
  8035d6:	89 c8                	mov    %ecx,%eax
  8035d8:	89 f2                	mov    %esi,%edx
  8035da:	f7 f7                	div    %edi
  8035dc:	89 d0                	mov    %edx,%eax
  8035de:	31 d2                	xor    %edx,%edx
  8035e0:	83 c4 1c             	add    $0x1c,%esp
  8035e3:	5b                   	pop    %ebx
  8035e4:	5e                   	pop    %esi
  8035e5:	5f                   	pop    %edi
  8035e6:	5d                   	pop    %ebp
  8035e7:	c3                   	ret    
  8035e8:	39 f0                	cmp    %esi,%eax
  8035ea:	0f 87 ac 00 00 00    	ja     80369c <__umoddi3+0xfc>
  8035f0:	0f bd e8             	bsr    %eax,%ebp
  8035f3:	83 f5 1f             	xor    $0x1f,%ebp
  8035f6:	0f 84 ac 00 00 00    	je     8036a8 <__umoddi3+0x108>
  8035fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803601:	29 ef                	sub    %ebp,%edi
  803603:	89 fe                	mov    %edi,%esi
  803605:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 e0                	shl    %cl,%eax
  80360d:	89 d7                	mov    %edx,%edi
  80360f:	89 f1                	mov    %esi,%ecx
  803611:	d3 ef                	shr    %cl,%edi
  803613:	09 c7                	or     %eax,%edi
  803615:	89 e9                	mov    %ebp,%ecx
  803617:	d3 e2                	shl    %cl,%edx
  803619:	89 14 24             	mov    %edx,(%esp)
  80361c:	89 d8                	mov    %ebx,%eax
  80361e:	d3 e0                	shl    %cl,%eax
  803620:	89 c2                	mov    %eax,%edx
  803622:	8b 44 24 08          	mov    0x8(%esp),%eax
  803626:	d3 e0                	shl    %cl,%eax
  803628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80362c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803630:	89 f1                	mov    %esi,%ecx
  803632:	d3 e8                	shr    %cl,%eax
  803634:	09 d0                	or     %edx,%eax
  803636:	d3 eb                	shr    %cl,%ebx
  803638:	89 da                	mov    %ebx,%edx
  80363a:	f7 f7                	div    %edi
  80363c:	89 d3                	mov    %edx,%ebx
  80363e:	f7 24 24             	mull   (%esp)
  803641:	89 c6                	mov    %eax,%esi
  803643:	89 d1                	mov    %edx,%ecx
  803645:	39 d3                	cmp    %edx,%ebx
  803647:	0f 82 87 00 00 00    	jb     8036d4 <__umoddi3+0x134>
  80364d:	0f 84 91 00 00 00    	je     8036e4 <__umoddi3+0x144>
  803653:	8b 54 24 04          	mov    0x4(%esp),%edx
  803657:	29 f2                	sub    %esi,%edx
  803659:	19 cb                	sbb    %ecx,%ebx
  80365b:	89 d8                	mov    %ebx,%eax
  80365d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803661:	d3 e0                	shl    %cl,%eax
  803663:	89 e9                	mov    %ebp,%ecx
  803665:	d3 ea                	shr    %cl,%edx
  803667:	09 d0                	or     %edx,%eax
  803669:	89 e9                	mov    %ebp,%ecx
  80366b:	d3 eb                	shr    %cl,%ebx
  80366d:	89 da                	mov    %ebx,%edx
  80366f:	83 c4 1c             	add    $0x1c,%esp
  803672:	5b                   	pop    %ebx
  803673:	5e                   	pop    %esi
  803674:	5f                   	pop    %edi
  803675:	5d                   	pop    %ebp
  803676:	c3                   	ret    
  803677:	90                   	nop
  803678:	89 fd                	mov    %edi,%ebp
  80367a:	85 ff                	test   %edi,%edi
  80367c:	75 0b                	jne    803689 <__umoddi3+0xe9>
  80367e:	b8 01 00 00 00       	mov    $0x1,%eax
  803683:	31 d2                	xor    %edx,%edx
  803685:	f7 f7                	div    %edi
  803687:	89 c5                	mov    %eax,%ebp
  803689:	89 f0                	mov    %esi,%eax
  80368b:	31 d2                	xor    %edx,%edx
  80368d:	f7 f5                	div    %ebp
  80368f:	89 c8                	mov    %ecx,%eax
  803691:	f7 f5                	div    %ebp
  803693:	89 d0                	mov    %edx,%eax
  803695:	e9 44 ff ff ff       	jmp    8035de <__umoddi3+0x3e>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	89 c8                	mov    %ecx,%eax
  80369e:	89 f2                	mov    %esi,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	3b 04 24             	cmp    (%esp),%eax
  8036ab:	72 06                	jb     8036b3 <__umoddi3+0x113>
  8036ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036b1:	77 0f                	ja     8036c2 <__umoddi3+0x122>
  8036b3:	89 f2                	mov    %esi,%edx
  8036b5:	29 f9                	sub    %edi,%ecx
  8036b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036bb:	89 14 24             	mov    %edx,(%esp)
  8036be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036c6:	8b 14 24             	mov    (%esp),%edx
  8036c9:	83 c4 1c             	add    $0x1c,%esp
  8036cc:	5b                   	pop    %ebx
  8036cd:	5e                   	pop    %esi
  8036ce:	5f                   	pop    %edi
  8036cf:	5d                   	pop    %ebp
  8036d0:	c3                   	ret    
  8036d1:	8d 76 00             	lea    0x0(%esi),%esi
  8036d4:	2b 04 24             	sub    (%esp),%eax
  8036d7:	19 fa                	sbb    %edi,%edx
  8036d9:	89 d1                	mov    %edx,%ecx
  8036db:	89 c6                	mov    %eax,%esi
  8036dd:	e9 71 ff ff ff       	jmp    803653 <__umoddi3+0xb3>
  8036e2:	66 90                	xchg   %ax,%ax
  8036e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e8:	72 ea                	jb     8036d4 <__umoddi3+0x134>
  8036ea:	89 d9                	mov    %ebx,%ecx
  8036ec:	e9 62 ff ff ff       	jmp    803653 <__umoddi3+0xb3>
