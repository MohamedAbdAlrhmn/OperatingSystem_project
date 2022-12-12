
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
  800082:	e8 5b 18 00 00       	call   8018e2 <sys_pf_calculate_allocated_pages>
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
  800102:	e8 3b 17 00 00       	call   801842 <sys_calculate_free_frames>
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
  800152:	bb 7c 37 80 00       	mov    $0x80377c,%ebx
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
  8001d7:	68 80 36 80 00       	push   $0x803680
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 e1 36 80 00       	push   $0x8036e1
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
  8001f8:	e8 45 16 00 00       	call   801842 <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 34 16 00 00       	call   801842 <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 f8 36 80 00       	push   $0x8036f8
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 e1 36 80 00       	push   $0x8036e1
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 3c 37 80 00       	push   $0x80373c
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
  800248:	e8 d5 18 00 00       	call   801b22 <sys_getenvindex>
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
  8002b3:	e8 77 16 00 00       	call   80192f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 b0 37 80 00       	push   $0x8037b0
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
  8002e3:	68 d8 37 80 00       	push   $0x8037d8
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
  800314:	68 00 38 80 00       	push   $0x803800
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 50 80 00       	mov    0x805020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 58 38 80 00       	push   $0x803858
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 b0 37 80 00       	push   $0x8037b0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 f7 15 00 00       	call   801949 <sys_enable_interrupt>

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
  800365:	e8 84 17 00 00       	call   801aee <sys_destroy_env>
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
  800376:	e8 d9 17 00 00       	call   801b54 <sys_exit_env>
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
  80039f:	68 6c 38 80 00       	push   $0x80386c
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 50 80 00       	mov    0x805000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 71 38 80 00       	push   $0x803871
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
  8003dc:	68 8d 38 80 00       	push   $0x80388d
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
  800408:	68 90 38 80 00       	push   $0x803890
  80040d:	6a 26                	push   $0x26
  80040f:	68 dc 38 80 00       	push   $0x8038dc
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
  8004da:	68 e8 38 80 00       	push   $0x8038e8
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 dc 38 80 00       	push   $0x8038dc
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
  80054a:	68 3c 39 80 00       	push   $0x80393c
  80054f:	6a 44                	push   $0x44
  800551:	68 dc 38 80 00       	push   $0x8038dc
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
  8005a4:	e8 d8 11 00 00       	call   801781 <sys_cputs>
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
  80061b:	e8 61 11 00 00       	call   801781 <sys_cputs>
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
  800665:	e8 c5 12 00 00       	call   80192f <sys_disable_interrupt>
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
  800685:	e8 bf 12 00 00       	call   801949 <sys_enable_interrupt>
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
  8006cf:	e8 30 2d 00 00       	call   803404 <__udivdi3>
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
  80071f:	e8 f0 2d 00 00       	call   803514 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 b4 3b 80 00       	add    $0x803bb4,%eax
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
  80087a:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
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
  80095b:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 c5 3b 80 00       	push   $0x803bc5
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
  800980:	68 ce 3b 80 00       	push   $0x803bce
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
  8009ad:	be d1 3b 80 00       	mov    $0x803bd1,%esi
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
  8013d3:	68 30 3d 80 00       	push   $0x803d30
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
  8014a3:	e8 1d 04 00 00       	call   8018c5 <sys_allocate_chunk>
  8014a8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ab:	a1 20 51 80 00       	mov    0x805120,%eax
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	50                   	push   %eax
  8014b4:	e8 92 0a 00 00       	call   801f4b <initialize_MemBlocksList>
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
  8014e1:	68 55 3d 80 00       	push   $0x803d55
  8014e6:	6a 33                	push   $0x33
  8014e8:	68 73 3d 80 00       	push   $0x803d73
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
  801560:	68 80 3d 80 00       	push   $0x803d80
  801565:	6a 34                	push   $0x34
  801567:	68 73 3d 80 00       	push   $0x803d73
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
  8015d5:	68 a4 3d 80 00       	push   $0x803da4
  8015da:	6a 46                	push   $0x46
  8015dc:	68 73 3d 80 00       	push   $0x803d73
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
  8015f1:	68 cc 3d 80 00       	push   $0x803dcc
  8015f6:	6a 61                	push   $0x61
  8015f8:	68 73 3d 80 00       	push   $0x803d73
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
  801617:	75 07                	jne    801620 <smalloc+0x1e>
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
  80161e:	eb 7c                	jmp    80169c <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801620:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162d:	01 d0                	add    %edx,%eax
  80162f:	48                   	dec    %eax
  801630:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801636:	ba 00 00 00 00       	mov    $0x0,%edx
  80163b:	f7 75 f0             	divl   -0x10(%ebp)
  80163e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801641:	29 d0                	sub    %edx,%eax
  801643:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801646:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80164d:	e8 41 06 00 00       	call   801c93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801652:	85 c0                	test   %eax,%eax
  801654:	74 11                	je     801667 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	ff 75 e8             	pushl  -0x18(%ebp)
  80165c:	e8 ac 0c 00 00       	call   80230d <alloc_block_FF>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801667:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80166b:	74 2a                	je     801697 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	8b 40 08             	mov    0x8(%eax),%eax
  801673:	89 c2                	mov    %eax,%edx
  801675:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801679:	52                   	push   %edx
  80167a:	50                   	push   %eax
  80167b:	ff 75 0c             	pushl  0xc(%ebp)
  80167e:	ff 75 08             	pushl  0x8(%ebp)
  801681:	e8 92 03 00 00       	call   801a18 <sys_createSharedObject>
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80168c:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801690:	74 05                	je     801697 <smalloc+0x95>
			return (void*)virtual_address;
  801692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801695:	eb 05                	jmp    80169c <smalloc+0x9a>
	}
	return NULL;
  801697:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a4:	e8 13 fd ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016a9:	83 ec 04             	sub    $0x4,%esp
  8016ac:	68 f0 3d 80 00       	push   $0x803df0
  8016b1:	68 a2 00 00 00       	push   $0xa2
  8016b6:	68 73 3d 80 00       	push   $0x803d73
  8016bb:	e8 be ec ff ff       	call   80037e <_panic>

008016c0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c6:	e8 f1 fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016cb:	83 ec 04             	sub    $0x4,%esp
  8016ce:	68 14 3e 80 00       	push   $0x803e14
  8016d3:	68 e6 00 00 00       	push   $0xe6
  8016d8:	68 73 3d 80 00       	push   $0x803d73
  8016dd:	e8 9c ec ff ff       	call   80037e <_panic>

008016e2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 3c 3e 80 00       	push   $0x803e3c
  8016f0:	68 fa 00 00 00       	push   $0xfa
  8016f5:	68 73 3d 80 00       	push   $0x803d73
  8016fa:	e8 7f ec ff ff       	call   80037e <_panic>

008016ff <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801705:	83 ec 04             	sub    $0x4,%esp
  801708:	68 60 3e 80 00       	push   $0x803e60
  80170d:	68 05 01 00 00       	push   $0x105
  801712:	68 73 3d 80 00       	push   $0x803d73
  801717:	e8 62 ec ff ff       	call   80037e <_panic>

0080171c <shrink>:

}
void shrink(uint32 newSize)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801722:	83 ec 04             	sub    $0x4,%esp
  801725:	68 60 3e 80 00       	push   $0x803e60
  80172a:	68 0a 01 00 00       	push   $0x10a
  80172f:	68 73 3d 80 00       	push   $0x803d73
  801734:	e8 45 ec ff ff       	call   80037e <_panic>

00801739 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	68 60 3e 80 00       	push   $0x803e60
  801747:	68 0f 01 00 00       	push   $0x10f
  80174c:	68 73 3d 80 00       	push   $0x803d73
  801751:	e8 28 ec ff ff       	call   80037e <_panic>

00801756 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	57                   	push   %edi
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8b 55 0c             	mov    0xc(%ebp),%edx
  801765:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801768:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80176b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80176e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801771:	cd 30                	int    $0x30
  801773:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801776:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801779:	83 c4 10             	add    $0x10,%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5f                   	pop    %edi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	8b 45 10             	mov    0x10(%ebp),%eax
  80178a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80178d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	52                   	push   %edx
  801799:	ff 75 0c             	pushl  0xc(%ebp)
  80179c:	50                   	push   %eax
  80179d:	6a 00                	push   $0x0
  80179f:	e8 b2 ff ff ff       	call   801756 <syscall>
  8017a4:	83 c4 18             	add    $0x18,%esp
}
  8017a7:	90                   	nop
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_cgetc>:

int
sys_cgetc(void)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 01                	push   $0x1
  8017b9:	e8 98 ff ff ff       	call   801756 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	52                   	push   %edx
  8017d3:	50                   	push   %eax
  8017d4:	6a 05                	push   $0x5
  8017d6:	e8 7b ff ff ff       	call   801756 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	56                   	push   %esi
  8017e4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017e5:	8b 75 18             	mov    0x18(%ebp),%esi
  8017e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	51                   	push   %ecx
  8017f7:	52                   	push   %edx
  8017f8:	50                   	push   %eax
  8017f9:	6a 06                	push   $0x6
  8017fb:	e8 56 ff ff ff       	call   801756 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801806:	5b                   	pop    %ebx
  801807:	5e                   	pop    %esi
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    

0080180a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	6a 07                	push   $0x7
  80181d:	e8 34 ff ff ff       	call   801756 <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
}
  801825:	c9                   	leave  
  801826:	c3                   	ret    

00801827 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	ff 75 08             	pushl  0x8(%ebp)
  801836:	6a 08                	push   $0x8
  801838:	e8 19 ff ff ff       	call   801756 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 09                	push   $0x9
  801851:	e8 00 ff ff ff       	call   801756 <syscall>
  801856:	83 c4 18             	add    $0x18,%esp
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 0a                	push   $0xa
  80186a:	e8 e7 fe ff ff       	call   801756 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 0b                	push   $0xb
  801883:	e8 ce fe ff ff       	call   801756 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	ff 75 0c             	pushl  0xc(%ebp)
  801899:	ff 75 08             	pushl  0x8(%ebp)
  80189c:	6a 0f                	push   $0xf
  80189e:	e8 b3 fe ff ff       	call   801756 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
	return;
  8018a6:	90                   	nop
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	6a 10                	push   $0x10
  8018ba:	e8 97 fe ff ff       	call   801756 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c2:	90                   	nop
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	ff 75 10             	pushl  0x10(%ebp)
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 11                	push   $0x11
  8018d7:	e8 7a fe ff ff       	call   801756 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018df:	90                   	nop
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 0c                	push   $0xc
  8018f1:	e8 60 fe ff ff       	call   801756 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	6a 0d                	push   $0xd
  80190b:	e8 46 fe ff ff       	call   801756 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 0e                	push   $0xe
  801924:	e8 2d fe ff ff       	call   801756 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
}
  80192c:	90                   	nop
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 13                	push   $0x13
  80193e:	e8 13 fe ff ff       	call   801756 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	90                   	nop
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 14                	push   $0x14
  801958:	e8 f9 fd ff ff       	call   801756 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	90                   	nop
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_cputc>:


