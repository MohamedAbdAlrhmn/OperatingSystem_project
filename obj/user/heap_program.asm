
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
  800082:	e8 a8 18 00 00       	call   80192f <sys_pf_calculate_allocated_pages>
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
  800102:	e8 88 17 00 00       	call   80188f <sys_calculate_free_frames>
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
  800152:	bb bc 37 80 00       	mov    $0x8037bc,%ebx
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
  8001d7:	68 c0 36 80 00       	push   $0x8036c0
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 21 37 80 00       	push   $0x803721
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
  8001f8:	e8 92 16 00 00       	call   80188f <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 81 16 00 00       	call   80188f <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 38 37 80 00       	push   $0x803738
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 21 37 80 00       	push   $0x803721
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 7c 37 80 00       	push   $0x80377c
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
  800248:	e8 22 19 00 00       	call   801b6f <sys_getenvindex>
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
  8002b3:	e8 c4 16 00 00       	call   80197c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 f0 37 80 00       	push   $0x8037f0
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
  8002e3:	68 18 38 80 00       	push   $0x803818
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
  800314:	68 40 38 80 00       	push   $0x803840
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 50 80 00       	mov    0x805020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 98 38 80 00       	push   $0x803898
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 f0 37 80 00       	push   $0x8037f0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 44 16 00 00       	call   801996 <sys_enable_interrupt>

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
  800365:	e8 d1 17 00 00       	call   801b3b <sys_destroy_env>
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
  800376:	e8 26 18 00 00       	call   801ba1 <sys_exit_env>
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
  80039f:	68 ac 38 80 00       	push   $0x8038ac
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 50 80 00       	mov    0x805000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 b1 38 80 00       	push   $0x8038b1
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
  8003dc:	68 cd 38 80 00       	push   $0x8038cd
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
  800408:	68 d0 38 80 00       	push   $0x8038d0
  80040d:	6a 26                	push   $0x26
  80040f:	68 1c 39 80 00       	push   $0x80391c
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
  8004da:	68 28 39 80 00       	push   $0x803928
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 1c 39 80 00       	push   $0x80391c
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
  80054a:	68 7c 39 80 00       	push   $0x80397c
  80054f:	6a 44                	push   $0x44
  800551:	68 1c 39 80 00       	push   $0x80391c
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
  8005a4:	e8 25 12 00 00       	call   8017ce <sys_cputs>
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
  80061b:	e8 ae 11 00 00       	call   8017ce <sys_cputs>
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
  800665:	e8 12 13 00 00       	call   80197c <sys_disable_interrupt>
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
  800685:	e8 0c 13 00 00       	call   801996 <sys_enable_interrupt>
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
  8006cf:	e8 80 2d 00 00       	call   803454 <__udivdi3>
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
  80071f:	e8 40 2e 00 00       	call   803564 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 f4 3b 80 00       	add    $0x803bf4,%eax
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
  80087a:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
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
  80095b:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 05 3c 80 00       	push   $0x803c05
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
  800980:	68 0e 3c 80 00       	push   $0x803c0e
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
  8009ad:	be 11 3c 80 00       	mov    $0x803c11,%esi
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
  8013d3:	68 70 3d 80 00       	push   $0x803d70
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
  8014a3:	e8 6a 04 00 00       	call   801912 <sys_allocate_chunk>
  8014a8:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ab:	a1 20 51 80 00       	mov    0x805120,%eax
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	50                   	push   %eax
  8014b4:	e8 df 0a 00 00       	call   801f98 <initialize_MemBlocksList>
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
  8014e1:	68 95 3d 80 00       	push   $0x803d95
  8014e6:	6a 33                	push   $0x33
  8014e8:	68 b3 3d 80 00       	push   $0x803db3
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
  801560:	68 c0 3d 80 00       	push   $0x803dc0
  801565:	6a 34                	push   $0x34
  801567:	68 b3 3d 80 00       	push   $0x803db3
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
  8015f8:	e8 e3 06 00 00       	call   801ce0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	74 11                	je     801612 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	ff 75 e8             	pushl  -0x18(%ebp)
  801607:	e8 4e 0d 00 00       	call   80235a <alloc_block_FF>
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
  80161e:	e8 aa 0a 00 00       	call   8020cd <insert_sorted_allocList>
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
  80163e:	68 e4 3d 80 00       	push   $0x803de4
  801643:	6a 6f                	push   $0x6f
  801645:	68 b3 3d 80 00       	push   $0x803db3
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
  801664:	75 07                	jne    80166d <smalloc+0x1e>
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 7c                	jmp    8016e9 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80166d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801674:	8b 55 0c             	mov    0xc(%ebp),%edx
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	01 d0                	add    %edx,%eax
  80167c:	48                   	dec    %eax
  80167d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801680:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801683:	ba 00 00 00 00       	mov    $0x0,%edx
  801688:	f7 75 f0             	divl   -0x10(%ebp)
  80168b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168e:	29 d0                	sub    %edx,%eax
  801690:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801693:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80169a:	e8 41 06 00 00       	call   801ce0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	74 11                	je     8016b4 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8016a3:	83 ec 0c             	sub    $0xc,%esp
  8016a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8016a9:	e8 ac 0c 00 00       	call   80235a <alloc_block_FF>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b8:	74 2a                	je     8016e4 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	8b 40 08             	mov    0x8(%eax),%eax
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016c6:	52                   	push   %edx
  8016c7:	50                   	push   %eax
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 92 03 00 00       	call   801a65 <sys_createSharedObject>
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016d9:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016dd:	74 05                	je     8016e4 <smalloc+0x95>
			return (void*)virtual_address;
  8016df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016e2:	eb 05                	jmp    8016e9 <smalloc+0x9a>
	}
	return NULL;
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    

008016eb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f1:	e8 c6 fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	68 08 3e 80 00       	push   $0x803e08
  8016fe:	68 b0 00 00 00       	push   $0xb0
  801703:	68 b3 3d 80 00       	push   $0x803db3
  801708:	e8 71 ec ff ff       	call   80037e <_panic>

0080170d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801713:	e8 a4 fc ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	68 2c 3e 80 00       	push   $0x803e2c
  801720:	68 f4 00 00 00       	push   $0xf4
  801725:	68 b3 3d 80 00       	push   $0x803db3
  80172a:	e8 4f ec ff ff       	call   80037e <_panic>

0080172f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	68 54 3e 80 00       	push   $0x803e54
  80173d:	68 08 01 00 00       	push   $0x108
  801742:	68 b3 3d 80 00       	push   $0x803db3
  801747:	e8 32 ec ff ff       	call   80037e <_panic>

0080174c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	68 78 3e 80 00       	push   $0x803e78
  80175a:	68 13 01 00 00       	push   $0x113
  80175f:	68 b3 3d 80 00       	push   $0x803db3
  801764:	e8 15 ec ff ff       	call   80037e <_panic>

00801769 <shrink>:

}
void shrink(uint32 newSize)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	68 78 3e 80 00       	push   $0x803e78
  801777:	68 18 01 00 00       	push   $0x118
  80177c:	68 b3 3d 80 00       	push   $0x803db3
  801781:	e8 f8 eb ff ff       	call   80037e <_panic>

00801786 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178c:	83 ec 04             	sub    $0x4,%esp
  80178f:	68 78 3e 80 00       	push   $0x803e78
  801794:	68 1d 01 00 00       	push   $0x11d
  801799:	68 b3 3d 80 00       	push   $0x803db3
  80179e:	e8 db eb ff ff       	call   80037e <_panic>

008017a3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	57                   	push   %edi
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017bb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017be:	cd 30                	int    $0x30
  8017c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	5b                   	pop    %ebx
  8017ca:	5e                   	pop    %esi
  8017cb:	5f                   	pop    %edi
  8017cc:	5d                   	pop    %ebp
  8017cd:	c3                   	ret    

