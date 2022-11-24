
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 f3 01 00 00       	call   800229 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 52 13 00 00       	call   8013bd <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 41 13 00 00       	call   8013bd <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 e5 15 00 00       	call   80166c <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000a8:	c1 e0 03             	shl    $0x3,%eax
  8000ab:	89 c2                	mov    %eax,%edx
  8000ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000b0:	01 d0                	add    %edx,%eax
  8000b2:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	89 d0                	mov    %edx,%eax
  8000ba:	01 c0                	add    %eax,%eax
  8000bc:	01 d0                	add    %edx,%eax
  8000be:	c1 e0 02             	shl    $0x2,%eax
  8000c1:	89 c2                	mov    %eax,%edx
  8000c3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000c6:	01 d0                	add    %edx,%eax
  8000c8:	c6 00 ff             	movb   $0xff,(%eax)

		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;

		free(x);
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	ff 75 cc             	pushl  -0x34(%ebp)
  8000d1:	e8 28 13 00 00       	call   8013fe <free>
  8000d6:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000d9:	83 ec 0c             	sub    $0xc,%esp
  8000dc:	ff 75 c8             	pushl  -0x38(%ebp)
  8000df:	e8 1a 13 00 00       	call   8013fe <free>
  8000e4:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  8000e7:	e8 e0 14 00 00       	call   8015cc <sys_calculate_free_frames>
  8000ec:	89 45 c0             	mov    %eax,-0x40(%ebp)

		x = malloc(sizeof(char)*size) ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	ff 75 d0             	pushl  -0x30(%ebp)
  8000f5:	e8 c3 12 00 00       	call   8013bd <malloc>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 cc             	mov    %eax,-0x34(%ebp)

		x[1]=-2;
  800100:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800103:	40                   	inc    %eax
  800104:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  800107:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80010a:	89 d0                	mov    %edx,%eax
  80010c:	c1 e0 02             	shl    $0x2,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80011b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80011e:	c1 e0 03             	shl    $0x3,%eax
  800121:	89 c2                	mov    %eax,%edx
  800123:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[12*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	01 c0                	add    %eax,%eax
  800132:	01 d0                	add    %edx,%eax
  800134:	c1 e0 02             	shl    $0x2,%eax
  800137:	89 c2                	mov    %eax,%edx
  800139:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 fe             	movb   $0xfe,(%eax)

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};
  800141:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800144:	bb 80 1e 80 00       	mov    $0x801e80,%ebx
  800149:	ba 08 00 00 00       	mov    $0x8,%edx
  80014e:	89 c7                	mov    %eax,%edi
  800150:	89 de                	mov    %ebx,%esi
  800152:	89 d1                	mov    %edx,%ecx
  800154:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800156:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < (myEnv->page_WS_max_size); i++)
  80015d:	eb 79                	jmp    8001d8 <_main+0x1a0>
		{
			int found = 0 ;
  80015f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800166:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80016d:	eb 3d                	jmp    8001ac <_main+0x174>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80016f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800172:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800176:	a1 20 30 80 00       	mov    0x803020,%eax
  80017b:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  800181:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800184:	89 d0                	mov    %edx,%eax
  800186:	01 c0                	add    %eax,%eax
  800188:	01 d0                	add    %edx,%eax
  80018a:	c1 e0 03             	shl    $0x3,%eax
  80018d:	01 d8                	add    %ebx,%eax
  80018f:	8b 00                	mov    (%eax),%eax
  800191:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800194:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800197:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019c:	39 c1                	cmp    %eax,%ecx
  80019e:	75 09                	jne    8001a9 <_main+0x171>
				{
					found = 1 ;
  8001a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001a7:	eb 12                	jmp    8001bb <_main+0x183>

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001a9:	ff 45 e0             	incl   -0x20(%ebp)
  8001ac:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b1:	8b 50 74             	mov    0x74(%eax),%edx
  8001b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b7:	39 c2                	cmp    %eax,%edx
  8001b9:	77 b4                	ja     80016f <_main+0x137>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001bb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001bf:	75 14                	jne    8001d5 <_main+0x19d>
				panic("PAGE Placement algorithm failed after applying freeHeap");
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 c0 1d 80 00       	push   $0x801dc0
  8001c9:	6a 41                	push   $0x41
  8001cb:	68 f8 1d 80 00       	push   $0x801df8
  8001d0:	e8 90 01 00 00       	call   800365 <_panic>
		x[12*Mega]=-2;

		uint32 pageWSEntries[8] = {0x802000, 0x80500000, 0x80800000, 0x80c00000, 0x80000000, 0x801000, 0x800000, 0xeebfd000};

		int i = 0, j ;
		for (; i < (myEnv->page_WS_max_size); i++)
  8001d5:	ff 45 e4             	incl   -0x1c(%ebp)
  8001d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8001dd:	8b 50 74             	mov    0x74(%eax),%edx
  8001e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e3:	39 c2                	cmp    %eax,%edx
  8001e5:	0f 87 74 ff ff ff    	ja     80015f <_main+0x127>
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap");
		}


		if( (freePages - sys_calculate_free_frames() ) != 8 ) panic("Extra/Less memory are wrongly allocated");
  8001eb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8001ee:	e8 d9 13 00 00       	call   8015cc <sys_calculate_free_frames>
  8001f3:	29 c3                	sub    %eax,%ebx
  8001f5:	89 d8                	mov    %ebx,%eax
  8001f7:	83 f8 08             	cmp    $0x8,%eax
  8001fa:	74 14                	je     800210 <_main+0x1d8>
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	68 0c 1e 80 00       	push   $0x801e0c
  800204:	6a 45                	push   $0x45
  800206:	68 f8 1d 80 00       	push   $0x801df8
  80020b:	e8 55 01 00 00       	call   800365 <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 34 1e 80 00       	push   $0x801e34
  800218:	e8 fc 03 00 00       	call   800619 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp


	return;
  800220:	90                   	nop
}
  800221:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5f                   	pop    %edi
  800227:	5d                   	pop    %ebp
  800228:	c3                   	ret    

00800229 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80022f:	e8 78 16 00 00       	call   8018ac <sys_getenvindex>
  800234:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800237:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023a:	89 d0                	mov    %edx,%eax
  80023c:	c1 e0 03             	shl    $0x3,%eax
  80023f:	01 d0                	add    %edx,%eax
  800241:	01 c0                	add    %eax,%eax
  800243:	01 d0                	add    %edx,%eax
  800245:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80024c:	01 d0                	add    %edx,%eax
  80024e:	c1 e0 04             	shl    $0x4,%eax
  800251:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800256:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80025b:	a1 20 30 80 00       	mov    0x803020,%eax
  800260:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800266:	84 c0                	test   %al,%al
  800268:	74 0f                	je     800279 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026a:	a1 20 30 80 00       	mov    0x803020,%eax
  80026f:	05 5c 05 00 00       	add    $0x55c,%eax
  800274:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80027d:	7e 0a                	jle    800289 <libmain+0x60>
		binaryname = argv[0];
  80027f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800282:	8b 00                	mov    (%eax),%eax
  800284:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800289:	83 ec 08             	sub    $0x8,%esp
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	e8 a1 fd ff ff       	call   800038 <_main>
  800297:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029a:	e8 1a 14 00 00       	call   8016b9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	68 b8 1e 80 00       	push   $0x801eb8
  8002a7:	e8 6d 03 00 00       	call   800619 <cprintf>
  8002ac:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002af:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b4:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8002bf:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002c5:	83 ec 04             	sub    $0x4,%esp
  8002c8:	52                   	push   %edx
  8002c9:	50                   	push   %eax
  8002ca:	68 e0 1e 80 00       	push   $0x801ee0
  8002cf:	e8 45 03 00 00       	call   800619 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002d7:	a1 20 30 80 00       	mov    0x803020,%eax
  8002dc:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002f8:	51                   	push   %ecx
  8002f9:	52                   	push   %edx
  8002fa:	50                   	push   %eax
  8002fb:	68 08 1f 80 00       	push   $0x801f08
  800300:	e8 14 03 00 00       	call   800619 <cprintf>
  800305:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800308:	a1 20 30 80 00       	mov    0x803020,%eax
  80030d:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800313:	83 ec 08             	sub    $0x8,%esp
  800316:	50                   	push   %eax
  800317:	68 60 1f 80 00       	push   $0x801f60
  80031c:	e8 f8 02 00 00       	call   800619 <cprintf>
  800321:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800324:	83 ec 0c             	sub    $0xc,%esp
  800327:	68 b8 1e 80 00       	push   $0x801eb8
  80032c:	e8 e8 02 00 00       	call   800619 <cprintf>
  800331:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800334:	e8 9a 13 00 00       	call   8016d3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800339:	e8 19 00 00 00       	call   800357 <exit>
}
  80033e:	90                   	nop
  80033f:	c9                   	leave  
  800340:	c3                   	ret    

00800341 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	6a 00                	push   $0x0
  80034c:	e8 27 15 00 00       	call   801878 <sys_destroy_env>
  800351:	83 c4 10             	add    $0x10,%esp
}
  800354:	90                   	nop
  800355:	c9                   	leave  
  800356:	c3                   	ret    

00800357 <exit>:

void
exit(void)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80035d:	e8 7c 15 00 00       	call   8018de <sys_exit_env>
}
  800362:	90                   	nop
  800363:	c9                   	leave  
  800364:	c3                   	ret    

