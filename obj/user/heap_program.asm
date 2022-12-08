
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
  800082:	e8 f3 17 00 00       	call   80187a <sys_pf_calculate_allocated_pages>
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
  800102:	e8 d3 16 00 00       	call   8017da <sys_calculate_free_frames>
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
  800152:	bb fc 36 80 00       	mov    $0x8036fc,%ebx
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
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8001d7:	68 00 36 80 00       	push   $0x803600
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 61 36 80 00       	push   $0x803661
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
  8001f8:	e8 dd 15 00 00       	call   8017da <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 cc 15 00 00       	call   8017da <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 78 36 80 00       	push   $0x803678
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 61 36 80 00       	push   $0x803661
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 bc 36 80 00       	push   $0x8036bc
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
  800248:	e8 6d 18 00 00       	call   801aba <sys_getenvindex>
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
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 0f 16 00 00       	call   8018c7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 30 37 80 00       	push   $0x803730
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 58 37 80 00       	push   $0x803758
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 80 37 80 00       	push   $0x803780
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 d8 37 80 00       	push   $0x8037d8
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 30 37 80 00       	push   $0x803730
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 8f 15 00 00       	call   8018e1 <sys_enable_interrupt>

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
  800365:	e8 1c 17 00 00       	call   801a86 <sys_destroy_env>
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
  800376:	e8 71 17 00 00       	call   801aec <sys_exit_env>
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
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 ec 37 80 00       	push   $0x8037ec
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 f1 37 80 00       	push   $0x8037f1
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
  8003dc:	68 0d 38 80 00       	push   $0x80380d
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
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 10 38 80 00       	push   $0x803810
  80040d:	6a 26                	push   $0x26
  80040f:	68 5c 38 80 00       	push   $0x80385c
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
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
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
  8004da:	68 68 38 80 00       	push   $0x803868
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 5c 38 80 00       	push   $0x80385c
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
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
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
  80054a:	68 bc 38 80 00       	push   $0x8038bc
  80054f:	6a 44                	push   $0x44
  800551:	68 5c 38 80 00       	push   $0x80385c
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
  800589:	a0 24 40 80 00       	mov    0x804024,%al
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
  8005a4:	e8 70 11 00 00       	call   801719 <sys_cputs>
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
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 f9 10 00 00       	call   801719 <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
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
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
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
  800665:	e8 5d 12 00 00       	call   8018c7 <sys_disable_interrupt>
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
  800685:	e8 57 12 00 00       	call   8018e1 <sys_enable_interrupt>
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
  8006cf:	e8 c8 2c 00 00       	call   80339c <__udivdi3>
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
  80071f:	e8 88 2d 00 00       	call   8034ac <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 34 3b 80 00       	add    $0x803b34,%eax
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
  80087a:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
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
  80095b:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 45 3b 80 00       	push   $0x803b45
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
  800980:	68 4e 3b 80 00       	push   $0x803b4e
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
  8009ad:	be 51 3b 80 00       	mov    $0x803b51,%esi
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
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 b0 3c 80 00       	push   $0x803cb0
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
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
  8013f3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013fa:	00 00 00 
  8013fd:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801404:	00 00 00 
  801407:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80140e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801411:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801418:	00 00 00 
  80141b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801422:	00 00 00 
  801425:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
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
  80144a:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80144f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801456:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801459:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801460:	a1 20 41 80 00       	mov    0x804120,%eax
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
  8014a3:	e8 b5 03 00 00       	call   80185d <sys_allocate_chunk>
  8014a8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ab:	a1 20 41 80 00       	mov    0x804120,%eax
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	50                   	push   %eax
  8014b4:	e8 2a 0a 00 00       	call   801ee3 <initialize_MemBlocksList>
  8014b9:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014bc:	a1 48 41 80 00       	mov    0x804148,%eax
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
  8014e1:	68 d5 3c 80 00       	push   $0x803cd5
  8014e6:	6a 33                	push   $0x33
  8014e8:	68 f3 3c 80 00       	push   $0x803cf3
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
  801511:	a3 4c 41 80 00       	mov    %eax,0x80414c
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
  801534:	a3 48 41 80 00       	mov    %eax,0x804148
  801539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80154c:	a1 54 41 80 00       	mov    0x804154,%eax
  801551:	48                   	dec    %eax
  801552:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801557:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80155b:	75 14                	jne    801571 <initialize_dyn_block_system+0x184>
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	68 00 3d 80 00       	push   $0x803d00
  801565:	6a 34                	push   $0x34
  801567:	68 f3 3c 80 00       	push   $0x803cf3
  80156c:	e8 0d ee ff ff       	call   80037e <_panic>
  801571:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157a:	89 10                	mov    %edx,(%eax)
  80157c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157f:	8b 00                	mov    (%eax),%eax
  801581:	85 c0                	test   %eax,%eax
  801583:	74 0d                	je     801592 <initialize_dyn_block_system+0x1a5>
  801585:	a1 38 41 80 00       	mov    0x804138,%eax
  80158a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80158d:	89 50 04             	mov    %edx,0x4(%eax)
  801590:	eb 08                	jmp    80159a <initialize_dyn_block_system+0x1ad>
  801592:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801595:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80159a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159d:	a3 38 41 80 00       	mov    %eax,0x804138
  8015a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ac:	a1 44 41 80 00       	mov    0x804144,%eax
  8015b1:	40                   	inc    %eax
  8015b2:	a3 44 41 80 00       	mov    %eax,0x804144
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
  8015d5:	68 24 3d 80 00       	push   $0x803d24
  8015da:	6a 46                	push   $0x46
  8015dc:	68 f3 3c 80 00       	push   $0x803cf3
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
  8015f1:	68 4c 3d 80 00       	push   $0x803d4c
  8015f6:	6a 61                	push   $0x61
  8015f8:	68 f3 3c 80 00       	push   $0x803cf3
  8015fd:	e8 7c ed ff ff       	call   80037e <_panic>

00801602 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 18             	sub    $0x18,%esp
  801608:	8b 45 10             	mov    0x10(%ebp),%eax
  80160b:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160e:	e8 a9 fd ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  801613:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801617:	75 07                	jne    801620 <smalloc+0x1e>
  801619:	b8 00 00 00 00       	mov    $0x0,%eax
  80161e:	eb 14                	jmp    801634 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801620:	83 ec 04             	sub    $0x4,%esp
  801623:	68 70 3d 80 00       	push   $0x803d70
  801628:	6a 76                	push   $0x76
  80162a:	68 f3 3c 80 00       	push   $0x803cf3
  80162f:	e8 4a ed ff ff       	call   80037e <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163c:	e8 7b fd ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	68 98 3d 80 00       	push   $0x803d98
  801649:	68 93 00 00 00       	push   $0x93
  80164e:	68 f3 3c 80 00       	push   $0x803cf3
  801653:	e8 26 ed ff ff       	call   80037e <_panic>

00801658 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165e:	e8 59 fd ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801663:	83 ec 04             	sub    $0x4,%esp
  801666:	68 bc 3d 80 00       	push   $0x803dbc
  80166b:	68 c5 00 00 00       	push   $0xc5
  801670:	68 f3 3c 80 00       	push   $0x803cf3
  801675:	e8 04 ed ff ff       	call   80037e <_panic>

0080167a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801680:	83 ec 04             	sub    $0x4,%esp
  801683:	68 e4 3d 80 00       	push   $0x803de4
  801688:	68 d9 00 00 00       	push   $0xd9
  80168d:	68 f3 3c 80 00       	push   $0x803cf3
  801692:	e8 e7 ec ff ff       	call   80037e <_panic>

00801697 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	68 08 3e 80 00       	push   $0x803e08
  8016a5:	68 e4 00 00 00       	push   $0xe4
  8016aa:	68 f3 3c 80 00       	push   $0x803cf3
  8016af:	e8 ca ec ff ff       	call   80037e <_panic>

008016b4 <shrink>:

}
void shrink(uint32 newSize)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	68 08 3e 80 00       	push   $0x803e08
  8016c2:	68 e9 00 00 00       	push   $0xe9
  8016c7:	68 f3 3c 80 00       	push   $0x803cf3
  8016cc:	e8 ad ec ff ff       	call   80037e <_panic>

008016d1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	68 08 3e 80 00       	push   $0x803e08
  8016df:	68 ee 00 00 00       	push   $0xee
  8016e4:	68 f3 3c 80 00       	push   $0x803cf3
  8016e9:	e8 90 ec ff ff       	call   80037e <_panic>

008016ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	57                   	push   %edi
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801700:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801703:	8b 7d 18             	mov    0x18(%ebp),%edi
  801706:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801709:	cd 30                	int    $0x30
  80170b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5f                   	pop    %edi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 04             	sub    $0x4,%esp
  80171f:	8b 45 10             	mov    0x10(%ebp),%eax
  801722:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801725:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	52                   	push   %edx
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	50                   	push   %eax
  801735:	6a 00                	push   $0x0
  801737:	e8 b2 ff ff ff       	call   8016ee <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
}
  80173f:	90                   	nop
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <sys_cgetc>:

int
sys_cgetc(void)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 01                	push   $0x1
  801751:	e8 98 ff ff ff       	call   8016ee <syscall>
  801756:	83 c4 18             	add    $0x18,%esp
}
  801759:	c9                   	leave  
  80175a:	c3                   	ret    

0080175b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80175e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	52                   	push   %edx
  80176b:	50                   	push   %eax
  80176c:	6a 05                	push   $0x5
  80176e:	e8 7b ff ff ff       	call   8016ee <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	56                   	push   %esi
  80177c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80177d:	8b 75 18             	mov    0x18(%ebp),%esi
  801780:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801783:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801786:	8b 55 0c             	mov    0xc(%ebp),%edx
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	51                   	push   %ecx
  80178f:	52                   	push   %edx
  801790:	50                   	push   %eax
  801791:	6a 06                	push   $0x6
  801793:	e8 56 ff ff ff       	call   8016ee <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80179e:	5b                   	pop    %ebx
  80179f:	5e                   	pop    %esi
  8017a0:	5d                   	pop    %ebp
  8017a1:	c3                   	ret    