void
sys_cputc(const char c)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80196f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	50                   	push   %eax
  80197c:	6a 15                	push   $0x15
  80197e:	e8 d3 fd ff ff       	call   801756 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	90                   	nop
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 16                	push   $0x16
  801998:	e8 b9 fd ff ff       	call   801756 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	90                   	nop
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	50                   	push   %eax
  8019b3:	6a 17                	push   $0x17
  8019b5:	e8 9c fd ff ff       	call   801756 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	52                   	push   %edx
  8019cf:	50                   	push   %eax
  8019d0:	6a 1a                	push   $0x1a
  8019d2:	e8 7f fd ff ff       	call   801756 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	52                   	push   %edx
  8019ec:	50                   	push   %eax
  8019ed:	6a 18                	push   $0x18
  8019ef:	e8 62 fd ff ff       	call   801756 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	52                   	push   %edx
  801a0a:	50                   	push   %eax
  801a0b:	6a 19                	push   $0x19
  801a0d:	e8 44 fd ff ff       	call   801756 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	51                   	push   %ecx
  801a31:	52                   	push   %edx
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	50                   	push   %eax
  801a36:	6a 1b                	push   $0x1b
  801a38:	e8 19 fd ff ff       	call   801756 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	52                   	push   %edx
  801a52:	50                   	push   %eax
  801a53:	6a 1c                	push   $0x1c
  801a55:	e8 fc fc ff ff       	call   801756 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	51                   	push   %ecx
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 1d                	push   $0x1d
  801a74:	e8 dd fc ff ff       	call   801756 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	52                   	push   %edx
  801a8e:	50                   	push   %eax
  801a8f:	6a 1e                	push   $0x1e
  801a91:	e8 c0 fc ff ff       	call   801756 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 1f                	push   $0x1f
  801aaa:	e8 a7 fc ff ff       	call   801756 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aba:	6a 00                	push   $0x0
  801abc:	ff 75 14             	pushl  0x14(%ebp)
  801abf:	ff 75 10             	pushl  0x10(%ebp)
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	50                   	push   %eax
  801ac6:	6a 20                	push   $0x20
  801ac8:	e8 89 fc ff ff       	call   801756 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 21                	push   $0x21
  801ae3:	e8 6e fc ff ff       	call   801756 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	50                   	push   %eax
  801afd:	6a 22                	push   $0x22
  801aff:	e8 52 fc ff ff       	call   801756 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 02                	push   $0x2
  801b18:	e8 39 fc ff ff       	call   801756 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 03                	push   $0x3
  801b31:	e8 20 fc ff ff       	call   801756 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 04                	push   $0x4
  801b4a:	e8 07 fc ff ff       	call   801756 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_exit_env>:


void sys_exit_env(void)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 23                	push   $0x23
  801b63:	e8 ee fb ff ff       	call   801756 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b77:	8d 50 04             	lea    0x4(%eax),%edx
  801b7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 24                	push   $0x24
  801b87:	e8 ca fb ff ff       	call   801756 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801b8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b98:	89 01                	mov    %eax,(%ecx)
  801b9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	c9                   	leave  
  801ba1:	c2 04 00             	ret    $0x4

00801ba4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	ff 75 10             	pushl  0x10(%ebp)
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	6a 12                	push   $0x12
  801bb6:	e8 9b fb ff ff       	call   801756 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bbe:	90                   	nop
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 25                	push   $0x25
  801bd0:	e8 81 fb ff ff       	call   801756 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 04             	sub    $0x4,%esp
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801be6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	50                   	push   %eax
  801bf3:	6a 26                	push   $0x26
  801bf5:	e8 5c fb ff ff       	call   801756 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfd:	90                   	nop
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <rsttst>:
void rsttst()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 28                	push   $0x28
  801c0f:	e8 42 fb ff ff       	call   801756 <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return ;
  801c17:	90                   	nop
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 04             	sub    $0x4,%esp
  801c20:	8b 45 14             	mov    0x14(%ebp),%eax
  801c23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c26:	8b 55 18             	mov    0x18(%ebp),%edx
  801c29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c2d:	52                   	push   %edx
  801c2e:	50                   	push   %eax
  801c2f:	ff 75 10             	pushl  0x10(%ebp)
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	ff 75 08             	pushl  0x8(%ebp)
  801c38:	6a 27                	push   $0x27
  801c3a:	e8 17 fb ff ff       	call   801756 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c42:	90                   	nop
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <chktst>:
void chktst(uint32 n)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	ff 75 08             	pushl  0x8(%ebp)
  801c53:	6a 29                	push   $0x29
  801c55:	e8 fc fa ff ff       	call   801756 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5d:	90                   	nop
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <inctst>:

void inctst()
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 2a                	push   $0x2a
  801c6f:	e8 e2 fa ff ff       	call   801756 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
	return ;
  801c77:	90                   	nop
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <gettst>:
uint32 gettst()
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 2b                	push   $0x2b
  801c89:	e8 c8 fa ff ff       	call   801756 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 2c                	push   $0x2c
  801ca5:	e8 ac fa ff ff       	call   801756 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
  801cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cb0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cb4:	75 07                	jne    801cbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbb:	eb 05                	jmp    801cc2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 2c                	push   $0x2c
  801cd6:	e8 7b fa ff ff       	call   801756 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
  801cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ce1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ce5:	75 07                	jne    801cee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ce7:	b8 01 00 00 00       	mov    $0x1,%eax
  801cec:	eb 05                	jmp    801cf3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 2c                	push   $0x2c
  801d07:	e8 4a fa ff ff       	call   801756 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
  801d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d12:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d16:	75 07                	jne    801d1f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d18:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1d:	eb 05                	jmp    801d24 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 2c                	push   $0x2c
  801d38:	e8 19 fa ff ff       	call   801756 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
  801d40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d43:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d47:	75 07                	jne    801d50 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d49:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4e:	eb 05                	jmp    801d55 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	6a 2d                	push   $0x2d
  801d67:	e8 ea f9 ff ff       	call   801756 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6f:	90                   	nop
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d76:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d79:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	53                   	push   %ebx
  801d85:	51                   	push   %ecx
  801d86:	52                   	push   %edx
  801d87:	50                   	push   %eax
  801d88:	6a 2e                	push   $0x2e
  801d8a:	e8 c7 f9 ff ff       	call   801756 <syscall>
  801d8f:	83 c4 18             	add    $0x18,%esp
}
  801d92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	52                   	push   %edx
  801da7:	50                   	push   %eax
  801da8:	6a 2f                	push   $0x2f
  801daa:	e8 a7 f9 ff ff       	call   801756 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dba:	83 ec 0c             	sub    $0xc,%esp
  801dbd:	68 70 3e 80 00       	push   $0x803e70
  801dc2:	e8 6b e8 ff ff       	call   800632 <cprintf>
  801dc7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	68 9c 3e 80 00       	push   $0x803e9c
  801dd9:	e8 54 e8 ff ff       	call   800632 <cprintf>
  801dde:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801de1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801de5:	a1 38 51 80 00       	mov    0x805138,%eax
  801dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ded:	eb 56                	jmp    801e45 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801def:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df3:	74 1c                	je     801e11 <print_mem_block_lists+0x5d>
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	8b 50 08             	mov    0x8(%eax),%edx
  801dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfe:	8b 48 08             	mov    0x8(%eax),%ecx
  801e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e04:	8b 40 0c             	mov    0xc(%eax),%eax
  801e07:	01 c8                	add    %ecx,%eax
  801e09:	39 c2                	cmp    %eax,%edx
  801e0b:	73 04                	jae    801e11 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e0d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e14:	8b 50 08             	mov    0x8(%eax),%edx
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1d:	01 c2                	add    %eax,%edx
  801e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e22:	8b 40 08             	mov    0x8(%eax),%eax
  801e25:	83 ec 04             	sub    $0x4,%esp
  801e28:	52                   	push   %edx
  801e29:	50                   	push   %eax
  801e2a:	68 b1 3e 80 00       	push   $0x803eb1
  801e2f:	e8 fe e7 ff ff       	call   800632 <cprintf>
  801e34:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e3d:	a1 40 51 80 00       	mov    0x805140,%eax
  801e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e49:	74 07                	je     801e52 <print_mem_block_lists+0x9e>
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	8b 00                	mov    (%eax),%eax
  801e50:	eb 05                	jmp    801e57 <print_mem_block_lists+0xa3>
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
  801e57:	a3 40 51 80 00       	mov    %eax,0x805140
  801e5c:	a1 40 51 80 00       	mov    0x805140,%eax
  801e61:	85 c0                	test   %eax,%eax
  801e63:	75 8a                	jne    801def <print_mem_block_lists+0x3b>
  801e65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e69:	75 84                	jne    801def <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e6b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e6f:	75 10                	jne    801e81 <print_mem_block_lists+0xcd>
  801e71:	83 ec 0c             	sub    $0xc,%esp
  801e74:	68 c0 3e 80 00       	push   $0x803ec0
  801e79:	e8 b4 e7 ff ff       	call   800632 <cprintf>
  801e7e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e81:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e88:	83 ec 0c             	sub    $0xc,%esp
  801e8b:	68 e4 3e 80 00       	push   $0x803ee4
  801e90:	e8 9d e7 ff ff       	call   800632 <cprintf>
  801e95:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e98:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e9c:	a1 40 50 80 00       	mov    0x805040,%eax
  801ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea4:	eb 56                	jmp    801efc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eaa:	74 1c                	je     801ec8 <print_mem_block_lists+0x114>
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 50 08             	mov    0x8(%eax),%edx
  801eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb5:	8b 48 08             	mov    0x8(%eax),%ecx
  801eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebe:	01 c8                	add    %ecx,%eax
  801ec0:	39 c2                	cmp    %eax,%edx
  801ec2:	73 04                	jae    801ec8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ec4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecb:	8b 50 08             	mov    0x8(%eax),%edx
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed4:	01 c2                	add    %eax,%edx
  801ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed9:	8b 40 08             	mov    0x8(%eax),%eax
  801edc:	83 ec 04             	sub    $0x4,%esp
  801edf:	52                   	push   %edx
  801ee0:	50                   	push   %eax
  801ee1:	68 b1 3e 80 00       	push   $0x803eb1
  801ee6:	e8 47 e7 ff ff       	call   800632 <cprintf>
  801eeb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ef4:	a1 48 50 80 00       	mov    0x805048,%eax
  801ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f00:	74 07                	je     801f09 <print_mem_block_lists+0x155>
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 00                	mov    (%eax),%eax
  801f07:	eb 05                	jmp    801f0e <print_mem_block_lists+0x15a>
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0e:	a3 48 50 80 00       	mov    %eax,0x805048
  801f13:	a1 48 50 80 00       	mov    0x805048,%eax
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	75 8a                	jne    801ea6 <print_mem_block_lists+0xf2>
  801f1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f20:	75 84                	jne    801ea6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f22:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f26:	75 10                	jne    801f38 <print_mem_block_lists+0x184>
  801f28:	83 ec 0c             	sub    $0xc,%esp
  801f2b:	68 fc 3e 80 00       	push   $0x803efc
  801f30:	e8 fd e6 ff ff       	call   800632 <cprintf>
  801f35:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	68 70 3e 80 00       	push   $0x803e70
  801f40:	e8 ed e6 ff ff       	call   800632 <cprintf>
  801f45:	83 c4 10             	add    $0x10,%esp

}
  801f48:	90                   	nop
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f51:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f58:	00 00 00 
  801f5b:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f62:	00 00 00 
  801f65:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f6c:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f76:	e9 9e 00 00 00       	jmp    802019 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f7b:	a1 50 50 80 00       	mov    0x805050,%eax
  801f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f83:	c1 e2 04             	shl    $0x4,%edx
  801f86:	01 d0                	add    %edx,%eax
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	75 14                	jne    801fa0 <initialize_MemBlocksList+0x55>
  801f8c:	83 ec 04             	sub    $0x4,%esp
  801f8f:	68 24 3f 80 00       	push   $0x803f24
  801f94:	6a 46                	push   $0x46
  801f96:	68 47 3f 80 00       	push   $0x803f47
  801f9b:	e8 de e3 ff ff       	call   80037e <_panic>
  801fa0:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa8:	c1 e2 04             	shl    $0x4,%edx
  801fab:	01 d0                	add    %edx,%eax
  801fad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fb3:	89 10                	mov    %edx,(%eax)
  801fb5:	8b 00                	mov    (%eax),%eax
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	74 18                	je     801fd3 <initialize_MemBlocksList+0x88>
  801fbb:	a1 48 51 80 00       	mov    0x805148,%eax
  801fc0:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fc6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fc9:	c1 e1 04             	shl    $0x4,%ecx
  801fcc:	01 ca                	add    %ecx,%edx
  801fce:	89 50 04             	mov    %edx,0x4(%eax)
  801fd1:	eb 12                	jmp    801fe5 <initialize_MemBlocksList+0x9a>
  801fd3:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdb:	c1 e2 04             	shl    $0x4,%edx
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fe5:	a1 50 50 80 00       	mov    0x805050,%eax
  801fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fed:	c1 e2 04             	shl    $0x4,%edx
  801ff0:	01 d0                	add    %edx,%eax
  801ff2:	a3 48 51 80 00       	mov    %eax,0x805148
  801ff7:	a1 50 50 80 00       	mov    0x805050,%eax
  801ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fff:	c1 e2 04             	shl    $0x4,%edx
  802002:	01 d0                	add    %edx,%eax
  802004:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80200b:	a1 54 51 80 00       	mov    0x805154,%eax
  802010:	40                   	inc    %eax
  802011:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802016:	ff 45 f4             	incl   -0xc(%ebp)
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80201f:	0f 82 56 ff ff ff    	jb     801f7b <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802025:	90                   	nop
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	8b 00                	mov    (%eax),%eax
  802033:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802036:	eb 19                	jmp    802051 <find_block+0x29>
	{
		if(va==point->sva)
  802038:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203b:	8b 40 08             	mov    0x8(%eax),%eax
  80203e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802041:	75 05                	jne    802048 <find_block+0x20>
		   return point;
  802043:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802046:	eb 36                	jmp    80207e <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	8b 40 08             	mov    0x8(%eax),%eax
  80204e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802051:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802055:	74 07                	je     80205e <find_block+0x36>
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8b 00                	mov    (%eax),%eax
  80205c:	eb 05                	jmp    802063 <find_block+0x3b>
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
  802063:	8b 55 08             	mov    0x8(%ebp),%edx
  802066:	89 42 08             	mov    %eax,0x8(%edx)
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	8b 40 08             	mov    0x8(%eax),%eax
  80206f:	85 c0                	test   %eax,%eax
  802071:	75 c5                	jne    802038 <find_block+0x10>
  802073:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802077:	75 bf                	jne    802038 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802079:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802086:	a1 40 50 80 00       	mov    0x805040,%eax
  80208b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80208e:	a1 44 50 80 00       	mov    0x805044,%eax
  802093:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802099:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80209c:	74 24                	je     8020c2 <insert_sorted_allocList+0x42>
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	8b 50 08             	mov    0x8(%eax),%edx
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	8b 40 08             	mov    0x8(%eax),%eax
  8020aa:	39 c2                	cmp    %eax,%edx
  8020ac:	76 14                	jbe    8020c2 <insert_sorted_allocList+0x42>
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	8b 50 08             	mov    0x8(%eax),%edx
  8020b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b7:	8b 40 08             	mov    0x8(%eax),%eax
  8020ba:	39 c2                	cmp    %eax,%edx
  8020bc:	0f 82 60 01 00 00    	jb     802222 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c6:	75 65                	jne    80212d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020cc:	75 14                	jne    8020e2 <insert_sorted_allocList+0x62>
  8020ce:	83 ec 04             	sub    $0x4,%esp
  8020d1:	68 24 3f 80 00       	push   $0x803f24
  8020d6:	6a 6b                	push   $0x6b
  8020d8:	68 47 3f 80 00       	push   $0x803f47
  8020dd:	e8 9c e2 ff ff       	call   80037e <_panic>
  8020e2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	89 10                	mov    %edx,(%eax)
  8020ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	74 0d                	je     802103 <insert_sorted_allocList+0x83>
  8020f6:	a1 40 50 80 00       	mov    0x805040,%eax
  8020fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fe:	89 50 04             	mov    %edx,0x4(%eax)
  802101:	eb 08                	jmp    80210b <insert_sorted_allocList+0x8b>
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	a3 44 50 80 00       	mov    %eax,0x805044
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	a3 40 50 80 00       	mov    %eax,0x805040
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80211d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802122:	40                   	inc    %eax
  802123:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802128:	e9 dc 01 00 00       	jmp    802309 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	8b 50 08             	mov    0x8(%eax),%edx
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	8b 40 08             	mov    0x8(%eax),%eax
  802139:	39 c2                	cmp    %eax,%edx
  80213b:	77 6c                	ja     8021a9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80213d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802141:	74 06                	je     802149 <insert_sorted_allocList+0xc9>
  802143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802147:	75 14                	jne    80215d <insert_sorted_allocList+0xdd>
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	68 60 3f 80 00       	push   $0x803f60
  802151:	6a 6f                	push   $0x6f
  802153:	68 47 3f 80 00       	push   $0x803f47
  802158:	e8 21 e2 ff ff       	call   80037e <_panic>
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	8b 50 04             	mov    0x4(%eax),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	89 50 04             	mov    %edx,0x4(%eax)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80216f:	89 10                	mov    %edx,(%eax)
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	8b 40 04             	mov    0x4(%eax),%eax
  802177:	85 c0                	test   %eax,%eax
  802179:	74 0d                	je     802188 <insert_sorted_allocList+0x108>
  80217b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217e:	8b 40 04             	mov    0x4(%eax),%eax
  802181:	8b 55 08             	mov    0x8(%ebp),%edx
  802184:	89 10                	mov    %edx,(%eax)
  802186:	eb 08                	jmp    802190 <insert_sorted_allocList+0x110>
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	a3 40 50 80 00       	mov    %eax,0x805040
  802190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802193:	8b 55 08             	mov    0x8(%ebp),%edx
  802196:	89 50 04             	mov    %edx,0x4(%eax)
  802199:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80219e:	40                   	inc    %eax
  80219f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a4:	e9 60 01 00 00       	jmp    802309 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	8b 50 08             	mov    0x8(%eax),%edx
  8021af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b2:	8b 40 08             	mov    0x8(%eax),%eax
  8021b5:	39 c2                	cmp    %eax,%edx
  8021b7:	0f 82 4c 01 00 00    	jb     802309 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c1:	75 14                	jne    8021d7 <insert_sorted_allocList+0x157>
  8021c3:	83 ec 04             	sub    $0x4,%esp
  8021c6:	68 98 3f 80 00       	push   $0x803f98
  8021cb:	6a 73                	push   $0x73
  8021cd:	68 47 3f 80 00       	push   $0x803f47
  8021d2:	e8 a7 e1 ff ff       	call   80037e <_panic>
  8021d7:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	89 50 04             	mov    %edx,0x4(%eax)
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	8b 40 04             	mov    0x4(%eax),%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	74 0c                	je     8021f9 <insert_sorted_allocList+0x179>
  8021ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f5:	89 10                	mov    %edx,(%eax)
  8021f7:	eb 08                	jmp    802201 <insert_sorted_allocList+0x181>
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	a3 40 50 80 00       	mov    %eax,0x805040
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	a3 44 50 80 00       	mov    %eax,0x805044
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802212:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802217:	40                   	inc    %eax
  802218:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80221d:	e9 e7 00 00 00       	jmp    802309 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802228:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80222f:	a1 40 50 80 00       	mov    0x805040,%eax
  802234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802237:	e9 9d 00 00 00       	jmp    8022d9 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	8b 50 08             	mov    0x8(%eax),%edx
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 08             	mov    0x8(%eax),%eax
  802250:	39 c2                	cmp    %eax,%edx
  802252:	76 7d                	jbe    8022d1 <insert_sorted_allocList+0x251>
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 50 08             	mov    0x8(%eax),%edx
  80225a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80225d:	8b 40 08             	mov    0x8(%eax),%eax
  802260:	39 c2                	cmp    %eax,%edx
  802262:	73 6d                	jae    8022d1 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802268:	74 06                	je     802270 <insert_sorted_allocList+0x1f0>
  80226a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226e:	75 14                	jne    802284 <insert_sorted_allocList+0x204>
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 bc 3f 80 00       	push   $0x803fbc
  802278:	6a 7f                	push   $0x7f
  80227a:	68 47 3f 80 00       	push   $0x803f47
  80227f:	e8 fa e0 ff ff       	call   80037e <_panic>
  802284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802287:	8b 10                	mov    (%eax),%edx
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	89 10                	mov    %edx,(%eax)
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8b 00                	mov    (%eax),%eax
  802293:	85 c0                	test   %eax,%eax
  802295:	74 0b                	je     8022a2 <insert_sorted_allocList+0x222>
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	8b 55 08             	mov    0x8(%ebp),%edx
  80229f:	89 50 04             	mov    %edx,0x4(%eax)
  8022a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a8:	89 10                	mov    %edx,(%eax)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b0:	89 50 04             	mov    %edx,0x4(%eax)
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	75 08                	jne    8022c4 <insert_sorted_allocList+0x244>
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	a3 44 50 80 00       	mov    %eax,0x805044
  8022c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022c9:	40                   	inc    %eax
  8022ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022cf:	eb 39                	jmp    80230a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022d1:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dd:	74 07                	je     8022e6 <insert_sorted_allocList+0x266>
  8022df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	eb 05                	jmp    8022eb <insert_sorted_allocList+0x26b>
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022eb:	a3 48 50 80 00       	mov    %eax,0x805048
  8022f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	0f 85 3f ff ff ff    	jne    80223c <insert_sorted_allocList+0x1bc>
  8022fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802301:	0f 85 35 ff ff ff    	jne    80223c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802307:	eb 01                	jmp    80230a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802309:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80230a:	90                   	nop
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802313:	a1 38 51 80 00       	mov    0x805138,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	e9 85 01 00 00       	jmp    8024a5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 0c             	mov    0xc(%eax),%eax
  802326:	3b 45 08             	cmp    0x8(%ebp),%eax
  802329:	0f 82 6e 01 00 00    	jb     80249d <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 40 0c             	mov    0xc(%eax),%eax
  802335:	3b 45 08             	cmp    0x8(%ebp),%eax
  802338:	0f 85 8a 00 00 00    	jne    8023c8 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	75 17                	jne    80235b <alloc_block_FF+0x4e>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 f0 3f 80 00       	push   $0x803ff0
  80234c:	68 93 00 00 00       	push   $0x93
  802351:	68 47 3f 80 00       	push   $0x803f47
  802356:	e8 23 e0 ff ff       	call   80037e <_panic>
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 00                	mov    (%eax),%eax
  802360:	85 c0                	test   %eax,%eax
  802362:	74 10                	je     802374 <alloc_block_FF+0x67>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 00                	mov    (%eax),%eax
  802369:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236c:	8b 52 04             	mov    0x4(%edx),%edx
  80236f:	89 50 04             	mov    %edx,0x4(%eax)
  802372:	eb 0b                	jmp    80237f <alloc_block_FF+0x72>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 40 04             	mov    0x4(%eax),%eax
  80237a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 40 04             	mov    0x4(%eax),%eax
  802385:	85 c0                	test   %eax,%eax
  802387:	74 0f                	je     802398 <alloc_block_FF+0x8b>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 04             	mov    0x4(%eax),%eax
  80238f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802392:	8b 12                	mov    (%edx),%edx
  802394:	89 10                	mov    %edx,(%eax)
  802396:	eb 0a                	jmp    8023a2 <alloc_block_FF+0x95>
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 00                	mov    (%eax),%eax
  80239d:	a3 38 51 80 00       	mov    %eax,0x805138
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8023ba:	48                   	dec    %eax
  8023bb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	e9 10 01 00 00       	jmp    8024d8 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d1:	0f 86 c6 00 00 00    	jbe    80249d <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023d7:	a1 48 51 80 00       	mov    0x805148,%eax
  8023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 50 08             	mov    0x8(%eax),%edx
  8023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e8:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f1:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023f8:	75 17                	jne    802411 <alloc_block_FF+0x104>
  8023fa:	83 ec 04             	sub    $0x4,%esp
  8023fd:	68 f0 3f 80 00       	push   $0x803ff0
  802402:	68 9b 00 00 00       	push   $0x9b
  802407:	68 47 3f 80 00       	push   $0x803f47
  80240c:	e8 6d df ff ff       	call   80037e <_panic>
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	8b 00                	mov    (%eax),%eax
  802416:	85 c0                	test   %eax,%eax
  802418:	74 10                	je     80242a <alloc_block_FF+0x11d>
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802422:	8b 52 04             	mov    0x4(%edx),%edx
  802425:	89 50 04             	mov    %edx,0x4(%eax)
  802428:	eb 0b                	jmp    802435 <alloc_block_FF+0x128>
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	8b 40 04             	mov    0x4(%eax),%eax
  802430:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	8b 40 04             	mov    0x4(%eax),%eax
  80243b:	85 c0                	test   %eax,%eax
  80243d:	74 0f                	je     80244e <alloc_block_FF+0x141>
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802448:	8b 12                	mov    (%edx),%edx
  80244a:	89 10                	mov    %edx,(%eax)
  80244c:	eb 0a                	jmp    802458 <alloc_block_FF+0x14b>
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	a3 48 51 80 00       	mov    %eax,0x805148
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246b:	a1 54 51 80 00       	mov    0x805154,%eax
  802470:	48                   	dec    %eax
  802471:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 50 08             	mov    0x8(%eax),%edx
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	01 c2                	add    %eax,%edx
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 0c             	mov    0xc(%eax),%eax
  80248d:	2b 45 08             	sub    0x8(%ebp),%eax
  802490:	89 c2                	mov    %eax,%edx
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	eb 3b                	jmp    8024d8 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80249d:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	74 07                	je     8024b2 <alloc_block_FF+0x1a5>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	eb 05                	jmp    8024b7 <alloc_block_FF+0x1aa>
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b7:	a3 40 51 80 00       	mov    %eax,0x805140
  8024bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	0f 85 57 fe ff ff    	jne    802320 <alloc_block_FF+0x13>
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	0f 85 4d fe ff ff    	jne    802320 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024e0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024e7:	a1 38 51 80 00       	mov    0x805138,%eax
  8024ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ef:	e9 df 00 00 00       	jmp    8025d3 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fd:	0f 82 c8 00 00 00    	jb     8025cb <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 40 0c             	mov    0xc(%eax),%eax
  802509:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250c:	0f 85 8a 00 00 00    	jne    80259c <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802516:	75 17                	jne    80252f <alloc_block_BF+0x55>
  802518:	83 ec 04             	sub    $0x4,%esp
  80251b:	68 f0 3f 80 00       	push   $0x803ff0
  802520:	68 b7 00 00 00       	push   $0xb7
  802525:	68 47 3f 80 00       	push   $0x803f47
  80252a:	e8 4f de ff ff       	call   80037e <_panic>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 00                	mov    (%eax),%eax
  802534:	85 c0                	test   %eax,%eax
  802536:	74 10                	je     802548 <alloc_block_BF+0x6e>
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 00                	mov    (%eax),%eax
  80253d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802540:	8b 52 04             	mov    0x4(%edx),%edx
  802543:	89 50 04             	mov    %edx,0x4(%eax)
  802546:	eb 0b                	jmp    802553 <alloc_block_BF+0x79>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	74 0f                	je     80256c <alloc_block_BF+0x92>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	8b 12                	mov    (%edx),%edx
  802568:	89 10                	mov    %edx,(%eax)
  80256a:	eb 0a                	jmp    802576 <alloc_block_BF+0x9c>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	a3 38 51 80 00       	mov    %eax,0x805138
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802589:	a1 44 51 80 00       	mov    0x805144,%eax
  80258e:	48                   	dec    %eax
  80258f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	e9 4d 01 00 00       	jmp    8026e9 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a5:	76 24                	jbe    8025cb <alloc_block_BF+0xf1>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025b0:	73 19                	jae    8025cb <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025b2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 08             	mov    0x8(%eax),%eax
  8025c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d7:	74 07                	je     8025e0 <alloc_block_BF+0x106>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	eb 05                	jmp    8025e5 <alloc_block_BF+0x10b>
  8025e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e5:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	0f 85 fd fe ff ff    	jne    8024f4 <alloc_block_BF+0x1a>
  8025f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fb:	0f 85 f3 fe ff ff    	jne    8024f4 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802601:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802605:	0f 84 d9 00 00 00    	je     8026e4 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80260b:	a1 48 51 80 00       	mov    0x805148,%eax
  802610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802616:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802619:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80261c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261f:	8b 55 08             	mov    0x8(%ebp),%edx
  802622:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802625:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802629:	75 17                	jne    802642 <alloc_block_BF+0x168>
  80262b:	83 ec 04             	sub    $0x4,%esp
  80262e:	68 f0 3f 80 00       	push   $0x803ff0
  802633:	68 c7 00 00 00       	push   $0xc7
  802638:	68 47 3f 80 00       	push   $0x803f47
  80263d:	e8 3c dd ff ff       	call   80037e <_panic>
  802642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	74 10                	je     80265b <alloc_block_BF+0x181>
  80264b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802653:	8b 52 04             	mov    0x4(%edx),%edx
  802656:	89 50 04             	mov    %edx,0x4(%eax)
  802659:	eb 0b                	jmp    802666 <alloc_block_BF+0x18c>
  80265b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	74 0f                	je     80267f <alloc_block_BF+0x1a5>
  802670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802673:	8b 40 04             	mov    0x4(%eax),%eax
  802676:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802679:	8b 12                	mov    (%edx),%edx
  80267b:	89 10                	mov    %edx,(%eax)
  80267d:	eb 0a                	jmp    802689 <alloc_block_BF+0x1af>
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	8b 00                	mov    (%eax),%eax
  802684:	a3 48 51 80 00       	mov    %eax,0x805148
  802689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802695:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269c:	a1 54 51 80 00       	mov    0x805154,%eax
  8026a1:	48                   	dec    %eax
  8026a2:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026a7:	83 ec 08             	sub    $0x8,%esp
  8026aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8026ad:	68 38 51 80 00       	push   $0x805138
  8026b2:	e8 71 f9 ff ff       	call   802028 <find_block>
  8026b7:	83 c4 10             	add    $0x10,%esp
  8026ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c0:	8b 50 08             	mov    0x8(%eax),%edx
  8026c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c6:	01 c2                	add    %eax,%edx
  8026c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cb:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d4:	2b 45 08             	sub    0x8(%ebp),%eax
  8026d7:	89 c2                	mov    %eax,%edx
  8026d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dc:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e2:	eb 05                	jmp    8026e9 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e9:	c9                   	leave  
  8026ea:	c3                   	ret    

008026eb <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026eb:	55                   	push   %ebp
  8026ec:	89 e5                	mov    %esp,%ebp
  8026ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026f1:	a1 28 50 80 00       	mov    0x805028,%eax
  8026f6:	85 c0                	test   %eax,%eax
  8026f8:	0f 85 de 01 00 00    	jne    8028dc <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026fe:	a1 38 51 80 00       	mov    0x805138,%eax
  802703:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802706:	e9 9e 01 00 00       	jmp    8028a9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 0c             	mov    0xc(%eax),%eax
  802711:	3b 45 08             	cmp    0x8(%ebp),%eax
  802714:	0f 82 87 01 00 00    	jb     8028a1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 0c             	mov    0xc(%eax),%eax
  802720:	3b 45 08             	cmp    0x8(%ebp),%eax
  802723:	0f 85 95 00 00 00    	jne    8027be <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_NF+0x5b>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 f0 3f 80 00       	push   $0x803ff0
  802737:	68 e0 00 00 00       	push   $0xe0
  80273c:	68 47 3f 80 00       	push   $0x803f47
  802741:	e8 38 dc ff ff       	call   80037e <_panic>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <alloc_block_NF+0x74>
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 0b                	jmp    80276a <alloc_block_NF+0x7f>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 0f                	je     802783 <alloc_block_NF+0x98>
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277d:	8b 12                	mov    (%edx),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 0a                	jmp    80278d <alloc_block_NF+0xa2>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	a3 38 51 80 00       	mov    %eax,0x805138
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 08             	mov    0x8(%eax),%eax
  8027b1:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	e9 f8 04 00 00       	jmp    802cb6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c7:	0f 86 d4 00 00 00    	jbe    8028a1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 50 08             	mov    0x8(%eax),%edx
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e7:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ee:	75 17                	jne    802807 <alloc_block_NF+0x11c>
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 f0 3f 80 00       	push   $0x803ff0
  8027f8:	68 e9 00 00 00       	push   $0xe9
  8027fd:	68 47 3f 80 00       	push   $0x803f47
  802802:	e8 77 db ff ff       	call   80037e <_panic>
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 10                	je     802820 <alloc_block_NF+0x135>
  802810:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802818:	8b 52 04             	mov    0x4(%edx),%edx
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	eb 0b                	jmp    80282b <alloc_block_NF+0x140>
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80282b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 0f                	je     802844 <alloc_block_NF+0x159>
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283e:	8b 12                	mov    (%edx),%edx
  802840:	89 10                	mov    %edx,(%eax)
  802842:	eb 0a                	jmp    80284e <alloc_block_NF+0x163>
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	a3 48 51 80 00       	mov    %eax,0x805148
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 54 51 80 00       	mov    0x805154,%eax
  802866:	48                   	dec    %eax
  802867:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	8b 40 08             	mov    0x8(%eax),%eax
  802872:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 50 08             	mov    0x8(%eax),%edx
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	01 c2                	add    %eax,%edx
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 40 0c             	mov    0xc(%eax),%eax
  80288e:	2b 45 08             	sub    0x8(%ebp),%eax
  802891:	89 c2                	mov    %eax,%edx
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289c:	e9 15 04 00 00       	jmp    802cb6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	74 07                	je     8028b6 <alloc_block_NF+0x1cb>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	eb 05                	jmp    8028bb <alloc_block_NF+0x1d0>
  8028b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8028c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	0f 85 3e fe ff ff    	jne    80270b <alloc_block_NF+0x20>
  8028cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d1:	0f 85 34 fe ff ff    	jne    80270b <alloc_block_NF+0x20>
  8028d7:	e9 d5 03 00 00       	jmp    802cb1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028dc:	a1 38 51 80 00       	mov    0x805138,%eax
  8028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e4:	e9 b1 01 00 00       	jmp    802a9a <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 50 08             	mov    0x8(%eax),%edx
  8028ef:	a1 28 50 80 00       	mov    0x805028,%eax
  8028f4:	39 c2                	cmp    %eax,%edx
  8028f6:	0f 82 96 01 00 00    	jb     802a92 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802902:	3b 45 08             	cmp    0x8(%ebp),%eax
  802905:	0f 82 87 01 00 00    	jb     802a92 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 0c             	mov    0xc(%eax),%eax
  802911:	3b 45 08             	cmp    0x8(%ebp),%eax
  802914:	0f 85 95 00 00 00    	jne    8029af <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	75 17                	jne    802937 <alloc_block_NF+0x24c>
  802920:	83 ec 04             	sub    $0x4,%esp
  802923:	68 f0 3f 80 00       	push   $0x803ff0
  802928:	68 fc 00 00 00       	push   $0xfc
  80292d:	68 47 3f 80 00       	push   $0x803f47
  802932:	e8 47 da ff ff       	call   80037e <_panic>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	74 10                	je     802950 <alloc_block_NF+0x265>
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802948:	8b 52 04             	mov    0x4(%edx),%edx
  80294b:	89 50 04             	mov    %edx,0x4(%eax)
  80294e:	eb 0b                	jmp    80295b <alloc_block_NF+0x270>
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 04             	mov    0x4(%eax),%eax
  802961:	85 c0                	test   %eax,%eax
  802963:	74 0f                	je     802974 <alloc_block_NF+0x289>
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	8b 40 04             	mov    0x4(%eax),%eax
  80296b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296e:	8b 12                	mov    (%edx),%edx
  802970:	89 10                	mov    %edx,(%eax)
  802972:	eb 0a                	jmp    80297e <alloc_block_NF+0x293>
  802974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802977:	8b 00                	mov    (%eax),%eax
  802979:	a3 38 51 80 00       	mov    %eax,0x805138
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 44 51 80 00       	mov    0x805144,%eax
  802996:	48                   	dec    %eax
  802997:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 08             	mov    0x8(%eax),%eax
  8029a2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	e9 07 03 00 00       	jmp    802cb6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b8:	0f 86 d4 00 00 00    	jbe    802a92 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029be:	a1 48 51 80 00       	mov    0x805148,%eax
  8029c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 50 08             	mov    0x8(%eax),%edx
  8029cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029df:	75 17                	jne    8029f8 <alloc_block_NF+0x30d>
  8029e1:	83 ec 04             	sub    $0x4,%esp
  8029e4:	68 f0 3f 80 00       	push   $0x803ff0
  8029e9:	68 04 01 00 00       	push   $0x104
  8029ee:	68 47 3f 80 00       	push   $0x803f47
  8029f3:	e8 86 d9 ff ff       	call   80037e <_panic>
  8029f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 10                	je     802a11 <alloc_block_NF+0x326>
  802a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a09:	8b 52 04             	mov    0x4(%edx),%edx
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	eb 0b                	jmp    802a1c <alloc_block_NF+0x331>
  802a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1f:	8b 40 04             	mov    0x4(%eax),%eax
  802a22:	85 c0                	test   %eax,%eax
  802a24:	74 0f                	je     802a35 <alloc_block_NF+0x34a>
  802a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a2f:	8b 12                	mov    (%edx),%edx
  802a31:	89 10                	mov    %edx,(%eax)
  802a33:	eb 0a                	jmp    802a3f <alloc_block_NF+0x354>
  802a35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	a3 48 51 80 00       	mov    %eax,0x805148
  802a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a52:	a1 54 51 80 00       	mov    0x805154,%eax
  802a57:	48                   	dec    %eax
  802a58:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a60:	8b 40 08             	mov    0x8(%eax),%eax
  802a63:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 50 08             	mov    0x8(%eax),%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	01 c2                	add    %eax,%edx
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a82:	89 c2                	mov    %eax,%edx
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8d:	e9 24 02 00 00       	jmp    802cb6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a92:	a1 40 51 80 00       	mov    0x805140,%eax
  802a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	74 07                	je     802aa7 <alloc_block_NF+0x3bc>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	eb 05                	jmp    802aac <alloc_block_NF+0x3c1>
  802aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  802aac:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	0f 85 2b fe ff ff    	jne    8028e9 <alloc_block_NF+0x1fe>
  802abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac2:	0f 85 21 fe ff ff    	jne    8028e9 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac8:	a1 38 51 80 00       	mov    0x805138,%eax
  802acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad0:	e9 ae 01 00 00       	jmp    802c83 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 50 08             	mov    0x8(%eax),%edx
  802adb:	a1 28 50 80 00       	mov    0x805028,%eax
  802ae0:	39 c2                	cmp    %eax,%edx
  802ae2:	0f 83 93 01 00 00    	jae    802c7b <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 0c             	mov    0xc(%eax),%eax
  802aee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af1:	0f 82 84 01 00 00    	jb     802c7b <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 0c             	mov    0xc(%eax),%eax
  802afd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b00:	0f 85 95 00 00 00    	jne    802b9b <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0a:	75 17                	jne    802b23 <alloc_block_NF+0x438>
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 f0 3f 80 00       	push   $0x803ff0
  802b14:	68 14 01 00 00       	push   $0x114
  802b19:	68 47 3f 80 00       	push   $0x803f47
  802b1e:	e8 5b d8 ff ff       	call   80037e <_panic>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 10                	je     802b3c <alloc_block_NF+0x451>
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b34:	8b 52 04             	mov    0x4(%edx),%edx
  802b37:	89 50 04             	mov    %edx,0x4(%eax)
  802b3a:	eb 0b                	jmp    802b47 <alloc_block_NF+0x45c>
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 40 04             	mov    0x4(%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 0f                	je     802b60 <alloc_block_NF+0x475>
  802b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b54:	8b 40 04             	mov    0x4(%eax),%eax
  802b57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5a:	8b 12                	mov    (%edx),%edx
  802b5c:	89 10                	mov    %edx,(%eax)
  802b5e:	eb 0a                	jmp    802b6a <alloc_block_NF+0x47f>
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	a3 38 51 80 00       	mov    %eax,0x805138
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7d:	a1 44 51 80 00       	mov    0x805144,%eax
  802b82:	48                   	dec    %eax
  802b83:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 40 08             	mov    0x8(%eax),%eax
  802b8e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	e9 1b 01 00 00       	jmp    802cb6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba4:	0f 86 d1 00 00 00    	jbe    802c7b <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802baa:	a1 48 51 80 00       	mov    0x805148,%eax
  802baf:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 50 08             	mov    0x8(%eax),%edx
  802bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bcb:	75 17                	jne    802be4 <alloc_block_NF+0x4f9>
  802bcd:	83 ec 04             	sub    $0x4,%esp
  802bd0:	68 f0 3f 80 00       	push   $0x803ff0
  802bd5:	68 1c 01 00 00       	push   $0x11c
  802bda:	68 47 3f 80 00       	push   $0x803f47
  802bdf:	e8 9a d7 ff ff       	call   80037e <_panic>
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 10                	je     802bfd <alloc_block_NF+0x512>
  802bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf5:	8b 52 04             	mov    0x4(%edx),%edx
  802bf8:	89 50 04             	mov    %edx,0x4(%eax)
  802bfb:	eb 0b                	jmp    802c08 <alloc_block_NF+0x51d>
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0b:	8b 40 04             	mov    0x4(%eax),%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	74 0f                	je     802c21 <alloc_block_NF+0x536>
  802c12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c15:	8b 40 04             	mov    0x4(%eax),%eax
  802c18:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c1b:	8b 12                	mov    (%edx),%edx
  802c1d:	89 10                	mov    %edx,(%eax)
  802c1f:	eb 0a                	jmp    802c2b <alloc_block_NF+0x540>
  802c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	a3 48 51 80 00       	mov    %eax,0x805148
  802c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3e:	a1 54 51 80 00       	mov    0x805154,%eax
  802c43:	48                   	dec    %eax
  802c44:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4c:	8b 40 08             	mov    0x8(%eax),%eax
  802c4f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 50 08             	mov    0x8(%eax),%edx
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	01 c2                	add    %eax,%edx
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6b:	2b 45 08             	sub    0x8(%ebp),%eax
  802c6e:	89 c2                	mov    %eax,%edx
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c79:	eb 3b                	jmp    802cb6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c7b:	a1 40 51 80 00       	mov    0x805140,%eax
  802c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	74 07                	je     802c90 <alloc_block_NF+0x5a5>
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 00                	mov    (%eax),%eax
  802c8e:	eb 05                	jmp    802c95 <alloc_block_NF+0x5aa>
  802c90:	b8 00 00 00 00       	mov    $0x0,%eax
  802c95:	a3 40 51 80 00       	mov    %eax,0x805140
  802c9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	0f 85 2e fe ff ff    	jne    802ad5 <alloc_block_NF+0x3ea>
  802ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cab:	0f 85 24 fe ff ff    	jne    802ad5 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb6:	c9                   	leave  
  802cb7:	c3                   	ret    

00802cb8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cb8:	55                   	push   %ebp
  802cb9:	89 e5                	mov    %esp,%ebp
  802cbb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cbe:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cc6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ccb:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cce:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 14                	je     802ceb <insert_sorted_with_merge_freeList+0x33>
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	8b 50 08             	mov    0x8(%eax),%edx
  802cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce0:	8b 40 08             	mov    0x8(%eax),%eax
  802ce3:	39 c2                	cmp    %eax,%edx
  802ce5:	0f 87 9b 01 00 00    	ja     802e86 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 17                	jne    802d08 <insert_sorted_with_merge_freeList+0x50>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 24 3f 80 00       	push   $0x803f24
  802cf9:	68 38 01 00 00       	push   $0x138
  802cfe:	68 47 3f 80 00       	push   $0x803f47
  802d03:	e8 76 d6 ff ff       	call   80037e <_panic>
  802d08:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <insert_sorted_with_merge_freeList+0x71>
  802d1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d21:	8b 55 08             	mov    0x8(%ebp),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 08                	jmp    802d31 <insert_sorted_with_merge_freeList+0x79>
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 38 51 80 00       	mov    %eax,0x805138
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d43:	a1 44 51 80 00       	mov    0x805144,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d52:	0f 84 a8 06 00 00    	je     803400 <insert_sorted_with_merge_freeList+0x748>
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	8b 50 08             	mov    0x8(%eax),%edx
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 40 0c             	mov    0xc(%eax),%eax
  802d64:	01 c2                	add    %eax,%edx
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 40 08             	mov    0x8(%eax),%eax
  802d6c:	39 c2                	cmp    %eax,%edx
  802d6e:	0f 85 8c 06 00 00    	jne    803400 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 50 0c             	mov    0xc(%eax),%edx
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d80:	01 c2                	add    %eax,%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8c:	75 17                	jne    802da5 <insert_sorted_with_merge_freeList+0xed>
  802d8e:	83 ec 04             	sub    $0x4,%esp
  802d91:	68 f0 3f 80 00       	push   $0x803ff0
  802d96:	68 3c 01 00 00       	push   $0x13c
  802d9b:	68 47 3f 80 00       	push   $0x803f47
  802da0:	e8 d9 d5 ff ff       	call   80037e <_panic>
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 10                	je     802dbe <insert_sorted_with_merge_freeList+0x106>
  802dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db6:	8b 52 04             	mov    0x4(%edx),%edx
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	eb 0b                	jmp    802dc9 <insert_sorted_with_merge_freeList+0x111>
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 40 04             	mov    0x4(%eax),%eax
  802dc4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	74 0f                	je     802de2 <insert_sorted_with_merge_freeList+0x12a>
  802dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd6:	8b 40 04             	mov    0x4(%eax),%eax
  802dd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddc:	8b 12                	mov    (%edx),%edx
  802dde:	89 10                	mov    %edx,(%eax)
  802de0:	eb 0a                	jmp    802dec <insert_sorted_with_merge_freeList+0x134>
  802de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	a3 38 51 80 00       	mov    %eax,0x805138
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dff:	a1 44 51 80 00       	mov    0x805144,%eax
  802e04:	48                   	dec    %eax
  802e05:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e22:	75 17                	jne    802e3b <insert_sorted_with_merge_freeList+0x183>
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	68 24 3f 80 00       	push   $0x803f24
  802e2c:	68 3f 01 00 00       	push   $0x13f
  802e31:	68 47 3f 80 00       	push   $0x803f47
  802e36:	e8 43 d5 ff ff       	call   80037e <_panic>
  802e3b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	89 10                	mov    %edx,(%eax)
  802e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0d                	je     802e5c <insert_sorted_with_merge_freeList+0x1a4>
  802e4f:	a1 48 51 80 00       	mov    0x805148,%eax
  802e54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_with_merge_freeList+0x1ac>
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	a3 48 51 80 00       	mov    %eax,0x805148
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7b:	40                   	inc    %eax
  802e7c:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e81:	e9 7a 05 00 00       	jmp    803400 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	8b 50 08             	mov    0x8(%eax),%edx
  802e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8f:	8b 40 08             	mov    0x8(%eax),%eax
  802e92:	39 c2                	cmp    %eax,%edx
  802e94:	0f 82 14 01 00 00    	jb     802fae <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9d:	8b 50 08             	mov    0x8(%eax),%edx
  802ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea6:	01 c2                	add    %eax,%edx
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	8b 40 08             	mov    0x8(%eax),%eax
  802eae:	39 c2                	cmp    %eax,%edx
  802eb0:	0f 85 90 00 00 00    	jne    802f46 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec2:	01 c2                	add    %eax,%edx
  802ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec7:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee2:	75 17                	jne    802efb <insert_sorted_with_merge_freeList+0x243>
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	68 24 3f 80 00       	push   $0x803f24
  802eec:	68 49 01 00 00       	push   $0x149
  802ef1:	68 47 3f 80 00       	push   $0x803f47
  802ef6:	e8 83 d4 ff ff       	call   80037e <_panic>
  802efb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	89 10                	mov    %edx,(%eax)
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 0d                	je     802f1c <insert_sorted_with_merge_freeList+0x264>
  802f0f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f14:	8b 55 08             	mov    0x8(%ebp),%edx
  802f17:	89 50 04             	mov    %edx,0x4(%eax)
  802f1a:	eb 08                	jmp    802f24 <insert_sorted_with_merge_freeList+0x26c>
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	a3 48 51 80 00       	mov    %eax,0x805148
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f36:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3b:	40                   	inc    %eax
  802f3c:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f41:	e9 bb 04 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4a:	75 17                	jne    802f63 <insert_sorted_with_merge_freeList+0x2ab>
  802f4c:	83 ec 04             	sub    $0x4,%esp
  802f4f:	68 98 3f 80 00       	push   $0x803f98
  802f54:	68 4c 01 00 00       	push   $0x14c
  802f59:	68 47 3f 80 00       	push   $0x803f47
  802f5e:	e8 1b d4 ff ff       	call   80037e <_panic>
  802f63:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	89 50 04             	mov    %edx,0x4(%eax)
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0c                	je     802f85 <insert_sorted_with_merge_freeList+0x2cd>
  802f79:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f81:	89 10                	mov    %edx,(%eax)
  802f83:	eb 08                	jmp    802f8d <insert_sorted_with_merge_freeList+0x2d5>
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	a3 38 51 80 00       	mov    %eax,0x805138
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9e:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa3:	40                   	inc    %eax
  802fa4:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fa9:	e9 53 04 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fae:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fb6:	e9 15 04 00 00       	jmp    8033d0 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 40 08             	mov    0x8(%eax),%eax
  802fcf:	39 c2                	cmp    %eax,%edx
  802fd1:	0f 86 f1 03 00 00    	jbe    8033c8 <insert_sorted_with_merge_freeList+0x710>
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8b 50 08             	mov    0x8(%eax),%edx
  802fdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe0:	8b 40 08             	mov    0x8(%eax),%eax
  802fe3:	39 c2                	cmp    %eax,%edx
  802fe5:	0f 83 dd 03 00 00    	jae    8033c8 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 50 08             	mov    0x8(%eax),%edx
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff7:	01 c2                	add    %eax,%edx
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 40 08             	mov    0x8(%eax),%eax
  802fff:	39 c2                	cmp    %eax,%edx
  803001:	0f 85 b9 01 00 00    	jne    8031c0 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 50 08             	mov    0x8(%eax),%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 40 0c             	mov    0xc(%eax),%eax
  803013:	01 c2                	add    %eax,%edx
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	8b 40 08             	mov    0x8(%eax),%eax
  80301b:	39 c2                	cmp    %eax,%edx
  80301d:	0f 85 0d 01 00 00    	jne    803130 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 50 0c             	mov    0xc(%eax),%edx
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 40 0c             	mov    0xc(%eax),%eax
  80302f:	01 c2                	add    %eax,%edx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803037:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303b:	75 17                	jne    803054 <insert_sorted_with_merge_freeList+0x39c>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 f0 3f 80 00       	push   $0x803ff0
  803045:	68 5c 01 00 00       	push   $0x15c
  80304a:	68 47 3f 80 00       	push   $0x803f47
  80304f:	e8 2a d3 ff ff       	call   80037e <_panic>
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	8b 00                	mov    (%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 10                	je     80306d <insert_sorted_with_merge_freeList+0x3b5>
  80305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803065:	8b 52 04             	mov    0x4(%edx),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	eb 0b                	jmp    803078 <insert_sorted_with_merge_freeList+0x3c0>
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	8b 40 04             	mov    0x4(%eax),%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 0f                	je     803091 <insert_sorted_with_merge_freeList+0x3d9>
  803082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803085:	8b 40 04             	mov    0x4(%eax),%eax
  803088:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308b:	8b 12                	mov    (%edx),%edx
  80308d:	89 10                	mov    %edx,(%eax)
  80308f:	eb 0a                	jmp    80309b <insert_sorted_with_merge_freeList+0x3e3>
  803091:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803094:	8b 00                	mov    (%eax),%eax
  803096:	a3 38 51 80 00       	mov    %eax,0x805138
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ae:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b3:	48                   	dec    %eax
  8030b4:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x432>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 24 3f 80 00       	push   $0x803f24
  8030db:	68 5f 01 00 00       	push   $0x15f
  8030e0:	68 47 3f 80 00       	push   $0x803f47
  8030e5:	e8 94 d2 ff ff       	call   80037e <_panic>
  8030ea:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	89 10                	mov    %edx,(%eax)
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	85 c0                	test   %eax,%eax
  8030fc:	74 0d                	je     80310b <insert_sorted_with_merge_freeList+0x453>
  8030fe:	a1 48 51 80 00       	mov    0x805148,%eax
  803103:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803106:	89 50 04             	mov    %edx,0x4(%eax)
  803109:	eb 08                	jmp    803113 <insert_sorted_with_merge_freeList+0x45b>
  80310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803116:	a3 48 51 80 00       	mov    %eax,0x805148
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803125:	a1 54 51 80 00       	mov    0x805154,%eax
  80312a:	40                   	inc    %eax
  80312b:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 50 0c             	mov    0xc(%eax),%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 40 0c             	mov    0xc(%eax),%eax
  80313c:	01 c2                	add    %eax,%edx
  80313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803141:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803158:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315c:	75 17                	jne    803175 <insert_sorted_with_merge_freeList+0x4bd>
  80315e:	83 ec 04             	sub    $0x4,%esp
  803161:	68 24 3f 80 00       	push   $0x803f24
  803166:	68 64 01 00 00       	push   $0x164
  80316b:	68 47 3f 80 00       	push   $0x803f47
  803170:	e8 09 d2 ff ff       	call   80037e <_panic>
  803175:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	85 c0                	test   %eax,%eax
  803187:	74 0d                	je     803196 <insert_sorted_with_merge_freeList+0x4de>
  803189:	a1 48 51 80 00       	mov    0x805148,%eax
  80318e:	8b 55 08             	mov    0x8(%ebp),%edx
  803191:	89 50 04             	mov    %edx,0x4(%eax)
  803194:	eb 08                	jmp    80319e <insert_sorted_with_merge_freeList+0x4e6>
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b5:	40                   	inc    %eax
  8031b6:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031bb:	e9 41 02 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	8b 50 08             	mov    0x8(%eax),%edx
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cc:	01 c2                	add    %eax,%edx
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 40 08             	mov    0x8(%eax),%eax
  8031d4:	39 c2                	cmp    %eax,%edx
  8031d6:	0f 85 7c 01 00 00    	jne    803358 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e0:	74 06                	je     8031e8 <insert_sorted_with_merge_freeList+0x530>
  8031e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e6:	75 17                	jne    8031ff <insert_sorted_with_merge_freeList+0x547>
  8031e8:	83 ec 04             	sub    $0x4,%esp
  8031eb:	68 60 3f 80 00       	push   $0x803f60
  8031f0:	68 69 01 00 00       	push   $0x169
  8031f5:	68 47 3f 80 00       	push   $0x803f47
  8031fa:	e8 7f d1 ff ff       	call   80037e <_panic>
  8031ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803202:	8b 50 04             	mov    0x4(%eax),%edx
  803205:	8b 45 08             	mov    0x8(%ebp),%eax
  803208:	89 50 04             	mov    %edx,0x4(%eax)
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803211:	89 10                	mov    %edx,(%eax)
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	8b 40 04             	mov    0x4(%eax),%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	74 0d                	je     80322a <insert_sorted_with_merge_freeList+0x572>
  80321d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	8b 55 08             	mov    0x8(%ebp),%edx
  803226:	89 10                	mov    %edx,(%eax)
  803228:	eb 08                	jmp    803232 <insert_sorted_with_merge_freeList+0x57a>
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	a3 38 51 80 00       	mov    %eax,0x805138
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 55 08             	mov    0x8(%ebp),%edx
  803238:	89 50 04             	mov    %edx,0x4(%eax)
  80323b:	a1 44 51 80 00       	mov    0x805144,%eax
  803240:	40                   	inc    %eax
  803241:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	8b 50 0c             	mov    0xc(%eax),%edx
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 0c             	mov    0xc(%eax),%eax
  803252:	01 c2                	add    %eax,%edx
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80325a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80325e:	75 17                	jne    803277 <insert_sorted_with_merge_freeList+0x5bf>
  803260:	83 ec 04             	sub    $0x4,%esp
  803263:	68 f0 3f 80 00       	push   $0x803ff0
  803268:	68 6b 01 00 00       	push   $0x16b
  80326d:	68 47 3f 80 00       	push   $0x803f47
  803272:	e8 07 d1 ff ff       	call   80037e <_panic>
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 00                	mov    (%eax),%eax
  80327c:	85 c0                	test   %eax,%eax
  80327e:	74 10                	je     803290 <insert_sorted_with_merge_freeList+0x5d8>
  803280:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803283:	8b 00                	mov    (%eax),%eax
  803285:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803288:	8b 52 04             	mov    0x4(%edx),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 0b                	jmp    80329b <insert_sorted_with_merge_freeList+0x5e3>
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0f                	je     8032b4 <insert_sorted_with_merge_freeList+0x5fc>
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ae:	8b 12                	mov    (%edx),%edx
  8032b0:	89 10                	mov    %edx,(%eax)
  8032b2:	eb 0a                	jmp    8032be <insert_sorted_with_merge_freeList+0x606>
  8032b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	a3 38 51 80 00       	mov    %eax,0x805138
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d6:	48                   	dec    %eax
  8032d7:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f4:	75 17                	jne    80330d <insert_sorted_with_merge_freeList+0x655>
  8032f6:	83 ec 04             	sub    $0x4,%esp
  8032f9:	68 24 3f 80 00       	push   $0x803f24
  8032fe:	68 6e 01 00 00       	push   $0x16e
  803303:	68 47 3f 80 00       	push   $0x803f47
  803308:	e8 71 d0 ff ff       	call   80037e <_panic>
  80330d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803316:	89 10                	mov    %edx,(%eax)
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	8b 00                	mov    (%eax),%eax
  80331d:	85 c0                	test   %eax,%eax
  80331f:	74 0d                	je     80332e <insert_sorted_with_merge_freeList+0x676>
  803321:	a1 48 51 80 00       	mov    0x805148,%eax
  803326:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803329:	89 50 04             	mov    %edx,0x4(%eax)
  80332c:	eb 08                	jmp    803336 <insert_sorted_with_merge_freeList+0x67e>
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803336:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803339:	a3 48 51 80 00       	mov    %eax,0x805148
  80333e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803348:	a1 54 51 80 00       	mov    0x805154,%eax
  80334d:	40                   	inc    %eax
  80334e:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803353:	e9 a9 00 00 00       	jmp    803401 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335c:	74 06                	je     803364 <insert_sorted_with_merge_freeList+0x6ac>
  80335e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803362:	75 17                	jne    80337b <insert_sorted_with_merge_freeList+0x6c3>
  803364:	83 ec 04             	sub    $0x4,%esp
  803367:	68 bc 3f 80 00       	push   $0x803fbc
  80336c:	68 73 01 00 00       	push   $0x173
  803371:	68 47 3f 80 00       	push   $0x803f47
  803376:	e8 03 d0 ff ff       	call   80037e <_panic>
  80337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337e:	8b 10                	mov    (%eax),%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	89 10                	mov    %edx,(%eax)
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 0b                	je     803399 <insert_sorted_with_merge_freeList+0x6e1>
  80338e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803391:	8b 00                	mov    (%eax),%eax
  803393:	8b 55 08             	mov    0x8(%ebp),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	8b 55 08             	mov    0x8(%ebp),%edx
  80339f:	89 10                	mov    %edx,(%eax)
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	8b 00                	mov    (%eax),%eax
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	75 08                	jne    8033bb <insert_sorted_with_merge_freeList+0x703>
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c0:	40                   	inc    %eax
  8033c1:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033c6:	eb 39                	jmp    803401 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8033cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d4:	74 07                	je     8033dd <insert_sorted_with_merge_freeList+0x725>
  8033d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	eb 05                	jmp    8033e2 <insert_sorted_with_merge_freeList+0x72a>
  8033dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e2:	a3 40 51 80 00       	mov    %eax,0x805140
  8033e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ec:	85 c0                	test   %eax,%eax
  8033ee:	0f 85 c7 fb ff ff    	jne    802fbb <insert_sorted_with_merge_freeList+0x303>
  8033f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f8:	0f 85 bd fb ff ff    	jne    802fbb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033fe:	eb 01                	jmp    803401 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803400:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803401:	90                   	nop
  803402:	c9                   	leave  
  803403:	c3                   	ret    

00803404 <__udivdi3>:
  803404:	55                   	push   %ebp
  803405:	57                   	push   %edi
  803406:	56                   	push   %esi
  803407:	53                   	push   %ebx
  803408:	83 ec 1c             	sub    $0x1c,%esp
  80340b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80340f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803417:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80341b:	89 ca                	mov    %ecx,%edx
  80341d:	89 f8                	mov    %edi,%eax
  80341f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803423:	85 f6                	test   %esi,%esi
  803425:	75 2d                	jne    803454 <__udivdi3+0x50>
  803427:	39 cf                	cmp    %ecx,%edi
  803429:	77 65                	ja     803490 <__udivdi3+0x8c>
  80342b:	89 fd                	mov    %edi,%ebp
  80342d:	85 ff                	test   %edi,%edi
  80342f:	75 0b                	jne    80343c <__udivdi3+0x38>
  803431:	b8 01 00 00 00       	mov    $0x1,%eax
  803436:	31 d2                	xor    %edx,%edx
  803438:	f7 f7                	div    %edi
  80343a:	89 c5                	mov    %eax,%ebp
  80343c:	31 d2                	xor    %edx,%edx
  80343e:	89 c8                	mov    %ecx,%eax
  803440:	f7 f5                	div    %ebp
  803442:	89 c1                	mov    %eax,%ecx
  803444:	89 d8                	mov    %ebx,%eax
  803446:	f7 f5                	div    %ebp
  803448:	89 cf                	mov    %ecx,%edi
  80344a:	89 fa                	mov    %edi,%edx
  80344c:	83 c4 1c             	add    $0x1c,%esp
  80344f:	5b                   	pop    %ebx
  803450:	5e                   	pop    %esi
  803451:	5f                   	pop    %edi
  803452:	5d                   	pop    %ebp
  803453:	c3                   	ret    
  803454:	39 ce                	cmp    %ecx,%esi
  803456:	77 28                	ja     803480 <__udivdi3+0x7c>
  803458:	0f bd fe             	bsr    %esi,%edi
  80345b:	83 f7 1f             	xor    $0x1f,%edi
  80345e:	75 40                	jne    8034a0 <__udivdi3+0x9c>
  803460:	39 ce                	cmp    %ecx,%esi
  803462:	72 0a                	jb     80346e <__udivdi3+0x6a>
  803464:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803468:	0f 87 9e 00 00 00    	ja     80350c <__udivdi3+0x108>
  80346e:	b8 01 00 00 00       	mov    $0x1,%eax
  803473:	89 fa                	mov    %edi,%edx
  803475:	83 c4 1c             	add    $0x1c,%esp
  803478:	5b                   	pop    %ebx
  803479:	5e                   	pop    %esi
  80347a:	5f                   	pop    %edi
  80347b:	5d                   	pop    %ebp
  80347c:	c3                   	ret    
  80347d:	8d 76 00             	lea    0x0(%esi),%esi
  803480:	31 ff                	xor    %edi,%edi
  803482:	31 c0                	xor    %eax,%eax
  803484:	89 fa                	mov    %edi,%edx
  803486:	83 c4 1c             	add    $0x1c,%esp
  803489:	5b                   	pop    %ebx
  80348a:	5e                   	pop    %esi
  80348b:	5f                   	pop    %edi
  80348c:	5d                   	pop    %ebp
  80348d:	c3                   	ret    
  80348e:	66 90                	xchg   %ax,%ax
  803490:	89 d8                	mov    %ebx,%eax
  803492:	f7 f7                	div    %edi
  803494:	31 ff                	xor    %edi,%edi
  803496:	89 fa                	mov    %edi,%edx
  803498:	83 c4 1c             	add    $0x1c,%esp
  80349b:	5b                   	pop    %ebx
  80349c:	5e                   	pop    %esi
  80349d:	5f                   	pop    %edi
  80349e:	5d                   	pop    %ebp
  80349f:	c3                   	ret    
  8034a0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a5:	89 eb                	mov    %ebp,%ebx
  8034a7:	29 fb                	sub    %edi,%ebx
  8034a9:	89 f9                	mov    %edi,%ecx
  8034ab:	d3 e6                	shl    %cl,%esi
  8034ad:	89 c5                	mov    %eax,%ebp
  8034af:	88 d9                	mov    %bl,%cl
  8034b1:	d3 ed                	shr    %cl,%ebp
  8034b3:	89 e9                	mov    %ebp,%ecx
  8034b5:	09 f1                	or     %esi,%ecx
  8034b7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034bb:	89 f9                	mov    %edi,%ecx
  8034bd:	d3 e0                	shl    %cl,%eax
  8034bf:	89 c5                	mov    %eax,%ebp
  8034c1:	89 d6                	mov    %edx,%esi
  8034c3:	88 d9                	mov    %bl,%cl
  8034c5:	d3 ee                	shr    %cl,%esi
  8034c7:	89 f9                	mov    %edi,%ecx
  8034c9:	d3 e2                	shl    %cl,%edx
  8034cb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034cf:	88 d9                	mov    %bl,%cl
  8034d1:	d3 e8                	shr    %cl,%eax
  8034d3:	09 c2                	or     %eax,%edx
  8034d5:	89 d0                	mov    %edx,%eax
  8034d7:	89 f2                	mov    %esi,%edx
  8034d9:	f7 74 24 0c          	divl   0xc(%esp)
  8034dd:	89 d6                	mov    %edx,%esi
  8034df:	89 c3                	mov    %eax,%ebx
  8034e1:	f7 e5                	mul    %ebp
  8034e3:	39 d6                	cmp    %edx,%esi
  8034e5:	72 19                	jb     803500 <__udivdi3+0xfc>
  8034e7:	74 0b                	je     8034f4 <__udivdi3+0xf0>
  8034e9:	89 d8                	mov    %ebx,%eax
  8034eb:	31 ff                	xor    %edi,%edi
  8034ed:	e9 58 ff ff ff       	jmp    80344a <__udivdi3+0x46>
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034f8:	89 f9                	mov    %edi,%ecx
  8034fa:	d3 e2                	shl    %cl,%edx
  8034fc:	39 c2                	cmp    %eax,%edx
  8034fe:	73 e9                	jae    8034e9 <__udivdi3+0xe5>
  803500:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803503:	31 ff                	xor    %edi,%edi
  803505:	e9 40 ff ff ff       	jmp    80344a <__udivdi3+0x46>
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	31 c0                	xor    %eax,%eax
  80350e:	e9 37 ff ff ff       	jmp    80344a <__udivdi3+0x46>
  803513:	90                   	nop

00803514 <__umoddi3>:
  803514:	55                   	push   %ebp
  803515:	57                   	push   %edi
  803516:	56                   	push   %esi
  803517:	53                   	push   %ebx
  803518:	83 ec 1c             	sub    $0x1c,%esp
  80351b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80351f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803527:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80352b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80352f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803533:	89 f3                	mov    %esi,%ebx
  803535:	89 fa                	mov    %edi,%edx
  803537:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353b:	89 34 24             	mov    %esi,(%esp)
  80353e:	85 c0                	test   %eax,%eax
  803540:	75 1a                	jne    80355c <__umoddi3+0x48>
  803542:	39 f7                	cmp    %esi,%edi
  803544:	0f 86 a2 00 00 00    	jbe    8035ec <__umoddi3+0xd8>
  80354a:	89 c8                	mov    %ecx,%eax
  80354c:	89 f2                	mov    %esi,%edx
  80354e:	f7 f7                	div    %edi
  803550:	89 d0                	mov    %edx,%eax
  803552:	31 d2                	xor    %edx,%edx
  803554:	83 c4 1c             	add    $0x1c,%esp
  803557:	5b                   	pop    %ebx
  803558:	5e                   	pop    %esi
  803559:	5f                   	pop    %edi
  80355a:	5d                   	pop    %ebp
  80355b:	c3                   	ret    
  80355c:	39 f0                	cmp    %esi,%eax
  80355e:	0f 87 ac 00 00 00    	ja     803610 <__umoddi3+0xfc>
  803564:	0f bd e8             	bsr    %eax,%ebp
  803567:	83 f5 1f             	xor    $0x1f,%ebp
  80356a:	0f 84 ac 00 00 00    	je     80361c <__umoddi3+0x108>
  803570:	bf 20 00 00 00       	mov    $0x20,%edi
  803575:	29 ef                	sub    %ebp,%edi
  803577:	89 fe                	mov    %edi,%esi
  803579:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80357d:	89 e9                	mov    %ebp,%ecx
  80357f:	d3 e0                	shl    %cl,%eax
  803581:	89 d7                	mov    %edx,%edi
  803583:	89 f1                	mov    %esi,%ecx
  803585:	d3 ef                	shr    %cl,%edi
  803587:	09 c7                	or     %eax,%edi
  803589:	89 e9                	mov    %ebp,%ecx
  80358b:	d3 e2                	shl    %cl,%edx
  80358d:	89 14 24             	mov    %edx,(%esp)
  803590:	89 d8                	mov    %ebx,%eax
  803592:	d3 e0                	shl    %cl,%eax
  803594:	89 c2                	mov    %eax,%edx
  803596:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359a:	d3 e0                	shl    %cl,%eax
  80359c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a4:	89 f1                	mov    %esi,%ecx
  8035a6:	d3 e8                	shr    %cl,%eax
  8035a8:	09 d0                	or     %edx,%eax
  8035aa:	d3 eb                	shr    %cl,%ebx
  8035ac:	89 da                	mov    %ebx,%edx
  8035ae:	f7 f7                	div    %edi
  8035b0:	89 d3                	mov    %edx,%ebx
  8035b2:	f7 24 24             	mull   (%esp)
  8035b5:	89 c6                	mov    %eax,%esi
  8035b7:	89 d1                	mov    %edx,%ecx
  8035b9:	39 d3                	cmp    %edx,%ebx
  8035bb:	0f 82 87 00 00 00    	jb     803648 <__umoddi3+0x134>
  8035c1:	0f 84 91 00 00 00    	je     803658 <__umoddi3+0x144>
  8035c7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035cb:	29 f2                	sub    %esi,%edx
  8035cd:	19 cb                	sbb    %ecx,%ebx
  8035cf:	89 d8                	mov    %ebx,%eax
  8035d1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d5:	d3 e0                	shl    %cl,%eax
  8035d7:	89 e9                	mov    %ebp,%ecx
  8035d9:	d3 ea                	shr    %cl,%edx
  8035db:	09 d0                	or     %edx,%eax
  8035dd:	89 e9                	mov    %ebp,%ecx
  8035df:	d3 eb                	shr    %cl,%ebx
  8035e1:	89 da                	mov    %ebx,%edx
  8035e3:	83 c4 1c             	add    $0x1c,%esp
  8035e6:	5b                   	pop    %ebx
  8035e7:	5e                   	pop    %esi
  8035e8:	5f                   	pop    %edi
  8035e9:	5d                   	pop    %ebp
  8035ea:	c3                   	ret    
  8035eb:	90                   	nop
  8035ec:	89 fd                	mov    %edi,%ebp
  8035ee:	85 ff                	test   %edi,%edi
  8035f0:	75 0b                	jne    8035fd <__umoddi3+0xe9>
  8035f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f7:	31 d2                	xor    %edx,%edx
  8035f9:	f7 f7                	div    %edi
  8035fb:	89 c5                	mov    %eax,%ebp
  8035fd:	89 f0                	mov    %esi,%eax
  8035ff:	31 d2                	xor    %edx,%edx
  803601:	f7 f5                	div    %ebp
  803603:	89 c8                	mov    %ecx,%eax
  803605:	f7 f5                	div    %ebp
  803607:	89 d0                	mov    %edx,%eax
  803609:	e9 44 ff ff ff       	jmp    803552 <__umoddi3+0x3e>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	89 c8                	mov    %ecx,%eax
  803612:	89 f2                	mov    %esi,%edx
  803614:	83 c4 1c             	add    $0x1c,%esp
  803617:	5b                   	pop    %ebx
  803618:	5e                   	pop    %esi
  803619:	5f                   	pop    %edi
  80361a:	5d                   	pop    %ebp
  80361b:	c3                   	ret    
  80361c:	3b 04 24             	cmp    (%esp),%eax
  80361f:	72 06                	jb     803627 <__umoddi3+0x113>
  803621:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803625:	77 0f                	ja     803636 <__umoddi3+0x122>
  803627:	89 f2                	mov    %esi,%edx
  803629:	29 f9                	sub    %edi,%ecx
  80362b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80362f:	89 14 24             	mov    %edx,(%esp)
  803632:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803636:	8b 44 24 04          	mov    0x4(%esp),%eax
  80363a:	8b 14 24             	mov    (%esp),%edx
  80363d:	83 c4 1c             	add    $0x1c,%esp
  803640:	5b                   	pop    %ebx
  803641:	5e                   	pop    %esi
  803642:	5f                   	pop    %edi
  803643:	5d                   	pop    %ebp
  803644:	c3                   	ret    
  803645:	8d 76 00             	lea    0x0(%esi),%esi
  803648:	2b 04 24             	sub    (%esp),%eax
  80364b:	19 fa                	sbb    %edi,%edx
  80364d:	89 d1                	mov    %edx,%ecx
  80364f:	89 c6                	mov    %eax,%esi
  803651:	e9 71 ff ff ff       	jmp    8035c7 <__umoddi3+0xb3>
  803656:	66 90                	xchg   %ax,%ax
  803658:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80365c:	72 ea                	jb     803648 <__umoddi3+0x134>
  80365e:	89 d9                	mov    %ebx,%ecx
  803660:	e9 62 ff ff ff       	jmp    8035c7 <__umoddi3+0xb3>