00800365 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800365:	55                   	push   %ebp
  800366:	89 e5                	mov    %esp,%ebp
  800368:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80036b:	8d 45 10             	lea    0x10(%ebp),%eax
  80036e:	83 c0 04             	add    $0x4,%eax
  800371:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800374:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800379:	85 c0                	test   %eax,%eax
  80037b:	74 16                	je     800393 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80037d:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800382:	83 ec 08             	sub    $0x8,%esp
  800385:	50                   	push   %eax
  800386:	68 74 1f 80 00       	push   $0x801f74
  80038b:	e8 89 02 00 00       	call   800619 <cprintf>
  800390:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800393:	a1 00 30 80 00       	mov    0x803000,%eax
  800398:	ff 75 0c             	pushl  0xc(%ebp)
  80039b:	ff 75 08             	pushl  0x8(%ebp)
  80039e:	50                   	push   %eax
  80039f:	68 79 1f 80 00       	push   $0x801f79
  8003a4:	e8 70 02 00 00       	call   800619 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	83 ec 08             	sub    $0x8,%esp
  8003b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b5:	50                   	push   %eax
  8003b6:	e8 f3 01 00 00       	call   8005ae <vcprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003be:	83 ec 08             	sub    $0x8,%esp
  8003c1:	6a 00                	push   $0x0
  8003c3:	68 95 1f 80 00       	push   $0x801f95
  8003c8:	e8 e1 01 00 00       	call   8005ae <vcprintf>
  8003cd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d0:	e8 82 ff ff ff       	call   800357 <exit>

	// should not return here
	while (1) ;
  8003d5:	eb fe                	jmp    8003d5 <_panic+0x70>

008003d7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003d7:	55                   	push   %ebp
  8003d8:	89 e5                	mov    %esp,%ebp
  8003da:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e2:	8b 50 74             	mov    0x74(%eax),%edx
  8003e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e8:	39 c2                	cmp    %eax,%edx
  8003ea:	74 14                	je     800400 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ec:	83 ec 04             	sub    $0x4,%esp
  8003ef:	68 98 1f 80 00       	push   $0x801f98
  8003f4:	6a 26                	push   $0x26
  8003f6:	68 e4 1f 80 00       	push   $0x801fe4
  8003fb:	e8 65 ff ff ff       	call   800365 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800407:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80040e:	e9 c2 00 00 00       	jmp    8004d5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800416:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	85 c0                	test   %eax,%eax
  800426:	75 08                	jne    800430 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800428:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80042b:	e9 a2 00 00 00       	jmp    8004d2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800430:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800437:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80043e:	eb 69                	jmp    8004a9 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800440:	a1 20 30 80 00       	mov    0x803020,%eax
  800445:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80044e:	89 d0                	mov    %edx,%eax
  800450:	01 c0                	add    %eax,%eax
  800452:	01 d0                	add    %edx,%eax
  800454:	c1 e0 03             	shl    $0x3,%eax
  800457:	01 c8                	add    %ecx,%eax
  800459:	8a 40 04             	mov    0x4(%eax),%al
  80045c:	84 c0                	test   %al,%al
  80045e:	75 46                	jne    8004a6 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800460:	a1 20 30 80 00       	mov    0x803020,%eax
  800465:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80046b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80046e:	89 d0                	mov    %edx,%eax
  800470:	01 c0                	add    %eax,%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	c1 e0 03             	shl    $0x3,%eax
  800477:	01 c8                	add    %ecx,%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80047e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800486:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800488:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80048b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 c8                	add    %ecx,%eax
  800497:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800499:	39 c2                	cmp    %eax,%edx
  80049b:	75 09                	jne    8004a6 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80049d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a4:	eb 12                	jmp    8004b8 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a6:	ff 45 e8             	incl   -0x18(%ebp)
  8004a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ae:	8b 50 74             	mov    0x74(%eax),%edx
  8004b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b4:	39 c2                	cmp    %eax,%edx
  8004b6:	77 88                	ja     800440 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004bc:	75 14                	jne    8004d2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004be:	83 ec 04             	sub    $0x4,%esp
  8004c1:	68 f0 1f 80 00       	push   $0x801ff0
  8004c6:	6a 3a                	push   $0x3a
  8004c8:	68 e4 1f 80 00       	push   $0x801fe4
  8004cd:	e8 93 fe ff ff       	call   800365 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d2:	ff 45 f0             	incl   -0x10(%ebp)
  8004d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004db:	0f 8c 32 ff ff ff    	jl     800413 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004ef:	eb 26                	jmp    800517 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f1:	a1 20 30 80 00       	mov    0x803020,%eax
  8004f6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ff:	89 d0                	mov    %edx,%eax
  800501:	01 c0                	add    %eax,%eax
  800503:	01 d0                	add    %edx,%eax
  800505:	c1 e0 03             	shl    $0x3,%eax
  800508:	01 c8                	add    %ecx,%eax
  80050a:	8a 40 04             	mov    0x4(%eax),%al
  80050d:	3c 01                	cmp    $0x1,%al
  80050f:	75 03                	jne    800514 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800511:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800514:	ff 45 e0             	incl   -0x20(%ebp)
  800517:	a1 20 30 80 00       	mov    0x803020,%eax
  80051c:	8b 50 74             	mov    0x74(%eax),%edx
  80051f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800522:	39 c2                	cmp    %eax,%edx
  800524:	77 cb                	ja     8004f1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800529:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 44 20 80 00       	push   $0x802044
  800536:	6a 44                	push   $0x44
  800538:	68 e4 1f 80 00       	push   $0x801fe4
  80053d:	e8 23 fe ff ff       	call   800365 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800542:	90                   	nop
  800543:	c9                   	leave  
  800544:	c3                   	ret    

00800545 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800545:	55                   	push   %ebp
  800546:	89 e5                	mov    %esp,%ebp
  800548:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80054b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	8d 48 01             	lea    0x1(%eax),%ecx
  800553:	8b 55 0c             	mov    0xc(%ebp),%edx
  800556:	89 0a                	mov    %ecx,(%edx)
  800558:	8b 55 08             	mov    0x8(%ebp),%edx
  80055b:	88 d1                	mov    %dl,%cl
  80055d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800560:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	3d ff 00 00 00       	cmp    $0xff,%eax
  80056e:	75 2c                	jne    80059c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800570:	a0 24 30 80 00       	mov    0x803024,%al
  800575:	0f b6 c0             	movzbl %al,%eax
  800578:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057b:	8b 12                	mov    (%edx),%edx
  80057d:	89 d1                	mov    %edx,%ecx
  80057f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800582:	83 c2 08             	add    $0x8,%edx
  800585:	83 ec 04             	sub    $0x4,%esp
  800588:	50                   	push   %eax
  800589:	51                   	push   %ecx
  80058a:	52                   	push   %edx
  80058b:	e8 7b 0f 00 00       	call   80150b <sys_cputs>
  800590:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800593:	8b 45 0c             	mov    0xc(%ebp),%eax
  800596:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 40 04             	mov    0x4(%eax),%eax
  8005a2:	8d 50 01             	lea    0x1(%eax),%edx
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005ab:	90                   	nop
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005be:	00 00 00 
	b.cnt = 0;
  8005c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005c8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005cb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ce:	ff 75 08             	pushl  0x8(%ebp)
  8005d1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	68 45 05 80 00       	push   $0x800545
  8005dd:	e8 11 02 00 00       	call   8007f3 <vprintfmt>
  8005e2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005e5:	a0 24 30 80 00       	mov    0x803024,%al
  8005ea:	0f b6 c0             	movzbl %al,%eax
  8005ed:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f3:	83 ec 04             	sub    $0x4,%esp
  8005f6:	50                   	push   %eax
  8005f7:	52                   	push   %edx
  8005f8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005fe:	83 c0 08             	add    $0x8,%eax
  800601:	50                   	push   %eax
  800602:	e8 04 0f 00 00       	call   80150b <sys_cputs>
  800607:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060a:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800611:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800617:	c9                   	leave  
  800618:	c3                   	ret    

00800619 <cprintf>:

int cprintf(const char *fmt, ...) {
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80061f:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800626:	8d 45 0c             	lea    0xc(%ebp),%eax
  800629:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	ff 75 f4             	pushl  -0xc(%ebp)
  800635:	50                   	push   %eax
  800636:	e8 73 ff ff ff       	call   8005ae <vcprintf>
  80063b:	83 c4 10             	add    $0x10,%esp
  80063e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80064c:	e8 68 10 00 00       	call   8016b9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 48 ff ff ff       	call   8005ae <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80066c:	e8 62 10 00 00       	call   8016d3 <sys_enable_interrupt>
	return cnt;
  800671:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800674:	c9                   	leave  
  800675:	c3                   	ret    

00800676 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800676:	55                   	push   %ebp
  800677:	89 e5                	mov    %esp,%ebp
  800679:	53                   	push   %ebx
  80067a:	83 ec 14             	sub    $0x14,%esp
  80067d:	8b 45 10             	mov    0x10(%ebp),%eax
  800680:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800683:	8b 45 14             	mov    0x14(%ebp),%eax
  800686:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800689:	8b 45 18             	mov    0x18(%ebp),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800694:	77 55                	ja     8006eb <printnum+0x75>
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	72 05                	jb     8006a0 <printnum+0x2a>
  80069b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80069e:	77 4b                	ja     8006eb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a0:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a3:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	52                   	push   %edx
  8006af:	50                   	push   %eax
  8006b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8006b6:	e8 85 14 00 00       	call   801b40 <__udivdi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	83 ec 04             	sub    $0x4,%esp
  8006c1:	ff 75 20             	pushl  0x20(%ebp)
  8006c4:	53                   	push   %ebx
  8006c5:	ff 75 18             	pushl  0x18(%ebp)
  8006c8:	52                   	push   %edx
  8006c9:	50                   	push   %eax
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	ff 75 08             	pushl  0x8(%ebp)
  8006d0:	e8 a1 ff ff ff       	call   800676 <printnum>
  8006d5:	83 c4 20             	add    $0x20,%esp
  8006d8:	eb 1a                	jmp    8006f4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	ff 75 20             	pushl  0x20(%ebp)
  8006e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e6:	ff d0                	call   *%eax
  8006e8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006eb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006ee:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f2:	7f e6                	jg     8006da <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800702:	53                   	push   %ebx
  800703:	51                   	push   %ecx
  800704:	52                   	push   %edx
  800705:	50                   	push   %eax
  800706:	e8 45 15 00 00       	call   801c50 <__umoddi3>
  80070b:	83 c4 10             	add    $0x10,%esp
  80070e:	05 b4 22 80 00       	add    $0x8022b4,%eax
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f be c0             	movsbl %al,%eax
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	50                   	push   %eax
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	ff d0                	call   *%eax
  800724:	83 c4 10             	add    $0x10,%esp
}
  800727:	90                   	nop
  800728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800730:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800734:	7e 1c                	jle    800752 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	8d 50 08             	lea    0x8(%eax),%edx
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	89 10                	mov    %edx,(%eax)
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	83 e8 08             	sub    $0x8,%eax
  80074b:	8b 50 04             	mov    0x4(%eax),%edx
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	eb 40                	jmp    800792 <getuint+0x65>
	else if (lflag)
  800752:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800756:	74 1e                	je     800776 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	8d 50 04             	lea    0x4(%eax),%edx
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	89 10                	mov    %edx,(%eax)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	83 e8 04             	sub    $0x4,%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	ba 00 00 00 00       	mov    $0x0,%edx
  800774:	eb 1c                	jmp    800792 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	8d 50 04             	lea    0x4(%eax),%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	89 10                	mov    %edx,(%eax)
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	83 e8 04             	sub    $0x4,%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800792:	5d                   	pop    %ebp
  800793:	c3                   	ret    

