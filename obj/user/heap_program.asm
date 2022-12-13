
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
  800082:	e8 3a 19 00 00       	call   8019c1 <sys_pf_calculate_allocated_pages>
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
  8000ec:	e8 44 15 00 00       	call   801635 <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 36 15 00 00       	call   801635 <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 1a 18 00 00       	call   801921 <sys_calculate_free_frames>
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
  800152:	bb 5c 38 80 00       	mov    $0x80385c,%ebx
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
  8001d7:	68 60 37 80 00       	push   $0x803760
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 c1 37 80 00       	push   $0x8037c1
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
  8001f8:	e8 24 17 00 00       	call   801921 <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 13 17 00 00       	call   801921 <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 d8 37 80 00       	push   $0x8037d8
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 c1 37 80 00       	push   $0x8037c1
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 1c 38 80 00       	push   $0x80381c
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
  800248:	e8 b4 19 00 00       	call   801c01 <sys_getenvindex>
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
  8002b3:	e8 56 17 00 00       	call   801a0e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 90 38 80 00       	push   $0x803890
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
  8002e3:	68 b8 38 80 00       	push   $0x8038b8
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
  800314:	68 e0 38 80 00       	push   $0x8038e0
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 50 80 00       	mov    0x805020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 38 39 80 00       	push   $0x803938
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 90 38 80 00       	push   $0x803890
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 d6 16 00 00       	call   801a28 <sys_enable_interrupt>

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
  800365:	e8 63 18 00 00       	call   801bcd <sys_destroy_env>
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
  800376:	e8 b8 18 00 00       	call   801c33 <sys_exit_env>
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
  80039f:	68 4c 39 80 00       	push   $0x80394c
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 50 80 00       	mov    0x805000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 51 39 80 00       	push   $0x803951
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
  8003dc:	68 6d 39 80 00       	push   $0x80396d
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
  800408:	68 70 39 80 00       	push   $0x803970
  80040d:	6a 26                	push   $0x26
  80040f:	68 bc 39 80 00       	push   $0x8039bc
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
  8004da:	68 c8 39 80 00       	push   $0x8039c8
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 bc 39 80 00       	push   $0x8039bc
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
  80054a:	68 1c 3a 80 00       	push   $0x803a1c
  80054f:	6a 44                	push   $0x44
  800551:	68 bc 39 80 00       	push   $0x8039bc
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
  8005a4:	e8 b7 12 00 00       	call   801860 <sys_cputs>
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
  80061b:	e8 40 12 00 00       	call   801860 <sys_cputs>
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
  800665:	e8 a4 13 00 00       	call   801a0e <sys_disable_interrupt>
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
  800685:	e8 9e 13 00 00       	call   801a28 <sys_enable_interrupt>
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
  8006cf:	e8 10 2e 00 00       	call   8034e4 <__udivdi3>
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
  80071f:	e8 d0 2e 00 00       	call   8035f4 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 94 3c 80 00       	add    $0x803c94,%eax
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
  80087a:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
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
  80095b:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 a5 3c 80 00       	push   $0x803ca5
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
  800980:	68 ae 3c 80 00       	push   $0x803cae
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
  8009ad:	be b1 3c 80 00       	mov    $0x803cb1,%esi
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
  8013d3:	68 10 3e 80 00       	push   $0x803e10
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
  8014a3:	e8 fc 04 00 00       	call   8019a4 <sys_allocate_chunk>
  8014a8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ab:	a1 20 51 80 00       	mov    0x805120,%eax
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	50                   	push   %eax
  8014b4:	e8 71 0b 00 00       	call   80202a <initialize_MemBlocksList>
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
  8014e1:	68 35 3e 80 00       	push   $0x803e35
  8014e6:	6a 33                	push   $0x33
  8014e8:	68 53 3e 80 00       	push   $0x803e53
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
  801560:	68 60 3e 80 00       	push   $0x803e60
  801565:	6a 34                	push   $0x34
  801567:	68 53 3e 80 00       	push   $0x803e53
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
  8015bd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c0:	e8 f7 fd ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  8015c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c9:	75 07                	jne    8015d2 <malloc+0x18>
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 61                	jmp    801633 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8015d2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	48                   	dec    %eax
  8015e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	f7 75 f0             	divl   -0x10(%ebp)
  8015f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f3:	29 d0                	sub    %edx,%eax
  8015f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f8:	e8 75 07 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	74 11                	je     801612 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	ff 75 e8             	pushl  -0x18(%ebp)
  801607:	e8 e0 0d 00 00       	call   8023ec <alloc_block_FF>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801616:	74 16                	je     80162e <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801618:	83 ec 0c             	sub    $0xc,%esp
  80161b:	ff 75 f4             	pushl  -0xc(%ebp)
  80161e:	e8 3c 0b 00 00       	call   80215f <insert_sorted_allocList>
  801623:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	8b 40 08             	mov    0x8(%eax),%eax
  80162c:	eb 05                	jmp    801633 <malloc+0x79>
	}

    return NULL;
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	68 84 3e 80 00       	push   $0x803e84
  801643:	6a 6f                	push   $0x6f
  801645:	68 53 3e 80 00       	push   $0x803e53
  80164a:	e8 2f ed ff ff       	call   80037e <_panic>

0080164f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 38             	sub    $0x38,%esp
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165b:	e8 5c fd ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  801660:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801664:	75 0a                	jne    801670 <smalloc+0x21>
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	e9 8b 00 00 00       	jmp    8016fb <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801670:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	48                   	dec    %eax
  801680:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	f7 75 f0             	divl   -0x10(%ebp)
  80168e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801691:	29 d0                	sub    %edx,%eax
  801693:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801696:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80169d:	e8 d0 06 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a2:	85 c0                	test   %eax,%eax
  8016a4:	74 11                	je     8016b7 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016a6:	83 ec 0c             	sub    $0xc,%esp
  8016a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ac:	e8 3b 0d 00 00       	call   8023ec <alloc_block_FF>
  8016b1:	83 c4 10             	add    $0x10,%esp
  8016b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016bb:	74 39                	je     8016f6 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	8b 40 08             	mov    0x8(%eax),%eax
  8016c3:	89 c2                	mov    %eax,%edx
  8016c5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016c9:	52                   	push   %edx
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	ff 75 08             	pushl  0x8(%ebp)
  8016d1:	e8 21 04 00 00       	call   801af7 <sys_createSharedObject>
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016dc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016e0:	74 14                	je     8016f6 <smalloc+0xa7>
  8016e2:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016e6:	74 0e                	je     8016f6 <smalloc+0xa7>
  8016e8:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016ec:	74 08                	je     8016f6 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f1:	8b 40 08             	mov    0x8(%eax),%eax
  8016f4:	eb 05                	jmp    8016fb <smalloc+0xac>
	}
	return NULL;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801703:	e8 b4 fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801708:	83 ec 08             	sub    $0x8,%esp
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 0b 04 00 00       	call   801b21 <sys_getSizeOfSharedObject>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80171c:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801720:	74 76                	je     801798 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801722:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801729:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80172c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172f:	01 d0                	add    %edx,%eax
  801731:	48                   	dec    %eax
  801732:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801735:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801738:	ba 00 00 00 00       	mov    $0x0,%edx
  80173d:	f7 75 ec             	divl   -0x14(%ebp)
  801740:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801743:	29 d0                	sub    %edx,%eax
  801745:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80174f:	e8 1e 06 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801754:	85 c0                	test   %eax,%eax
  801756:	74 11                	je     801769 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801758:	83 ec 0c             	sub    $0xc,%esp
  80175b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80175e:	e8 89 0c 00 00       	call   8023ec <alloc_block_FF>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80176d:	74 29                	je     801798 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801772:	8b 40 08             	mov    0x8(%eax),%eax
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	50                   	push   %eax
  801779:	ff 75 0c             	pushl  0xc(%ebp)
  80177c:	ff 75 08             	pushl  0x8(%ebp)
  80177f:	e8 ba 03 00 00       	call   801b3e <sys_getSharedObject>
  801784:	83 c4 10             	add    $0x10,%esp
  801787:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80178a:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80178e:	74 08                	je     801798 <sget+0x9b>
				return (void *)mem_block->sva;
  801790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801793:	8b 40 08             	mov    0x8(%eax),%eax
  801796:	eb 05                	jmp    80179d <sget+0xa0>
		}
	}
	return (void *)NULL;
  801798:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a5:	e8 12 fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 a8 3e 80 00       	push   $0x803ea8
  8017b2:	68 f1 00 00 00       	push   $0xf1
  8017b7:	68 53 3e 80 00       	push   $0x803e53
  8017bc:	e8 bd eb ff ff       	call   80037e <_panic>

008017c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 d0 3e 80 00       	push   $0x803ed0
  8017cf:	68 05 01 00 00       	push   $0x105
  8017d4:	68 53 3e 80 00       	push   $0x803e53
  8017d9:	e8 a0 eb ff ff       	call   80037e <_panic>

008017de <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 f4 3e 80 00       	push   $0x803ef4
  8017ec:	68 10 01 00 00       	push   $0x110
  8017f1:	68 53 3e 80 00       	push   $0x803e53
  8017f6:	e8 83 eb ff ff       	call   80037e <_panic>

008017fb <shrink>:

}
void shrink(uint32 newSize)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 f4 3e 80 00       	push   $0x803ef4
  801809:	68 15 01 00 00       	push   $0x115
  80180e:	68 53 3e 80 00       	push   $0x803e53
  801813:	e8 66 eb ff ff       	call   80037e <_panic>

00801818 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 f4 3e 80 00       	push   $0x803ef4
  801826:	68 1a 01 00 00       	push   $0x11a
  80182b:	68 53 3e 80 00       	push   $0x803e53
  801830:	e8 49 eb ff ff       	call   80037e <_panic>

00801835 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	57                   	push   %edi
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801847:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801850:	cd 30                	int    $0x30
  801852:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5f                   	pop    %edi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
  801869:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	52                   	push   %edx
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	50                   	push   %eax
  80187c:	6a 00                	push   $0x0
  80187e:	e8 b2 ff ff ff       	call   801835 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_cgetc>:

int
sys_cgetc(void)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 01                	push   $0x1
  801898:	e8 98 ff ff ff       	call   801835 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 05                	push   $0x5
  8018b5:	e8 7b ff ff ff       	call   801835 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
  8018d5:	51                   	push   %ecx
  8018d6:	52                   	push   %edx
  8018d7:	50                   	push   %eax
  8018d8:	6a 06                	push   $0x6
  8018da:	e8 56 ff ff ff       	call   801835 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 07                	push   $0x7
  8018fc:	e8 34 ff ff ff       	call   801835 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 08                	push   $0x8
  801917:	e8 19 ff ff ff       	call   801835 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 09                	push   $0x9
  801930:	e8 00 ff ff ff       	call   801835 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 0a                	push   $0xa
  801949:	e8 e7 fe ff ff       	call   801835 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 0b                	push   $0xb
  801962:	e8 ce fe ff ff       	call   801835 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	6a 0f                	push   $0xf
  80197d:	e8 b3 fe ff ff       	call   801835 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
	return;
  801985:	90                   	nop
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 10                	push   $0x10
  801999:	e8 97 fe ff ff       	call   801835 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 10             	pushl  0x10(%ebp)
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 11                	push   $0x11
  8019b6:	e8 7a fe ff ff       	call   801835 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019be:	90                   	nop
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 0c                	push   $0xc
  8019d0:	e8 60 fe ff ff       	call   801835 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 0d                	push   $0xd
  8019ea:	e8 46 fe ff ff       	call   801835 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 0e                	push   $0xe
  801a03:	e8 2d fe ff ff       	call   801835 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 13                	push   $0x13
  801a1d:	e8 13 fe ff ff       	call   801835 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 14                	push   $0x14
  801a37:	e8 f9 fd ff ff       	call   801835 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	90                   	nop
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	50                   	push   %eax
  801a5b:	6a 15                	push   $0x15
  801a5d:	e8 d3 fd ff ff       	call   801835 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 16                	push   $0x16
  801a77:	e8 b9 fd ff ff       	call   801835 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	90                   	nop
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	6a 17                	push   $0x17
  801a94:	e8 9c fd ff ff       	call   801835 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 1a                	push   $0x1a
  801ab1:	e8 7f fd ff ff       	call   801835 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 18                	push   $0x18
  801ace:	e8 62 fd ff ff       	call   801835 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 19                	push   $0x19
  801aec:	e8 44 fd ff ff       	call   801835 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	8b 45 10             	mov    0x10(%ebp),%eax
  801b00:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b03:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	51                   	push   %ecx
  801b10:	52                   	push   %edx
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	50                   	push   %eax
  801b15:	6a 1b                	push   $0x1b
  801b17:	e8 19 fd ff ff       	call   801835 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 1c                	push   $0x1c
  801b34:	e8 fc fc ff ff       	call   801835 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 1d                	push   $0x1d
  801b53:	e8 dd fc ff ff       	call   801835 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 1e                	push   $0x1e
  801b70:	e8 c0 fc ff ff       	call   801835 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 1f                	push   $0x1f
  801b89:	e8 a7 fc ff ff       	call   801835 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 14             	pushl  0x14(%ebp)
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	6a 20                	push   $0x20
  801ba7:	e8 89 fc ff ff       	call   801835 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	50                   	push   %eax
  801bc0:	6a 21                	push   $0x21
  801bc2:	e8 6e fc ff ff       	call   801835 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 22                	push   $0x22
  801bde:	e8 52 fc ff ff       	call   801835 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 02                	push   $0x2
  801bf7:	e8 39 fc ff ff       	call   801835 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 03                	push   $0x3
  801c10:	e8 20 fc ff ff       	call   801835 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 04                	push   $0x4
  801c29:	e8 07 fc ff ff       	call   801835 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_exit_env>:


void sys_exit_env(void)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 23                	push   $0x23
  801c42:	e8 ee fb ff ff       	call   801835 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c56:	8d 50 04             	lea    0x4(%eax),%edx
  801c59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	6a 24                	push   $0x24
  801c66:	e8 ca fb ff ff       	call   801835 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c77:	89 01                	mov    %eax,(%ecx)
  801c79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	c9                   	leave  
  801c80:	c2 04 00             	ret    $0x4

