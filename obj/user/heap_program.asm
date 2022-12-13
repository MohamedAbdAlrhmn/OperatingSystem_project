
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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
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
  800066:	e8 4f 15 00 00       	call   8015ba <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 3e 15 00 00       	call   8015ba <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 80 18 00 00       	call   801907 <sys_pf_calculate_allocated_pages>
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

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 f7 14 00 00       	call   8015e8 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 e9 14 00 00       	call   8015e8 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 60 17 00 00       	call   801867 <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 a5 14 00 00       	call   8015ba <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 9c 37 80 00       	mov    $0x80379c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 50 80 00       	mov    0x805020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 a0 36 80 00       	push   $0x8036a0
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 01 37 80 00       	push   $0x803701
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 6a 16 00 00       	call   801867 <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 59 16 00 00       	call   801867 <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 18 37 80 00       	push   $0x803718
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 01 37 80 00       	push   $0x803701
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 5c 37 80 00       	push   $0x80375c
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 fa 18 00 00       	call   801b47 <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 50 80 00       	mov    0x805020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 9c 16 00 00       	call   801954 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 d0 37 80 00       	push   $0x8037d0
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 f8 37 80 00       	push   $0x8037f8
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 50 80 00       	mov    0x805020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 20 38 80 00       	push   $0x803820
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 50 80 00       	mov    0x805020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 78 38 80 00       	push   $0x803878
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 d0 37 80 00       	push   $0x8037d0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 1c 16 00 00       	call   80196e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 a9 17 00 00       	call   801b13 <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 fe 17 00 00       	call   801b79 <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 8c 38 80 00       	push   $0x80388c
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 50 80 00       	mov    0x805000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 91 38 80 00       	push   $0x803891
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 ad 38 80 00       	push   $0x8038ad
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 b0 38 80 00       	push   $0x8038b0
  80040d:	6a 26                	push   $0x26
  80040f:	68 fc 38 80 00       	push   $0x8038fc
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 50 80 00       	mov    0x805020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 08 39 80 00       	push   $0x803908
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 fc 38 80 00       	push   $0x8038fc
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 50 80 00       	mov    0x805020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 50 80 00       	mov    0x805020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 5c 39 80 00       	push   $0x80395c
  80054f:	6a 44                	push   $0x44
  800551:	68 fc 38 80 00       	push   $0x8038fc
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 50 80 00       	mov    0x805024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 fd 11 00 00       	call   8017a6 <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 50 80 00       	mov    0x805024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 86 11 00 00       	call   8017a6 <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 ea 12 00 00       	call   801954 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 e4 12 00 00       	call   80196e <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 58 2d 00 00       	call   80342c <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 18 2e 00 00       	call   80353c <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 d4 3b 80 00       	add    $0x803bd4,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 e5 3b 80 00       	push   $0x803be5
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 ee 3b 80 00       	push   $0x803bee
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be f1 3b 80 00       	mov    $0x803bf1,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 50 80 00       	mov    0x805004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 50 3d 80 00       	push   $0x803d50
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8013f3:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8013fa:	00 00 00 
  8013fd:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801404:	00 00 00 
  801407:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80140e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801411:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801418:	00 00 00 
  80141b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801422:	00 00 00 
  801425:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80142c:	00 00 00 
	uint32 arr_size = 0;
  80142f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801436:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80143d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801440:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801445:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144a:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80144f:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801456:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801459:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801460:	a1 20 51 80 00       	mov    0x805120,%eax
  801465:	c1 e0 04             	shl    $0x4,%eax
  801468:	89 c2                	mov    %eax,%edx
  80146a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	48                   	dec    %eax
  801470:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801473:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801476:	ba 00 00 00 00       	mov    $0x0,%edx
  80147b:	f7 75 ec             	divl   -0x14(%ebp)
  80147e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801481:	29 d0                	sub    %edx,%eax
  801483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801486:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80148d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801490:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801495:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149a:	83 ec 04             	sub    $0x4,%esp
  80149d:	6a 06                	push   $0x6
  80149f:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a2:	50                   	push   %eax
  8014a3:	e8 42 04 00 00       	call   8018ea <sys_allocate_chunk>
  8014a8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ab:	a1 20 51 80 00       	mov    0x805120,%eax
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	50                   	push   %eax
  8014b4:	e8 b7 0a 00 00       	call   801f70 <initialize_MemBlocksList>
  8014b9:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8014c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014dc:	75 14                	jne    8014f2 <initialize_dyn_block_system+0x105>
  8014de:	83 ec 04             	sub    $0x4,%esp
  8014e1:	68 75 3d 80 00       	push   $0x803d75
  8014e6:	6a 33                	push   $0x33
  8014e8:	68 93 3d 80 00       	push   $0x803d93
  8014ed:	e8 8c ee ff ff       	call   80037e <_panic>
  8014f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f5:	8b 00                	mov    (%eax),%eax
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	74 10                	je     80150b <initialize_dyn_block_system+0x11e>
  8014fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fe:	8b 00                	mov    (%eax),%eax
  801500:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801503:	8b 52 04             	mov    0x4(%edx),%edx
  801506:	89 50 04             	mov    %edx,0x4(%eax)
  801509:	eb 0b                	jmp    801516 <initialize_dyn_block_system+0x129>
  80150b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150e:	8b 40 04             	mov    0x4(%eax),%eax
  801511:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801516:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801519:	8b 40 04             	mov    0x4(%eax),%eax
  80151c:	85 c0                	test   %eax,%eax
  80151e:	74 0f                	je     80152f <initialize_dyn_block_system+0x142>
  801520:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801523:	8b 40 04             	mov    0x4(%eax),%eax
  801526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801529:	8b 12                	mov    (%edx),%edx
  80152b:	89 10                	mov    %edx,(%eax)
  80152d:	eb 0a                	jmp    801539 <initialize_dyn_block_system+0x14c>
  80152f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801532:	8b 00                	mov    (%eax),%eax
  801534:	a3 48 51 80 00       	mov    %eax,0x805148
  801539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80154c:	a1 54 51 80 00       	mov    0x805154,%eax
  801551:	48                   	dec    %eax
  801552:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801557:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80155b:	75 14                	jne    801571 <initialize_dyn_block_system+0x184>
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	68 a0 3d 80 00       	push   $0x803da0
  801565:	6a 34                	push   $0x34
  801567:	68 93 3d 80 00       	push   $0x803d93
  80156c:	e8 0d ee ff ff       	call   80037e <_panic>
  801571:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157a:	89 10                	mov    %edx,(%eax)
  80157c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157f:	8b 00                	mov    (%eax),%eax
  801581:	85 c0                	test   %eax,%eax
  801583:	74 0d                	je     801592 <initialize_dyn_block_system+0x1a5>
  801585:	a1 38 51 80 00       	mov    0x805138,%eax
  80158a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80158d:	89 50 04             	mov    %edx,0x4(%eax)
  801590:	eb 08                	jmp    80159a <initialize_dyn_block_system+0x1ad>
  801592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801595:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80159a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159d:	a3 38 51 80 00       	mov    %eax,0x805138
  8015a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8015b1:	40                   	inc    %eax
  8015b2:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015b7:	90                   	nop
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c0:	e8 f7 fd ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8015c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c9:	75 07                	jne    8015d2 <malloc+0x18>
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 14                	jmp    8015e6 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	68 c4 3d 80 00       	push   $0x803dc4
  8015da:	6a 46                	push   $0x46
  8015dc:	68 93 3d 80 00       	push   $0x803d93
  8015e1:	e8 98 ed ff ff       	call   80037e <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015ee:	83 ec 04             	sub    $0x4,%esp
  8015f1:	68 ec 3d 80 00       	push   $0x803dec
  8015f6:	6a 61                	push   $0x61
  8015f8:	68 93 3d 80 00       	push   $0x803d93
  8015fd:	e8 7c ed ff ff       	call   80037e <_panic>

00801602 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 38             	sub    $0x38,%esp
  801608:	8b 45 10             	mov    0x10(%ebp),%eax
  80160b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160e:	e8 a9 fd ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  801613:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801617:	75 0a                	jne    801623 <smalloc+0x21>
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
  80161e:	e9 9e 00 00 00       	jmp    8016c1 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801623:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80162a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	48                   	dec    %eax
  801633:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801636:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	f7 75 f0             	divl   -0x10(%ebp)
  801641:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801644:	29 d0                	sub    %edx,%eax
  801646:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801649:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801650:	e8 63 06 00 00       	call   801cb8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801655:	85 c0                	test   %eax,%eax
  801657:	74 11                	je     80166a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801659:	83 ec 0c             	sub    $0xc,%esp
  80165c:	ff 75 e8             	pushl  -0x18(%ebp)
  80165f:	e8 ce 0c 00 00       	call   802332 <alloc_block_FF>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80166a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80166e:	74 4c                	je     8016bc <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801673:	8b 40 08             	mov    0x8(%eax),%eax
  801676:	89 c2                	mov    %eax,%edx
  801678:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80167c:	52                   	push   %edx
  80167d:	50                   	push   %eax
  80167e:	ff 75 0c             	pushl  0xc(%ebp)
  801681:	ff 75 08             	pushl  0x8(%ebp)
  801684:	e8 b4 03 00 00       	call   801a3d <sys_createSharedObject>
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	ff 75 e0             	pushl  -0x20(%ebp)
  801695:	68 0f 3e 80 00       	push   $0x803e0f
  80169a:	e8 93 ef ff ff       	call   800632 <cprintf>
  80169f:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016a2:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016a6:	74 14                	je     8016bc <smalloc+0xba>
  8016a8:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016ac:	74 0e                	je     8016bc <smalloc+0xba>
  8016ae:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016b2:	74 08                	je     8016bc <smalloc+0xba>
			return (void*) mem_block->sva;
  8016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b7:	8b 40 08             	mov    0x8(%eax),%eax
  8016ba:	eb 05                	jmp    8016c1 <smalloc+0xbf>
	}
	return NULL;
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c9:	e8 ee fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016ce:	83 ec 04             	sub    $0x4,%esp
  8016d1:	68 24 3e 80 00       	push   $0x803e24
  8016d6:	68 ab 00 00 00       	push   $0xab
  8016db:	68 93 3d 80 00       	push   $0x803d93
  8016e0:	e8 99 ec ff ff       	call   80037e <_panic>

008016e5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016eb:	e8 cc fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	68 48 3e 80 00       	push   $0x803e48
  8016f8:	68 ef 00 00 00       	push   $0xef
  8016fd:	68 93 3d 80 00       	push   $0x803d93
  801702:	e8 77 ec ff ff       	call   80037e <_panic>

00801707 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80170d:	83 ec 04             	sub    $0x4,%esp
  801710:	68 70 3e 80 00       	push   $0x803e70
  801715:	68 03 01 00 00       	push   $0x103
  80171a:	68 93 3d 80 00       	push   $0x803d93
  80171f:	e8 5a ec ff ff       	call   80037e <_panic>

00801724 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	68 94 3e 80 00       	push   $0x803e94
  801732:	68 0e 01 00 00       	push   $0x10e
  801737:	68 93 3d 80 00       	push   $0x803d93
  80173c:	e8 3d ec ff ff       	call   80037e <_panic>

00801741 <shrink>:

}
void shrink(uint32 newSize)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	68 94 3e 80 00       	push   $0x803e94
  80174f:	68 13 01 00 00       	push   $0x113
  801754:	68 93 3d 80 00       	push   $0x803d93
  801759:	e8 20 ec ff ff       	call   80037e <_panic>