00800794 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800797:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079b:	7e 1c                	jle    8007b9 <getint+0x25>
		return va_arg(*ap, long long);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	8d 50 08             	lea    0x8(%eax),%edx
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	89 10                	mov    %edx,(%eax)
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	83 e8 08             	sub    $0x8,%eax
  8007b2:	8b 50 04             	mov    0x4(%eax),%edx
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	eb 38                	jmp    8007f1 <getint+0x5d>
	else if (lflag)
  8007b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007bd:	74 1a                	je     8007d9 <getint+0x45>
		return va_arg(*ap, long);
  8007bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	8d 50 04             	lea    0x4(%eax),%edx
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	89 10                	mov    %edx,(%eax)
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	99                   	cltd   
  8007d7:	eb 18                	jmp    8007f1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dc:	8b 00                	mov    (%eax),%eax
  8007de:	8d 50 04             	lea    0x4(%eax),%edx
  8007e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e4:	89 10                	mov    %edx,(%eax)
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	8b 00                	mov    (%eax),%eax
  8007eb:	83 e8 04             	sub    $0x4,%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	99                   	cltd   
}
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	56                   	push   %esi
  8007f7:	53                   	push   %ebx
  8007f8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fb:	eb 17                	jmp    800814 <vprintfmt+0x21>
			if (ch == '\0')
  8007fd:	85 db                	test   %ebx,%ebx
  8007ff:	0f 84 af 03 00 00    	je     800bb4 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	53                   	push   %ebx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	ff d0                	call   *%eax
  800811:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	8b 45 10             	mov    0x10(%ebp),%eax
  800817:	8d 50 01             	lea    0x1(%eax),%edx
  80081a:	89 55 10             	mov    %edx,0x10(%ebp)
  80081d:	8a 00                	mov    (%eax),%al
  80081f:	0f b6 d8             	movzbl %al,%ebx
  800822:	83 fb 25             	cmp    $0x25,%ebx
  800825:	75 d6                	jne    8007fd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800827:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80082b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800832:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800839:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800840:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800847:	8b 45 10             	mov    0x10(%ebp),%eax
  80084a:	8d 50 01             	lea    0x1(%eax),%edx
  80084d:	89 55 10             	mov    %edx,0x10(%ebp)
  800850:	8a 00                	mov    (%eax),%al
  800852:	0f b6 d8             	movzbl %al,%ebx
  800855:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800858:	83 f8 55             	cmp    $0x55,%eax
  80085b:	0f 87 2b 03 00 00    	ja     800b8c <vprintfmt+0x399>
  800861:	8b 04 85 d8 22 80 00 	mov    0x8022d8(,%eax,4),%eax
  800868:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80086e:	eb d7                	jmp    800847 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800870:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800874:	eb d1                	jmp    800847 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800876:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80087d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800880:	89 d0                	mov    %edx,%eax
  800882:	c1 e0 02             	shl    $0x2,%eax
  800885:	01 d0                	add    %edx,%eax
  800887:	01 c0                	add    %eax,%eax
  800889:	01 d8                	add    %ebx,%eax
  80088b:	83 e8 30             	sub    $0x30,%eax
  80088e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800891:	8b 45 10             	mov    0x10(%ebp),%eax
  800894:	8a 00                	mov    (%eax),%al
  800896:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800899:	83 fb 2f             	cmp    $0x2f,%ebx
  80089c:	7e 3e                	jle    8008dc <vprintfmt+0xe9>
  80089e:	83 fb 39             	cmp    $0x39,%ebx
  8008a1:	7f 39                	jg     8008dc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a3:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008a6:	eb d5                	jmp    80087d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ab:	83 c0 04             	add    $0x4,%eax
  8008ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 e8 04             	sub    $0x4,%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008bc:	eb 1f                	jmp    8008dd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c2:	79 83                	jns    800847 <vprintfmt+0x54>
				width = 0;
  8008c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008cb:	e9 77 ff ff ff       	jmp    800847 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008d7:	e9 6b ff ff ff       	jmp    800847 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008dc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e1:	0f 89 60 ff ff ff    	jns    800847 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ed:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f4:	e9 4e ff ff ff       	jmp    800847 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008f9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008fc:	e9 46 ff ff ff       	jmp    800847 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800901:	8b 45 14             	mov    0x14(%ebp),%eax
  800904:	83 c0 04             	add    $0x4,%eax
  800907:	89 45 14             	mov    %eax,0x14(%ebp)
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 e8 04             	sub    $0x4,%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	50                   	push   %eax
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			break;
  800921:	e9 89 02 00 00       	jmp    800baf <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800926:	8b 45 14             	mov    0x14(%ebp),%eax
  800929:	83 c0 04             	add    $0x4,%eax
  80092c:	89 45 14             	mov    %eax,0x14(%ebp)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 e8 04             	sub    $0x4,%eax
  800935:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800937:	85 db                	test   %ebx,%ebx
  800939:	79 02                	jns    80093d <vprintfmt+0x14a>
				err = -err;
  80093b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80093d:	83 fb 64             	cmp    $0x64,%ebx
  800940:	7f 0b                	jg     80094d <vprintfmt+0x15a>
  800942:	8b 34 9d 20 21 80 00 	mov    0x802120(,%ebx,4),%esi
  800949:	85 f6                	test   %esi,%esi
  80094b:	75 19                	jne    800966 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80094d:	53                   	push   %ebx
  80094e:	68 c5 22 80 00       	push   $0x8022c5
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	ff 75 08             	pushl  0x8(%ebp)
  800959:	e8 5e 02 00 00       	call   800bbc <printfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800961:	e9 49 02 00 00       	jmp    800baf <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800966:	56                   	push   %esi
  800967:	68 ce 22 80 00       	push   $0x8022ce
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 45 02 00 00       	call   800bbc <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			break;
  80097a:	e9 30 02 00 00       	jmp    800baf <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80097f:	8b 45 14             	mov    0x14(%ebp),%eax
  800982:	83 c0 04             	add    $0x4,%eax
  800985:	89 45 14             	mov    %eax,0x14(%ebp)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 e8 04             	sub    $0x4,%eax
  80098e:	8b 30                	mov    (%eax),%esi
  800990:	85 f6                	test   %esi,%esi
  800992:	75 05                	jne    800999 <vprintfmt+0x1a6>
				p = "(null)";
  800994:	be d1 22 80 00       	mov    $0x8022d1,%esi
			if (width > 0 && padc != '-')
  800999:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099d:	7e 6d                	jle    800a0c <vprintfmt+0x219>
  80099f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a3:	74 67                	je     800a0c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	50                   	push   %eax
  8009ac:	56                   	push   %esi
  8009ad:	e8 0c 03 00 00       	call   800cbe <strnlen>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009b8:	eb 16                	jmp    8009d0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009ba:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	50                   	push   %eax
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	ff d0                	call   *%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cd:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d4:	7f e4                	jg     8009ba <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d6:	eb 34                	jmp    800a0c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009dc:	74 1c                	je     8009fa <vprintfmt+0x207>
  8009de:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e1:	7e 05                	jle    8009e8 <vprintfmt+0x1f5>
  8009e3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009e6:	7e 12                	jle    8009fa <vprintfmt+0x207>
					putch('?', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 3f                	push   $0x3f
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
  8009f8:	eb 0f                	jmp    800a09 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	53                   	push   %ebx
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a09:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0c:	89 f0                	mov    %esi,%eax
  800a0e:	8d 70 01             	lea    0x1(%eax),%esi
  800a11:	8a 00                	mov    (%eax),%al
  800a13:	0f be d8             	movsbl %al,%ebx
  800a16:	85 db                	test   %ebx,%ebx
  800a18:	74 24                	je     800a3e <vprintfmt+0x24b>
  800a1a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a1e:	78 b8                	js     8009d8 <vprintfmt+0x1e5>
  800a20:	ff 4d e0             	decl   -0x20(%ebp)
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	79 af                	jns    8009d8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a29:	eb 13                	jmp    800a3e <vprintfmt+0x24b>
				putch(' ', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 20                	push   $0x20
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a3b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a42:	7f e7                	jg     800a2b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a44:	e9 66 01 00 00       	jmp    800baf <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 3c fd ff ff       	call   800794 <getint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a67:	85 d2                	test   %edx,%edx
  800a69:	79 23                	jns    800a8e <vprintfmt+0x29b>
				putch('-', putdat);
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	ff 75 0c             	pushl  0xc(%ebp)
  800a71:	6a 2d                	push   $0x2d
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	ff d0                	call   *%eax
  800a78:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a81:	f7 d8                	neg    %eax
  800a83:	83 d2 00             	adc    $0x0,%edx
  800a86:	f7 da                	neg    %edx
  800a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a8e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a95:	e9 bc 00 00 00       	jmp    800b56 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9a:	83 ec 08             	sub    $0x8,%esp
  800a9d:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa0:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 84 fc ff ff       	call   80072d <getuint>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ab9:	e9 98 00 00 00       	jmp    800b56 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800abe:	83 ec 08             	sub    $0x8,%esp
  800ac1:	ff 75 0c             	pushl  0xc(%ebp)
  800ac4:	6a 58                	push   $0x58
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	ff d0                	call   *%eax
  800acb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	6a 58                	push   $0x58
  800ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad9:	ff d0                	call   *%eax
  800adb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ade:	83 ec 08             	sub    $0x8,%esp
  800ae1:	ff 75 0c             	pushl  0xc(%ebp)
  800ae4:	6a 58                	push   $0x58
  800ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae9:	ff d0                	call   *%eax
  800aeb:	83 c4 10             	add    $0x10,%esp
			break;
  800aee:	e9 bc 00 00 00       	jmp    800baf <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	6a 30                	push   $0x30
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	ff d0                	call   *%eax
  800b00:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b03:	83 ec 08             	sub    $0x8,%esp
  800b06:	ff 75 0c             	pushl  0xc(%ebp)
  800b09:	6a 78                	push   $0x78
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	ff d0                	call   *%eax
  800b10:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b13:	8b 45 14             	mov    0x14(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 14             	mov    %eax,0x14(%ebp)
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b2e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b35:	eb 1f                	jmp    800b56 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b3d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b40:	50                   	push   %eax
  800b41:	e8 e7 fb ff ff       	call   80072d <getuint>
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b4f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b56:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	83 ec 04             	sub    $0x4,%esp
  800b60:	52                   	push   %edx
  800b61:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b64:	50                   	push   %eax
  800b65:	ff 75 f4             	pushl  -0xc(%ebp)
  800b68:	ff 75 f0             	pushl  -0x10(%ebp)
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 00 fb ff ff       	call   800676 <printnum>
  800b76:	83 c4 20             	add    $0x20,%esp
			break;
  800b79:	eb 34                	jmp    800baf <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b7b:	83 ec 08             	sub    $0x8,%esp
  800b7e:	ff 75 0c             	pushl  0xc(%ebp)
  800b81:	53                   	push   %ebx
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	ff d0                	call   *%eax
  800b87:	83 c4 10             	add    $0x10,%esp
			break;
  800b8a:	eb 23                	jmp    800baf <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b8c:	83 ec 08             	sub    $0x8,%esp
  800b8f:	ff 75 0c             	pushl  0xc(%ebp)
  800b92:	6a 25                	push   $0x25
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	ff d0                	call   *%eax
  800b99:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b9c:	ff 4d 10             	decl   0x10(%ebp)
  800b9f:	eb 03                	jmp    800ba4 <vprintfmt+0x3b1>
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	48                   	dec    %eax
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	3c 25                	cmp    $0x25,%al
  800bac:	75 f3                	jne    800ba1 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bae:	90                   	nop
		}
	}
  800baf:	e9 47 fc ff ff       	jmp    8007fb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb4:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bb8:	5b                   	pop    %ebx
  800bb9:	5e                   	pop    %esi
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 16 fc ff ff       	call   8007f3 <vprintfmt>
  800bdd:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be0:	90                   	nop
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8b 40 08             	mov    0x8(%eax),%eax
  800bec:	8d 50 01             	lea    0x1(%eax),%edx
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8b 10                	mov    (%eax),%edx
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 40 04             	mov    0x4(%eax),%eax
  800c00:	39 c2                	cmp    %eax,%edx
  800c02:	73 12                	jae    800c16 <sprintputch+0x33>
		*b->buf++ = ch;
  800c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	8d 48 01             	lea    0x1(%eax),%ecx
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	89 0a                	mov    %ecx,(%edx)
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	88 10                	mov    %dl,(%eax)
}
  800c16:	90                   	nop
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	01 d0                	add    %edx,%eax
  800c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c3e:	74 06                	je     800c46 <vsnprintf+0x2d>
  800c40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c44:	7f 07                	jg     800c4d <vsnprintf+0x34>
		return -E_INVAL;
  800c46:	b8 03 00 00 00       	mov    $0x3,%eax
  800c4b:	eb 20                	jmp    800c6d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c4d:	ff 75 14             	pushl  0x14(%ebp)
  800c50:	ff 75 10             	pushl  0x10(%ebp)
  800c53:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c56:	50                   	push   %eax
  800c57:	68 e3 0b 80 00       	push   $0x800be3
  800c5c:	e8 92 fb ff ff       	call   8007f3 <vprintfmt>
  800c61:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c67:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c6d:	c9                   	leave  
  800c6e:	c3                   	ret    