008017a2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	52                   	push   %edx
  8017b2:	50                   	push   %eax
  8017b3:	6a 07                	push   $0x7
  8017b5:	e8 34 ff ff ff       	call   8016ee <syscall>
  8017ba:	83 c4 18             	add    $0x18,%esp
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	ff 75 0c             	pushl  0xc(%ebp)
  8017cb:	ff 75 08             	pushl  0x8(%ebp)
  8017ce:	6a 08                	push   $0x8
  8017d0:	e8 19 ff ff ff       	call   8016ee <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 09                	push   $0x9
  8017e9:	e8 00 ff ff ff       	call   8016ee <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 0a                	push   $0xa
  801802:	e8 e7 fe ff ff       	call   8016ee <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 0b                	push   $0xb
  80181b:	e8 ce fe ff ff       	call   8016ee <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	ff 75 08             	pushl  0x8(%ebp)
  801834:	6a 0f                	push   $0xf
  801836:	e8 b3 fe ff ff       	call   8016ee <syscall>
  80183b:	83 c4 18             	add    $0x18,%esp
	return;
  80183e:	90                   	nop
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	6a 10                	push   $0x10
  801852:	e8 97 fe ff ff       	call   8016ee <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
	return ;
  80185a:	90                   	nop
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	ff 75 10             	pushl  0x10(%ebp)
  801867:	ff 75 0c             	pushl  0xc(%ebp)
  80186a:	ff 75 08             	pushl  0x8(%ebp)
  80186d:	6a 11                	push   $0x11
  80186f:	e8 7a fe ff ff       	call   8016ee <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
	return ;
  801877:	90                   	nop
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 0c                	push   $0xc
  801889:	e8 60 fe ff ff       	call   8016ee <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 08             	pushl  0x8(%ebp)
  8018a1:	6a 0d                	push   $0xd
  8018a3:	e8 46 fe ff ff       	call   8016ee <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 0e                	push   $0xe
  8018bc:	e8 2d fe ff ff       	call   8016ee <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	90                   	nop
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 13                	push   $0x13
  8018d6:	e8 13 fe ff ff       	call   8016ee <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	90                   	nop
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 14                	push   $0x14
  8018f0:	e8 f9 fd ff ff       	call   8016ee <syscall>
  8018f5:	83 c4 18             	add    $0x18,%esp
}
  8018f8:	90                   	nop
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sys_cputc>:


void
sys_cputc(const char c)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801907:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	50                   	push   %eax
  801914:	6a 15                	push   $0x15
  801916:	e8 d3 fd ff ff       	call   8016ee <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
}
  80191e:	90                   	nop
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 16                	push   $0x16
  801930:	e8 b9 fd ff ff       	call   8016ee <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	90                   	nop
  801939:	c9                   	leave  
  80193a:	c3                   	ret    

0080193b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	50                   	push   %eax
  80194b:	6a 17                	push   $0x17
  80194d:	e8 9c fd ff ff       	call   8016ee <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	6a 1a                	push   $0x1a
  80196a:	e8 7f fd ff ff       	call   8016ee <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	52                   	push   %edx
  801984:	50                   	push   %eax
  801985:	6a 18                	push   $0x18
  801987:	e8 62 fd ff ff       	call   8016ee <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	90                   	nop
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	52                   	push   %edx
  8019a2:	50                   	push   %eax
  8019a3:	6a 19                	push   $0x19
  8019a5:	e8 44 fd ff ff       	call   8016ee <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019bc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019bf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	6a 00                	push   $0x0
  8019c8:	51                   	push   %ecx
  8019c9:	52                   	push   %edx
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	50                   	push   %eax
  8019ce:	6a 1b                	push   $0x1b
  8019d0:	e8 19 fd ff ff       	call   8016ee <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	52                   	push   %edx
  8019ea:	50                   	push   %eax
  8019eb:	6a 1c                	push   $0x1c
  8019ed:	e8 fc fc ff ff       	call   8016ee <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	51                   	push   %ecx
  801a08:	52                   	push   %edx
  801a09:	50                   	push   %eax
  801a0a:	6a 1d                	push   $0x1d
  801a0c:	e8 dd fc ff ff       	call   8016ee <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	6a 1e                	push   $0x1e
  801a29:	e8 c0 fc ff ff       	call   8016ee <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 1f                	push   $0x1f
  801a42:	e8 a7 fc ff ff       	call   8016ee <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	ff 75 14             	pushl  0x14(%ebp)
  801a57:	ff 75 10             	pushl  0x10(%ebp)
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	6a 20                	push   $0x20
  801a60:	e8 89 fc ff ff       	call   8016ee <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	50                   	push   %eax
  801a79:	6a 21                	push   $0x21
  801a7b:	e8 6e fc ff ff       	call   8016ee <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	50                   	push   %eax
  801a95:	6a 22                	push   $0x22
  801a97:	e8 52 fc ff ff       	call   8016ee <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 02                	push   $0x2
  801ab0:	e8 39 fc ff ff       	call   8016ee <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 03                	push   $0x3
  801ac9:	e8 20 fc ff ff       	call   8016ee <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 04                	push   $0x4
  801ae2:	e8 07 fc ff ff       	call   8016ee <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_exit_env>:


void sys_exit_env(void)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 23                	push   $0x23
  801afb:	e8 ee fb ff ff       	call   8016ee <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	90                   	nop
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b0f:	8d 50 04             	lea    0x4(%eax),%edx
  801b12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	52                   	push   %edx
  801b1c:	50                   	push   %eax
  801b1d:	6a 24                	push   $0x24
  801b1f:	e8 ca fb ff ff       	call   8016ee <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
	return result;
  801b27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b30:	89 01                	mov    %eax,(%ecx)
  801b32:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	c9                   	leave  
  801b39:	c2 04 00             	ret    $0x4

00801b3c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 10             	pushl  0x10(%ebp)
  801b46:	ff 75 0c             	pushl  0xc(%ebp)
  801b49:	ff 75 08             	pushl  0x8(%ebp)
  801b4c:	6a 12                	push   $0x12
  801b4e:	e8 9b fb ff ff       	call   8016ee <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return ;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 25                	push   $0x25
  801b68:	e8 81 fb ff ff       	call   8016ee <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b7e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	50                   	push   %eax
  801b8b:	6a 26                	push   $0x26
  801b8d:	e8 5c fb ff ff       	call   8016ee <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
	return ;
  801b95:	90                   	nop
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <rsttst>:
void rsttst()
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 28                	push   $0x28
  801ba7:	e8 42 fb ff ff       	call   8016ee <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
	return ;
  801baf:	90                   	nop
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bbe:	8b 55 18             	mov    0x18(%ebp),%edx
  801bc1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bc5:	52                   	push   %edx
  801bc6:	50                   	push   %eax
  801bc7:	ff 75 10             	pushl  0x10(%ebp)
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	ff 75 08             	pushl  0x8(%ebp)
  801bd0:	6a 27                	push   $0x27
  801bd2:	e8 17 fb ff ff       	call   8016ee <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <chktst>:
void chktst(uint32 n)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 29                	push   $0x29
  801bed:	e8 fc fa ff ff       	call   8016ee <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <inctst>:

void inctst()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 2a                	push   $0x2a
  801c07:	e8 e2 fa ff ff       	call   8016ee <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0f:	90                   	nop
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <gettst>:
uint32 gettst()
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 2b                	push   $0x2b
  801c21:	e8 c8 fa ff ff       	call   8016ee <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 2c                	push   $0x2c
  801c3d:	e8 ac fa ff ff       	call   8016ee <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
  801c45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c48:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c4c:	75 07                	jne    801c55 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c53:	eb 05                	jmp    801c5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 2c                	push   $0x2c
  801c6e:	e8 7b fa ff ff       	call   8016ee <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
  801c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c79:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c7d:	75 07                	jne    801c86 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c84:	eb 05                	jmp    801c8b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 2c                	push   $0x2c
  801c9f:	e8 4a fa ff ff       	call   8016ee <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
  801ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801caa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cae:	75 07                	jne    801cb7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cb5:	eb 05                	jmp    801cbc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 2c                	push   $0x2c
  801cd0:	e8 19 fa ff ff       	call   8016ee <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
  801cd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cdb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cdf:	75 07                	jne    801ce8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ce1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce6:	eb 05                	jmp    801ced <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	ff 75 08             	pushl  0x8(%ebp)
  801cfd:	6a 2d                	push   $0x2d
  801cff:	e8 ea f9 ff ff       	call   8016ee <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	6a 00                	push   $0x0
  801d1c:	53                   	push   %ebx
  801d1d:	51                   	push   %ecx
  801d1e:	52                   	push   %edx
  801d1f:	50                   	push   %eax
  801d20:	6a 2e                	push   $0x2e
  801d22:	e8 c7 f9 ff ff       	call   8016ee <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	6a 2f                	push   $0x2f
  801d42:	e8 a7 f9 ff ff       	call   8016ee <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d52:	83 ec 0c             	sub    $0xc,%esp
  801d55:	68 18 3e 80 00       	push   $0x803e18
  801d5a:	e8 d3 e8 ff ff       	call   800632 <cprintf>
  801d5f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	68 44 3e 80 00       	push   $0x803e44
  801d71:	e8 bc e8 ff ff       	call   800632 <cprintf>
  801d76:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d79:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d7d:	a1 38 41 80 00       	mov    0x804138,%eax
  801d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d85:	eb 56                	jmp    801ddd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d8b:	74 1c                	je     801da9 <print_mem_block_lists+0x5d>
  801d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d90:	8b 50 08             	mov    0x8(%eax),%edx
  801d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d96:	8b 48 08             	mov    0x8(%eax),%ecx
  801d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9f:	01 c8                	add    %ecx,%eax
  801da1:	39 c2                	cmp    %eax,%edx
  801da3:	73 04                	jae    801da9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801da5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	8b 50 08             	mov    0x8(%eax),%edx
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 40 0c             	mov    0xc(%eax),%eax
  801db5:	01 c2                	add    %eax,%edx
  801db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dba:	8b 40 08             	mov    0x8(%eax),%eax
  801dbd:	83 ec 04             	sub    $0x4,%esp
  801dc0:	52                   	push   %edx
  801dc1:	50                   	push   %eax
  801dc2:	68 59 3e 80 00       	push   $0x803e59
  801dc7:	e8 66 e8 ff ff       	call   800632 <cprintf>
  801dcc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dd5:	a1 40 41 80 00       	mov    0x804140,%eax
  801dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de1:	74 07                	je     801dea <print_mem_block_lists+0x9e>
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	8b 00                	mov    (%eax),%eax
  801de8:	eb 05                	jmp    801def <print_mem_block_lists+0xa3>
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	a3 40 41 80 00       	mov    %eax,0x804140
  801df4:	a1 40 41 80 00       	mov    0x804140,%eax
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	75 8a                	jne    801d87 <print_mem_block_lists+0x3b>
  801dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e01:	75 84                	jne    801d87 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e03:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e07:	75 10                	jne    801e19 <print_mem_block_lists+0xcd>
  801e09:	83 ec 0c             	sub    $0xc,%esp
  801e0c:	68 68 3e 80 00       	push   $0x803e68
  801e11:	e8 1c e8 ff ff       	call   800632 <cprintf>
  801e16:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e20:	83 ec 0c             	sub    $0xc,%esp
  801e23:	68 8c 3e 80 00       	push   $0x803e8c
  801e28:	e8 05 e8 ff ff       	call   800632 <cprintf>
  801e2d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e30:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e34:	a1 40 40 80 00       	mov    0x804040,%eax
  801e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3c:	eb 56                	jmp    801e94 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e42:	74 1c                	je     801e60 <print_mem_block_lists+0x114>
  801e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e47:	8b 50 08             	mov    0x8(%eax),%edx
  801e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	8b 40 0c             	mov    0xc(%eax),%eax
  801e56:	01 c8                	add    %ecx,%eax
  801e58:	39 c2                	cmp    %eax,%edx
  801e5a:	73 04                	jae    801e60 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e5c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	8b 50 08             	mov    0x8(%eax),%edx
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6c:	01 c2                	add    %eax,%edx
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	8b 40 08             	mov    0x8(%eax),%eax
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	52                   	push   %edx
  801e78:	50                   	push   %eax
  801e79:	68 59 3e 80 00       	push   $0x803e59
  801e7e:	e8 af e7 ff ff       	call   800632 <cprintf>
  801e83:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e8c:	a1 48 40 80 00       	mov    0x804048,%eax
  801e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e98:	74 07                	je     801ea1 <print_mem_block_lists+0x155>
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	8b 00                	mov    (%eax),%eax
  801e9f:	eb 05                	jmp    801ea6 <print_mem_block_lists+0x15a>
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea6:	a3 48 40 80 00       	mov    %eax,0x804048
  801eab:	a1 48 40 80 00       	mov    0x804048,%eax
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	75 8a                	jne    801e3e <print_mem_block_lists+0xf2>
  801eb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb8:	75 84                	jne    801e3e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801eba:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ebe:	75 10                	jne    801ed0 <print_mem_block_lists+0x184>
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	68 a4 3e 80 00       	push   $0x803ea4
  801ec8:	e8 65 e7 ff ff       	call   800632 <cprintf>
  801ecd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	68 18 3e 80 00       	push   $0x803e18
  801ed8:	e8 55 e7 ff ff       	call   800632 <cprintf>
  801edd:	83 c4 10             	add    $0x10,%esp

}
  801ee0:	90                   	nop
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ee9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ef0:	00 00 00 
  801ef3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801efa:	00 00 00 
  801efd:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f04:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f07:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f0e:	e9 9e 00 00 00       	jmp    801fb1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f13:	a1 50 40 80 00       	mov    0x804050,%eax
  801f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1b:	c1 e2 04             	shl    $0x4,%edx
  801f1e:	01 d0                	add    %edx,%eax
  801f20:	85 c0                	test   %eax,%eax
  801f22:	75 14                	jne    801f38 <initialize_MemBlocksList+0x55>
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	68 cc 3e 80 00       	push   $0x803ecc
  801f2c:	6a 46                	push   $0x46
  801f2e:	68 ef 3e 80 00       	push   $0x803eef
  801f33:	e8 46 e4 ff ff       	call   80037e <_panic>
  801f38:	a1 50 40 80 00       	mov    0x804050,%eax
  801f3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f40:	c1 e2 04             	shl    $0x4,%edx
  801f43:	01 d0                	add    %edx,%eax
  801f45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f4b:	89 10                	mov    %edx,(%eax)
  801f4d:	8b 00                	mov    (%eax),%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 18                	je     801f6b <initialize_MemBlocksList+0x88>
  801f53:	a1 48 41 80 00       	mov    0x804148,%eax
  801f58:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f5e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f61:	c1 e1 04             	shl    $0x4,%ecx
  801f64:	01 ca                	add    %ecx,%edx
  801f66:	89 50 04             	mov    %edx,0x4(%eax)
  801f69:	eb 12                	jmp    801f7d <initialize_MemBlocksList+0x9a>
  801f6b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f73:	c1 e2 04             	shl    $0x4,%edx
  801f76:	01 d0                	add    %edx,%eax
  801f78:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f7d:	a1 50 40 80 00       	mov    0x804050,%eax
  801f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f85:	c1 e2 04             	shl    $0x4,%edx
  801f88:	01 d0                	add    %edx,%eax
  801f8a:	a3 48 41 80 00       	mov    %eax,0x804148
  801f8f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	c1 e2 04             	shl    $0x4,%edx
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa3:	a1 54 41 80 00       	mov    0x804154,%eax
  801fa8:	40                   	inc    %eax
  801fa9:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fae:	ff 45 f4             	incl   -0xc(%ebp)
  801fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fb7:	0f 82 56 ff ff ff    	jb     801f13 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fbd:	90                   	nop
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8b 00                	mov    (%eax),%eax
  801fcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fce:	eb 19                	jmp    801fe9 <find_block+0x29>
	{
		if(va==point->sva)
  801fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fd3:	8b 40 08             	mov    0x8(%eax),%eax
  801fd6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fd9:	75 05                	jne    801fe0 <find_block+0x20>
		   return point;
  801fdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fde:	eb 36                	jmp    802016 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fe9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fed:	74 07                	je     801ff6 <find_block+0x36>
  801fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	eb 05                	jmp    801ffb <find_block+0x3b>
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ffe:	89 42 08             	mov    %eax,0x8(%edx)
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	8b 40 08             	mov    0x8(%eax),%eax
  802007:	85 c0                	test   %eax,%eax
  802009:	75 c5                	jne    801fd0 <find_block+0x10>
  80200b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80200f:	75 bf                	jne    801fd0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802011:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80201e:	a1 40 40 80 00       	mov    0x804040,%eax
  802023:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802026:	a1 44 40 80 00       	mov    0x804044,%eax
  80202b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802034:	74 24                	je     80205a <insert_sorted_allocList+0x42>
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	8b 50 08             	mov    0x8(%eax),%edx
  80203c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203f:	8b 40 08             	mov    0x8(%eax),%eax
  802042:	39 c2                	cmp    %eax,%edx
  802044:	76 14                	jbe    80205a <insert_sorted_allocList+0x42>
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 50 08             	mov    0x8(%eax),%edx
  80204c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80204f:	8b 40 08             	mov    0x8(%eax),%eax
  802052:	39 c2                	cmp    %eax,%edx
  802054:	0f 82 60 01 00 00    	jb     8021ba <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80205a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80205e:	75 65                	jne    8020c5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802060:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802064:	75 14                	jne    80207a <insert_sorted_allocList+0x62>
  802066:	83 ec 04             	sub    $0x4,%esp
  802069:	68 cc 3e 80 00       	push   $0x803ecc
  80206e:	6a 6b                	push   $0x6b
  802070:	68 ef 3e 80 00       	push   $0x803eef
  802075:	e8 04 e3 ff ff       	call   80037e <_panic>
  80207a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	89 10                	mov    %edx,(%eax)
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	8b 00                	mov    (%eax),%eax
  80208a:	85 c0                	test   %eax,%eax
  80208c:	74 0d                	je     80209b <insert_sorted_allocList+0x83>
  80208e:	a1 40 40 80 00       	mov    0x804040,%eax
  802093:	8b 55 08             	mov    0x8(%ebp),%edx
  802096:	89 50 04             	mov    %edx,0x4(%eax)
  802099:	eb 08                	jmp    8020a3 <insert_sorted_allocList+0x8b>
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	a3 44 40 80 00       	mov    %eax,0x804044
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020ba:	40                   	inc    %eax
  8020bb:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020c0:	e9 dc 01 00 00       	jmp    8022a1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	8b 50 08             	mov    0x8(%eax),%edx
  8020cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ce:	8b 40 08             	mov    0x8(%eax),%eax
  8020d1:	39 c2                	cmp    %eax,%edx
  8020d3:	77 6c                	ja     802141 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d9:	74 06                	je     8020e1 <insert_sorted_allocList+0xc9>
  8020db:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020df:	75 14                	jne    8020f5 <insert_sorted_allocList+0xdd>
  8020e1:	83 ec 04             	sub    $0x4,%esp
  8020e4:	68 08 3f 80 00       	push   $0x803f08
  8020e9:	6a 6f                	push   $0x6f
  8020eb:	68 ef 3e 80 00       	push   $0x803eef
  8020f0:	e8 89 e2 ff ff       	call   80037e <_panic>
  8020f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f8:	8b 50 04             	mov    0x4(%eax),%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	89 50 04             	mov    %edx,0x4(%eax)
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802107:	89 10                	mov    %edx,(%eax)
  802109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210c:	8b 40 04             	mov    0x4(%eax),%eax
  80210f:	85 c0                	test   %eax,%eax
  802111:	74 0d                	je     802120 <insert_sorted_allocList+0x108>
  802113:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802116:	8b 40 04             	mov    0x4(%eax),%eax
  802119:	8b 55 08             	mov    0x8(%ebp),%edx
  80211c:	89 10                	mov    %edx,(%eax)
  80211e:	eb 08                	jmp    802128 <insert_sorted_allocList+0x110>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	a3 40 40 80 00       	mov    %eax,0x804040
  802128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212b:	8b 55 08             	mov    0x8(%ebp),%edx
  80212e:	89 50 04             	mov    %edx,0x4(%eax)
  802131:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802136:	40                   	inc    %eax
  802137:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80213c:	e9 60 01 00 00       	jmp    8022a1 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 50 08             	mov    0x8(%eax),%edx
  802147:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214a:	8b 40 08             	mov    0x8(%eax),%eax
  80214d:	39 c2                	cmp    %eax,%edx
  80214f:	0f 82 4c 01 00 00    	jb     8022a1 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802155:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802159:	75 14                	jne    80216f <insert_sorted_allocList+0x157>
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	68 40 3f 80 00       	push   $0x803f40
  802163:	6a 73                	push   $0x73
  802165:	68 ef 3e 80 00       	push   $0x803eef
  80216a:	e8 0f e2 ff ff       	call   80037e <_panic>
  80216f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	89 50 04             	mov    %edx,0x4(%eax)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 40 04             	mov    0x4(%eax),%eax
  802181:	85 c0                	test   %eax,%eax
  802183:	74 0c                	je     802191 <insert_sorted_allocList+0x179>
  802185:	a1 44 40 80 00       	mov    0x804044,%eax
  80218a:	8b 55 08             	mov    0x8(%ebp),%edx
  80218d:	89 10                	mov    %edx,(%eax)
  80218f:	eb 08                	jmp    802199 <insert_sorted_allocList+0x181>
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	a3 40 40 80 00       	mov    %eax,0x804040
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021aa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021af:	40                   	inc    %eax
  8021b0:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b5:	e9 e7 00 00 00       	jmp    8022a1 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021c0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021c7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cf:	e9 9d 00 00 00       	jmp    802271 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d7:	8b 00                	mov    (%eax),%eax
  8021d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8b 50 08             	mov    0x8(%eax),%edx
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 40 08             	mov    0x8(%eax),%eax
  8021e8:	39 c2                	cmp    %eax,%edx
  8021ea:	76 7d                	jbe    802269 <insert_sorted_allocList+0x251>
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8b 50 08             	mov    0x8(%eax),%edx
  8021f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f5:	8b 40 08             	mov    0x8(%eax),%eax
  8021f8:	39 c2                	cmp    %eax,%edx
  8021fa:	73 6d                	jae    802269 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	74 06                	je     802208 <insert_sorted_allocList+0x1f0>
  802202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802206:	75 14                	jne    80221c <insert_sorted_allocList+0x204>
  802208:	83 ec 04             	sub    $0x4,%esp
  80220b:	68 64 3f 80 00       	push   $0x803f64
  802210:	6a 7f                	push   $0x7f
  802212:	68 ef 3e 80 00       	push   $0x803eef
  802217:	e8 62 e1 ff ff       	call   80037e <_panic>
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 10                	mov    (%eax),%edx
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	89 10                	mov    %edx,(%eax)
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	8b 00                	mov    (%eax),%eax
  80222b:	85 c0                	test   %eax,%eax
  80222d:	74 0b                	je     80223a <insert_sorted_allocList+0x222>
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	8b 00                	mov    (%eax),%eax
  802234:	8b 55 08             	mov    0x8(%ebp),%edx
  802237:	89 50 04             	mov    %edx,0x4(%eax)
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	8b 55 08             	mov    0x8(%ebp),%edx
  802240:	89 10                	mov    %edx,(%eax)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802248:	89 50 04             	mov    %edx,0x4(%eax)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	75 08                	jne    80225c <insert_sorted_allocList+0x244>
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 44 40 80 00       	mov    %eax,0x804044
  80225c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802261:	40                   	inc    %eax
  802262:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802267:	eb 39                	jmp    8022a2 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802269:	a1 48 40 80 00       	mov    0x804048,%eax
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802275:	74 07                	je     80227e <insert_sorted_allocList+0x266>
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 00                	mov    (%eax),%eax
  80227c:	eb 05                	jmp    802283 <insert_sorted_allocList+0x26b>
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
  802283:	a3 48 40 80 00       	mov    %eax,0x804048
  802288:	a1 48 40 80 00       	mov    0x804048,%eax
  80228d:	85 c0                	test   %eax,%eax
  80228f:	0f 85 3f ff ff ff    	jne    8021d4 <insert_sorted_allocList+0x1bc>
  802295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802299:	0f 85 35 ff ff ff    	jne    8021d4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80229f:	eb 01                	jmp    8022a2 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a1:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022a2:	90                   	nop
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022ab:	a1 38 41 80 00       	mov    0x804138,%eax
  8022b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b3:	e9 85 01 00 00       	jmp    80243d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8022be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c1:	0f 82 6e 01 00 00    	jb     802435 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8022cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d0:	0f 85 8a 00 00 00    	jne    802360 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022da:	75 17                	jne    8022f3 <alloc_block_FF+0x4e>
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	68 98 3f 80 00       	push   $0x803f98
  8022e4:	68 93 00 00 00       	push   $0x93
  8022e9:	68 ef 3e 80 00       	push   $0x803eef
  8022ee:	e8 8b e0 ff ff       	call   80037e <_panic>
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	74 10                	je     80230c <alloc_block_FF+0x67>
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802304:	8b 52 04             	mov    0x4(%edx),%edx
  802307:	89 50 04             	mov    %edx,0x4(%eax)
  80230a:	eb 0b                	jmp    802317 <alloc_block_FF+0x72>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 40 04             	mov    0x4(%eax),%eax
  802312:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 04             	mov    0x4(%eax),%eax
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 0f                	je     802330 <alloc_block_FF+0x8b>
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 40 04             	mov    0x4(%eax),%eax
  802327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232a:	8b 12                	mov    (%edx),%edx
  80232c:	89 10                	mov    %edx,(%eax)
  80232e:	eb 0a                	jmp    80233a <alloc_block_FF+0x95>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	a3 38 41 80 00       	mov    %eax,0x804138
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234d:	a1 44 41 80 00       	mov    0x804144,%eax
  802352:	48                   	dec    %eax
  802353:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	e9 10 01 00 00       	jmp    802470 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 40 0c             	mov    0xc(%eax),%eax
  802366:	3b 45 08             	cmp    0x8(%ebp),%eax
  802369:	0f 86 c6 00 00 00    	jbe    802435 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80236f:	a1 48 41 80 00       	mov    0x804148,%eax
  802374:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 50 08             	mov    0x8(%eax),%edx
  80237d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802380:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802386:	8b 55 08             	mov    0x8(%ebp),%edx
  802389:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80238c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802390:	75 17                	jne    8023a9 <alloc_block_FF+0x104>
  802392:	83 ec 04             	sub    $0x4,%esp
  802395:	68 98 3f 80 00       	push   $0x803f98
  80239a:	68 9b 00 00 00       	push   $0x9b
  80239f:	68 ef 3e 80 00       	push   $0x803eef
  8023a4:	e8 d5 df ff ff       	call   80037e <_panic>
  8023a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ac:	8b 00                	mov    (%eax),%eax
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	74 10                	je     8023c2 <alloc_block_FF+0x11d>
  8023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ba:	8b 52 04             	mov    0x4(%edx),%edx
  8023bd:	89 50 04             	mov    %edx,0x4(%eax)
  8023c0:	eb 0b                	jmp    8023cd <alloc_block_FF+0x128>
  8023c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c5:	8b 40 04             	mov    0x4(%eax),%eax
  8023c8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d0:	8b 40 04             	mov    0x4(%eax),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	74 0f                	je     8023e6 <alloc_block_FF+0x141>
  8023d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023da:	8b 40 04             	mov    0x4(%eax),%eax
  8023dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023e0:	8b 12                	mov    (%edx),%edx
  8023e2:	89 10                	mov    %edx,(%eax)
  8023e4:	eb 0a                	jmp    8023f0 <alloc_block_FF+0x14b>
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	8b 00                	mov    (%eax),%eax
  8023eb:	a3 48 41 80 00       	mov    %eax,0x804148
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802403:	a1 54 41 80 00       	mov    0x804154,%eax
  802408:	48                   	dec    %eax
  802409:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 50 08             	mov    0x8(%eax),%edx
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	01 c2                	add    %eax,%edx
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	2b 45 08             	sub    0x8(%ebp),%eax
  802428:	89 c2                	mov    %eax,%edx
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	eb 3b                	jmp    802470 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802435:	a1 40 41 80 00       	mov    0x804140,%eax
  80243a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802441:	74 07                	je     80244a <alloc_block_FF+0x1a5>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	eb 05                	jmp    80244f <alloc_block_FF+0x1aa>
  80244a:	b8 00 00 00 00       	mov    $0x0,%eax
  80244f:	a3 40 41 80 00       	mov    %eax,0x804140
  802454:	a1 40 41 80 00       	mov    0x804140,%eax
  802459:	85 c0                	test   %eax,%eax
  80245b:	0f 85 57 fe ff ff    	jne    8022b8 <alloc_block_FF+0x13>
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	0f 85 4d fe ff ff    	jne    8022b8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802478:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80247f:	a1 38 41 80 00       	mov    0x804138,%eax
  802484:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802487:	e9 df 00 00 00       	jmp    80256b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 40 0c             	mov    0xc(%eax),%eax
  802492:	3b 45 08             	cmp    0x8(%ebp),%eax
  802495:	0f 82 c8 00 00 00    	jb     802563 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a4:	0f 85 8a 00 00 00    	jne    802534 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ae:	75 17                	jne    8024c7 <alloc_block_BF+0x55>
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 98 3f 80 00       	push   $0x803f98
  8024b8:	68 b7 00 00 00       	push   $0xb7
  8024bd:	68 ef 3e 80 00       	push   $0x803eef
  8024c2:	e8 b7 de ff ff       	call   80037e <_panic>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 10                	je     8024e0 <alloc_block_BF+0x6e>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d8:	8b 52 04             	mov    0x4(%edx),%edx
  8024db:	89 50 04             	mov    %edx,0x4(%eax)
  8024de:	eb 0b                	jmp    8024eb <alloc_block_BF+0x79>
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0f                	je     802504 <alloc_block_BF+0x92>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fe:	8b 12                	mov    (%edx),%edx
  802500:	89 10                	mov    %edx,(%eax)
  802502:	eb 0a                	jmp    80250e <alloc_block_BF+0x9c>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	a3 38 41 80 00       	mov    %eax,0x804138
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802521:	a1 44 41 80 00       	mov    0x804144,%eax
  802526:	48                   	dec    %eax
  802527:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	e9 4d 01 00 00       	jmp    802681 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 0c             	mov    0xc(%eax),%eax
  80253a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253d:	76 24                	jbe    802563 <alloc_block_BF+0xf1>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 40 0c             	mov    0xc(%eax),%eax
  802545:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802548:	73 19                	jae    802563 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80254a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 0c             	mov    0xc(%eax),%eax
  802557:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 08             	mov    0x8(%eax),%eax
  802560:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802563:	a1 40 41 80 00       	mov    0x804140,%eax
  802568:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256f:	74 07                	je     802578 <alloc_block_BF+0x106>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	eb 05                	jmp    80257d <alloc_block_BF+0x10b>
  802578:	b8 00 00 00 00       	mov    $0x0,%eax
  80257d:	a3 40 41 80 00       	mov    %eax,0x804140
  802582:	a1 40 41 80 00       	mov    0x804140,%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	0f 85 fd fe ff ff    	jne    80248c <alloc_block_BF+0x1a>
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	0f 85 f3 fe ff ff    	jne    80248c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802599:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80259d:	0f 84 d9 00 00 00    	je     80267c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025a3:	a1 48 41 80 00       	mov    0x804148,%eax
  8025a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025b1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ba:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025c1:	75 17                	jne    8025da <alloc_block_BF+0x168>
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 98 3f 80 00       	push   $0x803f98
  8025cb:	68 c7 00 00 00       	push   $0xc7
  8025d0:	68 ef 3e 80 00       	push   $0x803eef
  8025d5:	e8 a4 dd ff ff       	call   80037e <_panic>
  8025da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	74 10                	je     8025f3 <alloc_block_BF+0x181>
  8025e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025eb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ee:	89 50 04             	mov    %edx,0x4(%eax)
  8025f1:	eb 0b                	jmp    8025fe <alloc_block_BF+0x18c>
  8025f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0f                	je     802617 <alloc_block_BF+0x1a5>
  802608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802611:	8b 12                	mov    (%edx),%edx
  802613:	89 10                	mov    %edx,(%eax)
  802615:	eb 0a                	jmp    802621 <alloc_block_BF+0x1af>
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	a3 48 41 80 00       	mov    %eax,0x804148
  802621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802634:	a1 54 41 80 00       	mov    0x804154,%eax
  802639:	48                   	dec    %eax
  80263a:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80263f:	83 ec 08             	sub    $0x8,%esp
  802642:	ff 75 ec             	pushl  -0x14(%ebp)
  802645:	68 38 41 80 00       	push   $0x804138
  80264a:	e8 71 f9 ff ff       	call   801fc0 <find_block>
  80264f:	83 c4 10             	add    $0x10,%esp
  802652:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802658:	8b 50 08             	mov    0x8(%eax),%edx
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	01 c2                	add    %eax,%edx
  802660:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802663:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802669:	8b 40 0c             	mov    0xc(%eax),%eax
  80266c:	2b 45 08             	sub    0x8(%ebp),%eax
  80266f:	89 c2                	mov    %eax,%edx
  802671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802674:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267a:	eb 05                	jmp    802681 <alloc_block_BF+0x20f>
	}
	return NULL;
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802681:	c9                   	leave  
  802682:	c3                   	ret    