008017ce <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ce:	55                   	push   %ebp
  8017cf:	89 e5                	mov    %esp,%ebp
  8017d1:	83 ec 04             	sub    $0x4,%esp
  8017d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	52                   	push   %edx
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	50                   	push   %eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	e8 b2 ff ff ff       	call   8017a3 <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	90                   	nop
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 01                	push   $0x1
  801806:	e8 98 ff ff ff       	call   8017a3 <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801813:	8b 55 0c             	mov    0xc(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	52                   	push   %edx
  801820:	50                   	push   %eax
  801821:	6a 05                	push   $0x5
  801823:	e8 7b ff ff ff       	call   8017a3 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	56                   	push   %esi
  801831:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801832:	8b 75 18             	mov    0x18(%ebp),%esi
  801835:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801838:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
  801843:	51                   	push   %ecx
  801844:	52                   	push   %edx
  801845:	50                   	push   %eax
  801846:	6a 06                	push   $0x6
  801848:	e8 56 ff ff ff       	call   8017a3 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	52                   	push   %edx
  801867:	50                   	push   %eax
  801868:	6a 07                	push   $0x7
  80186a:	e8 34 ff ff ff       	call   8017a3 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	6a 08                	push   $0x8
  801885:	e8 19 ff ff ff       	call   8017a3 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 09                	push   $0x9
  80189e:	e8 00 ff ff ff       	call   8017a3 <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 0a                	push   $0xa
  8018b7:	e8 e7 fe ff ff       	call   8017a3 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 0b                	push   $0xb
  8018d0:	e8 ce fe ff ff       	call   8017a3 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	6a 0f                	push   $0xf
  8018eb:	e8 b3 fe ff ff       	call   8017a3 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
	return;
  8018f3:	90                   	nop
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	6a 10                	push   $0x10
  801907:	e8 97 fe ff ff       	call   8017a3 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
	return ;
  80190f:	90                   	nop
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	ff 75 10             	pushl  0x10(%ebp)
  80191c:	ff 75 0c             	pushl  0xc(%ebp)
  80191f:	ff 75 08             	pushl  0x8(%ebp)
  801922:	6a 11                	push   $0x11
  801924:	e8 7a fe ff ff       	call   8017a3 <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
	return ;
  80192c:	90                   	nop
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 0c                	push   $0xc
  80193e:	e8 60 fe ff ff       	call   8017a3 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 0d                	push   $0xd
  801958:	e8 46 fe ff ff       	call   8017a3 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 0e                	push   $0xe
  801971:	e8 2d fe ff ff       	call   8017a3 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	90                   	nop
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 13                	push   $0x13
  80198b:	e8 13 fe ff ff       	call   8017a3 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	90                   	nop
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 14                	push   $0x14
  8019a5:	e8 f9 fd ff ff       	call   8017a3 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	90                   	nop
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 04             	sub    $0x4,%esp
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	50                   	push   %eax
  8019c9:	6a 15                	push   $0x15
  8019cb:	e8 d3 fd ff ff       	call   8017a3 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 16                	push   $0x16
  8019e5:	e8 b9 fd ff ff       	call   8017a3 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	6a 17                	push   $0x17
  801a02:	e8 9c fd ff ff       	call   8017a3 <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	52                   	push   %edx
  801a1c:	50                   	push   %eax
  801a1d:	6a 1a                	push   $0x1a
  801a1f:	e8 7f fd ff ff       	call   8017a3 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	52                   	push   %edx
  801a39:	50                   	push   %eax
  801a3a:	6a 18                	push   $0x18
  801a3c:	e8 62 fd ff ff       	call   8017a3 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	6a 19                	push   $0x19
  801a5a:	e8 44 fd ff ff       	call   8017a3 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a71:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a74:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	51                   	push   %ecx
  801a7e:	52                   	push   %edx
  801a7f:	ff 75 0c             	pushl  0xc(%ebp)
  801a82:	50                   	push   %eax
  801a83:	6a 1b                	push   $0x1b
  801a85:	e8 19 fd ff ff       	call   8017a3 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	6a 1c                	push   $0x1c
  801aa2:	e8 fc fc ff ff       	call   8017a3 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	51                   	push   %ecx
  801abd:	52                   	push   %edx
  801abe:	50                   	push   %eax
  801abf:	6a 1d                	push   $0x1d
  801ac1:	e8 dd fc ff ff       	call   8017a3 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	6a 1e                	push   $0x1e
  801ade:	e8 c0 fc ff ff       	call   8017a3 <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 1f                	push   $0x1f
  801af7:	e8 a7 fc ff ff       	call   8017a3 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	ff 75 14             	pushl  0x14(%ebp)
  801b0c:	ff 75 10             	pushl  0x10(%ebp)
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	50                   	push   %eax
  801b13:	6a 20                	push   $0x20
  801b15:	e8 89 fc ff ff       	call   8017a3 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	50                   	push   %eax
  801b2e:	6a 21                	push   $0x21
  801b30:	e8 6e fc ff ff       	call   8017a3 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	50                   	push   %eax
  801b4a:	6a 22                	push   $0x22
  801b4c:	e8 52 fc ff ff       	call   8017a3 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 02                	push   $0x2
  801b65:	e8 39 fc ff ff       	call   8017a3 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 03                	push   $0x3
  801b7e:	e8 20 fc ff ff       	call   8017a3 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 04                	push   $0x4
  801b97:	e8 07 fc ff ff       	call   8017a3 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_exit_env>:


void sys_exit_env(void)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 23                	push   $0x23
  801bb0:	e8 ee fb ff ff       	call   8017a3 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	90                   	nop
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bc1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc4:	8d 50 04             	lea    0x4(%eax),%edx
  801bc7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 24                	push   $0x24
  801bd4:	e8 ca fb ff ff       	call   8017a3 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
	return result;
  801bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be5:	89 01                	mov    %eax,(%ecx)
  801be7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	c9                   	leave  
  801bee:	c2 04 00             	ret    $0x4

00801bf1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	ff 75 10             	pushl  0x10(%ebp)
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	ff 75 08             	pushl  0x8(%ebp)
  801c01:	6a 12                	push   $0x12
  801c03:	e8 9b fb ff ff       	call   8017a3 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0b:	90                   	nop
}
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 25                	push   $0x25
  801c1d:	e8 81 fb ff ff       	call   8017a3 <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 04             	sub    $0x4,%esp
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c33:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	50                   	push   %eax
  801c40:	6a 26                	push   $0x26
  801c42:	e8 5c fb ff ff       	call   8017a3 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4a:	90                   	nop
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <rsttst>:
void rsttst()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 28                	push   $0x28
  801c5c:	e8 42 fb ff ff       	call   8017a3 <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
	return ;
  801c64:	90                   	nop
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c73:	8b 55 18             	mov    0x18(%ebp),%edx
  801c76:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c7a:	52                   	push   %edx
  801c7b:	50                   	push   %eax
  801c7c:	ff 75 10             	pushl  0x10(%ebp)
  801c7f:	ff 75 0c             	pushl  0xc(%ebp)
  801c82:	ff 75 08             	pushl  0x8(%ebp)
  801c85:	6a 27                	push   $0x27
  801c87:	e8 17 fb ff ff       	call   8017a3 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8f:	90                   	nop
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <chktst>:
void chktst(uint32 n)
{
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	ff 75 08             	pushl  0x8(%ebp)
  801ca0:	6a 29                	push   $0x29
  801ca2:	e8 fc fa ff ff       	call   8017a3 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
	return ;
  801caa:	90                   	nop
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <inctst>:

void inctst()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 2a                	push   $0x2a
  801cbc:	e8 e2 fa ff ff       	call   8017a3 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc4:	90                   	nop
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <gettst>:
uint32 gettst()
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 2b                	push   $0x2b
  801cd6:	e8 c8 fa ff ff       	call   8017a3 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 2c                	push   $0x2c
  801cf2:	e8 ac fa ff ff       	call   8017a3 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
  801cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cfd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d01:	75 07                	jne    801d0a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d03:	b8 01 00 00 00       	mov    $0x1,%eax
  801d08:	eb 05                	jmp    801d0f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 2c                	push   $0x2c
  801d23:	e8 7b fa ff ff       	call   8017a3 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
  801d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d2e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d32:	75 07                	jne    801d3b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	eb 05                	jmp    801d40 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2c                	push   $0x2c
  801d54:	e8 4a fa ff ff       	call   8017a3 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
  801d5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d5f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d63:	75 07                	jne    801d6c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	eb 05                	jmp    801d71 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 2c                	push   $0x2c
  801d85:	e8 19 fa ff ff       	call   8017a3 <syscall>
  801d8a:	83 c4 18             	add    $0x18,%esp
  801d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d90:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d94:	75 07                	jne    801d9d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d96:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9b:	eb 05                	jmp    801da2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	6a 2d                	push   $0x2d
  801db4:	e8 ea f9 ff ff       	call   8017a3 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbc:	90                   	nop
}
  801dbd:	c9                   	leave  
  801dbe:	c3                   	ret    