00800c6f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6f:	55                   	push   %ebp
  800c70:	89 e5                	mov    %esp,%ebp
  800c72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c75:	8d 45 10             	lea    0x10(%ebp),%eax
  800c78:	83 c0 04             	add    $0x4,%eax
  800c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	ff 75 f4             	pushl  -0xc(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 0c             	pushl  0xc(%ebp)
  800c88:	ff 75 08             	pushl  0x8(%ebp)
  800c8b:	e8 89 ff ff ff       	call   800c19 <vsnprintf>
  800c90:	83 c4 10             	add    $0x10,%esp
  800c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ca8:	eb 06                	jmp    800cb0 <strlen+0x15>
		n++;
  800caa:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cad:	ff 45 08             	incl   0x8(%ebp)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 00                	mov    (%eax),%al
  800cb5:	84 c0                	test   %al,%al
  800cb7:	75 f1                	jne    800caa <strlen+0xf>
		n++;
	return n;
  800cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cbc:	c9                   	leave  
  800cbd:	c3                   	ret    

00800cbe <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ccb:	eb 09                	jmp    800cd6 <strnlen+0x18>
		n++;
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd0:	ff 45 08             	incl   0x8(%ebp)
  800cd3:	ff 4d 0c             	decl   0xc(%ebp)
  800cd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cda:	74 09                	je     800ce5 <strnlen+0x27>
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	75 e8                	jne    800ccd <strnlen+0xf>
		n++;
	return n;
  800ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce8:	c9                   	leave  
  800ce9:	c3                   	ret    

00800cea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cf6:	90                   	nop
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8d 50 01             	lea    0x1(%eax),%edx
  800cfd:	89 55 08             	mov    %edx,0x8(%ebp)
  800d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d06:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	75 e4                	jne    800cf7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    

00800d18 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
  800d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2b:	eb 1f                	jmp    800d4c <strncpy+0x34>
		*dst++ = *src;
  800d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d30:	8d 50 01             	lea    0x1(%eax),%edx
  800d33:	89 55 08             	mov    %edx,0x8(%ebp)
  800d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d39:	8a 12                	mov    (%edx),%dl
  800d3b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	84 c0                	test   %al,%al
  800d44:	74 03                	je     800d49 <strncpy+0x31>
			src++;
  800d46:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d49:	ff 45 fc             	incl   -0x4(%ebp)
  800d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d52:	72 d9                	jb     800d2d <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d54:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d65:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d69:	74 30                	je     800d9b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d6b:	eb 16                	jmp    800d83 <strlcpy+0x2a>
			*dst++ = *src++;
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8d 50 01             	lea    0x1(%eax),%edx
  800d73:	89 55 08             	mov    %edx,0x8(%ebp)
  800d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d79:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d7c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d7f:	8a 12                	mov    (%edx),%dl
  800d81:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d83:	ff 4d 10             	decl   0x10(%ebp)
  800d86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8a:	74 09                	je     800d95 <strlcpy+0x3c>
  800d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	84 c0                	test   %al,%al
  800d93:	75 d8                	jne    800d6d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da1:	29 c2                	sub    %eax,%edx
  800da3:	89 d0                	mov    %edx,%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daa:	eb 06                	jmp    800db2 <strcmp+0xb>
		p++, q++;
  800dac:	ff 45 08             	incl   0x8(%ebp)
  800daf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	84 c0                	test   %al,%al
  800db9:	74 0e                	je     800dc9 <strcmp+0x22>
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 10                	mov    (%eax),%dl
  800dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	38 c2                	cmp    %al,%dl
  800dc7:	74 e3                	je     800dac <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f b6 d0             	movzbl %al,%edx
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	0f b6 c0             	movzbl %al,%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de2:	eb 09                	jmp    800ded <strncmp+0xe>
		n--, p++, q++;
  800de4:	ff 4d 10             	decl   0x10(%ebp)
  800de7:	ff 45 08             	incl   0x8(%ebp)
  800dea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ded:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df1:	74 17                	je     800e0a <strncmp+0x2b>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 00                	mov    (%eax),%al
  800df8:	84 c0                	test   %al,%al
  800dfa:	74 0e                	je     800e0a <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 10                	mov    (%eax),%dl
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	38 c2                	cmp    %al,%dl
  800e08:	74 da                	je     800de4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	75 07                	jne    800e17 <strncmp+0x38>
		return 0;
  800e10:	b8 00 00 00 00       	mov    $0x0,%eax
  800e15:	eb 14                	jmp    800e2b <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f b6 c0             	movzbl %al,%eax
  800e27:	29 c2                	sub    %eax,%edx
  800e29:	89 d0                	mov    %edx,%eax
}
  800e2b:	5d                   	pop    %ebp
  800e2c:	c3                   	ret    