00802683 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802683:	55                   	push   %ebp
  802684:	89 e5                	mov    %esp,%ebp
  802686:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802689:	a1 28 40 80 00       	mov    0x804028,%eax
  80268e:	85 c0                	test   %eax,%eax
  802690:	0f 85 de 01 00 00    	jne    802874 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802696:	a1 38 41 80 00       	mov    0x804138,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	e9 9e 01 00 00       	jmp    802841 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ac:	0f 82 87 01 00 00    	jb     802839 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026bb:	0f 85 95 00 00 00    	jne    802756 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	75 17                	jne    8026de <alloc_block_NF+0x5b>
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 98 3f 80 00       	push   $0x803f98
  8026cf:	68 e0 00 00 00       	push   $0xe0
  8026d4:	68 ef 3e 80 00       	push   $0x803eef
  8026d9:	e8 a0 dc ff ff       	call   80037e <_panic>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 10                	je     8026f7 <alloc_block_NF+0x74>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ef:	8b 52 04             	mov    0x4(%edx),%edx
  8026f2:	89 50 04             	mov    %edx,0x4(%eax)
  8026f5:	eb 0b                	jmp    802702 <alloc_block_NF+0x7f>
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 40 04             	mov    0x4(%eax),%eax
  8026fd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 40 04             	mov    0x4(%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 0f                	je     80271b <alloc_block_NF+0x98>
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 40 04             	mov    0x4(%eax),%eax
  802712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802715:	8b 12                	mov    (%edx),%edx
  802717:	89 10                	mov    %edx,(%eax)
  802719:	eb 0a                	jmp    802725 <alloc_block_NF+0xa2>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	a3 38 41 80 00       	mov    %eax,0x804138
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802731:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802738:	a1 44 41 80 00       	mov    0x804144,%eax
  80273d:	48                   	dec    %eax
  80273e:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 08             	mov    0x8(%eax),%eax
  802749:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	e9 f8 04 00 00       	jmp    802c4e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275f:	0f 86 d4 00 00 00    	jbe    802839 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802765:	a1 48 41 80 00       	mov    0x804148,%eax
  80276a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 50 08             	mov    0x8(%eax),%edx
  802773:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802776:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 55 08             	mov    0x8(%ebp),%edx
  80277f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802782:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802786:	75 17                	jne    80279f <alloc_block_NF+0x11c>
  802788:	83 ec 04             	sub    $0x4,%esp
  80278b:	68 98 3f 80 00       	push   $0x803f98
  802790:	68 e9 00 00 00       	push   $0xe9
  802795:	68 ef 3e 80 00       	push   $0x803eef
  80279a:	e8 df db ff ff       	call   80037e <_panic>
  80279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a2:	8b 00                	mov    (%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 10                	je     8027b8 <alloc_block_NF+0x135>
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027b0:	8b 52 04             	mov    0x4(%edx),%edx
  8027b3:	89 50 04             	mov    %edx,0x4(%eax)
  8027b6:	eb 0b                	jmp    8027c3 <alloc_block_NF+0x140>
  8027b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	74 0f                	je     8027dc <alloc_block_NF+0x159>
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 40 04             	mov    0x4(%eax),%eax
  8027d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d6:	8b 12                	mov    (%edx),%edx
  8027d8:	89 10                	mov    %edx,(%eax)
  8027da:	eb 0a                	jmp    8027e6 <alloc_block_NF+0x163>
  8027dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8027fe:	48                   	dec    %eax
  8027ff:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	8b 40 08             	mov    0x8(%eax),%eax
  80280a:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 50 08             	mov    0x8(%eax),%edx
  802815:	8b 45 08             	mov    0x8(%ebp),%eax
  802818:	01 c2                	add    %eax,%edx
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 0c             	mov    0xc(%eax),%eax
  802826:	2b 45 08             	sub    0x8(%ebp),%eax
  802829:	89 c2                	mov    %eax,%edx
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	e9 15 04 00 00       	jmp    802c4e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802839:	a1 40 41 80 00       	mov    0x804140,%eax
  80283e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802845:	74 07                	je     80284e <alloc_block_NF+0x1cb>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	eb 05                	jmp    802853 <alloc_block_NF+0x1d0>
  80284e:	b8 00 00 00 00       	mov    $0x0,%eax
  802853:	a3 40 41 80 00       	mov    %eax,0x804140
  802858:	a1 40 41 80 00       	mov    0x804140,%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	0f 85 3e fe ff ff    	jne    8026a3 <alloc_block_NF+0x20>
  802865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802869:	0f 85 34 fe ff ff    	jne    8026a3 <alloc_block_NF+0x20>
  80286f:	e9 d5 03 00 00       	jmp    802c49 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802874:	a1 38 41 80 00       	mov    0x804138,%eax
  802879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287c:	e9 b1 01 00 00       	jmp    802a32 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 50 08             	mov    0x8(%eax),%edx
  802887:	a1 28 40 80 00       	mov    0x804028,%eax
  80288c:	39 c2                	cmp    %eax,%edx
  80288e:	0f 82 96 01 00 00    	jb     802a2a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 40 0c             	mov    0xc(%eax),%eax
  80289a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289d:	0f 82 87 01 00 00    	jb     802a2a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ac:	0f 85 95 00 00 00    	jne    802947 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b6:	75 17                	jne    8028cf <alloc_block_NF+0x24c>
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 98 3f 80 00       	push   $0x803f98
  8028c0:	68 fc 00 00 00       	push   $0xfc
  8028c5:	68 ef 3e 80 00       	push   $0x803eef
  8028ca:	e8 af da ff ff       	call   80037e <_panic>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 10                	je     8028e8 <alloc_block_NF+0x265>
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e0:	8b 52 04             	mov    0x4(%edx),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 0b                	jmp    8028f3 <alloc_block_NF+0x270>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0f                	je     80290c <alloc_block_NF+0x289>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	8b 12                	mov    (%edx),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 0a                	jmp    802916 <alloc_block_NF+0x293>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	a3 38 41 80 00       	mov    %eax,0x804138
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802929:	a1 44 41 80 00       	mov    0x804144,%eax
  80292e:	48                   	dec    %eax
  80292f:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	8b 40 08             	mov    0x8(%eax),%eax
  80293a:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	e9 07 03 00 00       	jmp    802c4e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 40 0c             	mov    0xc(%eax),%eax
  80294d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802950:	0f 86 d4 00 00 00    	jbe    802a2a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802956:	a1 48 41 80 00       	mov    0x804148,%eax
  80295b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 50 08             	mov    0x8(%eax),%edx
  802964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802967:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80296a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296d:	8b 55 08             	mov    0x8(%ebp),%edx
  802970:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802973:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802977:	75 17                	jne    802990 <alloc_block_NF+0x30d>
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	68 98 3f 80 00       	push   $0x803f98
  802981:	68 04 01 00 00       	push   $0x104
  802986:	68 ef 3e 80 00       	push   $0x803eef
  80298b:	e8 ee d9 ff ff       	call   80037e <_panic>
  802990:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	85 c0                	test   %eax,%eax
  802997:	74 10                	je     8029a9 <alloc_block_NF+0x326>
  802999:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029a1:	8b 52 04             	mov    0x4(%edx),%edx
  8029a4:	89 50 04             	mov    %edx,0x4(%eax)
  8029a7:	eb 0b                	jmp    8029b4 <alloc_block_NF+0x331>
  8029a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ac:	8b 40 04             	mov    0x4(%eax),%eax
  8029af:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	74 0f                	je     8029cd <alloc_block_NF+0x34a>
  8029be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c1:	8b 40 04             	mov    0x4(%eax),%eax
  8029c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c7:	8b 12                	mov    (%edx),%edx
  8029c9:	89 10                	mov    %edx,(%eax)
  8029cb:	eb 0a                	jmp    8029d7 <alloc_block_NF+0x354>
  8029cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8029d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ef:	48                   	dec    %eax
  8029f0:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8029f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f8:	8b 40 08             	mov    0x8(%eax),%eax
  8029fb:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 50 08             	mov    0x8(%eax),%edx
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	01 c2                	add    %eax,%edx
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 0c             	mov    0xc(%eax),%eax
  802a17:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1a:	89 c2                	mov    %eax,%edx
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a25:	e9 24 02 00 00       	jmp    802c4e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a2a:	a1 40 41 80 00       	mov    0x804140,%eax
  802a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a36:	74 07                	je     802a3f <alloc_block_NF+0x3bc>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	eb 05                	jmp    802a44 <alloc_block_NF+0x3c1>
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	a3 40 41 80 00       	mov    %eax,0x804140
  802a49:	a1 40 41 80 00       	mov    0x804140,%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	0f 85 2b fe ff ff    	jne    802881 <alloc_block_NF+0x1fe>
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	0f 85 21 fe ff ff    	jne    802881 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a60:	a1 38 41 80 00       	mov    0x804138,%eax
  802a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a68:	e9 ae 01 00 00       	jmp    802c1b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	a1 28 40 80 00       	mov    0x804028,%eax
  802a78:	39 c2                	cmp    %eax,%edx
  802a7a:	0f 83 93 01 00 00    	jae    802c13 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 40 0c             	mov    0xc(%eax),%eax
  802a86:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a89:	0f 82 84 01 00 00    	jb     802c13 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a98:	0f 85 95 00 00 00    	jne    802b33 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa2:	75 17                	jne    802abb <alloc_block_NF+0x438>
  802aa4:	83 ec 04             	sub    $0x4,%esp
  802aa7:	68 98 3f 80 00       	push   $0x803f98
  802aac:	68 14 01 00 00       	push   $0x114
  802ab1:	68 ef 3e 80 00       	push   $0x803eef
  802ab6:	e8 c3 d8 ff ff       	call   80037e <_panic>
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	85 c0                	test   %eax,%eax
  802ac2:	74 10                	je     802ad4 <alloc_block_NF+0x451>
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 00                	mov    (%eax),%eax
  802ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802acc:	8b 52 04             	mov    0x4(%edx),%edx
  802acf:	89 50 04             	mov    %edx,0x4(%eax)
  802ad2:	eb 0b                	jmp    802adf <alloc_block_NF+0x45c>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 40 04             	mov    0x4(%eax),%eax
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 0f                	je     802af8 <alloc_block_NF+0x475>
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 40 04             	mov    0x4(%eax),%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	8b 12                	mov    (%edx),%edx
  802af4:	89 10                	mov    %edx,(%eax)
  802af6:	eb 0a                	jmp    802b02 <alloc_block_NF+0x47f>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 00                	mov    (%eax),%eax
  802afd:	a3 38 41 80 00       	mov    %eax,0x804138
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b15:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1a:	48                   	dec    %eax
  802b1b:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	e9 1b 01 00 00       	jmp    802c4e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3c:	0f 86 d1 00 00 00    	jbe    802c13 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b42:	a1 48 41 80 00       	mov    0x804148,%eax
  802b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	8b 50 08             	mov    0x8(%eax),%edx
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b59:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b63:	75 17                	jne    802b7c <alloc_block_NF+0x4f9>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 98 3f 80 00       	push   $0x803f98
  802b6d:	68 1c 01 00 00       	push   $0x11c
  802b72:	68 ef 3e 80 00       	push   $0x803eef
  802b77:	e8 02 d8 ff ff       	call   80037e <_panic>
  802b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	74 10                	je     802b95 <alloc_block_NF+0x512>
  802b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b88:	8b 00                	mov    (%eax),%eax
  802b8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b8d:	8b 52 04             	mov    0x4(%edx),%edx
  802b90:	89 50 04             	mov    %edx,0x4(%eax)
  802b93:	eb 0b                	jmp    802ba0 <alloc_block_NF+0x51d>
  802b95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	74 0f                	je     802bb9 <alloc_block_NF+0x536>
  802baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bad:	8b 40 04             	mov    0x4(%eax),%eax
  802bb0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb3:	8b 12                	mov    (%edx),%edx
  802bb5:	89 10                	mov    %edx,(%eax)
  802bb7:	eb 0a                	jmp    802bc3 <alloc_block_NF+0x540>
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd6:	a1 54 41 80 00       	mov    0x804154,%eax
  802bdb:	48                   	dec    %eax
  802bdc:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802be1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be4:	8b 40 08             	mov    0x8(%eax),%eax
  802be7:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 50 08             	mov    0x8(%eax),%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	01 c2                	add    %eax,%edx
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	2b 45 08             	sub    0x8(%ebp),%eax
  802c06:	89 c2                	mov    %eax,%edx
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	eb 3b                	jmp    802c4e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c13:	a1 40 41 80 00       	mov    0x804140,%eax
  802c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1f:	74 07                	je     802c28 <alloc_block_NF+0x5a5>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	eb 05                	jmp    802c2d <alloc_block_NF+0x5aa>
  802c28:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2d:	a3 40 41 80 00       	mov    %eax,0x804140
  802c32:	a1 40 41 80 00       	mov    0x804140,%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	0f 85 2e fe ff ff    	jne    802a6d <alloc_block_NF+0x3ea>
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	0f 85 24 fe ff ff    	jne    802a6d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c4e:	c9                   	leave  
  802c4f:	c3                   	ret    

00802c50 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
  802c53:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c56:	a1 38 41 80 00       	mov    0x804138,%eax
  802c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c5e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c63:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c66:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	74 14                	je     802c83 <insert_sorted_with_merge_freeList+0x33>
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	8b 40 08             	mov    0x8(%eax),%eax
  802c7b:	39 c2                	cmp    %eax,%edx
  802c7d:	0f 87 9b 01 00 00    	ja     802e1e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c87:	75 17                	jne    802ca0 <insert_sorted_with_merge_freeList+0x50>
  802c89:	83 ec 04             	sub    $0x4,%esp
  802c8c:	68 cc 3e 80 00       	push   $0x803ecc
  802c91:	68 38 01 00 00       	push   $0x138
  802c96:	68 ef 3e 80 00       	push   $0x803eef
  802c9b:	e8 de d6 ff ff       	call   80037e <_panic>
  802ca0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	89 10                	mov    %edx,(%eax)
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	8b 00                	mov    (%eax),%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	74 0d                	je     802cc1 <insert_sorted_with_merge_freeList+0x71>
  802cb4:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbc:	89 50 04             	mov    %edx,0x4(%eax)
  802cbf:	eb 08                	jmp    802cc9 <insert_sorted_with_merge_freeList+0x79>
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	a3 38 41 80 00       	mov    %eax,0x804138
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdb:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce0:	40                   	inc    %eax
  802ce1:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ce6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cea:	0f 84 a8 06 00 00    	je     803398 <insert_sorted_with_merge_freeList+0x748>
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 50 08             	mov    0x8(%eax),%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfc:	01 c2                	add    %eax,%edx
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 40 08             	mov    0x8(%eax),%eax
  802d04:	39 c2                	cmp    %eax,%edx
  802d06:	0f 85 8c 06 00 00    	jne    803398 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	01 c2                	add    %eax,%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d24:	75 17                	jne    802d3d <insert_sorted_with_merge_freeList+0xed>
  802d26:	83 ec 04             	sub    $0x4,%esp
  802d29:	68 98 3f 80 00       	push   $0x803f98
  802d2e:	68 3c 01 00 00       	push   $0x13c
  802d33:	68 ef 3e 80 00       	push   $0x803eef
  802d38:	e8 41 d6 ff ff       	call   80037e <_panic>
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	85 c0                	test   %eax,%eax
  802d44:	74 10                	je     802d56 <insert_sorted_with_merge_freeList+0x106>
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4e:	8b 52 04             	mov    0x4(%edx),%edx
  802d51:	89 50 04             	mov    %edx,0x4(%eax)
  802d54:	eb 0b                	jmp    802d61 <insert_sorted_with_merge_freeList+0x111>
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	85 c0                	test   %eax,%eax
  802d69:	74 0f                	je     802d7a <insert_sorted_with_merge_freeList+0x12a>
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	8b 40 04             	mov    0x4(%eax),%eax
  802d71:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d74:	8b 12                	mov    (%edx),%edx
  802d76:	89 10                	mov    %edx,(%eax)
  802d78:	eb 0a                	jmp    802d84 <insert_sorted_with_merge_freeList+0x134>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	a3 38 41 80 00       	mov    %eax,0x804138
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d97:	a1 44 41 80 00       	mov    0x804144,%eax
  802d9c:	48                   	dec    %eax
  802d9d:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802db6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dba:	75 17                	jne    802dd3 <insert_sorted_with_merge_freeList+0x183>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 cc 3e 80 00       	push   $0x803ecc
  802dc4:	68 3f 01 00 00       	push   $0x13f
  802dc9:	68 ef 3e 80 00       	push   $0x803eef
  802dce:	e8 ab d5 ff ff       	call   80037e <_panic>
  802dd3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddc:	89 10                	mov    %edx,(%eax)
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 0d                	je     802df4 <insert_sorted_with_merge_freeList+0x1a4>
  802de7:	a1 48 41 80 00       	mov    0x804148,%eax
  802dec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	eb 08                	jmp    802dfc <insert_sorted_with_merge_freeList+0x1ac>
  802df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dff:	a3 48 41 80 00       	mov    %eax,0x804148
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e13:	40                   	inc    %eax
  802e14:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e19:	e9 7a 05 00 00       	jmp    803398 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 50 08             	mov    0x8(%eax),%edx
  802e24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e27:	8b 40 08             	mov    0x8(%eax),%eax
  802e2a:	39 c2                	cmp    %eax,%edx
  802e2c:	0f 82 14 01 00 00    	jb     802f46 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e35:	8b 50 08             	mov    0x8(%eax),%edx
  802e38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	01 c2                	add    %eax,%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	8b 40 08             	mov    0x8(%eax),%eax
  802e46:	39 c2                	cmp    %eax,%edx
  802e48:	0f 85 90 00 00 00    	jne    802ede <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e51:	8b 50 0c             	mov    0xc(%eax),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	01 c2                	add    %eax,%edx
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7a:	75 17                	jne    802e93 <insert_sorted_with_merge_freeList+0x243>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 cc 3e 80 00       	push   $0x803ecc
  802e84:	68 49 01 00 00       	push   $0x149
  802e89:	68 ef 3e 80 00       	push   $0x803eef
  802e8e:	e8 eb d4 ff ff       	call   80037e <_panic>
  802e93:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <insert_sorted_with_merge_freeList+0x264>
  802ea7:	a1 48 41 80 00       	mov    0x804148,%eax
  802eac:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x26c>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ed9:	e9 bb 04 00 00       	jmp    803399 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ede:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee2:	75 17                	jne    802efb <insert_sorted_with_merge_freeList+0x2ab>
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	68 40 3f 80 00       	push   $0x803f40
  802eec:	68 4c 01 00 00       	push   $0x14c
  802ef1:	68 ef 3e 80 00       	push   $0x803eef
  802ef6:	e8 83 d4 ff ff       	call   80037e <_panic>
  802efb:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	89 50 04             	mov    %edx,0x4(%eax)
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	74 0c                	je     802f1d <insert_sorted_with_merge_freeList+0x2cd>
  802f11:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f16:	8b 55 08             	mov    0x8(%ebp),%edx
  802f19:	89 10                	mov    %edx,(%eax)
  802f1b:	eb 08                	jmp    802f25 <insert_sorted_with_merge_freeList+0x2d5>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 38 41 80 00       	mov    %eax,0x804138
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f36:	a1 44 41 80 00       	mov    0x804144,%eax
  802f3b:	40                   	inc    %eax
  802f3c:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f41:	e9 53 04 00 00       	jmp    803399 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f46:	a1 38 41 80 00       	mov    0x804138,%eax
  802f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4e:	e9 15 04 00 00       	jmp    803368 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 50 08             	mov    0x8(%eax),%edx
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 40 08             	mov    0x8(%eax),%eax
  802f67:	39 c2                	cmp    %eax,%edx
  802f69:	0f 86 f1 03 00 00    	jbe    803360 <insert_sorted_with_merge_freeList+0x710>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f78:	8b 40 08             	mov    0x8(%eax),%eax
  802f7b:	39 c2                	cmp    %eax,%edx
  802f7d:	0f 83 dd 03 00 00    	jae    803360 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 50 08             	mov    0x8(%eax),%edx
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8f:	01 c2                	add    %eax,%edx
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	8b 40 08             	mov    0x8(%eax),%eax
  802f97:	39 c2                	cmp    %eax,%edx
  802f99:	0f 85 b9 01 00 00    	jne    803158 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	8b 50 08             	mov    0x8(%eax),%edx
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fab:	01 c2                	add    %eax,%edx
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 40 08             	mov    0x8(%eax),%eax
  802fb3:	39 c2                	cmp    %eax,%edx
  802fb5:	0f 85 0d 01 00 00    	jne    8030c8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	01 c2                	add    %eax,%edx
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fcf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd3:	75 17                	jne    802fec <insert_sorted_with_merge_freeList+0x39c>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 98 3f 80 00       	push   $0x803f98
  802fdd:	68 5c 01 00 00       	push   $0x15c
  802fe2:	68 ef 3e 80 00       	push   $0x803eef
  802fe7:	e8 92 d3 ff ff       	call   80037e <_panic>
  802fec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	74 10                	je     803005 <insert_sorted_with_merge_freeList+0x3b5>
  802ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ffd:	8b 52 04             	mov    0x4(%edx),%edx
  803000:	89 50 04             	mov    %edx,0x4(%eax)
  803003:	eb 0b                	jmp    803010 <insert_sorted_with_merge_freeList+0x3c0>
  803005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 40 04             	mov    0x4(%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0f                	je     803029 <insert_sorted_with_merge_freeList+0x3d9>
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803023:	8b 12                	mov    (%edx),%edx
  803025:	89 10                	mov    %edx,(%eax)
  803027:	eb 0a                	jmp    803033 <insert_sorted_with_merge_freeList+0x3e3>
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	a3 38 41 80 00       	mov    %eax,0x804138
  803033:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803036:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803046:	a1 44 41 80 00       	mov    0x804144,%eax
  80304b:	48                   	dec    %eax
  80304c:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  803051:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803054:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803065:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803069:	75 17                	jne    803082 <insert_sorted_with_merge_freeList+0x432>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 cc 3e 80 00       	push   $0x803ecc
  803073:	68 5f 01 00 00       	push   $0x15f
  803078:	68 ef 3e 80 00       	push   $0x803eef
  80307d:	e8 fc d2 ff ff       	call   80037e <_panic>
  803082:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 0d                	je     8030a3 <insert_sorted_with_merge_freeList+0x453>
  803096:	a1 48 41 80 00       	mov    0x804148,%eax
  80309b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	eb 08                	jmp    8030ab <insert_sorted_with_merge_freeList+0x45b>
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c2:	40                   	inc    %eax
  8030c3:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d4:	01 c2                	add    %eax,%edx
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f4:	75 17                	jne    80310d <insert_sorted_with_merge_freeList+0x4bd>
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	68 cc 3e 80 00       	push   $0x803ecc
  8030fe:	68 64 01 00 00       	push   $0x164
  803103:	68 ef 3e 80 00       	push   $0x803eef
  803108:	e8 71 d2 ff ff       	call   80037e <_panic>
  80310d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	89 10                	mov    %edx,(%eax)
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 00                	mov    (%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 0d                	je     80312e <insert_sorted_with_merge_freeList+0x4de>
  803121:	a1 48 41 80 00       	mov    0x804148,%eax
  803126:	8b 55 08             	mov    0x8(%ebp),%edx
  803129:	89 50 04             	mov    %edx,0x4(%eax)
  80312c:	eb 08                	jmp    803136 <insert_sorted_with_merge_freeList+0x4e6>
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	a3 48 41 80 00       	mov    %eax,0x804148
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803148:	a1 54 41 80 00       	mov    0x804154,%eax
  80314d:	40                   	inc    %eax
  80314e:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803153:	e9 41 02 00 00       	jmp    803399 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 40 0c             	mov    0xc(%eax),%eax
  803164:	01 c2                	add    %eax,%edx
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	8b 40 08             	mov    0x8(%eax),%eax
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	0f 85 7c 01 00 00    	jne    8032f0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803174:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803178:	74 06                	je     803180 <insert_sorted_with_merge_freeList+0x530>
  80317a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317e:	75 17                	jne    803197 <insert_sorted_with_merge_freeList+0x547>
  803180:	83 ec 04             	sub    $0x4,%esp
  803183:	68 08 3f 80 00       	push   $0x803f08
  803188:	68 69 01 00 00       	push   $0x169
  80318d:	68 ef 3e 80 00       	push   $0x803eef
  803192:	e8 e7 d1 ff ff       	call   80037e <_panic>
  803197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319a:	8b 50 04             	mov    0x4(%eax),%edx
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	89 50 04             	mov    %edx,0x4(%eax)
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a9:	89 10                	mov    %edx,(%eax)
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 0d                	je     8031c2 <insert_sorted_with_merge_freeList+0x572>
  8031b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031be:	89 10                	mov    %edx,(%eax)
  8031c0:	eb 08                	jmp    8031ca <insert_sorted_with_merge_freeList+0x57a>
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d0:	89 50 04             	mov    %edx,0x4(%eax)
  8031d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031d8:	40                   	inc    %eax
  8031d9:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ea:	01 c2                	add    %eax,%edx
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f6:	75 17                	jne    80320f <insert_sorted_with_merge_freeList+0x5bf>
  8031f8:	83 ec 04             	sub    $0x4,%esp
  8031fb:	68 98 3f 80 00       	push   $0x803f98
  803200:	68 6b 01 00 00       	push   $0x16b
  803205:	68 ef 3e 80 00       	push   $0x803eef
  80320a:	e8 6f d1 ff ff       	call   80037e <_panic>
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	8b 00                	mov    (%eax),%eax
  803214:	85 c0                	test   %eax,%eax
  803216:	74 10                	je     803228 <insert_sorted_with_merge_freeList+0x5d8>
  803218:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321b:	8b 00                	mov    (%eax),%eax
  80321d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803220:	8b 52 04             	mov    0x4(%edx),%edx
  803223:	89 50 04             	mov    %edx,0x4(%eax)
  803226:	eb 0b                	jmp    803233 <insert_sorted_with_merge_freeList+0x5e3>
  803228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322b:	8b 40 04             	mov    0x4(%eax),%eax
  80322e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 40 04             	mov    0x4(%eax),%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	74 0f                	je     80324c <insert_sorted_with_merge_freeList+0x5fc>
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	8b 40 04             	mov    0x4(%eax),%eax
  803243:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803246:	8b 12                	mov    (%edx),%edx
  803248:	89 10                	mov    %edx,(%eax)
  80324a:	eb 0a                	jmp    803256 <insert_sorted_with_merge_freeList+0x606>
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 00                	mov    (%eax),%eax
  803251:	a3 38 41 80 00       	mov    %eax,0x804138
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80325f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803269:	a1 44 41 80 00       	mov    0x804144,%eax
  80326e:	48                   	dec    %eax
  80326f:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803274:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803277:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803288:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80328c:	75 17                	jne    8032a5 <insert_sorted_with_merge_freeList+0x655>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 cc 3e 80 00       	push   $0x803ecc
  803296:	68 6e 01 00 00       	push   $0x16e
  80329b:	68 ef 3e 80 00       	push   $0x803eef
  8032a0:	e8 d9 d0 ff ff       	call   80037e <_panic>
  8032a5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8032ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ae:	89 10                	mov    %edx,(%eax)
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 0d                	je     8032c6 <insert_sorted_with_merge_freeList+0x676>
  8032b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8032be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c1:	89 50 04             	mov    %edx,0x4(%eax)
  8032c4:	eb 08                	jmp    8032ce <insert_sorted_with_merge_freeList+0x67e>
  8032c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	a3 48 41 80 00       	mov    %eax,0x804148
  8032d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8032e5:	40                   	inc    %eax
  8032e6:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8032eb:	e9 a9 00 00 00       	jmp    803399 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f4:	74 06                	je     8032fc <insert_sorted_with_merge_freeList+0x6ac>
  8032f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032fa:	75 17                	jne    803313 <insert_sorted_with_merge_freeList+0x6c3>
  8032fc:	83 ec 04             	sub    $0x4,%esp
  8032ff:	68 64 3f 80 00       	push   $0x803f64
  803304:	68 73 01 00 00       	push   $0x173
  803309:	68 ef 3e 80 00       	push   $0x803eef
  80330e:	e8 6b d0 ff ff       	call   80037e <_panic>
  803313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803316:	8b 10                	mov    (%eax),%edx
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	89 10                	mov    %edx,(%eax)
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 00                	mov    (%eax),%eax
  803322:	85 c0                	test   %eax,%eax
  803324:	74 0b                	je     803331 <insert_sorted_with_merge_freeList+0x6e1>
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	8b 55 08             	mov    0x8(%ebp),%edx
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803334:	8b 55 08             	mov    0x8(%ebp),%edx
  803337:	89 10                	mov    %edx,(%eax)
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333f:	89 50 04             	mov    %edx,0x4(%eax)
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	75 08                	jne    803353 <insert_sorted_with_merge_freeList+0x703>
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803353:	a1 44 41 80 00       	mov    0x804144,%eax
  803358:	40                   	inc    %eax
  803359:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80335e:	eb 39                	jmp    803399 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803360:	a1 40 41 80 00       	mov    0x804140,%eax
  803365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803368:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336c:	74 07                	je     803375 <insert_sorted_with_merge_freeList+0x725>
  80336e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803371:	8b 00                	mov    (%eax),%eax
  803373:	eb 05                	jmp    80337a <insert_sorted_with_merge_freeList+0x72a>
  803375:	b8 00 00 00 00       	mov    $0x0,%eax
  80337a:	a3 40 41 80 00       	mov    %eax,0x804140
  80337f:	a1 40 41 80 00       	mov    0x804140,%eax
  803384:	85 c0                	test   %eax,%eax
  803386:	0f 85 c7 fb ff ff    	jne    802f53 <insert_sorted_with_merge_freeList+0x303>
  80338c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803390:	0f 85 bd fb ff ff    	jne    802f53 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803396:	eb 01                	jmp    803399 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803398:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803399:	90                   	nop
  80339a:	c9                   	leave  
  80339b:	c3                   	ret    

0080339c <__udivdi3>:
  80339c:	55                   	push   %ebp
  80339d:	57                   	push   %edi
  80339e:	56                   	push   %esi
  80339f:	53                   	push   %ebx
  8033a0:	83 ec 1c             	sub    $0x1c,%esp
  8033a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033b3:	89 ca                	mov    %ecx,%edx
  8033b5:	89 f8                	mov    %edi,%eax
  8033b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033bb:	85 f6                	test   %esi,%esi
  8033bd:	75 2d                	jne    8033ec <__udivdi3+0x50>
  8033bf:	39 cf                	cmp    %ecx,%edi
  8033c1:	77 65                	ja     803428 <__udivdi3+0x8c>
  8033c3:	89 fd                	mov    %edi,%ebp
  8033c5:	85 ff                	test   %edi,%edi
  8033c7:	75 0b                	jne    8033d4 <__udivdi3+0x38>
  8033c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ce:	31 d2                	xor    %edx,%edx
  8033d0:	f7 f7                	div    %edi
  8033d2:	89 c5                	mov    %eax,%ebp
  8033d4:	31 d2                	xor    %edx,%edx
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	f7 f5                	div    %ebp
  8033da:	89 c1                	mov    %eax,%ecx
  8033dc:	89 d8                	mov    %ebx,%eax
  8033de:	f7 f5                	div    %ebp
  8033e0:	89 cf                	mov    %ecx,%edi
  8033e2:	89 fa                	mov    %edi,%edx
  8033e4:	83 c4 1c             	add    $0x1c,%esp
  8033e7:	5b                   	pop    %ebx
  8033e8:	5e                   	pop    %esi
  8033e9:	5f                   	pop    %edi
  8033ea:	5d                   	pop    %ebp
  8033eb:	c3                   	ret    
  8033ec:	39 ce                	cmp    %ecx,%esi
  8033ee:	77 28                	ja     803418 <__udivdi3+0x7c>
  8033f0:	0f bd fe             	bsr    %esi,%edi
  8033f3:	83 f7 1f             	xor    $0x1f,%edi
  8033f6:	75 40                	jne    803438 <__udivdi3+0x9c>
  8033f8:	39 ce                	cmp    %ecx,%esi
  8033fa:	72 0a                	jb     803406 <__udivdi3+0x6a>
  8033fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803400:	0f 87 9e 00 00 00    	ja     8034a4 <__udivdi3+0x108>
  803406:	b8 01 00 00 00       	mov    $0x1,%eax
  80340b:	89 fa                	mov    %edi,%edx
  80340d:	83 c4 1c             	add    $0x1c,%esp
  803410:	5b                   	pop    %ebx
  803411:	5e                   	pop    %esi
  803412:	5f                   	pop    %edi
  803413:	5d                   	pop    %ebp
  803414:	c3                   	ret    
  803415:	8d 76 00             	lea    0x0(%esi),%esi
  803418:	31 ff                	xor    %edi,%edi
  80341a:	31 c0                	xor    %eax,%eax
  80341c:	89 fa                	mov    %edi,%edx
  80341e:	83 c4 1c             	add    $0x1c,%esp
  803421:	5b                   	pop    %ebx
  803422:	5e                   	pop    %esi
  803423:	5f                   	pop    %edi
  803424:	5d                   	pop    %ebp
  803425:	c3                   	ret    
  803426:	66 90                	xchg   %ax,%ax
  803428:	89 d8                	mov    %ebx,%eax
  80342a:	f7 f7                	div    %edi
  80342c:	31 ff                	xor    %edi,%edi
  80342e:	89 fa                	mov    %edi,%edx
  803430:	83 c4 1c             	add    $0x1c,%esp
  803433:	5b                   	pop    %ebx
  803434:	5e                   	pop    %esi
  803435:	5f                   	pop    %edi
  803436:	5d                   	pop    %ebp
  803437:	c3                   	ret    
  803438:	bd 20 00 00 00       	mov    $0x20,%ebp
  80343d:	89 eb                	mov    %ebp,%ebx
  80343f:	29 fb                	sub    %edi,%ebx
  803441:	89 f9                	mov    %edi,%ecx
  803443:	d3 e6                	shl    %cl,%esi
  803445:	89 c5                	mov    %eax,%ebp
  803447:	88 d9                	mov    %bl,%cl
  803449:	d3 ed                	shr    %cl,%ebp
  80344b:	89 e9                	mov    %ebp,%ecx
  80344d:	09 f1                	or     %esi,%ecx
  80344f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803453:	89 f9                	mov    %edi,%ecx
  803455:	d3 e0                	shl    %cl,%eax
  803457:	89 c5                	mov    %eax,%ebp
  803459:	89 d6                	mov    %edx,%esi
  80345b:	88 d9                	mov    %bl,%cl
  80345d:	d3 ee                	shr    %cl,%esi
  80345f:	89 f9                	mov    %edi,%ecx
  803461:	d3 e2                	shl    %cl,%edx
  803463:	8b 44 24 08          	mov    0x8(%esp),%eax
  803467:	88 d9                	mov    %bl,%cl
  803469:	d3 e8                	shr    %cl,%eax
  80346b:	09 c2                	or     %eax,%edx
  80346d:	89 d0                	mov    %edx,%eax
  80346f:	89 f2                	mov    %esi,%edx
  803471:	f7 74 24 0c          	divl   0xc(%esp)
  803475:	89 d6                	mov    %edx,%esi
  803477:	89 c3                	mov    %eax,%ebx
  803479:	f7 e5                	mul    %ebp
  80347b:	39 d6                	cmp    %edx,%esi
  80347d:	72 19                	jb     803498 <__udivdi3+0xfc>
  80347f:	74 0b                	je     80348c <__udivdi3+0xf0>
  803481:	89 d8                	mov    %ebx,%eax
  803483:	31 ff                	xor    %edi,%edi
  803485:	e9 58 ff ff ff       	jmp    8033e2 <__udivdi3+0x46>
  80348a:	66 90                	xchg   %ax,%ax
  80348c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803490:	89 f9                	mov    %edi,%ecx
  803492:	d3 e2                	shl    %cl,%edx
  803494:	39 c2                	cmp    %eax,%edx
  803496:	73 e9                	jae    803481 <__udivdi3+0xe5>
  803498:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80349b:	31 ff                	xor    %edi,%edi
  80349d:	e9 40 ff ff ff       	jmp    8033e2 <__udivdi3+0x46>
  8034a2:	66 90                	xchg   %ax,%ax
  8034a4:	31 c0                	xor    %eax,%eax
  8034a6:	e9 37 ff ff ff       	jmp    8033e2 <__udivdi3+0x46>
  8034ab:	90                   	nop

008034ac <__umoddi3>:
  8034ac:	55                   	push   %ebp
  8034ad:	57                   	push   %edi
  8034ae:	56                   	push   %esi
  8034af:	53                   	push   %ebx
  8034b0:	83 ec 1c             	sub    $0x1c,%esp
  8034b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034cb:	89 f3                	mov    %esi,%ebx
  8034cd:	89 fa                	mov    %edi,%edx
  8034cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034d3:	89 34 24             	mov    %esi,(%esp)
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	75 1a                	jne    8034f4 <__umoddi3+0x48>
  8034da:	39 f7                	cmp    %esi,%edi
  8034dc:	0f 86 a2 00 00 00    	jbe    803584 <__umoddi3+0xd8>
  8034e2:	89 c8                	mov    %ecx,%eax
  8034e4:	89 f2                	mov    %esi,%edx
  8034e6:	f7 f7                	div    %edi
  8034e8:	89 d0                	mov    %edx,%eax
  8034ea:	31 d2                	xor    %edx,%edx
  8034ec:	83 c4 1c             	add    $0x1c,%esp
  8034ef:	5b                   	pop    %ebx
  8034f0:	5e                   	pop    %esi
  8034f1:	5f                   	pop    %edi
  8034f2:	5d                   	pop    %ebp
  8034f3:	c3                   	ret    
  8034f4:	39 f0                	cmp    %esi,%eax
  8034f6:	0f 87 ac 00 00 00    	ja     8035a8 <__umoddi3+0xfc>
  8034fc:	0f bd e8             	bsr    %eax,%ebp
  8034ff:	83 f5 1f             	xor    $0x1f,%ebp
  803502:	0f 84 ac 00 00 00    	je     8035b4 <__umoddi3+0x108>
  803508:	bf 20 00 00 00       	mov    $0x20,%edi
  80350d:	29 ef                	sub    %ebp,%edi
  80350f:	89 fe                	mov    %edi,%esi
  803511:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803515:	89 e9                	mov    %ebp,%ecx
  803517:	d3 e0                	shl    %cl,%eax
  803519:	89 d7                	mov    %edx,%edi
  80351b:	89 f1                	mov    %esi,%ecx
  80351d:	d3 ef                	shr    %cl,%edi
  80351f:	09 c7                	or     %eax,%edi
  803521:	89 e9                	mov    %ebp,%ecx
  803523:	d3 e2                	shl    %cl,%edx
  803525:	89 14 24             	mov    %edx,(%esp)
  803528:	89 d8                	mov    %ebx,%eax
  80352a:	d3 e0                	shl    %cl,%eax
  80352c:	89 c2                	mov    %eax,%edx
  80352e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803532:	d3 e0                	shl    %cl,%eax
  803534:	89 44 24 04          	mov    %eax,0x4(%esp)
  803538:	8b 44 24 08          	mov    0x8(%esp),%eax
  80353c:	89 f1                	mov    %esi,%ecx
  80353e:	d3 e8                	shr    %cl,%eax
  803540:	09 d0                	or     %edx,%eax
  803542:	d3 eb                	shr    %cl,%ebx
  803544:	89 da                	mov    %ebx,%edx
  803546:	f7 f7                	div    %edi
  803548:	89 d3                	mov    %edx,%ebx
  80354a:	f7 24 24             	mull   (%esp)
  80354d:	89 c6                	mov    %eax,%esi
  80354f:	89 d1                	mov    %edx,%ecx
  803551:	39 d3                	cmp    %edx,%ebx
  803553:	0f 82 87 00 00 00    	jb     8035e0 <__umoddi3+0x134>
  803559:	0f 84 91 00 00 00    	je     8035f0 <__umoddi3+0x144>
  80355f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803563:	29 f2                	sub    %esi,%edx
  803565:	19 cb                	sbb    %ecx,%ebx
  803567:	89 d8                	mov    %ebx,%eax
  803569:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80356d:	d3 e0                	shl    %cl,%eax
  80356f:	89 e9                	mov    %ebp,%ecx
  803571:	d3 ea                	shr    %cl,%edx
  803573:	09 d0                	or     %edx,%eax
  803575:	89 e9                	mov    %ebp,%ecx
  803577:	d3 eb                	shr    %cl,%ebx
  803579:	89 da                	mov    %ebx,%edx
  80357b:	83 c4 1c             	add    $0x1c,%esp
  80357e:	5b                   	pop    %ebx
  80357f:	5e                   	pop    %esi
  803580:	5f                   	pop    %edi
  803581:	5d                   	pop    %ebp
  803582:	c3                   	ret    
  803583:	90                   	nop
  803584:	89 fd                	mov    %edi,%ebp
  803586:	85 ff                	test   %edi,%edi
  803588:	75 0b                	jne    803595 <__umoddi3+0xe9>
  80358a:	b8 01 00 00 00       	mov    $0x1,%eax
  80358f:	31 d2                	xor    %edx,%edx
  803591:	f7 f7                	div    %edi
  803593:	89 c5                	mov    %eax,%ebp
  803595:	89 f0                	mov    %esi,%eax
  803597:	31 d2                	xor    %edx,%edx
  803599:	f7 f5                	div    %ebp
  80359b:	89 c8                	mov    %ecx,%eax
  80359d:	f7 f5                	div    %ebp
  80359f:	89 d0                	mov    %edx,%eax
  8035a1:	e9 44 ff ff ff       	jmp    8034ea <__umoddi3+0x3e>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	89 c8                	mov    %ecx,%eax
  8035aa:	89 f2                	mov    %esi,%edx
  8035ac:	83 c4 1c             	add    $0x1c,%esp
  8035af:	5b                   	pop    %ebx
  8035b0:	5e                   	pop    %esi
  8035b1:	5f                   	pop    %edi
  8035b2:	5d                   	pop    %ebp
  8035b3:	c3                   	ret    
  8035b4:	3b 04 24             	cmp    (%esp),%eax
  8035b7:	72 06                	jb     8035bf <__umoddi3+0x113>
  8035b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035bd:	77 0f                	ja     8035ce <__umoddi3+0x122>
  8035bf:	89 f2                	mov    %esi,%edx
  8035c1:	29 f9                	sub    %edi,%ecx
  8035c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035c7:	89 14 24             	mov    %edx,(%esp)
  8035ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035d2:	8b 14 24             	mov    (%esp),%edx
  8035d5:	83 c4 1c             	add    $0x1c,%esp
  8035d8:	5b                   	pop    %ebx
  8035d9:	5e                   	pop    %esi
  8035da:	5f                   	pop    %edi
  8035db:	5d                   	pop    %ebp
  8035dc:	c3                   	ret    
  8035dd:	8d 76 00             	lea    0x0(%esi),%esi
  8035e0:	2b 04 24             	sub    (%esp),%eax
  8035e3:	19 fa                	sbb    %edi,%edx
  8035e5:	89 d1                	mov    %edx,%ecx
  8035e7:	89 c6                	mov    %eax,%esi
  8035e9:	e9 71 ff ff ff       	jmp    80355f <__umoddi3+0xb3>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035f4:	72 ea                	jb     8035e0 <__umoddi3+0x134>
  8035f6:	89 d9                	mov    %ebx,%ecx
  8035f8:	e9 62 ff ff ff       	jmp    80355f <__umoddi3+0xb3>