00801dbf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	53                   	push   %ebx
  801dd2:	51                   	push   %ecx
  801dd3:	52                   	push   %edx
  801dd4:	50                   	push   %eax
  801dd5:	6a 2e                	push   $0x2e
  801dd7:	e8 c7 f9 ff ff       	call   8017a3 <syscall>
  801ddc:	83 c4 18             	add    $0x18,%esp
}
  801ddf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801de7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	52                   	push   %edx
  801df4:	50                   	push   %eax
  801df5:	6a 2f                	push   $0x2f
  801df7:	e8 a7 f9 ff ff       	call   8017a3 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e07:	83 ec 0c             	sub    $0xc,%esp
  801e0a:	68 88 3e 80 00       	push   $0x803e88
  801e0f:	e8 1e e8 ff ff       	call   800632 <cprintf>
  801e14:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	68 b4 3e 80 00       	push   $0x803eb4
  801e26:	e8 07 e8 ff ff       	call   800632 <cprintf>
  801e2b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e2e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e32:	a1 38 51 80 00       	mov    0x805138,%eax
  801e37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3a:	eb 56                	jmp    801e92 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e40:	74 1c                	je     801e5e <print_mem_block_lists+0x5d>
  801e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e45:	8b 50 08             	mov    0x8(%eax),%edx
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e51:	8b 40 0c             	mov    0xc(%eax),%eax
  801e54:	01 c8                	add    %ecx,%eax
  801e56:	39 c2                	cmp    %eax,%edx
  801e58:	73 04                	jae    801e5e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e5a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	8b 50 08             	mov    0x8(%eax),%edx
  801e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e67:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6a:	01 c2                	add    %eax,%edx
  801e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6f:	8b 40 08             	mov    0x8(%eax),%eax
  801e72:	83 ec 04             	sub    $0x4,%esp
  801e75:	52                   	push   %edx
  801e76:	50                   	push   %eax
  801e77:	68 c9 3e 80 00       	push   $0x803ec9
  801e7c:	e8 b1 e7 ff ff       	call   800632 <cprintf>
  801e81:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8a:	a1 40 51 80 00       	mov    0x805140,%eax
  801e8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e96:	74 07                	je     801e9f <print_mem_block_lists+0x9e>
  801e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	eb 05                	jmp    801ea4 <print_mem_block_lists+0xa3>
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	a3 40 51 80 00       	mov    %eax,0x805140
  801ea9:	a1 40 51 80 00       	mov    0x805140,%eax
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	75 8a                	jne    801e3c <print_mem_block_lists+0x3b>
  801eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb6:	75 84                	jne    801e3c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eb8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ebc:	75 10                	jne    801ece <print_mem_block_lists+0xcd>
  801ebe:	83 ec 0c             	sub    $0xc,%esp
  801ec1:	68 d8 3e 80 00       	push   $0x803ed8
  801ec6:	e8 67 e7 ff ff       	call   800632 <cprintf>
  801ecb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ece:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ed5:	83 ec 0c             	sub    $0xc,%esp
  801ed8:	68 fc 3e 80 00       	push   $0x803efc
  801edd:	e8 50 e7 ff ff       	call   800632 <cprintf>
  801ee2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ee5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee9:	a1 40 50 80 00       	mov    0x805040,%eax
  801eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef1:	eb 56                	jmp    801f49 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef7:	74 1c                	je     801f15 <print_mem_block_lists+0x114>
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	8b 50 08             	mov    0x8(%eax),%edx
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f02:	8b 48 08             	mov    0x8(%eax),%ecx
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f08:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0b:	01 c8                	add    %ecx,%eax
  801f0d:	39 c2                	cmp    %eax,%edx
  801f0f:	73 04                	jae    801f15 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f11:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 50 08             	mov    0x8(%eax),%edx
  801f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f21:	01 c2                	add    %eax,%edx
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	8b 40 08             	mov    0x8(%eax),%eax
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	52                   	push   %edx
  801f2d:	50                   	push   %eax
  801f2e:	68 c9 3e 80 00       	push   $0x803ec9
  801f33:	e8 fa e6 ff ff       	call   800632 <cprintf>
  801f38:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f41:	a1 48 50 80 00       	mov    0x805048,%eax
  801f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4d:	74 07                	je     801f56 <print_mem_block_lists+0x155>
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	8b 00                	mov    (%eax),%eax
  801f54:	eb 05                	jmp    801f5b <print_mem_block_lists+0x15a>
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5b:	a3 48 50 80 00       	mov    %eax,0x805048
  801f60:	a1 48 50 80 00       	mov    0x805048,%eax
  801f65:	85 c0                	test   %eax,%eax
  801f67:	75 8a                	jne    801ef3 <print_mem_block_lists+0xf2>
  801f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6d:	75 84                	jne    801ef3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f6f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f73:	75 10                	jne    801f85 <print_mem_block_lists+0x184>
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	68 14 3f 80 00       	push   $0x803f14
  801f7d:	e8 b0 e6 ff ff       	call   800632 <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	68 88 3e 80 00       	push   $0x803e88
  801f8d:	e8 a0 e6 ff ff       	call   800632 <cprintf>
  801f92:	83 c4 10             	add    $0x10,%esp

}
  801f95:	90                   	nop
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f9e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fa5:	00 00 00 
  801fa8:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801faf:	00 00 00 
  801fb2:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fb9:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fc3:	e9 9e 00 00 00       	jmp    802066 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fc8:	a1 50 50 80 00       	mov    0x805050,%eax
  801fcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd0:	c1 e2 04             	shl    $0x4,%edx
  801fd3:	01 d0                	add    %edx,%eax
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	75 14                	jne    801fed <initialize_MemBlocksList+0x55>
  801fd9:	83 ec 04             	sub    $0x4,%esp
  801fdc:	68 3c 3f 80 00       	push   $0x803f3c
  801fe1:	6a 46                	push   $0x46
  801fe3:	68 5f 3f 80 00       	push   $0x803f5f
  801fe8:	e8 91 e3 ff ff       	call   80037e <_panic>
  801fed:	a1 50 50 80 00       	mov    0x805050,%eax
  801ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff5:	c1 e2 04             	shl    $0x4,%edx
  801ff8:	01 d0                	add    %edx,%eax
  801ffa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802000:	89 10                	mov    %edx,(%eax)
  802002:	8b 00                	mov    (%eax),%eax
  802004:	85 c0                	test   %eax,%eax
  802006:	74 18                	je     802020 <initialize_MemBlocksList+0x88>
  802008:	a1 48 51 80 00       	mov    0x805148,%eax
  80200d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802013:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802016:	c1 e1 04             	shl    $0x4,%ecx
  802019:	01 ca                	add    %ecx,%edx
  80201b:	89 50 04             	mov    %edx,0x4(%eax)
  80201e:	eb 12                	jmp    802032 <initialize_MemBlocksList+0x9a>
  802020:	a1 50 50 80 00       	mov    0x805050,%eax
  802025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802028:	c1 e2 04             	shl    $0x4,%edx
  80202b:	01 d0                	add    %edx,%eax
  80202d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802032:	a1 50 50 80 00       	mov    0x805050,%eax
  802037:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203a:	c1 e2 04             	shl    $0x4,%edx
  80203d:	01 d0                	add    %edx,%eax
  80203f:	a3 48 51 80 00       	mov    %eax,0x805148
  802044:	a1 50 50 80 00       	mov    0x805050,%eax
  802049:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204c:	c1 e2 04             	shl    $0x4,%edx
  80204f:	01 d0                	add    %edx,%eax
  802051:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802058:	a1 54 51 80 00       	mov    0x805154,%eax
  80205d:	40                   	inc    %eax
  80205e:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802063:	ff 45 f4             	incl   -0xc(%ebp)
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	3b 45 08             	cmp    0x8(%ebp),%eax
  80206c:	0f 82 56 ff ff ff    	jb     801fc8 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802072:	90                   	nop
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	8b 00                	mov    (%eax),%eax
  802080:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802083:	eb 19                	jmp    80209e <find_block+0x29>
	{
		if(va==point->sva)
  802085:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802088:	8b 40 08             	mov    0x8(%eax),%eax
  80208b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80208e:	75 05                	jne    802095 <find_block+0x20>
		   return point;
  802090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802093:	eb 36                	jmp    8020cb <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8b 40 08             	mov    0x8(%eax),%eax
  80209b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80209e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a2:	74 07                	je     8020ab <find_block+0x36>
  8020a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	eb 05                	jmp    8020b0 <find_block+0x3b>
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b3:	89 42 08             	mov    %eax,0x8(%edx)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	75 c5                	jne    802085 <find_block+0x10>
  8020c0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c4:	75 bf                	jne    802085 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020d3:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020db:	a1 44 50 80 00       	mov    0x805044,%eax
  8020e0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020e9:	74 24                	je     80210f <insert_sorted_allocList+0x42>
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 50 08             	mov    0x8(%eax),%edx
  8020f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f4:	8b 40 08             	mov    0x8(%eax),%eax
  8020f7:	39 c2                	cmp    %eax,%edx
  8020f9:	76 14                	jbe    80210f <insert_sorted_allocList+0x42>
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	8b 50 08             	mov    0x8(%eax),%edx
  802101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802104:	8b 40 08             	mov    0x8(%eax),%eax
  802107:	39 c2                	cmp    %eax,%edx
  802109:	0f 82 60 01 00 00    	jb     80226f <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80210f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802113:	75 65                	jne    80217a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802119:	75 14                	jne    80212f <insert_sorted_allocList+0x62>
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	68 3c 3f 80 00       	push   $0x803f3c
  802123:	6a 6b                	push   $0x6b
  802125:	68 5f 3f 80 00       	push   $0x803f5f
  80212a:	e8 4f e2 ff ff       	call   80037e <_panic>
  80212f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	89 10                	mov    %edx,(%eax)
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	8b 00                	mov    (%eax),%eax
  80213f:	85 c0                	test   %eax,%eax
  802141:	74 0d                	je     802150 <insert_sorted_allocList+0x83>
  802143:	a1 40 50 80 00       	mov    0x805040,%eax
  802148:	8b 55 08             	mov    0x8(%ebp),%edx
  80214b:	89 50 04             	mov    %edx,0x4(%eax)
  80214e:	eb 08                	jmp    802158 <insert_sorted_allocList+0x8b>
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	a3 44 50 80 00       	mov    %eax,0x805044
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	a3 40 50 80 00       	mov    %eax,0x805040
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80216f:	40                   	inc    %eax
  802170:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802175:	e9 dc 01 00 00       	jmp    802356 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 50 08             	mov    0x8(%eax),%edx
  802180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802183:	8b 40 08             	mov    0x8(%eax),%eax
  802186:	39 c2                	cmp    %eax,%edx
  802188:	77 6c                	ja     8021f6 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80218a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80218e:	74 06                	je     802196 <insert_sorted_allocList+0xc9>
  802190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802194:	75 14                	jne    8021aa <insert_sorted_allocList+0xdd>
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 78 3f 80 00       	push   $0x803f78
  80219e:	6a 6f                	push   $0x6f
  8021a0:	68 5f 3f 80 00       	push   $0x803f5f
  8021a5:	e8 d4 e1 ff ff       	call   80037e <_panic>
  8021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ad:	8b 50 04             	mov    0x4(%eax),%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	89 50 04             	mov    %edx,0x4(%eax)
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021bc:	89 10                	mov    %edx,(%eax)
  8021be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c1:	8b 40 04             	mov    0x4(%eax),%eax
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	74 0d                	je     8021d5 <insert_sorted_allocList+0x108>
  8021c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cb:	8b 40 04             	mov    0x4(%eax),%eax
  8021ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d1:	89 10                	mov    %edx,(%eax)
  8021d3:	eb 08                	jmp    8021dd <insert_sorted_allocList+0x110>
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	a3 40 50 80 00       	mov    %eax,0x805040
  8021dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e3:	89 50 04             	mov    %edx,0x4(%eax)
  8021e6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021eb:	40                   	inc    %eax
  8021ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f1:	e9 60 01 00 00       	jmp    802356 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 50 08             	mov    0x8(%eax),%edx
  8021fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	0f 82 4c 01 00 00    	jb     802356 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80220a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80220e:	75 14                	jne    802224 <insert_sorted_allocList+0x157>
  802210:	83 ec 04             	sub    $0x4,%esp
  802213:	68 b0 3f 80 00       	push   $0x803fb0
  802218:	6a 73                	push   $0x73
  80221a:	68 5f 3f 80 00       	push   $0x803f5f
  80221f:	e8 5a e1 ff ff       	call   80037e <_panic>
  802224:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	89 50 04             	mov    %edx,0x4(%eax)
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8b 40 04             	mov    0x4(%eax),%eax
  802236:	85 c0                	test   %eax,%eax
  802238:	74 0c                	je     802246 <insert_sorted_allocList+0x179>
  80223a:	a1 44 50 80 00       	mov    0x805044,%eax
  80223f:	8b 55 08             	mov    0x8(%ebp),%edx
  802242:	89 10                	mov    %edx,(%eax)
  802244:	eb 08                	jmp    80224e <insert_sorted_allocList+0x181>
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	a3 40 50 80 00       	mov    %eax,0x805040
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	a3 44 50 80 00       	mov    %eax,0x805044
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80225f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802264:	40                   	inc    %eax
  802265:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80226a:	e9 e7 00 00 00       	jmp    802356 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802275:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80227c:	a1 40 50 80 00       	mov    0x805040,%eax
  802281:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802284:	e9 9d 00 00 00       	jmp    802326 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	8b 00                	mov    (%eax),%eax
  80228e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 50 08             	mov    0x8(%eax),%edx
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 40 08             	mov    0x8(%eax),%eax
  80229d:	39 c2                	cmp    %eax,%edx
  80229f:	76 7d                	jbe    80231e <insert_sorted_allocList+0x251>
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 50 08             	mov    0x8(%eax),%edx
  8022a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022aa:	8b 40 08             	mov    0x8(%eax),%eax
  8022ad:	39 c2                	cmp    %eax,%edx
  8022af:	73 6d                	jae    80231e <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b5:	74 06                	je     8022bd <insert_sorted_allocList+0x1f0>
  8022b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bb:	75 14                	jne    8022d1 <insert_sorted_allocList+0x204>
  8022bd:	83 ec 04             	sub    $0x4,%esp
  8022c0:	68 d4 3f 80 00       	push   $0x803fd4
  8022c5:	6a 7f                	push   $0x7f
  8022c7:	68 5f 3f 80 00       	push   $0x803f5f
  8022cc:	e8 ad e0 ff ff       	call   80037e <_panic>
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 10                	mov    (%eax),%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 0b                	je     8022ef <insert_sorted_allocList+0x222>
  8022e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e7:	8b 00                	mov    (%eax),%eax
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f5:	89 10                	mov    %edx,(%eax)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fd:	89 50 04             	mov    %edx,0x4(%eax)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	75 08                	jne    802311 <insert_sorted_allocList+0x244>
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	a3 44 50 80 00       	mov    %eax,0x805044
  802311:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802316:	40                   	inc    %eax
  802317:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80231c:	eb 39                	jmp    802357 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80231e:	a1 48 50 80 00       	mov    0x805048,%eax
  802323:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802326:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232a:	74 07                	je     802333 <insert_sorted_allocList+0x266>
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 00                	mov    (%eax),%eax
  802331:	eb 05                	jmp    802338 <insert_sorted_allocList+0x26b>
  802333:	b8 00 00 00 00       	mov    $0x0,%eax
  802338:	a3 48 50 80 00       	mov    %eax,0x805048
  80233d:	a1 48 50 80 00       	mov    0x805048,%eax
  802342:	85 c0                	test   %eax,%eax
  802344:	0f 85 3f ff ff ff    	jne    802289 <insert_sorted_allocList+0x1bc>
  80234a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234e:	0f 85 35 ff ff ff    	jne    802289 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802354:	eb 01                	jmp    802357 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802356:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802357:	90                   	nop
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802360:	a1 38 51 80 00       	mov    0x805138,%eax
  802365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802368:	e9 85 01 00 00       	jmp    8024f2 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 40 0c             	mov    0xc(%eax),%eax
  802373:	3b 45 08             	cmp    0x8(%ebp),%eax
  802376:	0f 82 6e 01 00 00    	jb     8024ea <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	8b 40 0c             	mov    0xc(%eax),%eax
  802382:	3b 45 08             	cmp    0x8(%ebp),%eax
  802385:	0f 85 8a 00 00 00    	jne    802415 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80238b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238f:	75 17                	jne    8023a8 <alloc_block_FF+0x4e>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 08 40 80 00       	push   $0x804008
  802399:	68 93 00 00 00       	push   $0x93
  80239e:	68 5f 3f 80 00       	push   $0x803f5f
  8023a3:	e8 d6 df ff ff       	call   80037e <_panic>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 10                	je     8023c1 <alloc_block_FF+0x67>
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b9:	8b 52 04             	mov    0x4(%edx),%edx
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	eb 0b                	jmp    8023cc <alloc_block_FF+0x72>
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 40 04             	mov    0x4(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 0f                	je     8023e5 <alloc_block_FF+0x8b>
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 40 04             	mov    0x4(%eax),%eax
  8023dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023df:	8b 12                	mov    (%edx),%edx
  8023e1:	89 10                	mov    %edx,(%eax)
  8023e3:	eb 0a                	jmp    8023ef <alloc_block_FF+0x95>
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	a3 38 51 80 00       	mov    %eax,0x805138
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802402:	a1 44 51 80 00       	mov    0x805144,%eax
  802407:	48                   	dec    %eax
  802408:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	e9 10 01 00 00       	jmp    802525 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 40 0c             	mov    0xc(%eax),%eax
  80241b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241e:	0f 86 c6 00 00 00    	jbe    8024ea <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802424:	a1 48 51 80 00       	mov    0x805148,%eax
  802429:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 50 08             	mov    0x8(%eax),%edx
  802432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802435:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243b:	8b 55 08             	mov    0x8(%ebp),%edx
  80243e:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802441:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802445:	75 17                	jne    80245e <alloc_block_FF+0x104>
  802447:	83 ec 04             	sub    $0x4,%esp
  80244a:	68 08 40 80 00       	push   $0x804008
  80244f:	68 9b 00 00 00       	push   $0x9b
  802454:	68 5f 3f 80 00       	push   $0x803f5f
  802459:	e8 20 df ff ff       	call   80037e <_panic>
  80245e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	85 c0                	test   %eax,%eax
  802465:	74 10                	je     802477 <alloc_block_FF+0x11d>
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80246f:	8b 52 04             	mov    0x4(%edx),%edx
  802472:	89 50 04             	mov    %edx,0x4(%eax)
  802475:	eb 0b                	jmp    802482 <alloc_block_FF+0x128>
  802477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247a:	8b 40 04             	mov    0x4(%eax),%eax
  80247d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802485:	8b 40 04             	mov    0x4(%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 0f                	je     80249b <alloc_block_FF+0x141>
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	8b 40 04             	mov    0x4(%eax),%eax
  802492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802495:	8b 12                	mov    (%edx),%edx
  802497:	89 10                	mov    %edx,(%eax)
  802499:	eb 0a                	jmp    8024a5 <alloc_block_FF+0x14b>
  80249b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249e:	8b 00                	mov    (%eax),%eax
  8024a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8024a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b8:	a1 54 51 80 00       	mov    0x805154,%eax
  8024bd:	48                   	dec    %eax
  8024be:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 50 08             	mov    0x8(%eax),%edx
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	01 c2                	add    %eax,%edx
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	2b 45 08             	sub    0x8(%ebp),%eax
  8024dd:	89 c2                	mov    %eax,%edx
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	eb 3b                	jmp    802525 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	74 07                	je     8024ff <alloc_block_FF+0x1a5>
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 00                	mov    (%eax),%eax
  8024fd:	eb 05                	jmp    802504 <alloc_block_FF+0x1aa>
  8024ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802504:	a3 40 51 80 00       	mov    %eax,0x805140
  802509:	a1 40 51 80 00       	mov    0x805140,%eax
  80250e:	85 c0                	test   %eax,%eax
  802510:	0f 85 57 fe ff ff    	jne    80236d <alloc_block_FF+0x13>
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	0f 85 4d fe ff ff    	jne    80236d <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802525:	c9                   	leave  
  802526:	c3                   	ret    

00802527 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80252d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802534:	a1 38 51 80 00       	mov    0x805138,%eax
  802539:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253c:	e9 df 00 00 00       	jmp    802620 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 0c             	mov    0xc(%eax),%eax
  802547:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254a:	0f 82 c8 00 00 00    	jb     802618 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 0c             	mov    0xc(%eax),%eax
  802556:	3b 45 08             	cmp    0x8(%ebp),%eax
  802559:	0f 85 8a 00 00 00    	jne    8025e9 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	75 17                	jne    80257c <alloc_block_BF+0x55>
  802565:	83 ec 04             	sub    $0x4,%esp
  802568:	68 08 40 80 00       	push   $0x804008
  80256d:	68 b7 00 00 00       	push   $0xb7
  802572:	68 5f 3f 80 00       	push   $0x803f5f
  802577:	e8 02 de ff ff       	call   80037e <_panic>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	74 10                	je     802595 <alloc_block_BF+0x6e>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 52 04             	mov    0x4(%edx),%edx
  802590:	89 50 04             	mov    %edx,0x4(%eax)
  802593:	eb 0b                	jmp    8025a0 <alloc_block_BF+0x79>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 04             	mov    0x4(%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 0f                	je     8025b9 <alloc_block_BF+0x92>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b3:	8b 12                	mov    (%edx),%edx
  8025b5:	89 10                	mov    %edx,(%eax)
  8025b7:	eb 0a                	jmp    8025c3 <alloc_block_BF+0x9c>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	a3 38 51 80 00       	mov    %eax,0x805138
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d6:	a1 44 51 80 00       	mov    0x805144,%eax
  8025db:	48                   	dec    %eax
  8025dc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	e9 4d 01 00 00       	jmp    802736 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f2:	76 24                	jbe    802618 <alloc_block_BF+0xf1>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fd:	73 19                	jae    802618 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025ff:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 0c             	mov    0xc(%eax),%eax
  80260c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 08             	mov    0x8(%eax),%eax
  802615:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802618:	a1 40 51 80 00       	mov    0x805140,%eax
  80261d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	74 07                	je     80262d <alloc_block_BF+0x106>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	eb 05                	jmp    802632 <alloc_block_BF+0x10b>
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	a3 40 51 80 00       	mov    %eax,0x805140
  802637:	a1 40 51 80 00       	mov    0x805140,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	0f 85 fd fe ff ff    	jne    802541 <alloc_block_BF+0x1a>
  802644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802648:	0f 85 f3 fe ff ff    	jne    802541 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80264e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802652:	0f 84 d9 00 00 00    	je     802731 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802658:	a1 48 51 80 00       	mov    0x805148,%eax
  80265d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802663:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802666:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266c:	8b 55 08             	mov    0x8(%ebp),%edx
  80266f:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802672:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802676:	75 17                	jne    80268f <alloc_block_BF+0x168>
  802678:	83 ec 04             	sub    $0x4,%esp
  80267b:	68 08 40 80 00       	push   $0x804008
  802680:	68 c7 00 00 00       	push   $0xc7
  802685:	68 5f 3f 80 00       	push   $0x803f5f
  80268a:	e8 ef dc ff ff       	call   80037e <_panic>
  80268f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	74 10                	je     8026a8 <alloc_block_BF+0x181>
  802698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026a0:	8b 52 04             	mov    0x4(%edx),%edx
  8026a3:	89 50 04             	mov    %edx,0x4(%eax)
  8026a6:	eb 0b                	jmp    8026b3 <alloc_block_BF+0x18c>
  8026a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 0f                	je     8026cc <alloc_block_BF+0x1a5>
  8026bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c0:	8b 40 04             	mov    0x4(%eax),%eax
  8026c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c6:	8b 12                	mov    (%edx),%edx
  8026c8:	89 10                	mov    %edx,(%eax)
  8026ca:	eb 0a                	jmp    8026d6 <alloc_block_BF+0x1af>
  8026cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	a3 48 51 80 00       	mov    %eax,0x805148
  8026d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8026ee:	48                   	dec    %eax
  8026ef:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026f4:	83 ec 08             	sub    $0x8,%esp
  8026f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8026fa:	68 38 51 80 00       	push   $0x805138
  8026ff:	e8 71 f9 ff ff       	call   802075 <find_block>
  802704:	83 c4 10             	add    $0x10,%esp
  802707:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80270a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270d:	8b 50 08             	mov    0x8(%eax),%edx
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	01 c2                	add    %eax,%edx
  802715:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802718:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80271b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271e:	8b 40 0c             	mov    0xc(%eax),%eax
  802721:	2b 45 08             	sub    0x8(%ebp),%eax
  802724:	89 c2                	mov    %eax,%edx
  802726:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802729:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80272c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272f:	eb 05                	jmp    802736 <alloc_block_BF+0x20f>
	}
	return NULL;
  802731:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
  80273b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80273e:	a1 28 50 80 00       	mov    0x805028,%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	0f 85 de 01 00 00    	jne    802929 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80274b:	a1 38 51 80 00       	mov    0x805138,%eax
  802750:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802753:	e9 9e 01 00 00       	jmp    8028f6 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275b:	8b 40 0c             	mov    0xc(%eax),%eax
  80275e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802761:	0f 82 87 01 00 00    	jb     8028ee <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802770:	0f 85 95 00 00 00    	jne    80280b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277a:	75 17                	jne    802793 <alloc_block_NF+0x5b>
  80277c:	83 ec 04             	sub    $0x4,%esp
  80277f:	68 08 40 80 00       	push   $0x804008
  802784:	68 e0 00 00 00       	push   $0xe0
  802789:	68 5f 3f 80 00       	push   $0x803f5f
  80278e:	e8 eb db ff ff       	call   80037e <_panic>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 10                	je     8027ac <alloc_block_NF+0x74>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a4:	8b 52 04             	mov    0x4(%edx),%edx
  8027a7:	89 50 04             	mov    %edx,0x4(%eax)
  8027aa:	eb 0b                	jmp    8027b7 <alloc_block_NF+0x7f>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 40 04             	mov    0x4(%eax),%eax
  8027b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 0f                	je     8027d0 <alloc_block_NF+0x98>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 04             	mov    0x4(%eax),%eax
  8027c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ca:	8b 12                	mov    (%edx),%edx
  8027cc:	89 10                	mov    %edx,(%eax)
  8027ce:	eb 0a                	jmp    8027da <alloc_block_NF+0xa2>
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8027f2:	48                   	dec    %eax
  8027f3:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 08             	mov    0x8(%eax),%eax
  8027fe:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	e9 f8 04 00 00       	jmp    802d03 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 40 0c             	mov    0xc(%eax),%eax
  802811:	3b 45 08             	cmp    0x8(%ebp),%eax
  802814:	0f 86 d4 00 00 00    	jbe    8028ee <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80281a:	a1 48 51 80 00       	mov    0x805148,%eax
  80281f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 50 08             	mov    0x8(%eax),%edx
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 55 08             	mov    0x8(%ebp),%edx
  802834:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802837:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80283b:	75 17                	jne    802854 <alloc_block_NF+0x11c>
  80283d:	83 ec 04             	sub    $0x4,%esp
  802840:	68 08 40 80 00       	push   $0x804008
  802845:	68 e9 00 00 00       	push   $0xe9
  80284a:	68 5f 3f 80 00       	push   $0x803f5f
  80284f:	e8 2a db ff ff       	call   80037e <_panic>
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	85 c0                	test   %eax,%eax
  80285b:	74 10                	je     80286d <alloc_block_NF+0x135>
  80285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802865:	8b 52 04             	mov    0x4(%edx),%edx
  802868:	89 50 04             	mov    %edx,0x4(%eax)
  80286b:	eb 0b                	jmp    802878 <alloc_block_NF+0x140>
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 0f                	je     802891 <alloc_block_NF+0x159>
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 40 04             	mov    0x4(%eax),%eax
  802888:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288b:	8b 12                	mov    (%edx),%edx
  80288d:	89 10                	mov    %edx,(%eax)
  80288f:	eb 0a                	jmp    80289b <alloc_block_NF+0x163>
  802891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	a3 48 51 80 00       	mov    %eax,0x805148
  80289b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b3:	48                   	dec    %eax
  8028b4:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bc:	8b 40 08             	mov    0x8(%eax),%eax
  8028bf:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	01 c2                	add    %eax,%edx
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	2b 45 08             	sub    0x8(%ebp),%eax
  8028de:	89 c2                	mov    %eax,%edx
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	e9 15 04 00 00       	jmp    802d03 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fa:	74 07                	je     802903 <alloc_block_NF+0x1cb>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	eb 05                	jmp    802908 <alloc_block_NF+0x1d0>
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	a3 40 51 80 00       	mov    %eax,0x805140
  80290d:	a1 40 51 80 00       	mov    0x805140,%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	0f 85 3e fe ff ff    	jne    802758 <alloc_block_NF+0x20>
  80291a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291e:	0f 85 34 fe ff ff    	jne    802758 <alloc_block_NF+0x20>
  802924:	e9 d5 03 00 00       	jmp    802cfe <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802929:	a1 38 51 80 00       	mov    0x805138,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	e9 b1 01 00 00       	jmp    802ae7 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802939:	8b 50 08             	mov    0x8(%eax),%edx
  80293c:	a1 28 50 80 00       	mov    0x805028,%eax
  802941:	39 c2                	cmp    %eax,%edx
  802943:	0f 82 96 01 00 00    	jb     802adf <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 0c             	mov    0xc(%eax),%eax
  80294f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802952:	0f 82 87 01 00 00    	jb     802adf <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 0c             	mov    0xc(%eax),%eax
  80295e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802961:	0f 85 95 00 00 00    	jne    8029fc <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80296b:	75 17                	jne    802984 <alloc_block_NF+0x24c>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 08 40 80 00       	push   $0x804008
  802975:	68 fc 00 00 00       	push   $0xfc
  80297a:	68 5f 3f 80 00       	push   $0x803f5f
  80297f:	e8 fa d9 ff ff       	call   80037e <_panic>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	74 10                	je     80299d <alloc_block_NF+0x265>
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	8b 00                	mov    (%eax),%eax
  802992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802995:	8b 52 04             	mov    0x4(%edx),%edx
  802998:	89 50 04             	mov    %edx,0x4(%eax)
  80299b:	eb 0b                	jmp    8029a8 <alloc_block_NF+0x270>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 04             	mov    0x4(%eax),%eax
  8029a3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 0f                	je     8029c1 <alloc_block_NF+0x289>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 40 04             	mov    0x4(%eax),%eax
  8029b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bb:	8b 12                	mov    (%edx),%edx
  8029bd:	89 10                	mov    %edx,(%eax)
  8029bf:	eb 0a                	jmp    8029cb <alloc_block_NF+0x293>
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	a3 38 51 80 00       	mov    %eax,0x805138
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029de:	a1 44 51 80 00       	mov    0x805144,%eax
  8029e3:	48                   	dec    %eax
  8029e4:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 08             	mov    0x8(%eax),%eax
  8029ef:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	e9 07 03 00 00       	jmp    802d03 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802a02:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a05:	0f 86 d4 00 00 00    	jbe    802adf <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 50 08             	mov    0x8(%eax),%edx
  802a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a28:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a2c:	75 17                	jne    802a45 <alloc_block_NF+0x30d>
  802a2e:	83 ec 04             	sub    $0x4,%esp
  802a31:	68 08 40 80 00       	push   $0x804008
  802a36:	68 04 01 00 00       	push   $0x104
  802a3b:	68 5f 3f 80 00       	push   $0x803f5f
  802a40:	e8 39 d9 ff ff       	call   80037e <_panic>
  802a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	74 10                	je     802a5e <alloc_block_NF+0x326>
  802a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a56:	8b 52 04             	mov    0x4(%edx),%edx
  802a59:	89 50 04             	mov    %edx,0x4(%eax)
  802a5c:	eb 0b                	jmp    802a69 <alloc_block_NF+0x331>
  802a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a61:	8b 40 04             	mov    0x4(%eax),%eax
  802a64:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6c:	8b 40 04             	mov    0x4(%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 0f                	je     802a82 <alloc_block_NF+0x34a>
  802a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a7c:	8b 12                	mov    (%edx),%edx
  802a7e:	89 10                	mov    %edx,(%eax)
  802a80:	eb 0a                	jmp    802a8c <alloc_block_NF+0x354>
  802a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	a3 48 51 80 00       	mov    %eax,0x805148
  802a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9f:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa4:	48                   	dec    %eax
  802aa5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aad:	8b 40 08             	mov    0x8(%eax),%eax
  802ab0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	8b 50 08             	mov    0x8(%eax),%edx
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	01 c2                	add    %eax,%edx
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  802acc:	2b 45 08             	sub    0x8(%ebp),%eax
  802acf:	89 c2                	mov    %eax,%edx
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ada:	e9 24 02 00 00       	jmp    802d03 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802adf:	a1 40 51 80 00       	mov    0x805140,%eax
  802ae4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aeb:	74 07                	je     802af4 <alloc_block_NF+0x3bc>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	eb 05                	jmp    802af9 <alloc_block_NF+0x3c1>
  802af4:	b8 00 00 00 00       	mov    $0x0,%eax
  802af9:	a3 40 51 80 00       	mov    %eax,0x805140
  802afe:	a1 40 51 80 00       	mov    0x805140,%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	0f 85 2b fe ff ff    	jne    802936 <alloc_block_NF+0x1fe>
  802b0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0f:	0f 85 21 fe ff ff    	jne    802936 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b15:	a1 38 51 80 00       	mov    0x805138,%eax
  802b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1d:	e9 ae 01 00 00       	jmp    802cd0 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 50 08             	mov    0x8(%eax),%edx
  802b28:	a1 28 50 80 00       	mov    0x805028,%eax
  802b2d:	39 c2                	cmp    %eax,%edx
  802b2f:	0f 83 93 01 00 00    	jae    802cc8 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3e:	0f 82 84 01 00 00    	jb     802cc8 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4d:	0f 85 95 00 00 00    	jne    802be8 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	75 17                	jne    802b70 <alloc_block_NF+0x438>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 08 40 80 00       	push   $0x804008
  802b61:	68 14 01 00 00       	push   $0x114
  802b66:	68 5f 3f 80 00       	push   $0x803f5f
  802b6b:	e8 0e d8 ff ff       	call   80037e <_panic>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 10                	je     802b89 <alloc_block_NF+0x451>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b81:	8b 52 04             	mov    0x4(%edx),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 0b                	jmp    802b94 <alloc_block_NF+0x45c>
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 0f                	je     802bad <alloc_block_NF+0x475>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba7:	8b 12                	mov    (%edx),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	eb 0a                	jmp    802bb7 <alloc_block_NF+0x47f>
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bca:	a1 44 51 80 00       	mov    0x805144,%eax
  802bcf:	48                   	dec    %eax
  802bd0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 40 08             	mov    0x8(%eax),%eax
  802bdb:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	e9 1b 01 00 00       	jmp    802d03 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf1:	0f 86 d1 00 00 00    	jbe    802cc8 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bf7:	a1 48 51 80 00       	mov    0x805148,%eax
  802bfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 50 08             	mov    0x8(%eax),%edx
  802c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c08:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c18:	75 17                	jne    802c31 <alloc_block_NF+0x4f9>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 08 40 80 00       	push   $0x804008
  802c22:	68 1c 01 00 00       	push   $0x11c
  802c27:	68 5f 3f 80 00       	push   $0x803f5f
  802c2c:	e8 4d d7 ff ff       	call   80037e <_panic>
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	85 c0                	test   %eax,%eax
  802c38:	74 10                	je     802c4a <alloc_block_NF+0x512>
  802c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c42:	8b 52 04             	mov    0x4(%edx),%edx
  802c45:	89 50 04             	mov    %edx,0x4(%eax)
  802c48:	eb 0b                	jmp    802c55 <alloc_block_NF+0x51d>
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	8b 40 04             	mov    0x4(%eax),%eax
  802c50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c58:	8b 40 04             	mov    0x4(%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 0f                	je     802c6e <alloc_block_NF+0x536>
  802c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c62:	8b 40 04             	mov    0x4(%eax),%eax
  802c65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c68:	8b 12                	mov    (%edx),%edx
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	eb 0a                	jmp    802c78 <alloc_block_NF+0x540>
  802c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	a3 48 51 80 00       	mov    %eax,0x805148
  802c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c90:	48                   	dec    %eax
  802c91:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c99:	8b 40 08             	mov    0x8(%eax),%eax
  802c9c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 50 08             	mov    0x8(%eax),%edx
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	01 c2                	add    %eax,%edx
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb8:	2b 45 08             	sub    0x8(%ebp),%eax
  802cbb:	89 c2                	mov    %eax,%edx
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc6:	eb 3b                	jmp    802d03 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cc8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd4:	74 07                	je     802cdd <alloc_block_NF+0x5a5>
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	eb 05                	jmp    802ce2 <alloc_block_NF+0x5aa>
  802cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce7:	a1 40 51 80 00       	mov    0x805140,%eax
  802cec:	85 c0                	test   %eax,%eax
  802cee:	0f 85 2e fe ff ff    	jne    802b22 <alloc_block_NF+0x3ea>
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	0f 85 24 fe ff ff    	jne    802b22 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d03:	c9                   	leave  
  802d04:	c3                   	ret    

00802d05 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
  802d08:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d0b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d13:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d18:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d20:	85 c0                	test   %eax,%eax
  802d22:	74 14                	je     802d38 <insert_sorted_with_merge_freeList+0x33>
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 50 08             	mov    0x8(%eax),%edx
  802d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2d:	8b 40 08             	mov    0x8(%eax),%eax
  802d30:	39 c2                	cmp    %eax,%edx
  802d32:	0f 87 9b 01 00 00    	ja     802ed3 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d3c:	75 17                	jne    802d55 <insert_sorted_with_merge_freeList+0x50>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 3c 3f 80 00       	push   $0x803f3c
  802d46:	68 38 01 00 00       	push   $0x138
  802d4b:	68 5f 3f 80 00       	push   $0x803f5f
  802d50:	e8 29 d6 ff ff       	call   80037e <_panic>
  802d55:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	89 10                	mov    %edx,(%eax)
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 00                	mov    (%eax),%eax
  802d65:	85 c0                	test   %eax,%eax
  802d67:	74 0d                	je     802d76 <insert_sorted_with_merge_freeList+0x71>
  802d69:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 08                	jmp    802d7e <insert_sorted_with_merge_freeList+0x79>
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d81:	a3 38 51 80 00       	mov    %eax,0x805138
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d90:	a1 44 51 80 00       	mov    0x805144,%eax
  802d95:	40                   	inc    %eax
  802d96:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d9b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9f:	0f 84 a8 06 00 00    	je     80344d <insert_sorted_with_merge_freeList+0x748>
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	8b 50 08             	mov    0x8(%eax),%edx
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 40 0c             	mov    0xc(%eax),%eax
  802db1:	01 c2                	add    %eax,%edx
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	8b 40 08             	mov    0x8(%eax),%eax
  802db9:	39 c2                	cmp    %eax,%edx
  802dbb:	0f 85 8c 06 00 00    	jne    80344d <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	01 c2                	add    %eax,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd9:	75 17                	jne    802df2 <insert_sorted_with_merge_freeList+0xed>
  802ddb:	83 ec 04             	sub    $0x4,%esp
  802dde:	68 08 40 80 00       	push   $0x804008
  802de3:	68 3c 01 00 00       	push   $0x13c
  802de8:	68 5f 3f 80 00       	push   $0x803f5f
  802ded:	e8 8c d5 ff ff       	call   80037e <_panic>
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	85 c0                	test   %eax,%eax
  802df9:	74 10                	je     802e0b <insert_sorted_with_merge_freeList+0x106>
  802dfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfe:	8b 00                	mov    (%eax),%eax
  802e00:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e03:	8b 52 04             	mov    0x4(%edx),%edx
  802e06:	89 50 04             	mov    %edx,0x4(%eax)
  802e09:	eb 0b                	jmp    802e16 <insert_sorted_with_merge_freeList+0x111>
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	8b 40 04             	mov    0x4(%eax),%eax
  802e11:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 0f                	je     802e2f <insert_sorted_with_merge_freeList+0x12a>
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e29:	8b 12                	mov    (%edx),%edx
  802e2b:	89 10                	mov    %edx,(%eax)
  802e2d:	eb 0a                	jmp    802e39 <insert_sorted_with_merge_freeList+0x134>
  802e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	a3 38 51 80 00       	mov    %eax,0x805138
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e51:	48                   	dec    %eax
  802e52:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e6f:	75 17                	jne    802e88 <insert_sorted_with_merge_freeList+0x183>
  802e71:	83 ec 04             	sub    $0x4,%esp
  802e74:	68 3c 3f 80 00       	push   $0x803f3c
  802e79:	68 3f 01 00 00       	push   $0x13f
  802e7e:	68 5f 3f 80 00       	push   $0x803f5f
  802e83:	e8 f6 d4 ff ff       	call   80037e <_panic>
  802e88:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e91:	89 10                	mov    %edx,(%eax)
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 0d                	je     802ea9 <insert_sorted_with_merge_freeList+0x1a4>
  802e9c:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea4:	89 50 04             	mov    %edx,0x4(%eax)
  802ea7:	eb 08                	jmp    802eb1 <insert_sorted_with_merge_freeList+0x1ac>
  802ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec8:	40                   	inc    %eax
  802ec9:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ece:	e9 7a 05 00 00       	jmp    80344d <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edc:	8b 40 08             	mov    0x8(%eax),%eax
  802edf:	39 c2                	cmp    %eax,%edx
  802ee1:	0f 82 14 01 00 00    	jb     802ffb <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eea:	8b 50 08             	mov    0x8(%eax),%edx
  802eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef3:	01 c2                	add    %eax,%edx
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 40 08             	mov    0x8(%eax),%eax
  802efb:	39 c2                	cmp    %eax,%edx
  802efd:	0f 85 90 00 00 00    	jne    802f93 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f06:	8b 50 0c             	mov    0xc(%eax),%edx
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0f:	01 c2                	add    %eax,%edx
  802f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f14:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f21:	8b 45 08             	mov    0x8(%ebp),%eax
  802f24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2f:	75 17                	jne    802f48 <insert_sorted_with_merge_freeList+0x243>
  802f31:	83 ec 04             	sub    $0x4,%esp
  802f34:	68 3c 3f 80 00       	push   $0x803f3c
  802f39:	68 49 01 00 00       	push   $0x149
  802f3e:	68 5f 3f 80 00       	push   $0x803f5f
  802f43:	e8 36 d4 ff ff       	call   80037e <_panic>
  802f48:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	89 10                	mov    %edx,(%eax)
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	85 c0                	test   %eax,%eax
  802f5a:	74 0d                	je     802f69 <insert_sorted_with_merge_freeList+0x264>
  802f5c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f61:	8b 55 08             	mov    0x8(%ebp),%edx
  802f64:	89 50 04             	mov    %edx,0x4(%eax)
  802f67:	eb 08                	jmp    802f71 <insert_sorted_with_merge_freeList+0x26c>
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	a3 48 51 80 00       	mov    %eax,0x805148
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f83:	a1 54 51 80 00       	mov    0x805154,%eax
  802f88:	40                   	inc    %eax
  802f89:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f8e:	e9 bb 04 00 00       	jmp    80344e <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f97:	75 17                	jne    802fb0 <insert_sorted_with_merge_freeList+0x2ab>
  802f99:	83 ec 04             	sub    $0x4,%esp
  802f9c:	68 b0 3f 80 00       	push   $0x803fb0
  802fa1:	68 4c 01 00 00       	push   $0x14c
  802fa6:	68 5f 3f 80 00       	push   $0x803f5f
  802fab:	e8 ce d3 ff ff       	call   80037e <_panic>
  802fb0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	89 50 04             	mov    %edx,0x4(%eax)
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 04             	mov    0x4(%eax),%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	74 0c                	je     802fd2 <insert_sorted_with_merge_freeList+0x2cd>
  802fc6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fce:	89 10                	mov    %edx,(%eax)
  802fd0:	eb 08                	jmp    802fda <insert_sorted_with_merge_freeList+0x2d5>
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	a3 38 51 80 00       	mov    %eax,0x805138
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802feb:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff0:	40                   	inc    %eax
  802ff1:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ff6:	e9 53 04 00 00       	jmp    80344e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ffb:	a1 38 51 80 00       	mov    0x805138,%eax
  803000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803003:	e9 15 04 00 00       	jmp    80341d <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803019:	8b 40 08             	mov    0x8(%eax),%eax
  80301c:	39 c2                	cmp    %eax,%edx
  80301e:	0f 86 f1 03 00 00    	jbe    803415 <insert_sorted_with_merge_freeList+0x710>
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	8b 50 08             	mov    0x8(%eax),%edx
  80302a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302d:	8b 40 08             	mov    0x8(%eax),%eax
  803030:	39 c2                	cmp    %eax,%edx
  803032:	0f 83 dd 03 00 00    	jae    803415 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 50 08             	mov    0x8(%eax),%edx
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 40 0c             	mov    0xc(%eax),%eax
  803044:	01 c2                	add    %eax,%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 40 08             	mov    0x8(%eax),%eax
  80304c:	39 c2                	cmp    %eax,%edx
  80304e:	0f 85 b9 01 00 00    	jne    80320d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	8b 50 08             	mov    0x8(%eax),%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	8b 40 0c             	mov    0xc(%eax),%eax
  803060:	01 c2                	add    %eax,%edx
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	0f 85 0d 01 00 00    	jne    80317d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 50 0c             	mov    0xc(%eax),%edx
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	01 c2                	add    %eax,%edx
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803084:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803088:	75 17                	jne    8030a1 <insert_sorted_with_merge_freeList+0x39c>
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	68 08 40 80 00       	push   $0x804008
  803092:	68 5c 01 00 00       	push   $0x15c
  803097:	68 5f 3f 80 00       	push   $0x803f5f
  80309c:	e8 dd d2 ff ff       	call   80037e <_panic>
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	85 c0                	test   %eax,%eax
  8030a8:	74 10                	je     8030ba <insert_sorted_with_merge_freeList+0x3b5>
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030b2:	8b 52 04             	mov    0x4(%edx),%edx
  8030b5:	89 50 04             	mov    %edx,0x4(%eax)
  8030b8:	eb 0b                	jmp    8030c5 <insert_sorted_with_merge_freeList+0x3c0>
  8030ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bd:	8b 40 04             	mov    0x4(%eax),%eax
  8030c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 0f                	je     8030de <insert_sorted_with_merge_freeList+0x3d9>
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 40 04             	mov    0x4(%eax),%eax
  8030d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d8:	8b 12                	mov    (%edx),%edx
  8030da:	89 10                	mov    %edx,(%eax)
  8030dc:	eb 0a                	jmp    8030e8 <insert_sorted_with_merge_freeList+0x3e3>
  8030de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fb:	a1 44 51 80 00       	mov    0x805144,%eax
  803100:	48                   	dec    %eax
  803101:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80311a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80311e:	75 17                	jne    803137 <insert_sorted_with_merge_freeList+0x432>
  803120:	83 ec 04             	sub    $0x4,%esp
  803123:	68 3c 3f 80 00       	push   $0x803f3c
  803128:	68 5f 01 00 00       	push   $0x15f
  80312d:	68 5f 3f 80 00       	push   $0x803f5f
  803132:	e8 47 d2 ff ff       	call   80037e <_panic>
  803137:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80313d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803140:	89 10                	mov    %edx,(%eax)
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	85 c0                	test   %eax,%eax
  803149:	74 0d                	je     803158 <insert_sorted_with_merge_freeList+0x453>
  80314b:	a1 48 51 80 00       	mov    0x805148,%eax
  803150:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803153:	89 50 04             	mov    %edx,0x4(%eax)
  803156:	eb 08                	jmp    803160 <insert_sorted_with_merge_freeList+0x45b>
  803158:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	a3 48 51 80 00       	mov    %eax,0x805148
  803168:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803172:	a1 54 51 80 00       	mov    0x805154,%eax
  803177:	40                   	inc    %eax
  803178:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 50 0c             	mov    0xc(%eax),%edx
  803183:	8b 45 08             	mov    0x8(%ebp),%eax
  803186:	8b 40 0c             	mov    0xc(%eax),%eax
  803189:	01 c2                	add    %eax,%edx
  80318b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a9:	75 17                	jne    8031c2 <insert_sorted_with_merge_freeList+0x4bd>
  8031ab:	83 ec 04             	sub    $0x4,%esp
  8031ae:	68 3c 3f 80 00       	push   $0x803f3c
  8031b3:	68 64 01 00 00       	push   $0x164
  8031b8:	68 5f 3f 80 00       	push   $0x803f5f
  8031bd:	e8 bc d1 ff ff       	call   80037e <_panic>
  8031c2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	89 10                	mov    %edx,(%eax)
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	8b 00                	mov    (%eax),%eax
  8031d2:	85 c0                	test   %eax,%eax
  8031d4:	74 0d                	je     8031e3 <insert_sorted_with_merge_freeList+0x4de>
  8031d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8031db:	8b 55 08             	mov    0x8(%ebp),%edx
  8031de:	89 50 04             	mov    %edx,0x4(%eax)
  8031e1:	eb 08                	jmp    8031eb <insert_sorted_with_merge_freeList+0x4e6>
  8031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	a3 48 51 80 00       	mov    %eax,0x805148
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fd:	a1 54 51 80 00       	mov    0x805154,%eax
  803202:	40                   	inc    %eax
  803203:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803208:	e9 41 02 00 00       	jmp    80344e <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	8b 50 08             	mov    0x8(%eax),%edx
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	8b 40 0c             	mov    0xc(%eax),%eax
  803219:	01 c2                	add    %eax,%edx
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	8b 40 08             	mov    0x8(%eax),%eax
  803221:	39 c2                	cmp    %eax,%edx
  803223:	0f 85 7c 01 00 00    	jne    8033a5 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803229:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80322d:	74 06                	je     803235 <insert_sorted_with_merge_freeList+0x530>
  80322f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803233:	75 17                	jne    80324c <insert_sorted_with_merge_freeList+0x547>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 78 3f 80 00       	push   $0x803f78
  80323d:	68 69 01 00 00       	push   $0x169
  803242:	68 5f 3f 80 00       	push   $0x803f5f
  803247:	e8 32 d1 ff ff       	call   80037e <_panic>
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 50 04             	mov    0x4(%eax),%edx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	89 50 04             	mov    %edx,0x4(%eax)
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325e:	89 10                	mov    %edx,(%eax)
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	8b 40 04             	mov    0x4(%eax),%eax
  803266:	85 c0                	test   %eax,%eax
  803268:	74 0d                	je     803277 <insert_sorted_with_merge_freeList+0x572>
  80326a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326d:	8b 40 04             	mov    0x4(%eax),%eax
  803270:	8b 55 08             	mov    0x8(%ebp),%edx
  803273:	89 10                	mov    %edx,(%eax)
  803275:	eb 08                	jmp    80327f <insert_sorted_with_merge_freeList+0x57a>
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	a3 38 51 80 00       	mov    %eax,0x805138
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	8b 55 08             	mov    0x8(%ebp),%edx
  803285:	89 50 04             	mov    %edx,0x4(%eax)
  803288:	a1 44 51 80 00       	mov    0x805144,%eax
  80328d:	40                   	inc    %eax
  80328e:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	8b 50 0c             	mov    0xc(%eax),%edx
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	8b 40 0c             	mov    0xc(%eax),%eax
  80329f:	01 c2                	add    %eax,%edx
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ab:	75 17                	jne    8032c4 <insert_sorted_with_merge_freeList+0x5bf>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 08 40 80 00       	push   $0x804008
  8032b5:	68 6b 01 00 00       	push   $0x16b
  8032ba:	68 5f 3f 80 00       	push   $0x803f5f
  8032bf:	e8 ba d0 ff ff       	call   80037e <_panic>
  8032c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 10                	je     8032dd <insert_sorted_with_merge_freeList+0x5d8>
  8032cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d0:	8b 00                	mov    (%eax),%eax
  8032d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032d5:	8b 52 04             	mov    0x4(%edx),%edx
  8032d8:	89 50 04             	mov    %edx,0x4(%eax)
  8032db:	eb 0b                	jmp    8032e8 <insert_sorted_with_merge_freeList+0x5e3>
  8032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e0:	8b 40 04             	mov    0x4(%eax),%eax
  8032e3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 0f                	je     803301 <insert_sorted_with_merge_freeList+0x5fc>
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	8b 40 04             	mov    0x4(%eax),%eax
  8032f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fb:	8b 12                	mov    (%edx),%edx
  8032fd:	89 10                	mov    %edx,(%eax)
  8032ff:	eb 0a                	jmp    80330b <insert_sorted_with_merge_freeList+0x606>
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	a3 38 51 80 00       	mov    %eax,0x805138
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803314:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331e:	a1 44 51 80 00       	mov    0x805144,%eax
  803323:	48                   	dec    %eax
  803324:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80333d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803341:	75 17                	jne    80335a <insert_sorted_with_merge_freeList+0x655>
  803343:	83 ec 04             	sub    $0x4,%esp
  803346:	68 3c 3f 80 00       	push   $0x803f3c
  80334b:	68 6e 01 00 00       	push   $0x16e
  803350:	68 5f 3f 80 00       	push   $0x803f5f
  803355:	e8 24 d0 ff ff       	call   80037e <_panic>
  80335a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803360:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803363:	89 10                	mov    %edx,(%eax)
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	8b 00                	mov    (%eax),%eax
  80336a:	85 c0                	test   %eax,%eax
  80336c:	74 0d                	je     80337b <insert_sorted_with_merge_freeList+0x676>
  80336e:	a1 48 51 80 00       	mov    0x805148,%eax
  803373:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803376:	89 50 04             	mov    %edx,0x4(%eax)
  803379:	eb 08                	jmp    803383 <insert_sorted_with_merge_freeList+0x67e>
  80337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803383:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803386:	a3 48 51 80 00       	mov    %eax,0x805148
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803395:	a1 54 51 80 00       	mov    0x805154,%eax
  80339a:	40                   	inc    %eax
  80339b:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033a0:	e9 a9 00 00 00       	jmp    80344e <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a9:	74 06                	je     8033b1 <insert_sorted_with_merge_freeList+0x6ac>
  8033ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033af:	75 17                	jne    8033c8 <insert_sorted_with_merge_freeList+0x6c3>
  8033b1:	83 ec 04             	sub    $0x4,%esp
  8033b4:	68 d4 3f 80 00       	push   $0x803fd4
  8033b9:	68 73 01 00 00       	push   $0x173
  8033be:	68 5f 3f 80 00       	push   $0x803f5f
  8033c3:	e8 b6 cf ff ff       	call   80037e <_panic>
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	8b 10                	mov    (%eax),%edx
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	89 10                	mov    %edx,(%eax)
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	8b 00                	mov    (%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 0b                	je     8033e6 <insert_sorted_with_merge_freeList+0x6e1>
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e3:	89 50 04             	mov    %edx,0x4(%eax)
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ec:	89 10                	mov    %edx,(%eax)
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%eax)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	75 08                	jne    803408 <insert_sorted_with_merge_freeList+0x703>
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803408:	a1 44 51 80 00       	mov    0x805144,%eax
  80340d:	40                   	inc    %eax
  80340e:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803413:	eb 39                	jmp    80344e <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803415:	a1 40 51 80 00       	mov    0x805140,%eax
  80341a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803421:	74 07                	je     80342a <insert_sorted_with_merge_freeList+0x725>
  803423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803426:	8b 00                	mov    (%eax),%eax
  803428:	eb 05                	jmp    80342f <insert_sorted_with_merge_freeList+0x72a>
  80342a:	b8 00 00 00 00       	mov    $0x0,%eax
  80342f:	a3 40 51 80 00       	mov    %eax,0x805140
  803434:	a1 40 51 80 00       	mov    0x805140,%eax
  803439:	85 c0                	test   %eax,%eax
  80343b:	0f 85 c7 fb ff ff    	jne    803008 <insert_sorted_with_merge_freeList+0x303>
  803441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803445:	0f 85 bd fb ff ff    	jne    803008 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80344b:	eb 01                	jmp    80344e <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80344d:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80344e:	90                   	nop
  80344f:	c9                   	leave  
  803450:	c3                   	ret    
  803451:	66 90                	xchg   %ax,%ax
  803453:	90                   	nop

00803454 <__udivdi3>:
  803454:	55                   	push   %ebp
  803455:	57                   	push   %edi
  803456:	56                   	push   %esi
  803457:	53                   	push   %ebx
  803458:	83 ec 1c             	sub    $0x1c,%esp
  80345b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80345f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803467:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80346b:	89 ca                	mov    %ecx,%edx
  80346d:	89 f8                	mov    %edi,%eax
  80346f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803473:	85 f6                	test   %esi,%esi
  803475:	75 2d                	jne    8034a4 <__udivdi3+0x50>
  803477:	39 cf                	cmp    %ecx,%edi
  803479:	77 65                	ja     8034e0 <__udivdi3+0x8c>
  80347b:	89 fd                	mov    %edi,%ebp
  80347d:	85 ff                	test   %edi,%edi
  80347f:	75 0b                	jne    80348c <__udivdi3+0x38>
  803481:	b8 01 00 00 00       	mov    $0x1,%eax
  803486:	31 d2                	xor    %edx,%edx
  803488:	f7 f7                	div    %edi
  80348a:	89 c5                	mov    %eax,%ebp
  80348c:	31 d2                	xor    %edx,%edx
  80348e:	89 c8                	mov    %ecx,%eax
  803490:	f7 f5                	div    %ebp
  803492:	89 c1                	mov    %eax,%ecx
  803494:	89 d8                	mov    %ebx,%eax
  803496:	f7 f5                	div    %ebp
  803498:	89 cf                	mov    %ecx,%edi
  80349a:	89 fa                	mov    %edi,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	39 ce                	cmp    %ecx,%esi
  8034a6:	77 28                	ja     8034d0 <__udivdi3+0x7c>
  8034a8:	0f bd fe             	bsr    %esi,%edi
  8034ab:	83 f7 1f             	xor    $0x1f,%edi
  8034ae:	75 40                	jne    8034f0 <__udivdi3+0x9c>
  8034b0:	39 ce                	cmp    %ecx,%esi
  8034b2:	72 0a                	jb     8034be <__udivdi3+0x6a>
  8034b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034b8:	0f 87 9e 00 00 00    	ja     80355c <__udivdi3+0x108>
  8034be:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c3:	89 fa                	mov    %edi,%edx
  8034c5:	83 c4 1c             	add    $0x1c,%esp
  8034c8:	5b                   	pop    %ebx
  8034c9:	5e                   	pop    %esi
  8034ca:	5f                   	pop    %edi
  8034cb:	5d                   	pop    %ebp
  8034cc:	c3                   	ret    
  8034cd:	8d 76 00             	lea    0x0(%esi),%esi
  8034d0:	31 ff                	xor    %edi,%edi
  8034d2:	31 c0                	xor    %eax,%eax
  8034d4:	89 fa                	mov    %edi,%edx
  8034d6:	83 c4 1c             	add    $0x1c,%esp
  8034d9:	5b                   	pop    %ebx
  8034da:	5e                   	pop    %esi
  8034db:	5f                   	pop    %edi
  8034dc:	5d                   	pop    %ebp
  8034dd:	c3                   	ret    
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	89 d8                	mov    %ebx,%eax
  8034e2:	f7 f7                	div    %edi
  8034e4:	31 ff                	xor    %edi,%edi
  8034e6:	89 fa                	mov    %edi,%edx
  8034e8:	83 c4 1c             	add    $0x1c,%esp
  8034eb:	5b                   	pop    %ebx
  8034ec:	5e                   	pop    %esi
  8034ed:	5f                   	pop    %edi
  8034ee:	5d                   	pop    %ebp
  8034ef:	c3                   	ret    
  8034f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034f5:	89 eb                	mov    %ebp,%ebx
  8034f7:	29 fb                	sub    %edi,%ebx
  8034f9:	89 f9                	mov    %edi,%ecx
  8034fb:	d3 e6                	shl    %cl,%esi
  8034fd:	89 c5                	mov    %eax,%ebp
  8034ff:	88 d9                	mov    %bl,%cl
  803501:	d3 ed                	shr    %cl,%ebp
  803503:	89 e9                	mov    %ebp,%ecx
  803505:	09 f1                	or     %esi,%ecx
  803507:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80350b:	89 f9                	mov    %edi,%ecx
  80350d:	d3 e0                	shl    %cl,%eax
  80350f:	89 c5                	mov    %eax,%ebp
  803511:	89 d6                	mov    %edx,%esi
  803513:	88 d9                	mov    %bl,%cl
  803515:	d3 ee                	shr    %cl,%esi
  803517:	89 f9                	mov    %edi,%ecx
  803519:	d3 e2                	shl    %cl,%edx
  80351b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80351f:	88 d9                	mov    %bl,%cl
  803521:	d3 e8                	shr    %cl,%eax
  803523:	09 c2                	or     %eax,%edx
  803525:	89 d0                	mov    %edx,%eax
  803527:	89 f2                	mov    %esi,%edx
  803529:	f7 74 24 0c          	divl   0xc(%esp)
  80352d:	89 d6                	mov    %edx,%esi
  80352f:	89 c3                	mov    %eax,%ebx
  803531:	f7 e5                	mul    %ebp
  803533:	39 d6                	cmp    %edx,%esi
  803535:	72 19                	jb     803550 <__udivdi3+0xfc>
  803537:	74 0b                	je     803544 <__udivdi3+0xf0>
  803539:	89 d8                	mov    %ebx,%eax
  80353b:	31 ff                	xor    %edi,%edi
  80353d:	e9 58 ff ff ff       	jmp    80349a <__udivdi3+0x46>
  803542:	66 90                	xchg   %ax,%ax
  803544:	8b 54 24 08          	mov    0x8(%esp),%edx
  803548:	89 f9                	mov    %edi,%ecx
  80354a:	d3 e2                	shl    %cl,%edx
  80354c:	39 c2                	cmp    %eax,%edx
  80354e:	73 e9                	jae    803539 <__udivdi3+0xe5>
  803550:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803553:	31 ff                	xor    %edi,%edi
  803555:	e9 40 ff ff ff       	jmp    80349a <__udivdi3+0x46>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	31 c0                	xor    %eax,%eax
  80355e:	e9 37 ff ff ff       	jmp    80349a <__udivdi3+0x46>
  803563:	90                   	nop

00803564 <__umoddi3>:
  803564:	55                   	push   %ebp
  803565:	57                   	push   %edi
  803566:	56                   	push   %esi
  803567:	53                   	push   %ebx
  803568:	83 ec 1c             	sub    $0x1c,%esp
  80356b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80356f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803573:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803577:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80357b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80357f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803583:	89 f3                	mov    %esi,%ebx
  803585:	89 fa                	mov    %edi,%edx
  803587:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80358b:	89 34 24             	mov    %esi,(%esp)
  80358e:	85 c0                	test   %eax,%eax
  803590:	75 1a                	jne    8035ac <__umoddi3+0x48>
  803592:	39 f7                	cmp    %esi,%edi
  803594:	0f 86 a2 00 00 00    	jbe    80363c <__umoddi3+0xd8>
  80359a:	89 c8                	mov    %ecx,%eax
  80359c:	89 f2                	mov    %esi,%edx
  80359e:	f7 f7                	div    %edi
  8035a0:	89 d0                	mov    %edx,%eax
  8035a2:	31 d2                	xor    %edx,%edx
  8035a4:	83 c4 1c             	add    $0x1c,%esp
  8035a7:	5b                   	pop    %ebx
  8035a8:	5e                   	pop    %esi
  8035a9:	5f                   	pop    %edi
  8035aa:	5d                   	pop    %ebp
  8035ab:	c3                   	ret    
  8035ac:	39 f0                	cmp    %esi,%eax
  8035ae:	0f 87 ac 00 00 00    	ja     803660 <__umoddi3+0xfc>
  8035b4:	0f bd e8             	bsr    %eax,%ebp
  8035b7:	83 f5 1f             	xor    $0x1f,%ebp
  8035ba:	0f 84 ac 00 00 00    	je     80366c <__umoddi3+0x108>
  8035c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8035c5:	29 ef                	sub    %ebp,%edi
  8035c7:	89 fe                	mov    %edi,%esi
  8035c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035cd:	89 e9                	mov    %ebp,%ecx
  8035cf:	d3 e0                	shl    %cl,%eax
  8035d1:	89 d7                	mov    %edx,%edi
  8035d3:	89 f1                	mov    %esi,%ecx
  8035d5:	d3 ef                	shr    %cl,%edi
  8035d7:	09 c7                	or     %eax,%edi
  8035d9:	89 e9                	mov    %ebp,%ecx
  8035db:	d3 e2                	shl    %cl,%edx
  8035dd:	89 14 24             	mov    %edx,(%esp)
  8035e0:	89 d8                	mov    %ebx,%eax
  8035e2:	d3 e0                	shl    %cl,%eax
  8035e4:	89 c2                	mov    %eax,%edx
  8035e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ea:	d3 e0                	shl    %cl,%eax
  8035ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035f4:	89 f1                	mov    %esi,%ecx
  8035f6:	d3 e8                	shr    %cl,%eax
  8035f8:	09 d0                	or     %edx,%eax
  8035fa:	d3 eb                	shr    %cl,%ebx
  8035fc:	89 da                	mov    %ebx,%edx
  8035fe:	f7 f7                	div    %edi
  803600:	89 d3                	mov    %edx,%ebx
  803602:	f7 24 24             	mull   (%esp)
  803605:	89 c6                	mov    %eax,%esi
  803607:	89 d1                	mov    %edx,%ecx
  803609:	39 d3                	cmp    %edx,%ebx
  80360b:	0f 82 87 00 00 00    	jb     803698 <__umoddi3+0x134>
  803611:	0f 84 91 00 00 00    	je     8036a8 <__umoddi3+0x144>
  803617:	8b 54 24 04          	mov    0x4(%esp),%edx
  80361b:	29 f2                	sub    %esi,%edx
  80361d:	19 cb                	sbb    %ecx,%ebx
  80361f:	89 d8                	mov    %ebx,%eax
  803621:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803625:	d3 e0                	shl    %cl,%eax
  803627:	89 e9                	mov    %ebp,%ecx
  803629:	d3 ea                	shr    %cl,%edx
  80362b:	09 d0                	or     %edx,%eax
  80362d:	89 e9                	mov    %ebp,%ecx
  80362f:	d3 eb                	shr    %cl,%ebx
  803631:	89 da                	mov    %ebx,%edx
  803633:	83 c4 1c             	add    $0x1c,%esp
  803636:	5b                   	pop    %ebx
  803637:	5e                   	pop    %esi
  803638:	5f                   	pop    %edi
  803639:	5d                   	pop    %ebp
  80363a:	c3                   	ret    
  80363b:	90                   	nop
  80363c:	89 fd                	mov    %edi,%ebp
  80363e:	85 ff                	test   %edi,%edi
  803640:	75 0b                	jne    80364d <__umoddi3+0xe9>
  803642:	b8 01 00 00 00       	mov    $0x1,%eax
  803647:	31 d2                	xor    %edx,%edx
  803649:	f7 f7                	div    %edi
  80364b:	89 c5                	mov    %eax,%ebp
  80364d:	89 f0                	mov    %esi,%eax
  80364f:	31 d2                	xor    %edx,%edx
  803651:	f7 f5                	div    %ebp
  803653:	89 c8                	mov    %ecx,%eax
  803655:	f7 f5                	div    %ebp
  803657:	89 d0                	mov    %edx,%eax
  803659:	e9 44 ff ff ff       	jmp    8035a2 <__umoddi3+0x3e>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	89 c8                	mov    %ecx,%eax
  803662:	89 f2                	mov    %esi,%edx
  803664:	83 c4 1c             	add    $0x1c,%esp
  803667:	5b                   	pop    %ebx
  803668:	5e                   	pop    %esi
  803669:	5f                   	pop    %edi
  80366a:	5d                   	pop    %ebp
  80366b:	c3                   	ret    
  80366c:	3b 04 24             	cmp    (%esp),%eax
  80366f:	72 06                	jb     803677 <__umoddi3+0x113>
  803671:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803675:	77 0f                	ja     803686 <__umoddi3+0x122>
  803677:	89 f2                	mov    %esi,%edx
  803679:	29 f9                	sub    %edi,%ecx
  80367b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80367f:	89 14 24             	mov    %edx,(%esp)
  803682:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803686:	8b 44 24 04          	mov    0x4(%esp),%eax
  80368a:	8b 14 24             	mov    (%esp),%edx
  80368d:	83 c4 1c             	add    $0x1c,%esp
  803690:	5b                   	pop    %ebx
  803691:	5e                   	pop    %esi
  803692:	5f                   	pop    %edi
  803693:	5d                   	pop    %ebp
  803694:	c3                   	ret    
  803695:	8d 76 00             	lea    0x0(%esi),%esi
  803698:	2b 04 24             	sub    (%esp),%eax
  80369b:	19 fa                	sbb    %edi,%edx
  80369d:	89 d1                	mov    %edx,%ecx
  80369f:	89 c6                	mov    %eax,%esi
  8036a1:	e9 71 ff ff ff       	jmp    803617 <__umoddi3+0xb3>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036ac:	72 ea                	jb     803698 <__umoddi3+0x134>
  8036ae:	89 d9                	mov    %ebx,%ecx
  8036b0:	e9 62 ff ff ff       	jmp    803617 <__umoddi3+0xb3>