00800e2d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 12                	jmp    800e4d <strchr+0x20>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	75 05                	jne    800e4a <strchr+0x1d>
			return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	eb 11                	jmp    800e5b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4a:	ff 45 08             	incl   0x8(%ebp)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e5                	jne    800e3b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	83 ec 04             	sub    $0x4,%esp
  800e63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e66:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e69:	eb 0d                	jmp    800e78 <strfind+0x1b>
		if (*s == c)
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e73:	74 0e                	je     800e83 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 ea                	jne    800e6b <strfind+0xe>
  800e81:	eb 01                	jmp    800e84 <strfind+0x27>
		if (*s == c)
			break;
  800e83:	90                   	nop
	return (char *) s;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e95:	8b 45 10             	mov    0x10(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e9b:	eb 0e                	jmp    800eab <memset+0x22>
		*p++ = c;
  800e9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ea6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea9:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eab:	ff 4d f8             	decl   -0x8(%ebp)
  800eae:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb2:	79 e9                	jns    800e9d <memset+0x14>
		*p++ = c;

	return v;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ecb:	eb 16                	jmp    800ee3 <memcpy+0x2a>
		*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f0d:	73 50                	jae    800f5f <memmove+0x6a>
  800f0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f12:	8b 45 10             	mov    0x10(%ebp),%eax
  800f15:	01 d0                	add    %edx,%eax
  800f17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1a:	76 43                	jbe    800f5f <memmove+0x6a>
		s += n;
  800f1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1f:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f28:	eb 10                	jmp    800f3a <memmove+0x45>
			*--d = *--s;
  800f2a:	ff 4d f8             	decl   -0x8(%ebp)
  800f2d:	ff 4d fc             	decl   -0x4(%ebp)
  800f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f38:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f40:	89 55 10             	mov    %edx,0x10(%ebp)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	75 e3                	jne    800f2a <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f47:	eb 23                	jmp    800f6c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4c:	8d 50 01             	lea    0x1(%eax),%edx
  800f4f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f52:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f55:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f58:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f5b:	8a 12                	mov    (%edx),%dl
  800f5d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 dd                	jne    800f49 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
  800f74:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f80:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f83:	eb 2a                	jmp    800faf <memcmp+0x3e>
		if (*s1 != *s2)
  800f85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f88:	8a 10                	mov    (%eax),%dl
  800f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	38 c2                	cmp    %al,%dl
  800f91:	74 16                	je     800fa9 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	0f b6 d0             	movzbl %al,%edx
  800f9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	0f b6 c0             	movzbl %al,%eax
  800fa3:	29 c2                	sub    %eax,%edx
  800fa5:	89 d0                	mov    %edx,%eax
  800fa7:	eb 18                	jmp    800fc1 <memcmp+0x50>
		s1++, s2++;
  800fa9:	ff 45 fc             	incl   -0x4(%ebp)
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800faf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fb5:	89 55 10             	mov    %edx,0x10(%ebp)
  800fb8:	85 c0                	test   %eax,%eax
  800fba:	75 c9                	jne    800f85 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    

00800fc3 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd4:	eb 15                	jmp    800feb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	0f b6 d0             	movzbl %al,%edx
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	0f b6 c0             	movzbl %al,%eax
  800fe4:	39 c2                	cmp    %eax,%edx
  800fe6:	74 0d                	je     800ff5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fe8:	ff 45 08             	incl   0x8(%ebp)
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff1:	72 e3                	jb     800fd6 <memfind+0x13>
  800ff3:	eb 01                	jmp    800ff6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ff5:	90                   	nop
	return (void *) s;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801001:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801008:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80100f:	eb 03                	jmp    801014 <strtol+0x19>
		s++;
  801011:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 20                	cmp    $0x20,%al
  80101b:	74 f4                	je     801011 <strtol+0x16>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 09                	cmp    $0x9,%al
  801024:	74 eb                	je     801011 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 2b                	cmp    $0x2b,%al
  80102d:	75 05                	jne    801034 <strtol+0x39>
		s++;
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	eb 13                	jmp    801047 <strtol+0x4c>
	else if (*s == '-')
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	8a 00                	mov    (%eax),%al
  801039:	3c 2d                	cmp    $0x2d,%al
  80103b:	75 0a                	jne    801047 <strtol+0x4c>
		s++, neg = 1;
  80103d:	ff 45 08             	incl   0x8(%ebp)
  801040:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801047:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104b:	74 06                	je     801053 <strtol+0x58>
  80104d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801051:	75 20                	jne    801073 <strtol+0x78>
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	3c 30                	cmp    $0x30,%al
  80105a:	75 17                	jne    801073 <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	40                   	inc    %eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	3c 78                	cmp    $0x78,%al
  801064:	75 0d                	jne    801073 <strtol+0x78>
		s += 2, base = 16;
  801066:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801071:	eb 28                	jmp    80109b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801073:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801077:	75 15                	jne    80108e <strtol+0x93>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	3c 30                	cmp    $0x30,%al
  801080:	75 0c                	jne    80108e <strtol+0x93>
		s++, base = 8;
  801082:	ff 45 08             	incl   0x8(%ebp)
  801085:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80108c:	eb 0d                	jmp    80109b <strtol+0xa0>
	else if (base == 0)
  80108e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801092:	75 07                	jne    80109b <strtol+0xa0>
		base = 10;
  801094:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8a 00                	mov    (%eax),%al
  8010a0:	3c 2f                	cmp    $0x2f,%al
  8010a2:	7e 19                	jle    8010bd <strtol+0xc2>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 39                	cmp    $0x39,%al
  8010ab:	7f 10                	jg     8010bd <strtol+0xc2>
			dig = *s - '0';
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	0f be c0             	movsbl %al,%eax
  8010b5:	83 e8 30             	sub    $0x30,%eax
  8010b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010bb:	eb 42                	jmp    8010ff <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 60                	cmp    $0x60,%al
  8010c4:	7e 19                	jle    8010df <strtol+0xe4>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 7a                	cmp    $0x7a,%al
  8010cd:	7f 10                	jg     8010df <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f be c0             	movsbl %al,%eax
  8010d7:	83 e8 57             	sub    $0x57,%eax
  8010da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010dd:	eb 20                	jmp    8010ff <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 40                	cmp    $0x40,%al
  8010e6:	7e 39                	jle    801121 <strtol+0x126>
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 5a                	cmp    $0x5a,%al
  8010ef:	7f 30                	jg     801121 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	0f be c0             	movsbl %al,%eax
  8010f9:	83 e8 37             	sub    $0x37,%eax
  8010fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801102:	3b 45 10             	cmp    0x10(%ebp),%eax
  801105:	7d 19                	jge    801120 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801107:	ff 45 08             	incl   0x8(%ebp)
  80110a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110d:	0f af 45 10          	imul   0x10(%ebp),%eax
  801111:	89 c2                	mov    %eax,%edx
  801113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80111b:	e9 7b ff ff ff       	jmp    80109b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801120:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801121:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801125:	74 08                	je     80112f <strtol+0x134>
		*endptr = (char *) s;
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80112f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801133:	74 07                	je     80113c <strtol+0x141>
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	f7 d8                	neg    %eax
  80113a:	eb 03                	jmp    80113f <strtol+0x144>
  80113c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80113f:	c9                   	leave  
  801140:	c3                   	ret    

00801141 <ltostr>:

void
ltostr(long value, char *str)
{
  801141:	55                   	push   %ebp
  801142:	89 e5                	mov    %esp,%ebp
  801144:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801147:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80114e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801159:	79 13                	jns    80116e <ltostr+0x2d>
	{
		neg = 1;
  80115b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801168:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80116b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801176:	99                   	cltd   
  801177:	f7 f9                	idiv   %ecx
  801179:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80117c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80117f:	8d 50 01             	lea    0x1(%eax),%edx
  801182:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801185:	89 c2                	mov    %eax,%edx
  801187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118a:	01 d0                	add    %edx,%eax
  80118c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80118f:	83 c2 30             	add    $0x30,%edx
  801192:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801194:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801197:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80119c:	f7 e9                	imul   %ecx
  80119e:	c1 fa 02             	sar    $0x2,%edx
  8011a1:	89 c8                	mov    %ecx,%eax
  8011a3:	c1 f8 1f             	sar    $0x1f,%eax
  8011a6:	29 c2                	sub    %eax,%edx
  8011a8:	89 d0                	mov    %edx,%eax
  8011aa:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	c1 e0 02             	shl    $0x2,%eax
  8011c6:	01 d0                	add    %edx,%eax
  8011c8:	01 c0                	add    %eax,%eax
  8011ca:	29 c1                	sub    %eax,%ecx
  8011cc:	89 ca                	mov    %ecx,%edx
  8011ce:	85 d2                	test   %edx,%edx
  8011d0:	75 9c                	jne    80116e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011dc:	48                   	dec    %eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e4:	74 3d                	je     801223 <ltostr+0xe2>
		start = 1 ;
  8011e6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ed:	eb 34                	jmp    801223 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801202:	01 c2                	add    %eax,%edx
  801204:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	01 c8                	add    %ecx,%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801210:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	01 c2                	add    %eax,%edx
  801218:	8a 45 eb             	mov    -0x15(%ebp),%al
  80121b:	88 02                	mov    %al,(%edx)
		start++ ;
  80121d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801220:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801229:	7c c4                	jl     8011ef <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80122b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80122e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801231:	01 d0                	add    %edx,%eax
  801233:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801236:	90                   	nop
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80123f:	ff 75 08             	pushl  0x8(%ebp)
  801242:	e8 54 fa ff ff       	call   800c9b <strlen>
  801247:	83 c4 04             	add    $0x4,%esp
  80124a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80124d:	ff 75 0c             	pushl  0xc(%ebp)
  801250:	e8 46 fa ff ff       	call   800c9b <strlen>
  801255:	83 c4 04             	add    $0x4,%esp
  801258:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80125b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801262:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801269:	eb 17                	jmp    801282 <strcconcat+0x49>
		final[s] = str1[s] ;
  80126b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	01 c2                	add    %eax,%edx
  801273:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	01 c8                	add    %ecx,%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80127f:	ff 45 fc             	incl   -0x4(%ebp)
  801282:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801285:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801288:	7c e1                	jl     80126b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801291:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801298:	eb 1f                	jmp    8012b9 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8d 50 01             	lea    0x1(%eax),%edx
  8012a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a8:	01 c2                	add    %eax,%edx
  8012aa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b0:	01 c8                	add    %ecx,%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012b6:	ff 45 f8             	incl   -0x8(%ebp)
  8012b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012bf:	7c d9                	jl     80129a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c7:	01 d0                	add    %edx,%eax
  8012c9:	c6 00 00             	movb   $0x0,(%eax)
}
  8012cc:	90                   	nop
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	8b 00                	mov    (%eax),%eax
  8012e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f2:	eb 0c                	jmp    801300 <strsplit+0x31>
			*string++ = 0;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8a 00                	mov    (%eax),%al
  801305:	84 c0                	test   %al,%al
  801307:	74 18                	je     801321 <strsplit+0x52>
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	0f be c0             	movsbl %al,%eax
  801311:	50                   	push   %eax
  801312:	ff 75 0c             	pushl  0xc(%ebp)
  801315:	e8 13 fb ff ff       	call   800e2d <strchr>
  80131a:	83 c4 08             	add    $0x8,%esp
  80131d:	85 c0                	test   %eax,%eax
  80131f:	75 d3                	jne    8012f4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	84 c0                	test   %al,%al
  801328:	74 5a                	je     801384 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132a:	8b 45 14             	mov    0x14(%ebp),%eax
  80132d:	8b 00                	mov    (%eax),%eax
  80132f:	83 f8 0f             	cmp    $0xf,%eax
  801332:	75 07                	jne    80133b <strsplit+0x6c>
		{
			return 0;
  801334:	b8 00 00 00 00       	mov    $0x0,%eax
  801339:	eb 66                	jmp    8013a1 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80133b:	8b 45 14             	mov    0x14(%ebp),%eax
  80133e:	8b 00                	mov    (%eax),%eax
  801340:	8d 48 01             	lea    0x1(%eax),%ecx
  801343:	8b 55 14             	mov    0x14(%ebp),%edx
  801346:	89 0a                	mov    %ecx,(%edx)
  801348:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80134f:	8b 45 10             	mov    0x10(%ebp),%eax
  801352:	01 c2                	add    %eax,%edx
  801354:	8b 45 08             	mov    0x8(%ebp),%eax
  801357:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801359:	eb 03                	jmp    80135e <strsplit+0x8f>
			string++;
  80135b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 8b                	je     8012f2 <strsplit+0x23>
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	0f be c0             	movsbl %al,%eax
  80136f:	50                   	push   %eax
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	e8 b5 fa ff ff       	call   800e2d <strchr>
  801378:	83 c4 08             	add    $0x8,%esp
  80137b:	85 c0                	test   %eax,%eax
  80137d:	74 dc                	je     80135b <strsplit+0x8c>
			string++;
	}
  80137f:	e9 6e ff ff ff       	jmp    8012f2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801384:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801385:	8b 45 14             	mov    0x14(%ebp),%eax
  801388:	8b 00                	mov    (%eax),%eax
  80138a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801391:	8b 45 10             	mov    0x10(%ebp),%eax
  801394:	01 d0                	add    %edx,%eax
  801396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80139c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    

008013a3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a3:	55                   	push   %ebp
  8013a4:	89 e5                	mov    %esp,%ebp
  8013a6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8013a9:	83 ec 04             	sub    $0x4,%esp
  8013ac:	68 30 24 80 00       	push   $0x802430
  8013b1:	6a 0e                	push   $0xe
  8013b3:	68 6a 24 80 00       	push   $0x80246a
  8013b8:	e8 a8 ef ff ff       	call   800365 <_panic>

008013bd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  8013bd:	55                   	push   %ebp
  8013be:	89 e5                	mov    %esp,%ebp
  8013c0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  8013c3:	a1 04 30 80 00       	mov    0x803004,%eax
  8013c8:	85 c0                	test   %eax,%eax
  8013ca:	74 0f                	je     8013db <malloc+0x1e>
	{
		initialize_dyn_block_system();
  8013cc:	e8 d2 ff ff ff       	call   8013a3 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d1:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  8013d8:	00 00 00 
	}
	if (size == 0) return NULL ;
  8013db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013df:	75 07                	jne    8013e8 <malloc+0x2b>
  8013e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e6:	eb 14                	jmp    8013fc <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	68 78 24 80 00       	push   $0x802478
  8013f0:	6a 2e                	push   $0x2e
  8013f2:	68 6a 24 80 00       	push   $0x80246a
  8013f7:	e8 69 ef ff ff       	call   800365 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801404:	83 ec 04             	sub    $0x4,%esp
  801407:	68 a0 24 80 00       	push   $0x8024a0
  80140c:	6a 49                	push   $0x49
  80140e:	68 6a 24 80 00       	push   $0x80246a
  801413:	e8 4d ef ff ff       	call   800365 <_panic>

00801418 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	83 ec 18             	sub    $0x18,%esp
  80141e:	8b 45 10             	mov    0x10(%ebp),%eax
  801421:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801424:	83 ec 04             	sub    $0x4,%esp
  801427:	68 c4 24 80 00       	push   $0x8024c4
  80142c:	6a 57                	push   $0x57
  80142e:	68 6a 24 80 00       	push   $0x80246a
  801433:	e8 2d ef ff ff       	call   800365 <_panic>

00801438 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801438:	55                   	push   %ebp
  801439:	89 e5                	mov    %esp,%ebp
  80143b:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	68 ec 24 80 00       	push   $0x8024ec
  801446:	6a 60                	push   $0x60
  801448:	68 6a 24 80 00       	push   $0x80246a
  80144d:	e8 13 ef ff ff       	call   800365 <_panic>

00801452 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801458:	83 ec 04             	sub    $0x4,%esp
  80145b:	68 10 25 80 00       	push   $0x802510
  801460:	6a 7c                	push   $0x7c
  801462:	68 6a 24 80 00       	push   $0x80246a
  801467:	e8 f9 ee ff ff       	call   800365 <_panic>

0080146c <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	68 38 25 80 00       	push   $0x802538
  80147a:	68 86 00 00 00       	push   $0x86
  80147f:	68 6a 24 80 00       	push   $0x80246a
  801484:	e8 dc ee ff ff       	call   800365 <_panic>

00801489 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80148f:	83 ec 04             	sub    $0x4,%esp
  801492:	68 5c 25 80 00       	push   $0x80255c
  801497:	68 91 00 00 00       	push   $0x91
  80149c:	68 6a 24 80 00       	push   $0x80246a
  8014a1:	e8 bf ee ff ff       	call   800365 <_panic>

008014a6 <shrink>:

}
void shrink(uint32 newSize)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	68 5c 25 80 00       	push   $0x80255c
  8014b4:	68 96 00 00 00       	push   $0x96
  8014b9:	68 6a 24 80 00       	push   $0x80246a
  8014be:	e8 a2 ee ff ff       	call   800365 <_panic>

008014c3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	68 5c 25 80 00       	push   $0x80255c
  8014d1:	68 9b 00 00 00       	push   $0x9b
  8014d6:	68 6a 24 80 00       	push   $0x80246a
  8014db:	e8 85 ee ff ff       	call   800365 <_panic>

008014e0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	57                   	push   %edi
  8014e4:	56                   	push   %esi
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014f5:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014f8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014fb:	cd 30                	int    $0x30
  8014fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	5b                   	pop    %ebx
  801507:	5e                   	pop    %esi
  801508:	5f                   	pop    %edi
  801509:	5d                   	pop    %ebp
  80150a:	c3                   	ret    

0080150b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	8b 45 10             	mov    0x10(%ebp),%eax
  801514:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801517:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	52                   	push   %edx
  801523:	ff 75 0c             	pushl  0xc(%ebp)
  801526:	50                   	push   %eax
  801527:	6a 00                	push   $0x0
  801529:	e8 b2 ff ff ff       	call   8014e0 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
}
  801531:	90                   	nop
  801532:	c9                   	leave  
  801533:	c3                   	ret    