00801c83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	ff 75 10             	pushl  0x10(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 12                	push   $0x12
  801c95:	e8 9b fb ff ff       	call   801835 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 25                	push   $0x25
  801caf:	e8 81 fb ff ff       	call   801835 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 26                	push   $0x26
  801cd4:	e8 5c fb ff ff       	call   801835 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <rsttst>:
void rsttst()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 28                	push   $0x28
  801cee:	e8 42 fb ff ff       	call   801835 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d05:	8b 55 18             	mov    0x18(%ebp),%edx
  801d08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0c:	52                   	push   %edx
  801d0d:	50                   	push   %eax
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 27                	push   $0x27
  801d19:	e8 17 fb ff ff       	call   801835 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <chktst>:
void chktst(uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 29                	push   $0x29
  801d34:	e8 fc fa ff ff       	call   801835 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <inctst>:

void inctst()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 2a                	push   $0x2a
  801d4e:	e8 e2 fa ff ff       	call   801835 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <gettst>:
uint32 gettst()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 2b                	push   $0x2b
  801d68:	e8 c8 fa ff ff       	call   801835 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 2c                	push   $0x2c
  801d84:	e8 ac fa ff ff       	call   801835 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
  801d8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d93:	75 07                	jne    801d9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d95:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9a:	eb 05                	jmp    801da1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 2c                	push   $0x2c
  801db5:	e8 7b fa ff ff       	call   801835 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
  801dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc4:	75 07                	jne    801dcd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	eb 05                	jmp    801dd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 2c                	push   $0x2c
  801de6:	e8 4a fa ff ff       	call   801835 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
  801dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df5:	75 07                	jne    801dfe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfc:	eb 05                	jmp    801e03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 2c                	push   $0x2c
  801e17:	e8 19 fa ff ff       	call   801835 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
  801e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e26:	75 07                	jne    801e2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e28:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2d:	eb 05                	jmp    801e34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	6a 2d                	push   $0x2d
  801e46:	e8 ea f9 ff ff       	call   801835 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4e:	90                   	nop
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	53                   	push   %ebx
  801e64:	51                   	push   %ecx
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 2e                	push   $0x2e
  801e69:	e8 c7 f9 ff ff       	call   801835 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	52                   	push   %edx
  801e86:	50                   	push   %eax
  801e87:	6a 2f                	push   $0x2f
  801e89:	e8 a7 f9 ff ff       	call   801835 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	68 04 3f 80 00       	push   $0x803f04
  801ea1:	e8 8c e7 ff ff       	call   800632 <cprintf>
  801ea6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	68 30 3f 80 00       	push   $0x803f30
  801eb8:	e8 75 e7 ff ff       	call   800632 <cprintf>
  801ebd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec4:	a1 38 51 80 00       	mov    0x805138,%eax
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecc:	eb 56                	jmp    801f24 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ece:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed2:	74 1c                	je     801ef0 <print_mem_block_lists+0x5d>
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 50 08             	mov    0x8(%eax),%edx
  801eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edd:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee6:	01 c8                	add    %ecx,%eax
  801ee8:	39 c2                	cmp    %eax,%edx
  801eea:	73 04                	jae    801ef0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 50 08             	mov    0x8(%eax),%edx
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  801efc:	01 c2                	add    %eax,%edx
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	8b 40 08             	mov    0x8(%eax),%eax
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	52                   	push   %edx
  801f08:	50                   	push   %eax
  801f09:	68 45 3f 80 00       	push   $0x803f45
  801f0e:	e8 1f e7 ff ff       	call   800632 <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1c:	a1 40 51 80 00       	mov    0x805140,%eax
  801f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f28:	74 07                	je     801f31 <print_mem_block_lists+0x9e>
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	eb 05                	jmp    801f36 <print_mem_block_lists+0xa3>
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	a3 40 51 80 00       	mov    %eax,0x805140
  801f3b:	a1 40 51 80 00       	mov    0x805140,%eax
  801f40:	85 c0                	test   %eax,%eax
  801f42:	75 8a                	jne    801ece <print_mem_block_lists+0x3b>
  801f44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f48:	75 84                	jne    801ece <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f4a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4e:	75 10                	jne    801f60 <print_mem_block_lists+0xcd>
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	68 54 3f 80 00       	push   $0x803f54
  801f58:	e8 d5 e6 ff ff       	call   800632 <cprintf>
  801f5d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	68 78 3f 80 00       	push   $0x803f78
  801f6f:	e8 be e6 ff ff       	call   800632 <cprintf>
  801f74:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f77:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7b:	a1 40 50 80 00       	mov    0x805040,%eax
  801f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f83:	eb 56                	jmp    801fdb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f89:	74 1c                	je     801fa7 <print_mem_block_lists+0x114>
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 50 08             	mov    0x8(%eax),%edx
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	8b 48 08             	mov    0x8(%eax),%ecx
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9d:	01 c8                	add    %ecx,%eax
  801f9f:	39 c2                	cmp    %eax,%edx
  801fa1:	73 04                	jae    801fa7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 50 08             	mov    0x8(%eax),%edx
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb3:	01 c2                	add    %eax,%edx
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 40 08             	mov    0x8(%eax),%eax
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	68 45 3f 80 00       	push   $0x803f45
  801fc5:	e8 68 e6 ff ff       	call   800632 <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd3:	a1 48 50 80 00       	mov    0x805048,%eax
  801fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdf:	74 07                	je     801fe8 <print_mem_block_lists+0x155>
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	eb 05                	jmp    801fed <print_mem_block_lists+0x15a>
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	a3 48 50 80 00       	mov    %eax,0x805048
  801ff2:	a1 48 50 80 00       	mov    0x805048,%eax
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	75 8a                	jne    801f85 <print_mem_block_lists+0xf2>
  801ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fff:	75 84                	jne    801f85 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802001:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802005:	75 10                	jne    802017 <print_mem_block_lists+0x184>
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	68 90 3f 80 00       	push   $0x803f90
  80200f:	e8 1e e6 ff ff       	call   800632 <cprintf>
  802014:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	68 04 3f 80 00       	push   $0x803f04
  80201f:	e8 0e e6 ff ff       	call   800632 <cprintf>
  802024:	83 c4 10             	add    $0x10,%esp

}
  802027:	90                   	nop
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802030:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802037:	00 00 00 
  80203a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802041:	00 00 00 
  802044:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80204b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80204e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802055:	e9 9e 00 00 00       	jmp    8020f8 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80205a:	a1 50 50 80 00       	mov    0x805050,%eax
  80205f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802062:	c1 e2 04             	shl    $0x4,%edx
  802065:	01 d0                	add    %edx,%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	75 14                	jne    80207f <initialize_MemBlocksList+0x55>
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 b8 3f 80 00       	push   $0x803fb8
  802073:	6a 46                	push   $0x46
  802075:	68 db 3f 80 00       	push   $0x803fdb
  80207a:	e8 ff e2 ff ff       	call   80037e <_panic>
  80207f:	a1 50 50 80 00       	mov    0x805050,%eax
  802084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802087:	c1 e2 04             	shl    $0x4,%edx
  80208a:	01 d0                	add    %edx,%eax
  80208c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802092:	89 10                	mov    %edx,(%eax)
  802094:	8b 00                	mov    (%eax),%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	74 18                	je     8020b2 <initialize_MemBlocksList+0x88>
  80209a:	a1 48 51 80 00       	mov    0x805148,%eax
  80209f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020a8:	c1 e1 04             	shl    $0x4,%ecx
  8020ab:	01 ca                	add    %ecx,%edx
  8020ad:	89 50 04             	mov    %edx,0x4(%eax)
  8020b0:	eb 12                	jmp    8020c4 <initialize_MemBlocksList+0x9a>
  8020b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ba:	c1 e2 04             	shl    $0x4,%edx
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cc:	c1 e2 04             	shl    $0x4,%edx
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8020d6:	a1 50 50 80 00       	mov    0x805050,%eax
  8020db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020de:	c1 e2 04             	shl    $0x4,%edx
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8020ef:	40                   	inc    %eax
  8020f0:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020f5:	ff 45 f4             	incl   -0xc(%ebp)
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020fe:	0f 82 56 ff ff ff    	jb     80205a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802104:	90                   	nop
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802115:	eb 19                	jmp    802130 <find_block+0x29>
	{
		if(va==point->sva)
  802117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211a:	8b 40 08             	mov    0x8(%eax),%eax
  80211d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802120:	75 05                	jne    802127 <find_block+0x20>
		   return point;
  802122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802125:	eb 36                	jmp    80215d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	8b 40 08             	mov    0x8(%eax),%eax
  80212d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802130:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802134:	74 07                	je     80213d <find_block+0x36>
  802136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802139:	8b 00                	mov    (%eax),%eax
  80213b:	eb 05                	jmp    802142 <find_block+0x3b>
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
  802142:	8b 55 08             	mov    0x8(%ebp),%edx
  802145:	89 42 08             	mov    %eax,0x8(%edx)
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8b 40 08             	mov    0x8(%eax),%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 c5                	jne    802117 <find_block+0x10>
  802152:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802156:	75 bf                	jne    802117 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802165:	a1 40 50 80 00       	mov    0x805040,%eax
  80216a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80216d:	a1 44 50 80 00       	mov    0x805044,%eax
  802172:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802178:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80217b:	74 24                	je     8021a1 <insert_sorted_allocList+0x42>
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802186:	8b 40 08             	mov    0x8(%eax),%eax
  802189:	39 c2                	cmp    %eax,%edx
  80218b:	76 14                	jbe    8021a1 <insert_sorted_allocList+0x42>
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8b 50 08             	mov    0x8(%eax),%edx
  802193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802196:	8b 40 08             	mov    0x8(%eax),%eax
  802199:	39 c2                	cmp    %eax,%edx
  80219b:	0f 82 60 01 00 00    	jb     802301 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a5:	75 65                	jne    80220c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ab:	75 14                	jne    8021c1 <insert_sorted_allocList+0x62>
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	68 b8 3f 80 00       	push   $0x803fb8
  8021b5:	6a 6b                	push   $0x6b
  8021b7:	68 db 3f 80 00       	push   $0x803fdb
  8021bc:	e8 bd e1 ff ff       	call   80037e <_panic>
  8021c1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	89 10                	mov    %edx,(%eax)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 00                	mov    (%eax),%eax
  8021d1:	85 c0                	test   %eax,%eax
  8021d3:	74 0d                	je     8021e2 <insert_sorted_allocList+0x83>
  8021d5:	a1 40 50 80 00       	mov    0x805040,%eax
  8021da:	8b 55 08             	mov    0x8(%ebp),%edx
  8021dd:	89 50 04             	mov    %edx,0x4(%eax)
  8021e0:	eb 08                	jmp    8021ea <insert_sorted_allocList+0x8b>
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	a3 44 50 80 00       	mov    %eax,0x805044
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	a3 40 50 80 00       	mov    %eax,0x805040
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021fc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802201:	40                   	inc    %eax
  802202:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802207:	e9 dc 01 00 00       	jmp    8023e8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 50 08             	mov    0x8(%eax),%edx
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	8b 40 08             	mov    0x8(%eax),%eax
  802218:	39 c2                	cmp    %eax,%edx
  80221a:	77 6c                	ja     802288 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80221c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802220:	74 06                	je     802228 <insert_sorted_allocList+0xc9>
  802222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802226:	75 14                	jne    80223c <insert_sorted_allocList+0xdd>
  802228:	83 ec 04             	sub    $0x4,%esp
  80222b:	68 f4 3f 80 00       	push   $0x803ff4
  802230:	6a 6f                	push   $0x6f
  802232:	68 db 3f 80 00       	push   $0x803fdb
  802237:	e8 42 e1 ff ff       	call   80037e <_panic>
  80223c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223f:	8b 50 04             	mov    0x4(%eax),%edx
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	89 50 04             	mov    %edx,0x4(%eax)
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224e:	89 10                	mov    %edx,(%eax)
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	8b 40 04             	mov    0x4(%eax),%eax
  802256:	85 c0                	test   %eax,%eax
  802258:	74 0d                	je     802267 <insert_sorted_allocList+0x108>
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225d:	8b 40 04             	mov    0x4(%eax),%eax
  802260:	8b 55 08             	mov    0x8(%ebp),%edx
  802263:	89 10                	mov    %edx,(%eax)
  802265:	eb 08                	jmp    80226f <insert_sorted_allocList+0x110>
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	a3 40 50 80 00       	mov    %eax,0x805040
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	8b 55 08             	mov    0x8(%ebp),%edx
  802275:	89 50 04             	mov    %edx,0x4(%eax)
  802278:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80227d:	40                   	inc    %eax
  80227e:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802283:	e9 60 01 00 00       	jmp    8023e8 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	8b 50 08             	mov    0x8(%eax),%edx
  80228e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802291:	8b 40 08             	mov    0x8(%eax),%eax
  802294:	39 c2                	cmp    %eax,%edx
  802296:	0f 82 4c 01 00 00    	jb     8023e8 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80229c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a0:	75 14                	jne    8022b6 <insert_sorted_allocList+0x157>
  8022a2:	83 ec 04             	sub    $0x4,%esp
  8022a5:	68 2c 40 80 00       	push   $0x80402c
  8022aa:	6a 73                	push   $0x73
  8022ac:	68 db 3f 80 00       	push   $0x803fdb
  8022b1:	e8 c8 e0 ff ff       	call   80037e <_panic>
  8022b6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 0c                	je     8022d8 <insert_sorted_allocList+0x179>
  8022cc:	a1 44 50 80 00       	mov    0x805044,%eax
  8022d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	eb 08                	jmp    8022e0 <insert_sorted_allocList+0x181>
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	a3 40 50 80 00       	mov    %eax,0x805040
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 44 50 80 00       	mov    %eax,0x805044
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022f6:	40                   	inc    %eax
  8022f7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022fc:	e9 e7 00 00 00       	jmp    8023e8 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802307:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80230e:	a1 40 50 80 00       	mov    0x805040,%eax
  802313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802316:	e9 9d 00 00 00       	jmp    8023b8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8b 50 08             	mov    0x8(%eax),%edx
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 08             	mov    0x8(%eax),%eax
  80232f:	39 c2                	cmp    %eax,%edx
  802331:	76 7d                	jbe    8023b0 <insert_sorted_allocList+0x251>
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	8b 50 08             	mov    0x8(%eax),%edx
  802339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80233c:	8b 40 08             	mov    0x8(%eax),%eax
  80233f:	39 c2                	cmp    %eax,%edx
  802341:	73 6d                	jae    8023b0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802347:	74 06                	je     80234f <insert_sorted_allocList+0x1f0>
  802349:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234d:	75 14                	jne    802363 <insert_sorted_allocList+0x204>
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	68 50 40 80 00       	push   $0x804050
  802357:	6a 7f                	push   $0x7f
  802359:	68 db 3f 80 00       	push   $0x803fdb
  80235e:	e8 1b e0 ff ff       	call   80037e <_panic>
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	8b 10                	mov    (%eax),%edx
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	89 10                	mov    %edx,(%eax)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 0b                	je     802381 <insert_sorted_allocList+0x222>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	8b 55 08             	mov    0x8(%ebp),%edx
  80237e:	89 50 04             	mov    %edx,0x4(%eax)
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 55 08             	mov    0x8(%ebp),%edx
  802387:	89 10                	mov    %edx,(%eax)
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238f:	89 50 04             	mov    %edx,0x4(%eax)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	75 08                	jne    8023a3 <insert_sorted_allocList+0x244>
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 44 50 80 00       	mov    %eax,0x805044
  8023a3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023a8:	40                   	inc    %eax
  8023a9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023ae:	eb 39                	jmp    8023e9 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023b0:	a1 48 50 80 00       	mov    0x805048,%eax
  8023b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bc:	74 07                	je     8023c5 <insert_sorted_allocList+0x266>
  8023be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	eb 05                	jmp    8023ca <insert_sorted_allocList+0x26b>
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ca:	a3 48 50 80 00       	mov    %eax,0x805048
  8023cf:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d4:	85 c0                	test   %eax,%eax
  8023d6:	0f 85 3f ff ff ff    	jne    80231b <insert_sorted_allocList+0x1bc>
  8023dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e0:	0f 85 35 ff ff ff    	jne    80231b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023e6:	eb 01                	jmp    8023e9 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023e8:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023e9:	90                   	nop
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fa:	e9 85 01 00 00       	jmp    802584 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 40 0c             	mov    0xc(%eax),%eax
  802405:	3b 45 08             	cmp    0x8(%ebp),%eax
  802408:	0f 82 6e 01 00 00    	jb     80257c <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 40 0c             	mov    0xc(%eax),%eax
  802414:	3b 45 08             	cmp    0x8(%ebp),%eax
  802417:	0f 85 8a 00 00 00    	jne    8024a7 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80241d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802421:	75 17                	jne    80243a <alloc_block_FF+0x4e>
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	68 84 40 80 00       	push   $0x804084
  80242b:	68 93 00 00 00       	push   $0x93
  802430:	68 db 3f 80 00       	push   $0x803fdb
  802435:	e8 44 df ff ff       	call   80037e <_panic>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 10                	je     802453 <alloc_block_FF+0x67>
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 00                	mov    (%eax),%eax
  802448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244b:	8b 52 04             	mov    0x4(%edx),%edx
  80244e:	89 50 04             	mov    %edx,0x4(%eax)
  802451:	eb 0b                	jmp    80245e <alloc_block_FF+0x72>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 40 04             	mov    0x4(%eax),%eax
  802459:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	74 0f                	je     802477 <alloc_block_FF+0x8b>
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 40 04             	mov    0x4(%eax),%eax
  80246e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802471:	8b 12                	mov    (%edx),%edx
  802473:	89 10                	mov    %edx,(%eax)
  802475:	eb 0a                	jmp    802481 <alloc_block_FF+0x95>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 00                	mov    (%eax),%eax
  80247c:	a3 38 51 80 00       	mov    %eax,0x805138
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802494:	a1 44 51 80 00       	mov    0x805144,%eax
  802499:	48                   	dec    %eax
  80249a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	e9 10 01 00 00       	jmp    8025b7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b0:	0f 86 c6 00 00 00    	jbe    80257c <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024b6:	a1 48 51 80 00       	mov    0x805148,%eax
  8024bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 50 08             	mov    0x8(%eax),%edx
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c7:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d0:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024d7:	75 17                	jne    8024f0 <alloc_block_FF+0x104>
  8024d9:	83 ec 04             	sub    $0x4,%esp
  8024dc:	68 84 40 80 00       	push   $0x804084
  8024e1:	68 9b 00 00 00       	push   $0x9b
  8024e6:	68 db 3f 80 00       	push   $0x803fdb
  8024eb:	e8 8e de ff ff       	call   80037e <_panic>
  8024f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f3:	8b 00                	mov    (%eax),%eax
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	74 10                	je     802509 <alloc_block_FF+0x11d>
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 00                	mov    (%eax),%eax
  8024fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802501:	8b 52 04             	mov    0x4(%edx),%edx
  802504:	89 50 04             	mov    %edx,0x4(%eax)
  802507:	eb 0b                	jmp    802514 <alloc_block_FF+0x128>
  802509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	8b 40 04             	mov    0x4(%eax),%eax
  80251a:	85 c0                	test   %eax,%eax
  80251c:	74 0f                	je     80252d <alloc_block_FF+0x141>
  80251e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802521:	8b 40 04             	mov    0x4(%eax),%eax
  802524:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802527:	8b 12                	mov    (%edx),%edx
  802529:	89 10                	mov    %edx,(%eax)
  80252b:	eb 0a                	jmp    802537 <alloc_block_FF+0x14b>
  80252d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	a3 48 51 80 00       	mov    %eax,0x805148
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254a:	a1 54 51 80 00       	mov    0x805154,%eax
  80254f:	48                   	dec    %eax
  802550:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 50 08             	mov    0x8(%eax),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	01 c2                	add    %eax,%edx
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 0c             	mov    0xc(%eax),%eax
  80256c:	2b 45 08             	sub    0x8(%ebp),%eax
  80256f:	89 c2                	mov    %eax,%edx
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	eb 3b                	jmp    8025b7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80257c:	a1 40 51 80 00       	mov    0x805140,%eax
  802581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802588:	74 07                	je     802591 <alloc_block_FF+0x1a5>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 00                	mov    (%eax),%eax
  80258f:	eb 05                	jmp    802596 <alloc_block_FF+0x1aa>
  802591:	b8 00 00 00 00       	mov    $0x0,%eax
  802596:	a3 40 51 80 00       	mov    %eax,0x805140
  80259b:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	0f 85 57 fe ff ff    	jne    8023ff <alloc_block_FF+0x13>
  8025a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ac:	0f 85 4d fe ff ff    	jne    8023ff <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
  8025bc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025bf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ce:	e9 df 00 00 00       	jmp    8026b2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025dc:	0f 82 c8 00 00 00    	jb     8026aa <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025eb:	0f 85 8a 00 00 00    	jne    80267b <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	75 17                	jne    80260e <alloc_block_BF+0x55>
  8025f7:	83 ec 04             	sub    $0x4,%esp
  8025fa:	68 84 40 80 00       	push   $0x804084
  8025ff:	68 b7 00 00 00       	push   $0xb7
  802604:	68 db 3f 80 00       	push   $0x803fdb
  802609:	e8 70 dd ff ff       	call   80037e <_panic>
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 00                	mov    (%eax),%eax
  802613:	85 c0                	test   %eax,%eax
  802615:	74 10                	je     802627 <alloc_block_BF+0x6e>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261f:	8b 52 04             	mov    0x4(%edx),%edx
  802622:	89 50 04             	mov    %edx,0x4(%eax)
  802625:	eb 0b                	jmp    802632 <alloc_block_BF+0x79>
  802627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262a:	8b 40 04             	mov    0x4(%eax),%eax
  80262d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 04             	mov    0x4(%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 0f                	je     80264b <alloc_block_BF+0x92>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802645:	8b 12                	mov    (%edx),%edx
  802647:	89 10                	mov    %edx,(%eax)
  802649:	eb 0a                	jmp    802655 <alloc_block_BF+0x9c>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	a3 38 51 80 00       	mov    %eax,0x805138
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802668:	a1 44 51 80 00       	mov    0x805144,%eax
  80266d:	48                   	dec    %eax
  80266e:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	e9 4d 01 00 00       	jmp    8027c8 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 0c             	mov    0xc(%eax),%eax
  802681:	3b 45 08             	cmp    0x8(%ebp),%eax
  802684:	76 24                	jbe    8026aa <alloc_block_BF+0xf1>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 0c             	mov    0xc(%eax),%eax
  80268c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80268f:	73 19                	jae    8026aa <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802691:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	8b 40 0c             	mov    0xc(%eax),%eax
  80269e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 40 08             	mov    0x8(%eax),%eax
  8026a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8026af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b6:	74 07                	je     8026bf <alloc_block_BF+0x106>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	eb 05                	jmp    8026c4 <alloc_block_BF+0x10b>
  8026bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8026c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	0f 85 fd fe ff ff    	jne    8025d3 <alloc_block_BF+0x1a>
  8026d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026da:	0f 85 f3 fe ff ff    	jne    8025d3 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026e4:	0f 84 d9 00 00 00    	je     8027c3 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026ea:	a1 48 51 80 00       	mov    0x805148,%eax
  8026ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f8:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802701:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802704:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802708:	75 17                	jne    802721 <alloc_block_BF+0x168>
  80270a:	83 ec 04             	sub    $0x4,%esp
  80270d:	68 84 40 80 00       	push   $0x804084
  802712:	68 c7 00 00 00       	push   $0xc7
  802717:	68 db 3f 80 00       	push   $0x803fdb
  80271c:	e8 5d dc ff ff       	call   80037e <_panic>
  802721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	74 10                	je     80273a <alloc_block_BF+0x181>
  80272a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802732:	8b 52 04             	mov    0x4(%edx),%edx
  802735:	89 50 04             	mov    %edx,0x4(%eax)
  802738:	eb 0b                	jmp    802745 <alloc_block_BF+0x18c>
  80273a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273d:	8b 40 04             	mov    0x4(%eax),%eax
  802740:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 0f                	je     80275e <alloc_block_BF+0x1a5>
  80274f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802752:	8b 40 04             	mov    0x4(%eax),%eax
  802755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802758:	8b 12                	mov    (%edx),%edx
  80275a:	89 10                	mov    %edx,(%eax)
  80275c:	eb 0a                	jmp    802768 <alloc_block_BF+0x1af>
  80275e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	a3 48 51 80 00       	mov    %eax,0x805148
  802768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802771:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802774:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277b:	a1 54 51 80 00       	mov    0x805154,%eax
  802780:	48                   	dec    %eax
  802781:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802786:	83 ec 08             	sub    $0x8,%esp
  802789:	ff 75 ec             	pushl  -0x14(%ebp)
  80278c:	68 38 51 80 00       	push   $0x805138
  802791:	e8 71 f9 ff ff       	call   802107 <find_block>
  802796:	83 c4 10             	add    $0x10,%esp
  802799:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80279c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279f:	8b 50 08             	mov    0x8(%eax),%edx
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	01 c2                	add    %eax,%edx
  8027a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027aa:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b3:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b6:	89 c2                	mov    %eax,%edx
  8027b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bb:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c1:	eb 05                	jmp    8027c8 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027d0:	a1 28 50 80 00       	mov    0x805028,%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	0f 85 de 01 00 00    	jne    8029bb <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8027e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e5:	e9 9e 01 00 00       	jmp    802988 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f3:	0f 82 87 01 00 00    	jb     802980 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802802:	0f 85 95 00 00 00    	jne    80289d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802808:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280c:	75 17                	jne    802825 <alloc_block_NF+0x5b>
  80280e:	83 ec 04             	sub    $0x4,%esp
  802811:	68 84 40 80 00       	push   $0x804084
  802816:	68 e0 00 00 00       	push   $0xe0
  80281b:	68 db 3f 80 00       	push   $0x803fdb
  802820:	e8 59 db ff ff       	call   80037e <_panic>
  802825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802828:	8b 00                	mov    (%eax),%eax
  80282a:	85 c0                	test   %eax,%eax
  80282c:	74 10                	je     80283e <alloc_block_NF+0x74>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802836:	8b 52 04             	mov    0x4(%edx),%edx
  802839:	89 50 04             	mov    %edx,0x4(%eax)
  80283c:	eb 0b                	jmp    802849 <alloc_block_NF+0x7f>
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0f                	je     802862 <alloc_block_NF+0x98>
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 40 04             	mov    0x4(%eax),%eax
  802859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285c:	8b 12                	mov    (%edx),%edx
  80285e:	89 10                	mov    %edx,(%eax)
  802860:	eb 0a                	jmp    80286c <alloc_block_NF+0xa2>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 00                	mov    (%eax),%eax
  802867:	a3 38 51 80 00       	mov    %eax,0x805138
  80286c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287f:	a1 44 51 80 00       	mov    0x805144,%eax
  802884:	48                   	dec    %eax
  802885:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 40 08             	mov    0x8(%eax),%eax
  802890:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	e9 f8 04 00 00       	jmp    802d95 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a6:	0f 86 d4 00 00 00    	jbe    802980 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8028b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c6:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cd:	75 17                	jne    8028e6 <alloc_block_NF+0x11c>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 84 40 80 00       	push   $0x804084
  8028d7:	68 e9 00 00 00       	push   $0xe9
  8028dc:	68 db 3f 80 00       	push   $0x803fdb
  8028e1:	e8 98 da ff ff       	call   80037e <_panic>
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 10                	je     8028ff <alloc_block_NF+0x135>
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f7:	8b 52 04             	mov    0x4(%edx),%edx
  8028fa:	89 50 04             	mov    %edx,0x4(%eax)
  8028fd:	eb 0b                	jmp    80290a <alloc_block_NF+0x140>
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	8b 40 04             	mov    0x4(%eax),%eax
  802910:	85 c0                	test   %eax,%eax
  802912:	74 0f                	je     802923 <alloc_block_NF+0x159>
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	8b 40 04             	mov    0x4(%eax),%eax
  80291a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291d:	8b 12                	mov    (%edx),%edx
  80291f:	89 10                	mov    %edx,(%eax)
  802921:	eb 0a                	jmp    80292d <alloc_block_NF+0x163>
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	a3 48 51 80 00       	mov    %eax,0x805148
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802940:	a1 54 51 80 00       	mov    0x805154,%eax
  802945:	48                   	dec    %eax
  802946:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80294b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294e:	8b 40 08             	mov    0x8(%eax),%eax
  802951:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 50 08             	mov    0x8(%eax),%edx
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	01 c2                	add    %eax,%edx
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 40 0c             	mov    0xc(%eax),%eax
  80296d:	2b 45 08             	sub    0x8(%ebp),%eax
  802970:	89 c2                	mov    %eax,%edx
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297b:	e9 15 04 00 00       	jmp    802d95 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802980:	a1 40 51 80 00       	mov    0x805140,%eax
  802985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802988:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298c:	74 07                	je     802995 <alloc_block_NF+0x1cb>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	eb 05                	jmp    80299a <alloc_block_NF+0x1d0>
  802995:	b8 00 00 00 00       	mov    $0x0,%eax
  80299a:	a3 40 51 80 00       	mov    %eax,0x805140
  80299f:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	0f 85 3e fe ff ff    	jne    8027ea <alloc_block_NF+0x20>
  8029ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b0:	0f 85 34 fe ff ff    	jne    8027ea <alloc_block_NF+0x20>
  8029b6:	e9 d5 03 00 00       	jmp    802d90 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c3:	e9 b1 01 00 00       	jmp    802b79 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ce:	a1 28 50 80 00       	mov    0x805028,%eax
  8029d3:	39 c2                	cmp    %eax,%edx
  8029d5:	0f 82 96 01 00 00    	jb     802b71 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e4:	0f 82 87 01 00 00    	jb     802b71 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f3:	0f 85 95 00 00 00    	jne    802a8e <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fd:	75 17                	jne    802a16 <alloc_block_NF+0x24c>
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	68 84 40 80 00       	push   $0x804084
  802a07:	68 fc 00 00 00       	push   $0xfc
  802a0c:	68 db 3f 80 00       	push   $0x803fdb
  802a11:	e8 68 d9 ff ff       	call   80037e <_panic>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 10                	je     802a2f <alloc_block_NF+0x265>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a27:	8b 52 04             	mov    0x4(%edx),%edx
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	eb 0b                	jmp    802a3a <alloc_block_NF+0x270>
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 0f                	je     802a53 <alloc_block_NF+0x289>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4d:	8b 12                	mov    (%edx),%edx
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	eb 0a                	jmp    802a5d <alloc_block_NF+0x293>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	a3 38 51 80 00       	mov    %eax,0x805138
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a70:	a1 44 51 80 00       	mov    0x805144,%eax
  802a75:	48                   	dec    %eax
  802a76:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	e9 07 03 00 00       	jmp    802d95 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 86 d4 00 00 00    	jbe    802b71 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a9d:	a1 48 51 80 00       	mov    0x805148,%eax
  802aa2:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 50 08             	mov    0x8(%eax),%edx
  802aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aae:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802abe:	75 17                	jne    802ad7 <alloc_block_NF+0x30d>
  802ac0:	83 ec 04             	sub    $0x4,%esp
  802ac3:	68 84 40 80 00       	push   $0x804084
  802ac8:	68 04 01 00 00       	push   $0x104
  802acd:	68 db 3f 80 00       	push   $0x803fdb
  802ad2:	e8 a7 d8 ff ff       	call   80037e <_panic>
  802ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 10                	je     802af0 <alloc_block_NF+0x326>
  802ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ae8:	8b 52 04             	mov    0x4(%edx),%edx
  802aeb:	89 50 04             	mov    %edx,0x4(%eax)
  802aee:	eb 0b                	jmp    802afb <alloc_block_NF+0x331>
  802af0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 0f                	je     802b14 <alloc_block_NF+0x34a>
  802b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b0e:	8b 12                	mov    (%edx),%edx
  802b10:	89 10                	mov    %edx,(%eax)
  802b12:	eb 0a                	jmp    802b1e <alloc_block_NF+0x354>
  802b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	a3 48 51 80 00       	mov    %eax,0x805148
  802b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b31:	a1 54 51 80 00       	mov    0x805154,%eax
  802b36:	48                   	dec    %eax
  802b37:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3f:	8b 40 08             	mov    0x8(%eax),%eax
  802b42:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	01 c2                	add    %eax,%edx
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b61:	89 c2                	mov    %eax,%edx
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6c:	e9 24 02 00 00       	jmp    802d95 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b71:	a1 40 51 80 00       	mov    0x805140,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7d:	74 07                	je     802b86 <alloc_block_NF+0x3bc>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	eb 05                	jmp    802b8b <alloc_block_NF+0x3c1>
  802b86:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8b:	a3 40 51 80 00       	mov    %eax,0x805140
  802b90:	a1 40 51 80 00       	mov    0x805140,%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	0f 85 2b fe ff ff    	jne    8029c8 <alloc_block_NF+0x1fe>
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	0f 85 21 fe ff ff    	jne    8029c8 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ba7:	a1 38 51 80 00       	mov    0x805138,%eax
  802bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802baf:	e9 ae 01 00 00       	jmp    802d62 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 50 08             	mov    0x8(%eax),%edx
  802bba:	a1 28 50 80 00       	mov    0x805028,%eax
  802bbf:	39 c2                	cmp    %eax,%edx
  802bc1:	0f 83 93 01 00 00    	jae    802d5a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bd0:	0f 82 84 01 00 00    	jb     802d5a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdf:	0f 85 95 00 00 00    	jne    802c7a <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802be5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be9:	75 17                	jne    802c02 <alloc_block_NF+0x438>
  802beb:	83 ec 04             	sub    $0x4,%esp
  802bee:	68 84 40 80 00       	push   $0x804084
  802bf3:	68 14 01 00 00       	push   $0x114
  802bf8:	68 db 3f 80 00       	push   $0x803fdb
  802bfd:	e8 7c d7 ff ff       	call   80037e <_panic>
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	85 c0                	test   %eax,%eax
  802c09:	74 10                	je     802c1b <alloc_block_NF+0x451>
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 00                	mov    (%eax),%eax
  802c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c13:	8b 52 04             	mov    0x4(%edx),%edx
  802c16:	89 50 04             	mov    %edx,0x4(%eax)
  802c19:	eb 0b                	jmp    802c26 <alloc_block_NF+0x45c>
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 04             	mov    0x4(%eax),%eax
  802c2c:	85 c0                	test   %eax,%eax
  802c2e:	74 0f                	je     802c3f <alloc_block_NF+0x475>
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 40 04             	mov    0x4(%eax),%eax
  802c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c39:	8b 12                	mov    (%edx),%edx
  802c3b:	89 10                	mov    %edx,(%eax)
  802c3d:	eb 0a                	jmp    802c49 <alloc_block_NF+0x47f>
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	a3 38 51 80 00       	mov    %eax,0x805138
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802c61:	48                   	dec    %eax
  802c62:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 08             	mov    0x8(%eax),%eax
  802c6d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	e9 1b 01 00 00       	jmp    802d95 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c80:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c83:	0f 86 d1 00 00 00    	jbe    802d5a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c89:	a1 48 51 80 00       	mov    0x805148,%eax
  802c8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 50 08             	mov    0x8(%eax),%edx
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ca6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802caa:	75 17                	jne    802cc3 <alloc_block_NF+0x4f9>
  802cac:	83 ec 04             	sub    $0x4,%esp
  802caf:	68 84 40 80 00       	push   $0x804084
  802cb4:	68 1c 01 00 00       	push   $0x11c
  802cb9:	68 db 3f 80 00       	push   $0x803fdb
  802cbe:	e8 bb d6 ff ff       	call   80037e <_panic>
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	8b 00                	mov    (%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	74 10                	je     802cdc <alloc_block_NF+0x512>
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cd4:	8b 52 04             	mov    0x4(%edx),%edx
  802cd7:	89 50 04             	mov    %edx,0x4(%eax)
  802cda:	eb 0b                	jmp    802ce7 <alloc_block_NF+0x51d>
  802cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdf:	8b 40 04             	mov    0x4(%eax),%eax
  802ce2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	85 c0                	test   %eax,%eax
  802cef:	74 0f                	je     802d00 <alloc_block_NF+0x536>
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cfa:	8b 12                	mov    (%edx),%edx
  802cfc:	89 10                	mov    %edx,(%eax)
  802cfe:	eb 0a                	jmp    802d0a <alloc_block_NF+0x540>
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	a3 48 51 80 00       	mov    %eax,0x805148
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d22:	48                   	dec    %eax
  802d23:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	8b 40 08             	mov    0x8(%eax),%eax
  802d2e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 50 08             	mov    0x8(%eax),%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d47:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d4d:	89 c2                	mov    %eax,%edx
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d58:	eb 3b                	jmp    802d95 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d66:	74 07                	je     802d6f <alloc_block_NF+0x5a5>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	eb 05                	jmp    802d74 <alloc_block_NF+0x5aa>
  802d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802d74:	a3 40 51 80 00       	mov    %eax,0x805140
  802d79:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	0f 85 2e fe ff ff    	jne    802bb4 <alloc_block_NF+0x3ea>
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	0f 85 24 fe ff ff    	jne    802bb4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d97:	55                   	push   %ebp
  802d98:	89 e5                	mov    %esp,%ebp
  802d9a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802da5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802daa:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dad:	a1 38 51 80 00       	mov    0x805138,%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 14                	je     802dca <insert_sorted_with_merge_freeList+0x33>
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	8b 50 08             	mov    0x8(%eax),%edx
  802dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbf:	8b 40 08             	mov    0x8(%eax),%eax
  802dc2:	39 c2                	cmp    %eax,%edx
  802dc4:	0f 87 9b 01 00 00    	ja     802f65 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802dca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dce:	75 17                	jne    802de7 <insert_sorted_with_merge_freeList+0x50>
  802dd0:	83 ec 04             	sub    $0x4,%esp
  802dd3:	68 b8 3f 80 00       	push   $0x803fb8
  802dd8:	68 38 01 00 00       	push   $0x138
  802ddd:	68 db 3f 80 00       	push   $0x803fdb
  802de2:	e8 97 d5 ff ff       	call   80037e <_panic>
  802de7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	89 10                	mov    %edx,(%eax)
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 0d                	je     802e08 <insert_sorted_with_merge_freeList+0x71>
  802dfb:	a1 38 51 80 00       	mov    0x805138,%eax
  802e00:	8b 55 08             	mov    0x8(%ebp),%edx
  802e03:	89 50 04             	mov    %edx,0x4(%eax)
  802e06:	eb 08                	jmp    802e10 <insert_sorted_with_merge_freeList+0x79>
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	a3 38 51 80 00       	mov    %eax,0x805138
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e22:	a1 44 51 80 00       	mov    0x805144,%eax
  802e27:	40                   	inc    %eax
  802e28:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e31:	0f 84 a8 06 00 00    	je     8034df <insert_sorted_with_merge_freeList+0x748>
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	8b 50 08             	mov    0x8(%eax),%edx
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	01 c2                	add    %eax,%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 08             	mov    0x8(%eax),%eax
  802e4b:	39 c2                	cmp    %eax,%edx
  802e4d:	0f 85 8c 06 00 00    	jne    8034df <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 50 0c             	mov    0xc(%eax),%edx
  802e59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	01 c2                	add    %eax,%edx
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6b:	75 17                	jne    802e84 <insert_sorted_with_merge_freeList+0xed>
  802e6d:	83 ec 04             	sub    $0x4,%esp
  802e70:	68 84 40 80 00       	push   $0x804084
  802e75:	68 3c 01 00 00       	push   $0x13c
  802e7a:	68 db 3f 80 00       	push   $0x803fdb
  802e7f:	e8 fa d4 ff ff       	call   80037e <_panic>
  802e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	85 c0                	test   %eax,%eax
  802e8b:	74 10                	je     802e9d <insert_sorted_with_merge_freeList+0x106>
  802e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e95:	8b 52 04             	mov    0x4(%edx),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 0b                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x111>
  802e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea0:	8b 40 04             	mov    0x4(%eax),%eax
  802ea3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	8b 40 04             	mov    0x4(%eax),%eax
  802eae:	85 c0                	test   %eax,%eax
  802eb0:	74 0f                	je     802ec1 <insert_sorted_with_merge_freeList+0x12a>
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	8b 40 04             	mov    0x4(%eax),%eax
  802eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebb:	8b 12                	mov    (%edx),%edx
  802ebd:	89 10                	mov    %edx,(%eax)
  802ebf:	eb 0a                	jmp    802ecb <insert_sorted_with_merge_freeList+0x134>
  802ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec4:	8b 00                	mov    (%eax),%eax
  802ec6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ece:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ede:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee3:	48                   	dec    %eax
  802ee4:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802efd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f01:	75 17                	jne    802f1a <insert_sorted_with_merge_freeList+0x183>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 b8 3f 80 00       	push   $0x803fb8
  802f0b:	68 3f 01 00 00       	push   $0x13f
  802f10:	68 db 3f 80 00       	push   $0x803fdb
  802f15:	e8 64 d4 ff ff       	call   80037e <_panic>
  802f1a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f23:	89 10                	mov    %edx,(%eax)
  802f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 0d                	je     802f3b <insert_sorted_with_merge_freeList+0x1a4>
  802f2e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	eb 08                	jmp    802f43 <insert_sorted_with_merge_freeList+0x1ac>
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f55:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5a:	40                   	inc    %eax
  802f5b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f60:	e9 7a 05 00 00       	jmp    8034df <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	8b 40 08             	mov    0x8(%eax),%eax
  802f71:	39 c2                	cmp    %eax,%edx
  802f73:	0f 82 14 01 00 00    	jb     80308d <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7c:	8b 50 08             	mov    0x8(%eax),%edx
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	8b 40 0c             	mov    0xc(%eax),%eax
  802f85:	01 c2                	add    %eax,%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 40 08             	mov    0x8(%eax),%eax
  802f8d:	39 c2                	cmp    %eax,%edx
  802f8f:	0f 85 90 00 00 00    	jne    803025 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa1:	01 c2                	add    %eax,%edx
  802fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa6:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc1:	75 17                	jne    802fda <insert_sorted_with_merge_freeList+0x243>
  802fc3:	83 ec 04             	sub    $0x4,%esp
  802fc6:	68 b8 3f 80 00       	push   $0x803fb8
  802fcb:	68 49 01 00 00       	push   $0x149
  802fd0:	68 db 3f 80 00       	push   $0x803fdb
  802fd5:	e8 a4 d3 ff ff       	call   80037e <_panic>
  802fda:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	85 c0                	test   %eax,%eax
  802fec:	74 0d                	je     802ffb <insert_sorted_with_merge_freeList+0x264>
  802fee:	a1 48 51 80 00       	mov    0x805148,%eax
  802ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff6:	89 50 04             	mov    %edx,0x4(%eax)
  802ff9:	eb 08                	jmp    803003 <insert_sorted_with_merge_freeList+0x26c>
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	a3 48 51 80 00       	mov    %eax,0x805148
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803015:	a1 54 51 80 00       	mov    0x805154,%eax
  80301a:	40                   	inc    %eax
  80301b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803020:	e9 bb 04 00 00       	jmp    8034e0 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803025:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803029:	75 17                	jne    803042 <insert_sorted_with_merge_freeList+0x2ab>
  80302b:	83 ec 04             	sub    $0x4,%esp
  80302e:	68 2c 40 80 00       	push   $0x80402c
  803033:	68 4c 01 00 00       	push   $0x14c
  803038:	68 db 3f 80 00       	push   $0x803fdb
  80303d:	e8 3c d3 ff ff       	call   80037e <_panic>
  803042:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	89 50 04             	mov    %edx,0x4(%eax)
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 40 04             	mov    0x4(%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0c                	je     803064 <insert_sorted_with_merge_freeList+0x2cd>
  803058:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 10                	mov    %edx,(%eax)
  803062:	eb 08                	jmp    80306c <insert_sorted_with_merge_freeList+0x2d5>
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	a3 38 51 80 00       	mov    %eax,0x805138
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80307d:	a1 44 51 80 00       	mov    0x805144,%eax
  803082:	40                   	inc    %eax
  803083:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803088:	e9 53 04 00 00       	jmp    8034e0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80308d:	a1 38 51 80 00       	mov    0x805138,%eax
  803092:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803095:	e9 15 04 00 00       	jmp    8034af <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 50 08             	mov    0x8(%eax),%edx
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ab:	8b 40 08             	mov    0x8(%eax),%eax
  8030ae:	39 c2                	cmp    %eax,%edx
  8030b0:	0f 86 f1 03 00 00    	jbe    8034a7 <insert_sorted_with_merge_freeList+0x710>
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	8b 50 08             	mov    0x8(%eax),%edx
  8030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	39 c2                	cmp    %eax,%edx
  8030c4:	0f 83 dd 03 00 00    	jae    8034a7 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	8b 50 08             	mov    0x8(%eax),%edx
  8030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d6:	01 c2                	add    %eax,%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 08             	mov    0x8(%eax),%eax
  8030de:	39 c2                	cmp    %eax,%edx
  8030e0:	0f 85 b9 01 00 00    	jne    80329f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	8b 50 08             	mov    0x8(%eax),%edx
  8030ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f2:	01 c2                	add    %eax,%edx
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 08             	mov    0x8(%eax),%eax
  8030fa:	39 c2                	cmp    %eax,%edx
  8030fc:	0f 85 0d 01 00 00    	jne    80320f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 50 0c             	mov    0xc(%eax),%edx
  803108:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310b:	8b 40 0c             	mov    0xc(%eax),%eax
  80310e:	01 c2                	add    %eax,%edx
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803116:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311a:	75 17                	jne    803133 <insert_sorted_with_merge_freeList+0x39c>
  80311c:	83 ec 04             	sub    $0x4,%esp
  80311f:	68 84 40 80 00       	push   $0x804084
  803124:	68 5c 01 00 00       	push   $0x15c
  803129:	68 db 3f 80 00       	push   $0x803fdb
  80312e:	e8 4b d2 ff ff       	call   80037e <_panic>
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 10                	je     80314c <insert_sorted_with_merge_freeList+0x3b5>
  80313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803144:	8b 52 04             	mov    0x4(%edx),%edx
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	eb 0b                	jmp    803157 <insert_sorted_with_merge_freeList+0x3c0>
  80314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314f:	8b 40 04             	mov    0x4(%eax),%eax
  803152:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	8b 40 04             	mov    0x4(%eax),%eax
  80315d:	85 c0                	test   %eax,%eax
  80315f:	74 0f                	je     803170 <insert_sorted_with_merge_freeList+0x3d9>
  803161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803164:	8b 40 04             	mov    0x4(%eax),%eax
  803167:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80316a:	8b 12                	mov    (%edx),%edx
  80316c:	89 10                	mov    %edx,(%eax)
  80316e:	eb 0a                	jmp    80317a <insert_sorted_with_merge_freeList+0x3e3>
  803170:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	a3 38 51 80 00       	mov    %eax,0x805138
  80317a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318d:	a1 44 51 80 00       	mov    0x805144,%eax
  803192:	48                   	dec    %eax
  803193:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b0:	75 17                	jne    8031c9 <insert_sorted_with_merge_freeList+0x432>
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	68 b8 3f 80 00       	push   $0x803fb8
  8031ba:	68 5f 01 00 00       	push   $0x15f
  8031bf:	68 db 3f 80 00       	push   $0x803fdb
  8031c4:	e8 b5 d1 ff ff       	call   80037e <_panic>
  8031c9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	89 10                	mov    %edx,(%eax)
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 0d                	je     8031ea <insert_sorted_with_merge_freeList+0x453>
  8031dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8031e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e5:	89 50 04             	mov    %edx,0x4(%eax)
  8031e8:	eb 08                	jmp    8031f2 <insert_sorted_with_merge_freeList+0x45b>
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803204:	a1 54 51 80 00       	mov    0x805154,%eax
  803209:	40                   	inc    %eax
  80320a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803212:	8b 50 0c             	mov    0xc(%eax),%edx
  803215:	8b 45 08             	mov    0x8(%ebp),%eax
  803218:	8b 40 0c             	mov    0xc(%eax),%eax
  80321b:	01 c2                	add    %eax,%edx
  80321d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803220:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323b:	75 17                	jne    803254 <insert_sorted_with_merge_freeList+0x4bd>
  80323d:	83 ec 04             	sub    $0x4,%esp
  803240:	68 b8 3f 80 00       	push   $0x803fb8
  803245:	68 64 01 00 00       	push   $0x164
  80324a:	68 db 3f 80 00       	push   $0x803fdb
  80324f:	e8 2a d1 ff ff       	call   80037e <_panic>
  803254:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	89 10                	mov    %edx,(%eax)
  80325f:	8b 45 08             	mov    0x8(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	85 c0                	test   %eax,%eax
  803266:	74 0d                	je     803275 <insert_sorted_with_merge_freeList+0x4de>
  803268:	a1 48 51 80 00       	mov    0x805148,%eax
  80326d:	8b 55 08             	mov    0x8(%ebp),%edx
  803270:	89 50 04             	mov    %edx,0x4(%eax)
  803273:	eb 08                	jmp    80327d <insert_sorted_with_merge_freeList+0x4e6>
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	a3 48 51 80 00       	mov    %eax,0x805148
  803285:	8b 45 08             	mov    0x8(%ebp),%eax
  803288:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328f:	a1 54 51 80 00       	mov    0x805154,%eax
  803294:	40                   	inc    %eax
  803295:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80329a:	e9 41 02 00 00       	jmp    8034e0 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	8b 50 08             	mov    0x8(%eax),%edx
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ab:	01 c2                	add    %eax,%edx
  8032ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b0:	8b 40 08             	mov    0x8(%eax),%eax
  8032b3:	39 c2                	cmp    %eax,%edx
  8032b5:	0f 85 7c 01 00 00    	jne    803437 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032bf:	74 06                	je     8032c7 <insert_sorted_with_merge_freeList+0x530>
  8032c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c5:	75 17                	jne    8032de <insert_sorted_with_merge_freeList+0x547>
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	68 f4 3f 80 00       	push   $0x803ff4
  8032cf:	68 69 01 00 00       	push   $0x169
  8032d4:	68 db 3f 80 00       	push   $0x803fdb
  8032d9:	e8 a0 d0 ff ff       	call   80037e <_panic>
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	8b 50 04             	mov    0x4(%eax),%edx
  8032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f0:	89 10                	mov    %edx,(%eax)
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	8b 40 04             	mov    0x4(%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 0d                	je     803309 <insert_sorted_with_merge_freeList+0x572>
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	8b 40 04             	mov    0x4(%eax),%eax
  803302:	8b 55 08             	mov    0x8(%ebp),%edx
  803305:	89 10                	mov    %edx,(%eax)
  803307:	eb 08                	jmp    803311 <insert_sorted_with_merge_freeList+0x57a>
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	a3 38 51 80 00       	mov    %eax,0x805138
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	8b 55 08             	mov    0x8(%ebp),%edx
  803317:	89 50 04             	mov    %edx,0x4(%eax)
  80331a:	a1 44 51 80 00       	mov    0x805144,%eax
  80331f:	40                   	inc    %eax
  803320:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803325:	8b 45 08             	mov    0x8(%ebp),%eax
  803328:	8b 50 0c             	mov    0xc(%eax),%edx
  80332b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332e:	8b 40 0c             	mov    0xc(%eax),%eax
  803331:	01 c2                	add    %eax,%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803339:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80333d:	75 17                	jne    803356 <insert_sorted_with_merge_freeList+0x5bf>
  80333f:	83 ec 04             	sub    $0x4,%esp
  803342:	68 84 40 80 00       	push   $0x804084
  803347:	68 6b 01 00 00       	push   $0x16b
  80334c:	68 db 3f 80 00       	push   $0x803fdb
  803351:	e8 28 d0 ff ff       	call   80037e <_panic>
  803356:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803359:	8b 00                	mov    (%eax),%eax
  80335b:	85 c0                	test   %eax,%eax
  80335d:	74 10                	je     80336f <insert_sorted_with_merge_freeList+0x5d8>
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	8b 00                	mov    (%eax),%eax
  803364:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803367:	8b 52 04             	mov    0x4(%edx),%edx
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	eb 0b                	jmp    80337a <insert_sorted_with_merge_freeList+0x5e3>
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	8b 40 04             	mov    0x4(%eax),%eax
  803375:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	8b 40 04             	mov    0x4(%eax),%eax
  803380:	85 c0                	test   %eax,%eax
  803382:	74 0f                	je     803393 <insert_sorted_with_merge_freeList+0x5fc>
  803384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803387:	8b 40 04             	mov    0x4(%eax),%eax
  80338a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80338d:	8b 12                	mov    (%edx),%edx
  80338f:	89 10                	mov    %edx,(%eax)
  803391:	eb 0a                	jmp    80339d <insert_sorted_with_merge_freeList+0x606>
  803393:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	a3 38 51 80 00       	mov    %eax,0x805138
  80339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033b5:	48                   	dec    %eax
  8033b6:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033d3:	75 17                	jne    8033ec <insert_sorted_with_merge_freeList+0x655>
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	68 b8 3f 80 00       	push   $0x803fb8
  8033dd:	68 6e 01 00 00       	push   $0x16e
  8033e2:	68 db 3f 80 00       	push   $0x803fdb
  8033e7:	e8 92 cf ff ff       	call   80037e <_panic>
  8033ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f5:	89 10                	mov    %edx,(%eax)
  8033f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 0d                	je     80340d <insert_sorted_with_merge_freeList+0x676>
  803400:	a1 48 51 80 00       	mov    0x805148,%eax
  803405:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	eb 08                	jmp    803415 <insert_sorted_with_merge_freeList+0x67e>
  80340d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803410:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803418:	a3 48 51 80 00       	mov    %eax,0x805148
  80341d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803427:	a1 54 51 80 00       	mov    0x805154,%eax
  80342c:	40                   	inc    %eax
  80342d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803432:	e9 a9 00 00 00       	jmp    8034e0 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803437:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343b:	74 06                	je     803443 <insert_sorted_with_merge_freeList+0x6ac>
  80343d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803441:	75 17                	jne    80345a <insert_sorted_with_merge_freeList+0x6c3>
  803443:	83 ec 04             	sub    $0x4,%esp
  803446:	68 50 40 80 00       	push   $0x804050
  80344b:	68 73 01 00 00       	push   $0x173
  803450:	68 db 3f 80 00       	push   $0x803fdb
  803455:	e8 24 cf ff ff       	call   80037e <_panic>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 10                	mov    (%eax),%edx
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	89 10                	mov    %edx,(%eax)
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	85 c0                	test   %eax,%eax
  80346b:	74 0b                	je     803478 <insert_sorted_with_merge_freeList+0x6e1>
  80346d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803470:	8b 00                	mov    (%eax),%eax
  803472:	8b 55 08             	mov    0x8(%ebp),%edx
  803475:	89 50 04             	mov    %edx,0x4(%eax)
  803478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347b:	8b 55 08             	mov    0x8(%ebp),%edx
  80347e:	89 10                	mov    %edx,(%eax)
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803486:	89 50 04             	mov    %edx,0x4(%eax)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	75 08                	jne    80349a <insert_sorted_with_merge_freeList+0x703>
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80349a:	a1 44 51 80 00       	mov    0x805144,%eax
  80349f:	40                   	inc    %eax
  8034a0:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034a5:	eb 39                	jmp    8034e0 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034b3:	74 07                	je     8034bc <insert_sorted_with_merge_freeList+0x725>
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	eb 05                	jmp    8034c1 <insert_sorted_with_merge_freeList+0x72a>
  8034bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8034c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8034c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8034cb:	85 c0                	test   %eax,%eax
  8034cd:	0f 85 c7 fb ff ff    	jne    80309a <insert_sorted_with_merge_freeList+0x303>
  8034d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d7:	0f 85 bd fb ff ff    	jne    80309a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034dd:	eb 01                	jmp    8034e0 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034df:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034e0:	90                   	nop
  8034e1:	c9                   	leave  
  8034e2:	c3                   	ret    
  8034e3:	90                   	nop

008034e4 <__udivdi3>:
  8034e4:	55                   	push   %ebp
  8034e5:	57                   	push   %edi
  8034e6:	56                   	push   %esi
  8034e7:	53                   	push   %ebx
  8034e8:	83 ec 1c             	sub    $0x1c,%esp
  8034eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034fb:	89 ca                	mov    %ecx,%edx
  8034fd:	89 f8                	mov    %edi,%eax
  8034ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803503:	85 f6                	test   %esi,%esi
  803505:	75 2d                	jne    803534 <__udivdi3+0x50>
  803507:	39 cf                	cmp    %ecx,%edi
  803509:	77 65                	ja     803570 <__udivdi3+0x8c>
  80350b:	89 fd                	mov    %edi,%ebp
  80350d:	85 ff                	test   %edi,%edi
  80350f:	75 0b                	jne    80351c <__udivdi3+0x38>
  803511:	b8 01 00 00 00       	mov    $0x1,%eax
  803516:	31 d2                	xor    %edx,%edx
  803518:	f7 f7                	div    %edi
  80351a:	89 c5                	mov    %eax,%ebp
  80351c:	31 d2                	xor    %edx,%edx
  80351e:	89 c8                	mov    %ecx,%eax
  803520:	f7 f5                	div    %ebp
  803522:	89 c1                	mov    %eax,%ecx
  803524:	89 d8                	mov    %ebx,%eax
  803526:	f7 f5                	div    %ebp
  803528:	89 cf                	mov    %ecx,%edi
  80352a:	89 fa                	mov    %edi,%edx
  80352c:	83 c4 1c             	add    $0x1c,%esp
  80352f:	5b                   	pop    %ebx
  803530:	5e                   	pop    %esi
  803531:	5f                   	pop    %edi
  803532:	5d                   	pop    %ebp
  803533:	c3                   	ret    
  803534:	39 ce                	cmp    %ecx,%esi
  803536:	77 28                	ja     803560 <__udivdi3+0x7c>
  803538:	0f bd fe             	bsr    %esi,%edi
  80353b:	83 f7 1f             	xor    $0x1f,%edi
  80353e:	75 40                	jne    803580 <__udivdi3+0x9c>
  803540:	39 ce                	cmp    %ecx,%esi
  803542:	72 0a                	jb     80354e <__udivdi3+0x6a>
  803544:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803548:	0f 87 9e 00 00 00    	ja     8035ec <__udivdi3+0x108>
  80354e:	b8 01 00 00 00       	mov    $0x1,%eax
  803553:	89 fa                	mov    %edi,%edx
  803555:	83 c4 1c             	add    $0x1c,%esp
  803558:	5b                   	pop    %ebx
  803559:	5e                   	pop    %esi
  80355a:	5f                   	pop    %edi
  80355b:	5d                   	pop    %ebp
  80355c:	c3                   	ret    
  80355d:	8d 76 00             	lea    0x0(%esi),%esi
  803560:	31 ff                	xor    %edi,%edi
  803562:	31 c0                	xor    %eax,%eax
  803564:	89 fa                	mov    %edi,%edx
  803566:	83 c4 1c             	add    $0x1c,%esp
  803569:	5b                   	pop    %ebx
  80356a:	5e                   	pop    %esi
  80356b:	5f                   	pop    %edi
  80356c:	5d                   	pop    %ebp
  80356d:	c3                   	ret    
  80356e:	66 90                	xchg   %ax,%ax
  803570:	89 d8                	mov    %ebx,%eax
  803572:	f7 f7                	div    %edi
  803574:	31 ff                	xor    %edi,%edi
  803576:	89 fa                	mov    %edi,%edx
  803578:	83 c4 1c             	add    $0x1c,%esp
  80357b:	5b                   	pop    %ebx
  80357c:	5e                   	pop    %esi
  80357d:	5f                   	pop    %edi
  80357e:	5d                   	pop    %ebp
  80357f:	c3                   	ret    
  803580:	bd 20 00 00 00       	mov    $0x20,%ebp
  803585:	89 eb                	mov    %ebp,%ebx
  803587:	29 fb                	sub    %edi,%ebx
  803589:	89 f9                	mov    %edi,%ecx
  80358b:	d3 e6                	shl    %cl,%esi
  80358d:	89 c5                	mov    %eax,%ebp
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 ed                	shr    %cl,%ebp
  803593:	89 e9                	mov    %ebp,%ecx
  803595:	09 f1                	or     %esi,%ecx
  803597:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80359b:	89 f9                	mov    %edi,%ecx
  80359d:	d3 e0                	shl    %cl,%eax
  80359f:	89 c5                	mov    %eax,%ebp
  8035a1:	89 d6                	mov    %edx,%esi
  8035a3:	88 d9                	mov    %bl,%cl
  8035a5:	d3 ee                	shr    %cl,%esi
  8035a7:	89 f9                	mov    %edi,%ecx
  8035a9:	d3 e2                	shl    %cl,%edx
  8035ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035af:	88 d9                	mov    %bl,%cl
  8035b1:	d3 e8                	shr    %cl,%eax
  8035b3:	09 c2                	or     %eax,%edx
  8035b5:	89 d0                	mov    %edx,%eax
  8035b7:	89 f2                	mov    %esi,%edx
  8035b9:	f7 74 24 0c          	divl   0xc(%esp)
  8035bd:	89 d6                	mov    %edx,%esi
  8035bf:	89 c3                	mov    %eax,%ebx
  8035c1:	f7 e5                	mul    %ebp
  8035c3:	39 d6                	cmp    %edx,%esi
  8035c5:	72 19                	jb     8035e0 <__udivdi3+0xfc>
  8035c7:	74 0b                	je     8035d4 <__udivdi3+0xf0>
  8035c9:	89 d8                	mov    %ebx,%eax
  8035cb:	31 ff                	xor    %edi,%edi
  8035cd:	e9 58 ff ff ff       	jmp    80352a <__udivdi3+0x46>
  8035d2:	66 90                	xchg   %ax,%ax
  8035d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035d8:	89 f9                	mov    %edi,%ecx
  8035da:	d3 e2                	shl    %cl,%edx
  8035dc:	39 c2                	cmp    %eax,%edx
  8035de:	73 e9                	jae    8035c9 <__udivdi3+0xe5>
  8035e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035e3:	31 ff                	xor    %edi,%edi
  8035e5:	e9 40 ff ff ff       	jmp    80352a <__udivdi3+0x46>
  8035ea:	66 90                	xchg   %ax,%ax
  8035ec:	31 c0                	xor    %eax,%eax
  8035ee:	e9 37 ff ff ff       	jmp    80352a <__udivdi3+0x46>
  8035f3:	90                   	nop

008035f4 <__umoddi3>:
  8035f4:	55                   	push   %ebp
  8035f5:	57                   	push   %edi
  8035f6:	56                   	push   %esi
  8035f7:	53                   	push   %ebx
  8035f8:	83 ec 1c             	sub    $0x1c,%esp
  8035fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803603:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803607:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80360b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80360f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803613:	89 f3                	mov    %esi,%ebx
  803615:	89 fa                	mov    %edi,%edx
  803617:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80361b:	89 34 24             	mov    %esi,(%esp)
  80361e:	85 c0                	test   %eax,%eax
  803620:	75 1a                	jne    80363c <__umoddi3+0x48>
  803622:	39 f7                	cmp    %esi,%edi
  803624:	0f 86 a2 00 00 00    	jbe    8036cc <__umoddi3+0xd8>
  80362a:	89 c8                	mov    %ecx,%eax
  80362c:	89 f2                	mov    %esi,%edx
  80362e:	f7 f7                	div    %edi
  803630:	89 d0                	mov    %edx,%eax
  803632:	31 d2                	xor    %edx,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	39 f0                	cmp    %esi,%eax
  80363e:	0f 87 ac 00 00 00    	ja     8036f0 <__umoddi3+0xfc>
  803644:	0f bd e8             	bsr    %eax,%ebp
  803647:	83 f5 1f             	xor    $0x1f,%ebp
  80364a:	0f 84 ac 00 00 00    	je     8036fc <__umoddi3+0x108>
  803650:	bf 20 00 00 00       	mov    $0x20,%edi
  803655:	29 ef                	sub    %ebp,%edi
  803657:	89 fe                	mov    %edi,%esi
  803659:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80365d:	89 e9                	mov    %ebp,%ecx
  80365f:	d3 e0                	shl    %cl,%eax
  803661:	89 d7                	mov    %edx,%edi
  803663:	89 f1                	mov    %esi,%ecx
  803665:	d3 ef                	shr    %cl,%edi
  803667:	09 c7                	or     %eax,%edi
  803669:	89 e9                	mov    %ebp,%ecx
  80366b:	d3 e2                	shl    %cl,%edx
  80366d:	89 14 24             	mov    %edx,(%esp)
  803670:	89 d8                	mov    %ebx,%eax
  803672:	d3 e0                	shl    %cl,%eax
  803674:	89 c2                	mov    %eax,%edx
  803676:	8b 44 24 08          	mov    0x8(%esp),%eax
  80367a:	d3 e0                	shl    %cl,%eax
  80367c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803680:	8b 44 24 08          	mov    0x8(%esp),%eax
  803684:	89 f1                	mov    %esi,%ecx
  803686:	d3 e8                	shr    %cl,%eax
  803688:	09 d0                	or     %edx,%eax
  80368a:	d3 eb                	shr    %cl,%ebx
  80368c:	89 da                	mov    %ebx,%edx
  80368e:	f7 f7                	div    %edi
  803690:	89 d3                	mov    %edx,%ebx
  803692:	f7 24 24             	mull   (%esp)
  803695:	89 c6                	mov    %eax,%esi
  803697:	89 d1                	mov    %edx,%ecx
  803699:	39 d3                	cmp    %edx,%ebx
  80369b:	0f 82 87 00 00 00    	jb     803728 <__umoddi3+0x134>
  8036a1:	0f 84 91 00 00 00    	je     803738 <__umoddi3+0x144>
  8036a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036ab:	29 f2                	sub    %esi,%edx
  8036ad:	19 cb                	sbb    %ecx,%ebx
  8036af:	89 d8                	mov    %ebx,%eax
  8036b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036b5:	d3 e0                	shl    %cl,%eax
  8036b7:	89 e9                	mov    %ebp,%ecx
  8036b9:	d3 ea                	shr    %cl,%edx
  8036bb:	09 d0                	or     %edx,%eax
  8036bd:	89 e9                	mov    %ebp,%ecx
  8036bf:	d3 eb                	shr    %cl,%ebx
  8036c1:	89 da                	mov    %ebx,%edx
  8036c3:	83 c4 1c             	add    $0x1c,%esp
  8036c6:	5b                   	pop    %ebx
  8036c7:	5e                   	pop    %esi
  8036c8:	5f                   	pop    %edi
  8036c9:	5d                   	pop    %ebp
  8036ca:	c3                   	ret    
  8036cb:	90                   	nop
  8036cc:	89 fd                	mov    %edi,%ebp
  8036ce:	85 ff                	test   %edi,%edi
  8036d0:	75 0b                	jne    8036dd <__umoddi3+0xe9>
  8036d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8036d7:	31 d2                	xor    %edx,%edx
  8036d9:	f7 f7                	div    %edi
  8036db:	89 c5                	mov    %eax,%ebp
  8036dd:	89 f0                	mov    %esi,%eax
  8036df:	31 d2                	xor    %edx,%edx
  8036e1:	f7 f5                	div    %ebp
  8036e3:	89 c8                	mov    %ecx,%eax
  8036e5:	f7 f5                	div    %ebp
  8036e7:	89 d0                	mov    %edx,%eax
  8036e9:	e9 44 ff ff ff       	jmp    803632 <__umoddi3+0x3e>
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	89 c8                	mov    %ecx,%eax
  8036f2:	89 f2                	mov    %esi,%edx
  8036f4:	83 c4 1c             	add    $0x1c,%esp
  8036f7:	5b                   	pop    %ebx
  8036f8:	5e                   	pop    %esi
  8036f9:	5f                   	pop    %edi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    
  8036fc:	3b 04 24             	cmp    (%esp),%eax
  8036ff:	72 06                	jb     803707 <__umoddi3+0x113>
  803701:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803705:	77 0f                	ja     803716 <__umoddi3+0x122>
  803707:	89 f2                	mov    %esi,%edx
  803709:	29 f9                	sub    %edi,%ecx
  80370b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80370f:	89 14 24             	mov    %edx,(%esp)
  803712:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803716:	8b 44 24 04          	mov    0x4(%esp),%eax
  80371a:	8b 14 24             	mov    (%esp),%edx
  80371d:	83 c4 1c             	add    $0x1c,%esp
  803720:	5b                   	pop    %ebx
  803721:	5e                   	pop    %esi
  803722:	5f                   	pop    %edi
  803723:	5d                   	pop    %ebp
  803724:	c3                   	ret    
  803725:	8d 76 00             	lea    0x0(%esi),%esi
  803728:	2b 04 24             	sub    (%esp),%eax
  80372b:	19 fa                	sbb    %edi,%edx
  80372d:	89 d1                	mov    %edx,%ecx
  80372f:	89 c6                	mov    %eax,%esi
  803731:	e9 71 ff ff ff       	jmp    8036a7 <__umoddi3+0xb3>
  803736:	66 90                	xchg   %ax,%ax
  803738:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80373c:	72 ea                	jb     803728 <__umoddi3+0x134>
  80373e:	89 d9                	mov    %ebx,%ecx
  803740:	e9 62 ff ff ff       	jmp    8036a7 <__umoddi3+0xb3>