0080175e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	68 94 3e 80 00       	push   $0x803e94
  80176c:	68 18 01 00 00       	push   $0x118
  801771:	68 93 3d 80 00       	push   $0x803d93
  801776:	e8 03 ec ff ff       	call   80037e <_panic>

0080177b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	57                   	push   %edi
  80177f:	56                   	push   %esi
  801780:	53                   	push   %ebx
  801781:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80178d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801790:	8b 7d 18             	mov    0x18(%ebp),%edi
  801793:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801796:	cd 30                	int    $0x30
  801798:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80179b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	5b                   	pop    %ebx
  8017a2:	5e                   	pop    %esi
  8017a3:	5f                   	pop    %edi
  8017a4:	5d                   	pop    %ebp
  8017a5:	c3                   	ret    

008017a6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 04             	sub    $0x4,%esp
  8017ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8017af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	52                   	push   %edx
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	50                   	push   %eax
  8017c2:	6a 00                	push   $0x0
  8017c4:	e8 b2 ff ff ff       	call   80177b <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
}
  8017cc:	90                   	nop
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_cgetc>:

int
sys_cgetc(void)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 01                	push   $0x1
  8017de:	e8 98 ff ff ff       	call   80177b <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 05                	push   $0x5
  8017fb:	e8 7b ff ff ff       	call   80177b <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	56                   	push   %esi
  801809:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80180a:	8b 75 18             	mov    0x18(%ebp),%esi
  80180d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801810:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	56                   	push   %esi
  80181a:	53                   	push   %ebx
  80181b:	51                   	push   %ecx
  80181c:	52                   	push   %edx
  80181d:	50                   	push   %eax
  80181e:	6a 06                	push   $0x6
  801820:	e8 56 ff ff ff       	call   80177b <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
}
  801828:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182b:	5b                   	pop    %ebx
  80182c:	5e                   	pop    %esi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    

0080182f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	52                   	push   %edx
  80183f:	50                   	push   %eax
  801840:	6a 07                	push   $0x7
  801842:	e8 34 ff ff ff       	call   80177b <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	ff 75 0c             	pushl  0xc(%ebp)
  801858:	ff 75 08             	pushl  0x8(%ebp)
  80185b:	6a 08                	push   $0x8
  80185d:	e8 19 ff ff ff       	call   80177b <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 09                	push   $0x9
  801876:	e8 00 ff ff ff       	call   80177b <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 0a                	push   $0xa
  80188f:	e8 e7 fe ff ff       	call   80177b <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 0b                	push   $0xb
  8018a8:	e8 ce fe ff ff       	call   80177b <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	ff 75 0c             	pushl  0xc(%ebp)
  8018be:	ff 75 08             	pushl  0x8(%ebp)
  8018c1:	6a 0f                	push   $0xf
  8018c3:	e8 b3 fe ff ff       	call   80177b <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
	return;
  8018cb:	90                   	nop
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    

008018ce <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	ff 75 0c             	pushl  0xc(%ebp)
  8018da:	ff 75 08             	pushl  0x8(%ebp)
  8018dd:	6a 10                	push   $0x10
  8018df:	e8 97 fe ff ff       	call   80177b <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e7:	90                   	nop
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 10             	pushl  0x10(%ebp)
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 11                	push   $0x11
  8018fc:	e8 7a fe ff ff       	call   80177b <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
	return ;
  801904:	90                   	nop
}
  801905:	c9                   	leave  
  801906:	c3                   	ret    

00801907 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 0c                	push   $0xc
  801916:	e8 60 fe ff ff       	call   80177b <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	ff 75 08             	pushl  0x8(%ebp)
  80192e:	6a 0d                	push   $0xd
  801930:	e8 46 fe ff ff       	call   80177b <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 0e                	push   $0xe
  801949:	e8 2d fe ff ff       	call   80177b <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	90                   	nop
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 13                	push   $0x13
  801963:	e8 13 fe ff ff       	call   80177b <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 14                	push   $0x14
  80197d:	e8 f9 fd ff ff       	call   80177b <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	90                   	nop
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_cputc>:


void
sys_cputc(const char c)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	8b 45 08             	mov    0x8(%ebp),%eax
  801991:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801994:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	50                   	push   %eax
  8019a1:	6a 15                	push   $0x15
  8019a3:	e8 d3 fd ff ff       	call   80177b <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 16                	push   $0x16
  8019bd:	e8 b9 fd ff ff       	call   80177b <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 0c             	pushl  0xc(%ebp)
  8019d7:	50                   	push   %eax
  8019d8:	6a 17                	push   $0x17
  8019da:	e8 9c fd ff ff       	call   80177b <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	52                   	push   %edx
  8019f4:	50                   	push   %eax
  8019f5:	6a 1a                	push   $0x1a
  8019f7:	e8 7f fd ff ff       	call   80177b <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	6a 18                	push   $0x18
  801a14:	e8 62 fd ff ff       	call   80177b <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	52                   	push   %edx
  801a2f:	50                   	push   %eax
  801a30:	6a 19                	push   $0x19
  801a32:	e8 44 fd ff ff       	call   80177b <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	8b 45 10             	mov    0x10(%ebp),%eax
  801a46:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a49:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a4c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	51                   	push   %ecx
  801a56:	52                   	push   %edx
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	50                   	push   %eax
  801a5b:	6a 1b                	push   $0x1b
  801a5d:	e8 19 fd ff ff       	call   80177b <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	52                   	push   %edx
  801a77:	50                   	push   %eax
  801a78:	6a 1c                	push   $0x1c
  801a7a:	e8 fc fc ff ff       	call   80177b <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
}
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a87:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	51                   	push   %ecx
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 1d                	push   $0x1d
  801a99:	e8 dd fc ff ff       	call   80177b <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	52                   	push   %edx
  801ab3:	50                   	push   %eax
  801ab4:	6a 1e                	push   $0x1e
  801ab6:	e8 c0 fc ff ff       	call   80177b <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 1f                	push   $0x1f
  801acf:	e8 a7 fc ff ff       	call   80177b <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	ff 75 14             	pushl  0x14(%ebp)
  801ae4:	ff 75 10             	pushl  0x10(%ebp)
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	50                   	push   %eax
  801aeb:	6a 20                	push   $0x20
  801aed:	e8 89 fc ff ff       	call   80177b <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	50                   	push   %eax
  801b06:	6a 21                	push   $0x21
  801b08:	e8 6e fc ff ff       	call   80177b <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	90                   	nop
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	50                   	push   %eax
  801b22:	6a 22                	push   $0x22
  801b24:	e8 52 fc ff ff       	call   80177b <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 02                	push   $0x2
  801b3d:	e8 39 fc ff ff       	call   80177b <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 03                	push   $0x3
  801b56:	e8 20 fc ff ff       	call   80177b <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 04                	push   $0x4
  801b6f:	e8 07 fc ff ff       	call   80177b <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_exit_env>:


void sys_exit_env(void)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 23                	push   $0x23
  801b88:	e8 ee fb ff ff       	call   80177b <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	90                   	nop
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b99:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9c:	8d 50 04             	lea    0x4(%eax),%edx
  801b9f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	52                   	push   %edx
  801ba9:	50                   	push   %eax
  801baa:	6a 24                	push   $0x24
  801bac:	e8 ca fb ff ff       	call   80177b <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return result;
  801bb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bba:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bbd:	89 01                	mov    %eax,(%ecx)
  801bbf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	c9                   	leave  
  801bc6:	c2 04 00             	ret    $0x4

00801bc9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	ff 75 10             	pushl  0x10(%ebp)
  801bd3:	ff 75 0c             	pushl  0xc(%ebp)
  801bd6:	ff 75 08             	pushl  0x8(%ebp)
  801bd9:	6a 12                	push   $0x12
  801bdb:	e8 9b fb ff ff       	call   80177b <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return ;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 25                	push   $0x25
  801bf5:	e8 81 fb ff ff       	call   80177b <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	83 ec 04             	sub    $0x4,%esp
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c0b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	50                   	push   %eax
  801c18:	6a 26                	push   $0x26
  801c1a:	e8 5c fb ff ff       	call   80177b <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c22:	90                   	nop
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <rsttst>:
void rsttst()
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 28                	push   $0x28
  801c34:	e8 42 fb ff ff       	call   80177b <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3c:	90                   	nop
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 04             	sub    $0x4,%esp
  801c45:	8b 45 14             	mov    0x14(%ebp),%eax
  801c48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c4b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c52:	52                   	push   %edx
  801c53:	50                   	push   %eax
  801c54:	ff 75 10             	pushl  0x10(%ebp)
  801c57:	ff 75 0c             	pushl  0xc(%ebp)
  801c5a:	ff 75 08             	pushl  0x8(%ebp)
  801c5d:	6a 27                	push   $0x27
  801c5f:	e8 17 fb ff ff       	call   80177b <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
	return ;
  801c67:	90                   	nop
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <chktst>:
void chktst(uint32 n)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	6a 29                	push   $0x29
  801c7a:	e8 fc fa ff ff       	call   80177b <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <inctst>:

void inctst()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 2a                	push   $0x2a
  801c94:	e8 e2 fa ff ff       	call   80177b <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9c:	90                   	nop
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <gettst>:
uint32 gettst()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 2b                	push   $0x2b
  801cae:	e8 c8 fa ff ff       	call   80177b <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 2c                	push   $0x2c
  801cca:	e8 ac fa ff ff       	call   80177b <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
  801cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cd5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cd9:	75 07                	jne    801ce2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cdb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce0:	eb 05                	jmp    801ce7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 2c                	push   $0x2c
  801cfb:	e8 7b fa ff ff       	call   80177b <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
  801d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d06:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d0a:	75 07                	jne    801d13 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d11:	eb 05                	jmp    801d18 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 2c                	push   $0x2c
  801d2c:	e8 4a fa ff ff       	call   80177b <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
  801d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d37:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d3b:	75 07                	jne    801d44 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d42:	eb 05                	jmp    801d49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 2c                	push   $0x2c
  801d5d:	e8 19 fa ff ff       	call   80177b <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
  801d65:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d68:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d6c:	75 07                	jne    801d75 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d73:	eb 05                	jmp    801d7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	ff 75 08             	pushl  0x8(%ebp)
  801d8a:	6a 2d                	push   $0x2d
  801d8c:	e8 ea f9 ff ff       	call   80177b <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
	return ;
  801d94:	90                   	nop
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d9b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	6a 00                	push   $0x0
  801da9:	53                   	push   %ebx
  801daa:	51                   	push   %ecx
  801dab:	52                   	push   %edx
  801dac:	50                   	push   %eax
  801dad:	6a 2e                	push   $0x2e
  801daf:	e8 c7 f9 ff ff       	call   80177b <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	6a 2f                	push   $0x2f
  801dcf:	e8 a7 f9 ff ff       	call   80177b <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ddf:	83 ec 0c             	sub    $0xc,%esp
  801de2:	68 a4 3e 80 00       	push   $0x803ea4
  801de7:	e8 46 e8 ff ff       	call   800632 <cprintf>
  801dec:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801def:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801df6:	83 ec 0c             	sub    $0xc,%esp
  801df9:	68 d0 3e 80 00       	push   $0x803ed0
  801dfe:	e8 2f e8 ff ff       	call   800632 <cprintf>
  801e03:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e06:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e0a:	a1 38 51 80 00       	mov    0x805138,%eax
  801e0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e12:	eb 56                	jmp    801e6a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e18:	74 1c                	je     801e36 <print_mem_block_lists+0x5d>
  801e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1d:	8b 50 08             	mov    0x8(%eax),%edx
  801e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e23:	8b 48 08             	mov    0x8(%eax),%ecx
  801e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e29:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2c:	01 c8                	add    %ecx,%eax
  801e2e:	39 c2                	cmp    %eax,%edx
  801e30:	73 04                	jae    801e36 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e32:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 50 08             	mov    0x8(%eax),%edx
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e42:	01 c2                	add    %eax,%edx
  801e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e47:	8b 40 08             	mov    0x8(%eax),%eax
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	52                   	push   %edx
  801e4e:	50                   	push   %eax
  801e4f:	68 e5 3e 80 00       	push   $0x803ee5
  801e54:	e8 d9 e7 ff ff       	call   800632 <cprintf>
  801e59:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e62:	a1 40 51 80 00       	mov    0x805140,%eax
  801e67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6e:	74 07                	je     801e77 <print_mem_block_lists+0x9e>
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	8b 00                	mov    (%eax),%eax
  801e75:	eb 05                	jmp    801e7c <print_mem_block_lists+0xa3>
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7c:	a3 40 51 80 00       	mov    %eax,0x805140
  801e81:	a1 40 51 80 00       	mov    0x805140,%eax
  801e86:	85 c0                	test   %eax,%eax
  801e88:	75 8a                	jne    801e14 <print_mem_block_lists+0x3b>
  801e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8e:	75 84                	jne    801e14 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e90:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e94:	75 10                	jne    801ea6 <print_mem_block_lists+0xcd>
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	68 f4 3e 80 00       	push   $0x803ef4
  801e9e:	e8 8f e7 ff ff       	call   800632 <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ea6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	68 18 3f 80 00       	push   $0x803f18
  801eb5:	e8 78 e7 ff ff       	call   800632 <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ebd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ec1:	a1 40 50 80 00       	mov    0x805040,%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec9:	eb 56                	jmp    801f21 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ecf:	74 1c                	je     801eed <print_mem_block_lists+0x114>
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 50 08             	mov    0x8(%eax),%edx
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	8b 48 08             	mov    0x8(%eax),%ecx
  801edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee3:	01 c8                	add    %ecx,%eax
  801ee5:	39 c2                	cmp    %eax,%edx
  801ee7:	73 04                	jae    801eed <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ee9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 50 08             	mov    0x8(%eax),%edx
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef9:	01 c2                	add    %eax,%edx
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 40 08             	mov    0x8(%eax),%eax
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	68 e5 3e 80 00       	push   $0x803ee5
  801f0b:	e8 22 e7 ff ff       	call   800632 <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f19:	a1 48 50 80 00       	mov    0x805048,%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f25:	74 07                	je     801f2e <print_mem_block_lists+0x155>
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	eb 05                	jmp    801f33 <print_mem_block_lists+0x15a>
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	a3 48 50 80 00       	mov    %eax,0x805048
  801f38:	a1 48 50 80 00       	mov    0x805048,%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	75 8a                	jne    801ecb <print_mem_block_lists+0xf2>
  801f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f45:	75 84                	jne    801ecb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f47:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4b:	75 10                	jne    801f5d <print_mem_block_lists+0x184>
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	68 30 3f 80 00       	push   $0x803f30
  801f55:	e8 d8 e6 ff ff       	call   800632 <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f5d:	83 ec 0c             	sub    $0xc,%esp
  801f60:	68 a4 3e 80 00       	push   $0x803ea4
  801f65:	e8 c8 e6 ff ff       	call   800632 <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp

}
  801f6d:	90                   	nop
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f76:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f7d:	00 00 00 
  801f80:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f87:	00 00 00 
  801f8a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f91:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f9b:	e9 9e 00 00 00       	jmp    80203e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fa0:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa8:	c1 e2 04             	shl    $0x4,%edx
  801fab:	01 d0                	add    %edx,%eax
  801fad:	85 c0                	test   %eax,%eax
  801faf:	75 14                	jne    801fc5 <initialize_MemBlocksList+0x55>
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	68 58 3f 80 00       	push   $0x803f58
  801fb9:	6a 46                	push   $0x46
  801fbb:	68 7b 3f 80 00       	push   $0x803f7b
  801fc0:	e8 b9 e3 ff ff       	call   80037e <_panic>
  801fc5:	a1 50 50 80 00       	mov    0x805050,%eax
  801fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcd:	c1 e2 04             	shl    $0x4,%edx
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fd8:	89 10                	mov    %edx,(%eax)
  801fda:	8b 00                	mov    (%eax),%eax
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	74 18                	je     801ff8 <initialize_MemBlocksList+0x88>
  801fe0:	a1 48 51 80 00       	mov    0x805148,%eax
  801fe5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801feb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fee:	c1 e1 04             	shl    $0x4,%ecx
  801ff1:	01 ca                	add    %ecx,%edx
  801ff3:	89 50 04             	mov    %edx,0x4(%eax)
  801ff6:	eb 12                	jmp    80200a <initialize_MemBlocksList+0x9a>
  801ff8:	a1 50 50 80 00       	mov    0x805050,%eax
  801ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802000:	c1 e2 04             	shl    $0x4,%edx
  802003:	01 d0                	add    %edx,%eax
  802005:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80200a:	a1 50 50 80 00       	mov    0x805050,%eax
  80200f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802012:	c1 e2 04             	shl    $0x4,%edx
  802015:	01 d0                	add    %edx,%eax
  802017:	a3 48 51 80 00       	mov    %eax,0x805148
  80201c:	a1 50 50 80 00       	mov    0x805050,%eax
  802021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802024:	c1 e2 04             	shl    $0x4,%edx
  802027:	01 d0                	add    %edx,%eax
  802029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802030:	a1 54 51 80 00       	mov    0x805154,%eax
  802035:	40                   	inc    %eax
  802036:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80203b:	ff 45 f4             	incl   -0xc(%ebp)
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	3b 45 08             	cmp    0x8(%ebp),%eax
  802044:	0f 82 56 ff ff ff    	jb     801fa0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80204a:	90                   	nop
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 00                	mov    (%eax),%eax
  802058:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80205b:	eb 19                	jmp    802076 <find_block+0x29>
	{
		if(va==point->sva)
  80205d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802060:	8b 40 08             	mov    0x8(%eax),%eax
  802063:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802066:	75 05                	jne    80206d <find_block+0x20>
		   return point;
  802068:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206b:	eb 36                	jmp    8020a3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 40 08             	mov    0x8(%eax),%eax
  802073:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802076:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80207a:	74 07                	je     802083 <find_block+0x36>
  80207c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207f:	8b 00                	mov    (%eax),%eax
  802081:	eb 05                	jmp    802088 <find_block+0x3b>
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	8b 55 08             	mov    0x8(%ebp),%edx
  80208b:	89 42 08             	mov    %eax,0x8(%edx)
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	8b 40 08             	mov    0x8(%eax),%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	75 c5                	jne    80205d <find_block+0x10>
  802098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80209c:	75 bf                	jne    80205d <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020ab:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020b3:	a1 44 50 80 00       	mov    0x805044,%eax
  8020b8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020c1:	74 24                	je     8020e7 <insert_sorted_allocList+0x42>
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8b 50 08             	mov    0x8(%eax),%edx
  8020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cc:	8b 40 08             	mov    0x8(%eax),%eax
  8020cf:	39 c2                	cmp    %eax,%edx
  8020d1:	76 14                	jbe    8020e7 <insert_sorted_allocList+0x42>
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8b 50 08             	mov    0x8(%eax),%edx
  8020d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020dc:	8b 40 08             	mov    0x8(%eax),%eax
  8020df:	39 c2                	cmp    %eax,%edx
  8020e1:	0f 82 60 01 00 00    	jb     802247 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020eb:	75 65                	jne    802152 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f1:	75 14                	jne    802107 <insert_sorted_allocList+0x62>
  8020f3:	83 ec 04             	sub    $0x4,%esp
  8020f6:	68 58 3f 80 00       	push   $0x803f58
  8020fb:	6a 6b                	push   $0x6b
  8020fd:	68 7b 3f 80 00       	push   $0x803f7b
  802102:	e8 77 e2 ff ff       	call   80037e <_panic>
  802107:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	89 10                	mov    %edx,(%eax)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8b 00                	mov    (%eax),%eax
  802117:	85 c0                	test   %eax,%eax
  802119:	74 0d                	je     802128 <insert_sorted_allocList+0x83>
  80211b:	a1 40 50 80 00       	mov    0x805040,%eax
  802120:	8b 55 08             	mov    0x8(%ebp),%edx
  802123:	89 50 04             	mov    %edx,0x4(%eax)
  802126:	eb 08                	jmp    802130 <insert_sorted_allocList+0x8b>
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	a3 44 50 80 00       	mov    %eax,0x805044
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 40 50 80 00       	mov    %eax,0x805040
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802142:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802147:	40                   	inc    %eax
  802148:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80214d:	e9 dc 01 00 00       	jmp    80232e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	8b 50 08             	mov    0x8(%eax),%edx
  802158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215b:	8b 40 08             	mov    0x8(%eax),%eax
  80215e:	39 c2                	cmp    %eax,%edx
  802160:	77 6c                	ja     8021ce <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802166:	74 06                	je     80216e <insert_sorted_allocList+0xc9>
  802168:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216c:	75 14                	jne    802182 <insert_sorted_allocList+0xdd>
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	68 94 3f 80 00       	push   $0x803f94
  802176:	6a 6f                	push   $0x6f
  802178:	68 7b 3f 80 00       	push   $0x803f7b
  80217d:	e8 fc e1 ff ff       	call   80037e <_panic>
  802182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802185:	8b 50 04             	mov    0x4(%eax),%edx
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	89 50 04             	mov    %edx,0x4(%eax)
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802194:	89 10                	mov    %edx,(%eax)
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	8b 40 04             	mov    0x4(%eax),%eax
  80219c:	85 c0                	test   %eax,%eax
  80219e:	74 0d                	je     8021ad <insert_sorted_allocList+0x108>
  8021a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a3:	8b 40 04             	mov    0x4(%eax),%eax
  8021a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a9:	89 10                	mov    %edx,(%eax)
  8021ab:	eb 08                	jmp    8021b5 <insert_sorted_allocList+0x110>
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	a3 40 50 80 00       	mov    %eax,0x805040
  8021b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bb:	89 50 04             	mov    %edx,0x4(%eax)
  8021be:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021c3:	40                   	inc    %eax
  8021c4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c9:	e9 60 01 00 00       	jmp    80232e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 50 08             	mov    0x8(%eax),%edx
  8021d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d7:	8b 40 08             	mov    0x8(%eax),%eax
  8021da:	39 c2                	cmp    %eax,%edx
  8021dc:	0f 82 4c 01 00 00    	jb     80232e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e6:	75 14                	jne    8021fc <insert_sorted_allocList+0x157>
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	68 cc 3f 80 00       	push   $0x803fcc
  8021f0:	6a 73                	push   $0x73
  8021f2:	68 7b 3f 80 00       	push   $0x803f7b
  8021f7:	e8 82 e1 ff ff       	call   80037e <_panic>
  8021fc:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	89 50 04             	mov    %edx,0x4(%eax)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 40 04             	mov    0x4(%eax),%eax
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 0c                	je     80221e <insert_sorted_allocList+0x179>
  802212:	a1 44 50 80 00       	mov    0x805044,%eax
  802217:	8b 55 08             	mov    0x8(%ebp),%edx
  80221a:	89 10                	mov    %edx,(%eax)
  80221c:	eb 08                	jmp    802226 <insert_sorted_allocList+0x181>
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 40 50 80 00       	mov    %eax,0x805040
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 44 50 80 00       	mov    %eax,0x805044
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802237:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80223c:	40                   	inc    %eax
  80223d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802242:	e9 e7 00 00 00       	jmp    80232e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80224d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802254:	a1 40 50 80 00       	mov    0x805040,%eax
  802259:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225c:	e9 9d 00 00 00       	jmp    8022fe <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	8b 00                	mov    (%eax),%eax
  802266:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	39 c2                	cmp    %eax,%edx
  802277:	76 7d                	jbe    8022f6 <insert_sorted_allocList+0x251>
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 50 08             	mov    0x8(%eax),%edx
  80227f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802282:	8b 40 08             	mov    0x8(%eax),%eax
  802285:	39 c2                	cmp    %eax,%edx
  802287:	73 6d                	jae    8022f6 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802289:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80228d:	74 06                	je     802295 <insert_sorted_allocList+0x1f0>
  80228f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802293:	75 14                	jne    8022a9 <insert_sorted_allocList+0x204>
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	68 f0 3f 80 00       	push   $0x803ff0
  80229d:	6a 7f                	push   $0x7f
  80229f:	68 7b 3f 80 00       	push   $0x803f7b
  8022a4:	e8 d5 e0 ff ff       	call   80037e <_panic>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 10                	mov    (%eax),%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	89 10                	mov    %edx,(%eax)
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	74 0b                	je     8022c7 <insert_sorted_allocList+0x222>
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 00                	mov    (%eax),%eax
  8022c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c4:	89 50 04             	mov    %edx,0x4(%eax)
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cd:	89 10                	mov    %edx,(%eax)
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	75 08                	jne    8022e9 <insert_sorted_allocList+0x244>
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	a3 44 50 80 00       	mov    %eax,0x805044
  8022e9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ee:	40                   	inc    %eax
  8022ef:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022f4:	eb 39                	jmp    80232f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022f6:	a1 48 50 80 00       	mov    0x805048,%eax
  8022fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802302:	74 07                	je     80230b <insert_sorted_allocList+0x266>
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	eb 05                	jmp    802310 <insert_sorted_allocList+0x26b>
  80230b:	b8 00 00 00 00       	mov    $0x0,%eax
  802310:	a3 48 50 80 00       	mov    %eax,0x805048
  802315:	a1 48 50 80 00       	mov    0x805048,%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	0f 85 3f ff ff ff    	jne    802261 <insert_sorted_allocList+0x1bc>
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	0f 85 35 ff ff ff    	jne    802261 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80232c:	eb 01                	jmp    80232f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80232e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80232f:	90                   	nop
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802338:	a1 38 51 80 00       	mov    0x805138,%eax
  80233d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802340:	e9 85 01 00 00       	jmp    8024ca <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 0c             	mov    0xc(%eax),%eax
  80234b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234e:	0f 82 6e 01 00 00    	jb     8024c2 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 40 0c             	mov    0xc(%eax),%eax
  80235a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235d:	0f 85 8a 00 00 00    	jne    8023ed <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802367:	75 17                	jne    802380 <alloc_block_FF+0x4e>
  802369:	83 ec 04             	sub    $0x4,%esp
  80236c:	68 24 40 80 00       	push   $0x804024
  802371:	68 93 00 00 00       	push   $0x93
  802376:	68 7b 3f 80 00       	push   $0x803f7b
  80237b:	e8 fe df ff ff       	call   80037e <_panic>
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	74 10                	je     802399 <alloc_block_FF+0x67>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802391:	8b 52 04             	mov    0x4(%edx),%edx
  802394:	89 50 04             	mov    %edx,0x4(%eax)
  802397:	eb 0b                	jmp    8023a4 <alloc_block_FF+0x72>
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 40 04             	mov    0x4(%eax),%eax
  80239f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 40 04             	mov    0x4(%eax),%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	74 0f                	je     8023bd <alloc_block_FF+0x8b>
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 04             	mov    0x4(%eax),%eax
  8023b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b7:	8b 12                	mov    (%edx),%edx
  8023b9:	89 10                	mov    %edx,(%eax)
  8023bb:	eb 0a                	jmp    8023c7 <alloc_block_FF+0x95>
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023da:	a1 44 51 80 00       	mov    0x805144,%eax
  8023df:	48                   	dec    %eax
  8023e0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	e9 10 01 00 00       	jmp    8024fd <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f6:	0f 86 c6 00 00 00    	jbe    8024c2 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023fc:	a1 48 51 80 00       	mov    0x805148,%eax
  802401:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 50 08             	mov    0x8(%eax),%edx
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	8b 55 08             	mov    0x8(%ebp),%edx
  802416:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80241d:	75 17                	jne    802436 <alloc_block_FF+0x104>
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	68 24 40 80 00       	push   $0x804024
  802427:	68 9b 00 00 00       	push   $0x9b
  80242c:	68 7b 3f 80 00       	push   $0x803f7b
  802431:	e8 48 df ff ff       	call   80037e <_panic>
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	8b 00                	mov    (%eax),%eax
  80243b:	85 c0                	test   %eax,%eax
  80243d:	74 10                	je     80244f <alloc_block_FF+0x11d>
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802447:	8b 52 04             	mov    0x4(%edx),%edx
  80244a:	89 50 04             	mov    %edx,0x4(%eax)
  80244d:	eb 0b                	jmp    80245a <alloc_block_FF+0x128>
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	8b 40 04             	mov    0x4(%eax),%eax
  802455:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80245a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 0f                	je     802473 <alloc_block_FF+0x141>
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246d:	8b 12                	mov    (%edx),%edx
  80246f:	89 10                	mov    %edx,(%eax)
  802471:	eb 0a                	jmp    80247d <alloc_block_FF+0x14b>
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	a3 48 51 80 00       	mov    %eax,0x805148
  80247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802490:	a1 54 51 80 00       	mov    0x805154,%eax
  802495:	48                   	dec    %eax
  802496:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 50 08             	mov    0x8(%eax),%edx
  8024a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a4:	01 c2                	add    %eax,%edx
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b2:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b5:	89 c2                	mov    %eax,%edx
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ba:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	eb 3b                	jmp    8024fd <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024c2:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ce:	74 07                	je     8024d7 <alloc_block_FF+0x1a5>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	eb 05                	jmp    8024dc <alloc_block_FF+0x1aa>
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024dc:	a3 40 51 80 00       	mov    %eax,0x805140
  8024e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8024e6:	85 c0                	test   %eax,%eax
  8024e8:	0f 85 57 fe ff ff    	jne    802345 <alloc_block_FF+0x13>
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	0f 85 4d fe ff ff    	jne    802345 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802505:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80250c:	a1 38 51 80 00       	mov    0x805138,%eax
  802511:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802514:	e9 df 00 00 00       	jmp    8025f8 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 0c             	mov    0xc(%eax),%eax
  80251f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802522:	0f 82 c8 00 00 00    	jb     8025f0 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 0c             	mov    0xc(%eax),%eax
  80252e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802531:	0f 85 8a 00 00 00    	jne    8025c1 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253b:	75 17                	jne    802554 <alloc_block_BF+0x55>
  80253d:	83 ec 04             	sub    $0x4,%esp
  802540:	68 24 40 80 00       	push   $0x804024
  802545:	68 b7 00 00 00       	push   $0xb7
  80254a:	68 7b 3f 80 00       	push   $0x803f7b
  80254f:	e8 2a de ff ff       	call   80037e <_panic>
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	74 10                	je     80256d <alloc_block_BF+0x6e>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802565:	8b 52 04             	mov    0x4(%edx),%edx
  802568:	89 50 04             	mov    %edx,0x4(%eax)
  80256b:	eb 0b                	jmp    802578 <alloc_block_BF+0x79>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 40 04             	mov    0x4(%eax),%eax
  802573:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 40 04             	mov    0x4(%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 0f                	je     802591 <alloc_block_BF+0x92>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 04             	mov    0x4(%eax),%eax
  802588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258b:	8b 12                	mov    (%edx),%edx
  80258d:	89 10                	mov    %edx,(%eax)
  80258f:	eb 0a                	jmp    80259b <alloc_block_BF+0x9c>
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	a3 38 51 80 00       	mov    %eax,0x805138
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8025b3:	48                   	dec    %eax
  8025b4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	e9 4d 01 00 00       	jmp    80270e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ca:	76 24                	jbe    8025f0 <alloc_block_BF+0xf1>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025d5:	73 19                	jae    8025f0 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025d7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 08             	mov    0x8(%eax),%eax
  8025ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fc:	74 07                	je     802605 <alloc_block_BF+0x106>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	eb 05                	jmp    80260a <alloc_block_BF+0x10b>
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	a3 40 51 80 00       	mov    %eax,0x805140
  80260f:	a1 40 51 80 00       	mov    0x805140,%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 85 fd fe ff ff    	jne    802519 <alloc_block_BF+0x1a>
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	0f 85 f3 fe ff ff    	jne    802519 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802626:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80262a:	0f 84 d9 00 00 00    	je     802709 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802630:	a1 48 51 80 00       	mov    0x805148,%eax
  802635:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80263e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802641:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802644:	8b 55 08             	mov    0x8(%ebp),%edx
  802647:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80264a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80264e:	75 17                	jne    802667 <alloc_block_BF+0x168>
  802650:	83 ec 04             	sub    $0x4,%esp
  802653:	68 24 40 80 00       	push   $0x804024
  802658:	68 c7 00 00 00       	push   $0xc7
  80265d:	68 7b 3f 80 00       	push   $0x803f7b
  802662:	e8 17 dd ff ff       	call   80037e <_panic>
  802667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 10                	je     802680 <alloc_block_BF+0x181>
  802670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802678:	8b 52 04             	mov    0x4(%edx),%edx
  80267b:	89 50 04             	mov    %edx,0x4(%eax)
  80267e:	eb 0b                	jmp    80268b <alloc_block_BF+0x18c>
  802680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802683:	8b 40 04             	mov    0x4(%eax),%eax
  802686:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80268b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268e:	8b 40 04             	mov    0x4(%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 0f                	je     8026a4 <alloc_block_BF+0x1a5>
  802695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80269e:	8b 12                	mov    (%edx),%edx
  8026a0:	89 10                	mov    %edx,(%eax)
  8026a2:	eb 0a                	jmp    8026ae <alloc_block_BF+0x1af>
  8026a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8026c6:	48                   	dec    %eax
  8026c7:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026cc:	83 ec 08             	sub    $0x8,%esp
  8026cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8026d2:	68 38 51 80 00       	push   $0x805138
  8026d7:	e8 71 f9 ff ff       	call   80204d <find_block>
  8026dc:	83 c4 10             	add    $0x10,%esp
  8026df:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e5:	8b 50 08             	mov    0x8(%eax),%edx
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	01 c2                	add    %eax,%edx
  8026ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f0:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026fc:	89 c2                	mov    %eax,%edx
  8026fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802701:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	eb 05                	jmp    80270e <alloc_block_BF+0x20f>
	}
	return NULL;
  802709:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802716:	a1 28 50 80 00       	mov    0x805028,%eax
  80271b:	85 c0                	test   %eax,%eax
  80271d:	0f 85 de 01 00 00    	jne    802901 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802723:	a1 38 51 80 00       	mov    0x805138,%eax
  802728:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272b:	e9 9e 01 00 00       	jmp    8028ce <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 0c             	mov    0xc(%eax),%eax
  802736:	3b 45 08             	cmp    0x8(%ebp),%eax
  802739:	0f 82 87 01 00 00    	jb     8028c6 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	3b 45 08             	cmp    0x8(%ebp),%eax
  802748:	0f 85 95 00 00 00    	jne    8027e3 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80274e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802752:	75 17                	jne    80276b <alloc_block_NF+0x5b>
  802754:	83 ec 04             	sub    $0x4,%esp
  802757:	68 24 40 80 00       	push   $0x804024
  80275c:	68 e0 00 00 00       	push   $0xe0
  802761:	68 7b 3f 80 00       	push   $0x803f7b
  802766:	e8 13 dc ff ff       	call   80037e <_panic>
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 10                	je     802784 <alloc_block_NF+0x74>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277c:	8b 52 04             	mov    0x4(%edx),%edx
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	eb 0b                	jmp    80278f <alloc_block_NF+0x7f>
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 40 04             	mov    0x4(%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 0f                	je     8027a8 <alloc_block_NF+0x98>
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 04             	mov    0x4(%eax),%eax
  80279f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a2:	8b 12                	mov    (%edx),%edx
  8027a4:	89 10                	mov    %edx,(%eax)
  8027a6:	eb 0a                	jmp    8027b2 <alloc_block_NF+0xa2>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	a3 38 51 80 00       	mov    %eax,0x805138
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c5:	a1 44 51 80 00       	mov    0x805144,%eax
  8027ca:	48                   	dec    %eax
  8027cb:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 08             	mov    0x8(%eax),%eax
  8027d6:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	e9 f8 04 00 00       	jmp    802cdb <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ec:	0f 86 d4 00 00 00    	jbe    8028c6 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 50 08             	mov    0x8(%eax),%edx
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802809:	8b 55 08             	mov    0x8(%ebp),%edx
  80280c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80280f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802813:	75 17                	jne    80282c <alloc_block_NF+0x11c>
  802815:	83 ec 04             	sub    $0x4,%esp
  802818:	68 24 40 80 00       	push   $0x804024
  80281d:	68 e9 00 00 00       	push   $0xe9
  802822:	68 7b 3f 80 00       	push   $0x803f7b
  802827:	e8 52 db ff ff       	call   80037e <_panic>
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 10                	je     802845 <alloc_block_NF+0x135>
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 00                	mov    (%eax),%eax
  80283a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283d:	8b 52 04             	mov    0x4(%edx),%edx
  802840:	89 50 04             	mov    %edx,0x4(%eax)
  802843:	eb 0b                	jmp    802850 <alloc_block_NF+0x140>
  802845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802848:	8b 40 04             	mov    0x4(%eax),%eax
  80284b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	8b 40 04             	mov    0x4(%eax),%eax
  802856:	85 c0                	test   %eax,%eax
  802858:	74 0f                	je     802869 <alloc_block_NF+0x159>
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 40 04             	mov    0x4(%eax),%eax
  802860:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802863:	8b 12                	mov    (%edx),%edx
  802865:	89 10                	mov    %edx,(%eax)
  802867:	eb 0a                	jmp    802873 <alloc_block_NF+0x163>
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	8b 00                	mov    (%eax),%eax
  80286e:	a3 48 51 80 00       	mov    %eax,0x805148
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802886:	a1 54 51 80 00       	mov    0x805154,%eax
  80288b:	48                   	dec    %eax
  80288c:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802894:	8b 40 08             	mov    0x8(%eax),%eax
  802897:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 50 08             	mov    0x8(%eax),%edx
  8028a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a5:	01 c2                	add    %eax,%edx
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b6:	89 c2                	mov    %eax,%edx
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	e9 15 04 00 00       	jmp    802cdb <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d2:	74 07                	je     8028db <alloc_block_NF+0x1cb>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	eb 05                	jmp    8028e0 <alloc_block_NF+0x1d0>
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8028e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	0f 85 3e fe ff ff    	jne    802730 <alloc_block_NF+0x20>
  8028f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f6:	0f 85 34 fe ff ff    	jne    802730 <alloc_block_NF+0x20>
  8028fc:	e9 d5 03 00 00       	jmp    802cd6 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802901:	a1 38 51 80 00       	mov    0x805138,%eax
  802906:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802909:	e9 b1 01 00 00       	jmp    802abf <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 50 08             	mov    0x8(%eax),%edx
  802914:	a1 28 50 80 00       	mov    0x805028,%eax
  802919:	39 c2                	cmp    %eax,%edx
  80291b:	0f 82 96 01 00 00    	jb     802ab7 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 0c             	mov    0xc(%eax),%eax
  802927:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292a:	0f 82 87 01 00 00    	jb     802ab7 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 0c             	mov    0xc(%eax),%eax
  802936:	3b 45 08             	cmp    0x8(%ebp),%eax
  802939:	0f 85 95 00 00 00    	jne    8029d4 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	75 17                	jne    80295c <alloc_block_NF+0x24c>
  802945:	83 ec 04             	sub    $0x4,%esp
  802948:	68 24 40 80 00       	push   $0x804024
  80294d:	68 fc 00 00 00       	push   $0xfc
  802952:	68 7b 3f 80 00       	push   $0x803f7b
  802957:	e8 22 da ff ff       	call   80037e <_panic>
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 10                	je     802975 <alloc_block_NF+0x265>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296d:	8b 52 04             	mov    0x4(%edx),%edx
  802970:	89 50 04             	mov    %edx,0x4(%eax)
  802973:	eb 0b                	jmp    802980 <alloc_block_NF+0x270>
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 04             	mov    0x4(%eax),%eax
  802986:	85 c0                	test   %eax,%eax
  802988:	74 0f                	je     802999 <alloc_block_NF+0x289>
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802993:	8b 12                	mov    (%edx),%edx
  802995:	89 10                	mov    %edx,(%eax)
  802997:	eb 0a                	jmp    8029a3 <alloc_block_NF+0x293>
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b6:	a1 44 51 80 00       	mov    0x805144,%eax
  8029bb:	48                   	dec    %eax
  8029bc:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 40 08             	mov    0x8(%eax),%eax
  8029c7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	e9 07 03 00 00       	jmp    802cdb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029dd:	0f 86 d4 00 00 00    	jbe    802ab7 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029e3:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a00:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a04:	75 17                	jne    802a1d <alloc_block_NF+0x30d>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 24 40 80 00       	push   $0x804024
  802a0e:	68 04 01 00 00       	push   $0x104
  802a13:	68 7b 3f 80 00       	push   $0x803f7b
  802a18:	e8 61 d9 ff ff       	call   80037e <_panic>
  802a1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a20:	8b 00                	mov    (%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 10                	je     802a36 <alloc_block_NF+0x326>
  802a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2e:	8b 52 04             	mov    0x4(%edx),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 0b                	jmp    802a41 <alloc_block_NF+0x331>
  802a36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a39:	8b 40 04             	mov    0x4(%eax),%eax
  802a3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a44:	8b 40 04             	mov    0x4(%eax),%eax
  802a47:	85 c0                	test   %eax,%eax
  802a49:	74 0f                	je     802a5a <alloc_block_NF+0x34a>
  802a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a54:	8b 12                	mov    (%edx),%edx
  802a56:	89 10                	mov    %edx,(%eax)
  802a58:	eb 0a                	jmp    802a64 <alloc_block_NF+0x354>
  802a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a77:	a1 54 51 80 00       	mov    0x805154,%eax
  802a7c:	48                   	dec    %eax
  802a7d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a85:	8b 40 08             	mov    0x8(%eax),%eax
  802a88:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a90:	8b 50 08             	mov    0x8(%eax),%edx
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	01 c2                	add    %eax,%edx
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa4:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa7:	89 c2                	mov    %eax,%edx
  802aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aac:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab2:	e9 24 02 00 00       	jmp    802cdb <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ab7:	a1 40 51 80 00       	mov    0x805140,%eax
  802abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802abf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac3:	74 07                	je     802acc <alloc_block_NF+0x3bc>
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	eb 05                	jmp    802ad1 <alloc_block_NF+0x3c1>
  802acc:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad1:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad6:	a1 40 51 80 00       	mov    0x805140,%eax
  802adb:	85 c0                	test   %eax,%eax
  802add:	0f 85 2b fe ff ff    	jne    80290e <alloc_block_NF+0x1fe>
  802ae3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae7:	0f 85 21 fe ff ff    	jne    80290e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aed:	a1 38 51 80 00       	mov    0x805138,%eax
  802af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af5:	e9 ae 01 00 00       	jmp    802ca8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 50 08             	mov    0x8(%eax),%edx
  802b00:	a1 28 50 80 00       	mov    0x805028,%eax
  802b05:	39 c2                	cmp    %eax,%edx
  802b07:	0f 83 93 01 00 00    	jae    802ca0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 0c             	mov    0xc(%eax),%eax
  802b13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b16:	0f 82 84 01 00 00    	jb     802ca0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b25:	0f 85 95 00 00 00    	jne    802bc0 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2f:	75 17                	jne    802b48 <alloc_block_NF+0x438>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 24 40 80 00       	push   $0x804024
  802b39:	68 14 01 00 00       	push   $0x114
  802b3e:	68 7b 3f 80 00       	push   $0x803f7b
  802b43:	e8 36 d8 ff ff       	call   80037e <_panic>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 10                	je     802b61 <alloc_block_NF+0x451>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b59:	8b 52 04             	mov    0x4(%edx),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 0b                	jmp    802b6c <alloc_block_NF+0x45c>
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 40 04             	mov    0x4(%eax),%eax
  802b72:	85 c0                	test   %eax,%eax
  802b74:	74 0f                	je     802b85 <alloc_block_NF+0x475>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 04             	mov    0x4(%eax),%eax
  802b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7f:	8b 12                	mov    (%edx),%edx
  802b81:	89 10                	mov    %edx,(%eax)
  802b83:	eb 0a                	jmp    802b8f <alloc_block_NF+0x47f>
  802b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	a3 38 51 80 00       	mov    %eax,0x805138
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba7:	48                   	dec    %eax
  802ba8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	e9 1b 01 00 00       	jmp    802cdb <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc9:	0f 86 d1 00 00 00    	jbe    802ca0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bcf:	a1 48 51 80 00       	mov    0x805148,%eax
  802bd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 50 08             	mov    0x8(%eax),%edx
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be6:	8b 55 08             	mov    0x8(%ebp),%edx
  802be9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bf0:	75 17                	jne    802c09 <alloc_block_NF+0x4f9>
  802bf2:	83 ec 04             	sub    $0x4,%esp
  802bf5:	68 24 40 80 00       	push   $0x804024
  802bfa:	68 1c 01 00 00       	push   $0x11c
  802bff:	68 7b 3f 80 00       	push   $0x803f7b
  802c04:	e8 75 d7 ff ff       	call   80037e <_panic>
  802c09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 10                	je     802c22 <alloc_block_NF+0x512>
  802c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c15:	8b 00                	mov    (%eax),%eax
  802c17:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c1a:	8b 52 04             	mov    0x4(%edx),%edx
  802c1d:	89 50 04             	mov    %edx,0x4(%eax)
  802c20:	eb 0b                	jmp    802c2d <alloc_block_NF+0x51d>
  802c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	8b 40 04             	mov    0x4(%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 0f                	je     802c46 <alloc_block_NF+0x536>
  802c37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3a:	8b 40 04             	mov    0x4(%eax),%eax
  802c3d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c40:	8b 12                	mov    (%edx),%edx
  802c42:	89 10                	mov    %edx,(%eax)
  802c44:	eb 0a                	jmp    802c50 <alloc_block_NF+0x540>
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	8b 00                	mov    (%eax),%eax
  802c4b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c63:	a1 54 51 80 00       	mov    0x805154,%eax
  802c68:	48                   	dec    %eax
  802c69:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c71:	8b 40 08             	mov    0x8(%eax),%eax
  802c74:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 50 08             	mov    0x8(%eax),%edx
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	01 c2                	add    %eax,%edx
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	2b 45 08             	sub    0x8(%ebp),%eax
  802c93:	89 c2                	mov    %eax,%edx
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9e:	eb 3b                	jmp    802cdb <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ca0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cac:	74 07                	je     802cb5 <alloc_block_NF+0x5a5>
  802cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb1:	8b 00                	mov    (%eax),%eax
  802cb3:	eb 05                	jmp    802cba <alloc_block_NF+0x5aa>
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  802cba:	a3 40 51 80 00       	mov    %eax,0x805140
  802cbf:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc4:	85 c0                	test   %eax,%eax
  802cc6:	0f 85 2e fe ff ff    	jne    802afa <alloc_block_NF+0x3ea>
  802ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd0:	0f 85 24 fe ff ff    	jne    802afa <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cdb:	c9                   	leave  
  802cdc:	c3                   	ret    

00802cdd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cdd:	55                   	push   %ebp
  802cde:	89 e5                	mov    %esp,%ebp
  802ce0:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ce3:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ceb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cf3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 14                	je     802d10 <insert_sorted_with_merge_freeList+0x33>
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 50 08             	mov    0x8(%eax),%edx
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 40 08             	mov    0x8(%eax),%eax
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	0f 87 9b 01 00 00    	ja     802eab <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d14:	75 17                	jne    802d2d <insert_sorted_with_merge_freeList+0x50>
  802d16:	83 ec 04             	sub    $0x4,%esp
  802d19:	68 58 3f 80 00       	push   $0x803f58
  802d1e:	68 38 01 00 00       	push   $0x138
  802d23:	68 7b 3f 80 00       	push   $0x803f7b
  802d28:	e8 51 d6 ff ff       	call   80037e <_panic>
  802d2d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	89 10                	mov    %edx,(%eax)
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 0d                	je     802d4e <insert_sorted_with_merge_freeList+0x71>
  802d41:	a1 38 51 80 00       	mov    0x805138,%eax
  802d46:	8b 55 08             	mov    0x8(%ebp),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	eb 08                	jmp    802d56 <insert_sorted_with_merge_freeList+0x79>
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	a3 38 51 80 00       	mov    %eax,0x805138
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d68:	a1 44 51 80 00       	mov    0x805144,%eax
  802d6d:	40                   	inc    %eax
  802d6e:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d77:	0f 84 a8 06 00 00    	je     803425 <insert_sorted_with_merge_freeList+0x748>
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	8b 50 08             	mov    0x8(%eax),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 40 0c             	mov    0xc(%eax),%eax
  802d89:	01 c2                	add    %eax,%edx
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 08             	mov    0x8(%eax),%eax
  802d91:	39 c2                	cmp    %eax,%edx
  802d93:	0f 85 8c 06 00 00    	jne    803425 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 40 0c             	mov    0xc(%eax),%eax
  802da5:	01 c2                	add    %eax,%edx
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802db1:	75 17                	jne    802dca <insert_sorted_with_merge_freeList+0xed>
  802db3:	83 ec 04             	sub    $0x4,%esp
  802db6:	68 24 40 80 00       	push   $0x804024
  802dbb:	68 3c 01 00 00       	push   $0x13c
  802dc0:	68 7b 3f 80 00       	push   $0x803f7b
  802dc5:	e8 b4 d5 ff ff       	call   80037e <_panic>
  802dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 10                	je     802de3 <insert_sorted_with_merge_freeList+0x106>
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 00                	mov    (%eax),%eax
  802dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddb:	8b 52 04             	mov    0x4(%edx),%edx
  802dde:	89 50 04             	mov    %edx,0x4(%eax)
  802de1:	eb 0b                	jmp    802dee <insert_sorted_with_merge_freeList+0x111>
  802de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de6:	8b 40 04             	mov    0x4(%eax),%eax
  802de9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	8b 40 04             	mov    0x4(%eax),%eax
  802df4:	85 c0                	test   %eax,%eax
  802df6:	74 0f                	je     802e07 <insert_sorted_with_merge_freeList+0x12a>
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	8b 40 04             	mov    0x4(%eax),%eax
  802dfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e01:	8b 12                	mov    (%edx),%edx
  802e03:	89 10                	mov    %edx,(%eax)
  802e05:	eb 0a                	jmp    802e11 <insert_sorted_with_merge_freeList+0x134>
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e24:	a1 44 51 80 00       	mov    0x805144,%eax
  802e29:	48                   	dec    %eax
  802e2a:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e47:	75 17                	jne    802e60 <insert_sorted_with_merge_freeList+0x183>
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	68 58 3f 80 00       	push   $0x803f58
  802e51:	68 3f 01 00 00       	push   $0x13f
  802e56:	68 7b 3f 80 00       	push   $0x803f7b
  802e5b:	e8 1e d5 ff ff       	call   80037e <_panic>
  802e60:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0d                	je     802e81 <insert_sorted_with_merge_freeList+0x1a4>
  802e74:	a1 48 51 80 00       	mov    0x805148,%eax
  802e79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	eb 08                	jmp    802e89 <insert_sorted_with_merge_freeList+0x1ac>
  802e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea0:	40                   	inc    %eax
  802ea1:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ea6:	e9 7a 05 00 00       	jmp    803425 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 50 08             	mov    0x8(%eax),%edx
  802eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb4:	8b 40 08             	mov    0x8(%eax),%eax
  802eb7:	39 c2                	cmp    %eax,%edx
  802eb9:	0f 82 14 01 00 00    	jb     802fd3 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ebf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec2:	8b 50 08             	mov    0x8(%eax),%edx
  802ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecb:	01 c2                	add    %eax,%edx
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	8b 40 08             	mov    0x8(%eax),%eax
  802ed3:	39 c2                	cmp    %eax,%edx
  802ed5:	0f 85 90 00 00 00    	jne    802f6b <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ede:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee7:	01 c2                	add    %eax,%edx
  802ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eec:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f07:	75 17                	jne    802f20 <insert_sorted_with_merge_freeList+0x243>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 58 3f 80 00       	push   $0x803f58
  802f11:	68 49 01 00 00       	push   $0x149
  802f16:	68 7b 3f 80 00       	push   $0x803f7b
  802f1b:	e8 5e d4 ff ff       	call   80037e <_panic>
  802f20:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 00                	mov    (%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0d                	je     802f41 <insert_sorted_with_merge_freeList+0x264>
  802f34:	a1 48 51 80 00       	mov    0x805148,%eax
  802f39:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3c:	89 50 04             	mov    %edx,0x4(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_with_merge_freeList+0x26c>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f60:	40                   	inc    %eax
  802f61:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f66:	e9 bb 04 00 00       	jmp    803426 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6f:	75 17                	jne    802f88 <insert_sorted_with_merge_freeList+0x2ab>
  802f71:	83 ec 04             	sub    $0x4,%esp
  802f74:	68 cc 3f 80 00       	push   $0x803fcc
  802f79:	68 4c 01 00 00       	push   $0x14c
  802f7e:	68 7b 3f 80 00       	push   $0x803f7b
  802f83:	e8 f6 d3 ff ff       	call   80037e <_panic>
  802f88:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	74 0c                	je     802faa <insert_sorted_with_merge_freeList+0x2cd>
  802f9e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa6:	89 10                	mov    %edx,(%eax)
  802fa8:	eb 08                	jmp    802fb2 <insert_sorted_with_merge_freeList+0x2d5>
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc3:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc8:	40                   	inc    %eax
  802fc9:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fce:	e9 53 04 00 00       	jmp    803426 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdb:	e9 15 04 00 00       	jmp    8033f5 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 50 08             	mov    0x8(%eax),%edx
  802fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff1:	8b 40 08             	mov    0x8(%eax),%eax
  802ff4:	39 c2                	cmp    %eax,%edx
  802ff6:	0f 86 f1 03 00 00    	jbe    8033ed <insert_sorted_with_merge_freeList+0x710>
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 50 08             	mov    0x8(%eax),%edx
  803002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803005:	8b 40 08             	mov    0x8(%eax),%eax
  803008:	39 c2                	cmp    %eax,%edx
  80300a:	0f 83 dd 03 00 00    	jae    8033ed <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	8b 40 0c             	mov    0xc(%eax),%eax
  80301c:	01 c2                	add    %eax,%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 40 08             	mov    0x8(%eax),%eax
  803024:	39 c2                	cmp    %eax,%edx
  803026:	0f 85 b9 01 00 00    	jne    8031e5 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	8b 50 08             	mov    0x8(%eax),%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 40 0c             	mov    0xc(%eax),%eax
  803038:	01 c2                	add    %eax,%edx
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	8b 40 08             	mov    0x8(%eax),%eax
  803040:	39 c2                	cmp    %eax,%edx
  803042:	0f 85 0d 01 00 00    	jne    803155 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 0c             	mov    0xc(%eax),%edx
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8b 40 0c             	mov    0xc(%eax),%eax
  803054:	01 c2                	add    %eax,%edx
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80305c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803060:	75 17                	jne    803079 <insert_sorted_with_merge_freeList+0x39c>
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 24 40 80 00       	push   $0x804024
  80306a:	68 5c 01 00 00       	push   $0x15c
  80306f:	68 7b 3f 80 00       	push   $0x803f7b
  803074:	e8 05 d3 ff ff       	call   80037e <_panic>
  803079:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307c:	8b 00                	mov    (%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 10                	je     803092 <insert_sorted_with_merge_freeList+0x3b5>
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308a:	8b 52 04             	mov    0x4(%edx),%edx
  80308d:	89 50 04             	mov    %edx,0x4(%eax)
  803090:	eb 0b                	jmp    80309d <insert_sorted_with_merge_freeList+0x3c0>
  803092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	85 c0                	test   %eax,%eax
  8030a5:	74 0f                	je     8030b6 <insert_sorted_with_merge_freeList+0x3d9>
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 40 04             	mov    0x4(%eax),%eax
  8030ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b0:	8b 12                	mov    (%edx),%edx
  8030b2:	89 10                	mov    %edx,(%eax)
  8030b4:	eb 0a                	jmp    8030c0 <insert_sorted_with_merge_freeList+0x3e3>
  8030b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b9:	8b 00                	mov    (%eax),%eax
  8030bb:	a3 38 51 80 00       	mov    %eax,0x805138
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d8:	48                   	dec    %eax
  8030d9:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f6:	75 17                	jne    80310f <insert_sorted_with_merge_freeList+0x432>
  8030f8:	83 ec 04             	sub    $0x4,%esp
  8030fb:	68 58 3f 80 00       	push   $0x803f58
  803100:	68 5f 01 00 00       	push   $0x15f
  803105:	68 7b 3f 80 00       	push   $0x803f7b
  80310a:	e8 6f d2 ff ff       	call   80037e <_panic>
  80310f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	89 10                	mov    %edx,(%eax)
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 00                	mov    (%eax),%eax
  80311f:	85 c0                	test   %eax,%eax
  803121:	74 0d                	je     803130 <insert_sorted_with_merge_freeList+0x453>
  803123:	a1 48 51 80 00       	mov    0x805148,%eax
  803128:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80312b:	89 50 04             	mov    %edx,0x4(%eax)
  80312e:	eb 08                	jmp    803138 <insert_sorted_with_merge_freeList+0x45b>
  803130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803133:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313b:	a3 48 51 80 00       	mov    %eax,0x805148
  803140:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80314a:	a1 54 51 80 00       	mov    0x805154,%eax
  80314f:	40                   	inc    %eax
  803150:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	8b 50 0c             	mov    0xc(%eax),%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	8b 40 0c             	mov    0xc(%eax),%eax
  803161:	01 c2                	add    %eax,%edx
  803163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803166:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803173:	8b 45 08             	mov    0x8(%ebp),%eax
  803176:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80317d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803181:	75 17                	jne    80319a <insert_sorted_with_merge_freeList+0x4bd>
  803183:	83 ec 04             	sub    $0x4,%esp
  803186:	68 58 3f 80 00       	push   $0x803f58
  80318b:	68 64 01 00 00       	push   $0x164
  803190:	68 7b 3f 80 00       	push   $0x803f7b
  803195:	e8 e4 d1 ff ff       	call   80037e <_panic>
  80319a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	89 10                	mov    %edx,(%eax)
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 0d                	je     8031bb <insert_sorted_with_merge_freeList+0x4de>
  8031ae:	a1 48 51 80 00       	mov    0x805148,%eax
  8031b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b6:	89 50 04             	mov    %edx,0x4(%eax)
  8031b9:	eb 08                	jmp    8031c3 <insert_sorted_with_merge_freeList+0x4e6>
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	a3 48 51 80 00       	mov    %eax,0x805148
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8031da:	40                   	inc    %eax
  8031db:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031e0:	e9 41 02 00 00       	jmp    803426 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 50 08             	mov    0x8(%eax),%edx
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f1:	01 c2                	add    %eax,%edx
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	8b 40 08             	mov    0x8(%eax),%eax
  8031f9:	39 c2                	cmp    %eax,%edx
  8031fb:	0f 85 7c 01 00 00    	jne    80337d <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803201:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803205:	74 06                	je     80320d <insert_sorted_with_merge_freeList+0x530>
  803207:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320b:	75 17                	jne    803224 <insert_sorted_with_merge_freeList+0x547>
  80320d:	83 ec 04             	sub    $0x4,%esp
  803210:	68 94 3f 80 00       	push   $0x803f94
  803215:	68 69 01 00 00       	push   $0x169
  80321a:	68 7b 3f 80 00       	push   $0x803f7b
  80321f:	e8 5a d1 ff ff       	call   80037e <_panic>
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	8b 50 04             	mov    0x4(%eax),%edx
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	85 c0                	test   %eax,%eax
  803240:	74 0d                	je     80324f <insert_sorted_with_merge_freeList+0x572>
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	8b 40 04             	mov    0x4(%eax),%eax
  803248:	8b 55 08             	mov    0x8(%ebp),%edx
  80324b:	89 10                	mov    %edx,(%eax)
  80324d:	eb 08                	jmp    803257 <insert_sorted_with_merge_freeList+0x57a>
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	a3 38 51 80 00       	mov    %eax,0x805138
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 55 08             	mov    0x8(%ebp),%edx
  80325d:	89 50 04             	mov    %edx,0x4(%eax)
  803260:	a1 44 51 80 00       	mov    0x805144,%eax
  803265:	40                   	inc    %eax
  803266:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 50 0c             	mov    0xc(%eax),%edx
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 40 0c             	mov    0xc(%eax),%eax
  803277:	01 c2                	add    %eax,%edx
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80327f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803283:	75 17                	jne    80329c <insert_sorted_with_merge_freeList+0x5bf>
  803285:	83 ec 04             	sub    $0x4,%esp
  803288:	68 24 40 80 00       	push   $0x804024
  80328d:	68 6b 01 00 00       	push   $0x16b
  803292:	68 7b 3f 80 00       	push   $0x803f7b
  803297:	e8 e2 d0 ff ff       	call   80037e <_panic>
  80329c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329f:	8b 00                	mov    (%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 10                	je     8032b5 <insert_sorted_with_merge_freeList+0x5d8>
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	8b 00                	mov    (%eax),%eax
  8032aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ad:	8b 52 04             	mov    0x4(%edx),%edx
  8032b0:	89 50 04             	mov    %edx,0x4(%eax)
  8032b3:	eb 0b                	jmp    8032c0 <insert_sorted_with_merge_freeList+0x5e3>
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	8b 40 04             	mov    0x4(%eax),%eax
  8032bb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c3:	8b 40 04             	mov    0x4(%eax),%eax
  8032c6:	85 c0                	test   %eax,%eax
  8032c8:	74 0f                	je     8032d9 <insert_sorted_with_merge_freeList+0x5fc>
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 40 04             	mov    0x4(%eax),%eax
  8032d0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d3:	8b 12                	mov    (%edx),%edx
  8032d5:	89 10                	mov    %edx,(%eax)
  8032d7:	eb 0a                	jmp    8032e3 <insert_sorted_with_merge_freeList+0x606>
  8032d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8032fb:	48                   	dec    %eax
  8032fc:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803315:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803319:	75 17                	jne    803332 <insert_sorted_with_merge_freeList+0x655>
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	68 58 3f 80 00       	push   $0x803f58
  803323:	68 6e 01 00 00       	push   $0x16e
  803328:	68 7b 3f 80 00       	push   $0x803f7b
  80332d:	e8 4c d0 ff ff       	call   80037e <_panic>
  803332:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803338:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333b:	89 10                	mov    %edx,(%eax)
  80333d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803340:	8b 00                	mov    (%eax),%eax
  803342:	85 c0                	test   %eax,%eax
  803344:	74 0d                	je     803353 <insert_sorted_with_merge_freeList+0x676>
  803346:	a1 48 51 80 00       	mov    0x805148,%eax
  80334b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334e:	89 50 04             	mov    %edx,0x4(%eax)
  803351:	eb 08                	jmp    80335b <insert_sorted_with_merge_freeList+0x67e>
  803353:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803356:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	a3 48 51 80 00       	mov    %eax,0x805148
  803363:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803366:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80336d:	a1 54 51 80 00       	mov    0x805154,%eax
  803372:	40                   	inc    %eax
  803373:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803378:	e9 a9 00 00 00       	jmp    803426 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80337d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803381:	74 06                	je     803389 <insert_sorted_with_merge_freeList+0x6ac>
  803383:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803387:	75 17                	jne    8033a0 <insert_sorted_with_merge_freeList+0x6c3>
  803389:	83 ec 04             	sub    $0x4,%esp
  80338c:	68 f0 3f 80 00       	push   $0x803ff0
  803391:	68 73 01 00 00       	push   $0x173
  803396:	68 7b 3f 80 00       	push   $0x803f7b
  80339b:	e8 de cf ff ff       	call   80037e <_panic>
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 10                	mov    (%eax),%edx
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	89 10                	mov    %edx,(%eax)
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	74 0b                	je     8033be <insert_sorted_with_merge_freeList+0x6e1>
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bb:	89 50 04             	mov    %edx,0x4(%eax)
  8033be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c4:	89 10                	mov    %edx,(%eax)
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033cc:	89 50 04             	mov    %edx,0x4(%eax)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	75 08                	jne    8033e0 <insert_sorted_with_merge_freeList+0x703>
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e5:	40                   	inc    %eax
  8033e6:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033eb:	eb 39                	jmp    803426 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8033f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f9:	74 07                	je     803402 <insert_sorted_with_merge_freeList+0x725>
  8033fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fe:	8b 00                	mov    (%eax),%eax
  803400:	eb 05                	jmp    803407 <insert_sorted_with_merge_freeList+0x72a>
  803402:	b8 00 00 00 00       	mov    $0x0,%eax
  803407:	a3 40 51 80 00       	mov    %eax,0x805140
  80340c:	a1 40 51 80 00       	mov    0x805140,%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	0f 85 c7 fb ff ff    	jne    802fe0 <insert_sorted_with_merge_freeList+0x303>
  803419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341d:	0f 85 bd fb ff ff    	jne    802fe0 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803423:	eb 01                	jmp    803426 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803425:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803426:	90                   	nop
  803427:	c9                   	leave  
  803428:	c3                   	ret    
  803429:	66 90                	xchg   %ax,%ax
  80342b:	90                   	nop

0080342c <__udivdi3>:
  80342c:	55                   	push   %ebp
  80342d:	57                   	push   %edi
  80342e:	56                   	push   %esi
  80342f:	53                   	push   %ebx
  803430:	83 ec 1c             	sub    $0x1c,%esp
  803433:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803437:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80343b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80343f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803443:	89 ca                	mov    %ecx,%edx
  803445:	89 f8                	mov    %edi,%eax
  803447:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80344b:	85 f6                	test   %esi,%esi
  80344d:	75 2d                	jne    80347c <__udivdi3+0x50>
  80344f:	39 cf                	cmp    %ecx,%edi
  803451:	77 65                	ja     8034b8 <__udivdi3+0x8c>
  803453:	89 fd                	mov    %edi,%ebp
  803455:	85 ff                	test   %edi,%edi
  803457:	75 0b                	jne    803464 <__udivdi3+0x38>
  803459:	b8 01 00 00 00       	mov    $0x1,%eax
  80345e:	31 d2                	xor    %edx,%edx
  803460:	f7 f7                	div    %edi
  803462:	89 c5                	mov    %eax,%ebp
  803464:	31 d2                	xor    %edx,%edx
  803466:	89 c8                	mov    %ecx,%eax
  803468:	f7 f5                	div    %ebp
  80346a:	89 c1                	mov    %eax,%ecx
  80346c:	89 d8                	mov    %ebx,%eax
  80346e:	f7 f5                	div    %ebp
  803470:	89 cf                	mov    %ecx,%edi
  803472:	89 fa                	mov    %edi,%edx
  803474:	83 c4 1c             	add    $0x1c,%esp
  803477:	5b                   	pop    %ebx
  803478:	5e                   	pop    %esi
  803479:	5f                   	pop    %edi
  80347a:	5d                   	pop    %ebp
  80347b:	c3                   	ret    
  80347c:	39 ce                	cmp    %ecx,%esi
  80347e:	77 28                	ja     8034a8 <__udivdi3+0x7c>
  803480:	0f bd fe             	bsr    %esi,%edi
  803483:	83 f7 1f             	xor    $0x1f,%edi
  803486:	75 40                	jne    8034c8 <__udivdi3+0x9c>
  803488:	39 ce                	cmp    %ecx,%esi
  80348a:	72 0a                	jb     803496 <__udivdi3+0x6a>
  80348c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803490:	0f 87 9e 00 00 00    	ja     803534 <__udivdi3+0x108>
  803496:	b8 01 00 00 00       	mov    $0x1,%eax
  80349b:	89 fa                	mov    %edi,%edx
  80349d:	83 c4 1c             	add    $0x1c,%esp
  8034a0:	5b                   	pop    %ebx
  8034a1:	5e                   	pop    %esi
  8034a2:	5f                   	pop    %edi
  8034a3:	5d                   	pop    %ebp
  8034a4:	c3                   	ret    
  8034a5:	8d 76 00             	lea    0x0(%esi),%esi
  8034a8:	31 ff                	xor    %edi,%edi
  8034aa:	31 c0                	xor    %eax,%eax
  8034ac:	89 fa                	mov    %edi,%edx
  8034ae:	83 c4 1c             	add    $0x1c,%esp
  8034b1:	5b                   	pop    %ebx
  8034b2:	5e                   	pop    %esi
  8034b3:	5f                   	pop    %edi
  8034b4:	5d                   	pop    %ebp
  8034b5:	c3                   	ret    
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	89 d8                	mov    %ebx,%eax
  8034ba:	f7 f7                	div    %edi
  8034bc:	31 ff                	xor    %edi,%edi
  8034be:	89 fa                	mov    %edi,%edx
  8034c0:	83 c4 1c             	add    $0x1c,%esp
  8034c3:	5b                   	pop    %ebx
  8034c4:	5e                   	pop    %esi
  8034c5:	5f                   	pop    %edi
  8034c6:	5d                   	pop    %ebp
  8034c7:	c3                   	ret    
  8034c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034cd:	89 eb                	mov    %ebp,%ebx
  8034cf:	29 fb                	sub    %edi,%ebx
  8034d1:	89 f9                	mov    %edi,%ecx
  8034d3:	d3 e6                	shl    %cl,%esi
  8034d5:	89 c5                	mov    %eax,%ebp
  8034d7:	88 d9                	mov    %bl,%cl
  8034d9:	d3 ed                	shr    %cl,%ebp
  8034db:	89 e9                	mov    %ebp,%ecx
  8034dd:	09 f1                	or     %esi,%ecx
  8034df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034e3:	89 f9                	mov    %edi,%ecx
  8034e5:	d3 e0                	shl    %cl,%eax
  8034e7:	89 c5                	mov    %eax,%ebp
  8034e9:	89 d6                	mov    %edx,%esi
  8034eb:	88 d9                	mov    %bl,%cl
  8034ed:	d3 ee                	shr    %cl,%esi
  8034ef:	89 f9                	mov    %edi,%ecx
  8034f1:	d3 e2                	shl    %cl,%edx
  8034f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034f7:	88 d9                	mov    %bl,%cl
  8034f9:	d3 e8                	shr    %cl,%eax
  8034fb:	09 c2                	or     %eax,%edx
  8034fd:	89 d0                	mov    %edx,%eax
  8034ff:	89 f2                	mov    %esi,%edx
  803501:	f7 74 24 0c          	divl   0xc(%esp)
  803505:	89 d6                	mov    %edx,%esi
  803507:	89 c3                	mov    %eax,%ebx
  803509:	f7 e5                	mul    %ebp
  80350b:	39 d6                	cmp    %edx,%esi
  80350d:	72 19                	jb     803528 <__udivdi3+0xfc>
  80350f:	74 0b                	je     80351c <__udivdi3+0xf0>
  803511:	89 d8                	mov    %ebx,%eax
  803513:	31 ff                	xor    %edi,%edi
  803515:	e9 58 ff ff ff       	jmp    803472 <__udivdi3+0x46>
  80351a:	66 90                	xchg   %ax,%ax
  80351c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803520:	89 f9                	mov    %edi,%ecx
  803522:	d3 e2                	shl    %cl,%edx
  803524:	39 c2                	cmp    %eax,%edx
  803526:	73 e9                	jae    803511 <__udivdi3+0xe5>
  803528:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80352b:	31 ff                	xor    %edi,%edi
  80352d:	e9 40 ff ff ff       	jmp    803472 <__udivdi3+0x46>
  803532:	66 90                	xchg   %ax,%ax
  803534:	31 c0                	xor    %eax,%eax
  803536:	e9 37 ff ff ff       	jmp    803472 <__udivdi3+0x46>
  80353b:	90                   	nop

0080353c <__umoddi3>:
  80353c:	55                   	push   %ebp
  80353d:	57                   	push   %edi
  80353e:	56                   	push   %esi
  80353f:	53                   	push   %ebx
  803540:	83 ec 1c             	sub    $0x1c,%esp
  803543:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803547:	8b 74 24 34          	mov    0x34(%esp),%esi
  80354b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80354f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803553:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803557:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80355b:	89 f3                	mov    %esi,%ebx
  80355d:	89 fa                	mov    %edi,%edx
  80355f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803563:	89 34 24             	mov    %esi,(%esp)
  803566:	85 c0                	test   %eax,%eax
  803568:	75 1a                	jne    803584 <__umoddi3+0x48>
  80356a:	39 f7                	cmp    %esi,%edi
  80356c:	0f 86 a2 00 00 00    	jbe    803614 <__umoddi3+0xd8>
  803572:	89 c8                	mov    %ecx,%eax
  803574:	89 f2                	mov    %esi,%edx
  803576:	f7 f7                	div    %edi
  803578:	89 d0                	mov    %edx,%eax
  80357a:	31 d2                	xor    %edx,%edx
  80357c:	83 c4 1c             	add    $0x1c,%esp
  80357f:	5b                   	pop    %ebx
  803580:	5e                   	pop    %esi
  803581:	5f                   	pop    %edi
  803582:	5d                   	pop    %ebp
  803583:	c3                   	ret    
  803584:	39 f0                	cmp    %esi,%eax
  803586:	0f 87 ac 00 00 00    	ja     803638 <__umoddi3+0xfc>
  80358c:	0f bd e8             	bsr    %eax,%ebp
  80358f:	83 f5 1f             	xor    $0x1f,%ebp
  803592:	0f 84 ac 00 00 00    	je     803644 <__umoddi3+0x108>
  803598:	bf 20 00 00 00       	mov    $0x20,%edi
  80359d:	29 ef                	sub    %ebp,%edi
  80359f:	89 fe                	mov    %edi,%esi
  8035a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035a5:	89 e9                	mov    %ebp,%ecx
  8035a7:	d3 e0                	shl    %cl,%eax
  8035a9:	89 d7                	mov    %edx,%edi
  8035ab:	89 f1                	mov    %esi,%ecx
  8035ad:	d3 ef                	shr    %cl,%edi
  8035af:	09 c7                	or     %eax,%edi
  8035b1:	89 e9                	mov    %ebp,%ecx
  8035b3:	d3 e2                	shl    %cl,%edx
  8035b5:	89 14 24             	mov    %edx,(%esp)
  8035b8:	89 d8                	mov    %ebx,%eax
  8035ba:	d3 e0                	shl    %cl,%eax
  8035bc:	89 c2                	mov    %eax,%edx
  8035be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c2:	d3 e0                	shl    %cl,%eax
  8035c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035cc:	89 f1                	mov    %esi,%ecx
  8035ce:	d3 e8                	shr    %cl,%eax
  8035d0:	09 d0                	or     %edx,%eax
  8035d2:	d3 eb                	shr    %cl,%ebx
  8035d4:	89 da                	mov    %ebx,%edx
  8035d6:	f7 f7                	div    %edi
  8035d8:	89 d3                	mov    %edx,%ebx
  8035da:	f7 24 24             	mull   (%esp)
  8035dd:	89 c6                	mov    %eax,%esi
  8035df:	89 d1                	mov    %edx,%ecx
  8035e1:	39 d3                	cmp    %edx,%ebx
  8035e3:	0f 82 87 00 00 00    	jb     803670 <__umoddi3+0x134>
  8035e9:	0f 84 91 00 00 00    	je     803680 <__umoddi3+0x144>
  8035ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035f3:	29 f2                	sub    %esi,%edx
  8035f5:	19 cb                	sbb    %ecx,%ebx
  8035f7:	89 d8                	mov    %ebx,%eax
  8035f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035fd:	d3 e0                	shl    %cl,%eax
  8035ff:	89 e9                	mov    %ebp,%ecx
  803601:	d3 ea                	shr    %cl,%edx
  803603:	09 d0                	or     %edx,%eax
  803605:	89 e9                	mov    %ebp,%ecx
  803607:	d3 eb                	shr    %cl,%ebx
  803609:	89 da                	mov    %ebx,%edx
  80360b:	83 c4 1c             	add    $0x1c,%esp
  80360e:	5b                   	pop    %ebx
  80360f:	5e                   	pop    %esi
  803610:	5f                   	pop    %edi
  803611:	5d                   	pop    %ebp
  803612:	c3                   	ret    
  803613:	90                   	nop
  803614:	89 fd                	mov    %edi,%ebp
  803616:	85 ff                	test   %edi,%edi
  803618:	75 0b                	jne    803625 <__umoddi3+0xe9>
  80361a:	b8 01 00 00 00       	mov    $0x1,%eax
  80361f:	31 d2                	xor    %edx,%edx
  803621:	f7 f7                	div    %edi
  803623:	89 c5                	mov    %eax,%ebp
  803625:	89 f0                	mov    %esi,%eax
  803627:	31 d2                	xor    %edx,%edx
  803629:	f7 f5                	div    %ebp
  80362b:	89 c8                	mov    %ecx,%eax
  80362d:	f7 f5                	div    %ebp
  80362f:	89 d0                	mov    %edx,%eax
  803631:	e9 44 ff ff ff       	jmp    80357a <__umoddi3+0x3e>
  803636:	66 90                	xchg   %ax,%ax
  803638:	89 c8                	mov    %ecx,%eax
  80363a:	89 f2                	mov    %esi,%edx
  80363c:	83 c4 1c             	add    $0x1c,%esp
  80363f:	5b                   	pop    %ebx
  803640:	5e                   	pop    %esi
  803641:	5f                   	pop    %edi
  803642:	5d                   	pop    %ebp
  803643:	c3                   	ret    
  803644:	3b 04 24             	cmp    (%esp),%eax
  803647:	72 06                	jb     80364f <__umoddi3+0x113>
  803649:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80364d:	77 0f                	ja     80365e <__umoddi3+0x122>
  80364f:	89 f2                	mov    %esi,%edx
  803651:	29 f9                	sub    %edi,%ecx
  803653:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803657:	89 14 24             	mov    %edx,(%esp)
  80365a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80365e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803662:	8b 14 24             	mov    (%esp),%edx
  803665:	83 c4 1c             	add    $0x1c,%esp
  803668:	5b                   	pop    %ebx
  803669:	5e                   	pop    %esi
  80366a:	5f                   	pop    %edi
  80366b:	5d                   	pop    %ebp
  80366c:	c3                   	ret    
  80366d:	8d 76 00             	lea    0x0(%esi),%esi
  803670:	2b 04 24             	sub    (%esp),%eax
  803673:	19 fa                	sbb    %edi,%edx
  803675:	89 d1                	mov    %edx,%ecx
  803677:	89 c6                	mov    %eax,%esi
  803679:	e9 71 ff ff ff       	jmp    8035ef <__umoddi3+0xb3>
  80367e:	66 90                	xchg   %ax,%ax
  803680:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803684:	72 ea                	jb     803670 <__umoddi3+0x134>
  803686:	89 d9                	mov    %ebx,%ecx
  803688:	e9 62 ff ff ff       	jmp    8035ef <__umoddi3+0xb3>