00801534 <sys_cgetc>:

int
sys_cgetc(void)
{
  801534:	55                   	push   %ebp
  801535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 01                	push   $0x1
  801543:	e8 98 ff ff ff       	call   8014e0 <syscall>
  801548:	83 c4 18             	add    $0x18,%esp
}
  80154b:	c9                   	leave  
  80154c:	c3                   	ret    

0080154d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80154d:	55                   	push   %ebp
  80154e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801550:	8b 55 0c             	mov    0xc(%ebp),%edx
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	52                   	push   %edx
  80155d:	50                   	push   %eax
  80155e:	6a 05                	push   $0x5
  801560:	e8 7b ff ff ff       	call   8014e0 <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80156f:	8b 75 18             	mov    0x18(%ebp),%esi
  801572:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801575:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801578:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157b:	8b 45 08             	mov    0x8(%ebp),%eax
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
  801580:	51                   	push   %ecx
  801581:	52                   	push   %edx
  801582:	50                   	push   %eax
  801583:	6a 06                	push   $0x6
  801585:	e8 56 ff ff ff       	call   8014e0 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801597:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	52                   	push   %edx
  8015a4:	50                   	push   %eax
  8015a5:	6a 07                	push   $0x7
  8015a7:	e8 34 ff ff ff       	call   8014e0 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	6a 08                	push   $0x8
  8015c2:	e8 19 ff ff ff       	call   8014e0 <syscall>
  8015c7:	83 c4 18             	add    $0x18,%esp
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 09                	push   $0x9
  8015db:	e8 00 ff ff ff       	call   8014e0 <syscall>
  8015e0:	83 c4 18             	add    $0x18,%esp
}
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 0a                	push   $0xa
  8015f4:	e8 e7 fe ff ff       	call   8014e0 <syscall>
  8015f9:	83 c4 18             	add    $0x18,%esp
}
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801601:	6a 00                	push   $0x0
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 0b                	push   $0xb
  80160d:	e8 ce fe ff ff       	call   8014e0 <syscall>
  801612:	83 c4 18             	add    $0x18,%esp
}
  801615:	c9                   	leave  
  801616:	c3                   	ret    

00801617 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80161a:	6a 00                	push   $0x0
  80161c:	6a 00                	push   $0x0
  80161e:	6a 00                	push   $0x0
  801620:	ff 75 0c             	pushl  0xc(%ebp)
  801623:	ff 75 08             	pushl  0x8(%ebp)
  801626:	6a 0f                	push   $0xf
  801628:	e8 b3 fe ff ff       	call   8014e0 <syscall>
  80162d:	83 c4 18             	add    $0x18,%esp
	return;
  801630:	90                   	nop
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	ff 75 0c             	pushl  0xc(%ebp)
  80163f:	ff 75 08             	pushl  0x8(%ebp)
  801642:	6a 10                	push   $0x10
  801644:	e8 97 fe ff ff       	call   8014e0 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
	return ;
  80164c:	90                   	nop
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	ff 75 10             	pushl  0x10(%ebp)
  801659:	ff 75 0c             	pushl  0xc(%ebp)
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	6a 11                	push   $0x11
  801661:	e8 7a fe ff ff       	call   8014e0 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
	return ;
  801669:	90                   	nop
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	6a 00                	push   $0x0
  801679:	6a 0c                	push   $0xc
  80167b:	e8 60 fe ff ff       	call   8014e0 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	ff 75 08             	pushl  0x8(%ebp)
  801693:	6a 0d                	push   $0xd
  801695:	e8 46 fe ff ff       	call   8014e0 <syscall>
  80169a:	83 c4 18             	add    $0x18,%esp
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 0e                	push   $0xe
  8016ae:	e8 2d fe ff ff       	call   8014e0 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
}
  8016b6:	90                   	nop
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 13                	push   $0x13
  8016c8:	e8 13 fe ff ff       	call   8014e0 <syscall>
  8016cd:	83 c4 18             	add    $0x18,%esp
}
  8016d0:	90                   	nop
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 14                	push   $0x14
  8016e2:	e8 f9 fd ff ff       	call   8014e0 <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_cputc>:


void
sys_cputc(const char c)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	6a 00                	push   $0x0
  801705:	50                   	push   %eax
  801706:	6a 15                	push   $0x15
  801708:	e8 d3 fd ff ff       	call   8014e0 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	90                   	nop
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 16                	push   $0x16
  801722:	e8 b9 fd ff ff       	call   8014e0 <syscall>
  801727:	83 c4 18             	add    $0x18,%esp
}
  80172a:	90                   	nop
  80172b:	c9                   	leave  
  80172c:	c3                   	ret    

0080172d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801730:	8b 45 08             	mov    0x8(%ebp),%eax
  801733:	6a 00                	push   $0x0
  801735:	6a 00                	push   $0x0
  801737:	6a 00                	push   $0x0
  801739:	ff 75 0c             	pushl  0xc(%ebp)
  80173c:	50                   	push   %eax
  80173d:	6a 17                	push   $0x17
  80173f:	e8 9c fd ff ff       	call   8014e0 <syscall>
  801744:	83 c4 18             	add    $0x18,%esp
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80174c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	6a 1a                	push   $0x1a
  80175c:	e8 7f fd ff ff       	call   8014e0 <syscall>
  801761:	83 c4 18             	add    $0x18,%esp
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	52                   	push   %edx
  801776:	50                   	push   %eax
  801777:	6a 18                	push   $0x18
  801779:	e8 62 fd ff ff       	call   8014e0 <syscall>
  80177e:	83 c4 18             	add    $0x18,%esp
}
  801781:	90                   	nop
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	52                   	push   %edx
  801794:	50                   	push   %eax
  801795:	6a 19                	push   $0x19
  801797:	e8 44 fd ff ff       	call   8014e0 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
}
  80179f:	90                   	nop
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017b1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	51                   	push   %ecx
  8017bb:	52                   	push   %edx
  8017bc:	ff 75 0c             	pushl  0xc(%ebp)
  8017bf:	50                   	push   %eax
  8017c0:	6a 1b                	push   $0x1b
  8017c2:	e8 19 fd ff ff       	call   8014e0 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	52                   	push   %edx
  8017dc:	50                   	push   %eax
  8017dd:	6a 1c                	push   $0x1c
  8017df:	e8 fc fc ff ff       	call   8014e0 <syscall>
  8017e4:	83 c4 18             	add    $0x18,%esp
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	51                   	push   %ecx
  8017fa:	52                   	push   %edx
  8017fb:	50                   	push   %eax
  8017fc:	6a 1d                	push   $0x1d
  8017fe:	e8 dd fc ff ff       	call   8014e0 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80180b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180e:	8b 45 08             	mov    0x8(%ebp),%eax
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	52                   	push   %edx
  801818:	50                   	push   %eax
  801819:	6a 1e                	push   $0x1e
  80181b:	e8 c0 fc ff ff       	call   8014e0 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 1f                	push   $0x1f
  801834:	e8 a7 fc ff ff       	call   8014e0 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	6a 00                	push   $0x0
  801846:	ff 75 14             	pushl  0x14(%ebp)
  801849:	ff 75 10             	pushl  0x10(%ebp)
  80184c:	ff 75 0c             	pushl  0xc(%ebp)
  80184f:	50                   	push   %eax
  801850:	6a 20                	push   $0x20
  801852:	e8 89 fc ff ff       	call   8014e0 <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
}
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	50                   	push   %eax
  80186b:	6a 21                	push   $0x21
  80186d:	e8 6e fc ff ff       	call   8014e0 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	90                   	nop
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	50                   	push   %eax
  801887:	6a 22                	push   $0x22
  801889:	e8 52 fc ff ff       	call   8014e0 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 02                	push   $0x2
  8018a2:	e8 39 fc ff ff       	call   8014e0 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 03                	push   $0x3
  8018bb:	e8 20 fc ff ff       	call   8014e0 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 04                	push   $0x4
  8018d4:	e8 07 fc ff ff       	call   8014e0 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_exit_env>:


void sys_exit_env(void)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 23                	push   $0x23
  8018ed:	e8 ee fb ff ff       	call   8014e0 <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	90                   	nop
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018fe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801901:	8d 50 04             	lea    0x4(%eax),%edx
  801904:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	52                   	push   %edx
  80190e:	50                   	push   %eax
  80190f:	6a 24                	push   $0x24
  801911:	e8 ca fb ff ff       	call   8014e0 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
	return result;
  801919:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80191c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801922:	89 01                	mov    %eax,(%ecx)
  801924:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	c9                   	leave  
  80192b:	c2 04 00             	ret    $0x4

0080192e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	ff 75 10             	pushl  0x10(%ebp)
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	6a 12                	push   $0x12
  801940:	e8 9b fb ff ff       	call   8014e0 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_rcr2>:
uint32 sys_rcr2()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 25                	push   $0x25
  80195a:	e8 81 fb ff ff       	call   8014e0 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801970:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	50                   	push   %eax
  80197d:	6a 26                	push   $0x26
  80197f:	e8 5c fb ff ff       	call   8014e0 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
	return ;
  801987:	90                   	nop
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <rsttst>:
void rsttst()
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 28                	push   $0x28
  801999:	e8 42 fb ff ff       	call   8014e0 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019b0:	8b 55 18             	mov    0x18(%ebp),%edx
  8019b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	ff 75 10             	pushl  0x10(%ebp)
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	6a 27                	push   $0x27
  8019c4:	e8 17 fb ff ff       	call   8014e0 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cc:	90                   	nop
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <chktst>:
void chktst(uint32 n)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	ff 75 08             	pushl  0x8(%ebp)
  8019dd:	6a 29                	push   $0x29
  8019df:	e8 fc fa ff ff       	call   8014e0 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <inctst>:

void inctst()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 2a                	push   $0x2a
  8019f9:	e8 e2 fa ff ff       	call   8014e0 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <gettst>:
uint32 gettst()
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 2b                	push   $0x2b
  801a13:	e8 c8 fa ff ff       	call   8014e0 <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 2c                	push   $0x2c
  801a2f:	e8 ac fa ff ff       	call   8014e0 <syscall>
  801a34:	83 c4 18             	add    $0x18,%esp
  801a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a3a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a3e:	75 07                	jne    801a47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a40:	b8 01 00 00 00       	mov    $0x1,%eax
  801a45:	eb 05                	jmp    801a4c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
  801a51:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 2c                	push   $0x2c
  801a60:	e8 7b fa ff ff       	call   8014e0 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
  801a68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a6b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a6f:	75 07                	jne    801a78 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a71:	b8 01 00 00 00       	mov    $0x1,%eax
  801a76:	eb 05                	jmp    801a7d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 2c                	push   $0x2c
  801a91:	e8 4a fa ff ff       	call   8014e0 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
  801a99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a9c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801aa0:	75 07                	jne    801aa9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa7:	eb 05                	jmp    801aae <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aa9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 2c                	push   $0x2c
  801ac2:	e8 19 fa ff ff       	call   8014e0 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
  801aca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801acd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ad1:	75 07                	jne    801ada <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ad3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad8:	eb 05                	jmp    801adf <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ada:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	ff 75 08             	pushl  0x8(%ebp)
  801aef:	6a 2d                	push   $0x2d
  801af1:	e8 ea f9 ff ff       	call   8014e0 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
	return ;
  801af9:	90                   	nop
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b00:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	53                   	push   %ebx
  801b0f:	51                   	push   %ecx
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 2e                	push   $0x2e
  801b14:	e8 c7 f9 ff ff       	call   8014e0 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 2f                	push   $0x2f
  801b34:	e8 a7 f9 ff ff       	call   8014e0 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    
  801b3e:	66 90                	xchg   %ax,%ax

00801b40 <__udivdi3>:
  801b40:	55                   	push   %ebp
  801b41:	57                   	push   %edi
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
  801b47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b57:	89 ca                	mov    %ecx,%edx
  801b59:	89 f8                	mov    %edi,%eax
  801b5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b5f:	85 f6                	test   %esi,%esi
  801b61:	75 2d                	jne    801b90 <__udivdi3+0x50>
  801b63:	39 cf                	cmp    %ecx,%edi
  801b65:	77 65                	ja     801bcc <__udivdi3+0x8c>
  801b67:	89 fd                	mov    %edi,%ebp
  801b69:	85 ff                	test   %edi,%edi
  801b6b:	75 0b                	jne    801b78 <__udivdi3+0x38>
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	31 d2                	xor    %edx,%edx
  801b74:	f7 f7                	div    %edi
  801b76:	89 c5                	mov    %eax,%ebp
  801b78:	31 d2                	xor    %edx,%edx
  801b7a:	89 c8                	mov    %ecx,%eax
  801b7c:	f7 f5                	div    %ebp
  801b7e:	89 c1                	mov    %eax,%ecx
  801b80:	89 d8                	mov    %ebx,%eax
  801b82:	f7 f5                	div    %ebp
  801b84:	89 cf                	mov    %ecx,%edi
  801b86:	89 fa                	mov    %edi,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	39 ce                	cmp    %ecx,%esi
  801b92:	77 28                	ja     801bbc <__udivdi3+0x7c>
  801b94:	0f bd fe             	bsr    %esi,%edi
  801b97:	83 f7 1f             	xor    $0x1f,%edi
  801b9a:	75 40                	jne    801bdc <__udivdi3+0x9c>
  801b9c:	39 ce                	cmp    %ecx,%esi
  801b9e:	72 0a                	jb     801baa <__udivdi3+0x6a>
  801ba0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ba4:	0f 87 9e 00 00 00    	ja     801c48 <__udivdi3+0x108>
  801baa:	b8 01 00 00 00       	mov    $0x1,%eax
  801baf:	89 fa                	mov    %edi,%edx
  801bb1:	83 c4 1c             	add    $0x1c,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5f                   	pop    %edi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    
  801bb9:	8d 76 00             	lea    0x0(%esi),%esi
  801bbc:	31 ff                	xor    %edi,%edi
  801bbe:	31 c0                	xor    %eax,%eax
  801bc0:	89 fa                	mov    %edi,%edx
  801bc2:	83 c4 1c             	add    $0x1c,%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5f                   	pop    %edi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	f7 f7                	div    %edi
  801bd0:	31 ff                	xor    %edi,%edi
  801bd2:	89 fa                	mov    %edi,%edx
  801bd4:	83 c4 1c             	add    $0x1c,%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
  801bdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801be1:	89 eb                	mov    %ebp,%ebx
  801be3:	29 fb                	sub    %edi,%ebx
  801be5:	89 f9                	mov    %edi,%ecx
  801be7:	d3 e6                	shl    %cl,%esi
  801be9:	89 c5                	mov    %eax,%ebp
  801beb:	88 d9                	mov    %bl,%cl
  801bed:	d3 ed                	shr    %cl,%ebp
  801bef:	89 e9                	mov    %ebp,%ecx
  801bf1:	09 f1                	or     %esi,%ecx
  801bf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bf7:	89 f9                	mov    %edi,%ecx
  801bf9:	d3 e0                	shl    %cl,%eax
  801bfb:	89 c5                	mov    %eax,%ebp
  801bfd:	89 d6                	mov    %edx,%esi
  801bff:	88 d9                	mov    %bl,%cl
  801c01:	d3 ee                	shr    %cl,%esi
  801c03:	89 f9                	mov    %edi,%ecx
  801c05:	d3 e2                	shl    %cl,%edx
  801c07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c0b:	88 d9                	mov    %bl,%cl
  801c0d:	d3 e8                	shr    %cl,%eax
  801c0f:	09 c2                	or     %eax,%edx
  801c11:	89 d0                	mov    %edx,%eax
  801c13:	89 f2                	mov    %esi,%edx
  801c15:	f7 74 24 0c          	divl   0xc(%esp)
  801c19:	89 d6                	mov    %edx,%esi
  801c1b:	89 c3                	mov    %eax,%ebx
  801c1d:	f7 e5                	mul    %ebp
  801c1f:	39 d6                	cmp    %edx,%esi
  801c21:	72 19                	jb     801c3c <__udivdi3+0xfc>
  801c23:	74 0b                	je     801c30 <__udivdi3+0xf0>
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	31 ff                	xor    %edi,%edi
  801c29:	e9 58 ff ff ff       	jmp    801b86 <__udivdi3+0x46>
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c34:	89 f9                	mov    %edi,%ecx
  801c36:	d3 e2                	shl    %cl,%edx
  801c38:	39 c2                	cmp    %eax,%edx
  801c3a:	73 e9                	jae    801c25 <__udivdi3+0xe5>
  801c3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c3f:	31 ff                	xor    %edi,%edi
  801c41:	e9 40 ff ff ff       	jmp    801b86 <__udivdi3+0x46>
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	31 c0                	xor    %eax,%eax
  801c4a:	e9 37 ff ff ff       	jmp    801b86 <__udivdi3+0x46>
  801c4f:	90                   	nop

00801c50 <__umoddi3>:
  801c50:	55                   	push   %ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 1c             	sub    $0x1c,%esp
  801c57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c6f:	89 f3                	mov    %esi,%ebx
  801c71:	89 fa                	mov    %edi,%edx
  801c73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c77:	89 34 24             	mov    %esi,(%esp)
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	75 1a                	jne    801c98 <__umoddi3+0x48>
  801c7e:	39 f7                	cmp    %esi,%edi
  801c80:	0f 86 a2 00 00 00    	jbe    801d28 <__umoddi3+0xd8>
  801c86:	89 c8                	mov    %ecx,%eax
  801c88:	89 f2                	mov    %esi,%edx
  801c8a:	f7 f7                	div    %edi
  801c8c:	89 d0                	mov    %edx,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	83 c4 1c             	add    $0x1c,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5f                   	pop    %edi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
  801c98:	39 f0                	cmp    %esi,%eax
  801c9a:	0f 87 ac 00 00 00    	ja     801d4c <__umoddi3+0xfc>
  801ca0:	0f bd e8             	bsr    %eax,%ebp
  801ca3:	83 f5 1f             	xor    $0x1f,%ebp
  801ca6:	0f 84 ac 00 00 00    	je     801d58 <__umoddi3+0x108>
  801cac:	bf 20 00 00 00       	mov    $0x20,%edi
  801cb1:	29 ef                	sub    %ebp,%edi
  801cb3:	89 fe                	mov    %edi,%esi
  801cb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cb9:	89 e9                	mov    %ebp,%ecx
  801cbb:	d3 e0                	shl    %cl,%eax
  801cbd:	89 d7                	mov    %edx,%edi
  801cbf:	89 f1                	mov    %esi,%ecx
  801cc1:	d3 ef                	shr    %cl,%edi
  801cc3:	09 c7                	or     %eax,%edi
  801cc5:	89 e9                	mov    %ebp,%ecx
  801cc7:	d3 e2                	shl    %cl,%edx
  801cc9:	89 14 24             	mov    %edx,(%esp)
  801ccc:	89 d8                	mov    %ebx,%eax
  801cce:	d3 e0                	shl    %cl,%eax
  801cd0:	89 c2                	mov    %eax,%edx
  801cd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd6:	d3 e0                	shl    %cl,%eax
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce0:	89 f1                	mov    %esi,%ecx
  801ce2:	d3 e8                	shr    %cl,%eax
  801ce4:	09 d0                	or     %edx,%eax
  801ce6:	d3 eb                	shr    %cl,%ebx
  801ce8:	89 da                	mov    %ebx,%edx
  801cea:	f7 f7                	div    %edi
  801cec:	89 d3                	mov    %edx,%ebx
  801cee:	f7 24 24             	mull   (%esp)
  801cf1:	89 c6                	mov    %eax,%esi
  801cf3:	89 d1                	mov    %edx,%ecx
  801cf5:	39 d3                	cmp    %edx,%ebx
  801cf7:	0f 82 87 00 00 00    	jb     801d84 <__umoddi3+0x134>
  801cfd:	0f 84 91 00 00 00    	je     801d94 <__umoddi3+0x144>
  801d03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d07:	29 f2                	sub    %esi,%edx
  801d09:	19 cb                	sbb    %ecx,%ebx
  801d0b:	89 d8                	mov    %ebx,%eax
  801d0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d11:	d3 e0                	shl    %cl,%eax
  801d13:	89 e9                	mov    %ebp,%ecx
  801d15:	d3 ea                	shr    %cl,%edx
  801d17:	09 d0                	or     %edx,%eax
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 eb                	shr    %cl,%ebx
  801d1d:	89 da                	mov    %ebx,%edx
  801d1f:	83 c4 1c             	add    $0x1c,%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    
  801d27:	90                   	nop
  801d28:	89 fd                	mov    %edi,%ebp
  801d2a:	85 ff                	test   %edi,%edi
  801d2c:	75 0b                	jne    801d39 <__umoddi3+0xe9>
  801d2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d33:	31 d2                	xor    %edx,%edx
  801d35:	f7 f7                	div    %edi
  801d37:	89 c5                	mov    %eax,%ebp
  801d39:	89 f0                	mov    %esi,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	f7 f5                	div    %ebp
  801d3f:	89 c8                	mov    %ecx,%eax
  801d41:	f7 f5                	div    %ebp
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	e9 44 ff ff ff       	jmp    801c8e <__umoddi3+0x3e>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	89 c8                	mov    %ecx,%eax
  801d4e:	89 f2                	mov    %esi,%edx
  801d50:	83 c4 1c             	add    $0x1c,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
  801d58:	3b 04 24             	cmp    (%esp),%eax
  801d5b:	72 06                	jb     801d63 <__umoddi3+0x113>
  801d5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d61:	77 0f                	ja     801d72 <__umoddi3+0x122>
  801d63:	89 f2                	mov    %esi,%edx
  801d65:	29 f9                	sub    %edi,%ecx
  801d67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d6b:	89 14 24             	mov    %edx,(%esp)
  801d6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d76:	8b 14 24             	mov    (%esp),%edx
  801d79:	83 c4 1c             	add    $0x1c,%esp
  801d7c:	5b                   	pop    %ebx
  801d7d:	5e                   	pop    %esi
  801d7e:	5f                   	pop    %edi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    
  801d81:	8d 76 00             	lea    0x0(%esi),%esi
  801d84:	2b 04 24             	sub    (%esp),%eax
  801d87:	19 fa                	sbb    %edi,%edx
  801d89:	89 d1                	mov    %edx,%ecx
  801d8b:	89 c6                	mov    %eax,%esi
  801d8d:	e9 71 ff ff ff       	jmp    801d03 <__umoddi3+0xb3>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d98:	72 ea                	jb     801d84 <__umoddi3+0x134>
  801d9a:	89 d9                	mov    %ebx,%ecx
  801d9c:	e9 62 ff ff ff       	jmp    801d03 <__umoddi3+0xb3>
